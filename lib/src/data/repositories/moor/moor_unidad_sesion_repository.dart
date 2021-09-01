import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_utils.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/sesion_evento.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/unidad_evento.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_sesion_repository.dart';
import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/app_tools.dart';
import 'database/app_database.dart';

class MoorUnidadSesionRepository extends UnidadSesionRepository{
  @override
  Future<void> saveUnidadSesion(Map<String, dynamic> unidadSesion, int usuarioId, int calendarioTipoId, int silaboEventoId, int rolId) async{
    AppDataBase SQL = AppDataBase();
    try{
      await SQL.batch((batch) async {
        // functions in a batch don't have to be awaited - just
        // await the whole batch afterwards.

        var query = SQL.select(SQL.unidadEvento).join([
          innerJoin(SQL.relUnidadEvento, SQL.unidadEvento.unidadAprendizajeId.equalsExp(SQL.relUnidadEvento.unidadaprendizajeId)),
        ]);
        query.where(SQL.unidadEvento.silaboEventoId.equals(silaboEventoId));
        query.where(SQL.relUnidadEvento.tipoid.equals(calendarioTipoId));

        List<int> unidadEventoIdList = [];
        for(var row in await query.get()){
          UnidadEventoData unidadEvento = row.readTable(SQL.unidadEvento);
          unidadEventoIdList.add(unidadEvento.unidadAprendizajeId);
        }

        (SQL.delete(SQL.relUnidadEvento)..where((tbl) => tbl.unidadaprendizajeId.isIn(unidadEventoIdList) )).go();
        (SQL.delete(SQL.unidadEvento)..where((tbl) => tbl.unidadAprendizajeId.isIn(unidadEventoIdList) )).go();
        var queryDeleteSesion = SQL.delete(SQL.sesionEvento)..where((tbl) => tbl.unidadAprendizajeId.isIn(unidadEventoIdList));
        queryDeleteSesion.where((tbl) => tbl.rolId.equals(rolId));
        queryDeleteSesion.go();

        if(unidadSesion.containsKey("unidadAprendizaje")){
          batch.insertAll(SQL.unidadEvento, SerializableConvert.converListSerializeUnidadEvento(unidadSesion["unidadAprendizaje"])  , mode: InsertMode.insertOrReplace );
        }

        if(unidadSesion.containsKey("relUnidadAprenEvento_tipo")){
          batch.insertAll(SQL.relUnidadEvento, SerializableConvert.converListSerializeRelUnidadEvento(unidadSesion["relUnidadAprenEvento_tipo"])  , mode: InsertMode.insertOrReplace );
        }

        if(unidadSesion.containsKey("sesion")){
          batch.insertAll(SQL.sesionEvento, SerializableConvert.converListSerializeSesionEvento(unidadSesion["sesion"])  , mode: InsertMode.insertOrReplace );
        }

      });

    }catch(e){
      print("unidadUIList moor save error");
      throw Exception(e);
    }


  }

  @override
  Future<List<UnidadUi>> getUnidadSesion(int usuarioId, int calendarioTipoId, int silaboEventoId, int rolId) async{
    print("unidadUIList moor 1");
    AppDataBase SQL = AppDataBase();
    var query = SQL.select(SQL.unidadEvento).join([
      innerJoin(SQL.relUnidadEvento, SQL.unidadEvento.unidadAprendizajeId.equalsExp(SQL.relUnidadEvento.unidadaprendizajeId)),
      leftOuterJoin(SQL.sesionEvento, SQL.sesionEvento.unidadAprendizajeId.equalsExp(SQL.unidadEvento.unidadAprendizajeId)),
    ]);
    query.where(SQL.unidadEvento.silaboEventoId.equals(silaboEventoId));
    query.where(SQL.relUnidadEvento.tipoid.equals(calendarioTipoId));
    query.orderBy([OrderingTerm(expression: SQL.unidadEvento.nroUnidad, mode: OrderingMode.desc),OrderingTerm(expression: SQL.sesionEvento.fechaEjecucion, mode: OrderingMode.desc) ]);

    List<UnidadUi> unidadEventoUiList = [];
    for(var row in await query.get()){
      print("unidadUIList moor 1.2");
      UnidadEventoData unidadEvento = row.readTable(SQL.unidadEvento);
      SesionEventoData? sesionEvento = row.readTableOrNull(SQL.sesionEvento);

      UnidadUi? unidadUi = unidadEventoUiList.firstWhereOrNull((element) => unidadEvento.unidadAprendizajeId == element.unidadAprendizajeId);
      if(unidadUi == null){
        unidadUi = new UnidadUi();
        unidadUi.unidadAprendizajeId = unidadEvento.unidadAprendizajeId;
        unidadUi.titulo = unidadEvento.titulo;
        unidadUi.nroUnidad = unidadEvento.nroUnidad;
        unidadUi.sesionUiList = [];
        unidadEventoUiList.add(unidadUi);
      }

      if(sesionEvento!=null){
        SesionUi sesionUi = SesionUi();
        sesionUi.sesionAprendizajeId = sesionEvento.sesionAprendizajeId;
        sesionUi.titulo = sesionEvento.titulo;
        sesionUi.tituloUnidad = unidadUi.titulo;
        sesionUi.nroUnidad = unidadUi.nroUnidad;
        sesionUi.nroSesion = sesionEvento.nroSesion;
        sesionUi.proposito = sesionEvento.proposito;
        sesionUi.horas = (sesionEvento.horas??0).toString() + " min" ;
        sesionUi.fechaEjecucion = AppTools.f_fecha_letras(DateTime.fromMillisecondsSinceEpoch(sesionEvento.fechaEjecucion??0));
        sesionUi.fechaEjecucionFin = (sesionEvento.fechaEjecucionFin??0) > 943938000000? AppTools.f_fecha_letras(DateTime.fromMillisecondsSinceEpoch(sesionEvento.fechaEjecucionFin??0)):null;
        sesionUi.sesionAprendizajePadreId = sesionEvento.parentSesionId;
        sesionUi.estadoEjecucionId = sesionEvento.estadoEjecucionId;
        if(sesionEvento.rolId == rolId)unidadUi.sesionUiList?.add(sesionUi);
      }

    }
    print("unidadUIList moor");
    return unidadEventoUiList;

  }

}