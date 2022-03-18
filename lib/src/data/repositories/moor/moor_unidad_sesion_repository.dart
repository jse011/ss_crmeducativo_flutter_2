import 'package:flutter/cupertino.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_utils.dart';
import 'package:ss_crmeducativo_2/src/data/helpers/serelizable/rest_api_response.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/campotematico_sesion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/competencia_sesion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/desempenio_icd_sesion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/instrumento_evaluacion_sesion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/recursos_sesion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/sesion_evento.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/unidad_evento.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/actividad_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/actividad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/desempenio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_firebase_sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/icd_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/instrumento_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_hoy_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_sesion_repository.dart';
import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_drive_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tipos.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_youtube_tools.dart';
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

        await (SQL.delete(SQL.relUnidadEvento)..where((tbl) => tbl.unidadaprendizajeId.isIn(unidadEventoIdList) )).go();
        await (SQL.delete(SQL.unidadEvento)..where((tbl) => tbl.unidadAprendizajeId.isIn(unidadEventoIdList) )).go();
        var queryDeleteSesion = SQL.delete(SQL.sesionEvento)..where((tbl) => tbl.unidadAprendizajeId.isIn(unidadEventoIdList));
        if(rolId>0) queryDeleteSesion.where((tbl) => tbl.rolId.equals(rolId));

        await queryDeleteSesion.go();

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


    List<UnidadUi> unidadEventoUiList = [];
    List<int> sesionPadreIdList = [];
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
        unidadUi.silaboEventoId = unidadEvento.silaboEventoId;
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
        sesionUi.fechaEjecucionDate = DateTime.fromMillisecondsSinceEpoch(sesionEvento.fechaEjecucion??0);
        sesionUi.fechaEjecucionFin = (sesionEvento.fechaEjecucionFin??0) > 943938000000? DomainTools.f_fecha_letras(DateTime.fromMillisecondsSinceEpoch(sesionEvento.fechaEjecucionFin??0)):null;
        sesionUi.sesionAprendizajePadreId = sesionEvento.parentSesionId;
        //sesionUi.estadoEjecucionId = sesionEvento.estadoEjecucionId;

        if(sesionEvento.estadoEjecucionId == UnidadSesionRepository.ESTADO_CREADO){
          sesionUi.sesionEstado = SesionEstado.CREADO;
          //sesionUi.estadoEjecucion = "Creado";
          //sesionUi.colorSesion = "#1E88E5";
        }else if(sesionEvento.estadoEjecucionId == UnidadSesionRepository.ESTADO_PROGRAMADO){
          sesionUi.sesionEstado = SesionEstado.PROGRAMADO;
          //sesionUi.estadoEjecucion = "Programado";
          //sesionUi.colorSesion = "#FB8C00";
        }else if(sesionEvento.estadoEjecucionId == UnidadSesionRepository.ESTADO_HECHO){
          sesionUi.sesionEstado = SesionEstado.HECHO;
          //sesionUi.estadoEjecucion = "Hecho";
          //sesionUi.colorSesion = "#4caf50";
        }else if(sesionEvento.estadoEjecucionId == UnidadSesionRepository.ESTADO_PENDIENTE){
          sesionUi.sesionEstado = SesionEstado.PENDIENTE;
          //sesionUi.estadoEjecucion = "Pendiente";
          //sesionUi.colorSesion = "#F44336";
        }

        sesionUi.unidadAprendizajeId = unidadUi.unidadAprendizajeId;
        sesionUi.rolId = sesionEvento.rolId;
        unidadUi.sesionUiList?.add(sesionUi);
        if(sesionUi.rolId == 6)
          sesionPadreIdList.add(sesionUi.sesionAprendizajePadreId??0);
      }
    }

    for(UnidadUi unidadUi in unidadEventoUiList){
      for(int sesionId in sesionPadreIdList){
        unidadUi.sesionUiList?.removeWhere((element) => element.sesionAprendizajeId == sesionId);
      }
      unidadUi.sesionUiList?.sort((o1, o2) {
        int cmp = (o2.nroUnidad??0).compareTo(o1.nroUnidad??0);
        if (cmp != 0) return cmp;
        return (o2.fechaEjecucionDate??DateTime(1980)).compareTo(o1.fechaEjecucionDate??DateTime(1980));
      });
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
     calendarioPeriodoUI.habilitadoProceso = (serial.habilitadoProceso??false)?1:0;
     print("habilitadoProceso: ${serial.habilitadoProceso}");
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


      await (SQL.delete(SQL.competenciaSesion)..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId) )).go();
      await (SQL.delete(SQL.desempenioIcdSesion)..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId) )).go();
      await (SQL.delete(SQL.campotematicoSesion)..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId) )).go();
      await (SQL.delete(SQL.recursoSesion)..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId) )).go();


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

      if(unidadAprendizaje.containsKey("recursoDidaticos")){
        List<RecursoSesionData> list = [];
        unidadAprendizaje['recursoDidaticos'].forEach((v) {
          list.add(RecursoSesionData.fromJson(v));
        });
        batch.insertAll(SQL.recursoSesion,list, mode: InsertMode.insertOrReplace );
      }

    });


  }

  @override
  Future<SesionUi> getAprendizajeSesion(int? sesionAprendizajeId) async{
    AppDataBase SQL = AppDataBase();
    SesionUi sesionUi = SesionUi();
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


    List<SesionRecursoUi> sesionRecursoUiList = [];
    for(RecursoSesionData recursoData in await (SQL.select(SQL.recursoSesion)..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId))).get()){

      SesionRecursoUi sesionRecursoUi = SesionRecursoUi();
      sesionRecursoUi.recursoDidacticoId = recursoData.recursoDidacticoId;
      sesionRecursoUi.titulo = recursoData.titulo;
      sesionRecursoUi.descripcion = recursoData.descripcion;
      sesionRecursoUi.driveId = recursoData.driveId;
      sesionRecursoUi.tipoRecursoActNombre = recursoData.tipoRecursoActNombre;
      switch(recursoData.tipoId) {
        case DomainTipos.TIPO_RECURSO_AUDIO:
          sesionRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_AUDIO;
          break;
        case DomainTipos.TIPO_RECURSO_DIAPOSITIVA:
          sesionRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_DIAPOSITIVA;
          break;
        case DomainTipos.TIPO_RECURSO_DOCUMENTO:
          sesionRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_DOCUMENTO;
          break;
        case DomainTipos.TIPO_RECURSO_HOJA_CALUCLO:
          sesionRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_HOJA_CALCULO;
          break;
        case DomainTipos.TIPO_RECURSO_IMAGEN:
          sesionRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_IMAGEN;
          break;
        case DomainTipos.TIPO_RECURSO_PDF:
          sesionRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_PDF;
          break;
        case DomainTipos.TIPO_RECURSO_VIDEO:
        case DomainTipos.TIPO_RECURSO_VINCULO:

          if(recursoData.tipoId == DomainTipos.TIPO_RECURSO_VINCULO && (sesionRecursoUi.driveId??"").isNotEmpty){
            sesionRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_VIDEO;
            break;
          }

          sesionRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO;
          String? idYoutube = YouTubeUrlParser.getYoutubeVideoId(sesionRecursoUi.descripcion);
          String? idDrive = DriveUrlParser.getDocumentId(sesionRecursoUi.descripcion);
          if((idYoutube??"").isNotEmpty){
            sesionRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO_YOUTUBE;
          }else if((idDrive??"").isNotEmpty){
            sesionRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO_DRIVE;
            sesionRecursoUi.driveId = idDrive;
          }else{
            sesionRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO;
          }
          break;
        case DomainTipos.TIPO_RECURSO_YOUTUBE:
          sesionRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO_YOUTUBE;
          break;
        case DomainTipos.TIPO_RECURSO_MATERIALES:
          sesionRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_RECURSO;
          break;
        default:
          sesionRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO;
          break;
      }
      sesionRecursoUiList.add(sesionRecursoUi);
    }
    sesionUi.competenciaUiList = competenciaUiList;
    sesionUi.recursosUiList = sesionRecursoUiList;
    return sesionUi;

  }

  @override
  Future<void> saveEstadoSesion(int? sesionAprendizajeId, int estado_hecho) async{

  }

  @override
  Future<void> saveActividadesSesion(int? sesionAprendizajeId, List<dynamic> actividades) async{
    AppDataBase SQL = AppDataBase();

    await SQL.batch((batch) async {
      await (SQL.delete(SQL.actividadSesion)..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId) )).go();
      await (SQL.delete(SQL.instrumentoEvaluacionSesion)..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId) )).go();


      List<ActividadSesionData> list = [];
      List<RecursosActividadSesionData> recursoslist = [];
      List<InstrumentoEvaluacionSesionData> intrumentoList = [];
      actividades.forEach((v) {
        Map<String, dynamic> json = v;
        list.add(ActividadSesionData.fromJson(json));

        if(json.containsKey("subActividad")){
          List<dynamic>? subActividad = json["subActividad"];
          subActividad?.forEach((element) {
            list.add(ActividadSesionData.fromJson(element));

            if(element.containsKey("recursoActividad")){
              List<dynamic>? recursoSubActividad = element["recursoActividad"];
              recursoSubActividad?.forEach((element) {
                recursoslist.add(RecursosActividadSesionData.fromJson(element));
              });
            }

          });
        }

        if(json.containsKey("recursoActividad")){
          List<dynamic>? recursoActividad = json["recursoActividad"];
          recursoActividad?.forEach((element) {
            recursoslist.add(RecursosActividadSesionData.fromJson(element));
          });
        }

        if(json.containsKey("instrumento")){
          Map<String, dynamic>? instrumento = json["instrumento"];
          if(instrumento!=null)intrumentoList.add(InstrumentoEvaluacionSesionData.fromJson(instrumento));
        }

      });

      List<int> actividadIdList  = [];
      for(var actividad in list){
        actividadIdList.add(actividad.actividadAprendizajeId);
      }

      await (SQL.delete(SQL.recursosActividadSesion)..where((tbl) => tbl.actividadAprendizajeId.isIn(actividadIdList) )).go();

      batch.insertAll(SQL.actividadSesion,list, mode: InsertMode.insertOrReplace );
      batch.insertAll(SQL.instrumentoEvaluacionSesion, intrumentoList, mode: InsertMode.insertOrReplace );
      print("recursoslist: ${recursoslist.length}");
      batch.insertAll(SQL.recursosActividadSesion,recursoslist, mode: InsertMode.insertOrReplace );

    });

  }

  @override
  Future<SesionUi> getActividadSesion(int? sesionAprendizajeId)async {
    AppDataBase SQL = AppDataBase();
    var query = SQL.select(SQL.actividadSesion)
      ..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId));
    query.where((tbl) => tbl.parentId.equals(0));
    SesionUi sesionUi = SesionUi();
    List<ActividadUi> actividadList = [];
    List<InstrumentoEvaluacionSesionData> instrumentoDataList = await (SQL
        .select(SQL.instrumentoEvaluacionSesion)
      ..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId)))
        .get();
    List<InstrumentoEvaluacionUi> instrumentoEvaluacionUiList = [];
    List<InstrumentoEvaluacionUi> instrumentoRemoveUiList = [];
    for (InstrumentoEvaluacionSesionData instrumentoData in instrumentoDataList) {
      InstrumentoEvaluacionUi instrumentoEvaluacionUi = InstrumentoEvaluacionUi();
      instrumentoEvaluacionUi.instrumentoEvalId =
          instrumentoData.instrumentoEvalId;
      instrumentoEvaluacionUi.nombre = instrumentoData.nombre;
      instrumentoEvaluacionUi.cantidadPreguntas =
          instrumentoData.cantidadPreguntas;
      instrumentoEvaluacionUiList.add(instrumentoEvaluacionUi);
    }

    for (ActividadSesionData actividadSesionData in await query.get()) {
      ActividadUi actividadUi = ActividadUi();
      actividadUi.actividadAprendizajeId =
          actividadSesionData.actividadAprendizajeId;
      actividadUi.actividad = actividadSesionData.actividad;
      actividadUi.secuencia = actividadSesionData.secuencia;
      actividadUi.tipoNombre = actividadSesionData.tipoActividad;
      actividadUi.descripcion =
          actividadSesionData.descripcionActividad?.replaceAll("(\n|\r)", "");


      if (actividadSesionData.tipoActividadId == 585) {
        actividadUi.tipo = ActividadTipo.CONECTA; //Conecta
      }
      else if (actividadSesionData.tipoActividadId == 586) {
        actividadUi.tipo = ActividadTipo.TEORIA; //Teoría
      }
      else if (actividadSesionData.tipoActividadId == 587) {
        actividadUi.tipo = ActividadTipo.APRENDIZAJE; //Aprendizaje
      }
      else if (actividadSesionData.tipoActividadId == 588) {
        actividadUi.tipo = ActividadTipo.PRACTICA; //Práctica
      }
      else {
        actividadUi.tipo = ActividadTipo.CONECTA;
      }

      var subQuery = SQL.select(SQL.actividadSesion)
        ..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId));
      subQuery.where((tbl) =>
          tbl.parentId.equals(actividadSesionData.actividadAprendizajeId));
      List<ActividadUi> subactividadList = [];
      for (ActividadSesionData subActividadSesionData in await subQuery.get()) {
        ActividadUi subActividadUi = ActividadUi();
        subActividadUi.actividadAprendizajeId =
            subActividadSesionData.actividadAprendizajeId;
        subActividadUi.actividad = subActividadSesionData.actividad;
        subActividadUi.descripcion =
            subActividadSesionData.descripcionActividad?.replaceAll(
                "(\n|\r)", "");
        subActividadUi.recursos = await getRecursoActividad(
            subActividadSesionData.actividadAprendizajeId);
        subActividadUi.instrumentoEvaluacionUi =
            instrumentoEvaluacionUiList.firstWhereOrNull((element) => element
                .instrumentoEvalId == subActividadSesionData.instrumentoEvalId);
        if(subActividadUi.instrumentoEvaluacionUi!=null){
          instrumentoRemoveUiList.add(subActividadUi.instrumentoEvaluacionUi!);
        }
        subactividadList.add(subActividadUi);
      }
      actividadUi.subActividades = subactividadList;
      actividadUi.recursos =
      await getRecursoActividad(actividadSesionData.actividadAprendizajeId);
      actividadUi.instrumentoEvaluacionUi =
          instrumentoEvaluacionUiList.firstWhereOrNull((element) => element
              .instrumentoEvalId == actividadSesionData.instrumentoEvalId);
      if(actividadUi.instrumentoEvaluacionUi!=null){
        instrumentoRemoveUiList.add(actividadUi.instrumentoEvaluacionUi!);
      }
      actividadList.add(actividadUi);
    }

    for(var instrumentoRemove in instrumentoRemoveUiList){
      instrumentoEvaluacionUiList.remove(instrumentoRemove);
    }
    sesionUi.instrumentoEvaluacionUiList = instrumentoEvaluacionUiList;
    sesionUi.actividadUiList = actividadList;

    return sesionUi;

  }

    Future<List<ActividadRecursoUi>> getRecursoActividad (int actividadAprendizajeId)async{
    AppDataBase SQL = AppDataBase();
    var recursoQuery = SQL.select(SQL.recursosActividadSesion)..where((tbl) => tbl.actividadAprendizajeId.equals(actividadAprendizajeId));
    List<ActividadRecursoUi> actividadRecursoUiList = [];
    for(RecursosActividadSesionData recursoData in await recursoQuery.get()){
      ActividadRecursoUi actividadRecursoUi = ActividadRecursoUi();
      actividadRecursoUi.recursoDidacticoId = recursoData.recursoDidacticoId;
      actividadRecursoUi.titulo = recursoData.titulo;
      actividadRecursoUi.descripcion = recursoData.descripcion;
      actividadRecursoUi.driveId = recursoData.driveId;
      switch(recursoData.tipoId) {
        case DomainTipos.TIPO_RECURSO_AUDIO:
          actividadRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_AUDIO;
          break;
        case DomainTipos.TIPO_RECURSO_DIAPOSITIVA:
          actividadRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_DIAPOSITIVA;
          break;
        case DomainTipos.TIPO_RECURSO_DOCUMENTO:
          actividadRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_DOCUMENTO;
          break;
        case DomainTipos.TIPO_RECURSO_HOJA_CALUCLO:
          actividadRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_HOJA_CALCULO;
          break;
        case DomainTipos.TIPO_RECURSO_IMAGEN:
          actividadRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_IMAGEN;
          break;
        case DomainTipos.TIPO_RECURSO_PDF:
          actividadRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_PDF;
          break;
        case DomainTipos.TIPO_RECURSO_VIDEO:
        case DomainTipos.TIPO_RECURSO_VINCULO:

          if(recursoData.tipoId == DomainTipos.TIPO_RECURSO_VINCULO && (actividadRecursoUi.driveId??"").isNotEmpty){
            actividadRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_VIDEO;
            break;
          }

          actividadRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO;
          String? idYoutube = YouTubeUrlParser.getYoutubeVideoId(actividadRecursoUi.descripcion);
          String? idDrive = DriveUrlParser.getDocumentId(actividadRecursoUi.descripcion);
          if((idYoutube??"").isNotEmpty){
            actividadRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO_YOUTUBE;
          }else if((idDrive??"").isNotEmpty){
            actividadRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO_DRIVE;
            actividadRecursoUi.driveId = idDrive;
          }else{
            actividadRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO;
          }
          break;
        case DomainTipos.TIPO_RECURSO_YOUTUBE:
          actividadRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO_YOUTUBE;
          break;
        case DomainTipos.TIPO_RECURSO_MATERIALES:
          actividadRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_RECURSO;
          break;
        default:
          actividadRecursoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO;
          break;
      }
      actividadRecursoUiList.add(actividadRecursoUi);
    }
    print("actividadRecursoUiList: ${actividadRecursoUiList.length}");
    return actividadRecursoUiList;
  }

  @override
  List<EvaluacionFirebaseSesionUi>? transformarEvaluacionesData(Map<String, dynamic> evalaucionesSesionesData) {
    List<EvaluacionFirebaseSesionUi> evaluaciones = [];
    if(evalaucionesSesionesData.containsKey("tareas")){
      if(evalaucionesSesionesData.containsKey("preguntas")){
        for(var item in evalaucionesSesionesData["preguntas"]){
          PreguntaFirebaseSerial preguntasFirebaseSerial = PreguntaFirebaseSerial.fromJson(item);
          EvaluacionFirebaseSesionUi evaluacionFirebaseSesionUi = new EvaluacionFirebaseSesionUi();
          evaluacionFirebaseSesionUi.key = preguntasFirebaseSerial.PreguntaPortalAlumnoId;
          evaluacionFirebaseSesionUi.tipo = EvaluacionFirebaseTipoUi.PREGUNTA;
          evaluacionFirebaseSesionUi.nombre = preguntasFirebaseSerial.Pregunta;
          evaluacionFirebaseSesionUi.data = item;
          evaluaciones.add(evaluacionFirebaseSesionUi);
        }
      }

      for(var item in evalaucionesSesionesData["tareas"]){
        TareaFirebaseSerial tareasFirebaseSerial = TareaFirebaseSerial.fromJson(item);
        EvaluacionFirebaseSesionUi evaluacionFirebaseSesionUi = new EvaluacionFirebaseSesionUi();
        evaluacionFirebaseSesionUi.key = tareasFirebaseSerial.TareaId;
        evaluacionFirebaseSesionUi.tipo = EvaluacionFirebaseTipoUi.TAREA;
        evaluacionFirebaseSesionUi.nombre = tareasFirebaseSerial.Titulo;
        evaluacionFirebaseSesionUi.data = item;
        evaluaciones.add(evaluacionFirebaseSesionUi);
      }
    }

    if(evalaucionesSesionesData.containsKey("instrumetos")){
      for(var item in evalaucionesSesionesData["instrumetos"]){
        InstrumetosFirebaseSerial preguntasFirebaseSerial = InstrumetosFirebaseSerial.fromJson(item);
        EvaluacionFirebaseSesionUi evaluacionFirebaseSesionUi = new EvaluacionFirebaseSesionUi();
        evaluacionFirebaseSesionUi.key = preguntasFirebaseSerial.InstrumentoEvalId?.toString();
        evaluacionFirebaseSesionUi.tipo = EvaluacionFirebaseTipoUi.INSTRUMENTO;
        evaluacionFirebaseSesionUi.nombre = preguntasFirebaseSerial.Nombre;
        evaluacionFirebaseSesionUi.data = item;
        evaluaciones.add(evaluacionFirebaseSesionUi);
      }
    }


    if(evalaucionesSesionesData.containsKey("unidadTareas")){
      for(var item in evalaucionesSesionesData["unidadTareas"]){
        TareaFirebaseSerial tareasFirebaseSerial = TareaFirebaseSerial.fromJson(item);
        EvaluacionFirebaseSesionUi evaluacionFirebaseSesionUi = new EvaluacionFirebaseSesionUi();
        evaluacionFirebaseSesionUi.tipo = EvaluacionFirebaseTipoUi.TAREAUNIDAD;
        evaluacionFirebaseSesionUi.nombre = tareasFirebaseSerial.Titulo;
        evaluacionFirebaseSesionUi.data = tareasFirebaseSerial.toJson();
        evaluaciones.add(evaluacionFirebaseSesionUi);
      }
    }
    return evaluaciones;
  }
}



