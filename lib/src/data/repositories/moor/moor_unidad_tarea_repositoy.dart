import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tarea/tarea_unidad.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

import 'database/app_database.dart';

class MoorUnidadTareaRepository extends UnidadTareaRepository{

  @override
  Future<List<UnidadUi>> getUnidadTarea(int calendarioPeriodoId, int silaboEventoId) async{
    AppDataBase SQL = AppDataBase();



    var queryUnidad = SQL.select(SQL.tareaUnidad)..where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    queryUnidad.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
    queryUnidad.orderBy([
          (u) =>
              OrderingTerm(expression: u.nroUnidad, mode: OrderingMode.desc),
    ]);

    var queryTarea = SQL.select(SQL.tarea)..where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    queryTarea.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
    queryTarea.orderBy([
          (u) =>
          OrderingTerm(expression: u.fechaCreacion, mode: OrderingMode.desc),
    ]);
    List<UnidadUi> unidadUiList = [];
    for(TareaUnidadData tareaUnidadData in await queryUnidad.get()){
      UnidadUi unidadUi = UnidadUi();
      unidadUi.unidadAprendizajeId = tareaUnidadData.unidadAprendizajeId;
      unidadUi.titulo = tareaUnidadData.titulo;
      unidadUi.nroUnidad = tareaUnidadData.nroUnidad;
      unidadUi.silaboEventoId = tareaUnidadData.silaboEventoId;

      unidadUiList.add(unidadUi);
    }
    List<TareaUi> tareaUiList = [];
    for(TareaData tareaData in await queryTarea.get()){
      TareaUi tareaUi = TareaUi();
      tareaUi.tareaId = tareaData.tareaId;
      tareaUi.titulo = tareaData.titulo;
      tareaUi.instrucciones = tareaData.instrucciones;
      tareaUi.rubroEvalProcesoId = tareaData.rubroEvalProcesoId;
      tareaUi.unidadAprendizajeId = tareaData.unidadAprendizajeId;
      tareaUiList.add(tareaUi);
    }


    for(UnidadUi unidadUi in unidadUiList){
      List<TareaUi> tareaUiUnidadList = [];
      for(TareaUi tareaUi in tareaUiList){
        if(tareaUi.unidadAprendizajeId == unidadUi.unidadAprendizajeId){
          tareaUiUnidadList.add(tareaUi);
        }
      }
      unidadUi.tareaUiList = tareaUiUnidadList;
    }

    return unidadUiList;
  }

  @override
  Future<void> saveUnidadTarea(Map<String, dynamic> unidadSesion, int calendarioPeriodoId, int silaboEventoId) async {
    AppDataBase SQL = AppDataBase();
    await SQL.batch((batch) async {
      // functions in a batch don't have to be awaited - just
      // await the whole batch afterwards.

      var query = SQL.delete(SQL.tareaUnidad)..where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
      query.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
      query.go();

      var queryTarea = SQL.delete(SQL.tarea)..where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
      queryTarea.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
      queryTarea.go();

      if(unidadSesion.containsKey("tarea")){
        print("unidadAprendizaje tarea");
        batch.insertAll(SQL.tarea, SerializableConvert.converListSerializeTarea(unidadSesion["tarea"])  , mode: InsertMode.insertOrReplace );
      }

      print("unidadAprendizaje 1");
      if(unidadSesion.containsKey("unidadAprendizaje")){
        print("unidadAprendizaje 2");
        batch.insertAll(SQL.tareaUnidad, SerializableConvert.converListSerializeTareaUnidad(unidadSesion["unidadAprendizaje"])  , mode: InsertMode.insertOrReplace );
      }



    });

  }

}