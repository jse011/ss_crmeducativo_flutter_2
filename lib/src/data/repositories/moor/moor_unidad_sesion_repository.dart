import 'package:flutter/cupertino.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_utils.dart';
import 'package:ss_crmeducativo_2/src/data/helpers/serelizable/rest_api_response.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/campotematico_sesion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/competencia_sesion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/desempenio_icd_sesion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/sesion_evento.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/unidad_evento.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/desempenio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/icd_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_hoy_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_sesion_repository.dart';
import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
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
        if(rolId>0) queryDeleteSesion.where((tbl) => tbl.rolId.equals(rolId));

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
    query.orderBy([
      OrderingTerm(expression: SQL.unidadEvento.nroUnidad, mode: OrderingMode.desc),
      OrderingTerm(expression: SQL.sesionEvento.fechaEjecucion, mode: OrderingMode.desc),
      OrderingTerm(expression: SQL.sesionEvento.rolId, mode: OrderingMode.desc)
    ]);

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
        sesionUi.fechaEjecucion = DomainTools.f_fecha_letras(DateTime.fromMillisecondsSinceEpoch(sesionEvento.fechaEjecucion??0));
        sesionUi.fechaEjecucionFin = (sesionEvento.fechaEjecucionFin??0) > 943938000000? DomainTools.f_fecha_letras(DateTime.fromMillisecondsSinceEpoch(sesionEvento.fechaEjecucionFin??0)):null;
        sesionUi.sesionAprendizajePadreId = sesionEvento.parentSesionId;
        sesionUi.estadoEjecucionId = sesionEvento.estadoEjecucionId;
        sesionUi.unidadAprendizajeId = unidadUi.unidadAprendizajeId;
        sesionUi.rolId = sesionEvento.rolId;
        if(sesionEvento.rolId == 6){
          unidadUi.sesionUiList?.add(sesionUi);
        }else if(sesionEvento.rolId == 4){

          SesionUi? sesionAlumnoUi = unidadUi.sesionUiList?.firstWhereOrNull((element) => element.sesionAprendizajePadreId == sesionUi.sesionAprendizajeId);
          print("sesionAlumnoUi ${sesionAlumnoUi?.sesionAprendizajePadreId}");
          if(sesionAlumnoUi==null)unidadUi.sesionUiList?.add(sesionUi);
        }else{
          unidadUi.sesionUiList?.add(sesionUi);
        }
      }

    }
    print("unidadUIList moor");
    return unidadEventoUiList;

  }

  @override
  List<SesionHoyUi> transformarSesionHoy(List<dynamic> sesionHoyListData) {

   List<SesionHoyUi> sesionHoyUiDocenteList = [];
   List<SesionHoyUi> sesionHoyUiAlumnoList = [];

   for(dynamic sesionHoySerial in sesionHoyListData){
     BESesionHoyDocenteSerial serial = BESesionHoyDocenteSerial.fromJson(sesionHoySerial);
     SesionHoyUi sesionHoyUi = SesionHoyUi();
     SesionUi sesionUi = SesionUi();
     sesionUi.sesionAprendizajeId = serial.sesionAprendizajeId;
     sesionUi.tituloUnidad = serial.tituloUnidad;
     sesionUi.nroUnidad = serial.nroUnidad;
     sesionUi.titulo = serial.titulo;
     sesionUi.proposito = serial.proposito;
     sesionUi.sesionAprendizajePadreId = serial.parentSesionId;
     sesionUi.horas =  (serial.horas??0).toString() + " min" ;
     sesionUi.fechaEjecucion =  (serial.horas??0).toString() + " min" ;
     sesionUi.fechaEjecucion = DomainTools.f_fecha_letras(DateTime.fromMillisecondsSinceEpoch(serial.fechaEjecucion??0));
     sesionUi.fechaEjecucionFin = (serial.fechaEjecucionFin??0) > 943938000000? DomainTools.f_fecha_letras(DateTime.fromMillisecondsSinceEpoch(serial.fechaEjecucionFin??0)):null;
     sesionUi.nroSesion = serial.nroSesion;
     sesionUi.rolId = serial.rolId;
     sesionHoyUi.sesionUi = sesionUi;

     UnidadUi unidadUi = UnidadUi();
     unidadUi.unidadAprendizajeId = serial.unidadAprendizajeId;
     unidadUi.silaboEventoId = serial.silaboEventoId;
     unidadUi.titulo =  serial.titulo;
     unidadUi.nroUnidad = serial.nroUnidad;
     sesionHoyUi.unidadUi = unidadUi;
     CursosUi cursosUi = CursosUi();
     cursosUi.cargaCursoId = serial.cargaCursoId;
     cursosUi.nombreCurso = serial.cursoNombre;
     cursosUi.gradoSeccion = (serial.periodoNombre??"") + " - " + (serial.grupoNombre??"");
     cursosUi.color1 = serial.color1;
     cursosUi.color2 = serial.color2;
     cursosUi.color3 = serial.color3;
     cursosUi.banner = serial.path;
     cursosUi.silaboEventoId = serial.silaboEventoId;
     sesionHoyUi.cursosUi = cursosUi;
     CalendarioPeriodoUI calendarioPeriodoUI = CalendarioPeriodoUI();
     calendarioPeriodoUI.id = serial.calendarioPeriodoId;
     calendarioPeriodoUI.tipoId = serial.calendarioPerTipoId;
     sesionHoyUi.calendarioPeriodoUI = calendarioPeriodoUI;
     if(serial.rolId == 4){
       sesionHoyUiDocenteList.add(sesionHoyUi);
     }else{
       sesionHoyUiAlumnoList.add(sesionHoyUi);
     }
   }

   for(SesionHoyUi sesionHoyAlumnoUi in sesionHoyUiAlumnoList){
     sesionHoyUiDocenteList.removeWhere((x)=> x.sesionUi?.sesionAprendizajeId == sesionHoyAlumnoUi.sesionUi?.sesionAprendizajePadreId);
   }

   sesionHoyUiAlumnoList.addAll(sesionHoyUiDocenteList);

   return sesionHoyUiAlumnoList;
  }

  @override
  Future<void> saveAprendizajeSesion(int? sesionAprendizajeId, Map<String, dynamic> unidadAprendizaje) async{
    AppDataBase SQL = AppDataBase();

    await SQL.batch((batch) async {
      // functions in a batch don't have to be awaited - just
      // await the whole batch afterwards.


      (SQL.delete(SQL.competenciaSesion)..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId) )).go();
      (SQL.delete(SQL.desempenioIcdSesion)..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId) )).go();
      (SQL.delete(SQL.campotematicoSesion)..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId) )).go();


      if(unidadAprendizaje.containsKey("competencias")){
        List<CompetenciaSesionData> list = [];
        unidadAprendizaje['competencias'].forEach((v) {
          list.add(CompetenciaSesionData.fromJson(v));
        });
        batch.insertAll(SQL.competenciaSesion,list, mode: InsertMode.insertOrReplace );
      }

      if(unidadAprendizaje.containsKey("desempenioIcds")){
        List<DesempenioIcdSesionData> list = [];
        unidadAprendizaje['desempenioIcds'].forEach((v) {
          list.add(DesempenioIcdSesionData.fromJson(v));
        });
        batch.insertAll(SQL.desempenioIcdSesion,list, mode: InsertMode.insertOrReplace );
      }

      if(unidadAprendizaje.containsKey("campotematicos")){
        List<CampotematicoSesionData> list = [];
        unidadAprendizaje['campotematicos'].forEach((v) {
          list.add(CampotematicoSesionData.fromJson(v));
        });
        batch.insertAll(SQL.campotematicoSesion,list, mode: InsertMode.insertOrReplace );
      }

    });


  }

  @override
  Future<List<CompetenciaUi>> getAprendizajeSesion(int? sesionAprendizajeId) async{
    AppDataBase SQL = AppDataBase();
    List<CompetenciaUi> competenciaUiList = [];
    List<CompetenciaSesionData> competenciaSesionList = await (SQL.select(SQL.competenciaSesion)..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId))).get();
    for(CompetenciaSesionData competenciaSesionData in competenciaSesionList){
      CompetenciaUi? competenciaUi = competenciaUiList.firstWhereOrNull((element) => element.competenciaId == competenciaSesionData.competenciaId);
      if(competenciaUi==null){
        competenciaUi = CompetenciaUi();
        competenciaUi.competenciaId = competenciaSesionData.competenciaId;
        competenciaUi.nombre = competenciaSesionData.competencia;
        competenciaUi.tipoCompetencia = competenciaSesionData.tipoCompetencia;
        competenciaUi.capacidadUiList = [];
        competenciaUiList.add(competenciaUi);
      }

      CapacidadUi capacidadUi = CapacidadUi();
      capacidadUi.capacidadId = competenciaSesionData.capacidadId;
      capacidadUi.nombre = competenciaSesionData.capacidad;
      capacidadUi.tipoCapacidad = competenciaSesionData.tipoCapacidad;
      competenciaUi.capacidadUiList?.add(capacidadUi);

    }

    List<DesempenioIcdSesionData> desempenioIcdSesionList = await (SQL.select(SQL.desempenioIcdSesion)..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId))).get();
    List<DesempenioUi> desempenioUiList = [];
    for(DesempenioIcdSesionData desempenioIcdSesionData in desempenioIcdSesionList){
      DesempenioUi? desempenioUi = desempenioUiList.firstWhereOrNull((element) => element.competenciaId == desempenioIcdSesionData.competenciaId && desempenioIcdSesionData.desempenioId == element.desempenioId);
      if(desempenioUi == null){
        desempenioUi =  DesempenioUi();
        desempenioUi.desempenioId = desempenioIcdSesionData.desempenioId;
        desempenioUi.competenciaId =   desempenioIcdSesionData.competenciaId;
        desempenioUi.desempenio = desempenioIcdSesionData.desempenio;
        desempenioUi.icdUiList = [];
        desempenioUiList.add(desempenioUi);
      }

      IcdUi icdUi = IcdUi();
      icdUi.icdId = desempenioIcdSesionData.icdId;
      icdUi.titulo = desempenioIcdSesionData.icd;
      icdUi.competenciaId =  desempenioIcdSesionData.competenciaId;
      icdUi.desempenioIcdId = desempenioIcdSesionData.desempenioIcdId;
      desempenioUi.icdUiList?.add(icdUi);

    }

    List<CampotematicoSesionData> campotematicoSesionList = await (SQL.select(SQL.campotematicoSesion)..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId))).get();
    List<TemaCriterioUi> temaCriterioUiList = [];
    for(CampotematicoSesionData campotematicoSesionData in campotematicoSesionList){
      if((campotematicoSesionData.campoTematicoPadreId??0) > 0){
        TemaCriterioUi? temaCriPadreUi = temaCriterioUiList.firstWhereOrNull((element) => element.campoTematicoId == campotematicoSesionData.campoTematicoPadre && element.desempenioIcdId == campotematicoSesionData.desempenioIcdId);
        if(temaCriPadreUi == null){
          temaCriPadreUi = TemaCriterioUi();
          temaCriPadreUi.campoTematicoId = campotematicoSesionData.campoTematicoPadreId;
          temaCriPadreUi.titulo = campotematicoSesionData.campoTematicoPadre;
          print("campoTematicoPadre: ${campotematicoSesionData.campoTematicoPadre}");
          temaCriPadreUi.desempenioIcdId = campotematicoSesionData.desempenioIcdId;
          temaCriPadreUi.temaCriterioUiList = [];
          temaCriterioUiList.add(temaCriPadreUi);
        }
        TemaCriterioUi temaCriterioUi = TemaCriterioUi();
        temaCriterioUi.campoTematicoId = campotematicoSesionData.campoTematicoId;
        temaCriterioUi.titulo = campotematicoSesionData.campoTematico;
        temaCriterioUi.desempenioIcdId = campotematicoSesionData.desempenioIcdId;
        temaCriPadreUi.temaCriterioUiList?.add(temaCriterioUi);

      }else{
        TemaCriterioUi temaCriterioUi = TemaCriterioUi();
        temaCriterioUi.campoTematicoId = campotematicoSesionData.campoTematicoId;
        temaCriterioUi.titulo = campotematicoSesionData.campoTematico;
        temaCriterioUi.desempenioIcdId = campotematicoSesionData.desempenioIcdId;
        temaCriterioUiList.add(temaCriterioUi);
      }
    }


    for(CompetenciaUi competenciaUi in competenciaUiList){
      for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
        capacidadUi.desempenioUiList = [];
        for(DesempenioUi desempenioUi in desempenioUiList){
           if(desempenioUi.competenciaId == capacidadUi.capacidadId){
             capacidadUi.desempenioUiList?.add(desempenioUi);
           }
        }

        for(DesempenioUi desempenioUi in capacidadUi.desempenioUiList??[]){
          for(IcdUi icdUi in desempenioUi.icdUiList??[]){
            icdUi.temaCriterioUiList = [];
            for(TemaCriterioUi temaCriterioUi in temaCriterioUiList){
              if(icdUi.desempenioIcdId == temaCriterioUi.desempenioIcdId){
                icdUi.temaCriterioUiList?.add(temaCriterioUi);
              }
            }
            print("icdUi.temaCriterioUiList: ${icdUi.temaCriterioUiList?.length}");
          }
        }


      }
    }

    return competenciaUiList;

  }

}