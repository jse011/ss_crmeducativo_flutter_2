import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/helpers/serelizable/rest_api_response.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/archivo_rubro.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/equipo_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/evaluacion_proceso.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/data_convert.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/estado_sync.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_equipo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_publicado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/forma_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/integrante_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_eval_equipo_integrante_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_equipo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_comentario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_evidencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_resultado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_resultado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tipos.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_youtube_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/id_generator.dart';


import 'database/app_database.dart';

class MoorRubroRepository extends RubroRepository{
  static const int TN_VALOR_NUMERICO = 410, TN_SELECTOR_NUMERICO = 411, TN_SELECTOR_VALORES = 412, TN_SELECTOR_ICONOS = 409, TN_VALOR_ASISTENCIA= 474;
  static const int COMPETENCIA_BASE = 347, COMPETENCIA_TRANS = 348, COMPETENCIA_ENFQ = 349;
  static const int TIPO_RUBRO_UNIDIMENCIONAL = 470, TIPO_RUBRO_BIMENSIONAL = 471, TIPO_RUBRO_BIDIMENCIONAL_DETALLE = 473;
  static const int FORMA_EVAL_INDIVIDUAL = 477, FORMA_EVAL_GRUPAL = 478;


  @override
  Future<void> saveDatosCrearRubros(Map<String, dynamic> crearRubro, int silaboEventoId, int calendarioPeriodoId, int sesionAprendizajeId) async {
    AppDataBase SQL = AppDataBase();
    int anioAcademicoId = 0;
    int  empleadoId = 0;

    await SQL.transaction(() async{

      if(sesionAprendizajeId>0){
        var query = SQL.delete(SQL.criterio)..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId));
        await query.go();
      }else{
        var query = SQL.delete(SQL.criterio)..where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
        query.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
        //query.where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId));
        await query.go();
      }

      await SQL.batch((batch) async {
        // functions in a batch don't have to be awaited - just
        // await the whole batch afterwards.
        //if(crearRubro.containsKey("sessionAprendizajeCriterios")||crearRubro.containsKey("unidadAprendizajeCriterios")){
          //&& t.calendarioPeriodoId.equals(calendarioPeriodoId)
          //batch.deleteWhere(SQL.criterio, (Criterio t) => t.silaboEventoId.equals(silaboEventoId));


        //}

        if(crearRubro.containsKey("sessionAprendizajeCriterios")){
          batch.insertAll(SQL.criterio, SerializableConvert.converListSerializeCriterio(crearRubro["sessionAprendizajeCriterios"])  , mode: InsertMode.insertOrReplace );
        }

        if(crearRubro.containsKey("unidadAprendizajeCriterios")){
          batch.insertAll(SQL.criterio, SerializableConvert.converListSerializeCriterio(crearRubro["unidadAprendizajeCriterios"])  , mode: InsertMode.insertOrReplace );
        }

        if(crearRubro.containsKey("crearRubrosOfflinetipos")){
          batch.deleteWhere(SQL.tiposRubro, (row) => const Constant(true));
          batch.insertAll(SQL.tiposRubro, SerializableConvert.converListSerializeTiposRubro(crearRubro["crearRubrosOfflinetipos"])  , mode: InsertMode.insertOrReplace );
        }

        if(crearRubro.containsKey("crearRubrosOfflinetipos_evaluacion")){
          batch.deleteWhere(SQL.tipoEvaluacionRubro, (row) => const Constant(true));
          batch.insertAll(SQL.tipoEvaluacionRubro, SerializableConvert.converListSerializeTipoEvaluacionRubro(crearRubro["crearRubrosOfflinetipos_evaluacion"])  , mode: InsertMode.insertOrReplace );
        }

        if(crearRubro.containsKey("valorTipoNota")){
          batch.deleteWhere(SQL.valorTipoNotaRubro, ($ValorTipoNotaRubroTable row) => Constant(true));
          batch.insertAll(SQL.valorTipoNotaRubro, SerializableConvert.converListSerializeValorTipoNotaRubro(crearRubro["valorTipoNota"]), mode: InsertMode.insertOrReplace);
          batch.insertAll(SQL.valorTipoNotaResultado, SerializableConvert.converListSerializeValorTipoNotaResultado(crearRubro["valorTipoNota"]), mode: InsertMode.insertOrReplace);
        }

        if(crearRubro.containsKey("tipoNotaEscala")){
          batch.deleteWhere(SQL.tipoNotaRubro, (row) => Constant(true));
          batch.insertAll(SQL.tipoNotaRubro, SerializableConvert.converListSerializeTipoNotaRubro(crearRubro["tipoNotaEscala"]), mode: InsertMode.insertOrReplace);
          batch.insertAll(SQL.tipoNotaResultado, SerializableConvert.converListSerializeTipoNotaResultado(crearRubro["tipoNotaEscala"]), mode: InsertMode.insertOrReplace);
        }

        /*Nueva forma de enviar criterios*/
        if(crearRubro.containsKey("unidades")||crearRubro.containsKey("sesiones")){
          Iterable sesiones = crearRubro["sesiones"];
          List<SesionesCriterioSerial> sesionSerialList = [];
          for(var item in sesiones){
            sesionSerialList.add(SesionesCriterioSerial.fromJson(item));
          }

          Iterable unidades = crearRubro["unidades"];
          List<UnidadesCriteroSerial> unidadSerialList = [];
          for(var item in unidades){
            unidadSerialList.add(UnidadesCriteroSerial.fromJson(item));
          }

          Iterable competencias = crearRubro["competencias"];
          List<CompetenciasCriteroSerial> competenciasSerialList = [];
          for(var item in competencias){
            competenciasSerialList.add(CompetenciasCriteroSerial.fromJson(item));
          }

          Iterable desempenioIcds = crearRubro["desempenioIcds"];
          List<DesempenioIcdsCriteroSerial> desempenioIcdsSerialList = [];
          for(var item in desempenioIcds){
            desempenioIcdsSerialList.add(DesempenioIcdsCriteroSerial.fromJson(item));
          }

          Iterable icds = crearRubro["icds"];
          List<IcdsCriteroSerial> icdsSerialList = [];
          for(var item in icds){
            icdsSerialList.add(IcdsCriteroSerial.fromJson(item));
          }

          Iterable campotematicos = crearRubro["campotematicos"];
          List<CampotematicosCriteroSerial> campotematicosSerialList = [];
          for(var item in campotematicos){
            campotematicosSerialList.add(CampotematicosCriteroSerial.fromJson(item));
          }

          Iterable sesionesCompetencia = crearRubro["sesionesCompetencia"];
          List<SesionesCompetenciaCriterioSerial> sesionesCompetenciaSerialList = [];
          for(var item in sesionesCompetencia){
            sesionesCompetenciaSerialList.add(SesionesCompetenciaCriterioSerial.fromJson(item));
          }

          Iterable sesionesDesempenioIcds = crearRubro["sesionesDesempenioIcds"];
          List<SesionesDesempenioIcdsCriterioSerial> sesionesDesempenioIcdsSerialList = [];
          for(var item in sesionesDesempenioIcds){
            sesionesDesempenioIcdsSerialList.add(SesionesDesempenioIcdsCriterioSerial.fromJson(item));
          }

          Iterable sesionesCampoTematicos = crearRubro["sesionesCampoTematicos"];
          List<SesionesCampoTematicosCriterioSerial> sesionesCampoTematicosSerialList = [];
          for(var item in sesionesCampoTematicos){
            sesionesCampoTematicosSerialList.add(SesionesCampoTematicosCriterioSerial.fromJson(item));
          }

          Iterable unidadCampoTematicos = crearRubro["unidadCampoTematicos"];
          List<UnidadCampoTematicosCriteroSerial> unidadCampoTematicosSerialList = [];
          for(var item in unidadCampoTematicos){
            unidadCampoTematicosSerialList.add(UnidadCampoTematicosCriteroSerial.fromJson(item));
          }

          Iterable unidadCompetencias = crearRubro["unidadCompetencias"];
          List<UnidadCompetenciasCriteroSerial> unidadCompetenciasSerialList = [];
          for(var item in unidadCompetencias){
            unidadCompetenciasSerialList.add(UnidadCompetenciasCriteroSerial.fromJson(item));
          }

          Iterable unidadDesempenioIcds = crearRubro["unidadDesempenioIcds"];
          List<UnidadDesempenioIcdsCriteroSerial> unidadDesempenioIcdsSerialList = [];
          for(var item in unidadDesempenioIcds){
            unidadDesempenioIcdsSerialList.add(UnidadDesempenioIcdsCriteroSerial.fromJson(item));
          }

          Map<String,dynamic> imagenDesempenioIcd = crearRubro["imagenDesempenioIcd"];

          List<CriterioData> criterioUnidadList = [];
          for(var unidad in unidadSerialList){

            var unidadCompetenciasFiltro = unidadCompetenciasSerialList.where((element) => element.unidadAprendizajeId == unidad.unidadAprendizajeId);
            if(unidadCompetenciasFiltro.isNotEmpty){
              for(var unidadcompetencia in unidadCompetenciasFiltro){
                CompetenciasCriteroSerial? capacidad = competenciasSerialList.firstWhereOrNull((element) => element.competenciaId == unidadcompetencia.competenciaId);
                CompetenciasCriteroSerial? competencia = competenciasSerialList.firstWhereOrNull((element) => element.competenciaId == capacidad?.superCompetenciaId);

                var unidadDesempenioIcdsFiltro = unidadDesempenioIcdsSerialList.where((element) => element.unidadCompetenciaId == unidadcompetencia.unidadCompetenciaId);

                if(unidadDesempenioIcdsFiltro.isNotEmpty){
                  for(var unidadDesempenioIcd in unidadDesempenioIcdsFiltro){
                    DesempenioIcdsCriteroSerial? desempenioIcds = desempenioIcdsSerialList.firstWhereOrNull((element) => element.desempenioIcdId == unidadDesempenioIcd.desempenioIcdId);
                    IcdsCriteroSerial? icds = icdsSerialList.firstWhereOrNull((element) => element.icdId == desempenioIcds?.icdId);
                    String? url = null;
                    if(imagenDesempenioIcd.containsKey(desempenioIcds?.tipoId??"")){
                      url = imagenDesempenioIcd[desempenioIcds?.tipoId];
                    }

                    var unidadCampoTematicosFiltro = unidadCampoTematicosSerialList.where((element) => element.unidadCompetenciaDesempenioIcdId == unidadDesempenioIcd.unidadCompetenciaDesempenioIcdId);
                    if(unidadCampoTematicosFiltro.isNotEmpty){
                      for(var unidadCampoTematico in unidadCampoTematicosFiltro){
                        CampotematicosCriteroSerial? campotematico = campotematicosSerialList.firstWhereOrNull((element) => element.campoTematicoId == unidadCampoTematico.campoTematicoIcd);
                        CampotematicosCriteroSerial? campotematicoPadre = campotematicosSerialList.firstWhereOrNull((element) => element.campoTematicoId == campotematico?.parentId);

                        criterioUnidadList.add(tranformarCriterioUnidadData(silaboEventoId, calendarioPeriodoId, unidad, null, unidadcompetencia, capacidad, competencia, desempenioIcds, icds, url, campotematico, campotematicoPadre));
                      }
                    }else{
                      criterioUnidadList.add(tranformarCriterioUnidadData(silaboEventoId, calendarioPeriodoId, unidad, null, unidadcompetencia, capacidad, competencia, desempenioIcds, icds, url, null, null));
                    }
                  }
                }else{
                  criterioUnidadList.add(tranformarCriterioUnidadData(silaboEventoId, calendarioPeriodoId, unidad, null, unidadcompetencia, capacidad, competencia, null, null, null, null, null));
                }
              }
            }else{
              criterioUnidadList.add(tranformarCriterioUnidadData(silaboEventoId, calendarioPeriodoId, unidad, null, null, null, null, null, null, null, null, null));
            }
          }

          List<CriterioData> criterioSesionList = [];
          for(var sesion in sesionSerialList){
            var unidad = unidadSerialList.firstWhereOrNull((element) => element.unidadAprendizajeId == sesion.unidadAprendizajeId);
            var sesionCompetenciasFiltro = sesionesCompetenciaSerialList.where((element) => element.sesionAprendizajeId == sesion.sesionAprendizajeId);
            if(sesionCompetenciasFiltro.isNotEmpty){
              for(var sesioncompetencia in sesionCompetenciasFiltro){
                CompetenciasCriteroSerial? capacidad = competenciasSerialList.firstWhereOrNull((element) => element.competenciaId == sesioncompetencia.competenciaId);
                CompetenciasCriteroSerial? competencia = competenciasSerialList.firstWhereOrNull((element) => element.competenciaId == capacidad?.superCompetenciaId);

                var sesionesDesempenioIcdsFiltro = sesionesDesempenioIcdsSerialList.where((element) => element.sesionCompetenciaId == sesioncompetencia.sesionCompetenciaId);
                if(sesionesDesempenioIcdsFiltro.isNotEmpty){
                  for(var sesionesDesempenioIcds in sesionesDesempenioIcdsFiltro){
                    DesempenioIcdsCriteroSerial? desempenioIcds = desempenioIcdsSerialList.firstWhereOrNull((element) => element.desempenioIcdId == sesionesDesempenioIcds.desempenioIcdId);
                    IcdsCriteroSerial? icds = icdsSerialList.firstWhereOrNull((element) => element.icdId == desempenioIcds?.icdId);
                    String? url = null;
                    if(imagenDesempenioIcd.containsKey(desempenioIcds?.tipoId??"")){
                      url = imagenDesempenioIcd[desempenioIcds?.tipoId];
                    }

                    var sesionesCampoTematicosFiltro = sesionesCampoTematicosSerialList.where((element) => element.sesionCompetenciaDesempenioIcdId == sesionesDesempenioIcds.sesionCompetenciaDesempenioIcdId);
                    if(sesionesCampoTematicosFiltro.isNotEmpty){
                      for(var  sesionesCampoTematico in sesionesCampoTematicosFiltro){
                        CampotematicosCriteroSerial? campotematico = campotematicosSerialList.firstWhereOrNull((element) => element.campoTematicoId == sesionesCampoTematico.campoTematicoId);
                        CampotematicosCriteroSerial? campotematicoPadre = campotematicosSerialList.firstWhereOrNull((element) => element.campoTematicoId == campotematico?.parentId);

                        criterioSesionList.add(tranformarCriterioUnidadData(silaboEventoId, calendarioPeriodoId, unidad, sesion, null, capacidad, competencia, desempenioIcds, icds, url, campotematico, campotematicoPadre));
                      }
                    }else{
                      criterioSesionList.add(tranformarCriterioUnidadData(silaboEventoId, calendarioPeriodoId, unidad, sesion, null, capacidad, competencia, desempenioIcds, icds, url, null, null));
                    }
                  }
                }else{
                  criterioSesionList.add(tranformarCriterioUnidadData(silaboEventoId, calendarioPeriodoId, unidad, sesion, null, capacidad, competencia, null, null, null, null, null));
                }
              }
            }else{
              criterioSesionList.add(tranformarCriterioUnidadData(silaboEventoId, calendarioPeriodoId, unidad, sesion, null, null, null, null, null, null, null, null));
            }
          }

          batch.insertAll(SQL.criterio,criterioUnidadList , mode: InsertMode.insertOrReplace );
          batch.insertAll(SQL.criterio, criterioSesionList, mode: InsertMode.insertOrReplace );

          /*Nueva forma de enviar criterios*/
        }

      });
    });
  }

  CriterioData tranformarCriterioUnidadData(int? silaboEventoId, int? calendarioPeriodoId, UnidadesCriteroSerial? unidad, SesionesCriterioSerial? sesion, UnidadCompetenciasCriteroSerial? unidadcompetencia, CompetenciasCriteroSerial? capacidad,
      CompetenciasCriteroSerial? competencia, DesempenioIcdsCriteroSerial? desempenioIcds, IcdsCriteroSerial? icds, String? url, CampotematicosCriteroSerial? campotematico, CampotematicosCriteroSerial? campotematicoPadre){
    print("unidad ${unidad?.titulo}");
    return CriterioData(
      unidadAprendiajeId: unidad?.unidadAprendizajeId??sesion?.unidadAprendizajeId??0,
      nroUnidad: unidad?.nroUnidad,
      tituloUnidad: unidad?.titulo,
      calendarioPeriodoId: calendarioPeriodoId,
      silaboEventoId: silaboEventoId??0,
      competenciaId: capacidad?.competenciaId??0,
      competenciaNombre: capacidad?.nombre,
      competenciaEvaluable: unidadcompetencia?.competenciaEvaluable,
      competenciaResultadoId: unidadcompetencia?.competenciaResultadoId,
      competenciaTipoId: capacidad?.tipoId,
      superCompetenciaId: capacidad?.superCompetenciaId,
      superCompetenciaNombre: competencia?.nombre,
      superCompetenciaEvaluable: unidadcompetencia?.competenciaEvaluablePadre,
      superCompetenciaResultadoId: unidadcompetencia?.competenciaResultadoPadreId,
      superCompetenciaTipoId: competencia?.tipoId,
      desempenioIcdId: desempenioIcds?.desempenioIcdId??0,
      tipoId: desempenioIcds?.tipoId,
      icdId: desempenioIcds?.icdId,
      icdTitulo: icds?.titulo,
      desempenioId: desempenioIcds?.desempenioId,
      url: url,
      //sequito el titulo desempenio por ser largo
      campoTematicoId: campotematico?.campoTematicoId??0,
      campoTematicoTitulo: campotematico?.titulo,
      campoTematicoParentEstado: campotematico?.estado,
      campoTematicoParentParentId: campotematico?.parentId,
      campoTematicoParentTitulo: campotematicoPadre?.titulo,
      sesionAprendizajeId: sesion?.sesionAprendizajeId??0,
      nroSesion: sesion?.nroSesion,
      rolIdSesion: sesion?.rolId,
      sesionAprendizajePadreId: sesion?.parentSesionId,
      tituloSesion: sesion?.titulo
    );
  }


  @override
  Future<void> saveDatosRubrosEval(Map<String, dynamic> rubro, int silaboEventoId, int calendarioPeriodoId, int sesionAprendizajeDocenteId, int sesionAprendizajeAlumnoId, String? tareaId) async {
    AppDataBase SQL = AppDataBase();
    //print("saveDatosRubrosEval ${sesionAprendizajeDocenteId} ${sesionAprendizajeAlumnoId}");
    await SQL.transaction(() async{
      await SQL.batch((batch) async {
        print("AQUI D: 1");
        if(rubro.containsKey("rubroEvaluaciones")){
          var queryRubro;
          if((tareaId??"").isNotEmpty){
            queryRubro = SQL.selectOnly(SQL.rubroEvaluacionProceso)
              ..addColumns([SQL.rubroEvaluacionProceso.rubroEvalProcesoId]);
            queryRubro.where(SQL.rubroEvaluacionProceso.tareaId.equals(tareaId));
          } else if(sesionAprendizajeDocenteId>0&&sesionAprendizajeAlumnoId>0){
            queryRubro = SQL.selectOnly(SQL.rubroEvaluacionProceso)
              ..addColumns([SQL.rubroEvaluacionProceso.rubroEvalProcesoId]);
            queryRubro.where(SQL.rubroEvaluacionProceso.sesionAprendizajeId.isIn([sesionAprendizajeAlumnoId, sesionAprendizajeDocenteId]));
          }else if(sesionAprendizajeDocenteId>0){
            queryRubro = SQL.selectOnly(SQL.rubroEvaluacionProceso)
              ..addColumns([SQL.rubroEvaluacionProceso.rubroEvalProcesoId]);
            queryRubro.where(SQL.rubroEvaluacionProceso.sesionAprendizajeId.equals(sesionAprendizajeDocenteId));
          }else if(sesionAprendizajeAlumnoId>0){
            queryRubro = SQL.selectOnly(SQL.rubroEvaluacionProceso)
              ..addColumns([SQL.rubroEvaluacionProceso.rubroEvalProcesoId]);
            queryRubro.where(SQL.rubroEvaluacionProceso.sesionAprendizajeId.equals(sesionAprendizajeAlumnoId));
          }else{
            queryRubro = SQL.selectOnly(SQL.rubroEvaluacionProceso)
              ..addColumns([SQL.rubroEvaluacionProceso.rubroEvalProcesoId]);
            queryRubro.where(SQL.rubroEvaluacionProceso.silaboEventoId.equals(silaboEventoId));
            queryRubro.where(SQL.rubroEvaluacionProceso.calendarioPeriodoId.equals(calendarioPeriodoId));
          }
          //queryRubro.where(SQL.rubroEvaluacionProceso.syncFlag.isNotIn([EstadoSync.FLAG_UPDATED, EstadoSync.FLAG_ADDED])); El servidor devuelve los rubros que solo estan en el celular

          var queryEval = SQL.selectOnly(SQL.evaluacionProceso)..addColumns([SQL.evaluacionProceso.evaluacionProcesoId]);
          queryEval.where(SQL.evaluacionProceso.rubroEvalProcesoId.isInQuery(queryRubro));

          await (SQL.delete(SQL.rubroComentario)..where((tbl) => tbl.evaluacionProcesoId.isInQuery(queryEval))).go();
          await (SQL.delete(SQL.archivoRubro)..where((tbl) => tbl.evaluacionProcesoId.isInQuery(queryEval))).go();
          await (SQL.delete(SQL.evaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.isInQuery(queryRubro))).go();
          await (SQL.delete(SQL.rubroEvalRNPFormula)..where((tbl) => tbl.rubroEvaluacionPrimId.isInQuery(queryRubro))).go();
          await (SQL.delete(SQL.rubroCampotematico)..where((tbl) => tbl.rubroEvalProcesoId.isInQuery(queryRubro))).go();
          await (SQL.delete(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.isInQuery(queryRubro))).go();

          var queryGrupoEquipo = SQL.selectOnly(SQL.rubroEvaluacionProcesoEquipo)
        ..addColumns([SQL.rubroEvaluacionProcesoEquipo.rubroEvaluacionEquipoId]);
          queryGrupoEquipo.where(SQL.rubroEvaluacionProcesoEquipo.rubroEvalProcesoId.isInQuery(queryRubro));

        await (SQL.delete(SQL.rubroEvaluacionProcesoIntegrante)..where((tbl) => tbl.rubroEvaluacionEquipoId.isInQuery(queryGrupoEquipo))).go();
        await (SQL.delete(SQL.rubroEvaluacionProcesoEquipo)..where((tbl) => tbl.rubroEvaluacionEquipoId.isInQuery(queryGrupoEquipo))).go();
        await (SQL.delete(SQL.equipoEvaluacion)..where((tbl) => tbl.equipoId.isInQuery(queryGrupoEquipo))).go();

          //(SQL.delete(SQL.equipoEvaluacion)..where((tbl) => tbl.rubroEvalProcesoId.isInQuery(queryRubro))).go();
          //(SQL.delete(SQL.equipoEvaluacion)..where((tbl) => tbl.rubroEvalProcesoId.isInQuery(queryRubro))).go();

          List<RubroEvaluacionProcesoData> rubroEvaluacionProcesolist = SerializableConvert.converListSerializeRubroEvaluacionProceso(rubro["rubroEvaluaciones"]);
          if(rubro.containsKey("evaluacionStringList")){
            Iterable l = rubro["evaluacionStringList"];
            List<EvaluacionProcesoData> evaluacionProcesoDataList = [];
            for(var item in l){
              String evaluacionProcesoId = "";
              double nota = 0;
              int alumoId = 0;
              String? rubroEvaluacionId = null;
              int publicado = 0;
              String? valorTipoNotaId = null;
              if(item is String){
                var parts  = item.split('|\$');
                evaluacionProcesoId =  parts[0];
                var partsDetalle  = parts[1].split('|');
                String _nota = partsDetalle[0];
                String _alumnoId = partsDetalle[1];
                String _positionRubro = partsDetalle[2];
                String _publicado = partsDetalle[3];
                nota = (_nota).isEmpty?0:double.parse(_nota);
                alumoId = (_alumnoId).isEmpty?0:int.parse(_alumnoId);
                publicado = (_publicado).isEmpty?0:int.parse(_publicado);
                int? positionRubro = (_positionRubro).isEmpty?null:int.parse(_positionRubro);
                if(positionRubro!=null){
                  try{
                    RubroEvaluacionProcesoData rubroEvaluacionProcesoData = rubroEvaluacionProcesolist[positionRubro];
                    rubroEvaluacionId = rubroEvaluacionProcesoData.rubroEvalProcesoId;
                  }catch(e){}
                }
                valorTipoNotaId = parts[2];

              }

              evaluacionProcesoDataList.add( EvaluacionProcesoData(
                  evaluacionProcesoId: evaluacionProcesoId,
                  rubroEvalProcesoId:  rubroEvaluacionId,
                  nota: nota,
                  alumnoId: alumoId,
                  publicado: publicado,
                  valorTipoNotaId: valorTipoNotaId
              ));
            }

            batch.insertAll(SQL.evaluacionProceso, evaluacionProcesoDataList, mode: InsertMode.insertOrReplace );
          }

          batch.insertAll(SQL.rubroEvaluacionProceso, rubroEvaluacionProcesolist, mode: InsertMode.insertOrReplace );
          if(rubro.containsKey("evaluaciones")){
            batch.insertAll(SQL.evaluacionProceso, SerializableConvert.converListSerializeEvaluacionProceso(rubro["evaluaciones"]), mode: InsertMode.insertOrReplace ); 
          }
          batch.insertAll(SQL.rubroEvalRNPFormula, SerializableConvert.converListSerializeRubroEvalRNPFormula(rubro["rubroFormulas"]), mode: InsertMode.insertOrReplace );

        }
        print("AQUI D: 2");

        if(rubro.containsKey("crearRubrosOfflinetipos")){
          batch.deleteWhere(SQL.tiposRubro, (row) => const Constant(true));
          batch.insertAll(SQL.tiposRubro, SerializableConvert.converListSerializeTiposRubro(rubro["crearRubrosOfflinetipos"])  , mode: InsertMode.insertOrReplace );
        }

        if(rubro.containsKey("valorTipoNota")){
          batch.deleteWhere(SQL.valorTipoNotaRubro, ($ValorTipoNotaRubroTable row) => Constant(true));
          batch.insertAll(SQL.valorTipoNotaRubro, SerializableConvert.converListSerializeValorTipoNotaRubro(rubro["valorTipoNota"]), mode: InsertMode.insertOrReplace);
          batch.insertAll(SQL.valorTipoNotaResultado, SerializableConvert.converListSerializeValorTipoNotaResultado(rubro["valorTipoNota"]), mode: InsertMode.insertOrReplace);
        }

        if(rubro.containsKey("tipoNotaEscala")){
          batch.deleteWhere(SQL.tipoNotaRubro, (row) => Constant(true));
          batch.insertAll(SQL.tipoNotaRubro, SerializableConvert.converListSerializeTipoNotaRubro(rubro["tipoNotaEscala"]), mode: InsertMode.insertOrReplace);
          batch.insertAll(SQL.tipoNotaResultado, SerializableConvert.converListSerializeTipoNotaResultado(rubro["tipoNotaEscala"]), mode: InsertMode.insertOrReplace);
        }

        if(rubro.containsKey("rubroComentarios")){
          batch.insertAll(SQL.rubroComentario, SerializableConvert.converListSerializeRubroComentario(rubro["rubroComentarios"]), mode: InsertMode.insertOrReplace);
        }


        if(rubro.containsKey("rubroArchivo")){
          print("AQUI D: 2.8");
          batch.insertAll(SQL.archivoRubro, SerializableConvert.converListSerializeArchivoRubro(rubro["rubroArchivo"]), mode: InsertMode.insertOrReplace);
        }

        if(rubro.containsKey("rubroArchivo")){
          print("AQUI D: 2.8");
          batch.insertAll(SQL.archivoRubro, SerializableConvert.converListSerializeArchivoRubro(rubro["rubroArchivo"]), mode: InsertMode.insertOrReplace);
        }

        if(rubro.containsKey("rubroArchivo")){
          print("AQUI D: 2.8");
          batch.insertAll(SQL.archivoRubro, SerializableConvert.converListSerializeArchivoRubro(rubro["rubroArchivo"]), mode: InsertMode.insertOrReplace);
        }

        if(rubro.containsKey("equipoEvaluacionProceso")){
          batch.insertAll(SQL.equipoEvaluacion, SerializableConvert.converListSerializeEvaluacionEquipo(rubro["equipoEvaluacionProceso"]), mode: InsertMode.insertOrReplace);
        }

        if(rubro.containsKey("rubroEvaluacionProcesoEquipo")){
          batch.insertAll(SQL.rubroEvaluacionProcesoEquipo, SerializableConvert.converListSerializeRubroEvaluacionProcesoEquipo(rubro["rubroEvaluacionProcesoEquipo"]), mode: InsertMode.insertOrReplace);
        }

        if(rubro.containsKey("rubroEvaluacionProcesoIntegrante")){
          batch.insertAll(SQL.rubroEvaluacionProcesoIntegrante, SerializableConvert.converListSerializeRubroEvaluacionProcesoIntegrante(rubro["rubroEvaluacionProcesoIntegrante"]), mode: InsertMode.insertOrReplace);
        }
        print("AQUI D: 3");

      });
    });

  }

  @override
  Future<List<FormaEvaluacionUi>> getGetFormaEvaluacion() async {
    AppDataBase SQL = AppDataBase();

    var query = SQL.select(SQL.tiposRubro)..where((tbl) => tbl.concepto.equals("Forma Evaluacion"));
    query.where((tbl) => tbl.objeto.equals("T_RN_MAE_RUBRO_EVALUACION_PROCESO"));
    List<TiposRubroData> formaEvaluacionData =  await query.get();
    List<FormaEvaluacionUi> formaEvaluacionUiList = [];
    for(TiposRubroData tipoRubroData in formaEvaluacionData){
      FormaEvaluacionUi formaEvaluacionUi = FormaEvaluacionUi();
      formaEvaluacionUi.id = tipoRubroData.tipoId;
      formaEvaluacionUi.nombre = tipoRubroData.nombre;
      formaEvaluacionUi.grupal = (tipoRubroData.tipoId ==FORMA_EVAL_GRUPAL);
      formaEvaluacionUiList.add(formaEvaluacionUi);
    }
    return formaEvaluacionUiList;
  }

  @override
  Future<List<TipoEvaluacionUi>> getGetTipoEvaluacion() async{
    AppDataBase SQL = AppDataBase();
   List<TipoEvaluacionUi> tipoEvaluacionUiList = [];
    List<TipoEvaluacionRubroData> tipoEvaluacionRubroDataList =  await SQL.select(SQL.tipoEvaluacionRubro).get();
    for(TipoEvaluacionRubroData tipoEvaluacionRubroData in tipoEvaluacionRubroDataList){
      TipoEvaluacionUi tipoEvaluacionUi = TipoEvaluacionUi();
      tipoEvaluacionUi.id= tipoEvaluacionRubroData.tipoEvaluacionId;
      tipoEvaluacionUi.nombre = tipoEvaluacionRubroData.nombre;
      tipoEvaluacionUiList.add(tipoEvaluacionUi);
    }
    return tipoEvaluacionUiList;
  }

  @override
  Future<List<TipoNotaUi>> getGetTipoNota(int programaEducativoId) async{
    AppDataBase SQL = AppDataBase();
    List<TipoNotaUi> tipoNotaUiList = [];

    var query = SQL.select(SQL.tipoNotaRubro)..where((tbl) => tbl.programaEducativoId.equals(programaEducativoId));
    query.where((tbl) => tbl.tipoId.isNotIn([TN_VALOR_ASISTENCIA]));
    //query.where((tbl) => tbl.silaboEventoId.isNotIn([0]));
    query.orderBy([(tbl)=> OrderingTerm.desc(tbl.tipoNotaId),
            (tbl)=> OrderingTerm.desc(tbl.nombre)]);
    List<TipoNotaRubroData> tipoNotaList = await query.get();
    for(TipoNotaRubroData tipoNotaRubroData in tipoNotaList){

      TipoNotaUi tipoNotaUi = convertTipoNotaUi(tipoNotaRubroData);

        List<ValorTipoNotaUi> valorTipoNotaUiList = [];
        List<ValorTipoNotaRubroData> valorTipoNotaRubroList = await (SQL.select(SQL.valorTipoNotaRubro)..where((tbl) => tbl.tipoNotaId.equals(tipoNotaRubroData.tipoNotaId))).get();
        valorTipoNotaRubroList.sort((a, b) => (b.valorNumerico??0).compareTo(a.valorNumerico??0));

        for(ValorTipoNotaRubroData valorTipoNotaRubroData in valorTipoNotaRubroList){
          ValorTipoNotaUi valorTipoNotaUi = convertValorTipoNotaUi(valorTipoNotaRubroData);
          valorTipoNotaUi.tipoNotaUi = tipoNotaUi;
          valorTipoNotaUiList.add(valorTipoNotaUi);
        }

        tipoNotaUi.valorTipoNotaList = valorTipoNotaUiList;
        tipoNotaUiList.add(tipoNotaUi);
        tipoNotaUiList.sort((a, b) => (b.valorTipoNotaList??[]).length.compareTo((a.valorTipoNotaList??[]).length));
    }
    return tipoNotaUiList;

  }

  TipoNotaUi convertTipoNotaUi(TipoNotaRubroData? tipoNotaRubroData){
    TipoNotaUi tipoNotaUi = TipoNotaUi();
    tipoNotaUi.tipoNotaId = tipoNotaRubroData?.tipoNotaId;
    tipoNotaUi.nombre = tipoNotaRubroData?.nombre;
    tipoNotaUi.escalanombre = tipoNotaRubroData?.escalanombre;
    tipoNotaUi.escalavalorMaximo = tipoNotaRubroData?.escalavalorMaximo;
    tipoNotaUi.escalavalorMinimo = tipoNotaRubroData?.escalavalorMinimo;
    tipoNotaUi.tiponombre = tipoNotaRubroData?.tiponombre;
    tipoNotaUi.tipoId = tipoNotaRubroData?.tipoId;
    tipoNotaUi.intervalo = tipoNotaRubroData?.intervalo;

    switch(tipoNotaRubroData?.tipoId??0){
      case TN_SELECTOR_ICONOS:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_ICONOS;
        break;
      case TN_SELECTOR_NUMERICO:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_NUMERICO;
        break;
      case TN_SELECTOR_VALORES:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_VALORES;
        break;
      case TN_VALOR_NUMERICO:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.VALOR_NUMERICO;
        break;
      case TN_VALOR_ASISTENCIA:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.VALOR_ASISTENCIA;
        break;
    }
    return tipoNotaUi;
  }

  ValorTipoNotaUi convertValorTipoNotaUi(ValorTipoNotaRubroData? valorTipoNotaRubroData){
    ValorTipoNotaUi valorTipoNotaUi = ValorTipoNotaUi();
    valorTipoNotaUi.valorTipoNotaId = valorTipoNotaRubroData?.valorTipoNotaId;
    valorTipoNotaUi.titulo = valorTipoNotaRubroData?.titulo;
    valorTipoNotaUi.alias = valorTipoNotaRubroData?.alias;
    valorTipoNotaUi.icono = valorTipoNotaRubroData?.icono;
    valorTipoNotaUi.incluidoLInferior = valorTipoNotaRubroData?.incluidoLInferior;
    valorTipoNotaUi.incluidoLSuperior = valorTipoNotaRubroData?.incluidoLSuperior;
    valorTipoNotaUi.valorNumerico = valorTipoNotaRubroData?.valorNumerico;
    valorTipoNotaUi.limiteInferior = valorTipoNotaRubroData?.limiteInferior;
    valorTipoNotaUi.limiteSuperior = valorTipoNotaRubroData?.limiteSuperior;


    valorTipoNotaUi.incluidoLInferiorTransf = valorTipoNotaRubroData?.incluidoLInferiorTransf;
    valorTipoNotaUi.incluidoLSuperiorTransf = valorTipoNotaRubroData?.incluidoLSuperiorTransf;
    valorTipoNotaUi.valorNumericoTransf = valorTipoNotaRubroData?.valorNumericoTransf;
    valorTipoNotaUi.limiteInferiorTransf = valorTipoNotaRubroData?.limiteInferiorTransf;
    valorTipoNotaUi.limiteSuperiorTransf = valorTipoNotaRubroData?.limiteSuperiorTransf;
    return valorTipoNotaUi;
  }
  @override
  Future<List<CompetenciaUi>> getTemasCriterios(int? calendarioPeriodoId, int? silaboEventoId, int? sesionAprendizajeId) async{
    AppDataBase SQL = AppDataBase();
    var query = SQL.select(SQL.criterio)..where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
    query.where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    if((sesionAprendizajeId??0)>0){
      query.where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId));
    }

    List<CompetenciaUi> competenciaUiList = [];
    //List<CapacidadUi> capacidadUiList = [];
    //List<CriterioUi> criterioUiList = [];

    //List<TemaCriterioUi> padreTemaCriterioDataList = [];
    //List<TemaCriterioUi> temaCriterioDataList = [];

    List<CriterioData> criterioDataList = await query.get();
    for(CriterioData criterioData in criterioDataList){

      CompetenciaUi? competenciaUi = competenciaUiList.firstWhereOrNull((element) => element.competenciaId == criterioData.superCompetenciaId);
      if(competenciaUi==null&& criterioData.superCompetenciaId != 0){
        competenciaUi = CompetenciaUi();
        competenciaUi.capacidadUiList = [];
        competenciaUi.competenciaId = criterioData.superCompetenciaId;
        competenciaUi.nombre = criterioData.superCompetenciaNombre;
        competenciaUi.descripcion = criterioData.superCompetenciaDescripcion;
        competenciaUi.url = criterioData.url;
        competenciaUi.evaluable = criterioData.superCompetenciaEvaluable;
        competenciaUi.rubroResultadoId = criterioData.superCompetenciaResultadoId;
        switch( criterioData.superCompetenciaTipoId??0){
          case COMPETENCIA_BASE:
            competenciaUi.tipoCompetenciaUi = TipoCompetenciaUi.BASE;
            break;
          case COMPETENCIA_ENFQ:
            competenciaUi.tipoCompetenciaUi = TipoCompetenciaUi.ENFOQUE;
            break;
          case COMPETENCIA_TRANS:
            competenciaUi.tipoCompetenciaUi = TipoCompetenciaUi.TRANSVERSAL;
            break;
        }

        competenciaUiList.add(competenciaUi);
      }

      CapacidadUi? capacidadUi = competenciaUi?.capacidadUiList?.firstWhereOrNull((element) => element.capacidadId == criterioData.competenciaId && competenciaUi?.competenciaId == element.competenciaId);
      if(capacidadUi==null && criterioData.competenciaId != 0){
        capacidadUi = CapacidadUi();
        capacidadUi.criterioUiList = [];
        capacidadUi.capacidadId = criterioData.competenciaId;
        capacidadUi.nombre = criterioData.competenciaNombre;
        capacidadUi.descripcion = criterioData.competenciaDescripcion;
        capacidadUi.tipoId = criterioData.competenciaTipoId;
        capacidadUi.competenciaId = criterioData.superCompetenciaId;
        capacidadUi.competenciaUi = competenciaUi;
        capacidadUi.rubroResultadoId = criterioData.competenciaResultadoId;
        capacidadUi.evaluable = criterioData.competenciaEvaluable;
        competenciaUi?.capacidadUiList?.add(capacidadUi);
      }

      CriterioUi? criterioUi = capacidadUi?.criterioUiList?.firstWhereOrNull((element) => element.desempenioIcdId == criterioData.desempenioIcdId);
      if(criterioUi==null && criterioData.desempenioIcdId != 0){

        if((criterioData.icdTitulo??"").trim().isEmpty){
          //print("desempenioIcdId ${criterioData.desempenioIcdId}");
          //print("icdTitulo ${criterioData.icdTitulo}");
          //print("icdId ${criterioData.icdId}");
          //print("capacidad ${criterioData.competenciaId}");
        }
        criterioUi= CriterioUi();
        criterioUi.temaCriterioUiList = [];
        criterioUi.desempenioIcdId = criterioData.desempenioIcdId;
        criterioUi.desempenioId = criterioData.desempenioId;
        criterioUi.icdId = criterioData.icdId;
        criterioUi.desempenioDescripcion = criterioData.DesempenioDescripcion;
        criterioUi.peso = criterioData.peso?.toDouble();
        criterioUi.icdTitulo = criterioData.icdTitulo;
        criterioUi.icdDescripcion = criterioData.icdDescripcion;
        criterioUi.desempenioIcdDescripcion = criterioData.desempenioIcdDescripcion;
        criterioUi.capacidadId = criterioData.competenciaId;
        criterioUi.capacidadUi = capacidadUi;
        criterioUi.tipoId = criterioData.tipoId;
        criterioUi.url = criterioData.url;
        capacidadUi?.criterioUiList?.add(criterioUi);

      }

      if((criterioData.campoTematicoParentId??0) > 0) {
        TemaCriterioUi? padreTemaCriterioUi = criterioUi?.temaCriterioUiList?.firstWhereOrNull((element) => element.campoTematicoId == criterioData.campoTematicoParentId);
        if (padreTemaCriterioUi == null && criterioData.campoTematicoParentId != 0 && criterioData.campoTematicoParentId != null) {
          padreTemaCriterioUi = TemaCriterioUi();
          padreTemaCriterioUi.temaCriterioUiList = [];
          padreTemaCriterioUi.campoTematicoId =
              criterioData.campoTematicoParentId;
          padreTemaCriterioUi.titulo = criterioData.campoTematicoParentTitulo;
          padreTemaCriterioUi.descripcion =
              criterioData.campoTematicoParentDescripcion;
          padreTemaCriterioUi.parentId = criterioData.campoTematicoParentId;
          criterioUi?.temaCriterioUiList?.add(padreTemaCriterioUi);
        }


        TemaCriterioUi? temaCriterioUi = padreTemaCriterioUi?.temaCriterioUiList?.firstWhereOrNull((element) => element.campoTematicoId == criterioData.campoTematicoId);
        if(temaCriterioUi==null && criterioData.campoTematicoId != 0 && criterioData.campoTematicoId != null){
          temaCriterioUi = TemaCriterioUi();
          temaCriterioUi.campoTematicoId = criterioData.campoTematicoId;
          temaCriterioUi.titulo = criterioData.campoTematicoTitulo;
          temaCriterioUi.descripcion = criterioData.campoTematicoDescripcion;
          temaCriterioUi.parentId = criterioData.campoTematicoParentId;
          temaCriterioUi.parent = padreTemaCriterioUi;
          padreTemaCriterioUi?.temaCriterioUiList?.add(temaCriterioUi);
        }

      }else{
        TemaCriterioUi? temaCriterioUi = criterioUi?.temaCriterioUiList?.firstWhereOrNull((element) => element.campoTematicoId == criterioData.campoTematicoId);
        if(temaCriterioUi==null && criterioData.campoTematicoId != 0 && criterioData.campoTematicoId != null){
          temaCriterioUi = TemaCriterioUi();
          temaCriterioUi.campoTematicoId = criterioData.campoTematicoId;
          temaCriterioUi.titulo = criterioData.campoTematicoTitulo;
          temaCriterioUi.descripcion = criterioData.campoTematicoDescripcion;
          temaCriterioUi.parentId = criterioData.campoTematicoParentId;
          criterioUi?.temaCriterioUiList?.add(temaCriterioUi);
        }
      }

    }

   // //print("competenciaUiList size "+competenciaUiList.length.toString());
    return competenciaUiList;
  }

  @override
  Future<void> saveRubroEvaluacionData(Map<String, dynamic> rubroEvaluacionData) async {
    //print("saveRubroEvaluacionData");
    AppDataBase SQL = AppDataBase();
    //= await getRubroEvaluacionData(rubricaEvaluacionUi, usuarioId);

    print("saveRubroEvaluacionData 2 ${rubroEvaluacionData.containsKey("rubroEvaluacionProceso")}");

    await SQL.batch((batch) async {


      print("saveRubroEvaluacionData 2 ${rubroEvaluacionData["rubroEvaluacionProceso"]}");
      if(rubroEvaluacionData["rubroEvaluacionProceso"] != null){
        print("save rubroEvaluacionProceso");
        batch.insert(
            SQL.rubroEvaluacionProceso, rubroEvaluacionData["rubroEvaluacionProceso"], mode: InsertMode.insertOrReplace);
      }

      for (var o in rubroEvaluacionData["rubroEvaluacionAsociado"] ?? []) {
        batch.insert(
            SQL.rubroEvaluacionProceso, o, mode: InsertMode.insertOrReplace);
      }

      for (var o in rubroEvaluacionData["evaluacionProceso"] ?? []) {

        for(var item in rubroEvaluacionData["evaluacionProceso"]??[]){
          print("save evaluacionProceso ${ item.valorTipoNotaId }");

        }
        batch.insert(
            SQL.evaluacionProceso, o, mode: InsertMode.insertOrReplace);
      }

      for (var o in rubroEvaluacionData["rubroEvalRNPFormula"] ?? []) {
        batch.insert(
            SQL.rubroEvalRNPFormula, o, mode: InsertMode.insertOrReplace);
      }

      for (var o in rubroEvaluacionData["criterioRubroEvaluacion"] ?? []) {
        batch.insert(
            SQL.criterioRubroEvaluacion, o, mode: InsertMode.insertOrReplace);
      }

      for (var o in rubroEvaluacionData["rubroCampotematico"] ?? []) {
        batch.insert(
            SQL.rubroCampotematico, o, mode: InsertMode.insertOrReplace);
      }

      for (var o in rubroEvaluacionData["rubroEvaluacionProcesoEquipo"] ?? []) {
        batch.insert(
            SQL.rubroEvaluacionProcesoEquipo, o, mode: InsertMode.insertOrReplace);
      }

      for (var o in rubroEvaluacionData["rubroEvaluacionProcesoIntegrante"] ?? []) {
        batch.insert(
            SQL.rubroEvaluacionProcesoIntegrante, o, mode: InsertMode.insertOrReplace);
      }

      for (var o in rubroEvaluacionData["equipoEvaluacion"] ?? []) {
        batch.insert(
            SQL.equipoEvaluacion, o, mode: InsertMode.insertOrReplace);
      }

      //List<RubroCampotematicoData> rubroCampotematicoDataList = await (SQL.select(SQL.rubroCampotematico)..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdEvaluacionList))).get();
      //List<RubroComentarioData> rubroComentarioList = await (SQL.select(SQL.rubroComentario)..where((tbl) => tbl.evaluacionProcesoId.isIn(evaluacionIdList))).get();
      //List<ArchivoRubroData> archivoRubroDataList = await (SQL.select(SQL.archivoRubro)..where((tbl) => tbl.evaluacionProcesoId.isIn(evaluacionIdList))).get();
    });

  }
  @override
  Future<Map<String,dynamic>> createRubroEvaluacionData(RubricaEvaluacionUi? rubricaEvaluacionUi, int? usuarioId) async{
    AppDataBase SQL = AppDataBase();
    Map<String,dynamic> rubroEvaluacionData = Map();
    rubroEvaluacionData["rubroEvaluacionProceso"] = null;
    rubroEvaluacionData["rubroEvaluacionAsociado"] = [];
    rubroEvaluacionData["evaluacionProceso"] = [];
    rubroEvaluacionData["rubroEvalRNPFormula"] = [];
    rubroEvaluacionData["criterioRubroEvaluacion"] = [];
    rubroEvaluacionData["rubroCampotematico"] = [];
    rubroEvaluacionData["rubroCampotematico"] = [];
    rubroEvaluacionData["rubroEvaluacionProcesoEquipo"] = [];
    rubroEvaluacionData["rubroEvaluacionProcesoIntegrante"] = [];
    rubroEvaluacionData["equipoEvaluacion"] = [];
    List<ContactoDocenteData> alumnoList = [];

    //print("createRubroEvaluacionData ${rubricaEvaluacionUi?.sesionAprendizajeId}");

    if(rubricaEvaluacionUi?.formaEvaluacionId != FORMA_EVAL_GRUPAL) {
      var query = SQL.select(SQL.contactoDocente)
        ..where((tbl) => tbl.cargaCursoId.equals(rubricaEvaluacionUi?.cargaCursoId));
      query.where((tbl) => tbl.tipo.equals(1));
      query.where((tbl) => tbl.contratoVigente.equals(true));
      alumnoList = await query.get();
    }

    //rubroEvaluacionId = IdGenerator.generateId();
    RubroEvaluacionProcesoData rubroEvaluacionProceso = RubroEvaluacionProcesoData(
      rubroEvalProcesoId: rubricaEvaluacionUi?.rubroEvaluacionId??"",
      titulo: rubricaEvaluacionUi?.titulo,
      subtitulo: "",
      tiporubroid: TIPO_RUBRO_BIMENSIONAL,
      calendarioPeriodoId: rubricaEvaluacionUi?.calendarioPeriodoId,
      competenciaId: 0,
      sesionAprendizajeId: rubricaEvaluacionUi?.sesionAprendizajeId,
      tipoNotaId: rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaId,
      formaEvaluacionId: rubricaEvaluacionUi?.formaEvaluacionId,
      tipoEvaluacionId: rubricaEvaluacionUi?.tipoEvaluacionId,
      silaboEventoId: rubricaEvaluacionUi?.silaboEventoId,
      estadoId: RubroRepository.ESTADO_CREADO,
      syncFlag: EstadoSync.FLAG_ADDED,
      countIndicador: rubricaEvaluacionUi?.criterioPesoUiList?.length,
      estrategiaEvaluacionId: 0,
      anchoColumna: "",
      colorFondo: "",
      tipoFormulaId: 0,
      //estrategiaEvaluacionId: Falta
      tareaId: rubricaEvaluacionUi?.tareaUi?.tareaId,
      fechaCreacion: DateTime.now(),
      fechaAccion: DateTime.now(),
      usuarioAccionId: usuarioId,
      usuarioCreacionId: usuarioId,
    );
    rubroEvaluacionData["rubroEvaluacionProceso"] = rubroEvaluacionProceso;

    if(rubricaEvaluacionUi?.formaEvaluacionId != FORMA_EVAL_GRUPAL){
      for(ContactoDocenteData alumno in alumnoList){
        EvaluacionProcesoData evaluacionProceso = EvaluacionProcesoData(
          evaluacionProcesoId: IdGenerator.generateId(),
          rubroEvalProcesoId: rubricaEvaluacionUi?.rubroEvaluacionId,
          alumnoId: alumno.personaId,
          syncFlag: EstadoSync.FLAG_ADDED,
          fechaCreacion: DateTime.now(),
          fechaAccion: DateTime.now(),
          usuarioAccionId: usuarioId,
          usuarioCreacionId: usuarioId,
        );
        rubroEvaluacionData["evaluacionProceso"]?.add(evaluacionProceso);
      }


    }else{

      for(GrupoUi grupoUi in rubricaEvaluacionUi?.grupoUiList??[]){
        if((grupoUi.equipoId??"").isEmpty)continue;
        String rubroEvaluacionEquipoId = IdGenerator.generateId();
        RubroEvaluacionProcesoEquipoData rubroEvaluacionProcesoEquipoData = RubroEvaluacionProcesoEquipoData(
            rubroEvaluacionEquipoId: rubroEvaluacionEquipoId,
            equipoId: grupoUi.equipoId,
            nombreEquipo: grupoUi.nombre??'',
            orden: grupoUi.posicion,
            rubroEvalProcesoId: rubricaEvaluacionUi?.rubroEvaluacionId??"",
            syncFlag: EstadoSync.FLAG_ADDED,
            fechaCreacion: DateTime.now(),
            fechaAccion: DateTime.now(),
            usuarioAccionId: usuarioId,
            usuarioCreacionId: usuarioId,
        );

        rubroEvaluacionData["rubroEvaluacionProcesoEquipo"]?.add(rubroEvaluacionProcesoEquipoData);

        EquipoEvaluacionData equipoEvaluacion = EquipoEvaluacionData(
            equipoEvaluacionProcesoId: IdGenerator.generateId(),
            equipoId: rubroEvaluacionEquipoId,
            rubroEvalProcesoId: rubricaEvaluacionUi?.rubroEvaluacionId??"",
            sesionAprendizajeId: rubricaEvaluacionUi?.sesionAprendizajeId,
            fechaCreacion: DateTime.now(),
            fechaAccion: DateTime.now(),
            usuarioAccionId: usuarioId,
            usuarioCreacionId: usuarioId,

        );
        rubroEvaluacionData["equipoEvaluacion"]?.add(equipoEvaluacion);

        for(IntegranteGrupoUi integranteGrupoUi in grupoUi.integranteUiList??[]){
          RubroEvaluacionProcesoIntegranteData rubroEvaluacionProcesoIntegranteData = RubroEvaluacionProcesoIntegranteData(
              personaId: integranteGrupoUi.personaUi?.personaId??0,
              rubroEvaluacionEquipoId: rubroEvaluacionEquipoId,
              syncFlag: EstadoSync.FLAG_ADDED,
              fechaCreacion: DateTime.now(),
              fechaAccion: DateTime.now(),
              usuarioAccionId: usuarioId,
              usuarioCreacionId: usuarioId,
          );

          rubroEvaluacionData["rubroEvaluacionProcesoIntegrante"]?.add(rubroEvaluacionProcesoIntegranteData);

          EvaluacionProcesoData evaluacionProceso = EvaluacionProcesoData(
            evaluacionProcesoId: IdGenerator.generateId(),
            rubroEvalProcesoId: rubricaEvaluacionUi?.rubroEvaluacionId,
            alumnoId: integranteGrupoUi.personaUi?.personaId,
            equipoId: rubroEvaluacionEquipoId,
            syncFlag: EstadoSync.FLAG_ADDED,
            fechaCreacion: DateTime.now(),
            fechaAccion: DateTime.now(),
            usuarioAccionId: usuarioId,
            usuarioCreacionId: usuarioId,
          );
          rubroEvaluacionData["evaluacionProceso"]?.add(evaluacionProceso);

        }
      }

    }

    for(CriterioPesoUi criterioPesoUi in rubricaEvaluacionUi?.criterioPesoUiList??[]){

      CapacidadUi? capacidadUi = criterioPesoUi.criterioUi?.capacidadUi;

      String rubroEvaluacionDetalleId = IdGenerator.generateId();
      RubroEvaluacionProcesoData procesoDetalle = RubroEvaluacionProcesoData(
        rubroEvalProcesoId: rubroEvaluacionDetalleId,
        titulo: criterioPesoUi.criterioUi?.icdTituloEditado??criterioPesoUi.criterioUi?.icdTitulo??"",
        subtitulo: '',
        desempenioIcdId: criterioPesoUi.criterioUi?.desempenioIcdId,
        tiporubroid: TIPO_RUBRO_BIDIMENCIONAL_DETALLE,
        tipoNotaId: rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaId,
        silaboEventoId: rubricaEvaluacionUi?.silaboEventoId,
        competenciaId: capacidadUi?.capacidadId,
        calendarioPeriodoId: rubricaEvaluacionUi?.calendarioPeriodoId,
        sesionAprendizajeId: rubricaEvaluacionUi?.sesionAprendizajeId,
        tipoEvaluacionId: rubricaEvaluacionUi?.tipoEvaluacionId,
        formaEvaluacionId: rubricaEvaluacionUi?.formaEvaluacionId,
        tareaId: rubricaEvaluacionUi?.tareaUi?.tareaId,
        estadoId: RubroRepository.ESTADO_CREADO,
        rubroFormal: capacidadUi?.tipoId == COMPETENCIA_BASE? 1:0,
        syncFlag: EstadoSync.FLAG_ADDED,
        fechaCreacion: DateTime.now(),
        fechaAccion: DateTime.now(),
        usuarioAccionId: usuarioId,
        usuarioCreacionId: usuarioId,
        tipoFormulaId: 0,
      );
      rubroEvaluacionData["rubroEvaluacionAsociado"]?.add(procesoDetalle);
      //batch.insert(SQL.rubroEvaluacionProceso, procesoDetalle, mode: InsertMode.insertOrReplace);

      if(rubricaEvaluacionUi?.formaEvaluacionId != FORMA_EVAL_GRUPAL){

        for(ContactoDocenteData alumno in alumnoList){
          EvaluacionProcesoData evaluacionProceso = EvaluacionProcesoData(
            evaluacionProcesoId: IdGenerator.generateId(),
            rubroEvalProcesoId: rubroEvaluacionDetalleId,
            alumnoId: alumno.personaId,
            nombres: alumno.nombres,
            apellidoMaterno: alumno.apellidoMaterno,
            apellidoPaterno: alumno.apellidoPaterno,
            foto: alumno.foto,
            syncFlag: EstadoSync.FLAG_ADDED,
            fechaCreacion: DateTime.now(),
            fechaAccion: DateTime.now(),
            usuarioAccionId: usuarioId,
            usuarioCreacionId: usuarioId,
          );
          rubroEvaluacionData["evaluacionProceso"]?.add(evaluacionProceso);
          //batch.insert(SQL.evaluacionProceso, evaluacionProceso, mode: InsertMode.insertOrReplace);
        }

      }else{

        for(GrupoUi grupoUi in rubricaEvaluacionUi?.grupoUiList??[]){
          if((grupoUi.equipoId??"").isEmpty)continue;
          String rubroEvaluacionEquipoId = IdGenerator.generateId();
          RubroEvaluacionProcesoEquipoData rubroEvaluacionProcesoEquipoData = RubroEvaluacionProcesoEquipoData(
            rubroEvaluacionEquipoId: rubroEvaluacionEquipoId,
            equipoId: grupoUi.equipoId,
            nombreEquipo: grupoUi.nombre??'',
            orden: grupoUi.posicion,
            rubroEvalProcesoId: rubroEvaluacionDetalleId,
            syncFlag: EstadoSync.FLAG_ADDED,
            fechaCreacion: DateTime.now(),
            fechaAccion: DateTime.now(),
            usuarioAccionId: usuarioId,
            usuarioCreacionId: usuarioId,
          );

          rubroEvaluacionData["rubroEvaluacionProcesoEquipo"]?.add(rubroEvaluacionProcesoEquipoData);

          EquipoEvaluacionData equipoEvaluacion = EquipoEvaluacionData(
            equipoEvaluacionProcesoId: IdGenerator.generateId(),
            equipoId: rubroEvaluacionEquipoId,
            rubroEvalProcesoId: rubroEvaluacionDetalleId,
            sesionAprendizajeId: rubricaEvaluacionUi?.sesionAprendizajeId,
            fechaCreacion: DateTime.now(),
            fechaAccion: DateTime.now(),
            usuarioAccionId: usuarioId,
            usuarioCreacionId: usuarioId,

          );
          rubroEvaluacionData["equipoEvaluacion"]?.add(equipoEvaluacion);

          for(IntegranteGrupoUi integranteGrupoUi in grupoUi.integranteUiList??[]){
            RubroEvaluacionProcesoIntegranteData rubroEvaluacionProcesoIntegranteData = RubroEvaluacionProcesoIntegranteData(
              personaId: integranteGrupoUi.personaUi?.personaId??0,
              rubroEvaluacionEquipoId: rubroEvaluacionEquipoId,
              syncFlag: EstadoSync.FLAG_ADDED,
              fechaCreacion: DateTime.now(),
              fechaAccion: DateTime.now(),
              usuarioAccionId: usuarioId,
              usuarioCreacionId: usuarioId,
            );
            rubroEvaluacionData["rubroEvaluacionProcesoIntegrante"]?.add(rubroEvaluacionProcesoIntegranteData);
            EvaluacionProcesoData evaluacionProceso = EvaluacionProcesoData(
              evaluacionProcesoId: IdGenerator.generateId(),
              rubroEvalProcesoId: rubroEvaluacionDetalleId,
              alumnoId: integranteGrupoUi.personaUi?.personaId,
              nombres: integranteGrupoUi.personaUi?.nombres,
              equipoId: rubroEvaluacionEquipoId,
              apellidoMaterno: integranteGrupoUi.personaUi?.apellidoMaterno,
              apellidoPaterno: integranteGrupoUi.personaUi?.apellidoPaterno,
              foto: integranteGrupoUi.personaUi?.foto,
              syncFlag: EstadoSync.FLAG_ADDED,
              fechaCreacion: DateTime.now(),
              fechaAccion: DateTime.now(),
              usuarioAccionId: usuarioId,
              usuarioCreacionId: usuarioId,
            );
            rubroEvaluacionData["evaluacionProceso"]?.add(evaluacionProceso);

          }
        }
      }


      double? peso = criterioPesoUi.criterioUi?.peso;

      RubroEvalRNPFormulaData rubroEvalRNPFormula = RubroEvalRNPFormulaData(
        rubroFormulaId: IdGenerator.generateId(),
        rubroEvaluacionPrimId: rubricaEvaluacionUi?.rubroEvaluacionId,
        rubroEvaluacionSecId: rubroEvaluacionDetalleId,
        peso: peso?.toDouble(),
        syncFlag: EstadoSync.FLAG_ADDED,
        fechaCreacion: DateTime.now(),
        fechaAccion: DateTime.now(),
        usuarioAccionId: usuarioId,
        usuarioCreacionId: usuarioId,
      );
      rubroEvaluacionData["rubroEvalRNPFormula"]?.add(rubroEvalRNPFormula);
      //batch.insert(SQL.rubroEvalRNPFormula, rubroEvalRNPFormula, mode: InsertMode.insertOrReplace);

      for(CriterioValorTipoNotaUi criterioValorTipoNotaUi in rubricaEvaluacionUi?.criterioValorTipoNotaUiList??[]){
        if(criterioValorTipoNotaUi.criterioUi?.desempenioIcdId == criterioPesoUi.criterioUi?.desempenioIcdId){
          CriterioRubroEvaluacionData criterioRubroEvaluacionData = CriterioRubroEvaluacionData(
              criteriosEvaluacionId: IdGenerator.generateId(),
              rubroEvalProcesoId: rubroEvaluacionDetalleId,
              valorTipoNotaId: criterioValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId,
              descripcion: "");
          rubroEvaluacionData["criterioRubroEvaluacion"]?.add(criterioRubroEvaluacionData);
          //batch.insert(SQL.criterioRubroEvaluacion, criterioRubroEvaluacionData);
        }
      }

      List<TemaCriterioUi> temaCriterioUiList = [];
      for(TemaCriterioUi temaCriterioUi in criterioPesoUi.criterioUi?.temaCriterioUiList??[]){
        if((temaCriterioUi.temaCriterioUiList??[]).isEmpty && (temaCriterioUi.toogle??false))temaCriterioUiList.add(temaCriterioUi);
        for(TemaCriterioUi subtemaCriterioUi in temaCriterioUi.temaCriterioUiList??[]){
          if(subtemaCriterioUi.toogle??false)temaCriterioUiList.add(subtemaCriterioUi);
        }
      }

      for(TemaCriterioUi temaCriterioUi in temaCriterioUiList){
        if(temaCriterioUi.toogle??false){
          RubroCampotematicoData rubroCampotematicoData = RubroCampotematicoData(
            rubroEvalProcesoId: rubroEvaluacionDetalleId,
            campoTematicoId: temaCriterioUi.campoTematicoId??0,
            syncFlag: EstadoSync.FLAG_ADDED,
            fechaCreacion: DateTime.now(),
            fechaAccion: DateTime.now(),
            usuarioAccionId: usuarioId,
            usuarioCreacionId: usuarioId,
          );
          rubroEvaluacionData["rubroCampotematico"]?.add(rubroCampotematicoData);
          //batch.insert(SQL.rubroCampotematico, rubroCampotematicoData, mode: InsertMode.insertOrReplace);
        }
      }
    }

    return rubroEvaluacionData;
  }
  /* transformacion Serial estos metodos en lo posible deben de enviar la misma información*/

  @override
  Future<Map<String,dynamic>> getRubroEvaluacionSerial(Map<String, dynamic> rubroEvaluacionData) async {
    //= await getRubroEvaluacionData(rubricaEvaluacionUi, usuarioId);
    print("rubroEvaluacionData: ${rubroEvaluacionData}");
    Map<String, dynamic> bERubroEvalEnvioSimple = new Map<String, dynamic>();

    bERubroEvalEnvioSimple["rubroEvaluacionProceso"] = DataConvert.converRubroEvaluacionProceso(rubroEvaluacionData["rubroEvaluacionProceso"]);
    bERubroEvalEnvioSimple["rubroEvaluacionAsociado"] = DataConvert.converListRubroEvaluacionProceso(rubroEvaluacionData["rubroEvaluacionAsociado"]??[]);
    bERubroEvalEnvioSimple["rubroEvalProcesoFormula"] = DataConvert.converListSerializeRubroEvalRNPFormula(rubroEvaluacionData["rubroEvalRNPFormula"]??[]);
    bERubroEvalEnvioSimple["evaluacionProceso"] = DataConvert.converListEvaluacionProceso(rubroEvaluacionData["evaluacionProceso"]??[]);
    bERubroEvalEnvioSimple["rubro_evaluacion_proceso_campotematico"] = DataConvert.converListRubroCampotematico(rubroEvaluacionData["rubroCampotematico"]??[]);
    //bERubroEvalEnvioSimple["obtenerCriterioRubroEvaluacionProceso"] = DataConvert.converListRubroCampotematico(rubroCampotematicoDataList);
    bERubroEvalEnvioSimple["rubroEvaluacionProcesoComentario"] = DataConvert.converListSerializeRubroComentario(rubroEvaluacionData["rubroComentario"]??[]);
    bERubroEvalEnvioSimple["ArchivoRubroData"] = DataConvert.converListSerializeArchivoRubro(rubroEvaluacionData["archivoRubro"]??[]);

    bERubroEvalEnvioSimple["ObtenerRubroEvaluacionProcesoEquipo"] = DataConvert.converListSerializeEvaluacionProcesoEquipo(rubroEvaluacionData["rubroEvaluacionProcesoEquipo"]??[]);
    bERubroEvalEnvioSimple["ObtenerRubroEvaluacionProcesoIntegrante"] = DataConvert.converListSerializeEvaluacionProcesoIntegrante(rubroEvaluacionData["rubroEvaluacionProcesoIntegrante"]??[]);
    bERubroEvalEnvioSimple["obtenerEquipoEvaluacionProceso"] = DataConvert.converListSerializeEquipoEvaluacion(rubroEvaluacionData["equipoEvaluacion"]??[]);

    return bERubroEvalEnvioSimple;

  }

  Future<Map<String, dynamic>> transformarRubroEvaluacionDataToSerial(AppDataBase SQL, RubroEvaluacionProcesoData rubroEvaluacionProcesoData) async{

    Map<String, dynamic> bERubroEvalEnvioSimple = new Map<String, dynamic>();
    List<RubroEvaluacionProcesoData> rubroEvaluacionDataList = [];
    List<RubroEvalRNPFormulaData> rubroFormulaDataList = [];
    List<String> rubroEvaluacionIdEvaluacionList = [];

    rubroEvaluacionIdEvaluacionList.add(rubroEvaluacionProcesoData.rubroEvalProcesoId);
    if(rubroEvaluacionProcesoData.tiporubroid == TIPO_RUBRO_BIMENSIONAL){
      var queryRubroDetalle = SQL.select(SQL.rubroEvaluacionProceso).join([
        innerJoin(SQL.rubroEvalRNPFormula, SQL.rubroEvalRNPFormula.rubroEvaluacionSecId.equalsExp(SQL.rubroEvaluacionProceso.rubroEvalProcesoId))
      ]);
      queryRubroDetalle.where(SQL.rubroEvalRNPFormula.rubroEvaluacionPrimId.equals(rubroEvaluacionProcesoData.rubroEvalProcesoId));

      for(var row in await queryRubroDetalle.get()){
        RubroEvaluacionProcesoData rubroEvaluacionProcesoData = row.readTable(SQL.rubroEvaluacionProceso);
        //print("transformarEvaluaciones: ${rubroEvaluacionProcesoData.rubroEvalProcesoId}");
        //print("transformarEvaluaciones: ${rubroEvaluacionProcesoData.titulo}");
        //print("transformarEvaluaciones: ${rubroEvaluacionProcesoData.peso}");
        rubroEvaluacionDataList.add(rubroEvaluacionProcesoData);
        rubroEvaluacionIdEvaluacionList.add(rubroEvaluacionProcesoData.rubroEvalProcesoId);
        rubroFormulaDataList.add(row.readTable(SQL.rubroEvalRNPFormula));
      }
    }

    List<EvaluacionProcesoData> evaluacionProcesoDataList = await (SQL.select(SQL.evaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdEvaluacionList))).get();
    /*for(var evalaucionUi in evaluacionProcesoDataList){
      if(evalaucionUi.evaluacionProcesoId!=null)evaluacionIdList.add(evalaucionUi.evaluacionProcesoId);
    }*/
   var queryEvaluacion = SQL.selectOnly(SQL.evaluacionProceso)
      ..addColumns([SQL.evaluacionProceso.evaluacionProcesoId]);
    queryEvaluacion.where(SQL.evaluacionProceso.rubroEvalProcesoId.isIn(rubroEvaluacionIdEvaluacionList));

    List<RubroCampotematicoData> rubroCampotematicoDataList = await (SQL.select(SQL.rubroCampotematico)..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdEvaluacionList))).get();
    List<RubroComentarioData> rubroComentarioList = await (SQL.select(SQL.rubroComentario)..where((tbl) => tbl.evaluacionProcesoId.isInQuery(queryEvaluacion))).get();
    print("rubroComentarioList: leng ${rubroComentarioList.length}");
    List<ArchivoRubroData> archivoRubroDataList = await (SQL.select(SQL.archivoRubro)..where((tbl) => tbl.evaluacionProcesoId.isInQuery(queryEvaluacion))).get();
    bERubroEvalEnvioSimple["rubroEvaluacionProceso"] = DataConvert.converRubroEvaluacionProceso(rubroEvaluacionProcesoData);
    bERubroEvalEnvioSimple["rubroEvaluacionAsociado"] = DataConvert.converListRubroEvaluacionProceso(rubroEvaluacionDataList);
    bERubroEvalEnvioSimple["rubroEvalProcesoFormula"] = DataConvert.converListSerializeRubroEvalRNPFormula(rubroFormulaDataList);
    bERubroEvalEnvioSimple["evaluacionProceso"] = DataConvert.converListEvaluacionProceso(evaluacionProcesoDataList);
    bERubroEvalEnvioSimple["rubro_evaluacion_proceso_campotematico"] = DataConvert.converListRubroCampotematico(rubroCampotematicoDataList);
    //bERubroEvalEnvioSimple["obtenerCriterioRubroEvaluacionProceso"] = DataConvert.converListRubroCampotematico(rubroCampotematicoDataList);
    bERubroEvalEnvioSimple["rubroEvaluacionProcesoComentario"] = DataConvert.converListSerializeRubroComentario(rubroComentarioList);
    bERubroEvalEnvioSimple["archivoRubroProceso"] = DataConvert.converListSerializeArchivoRubro(archivoRubroDataList);

    List<RubroEvaluacionProcesoEquipoData> rubroEvaluacionProcesoEquipoDataList = [];
    List<RubroEvaluacionProcesoIntegranteData> rubroEvaluacionProcesoIntegranteDataList = [];
    var queryGrupos = SQL.select(SQL.rubroEvaluacionProcesoIntegrante).join([
      innerJoin(SQL.rubroEvaluacionProcesoEquipo, SQL.rubroEvaluacionProcesoEquipo.rubroEvaluacionEquipoId.equalsExp(SQL.rubroEvaluacionProcesoIntegrante.rubroEvaluacionEquipoId)),
    ]);
    queryGrupos.where(SQL.rubroEvaluacionProcesoEquipo.rubroEvalProcesoId.isIn(rubroEvaluacionIdEvaluacionList));

    for(var row in await queryGrupos.get()){
      RubroEvaluacionProcesoEquipoData rubroEvaluacionProcesoEquipoData =  row.readTable(SQL.rubroEvaluacionProcesoEquipo);
      RubroEvaluacionProcesoIntegranteData rubroEvaluacionProcesoIntegranteData = row.readTable(SQL.rubroEvaluacionProcesoIntegrante);
      RubroEvaluacionProcesoEquipoData? search = rubroEvaluacionProcesoEquipoDataList.firstWhereOrNull((element) => element.rubroEvaluacionEquipoId == rubroEvaluacionProcesoEquipoData.rubroEvaluacionEquipoId);
      if(search==null){
        rubroEvaluacionProcesoEquipoDataList.add(rubroEvaluacionProcesoEquipoData);
      }
      rubroEvaluacionProcesoIntegranteDataList.add(rubroEvaluacionProcesoIntegranteData);
    }

    List<EquipoEvaluacionData> equipoEvaluacionList =  await (SQL.select(SQL.equipoEvaluacion)
      ..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdEvaluacionList))).get();

    bERubroEvalEnvioSimple["ObtenerRubroEvaluacionProcesoEquipo"] = DataConvert.converListSerializeEvaluacionProcesoEquipo(rubroEvaluacionProcesoEquipoDataList);
    bERubroEvalEnvioSimple["ObtenerRubroEvaluacionProcesoIntegrante"] = DataConvert.converListSerializeEvaluacionProcesoIntegrante(rubroEvaluacionProcesoIntegranteDataList);
    bERubroEvalEnvioSimple["obtenerEquipoEvaluacionProceso"] = DataConvert.converListSerializeEquipoEvaluacion(equipoEvaluacionList);


    return bERubroEvalEnvioSimple;
  }

  @override
  Future<Map<String, dynamic>?> getRubroEvaluacionIdSerial(String? rubroEvaluacionId) async {
    AppDataBase SQL = AppDataBase();
    //print("getRubroEvaluacionSerial: ${rubroEvaluacionId} as");
    RubroEvaluacionProcesoData? rubroEvaluacionProcesoData = await (SQL.selectSingle(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.equals(rubroEvaluacionId)))
        .getSingleOrNull();
    if(rubroEvaluacionProcesoData != null){
      return transformarRubroEvaluacionDataToSerial(SQL, rubroEvaluacionProcesoData);
    }else{
      return null;
    }
  }

  /*    transformacion Serial           */
  @override
  Future<void> eliminarEvalQueNoSeExportaron(String? rubroEvaluacionId) async {

    AppDataBase SQL = AppDataBase();

    List<String> rubroEvaluacionIdList = [];
    rubroEvaluacionIdList.add(rubroEvaluacionId??"");

    List<RubroEvalRNPFormulaData> RubroEvalRNPFormulaList = await(SQL.select(SQL.rubroEvalRNPFormula)..where((tbl) => tbl.rubroEvaluacionPrimId.equals(rubroEvaluacionId))).get();

    for(var row in RubroEvalRNPFormulaList){
      rubroEvaluacionIdList.add(row.rubroEvaluacionSecId??"");
    }

    await (SQL.delete(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdList))).go();
    await (SQL.delete(SQL.evaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdList))).go();
    await (SQL.delete(SQL.rubroCampotematico)..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdList))).go();
    await (SQL.delete(SQL.criterioRubroEvaluacion)..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdList))).go();

  }

  @override
  Future<List<RubricaEvaluacionUi>> getRubroEvaluacionList(int calendarioPeriodoId, int silaboEventoId, OrigenRubroUi origenRubroUi) async {
    AppDataBase SQL = AppDataBase();
    var query = SQL.select(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
    query.where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    query.where((tbl) => tbl.tiporubroid.isIn([TIPO_RUBRO_BIMENSIONAL, TIPO_RUBRO_UNIDIMENCIONAL]));
    //query.where((tbl) => tbl.tipoFormulaId.isNull());
    //query.where((tbl) => tbl.tipoFormulaId.equals(0));
    query.where((tbl) => tbl.estadoId.isNotIn([RubroRepository.ESTADO_ELIMINADO]));
    query.orderBy([(tbl)=> OrderingTerm.desc(tbl.fechaCreacion)]);

    List<String> rubricaIdList =[];
    List<RubricaEvaluacionUi> rubricaEvalProcesoUiList = [];
    List<RubroEvaluacionProcesoData> rubroEvalProcesoList = await query.get();
    for(RubroEvaluacionProcesoData rubroEvaluacionProcesoData in  rubroEvalProcesoList){
      if((rubroEvaluacionProcesoData.tipoFormulaId??0)!=0)continue;
      RubricaEvaluacionUi rubricaEvaluacionUi = convertRubricaEvaluacionUi(rubroEvaluacionProcesoData, 0.0);

      if(origenRubroUi == OrigenRubroUi.TODOS){
        rubricaIdList.add(rubroEvaluacionProcesoData.rubroEvalProcesoId);
        rubricaEvalProcesoUiList.add(rubricaEvaluacionUi);
      }else if(origenRubroUi == rubricaEvaluacionUi.origenRubroUi){
        rubricaIdList.add(rubroEvaluacionProcesoData.rubroEvalProcesoId);
        rubricaEvalProcesoUiList.add(rubricaEvaluacionUi);
      }
    }

    var queryEval = SQL.select(SQL.evaluacionProceso).join([
        innerJoin(SQL.rubroEvaluacionProceso, SQL.evaluacionProceso.rubroEvalProcesoId.equalsExp(SQL.rubroEvaluacionProceso.rubroEvalProcesoId))
    ]);
    queryEval.where(SQL.rubroEvaluacionProceso.silaboEventoId.equals(silaboEventoId));
    queryEval.where(SQL.rubroEvaluacionProceso.calendarioPeriodoId.equals(calendarioPeriodoId));

    for(var row in await queryEval.get()){
      EvaluacionProcesoData evalRubroEvalProceso = row.readTable(SQL.evaluacionProceso);
      for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvalProcesoUiList){
        if(rubricaEvaluacionUi.rubroEvaluacionId == evalRubroEvalProceso.rubroEvalProcesoId){
          rubricaEvaluacionUi.cantEvaluaciones = (rubricaEvaluacionUi.cantEvaluaciones??0) + 1;
          if((evalRubroEvalProceso.publicado??0) == 1){
            rubricaEvaluacionUi.cantEvalPublicadas = (rubricaEvaluacionUi.cantEvalPublicadas??0) + 1;
          }
        }
      }
    }
    //#region Agregar la cantidad de rubros Asociados
    var queryRubroDetalle = SQL.select(SQL.rubroEvalRNPFormula).join([
      innerJoin(SQL.rubroEvaluacionProceso, SQL.rubroEvalRNPFormula.rubroEvaluacionSecId.equalsExp(SQL.rubroEvaluacionProceso.rubroEvalProcesoId))
    ]);
    queryRubroDetalle.where(SQL.rubroEvalRNPFormula.rubroEvaluacionPrimId.isIn(rubricaIdList));
    queryRubroDetalle.where(SQL.rubroEvaluacionProceso.estadoId.isNotIn([RubroRepository.ESTADO_ELIMINADO]));

    for(var row in await queryRubroDetalle.get()){
      RubroEvalRNPFormulaData rubroEvalRNPFormulaData = row.readTable(SQL.rubroEvalRNPFormula);
      for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvalProcesoUiList){
        if(rubroEvalRNPFormulaData.rubroEvaluacionPrimId == rubricaEvaluacionUi.rubroEvaluacionId){
          rubricaEvaluacionUi.cantidadRubroDetalle =  (rubricaEvaluacionUi.cantidadRubroDetalle??0) + 1;
        }
      }
    }
    print("rubricaEvalProcesoUiList: ${rubricaEvalProcesoUiList.length}");
    return rubricaEvalProcesoUiList;
  }

  RubricaEvaluacionUi convertRubricaEvaluacionUi(RubroEvaluacionProcesoData? rubroEvaluacionProcesoData, double peso){
    RubricaEvaluacionUi rubricaEvaluacionUi = RubricaEvaluacionUi();
    rubricaEvaluacionUi.rubroEvaluacionId = rubroEvaluacionProcesoData?.rubroEvalProcesoId;
    rubricaEvaluacionUi.titulo = rubroEvaluacionProcesoData?.titulo;
    rubricaEvaluacionUi.subtitulo = rubroEvaluacionProcesoData?.subtitulo;
    rubricaEvaluacionUi.desempenioIcdId = rubroEvaluacionProcesoData?.desempenioIcdId;
    rubricaEvaluacionUi.fechaCreacion_ = DomainTools.f_fecha_letras(rubroEvaluacionProcesoData?.fechaCreacion);
    rubricaEvaluacionUi.fechaCreacion = rubroEvaluacionProcesoData?.fechaCreacion;
    rubricaEvaluacionUi.mediaDesvicion = '${(rubroEvaluacionProcesoData?.promedio??0).toStringAsFixed(1)}(${(rubroEvaluacionProcesoData?.desviacionEstandar??0).toStringAsFixed(1)})';
    rubricaEvaluacionUi.promedio = rubroEvaluacionProcesoData?.promedio;
    rubricaEvaluacionUi.desviacionEstandar = rubroEvaluacionProcesoData?.desviacionEstandar;
    rubricaEvaluacionUi.rubroGrupal = rubroEvaluacionProcesoData?.formaEvaluacionId == FORMA_EVAL_GRUPAL;
    rubricaEvaluacionUi.formaEvaluacionId = rubroEvaluacionProcesoData?.formaEvaluacionId;
    rubricaEvaluacionUi.tipoEvaluacionId = rubroEvaluacionProcesoData?.tipoEvaluacionId;
    rubricaEvaluacionUi.tipoNotaId = rubroEvaluacionProcesoData?.tipoNotaId;
    rubricaEvaluacionUi.sesionAprendizajeId = rubroEvaluacionProcesoData?.sesionAprendizajeId;
    rubricaEvaluacionUi.competenciaId = rubroEvaluacionProcesoData?.competenciaId;
    rubricaEvaluacionUi.desempenioIcdId = rubroEvaluacionProcesoData?.desempenioIcdId;

    if((rubroEvaluacionProcesoData?.tareaId??"").isNotEmpty)rubricaEvaluacionUi.origenRubroUi = OrigenRubroUi.GENERADO_TAREA;
    else if( (rubroEvaluacionProcesoData?.instrumentoEvalId??0) > 0)rubricaEvaluacionUi.origenRubroUi = OrigenRubroUi.GENERADO_INSTRUMENTO;
    else if((rubroEvaluacionProcesoData?.preguntaId??"").isNotEmpty)rubricaEvaluacionUi.origenRubroUi = OrigenRubroUi.GENERADO_PREGUNTA;
    else rubricaEvaluacionUi.origenRubroUi = OrigenRubroUi.CREADO_DOCENTE;
    rubricaEvaluacionUi.tipoNotaId = rubroEvaluacionProcesoData?.tipoNotaId;
    rubricaEvaluacionUi.formula_peso = peso;
    rubricaEvaluacionUi.guardadoLocal = (rubroEvaluacionProcesoData?.syncFlag == EstadoSync.FLAG_ADDED ||  rubroEvaluacionProcesoData?.syncFlag == EstadoSync.FLAG_UPDATED);
    rubricaEvaluacionUi.calendarioPeriodoId = rubroEvaluacionProcesoData?.calendarioPeriodoId;
    rubricaEvaluacionUi.peso = rubroEvaluacionProcesoData?.peso;
    switch(rubroEvaluacionProcesoData?.tiporubroid){
      case TIPO_RUBRO_UNIDIMENCIONAL:
        rubricaEvaluacionUi.tipoRubroEvaluacion = TipoRubroEvaluacion.UNIDIMENSIONAL;
        break;
      case TIPO_RUBRO_BIMENSIONAL:
        rubricaEvaluacionUi.tipoRubroEvaluacion = TipoRubroEvaluacion.BIDIMENSIONAL;
        break;
      case TIPO_RUBRO_BIDIMENCIONAL_DETALLE:
        rubricaEvaluacionUi.tipoRubroEvaluacion = TipoRubroEvaluacion.BIDIMENSIONAL_DETALLE;
        break;
      default:
        rubricaEvaluacionUi.tipoRubroEvaluacion = TipoRubroEvaluacion.UNIDIMENSIONAL;
        break;
    }
    return rubricaEvaluacionUi;
  }

  EvaluacionUi convertEvaluacionUi(EvaluacionProcesoData evaluacionProcesoData){
    EvaluacionUi evaluacionUi = EvaluacionUi();
    evaluacionUi.evaluacionId = evaluacionProcesoData.evaluacionProcesoId;
    evaluacionUi.rubroEvaluacionId = evaluacionProcesoData.rubroEvalProcesoId;
    evaluacionUi.alumnoId = evaluacionProcesoData.alumnoId;
    evaluacionUi.personaUi = PersonaUi();
    evaluacionUi.personaUi?.personaId = evaluacionProcesoData.alumnoId;
    evaluacionUi.personaUi?.nombres = evaluacionProcesoData.nombres;
    evaluacionUi.personaUi?.nombreCompleto = '${DomainTools.capitalize(evaluacionProcesoData.nombres??"")} ${DomainTools.capitalize(evaluacionProcesoData.apellidoPaterno??"")} ${DomainTools.capitalize(evaluacionProcesoData.apellidoMaterno??"")}';
    evaluacionUi.personaUi?.apellidos  = '${DomainTools.capitalize(evaluacionProcesoData.apellidoPaterno??"")} ${DomainTools.capitalize(evaluacionProcesoData.apellidoMaterno??"")}';
    evaluacionUi.personaUi?.apellidoPaterno = evaluacionProcesoData.apellidoPaterno;
    evaluacionUi.personaUi?.apellidoMaterno = evaluacionProcesoData.apellidoMaterno;
    evaluacionUi.personaUi?.foto = evaluacionProcesoData.foto;
    evaluacionUi.publicado = evaluacionProcesoData.publicado;
    evaluacionUi.equipoId = evaluacionProcesoData.equipoId;
    evaluacionUi.valorTipoNotaId =  evaluacionProcesoData.valorTipoNotaId;
    evaluacionUi.nota = evaluacionProcesoData.nota;
    return evaluacionUi;
  }

  @override
  Future<List<UnidadUi>> getUnidadAprendizaje(int? silaboEventoId, int? calendarioPeriodoId) async {
    AppDataBase SQL = AppDataBase();
    List<UnidadUi> unidadUiList = [];
    List<SesionUi> sesionUiList = [];
    var query = SQL.selectOnly(SQL.criterio, distinct: true)//..where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    //query.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
      ..addColumns([SQL.criterio.silaboEventoId,
        SQL.criterio.unidadAprendiajeId,
        SQL.criterio.tituloUnidad,
        SQL.criterio.nroUnidad,
        SQL.criterio.sesionAprendizajeId,
        SQL.criterio.sesionAprendizajePadreId,
        SQL.criterio.nroSesion,
        SQL.criterio.propositoSesion,
        SQL.criterio.rolIdSesion,
        SQL.criterio.tituloSesion,
      ]);
    query.where(SQL.criterio.silaboEventoId.equals(silaboEventoId));
    query.where(SQL.criterio.calendarioPeriodoId.equals(calendarioPeriodoId));
    query.orderBy([ OrderingTerm(expression: SQL.criterio.nroUnidad, mode: OrderingMode.desc),  OrderingTerm(expression: SQL.criterio.nroSesion, mode: OrderingMode.desc)]);
    query.map((row){
    UnidadUi? unidadUi = unidadUiList.firstWhereOrNull((element) => element.unidadAprendizajeId == row.read(SQL.criterio.unidadAprendiajeId));
    if(unidadUi == null){
      unidadUi = UnidadUi();
      unidadUi.sesionUiList = [];
      unidadUiList.add(unidadUi);
    }
    unidadUi.unidadAprendizajeId = row.read(SQL.criterio.unidadAprendiajeId);
    print("criterio ${row.read(SQL.criterio.tituloUnidad)}");
    unidadUi.titulo = row.read(SQL.criterio.tituloUnidad);
    unidadUi.nroUnidad = row.read(SQL.criterio.nroUnidad);
    SesionUi sesionUi = SesionUi();
    sesionUi.sesionAprendizajeId =  row.read(SQL.criterio.sesionAprendizajeId);
    sesionUi.sesionAprendizajePadreId = row.read(SQL.criterio.sesionAprendizajePadreId);
    sesionUi.tituloUnidad = unidadUi.titulo;
    sesionUi.nroUnidad = unidadUi.nroUnidad;
    sesionUi.nroSesion = row.read(SQL.criterio.nroSesion);
    sesionUi.titulo = row.read(SQL.criterio.tituloSesion);
    sesionUi.proposito = row.read(SQL.criterio.propositoSesion);
    sesionUi.unidadAprendizajeId = unidadUi.unidadAprendizajeId;
    sesionUi.rubricaEvaluacionUiList = [];
    if((sesionUi.sesionAprendizajeId??0)>0){
      unidadUi.sesionUiList?.add(sesionUi);
      sesionUiList.add(sesionUi);
    }

    return unidadUi;
    }).get();


    var queryRubro = SQL.select(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
    queryRubro.where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    queryRubro.where((tbl) => tbl.tiporubroid.isIn([TIPO_RUBRO_BIMENSIONAL, TIPO_RUBRO_UNIDIMENCIONAL]));
    //queryRubro.where((tbl) => tbl.tipoFormulaId.isNull());
    //queryRubro.where((tbl) => tbl.tipoFormulaId.equals(0));
    queryRubro.where((tbl) => tbl.sesionAprendizajeId.isNotNull());
    queryRubro.orderBy([(tbl)=> OrderingTerm.desc(tbl.fechaCreacion)]);

    List<RubroEvaluacionProcesoData> rubroEvalProcesoList = await queryRubro.get();
    for(RubroEvaluacionProcesoData rubroEvaluacionProcesoData in  rubroEvalProcesoList){
      if((rubroEvaluacionProcesoData.tipoFormulaId??0)!=0)continue;
      for(SesionUi sesionUi in sesionUiList){
        if(sesionUi.sesionAprendizajeId == rubroEvaluacionProcesoData.sesionAprendizajeId || sesionUi.sesionAprendizajePadreId ==  rubroEvaluacionProcesoData.sesionAprendizajeId){
          RubricaEvaluacionUi rubricaEvaluacionUi = convertRubricaEvaluacionUi(rubroEvaluacionProcesoData, 0.0);
          sesionUi.rubricaEvaluacionUiList?.add(rubricaEvaluacionUi);
        }
      }
    }

    return unidadUiList;
  }

  @override
  Future<List<CompetenciaUi>> getRubroCompetencia(int? silaboEventoId, int? calendarioPeriodoId, int? competenciaId) async{
    AppDataBase SQL = AppDataBase();
    final rubroPadre = SQL.alias(SQL.rubroEvaluacionProceso, 'rubroPadre');
    var queryRubro = SQL.select(SQL.rubroEvaluacionProceso).join([
      leftOuterJoin(SQL.rubroEvalRNPFormula, SQL.rubroEvaluacionProceso.rubroEvalProcesoId.equalsExp(SQL.rubroEvalRNPFormula.rubroEvaluacionSecId)),
      leftOuterJoin(rubroPadre, SQL.rubroEvalRNPFormula.rubroEvaluacionPrimId.equalsExp(rubroPadre.rubroEvalProcesoId))
    ]);

    queryRubro.where(SQL.rubroEvaluacionProceso.calendarioPeriodoId.equals(calendarioPeriodoId));
    queryRubro.where(SQL.rubroEvaluacionProceso.silaboEventoId.equals(silaboEventoId));
    queryRubro.where(SQL.rubroEvaluacionProceso.tiporubroid.isIn([TIPO_RUBRO_BIDIMENCIONAL_DETALLE, TIPO_RUBRO_UNIDIMENCIONAL]));
    //queryRubro.where(SQL.rubroEvaluacionProceso.tipoFormulaId.isNull());
    //queryRubro.where(SQL.rubroEvaluacionProceso.tipoFormulaId.equals(0));
    //queryRubro.where((tbl) => tbl.sesionAprendizajeId.isNotNull());
    queryRubro.where(SQL.rubroEvaluacionProceso.estadoId.isNotIn([RubroRepository.ESTADO_ELIMINADO]));

    queryRubro.orderBy([OrderingTerm.desc(SQL.rubroEvaluacionProceso.fechaCreacion)]);

    List<RubroEvaluacionProcesoData> rubroEvalProcesoList = [];
    Map<String,RubroEvaluacionProcesoData?> rubroPadresMap = Map();
    Map<String,int> rubroPadresCountMap = Map();
    List<String> rubroEvalProcesoIdList = [];
    List<String> rubroTipoNotaIdList = [];
    var rows = await queryRubro.get();

    for(var row in  rows){//Puede venir repetida
      RubroEvaluacionProcesoData item = row.readTable(SQL.rubroEvaluacionProceso);
      if((item.tipoFormulaId??0)!=0)continue;

      RubroEvaluacionProcesoData? rubroEvaluacionProcesoData = rubroEvalProcesoList.firstWhereOrNull((element) => element.rubroEvalProcesoId ==  item.rubroEvalProcesoId);
      if(rubroEvaluacionProcesoData == null){
        rubroEvalProcesoIdList.add(item.rubroEvalProcesoId);
        rubroTipoNotaIdList.add(item.tipoNotaId??"");
        rubroEvalProcesoList.add(item);
      }
      RubroEvaluacionProcesoData? itemPadre = row.readTableOrNull(rubroPadre);
      if(itemPadre?.tiporubroid == TIPO_RUBRO_BIMENSIONAL){//evitar agregar rubro formulas
        rubroPadresMap[item.rubroEvalProcesoId] = itemPadre;
        rubroPadresCountMap[itemPadre?.rubroEvalProcesoId??""] = (rubroPadresCountMap[itemPadre?.rubroEvalProcesoId]??0)+1;
      }
    }

    List<TipoNotaUi> tipoNotaUiList = [];
    List<EvaluacionProcesoData> evaluacionProcesoDataList = await (SQL.select(SQL.evaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvalProcesoIdList))).get();
    var queryTipoNota = SQL.select(SQL.tipoNotaRubro)..where((tbl) => tbl.tipoNotaId.isIn(rubroTipoNotaIdList));
    //queryTipoNota.where((tbl) => tbl.silaboEventoId.equals(0));
    List<TipoNotaRubroData> tipoNotaList = await (queryTipoNota).get();
    for(TipoNotaRubroData tipoNotaRubroData in tipoNotaList){

      TipoNotaUi tipoNotaUi = convertTipoNotaUi(tipoNotaRubroData);
      List<ValorTipoNotaUi> valorTipoNotaUiList = [];

      var queryValorTipoNota = SQL.select(SQL.valorTipoNotaRubro)..where((tbl) => tbl.tipoNotaId.equals(tipoNotaRubroData.tipoNotaId));
      //queryValorTipoNota.where((tbl) => tbl.silaboEventoId.equals(0));
      List<ValorTipoNotaRubroData> valorTipoNotaRubroList = await queryValorTipoNota.get();
      valorTipoNotaRubroList.sort((a, b) => (b.valorNumerico??0).compareTo(a.valorNumerico??0));

      for(ValorTipoNotaRubroData valorTipoNotaRubroData in valorTipoNotaRubroList){
        ValorTipoNotaUi valorTipoNotaUi = convertValorTipoNotaUi(valorTipoNotaRubroData);
        valorTipoNotaUi.tipoNotaUi = tipoNotaUi;
        valorTipoNotaUiList.add(valorTipoNotaUi);
      }

      tipoNotaUi.valorTipoNotaList = valorTipoNotaUiList;
      tipoNotaUiList.add(tipoNotaUi);
    }

    //print("evaluacionProcesoDataList: ${evaluacionProcesoDataList.length}");
    List<CompetenciaUi> competenciaUiList = await getTemasCriterios(calendarioPeriodoId??0, silaboEventoId??0,  null);
    for(CompetenciaUi competenciaUi in competenciaUiList){
      for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
        capacidadUi.rubricaEvalUiList = [];
        for(RubroEvaluacionProcesoData rubroEvaluacionProcesoData in  rubroEvalProcesoList){
          if(capacidadUi.capacidadId == rubroEvaluacionProcesoData.competenciaId){
            RubricaEvaluacionUi rubricaEvaluacionUi = convertRubricaEvaluacionUi(rubroEvaluacionProcesoData, 0.0);
            rubricaEvaluacionUi.tituloRubroCabecera = rubroPadresMap[rubroEvaluacionProcesoData.rubroEvalProcesoId]?.titulo;
            rubricaEvaluacionUi.rubricaIdRubroCabecera = rubroPadresMap[rubroEvaluacionProcesoData.rubroEvalProcesoId]?.rubroEvalProcesoId;
            rubricaEvaluacionUi.cantidadRubroDetalle = rubroPadresCountMap[rubroPadresMap[rubroEvaluacionProcesoData.rubroEvalProcesoId]?.rubroEvalProcesoId??""];

            rubricaEvaluacionUi.evaluacionUiList = [];
            TipoNotaUi? tipoNotaUi = tipoNotaUiList.firstWhereOrNull((element)=> element.tipoNotaId == rubricaEvaluacionUi.tipoNotaId);
            rubricaEvaluacionUi.tipoNotaUi = tipoNotaUi;

            for(EvaluacionProcesoData evaluacionProcesoData in evaluacionProcesoDataList){
              if(evaluacionProcesoData.rubroEvalProcesoId ==  rubroEvaluacionProcesoData.rubroEvalProcesoId){
                EvaluacionUi evaluacionUi = convertEvaluacionUi(evaluacionProcesoData);
                ValorTipoNotaUi? valorTipoNotaUi = tipoNotaUi?.valorTipoNotaList?.firstWhereOrNull((element) => element.valorTipoNotaId == evaluacionUi.valorTipoNotaId);
                evaluacionUi.valorTipoNotaUi = valorTipoNotaUi;
                evaluacionUi.rubroEvaluacionUi =  rubricaEvaluacionUi;

                rubricaEvaluacionUi.evaluacionUiList?.add(evaluacionUi);
              }
            }

            capacidadUi.rubricaEvalUiList?.add(rubricaEvaluacionUi);
          }
        }

        //print("capacidadUi: ${ capacidadUi.rubricaEvalUiList?.length}");
      }
    }

    return competenciaUiList;
  }


  @override
  Future<TipoNotaUi> getGetTipoNotaResultado(int? silaboEventoId) async{
    AppDataBase SQL = AppDataBase();
    var query =  SQL.selectSingle(SQL.tipoNotaResultado);
    query.where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));

    TipoNotaResultadoData? tipoNotaRubroData = await query.getSingleOrNull();

    TipoNotaUi tipoNotaUi = TipoNotaUi();
    tipoNotaUi.tipoNotaId = tipoNotaRubroData?.tipoNotaId;
    tipoNotaUi.nombre = tipoNotaRubroData?.nombre;
    tipoNotaUi.escalanombre = tipoNotaRubroData?.escalanombre;
    tipoNotaUi.escalavalorMaximo = tipoNotaRubroData?.escalavalorMaximo;
    tipoNotaUi.escalavalorMinimo = tipoNotaRubroData?.escalavalorMinimo;
    tipoNotaUi.tiponombre = tipoNotaRubroData?.tiponombre;
    tipoNotaUi.tipoId = tipoNotaRubroData?.tipoId;
    tipoNotaUi.intervalo = tipoNotaRubroData?.intervalo;
    tipoNotaUi.resultado = true;
    switch(tipoNotaRubroData?.tipoId??0){
      case TN_SELECTOR_ICONOS:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_ICONOS;
        print("getGetTipoNotaResultado SELECTOR_ICONOS");
        break;
      case TN_SELECTOR_NUMERICO:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_NUMERICO;
        print("getGetTipoNotaResultado SELECTOR_ICONOS");
        break;
      case TN_SELECTOR_VALORES:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_VALORES;
        print("getGetTipoNotaResultado SELECTOR_VALORES");
        break;
      case TN_VALOR_NUMERICO:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.VALOR_NUMERICO;
        print("getGetTipoNotaResultado VALOR_NUMERICO");
        break;
      case TN_VALOR_ASISTENCIA:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.VALOR_ASISTENCIA;
        print("getGetTipoNotaResultado VALOR_ASISTENCIA");
        break;
    }

    List<ValorTipoNotaUi> valorTipoNotaUiList = [];
    var queryValorTipoNota = SQL.select(SQL.valorTipoNotaResultado);
    queryValorTipoNota..where((tbl) => tbl.tipoNotaId.equals(tipoNotaRubroData?.tipoNotaId));
    queryValorTipoNota.where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    List<ValorTipoNotaResultadoData> valorTipoNotaRubroList = await queryValorTipoNota.get();


    valorTipoNotaRubroList.sort((a, b) => (b.valorNumerico??0).compareTo(a.valorNumerico??0));

    for(ValorTipoNotaResultadoData valorTipoNotaRubroData in valorTipoNotaRubroList){
      ValorTipoNotaUi valorTipoNotaUi = ValorTipoNotaUi();
      valorTipoNotaUi.valorTipoNotaId = valorTipoNotaRubroData.valorTipoNotaId;
      valorTipoNotaUi.titulo = valorTipoNotaRubroData.titulo;
      valorTipoNotaUi.alias = valorTipoNotaRubroData.alias;
      valorTipoNotaUi.icono = valorTipoNotaRubroData.icono;
      valorTipoNotaUi.incluidoLInferior = valorTipoNotaRubroData.incluidoLInferior;
      valorTipoNotaUi.incluidoLSuperior = valorTipoNotaRubroData.incluidoLSuperior;
      valorTipoNotaUi.tipoNotaUi = tipoNotaUi;
      valorTipoNotaUi.tipoNotaId = valorTipoNotaRubroData.tipoNotaId;
      valorTipoNotaUi.valorNumerico = valorTipoNotaRubroData.valorNumerico;
      valorTipoNotaUi.limiteInferior = valorTipoNotaRubroData.limiteInferior;
      valorTipoNotaUi.limiteSuperior = valorTipoNotaRubroData.limiteSuperior;

      valorTipoNotaUi.incluidoLInferiorTransf = valorTipoNotaRubroData.incluidoLInferiorTransf;
      valorTipoNotaUi.incluidoLSuperiorTransf = valorTipoNotaRubroData.incluidoLSuperiorTransf;
      valorTipoNotaUi.valorNumericoTransf = valorTipoNotaRubroData.valorNumericoTransf;
      valorTipoNotaUi.limiteInferiorTransf = valorTipoNotaRubroData.limiteInferiorTransf;
      valorTipoNotaUi.limiteSuperiorTransf = valorTipoNotaRubroData.limiteSuperiorTransf;

      valorTipoNotaUiList.add(valorTipoNotaUi);
    }
    //print("valorTipoNotaList: " + (valorTipoNotaUiList.length).toString());
    tipoNotaUi.valorTipoNotaList = valorTipoNotaUiList;


    return tipoNotaUi;
  }

  Future<TipoNotaUi> getTipoNota(String? tipoNotaId) async{
    AppDataBase SQL = AppDataBase();
    var query =  SQL.selectSingle(SQL.tipoNotaRubro)..where((tbl) => tbl.tipoNotaId.equals(tipoNotaId));

    TipoNotaRubroData? tipoNotaRubroData = await query.getSingleOrNull();

    TipoNotaUi tipoNotaUi = TipoNotaUi();
    tipoNotaUi.tipoNotaId = tipoNotaRubroData?.tipoNotaId;
    tipoNotaUi.nombre = tipoNotaRubroData?.nombre;
    tipoNotaUi.escalanombre = tipoNotaRubroData?.escalanombre;
    tipoNotaUi.escalavalorMaximo = tipoNotaRubroData?.escalavalorMaximo;
    tipoNotaUi.escalavalorMinimo = tipoNotaRubroData?.escalavalorMinimo;
    tipoNotaUi.tiponombre = tipoNotaRubroData?.tiponombre;
    tipoNotaUi.tipoId = tipoNotaRubroData?.tipoId;
    tipoNotaUi.intervalo = tipoNotaRubroData?.intervalo;

    switch(tipoNotaRubroData?.tipoId??0){
      case TN_SELECTOR_ICONOS:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_ICONOS;
        break;
      case TN_SELECTOR_NUMERICO:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_NUMERICO;
        break;
      case TN_SELECTOR_VALORES:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_VALORES;
        break;
      case TN_VALOR_NUMERICO:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.VALOR_NUMERICO;
        break;
      case TN_VALOR_ASISTENCIA:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.VALOR_ASISTENCIA;
        break;
    }

    List<ValorTipoNotaUi> valorTipoNotaUiList = [];
    var queryValorTipoNota = SQL.select(SQL.valorTipoNotaRubro)..where((tbl) => tbl.tipoNotaId.equals(tipoNotaRubroData?.tipoNotaId));
    List<ValorTipoNotaRubroData> valorTipoNotaRubroList = await queryValorTipoNota.get();
    valorTipoNotaRubroList.sort((a, b) => (b.valorNumerico??0).compareTo(a.valorNumerico??0));

    for(ValorTipoNotaRubroData valorTipoNotaRubroData in valorTipoNotaRubroList){
      ValorTipoNotaUi valorTipoNotaUi = convertValorTipoNotaUi(valorTipoNotaRubroData);
      valorTipoNotaUi.tipoNotaUi = tipoNotaUi;
      //print("getTipoNota ${valorTipoNotaUi.icono}");
      valorTipoNotaUiList.add(valorTipoNotaUi);
    }

    tipoNotaUi.valorTipoNotaList = valorTipoNotaUiList;
    return tipoNotaUi;
  }

  @override
  Future<RubricaEvaluacionUi> getRubroEvaluacion(String? rubroEvaluacionId)async {
    AppDataBase SQL = AppDataBase();
    RubroEvaluacionProcesoData? rubroEvaluacionProcesoData = await (SQL.selectSingle(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.equals(rubroEvaluacionId))).getSingleOrNull();
    RubricaEvaluacionUi rubricaEvaluacionUi = convertRubricaEvaluacionUi(rubroEvaluacionProcesoData, 0.0);


    List<RubricaEvaluacionUi> rubricaEvaluacionUiDetalleList = [];
    if(rubroEvaluacionProcesoData?.tiporubroid == TIPO_RUBRO_BIMENSIONAL){
      var queryRubroDetalle = SQL.select(SQL.rubroEvaluacionProceso).join([
        innerJoin(SQL.rubroEvalRNPFormula, SQL.rubroEvalRNPFormula.rubroEvaluacionSecId.equalsExp(SQL.rubroEvaluacionProceso.rubroEvalProcesoId))
      ]);
      queryRubroDetalle.where(SQL.rubroEvaluacionProceso.estadoId.isNotIn([RubroRepository.ESTADO_ELIMINADO]));
      queryRubroDetalle.where(SQL.rubroEvalRNPFormula.rubroEvaluacionPrimId.equals(rubroEvaluacionId));
      int count = 0;
      for(var row in await queryRubroDetalle.get()){
        RubroEvaluacionProcesoData rubroEvaluacionProcesoData = row.readTable(SQL.rubroEvaluacionProceso);
        RubroEvalRNPFormulaData rubroEvalRNPFormulaData = row.readTable(SQL.rubroEvalRNPFormula);
        //print("rubroEvalRNPFormulaData peso: ${rubroEvalRNPFormulaData.peso}");
        RubricaEvaluacionUi rubricaEvaluacionUiDetalle = convertRubricaEvaluacionUi(rubroEvaluacionProcesoData, rubroEvalRNPFormulaData.peso??0.0);
        rubricaEvaluacionUiDetalleList.add(rubricaEvaluacionUiDetalle);
        count++;
      }
      rubricaEvaluacionUi.cantidadRubroDetalle = count;
    }

    /*Obtener Tipo Nota*/
    rubricaEvaluacionUi.tipoNotaUi = await getTipoNota(rubricaEvaluacionUi.tipoNotaId);

    List<TipoNotaUi> tipoNotaUiDetalleList = [];//Validacion por no hacer muchas consultas
    for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUiDetalleList){
      TipoNotaUi? tipoNotaUi = tipoNotaUiDetalleList.firstWhereOrNull((element) => element.tipoNotaId == rubricaEvaluacionUi.tipoNotaId);
      if(tipoNotaUi==null){
        tipoNotaUi = await getTipoNota(rubricaEvaluacionUi.tipoNotaId);
        tipoNotaUiDetalleList.add(tipoNotaUi);
      }
      rubricaEvaluacionUi.tipoNotaUi = tipoNotaUi;
    }
    /*Obtener Evaluacion*/
    List<String> rubroEvaluacionIdEvaluacionList = [];
    List<RubricaEvaluacionUi> rubroEvaluacionUiEvaluacionList = [];
    rubroEvaluacionIdEvaluacionList.add(rubricaEvaluacionUi.rubroEvaluacionId??"");
    rubroEvaluacionUiEvaluacionList.add(rubricaEvaluacionUi);
    for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUiDetalleList){
      rubroEvaluacionIdEvaluacionList.add(rubricaEvaluacionUi.rubroEvaluacionId??"");
      rubroEvaluacionUiEvaluacionList.add(rubricaEvaluacionUi);
    }

    
    
    var queryEvidencia = SQL.select(SQL.archivoRubro).join([
      innerJoin(SQL.evaluacionProceso, SQL.evaluacionProceso.evaluacionProcesoId.equalsExp(SQL.archivoRubro.evaluacionProcesoId)),
      innerJoin(SQL.rubroEvaluacionProceso, SQL.rubroEvaluacionProceso.rubroEvalProcesoId.equalsExp(SQL.evaluacionProceso.rubroEvalProcesoId)),
    ]);
    queryEvidencia.where(SQL.rubroEvaluacionProceso.rubroEvalProcesoId.isIn(rubroEvaluacionIdEvaluacionList));
    List<RubroEvidenciaUi> rubroEvidenciaUiList = [];
    for(var row in await queryEvidencia.get()){
      ArchivoRubroData item = row.readTable(SQL.archivoRubro);
      EvaluacionProcesoData evaluacionProcesoData = row.readTable(SQL.evaluacionProceso);
      if(item.delete == 1)continue;
      RubroEvidenciaUi rubroEvidenciaUi = RubroEvidenciaUi();
      rubroEvidenciaUi.archivoRubroId = item.archivoRubroId;
      rubroEvidenciaUi.titulo = item.url?.split("/").last;
      rubroEvidenciaUi.url = item.url;
      rubroEvidenciaUi.tipoRecurso = getTipoArchivo(item);
      rubroEvidenciaUi.eliminar = item.delete==1;
      rubroEvidenciaUi.evaluacionUi = EvaluacionUi();
      rubroEvidenciaUi.evaluacionUi?.evaluacionId =evaluacionProcesoData.evaluacionProcesoId;
      //rubroEvidenciaUi.evaluacionUi = evaluacionUi;
      rubroEvidenciaUi.rubroEvaluacionId = evaluacionProcesoData.rubroEvalProcesoId;
      rubroEvidenciaUi.fechaCreacion = item.fechaCreacion;
      rubroEvidenciaUiList.add(rubroEvidenciaUi);

    }
    var queryComentario = SQL.select(SQL.rubroComentario).join([
      innerJoin(SQL.evaluacionProceso, SQL.evaluacionProceso.evaluacionProcesoId.equalsExp(SQL.rubroComentario.evaluacionProcesoId)),
      innerJoin(SQL.rubroEvaluacionProceso, SQL.rubroEvaluacionProceso.rubroEvalProcesoId.equalsExp(SQL.evaluacionProceso.rubroEvalProcesoId)),
    ]);
    queryComentario.where(SQL.rubroEvaluacionProceso.rubroEvalProcesoId.isIn(rubroEvaluacionIdEvaluacionList));
    List<RubroComentarioUi> rubroComentarioUiList = [];
    for(var row in await queryComentario.get()){
      RubroComentarioData item = row.readTable(SQL.rubroComentario);
      EvaluacionProcesoData evaluacionProcesoData = row.readTable(SQL.evaluacionProceso);
      if(item.delete == 1)continue;
      RubroComentarioUi rubroComentarioUi = RubroComentarioUi();
      rubroComentarioUi.evaluacionRubroComentarioId = item.evaluacionProcesoComentarioId;
      rubroComentarioUi.comentario = item.descripcion;
      rubroComentarioUi.evaluacionId = evaluacionProcesoData.evaluacionProcesoId;
      rubroComentarioUi.rubroEvaluacionId = evaluacionProcesoData.rubroEvalProcesoId;
      //print("descripcion: ${item.descripcion}");
      rubroComentarioUi.fechaCreacion = item.fechaCreacion;
      rubroComentarioUiList.add(rubroComentarioUi);
    }

    List<EvaluacionProcesoData> evaluacionProcesoDataList = await (SQL.select(SQL.evaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdEvaluacionList))).get();
    for(RubricaEvaluacionUi rubricaEvaluacionUi in rubroEvaluacionUiEvaluacionList){
      rubricaEvaluacionUi.evaluacionUiList = [];
      for(EvaluacionProcesoData evaluacionProcesoData in evaluacionProcesoDataList){
        if(evaluacionProcesoData.rubroEvalProcesoId == rubricaEvaluacionUi.rubroEvaluacionId){
          EvaluacionUi evaluacionUi = convertEvaluacionUi(evaluacionProcesoData);
          ValorTipoNotaUi? valorTipoNotaUi = rubricaEvaluacionUi.tipoNotaUi?.valorTipoNotaList?.firstWhereOrNull((element) => element.valorTipoNotaId == evaluacionUi.valorTipoNotaId);
          evaluacionUi.valorTipoNotaUi = valorTipoNotaUi;
          evaluacionUi.rubroEvaluacionUi =  rubricaEvaluacionUi;
          evaluacionUi.comentarios = [];
          var comentarios = rubroComentarioUiList.where((element) => element.evaluacionId == evaluacionProcesoData.evaluacionProcesoId);
          comentarios.sorted((a, b) => (b.fechaCreacion??DateTime(1950)).compareTo(a.fechaCreacion??DateTime(1950)));
          evaluacionUi.comentarios?.addAll(comentarios);

          var evidencias = rubroEvidenciaUiList.where((element) => element.evaluacionUi?.evaluacionId == evaluacionProcesoData.evaluacionProcesoId);
          evidencias.sorted((a, b) => (b.fechaCreacion??DateTime(1950)).compareTo(a.fechaCreacion??DateTime(1950)));
          evaluacionUi.evidencias = [];
          for(RubroEvidenciaUi item in evidencias){
            item.evaluacionUi = evaluacionUi;
            evaluacionUi.evidencias?.add(item);
          }
          rubricaEvaluacionUi.evaluacionUiList?.add(evaluacionUi);
        }
      }
    }

    if(rubroEvaluacionProcesoData?.formaEvaluacionId == FORMA_EVAL_GRUPAL){
      var queryGrupos = SQL.select(SQL.rubroEvaluacionProcesoIntegrante).join([
        innerJoin(SQL.rubroEvaluacionProcesoEquipo, SQL.rubroEvaluacionProcesoEquipo.rubroEvaluacionEquipoId.equalsExp(SQL.rubroEvaluacionProcesoIntegrante.rubroEvaluacionEquipoId)),
      ]);
      queryGrupos.where(SQL.rubroEvaluacionProcesoEquipo.rubroEvalProcesoId.isIn(rubroEvaluacionIdEvaluacionList));

      List<EquipoEvaluacionData> equipoEvaluacionList =  await (SQL.select(SQL.equipoEvaluacion)
                                                                    ..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdEvaluacionList))).get();

      print("equipoEvaluacionList: ${ equipoEvaluacionList.length}");
      for(RubricaEvaluacionUi rubricaEvaluacionUi in rubroEvaluacionUiEvaluacionList){
        rubricaEvaluacionUi.equipoUiList = [];
      }

      for(var row in await queryGrupos.get()){

        RubroEvaluacionProcesoEquipoData rubroEvaluacionProcesoEquipoData =  row.readTable(SQL.rubroEvaluacionProcesoEquipo);
        RubroEvaluacionProcesoIntegranteData rubroEvaluacionProcesoIntegranteData = row.readTable(SQL.rubroEvaluacionProcesoIntegrante);

        for(RubricaEvaluacionUi rubricaEvaluacionUi in rubroEvaluacionUiEvaluacionList){

          if(rubricaEvaluacionUi.rubroEvaluacionId == rubroEvaluacionProcesoEquipoData.rubroEvalProcesoId){

            RubricaEvaluacionEquipoUi? rubricaEvaluacionEquipoUi = rubricaEvaluacionUi.equipoUiList?.firstWhereOrNull((element) => element.rubroEvaluacionEquipoId == rubroEvaluacionProcesoEquipoData.rubroEvaluacionEquipoId);
            if(rubricaEvaluacionEquipoUi == null){

              rubricaEvaluacionEquipoUi = RubricaEvaluacionEquipoUi();
              rubricaEvaluacionEquipoUi.rubroEvaluacionEquipoId = rubroEvaluacionProcesoEquipoData.rubroEvaluacionEquipoId;
              rubricaEvaluacionEquipoUi.orden = rubroEvaluacionProcesoEquipoData.orden;
              rubricaEvaluacionEquipoUi.nombreEquipo = rubroEvaluacionProcesoEquipoData.nombreEquipo;
              rubricaEvaluacionEquipoUi.equipoId = rubroEvaluacionProcesoEquipoData.equipoId;
              rubricaEvaluacionEquipoUi.integrantesUiList = [];
              rubricaEvaluacionEquipoUi.rubricaEvaluacionUi = rubricaEvaluacionUi;
              rubricaEvaluacionUi.equipoUiList?.add(rubricaEvaluacionEquipoUi);

              EquipoEvaluacionData? equipoEvaluacionData = equipoEvaluacionList.firstWhereOrNull((element) => element.equipoId == rubroEvaluacionProcesoEquipoData.rubroEvaluacionEquipoId);

              ValorTipoNotaUi? valorTipoNotaUi = rubricaEvaluacionUi.tipoNotaUi?.valorTipoNotaList?.firstWhereOrNull((element) => element.valorTipoNotaId == equipoEvaluacionData?.valorTipoNotaId);
              rubricaEvaluacionEquipoUi.evaluacionEquipoUi = EvaluacionEquipoUi();
              rubricaEvaluacionEquipoUi.evaluacionEquipoUi?.equipoEvaluacionProcesoId = equipoEvaluacionData?.equipoEvaluacionProcesoId;

              rubricaEvaluacionEquipoUi.evaluacionEquipoUi?.valorTipoNotaUi = valorTipoNotaUi;
              rubricaEvaluacionEquipoUi.evaluacionEquipoUi?.nota = equipoEvaluacionData?.nota;
              rubricaEvaluacionEquipoUi.evaluacionEquipoUi?.rubricaEvaluacionEquipoUi = rubricaEvaluacionEquipoUi;

            }


            RubricaEvalEquipoIntegranteUi rubricaEvalEquipoIntegranteUi = RubricaEvalEquipoIntegranteUi();
            rubricaEvalEquipoIntegranteUi.personaId = rubroEvaluacionProcesoIntegranteData.personaId;
            rubricaEvalEquipoIntegranteUi.rubroEvaluacionEquipoId = rubroEvaluacionProcesoIntegranteData.rubroEvaluacionEquipoId;
            rubricaEvalEquipoIntegranteUi.rubricaEvaluacionEquipoUi = rubricaEvaluacionEquipoUi;
            rubricaEvaluacionEquipoUi.integrantesUiList?.add(rubricaEvalEquipoIntegranteUi);
          }
        }

      }

    }
    /*Obtener Evaluacuion*/
    rubricaEvaluacionUi.rubrosDetalleList = rubricaEvaluacionUiDetalleList;
    return rubricaEvaluacionUi;
  }

  TipoRecursosUi getTipoArchivo(ArchivoRubroData data){
    switch(data.tipoArchivoId) {
      case DomainTipos.TIPO_RECURSO_AUDIO:
       return TipoRecursosUi.TIPO_AUDIO;
      case DomainTipos.TIPO_RECURSO_DIAPOSITIVA:
        return TipoRecursosUi.TIPO_DIAPOSITIVA;
      case DomainTipos.TIPO_RECURSO_DOCUMENTO:
        return TipoRecursosUi.TIPO_DOCUMENTO;
      case DomainTipos.TIPO_RECURSO_HOJA_CALUCLO:
        return TipoRecursosUi.TIPO_HOJA_CALCULO;
      case DomainTipos.TIPO_RECURSO_IMAGEN:
        return TipoRecursosUi.TIPO_IMAGEN;
      case DomainTipos.TIPO_RECURSO_PDF:
        return TipoRecursosUi.TIPO_PDF;
      case DomainTipos.TIPO_RECURSO_VIDEO:
      case DomainTipos.TIPO_RECURSO_VINCULO:
        return TipoRecursosUi.TIPO_VINCULO;
      case DomainTipos.TIPO_RECURSO_YOUTUBE:
        return TipoRecursosUi.TIPO_VINCULO_YOUTUBE;
      case DomainTipos.TIPO_RECURSO_MATERIALES:
        return TipoRecursosUi.TIPO_RECURSO;
      default:
        return TipoRecursosUi.TIPO_VINCULO;
    }
  }

  @override
  cambiarEstadoActualizado(String? rubroEvaluacionId) async{
    AppDataBase SQL = AppDataBase();
    try{

      RubricaEvaluacionUi rubricaEvaluacionUi = await getRubroEvaluacion(rubroEvaluacionId);
      List<String?> rubroEvaluacionIdList = [];
      List<String?> evaluacionIdList = [];
      rubroEvaluacionIdList.add(rubroEvaluacionId);
      for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUi.rubrosDetalleList??[]){
        rubroEvaluacionIdList.add(rubricaEvaluacionUi.rubroEvaluacionId??"");
        for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi.evaluacionUiList??[]){
          evaluacionIdList.add(evaluacionUi.evaluacionId??"");
        }
      }

      for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi.evaluacionUiList??[]){
        evaluacionIdList.add(evaluacionUi.evaluacionId??"");
      }

      await (SQL.update(SQL.rubroEvaluacionProceso)
        ..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdList)))
          .write(
          RubroEvaluacionProcesoCompanion(
            syncFlag: Value(EstadoSync.FLAG_EXPORTED),
          ));



      await (SQL.update(SQL.evaluacionProceso)
        ..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdList)))//ya so  se filtra por el evaluacion por que generta error por la cantidad masiva
          .write(
          EvaluacionProcesoCompanion(
            syncFlag: Value(EstadoSync.FLAG_EXPORTED),
          ));

    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<Map<String,dynamic>>> getRubroEvalNoEnviadosServidorSerial(int? silaboEventoId, int? calendarioPeriodoId) async {
    AppDataBase SQL = AppDataBase();

    var query = SQL.select(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
    query.where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    query.where((tbl) => tbl.tiporubroid.isIn([TIPO_RUBRO_BIMENSIONAL, TIPO_RUBRO_UNIDIMENCIONAL]));
    //query.where((tbl) => tbl.tipoFormulaId.isNull());
    //query.where((tbl) => tbl.tipoFormulaId.equals(0));
    query.where((tbl) => tbl.estadoId.isNotIn([RubroRepository.ESTADO_ELIMINADO]));
    query.where((tbl) => tbl.syncFlag.isIn([EstadoSync.FLAG_ADDED, EstadoSync.FLAG_UPDATED]));

    List<Map<String,dynamic>> listaExportar = [];
    List<RubroEvaluacionProcesoData> rubroEvalProcesoList = await query.get();
    for(RubroEvaluacionProcesoData rubroEvaluacionProcesoData in rubroEvalProcesoList){
      if((rubroEvaluacionProcesoData.tipoFormulaId??0)!=0)continue;
      listaExportar.add(await transformarRubroEvaluacionDataToSerial(SQL, rubroEvaluacionProcesoData));
    }

    return listaExportar;

  }

  @override
  Future<void> updateEvaluacion(RubricaEvaluacionUi? rubricaEvaluacionUi, int? alumnoId, int? usuarioId) async{
    AppDataBase SQL = AppDataBase();

    List<EvaluacionUi> evaluacionesList = [];
    List<double> notas = [];
    for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi?.evaluacionUiList??[]){
      notas.add(evaluacionUi.nota??0);
      if(evaluacionUi.alumnoId == alumnoId || alumnoId == null){
        evaluacionesList.add(evaluacionUi);
      }
    }

    rubricaEvaluacionUi?.promedio = DomainTools.promedio(notas);
    rubricaEvaluacionUi?.desviacionEstandar = DomainTools.desviacionEstandar(notas);
    print("updateEvaluacion: promedio: ${DomainTools.promedio(notas)} nombre: ${rubricaEvaluacionUi?.titulo}");
    await (SQL.update(SQL.rubroEvaluacionProceso)
      ..where((tbl) => tbl.rubroEvalProcesoId.equals(rubricaEvaluacionUi?.rubroEvaluacionId)))
        .write(
        RubroEvaluacionProcesoCompanion(
          promedio:  Value(rubricaEvaluacionUi?.promedio),
          desviacionEstandar: Value(rubricaEvaluacionUi?.desviacionEstandar),
          usuarioAccionId: Value(usuarioId??0,),
          fechaAccion: Value(DateTime.now()),
          syncFlag: Value(EstadoSync.FLAG_UPDATED),
        ));



    for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUi?.rubrosDetalleList??[]){
      List<double> notas = [];
      for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi.evaluacionUiList??[]){
        notas.add(evaluacionUi.nota??0);
        if(evaluacionUi.alumnoId == alumnoId || alumnoId == null){
          evaluacionesList.add(evaluacionUi);
        }
      }

      rubricaEvaluacionUi.promedio = DomainTools.promedio(notas);
      rubricaEvaluacionUi.desviacionEstandar = DomainTools.desviacionEstandar(notas);
      await (SQL.update(SQL.rubroEvaluacionProceso)
        ..where((tbl) => tbl.rubroEvalProcesoId.equals(rubricaEvaluacionUi.rubroEvaluacionId)))
          .write(
          RubroEvaluacionProcesoCompanion(
            promedio:  Value(rubricaEvaluacionUi.promedio),
            desviacionEstandar: Value(rubricaEvaluacionUi.desviacionEstandar),
            usuarioAccionId: Value(usuarioId??0,),
            fechaAccion: Value(DateTime.now()),
            syncFlag: Value(EstadoSync.FLAG_UPDATED),
          ));
    }

    for(EvaluacionUi evaluacionUi in evaluacionesList){
      if(evaluacionUi.evaluacionId == null){

        String? key = IdGenerator.generateId();
        await SQL.batch((batch) async {
          EvaluacionProcesoData evaluacionProcesoData = new EvaluacionProcesoData(
            evaluacionProcesoId: key,
            usuarioCreacionId: usuarioId,
            fechaCreacion: DateTime.now(),
            usuarioAccionId: usuarioId,
            fechaAccion: DateTime.now(),
            rubroEvalProcesoId: (evaluacionUi.rubroEvaluacionId??"").isNotEmpty?evaluacionUi.rubroEvaluacionId:evaluacionUi.rubroEvaluacionUi?.rubroEvaluacionId,
            nombres: evaluacionUi.personaUi?.nombres,
            apellidoPaterno: evaluacionUi.personaUi?.apellidoPaterno,
            apellidoMaterno: evaluacionUi.personaUi?.apellidoMaterno,
            foto: evaluacionUi.personaUi?.foto,
            alumnoId: (evaluacionUi.personaUi?.personaId??0)>0?evaluacionUi.personaUi?.personaId:evaluacionUi.alumnoId,
            calendarioPeriodoId: rubricaEvaluacionUi?.calendarioPeriodoId,
            equipoId: evaluacionUi.equipoId,
            escala: evaluacionUi.escala,
            evaluacionResultadoId: null,
            visto: null,
            valorTipoNotaId: evaluacionUi.valorTipoNotaId,
            msje: null,//Cuando se crea los comentario
            nota: evaluacionUi.nota??0.0,
            sesionAprendizajeId: rubricaEvaluacionUi?.sesionAprendizajeId,
            publicado: evaluacionUi.publicado,
            syncFlag: EstadoSync.FLAG_ADDED,
          );

          evaluacionUi.evaluacionId =key;
          evaluacionUi.personaUi?.soloApareceEnElCurso = false;

          batch.insert(SQL.evaluacionProceso, evaluacionProcesoData, mode: InsertMode.insertOrReplace);
        });
      }else{

        await (SQL.update(SQL.evaluacionProceso)
          ..where((tbl) => tbl.evaluacionProcesoId.equals(evaluacionUi.evaluacionId)))
            .write(
            EvaluacionProcesoCompanion(
              valorTipoNotaId: Value(evaluacionUi.valorTipoNotaId),
              nota: Value(evaluacionUi.nota),
              publicado: Value(evaluacionUi.publicado),
              usuarioAccionId: Value(usuarioId??0,),
              fechaAccion: Value(DateTime.now()),
              syncFlag: Value(EstadoSync.FLAG_UPDATED),
            ));

      }
    }

  }

  @override
  Future<void> eliminarEvaluacion(RubricaEvaluacionUi? rubricaEvaluacionUi, int usuarioId) async {

    AppDataBase SQL = AppDataBase();
    List<String> rubroEvaluacionIdList = [];
    var queryRubroDetalle = SQL.select(SQL.rubroEvaluacionProceso).join([
      innerJoin(SQL.rubroEvalRNPFormula, SQL.rubroEvalRNPFormula.rubroEvaluacionSecId.equalsExp(SQL.rubroEvaluacionProceso.rubroEvalProcesoId))
    ]);
    queryRubroDetalle.where(SQL.rubroEvalRNPFormula.rubroEvaluacionPrimId.equals(rubricaEvaluacionUi?.rubroEvaluacionId));

    rubroEvaluacionIdList.add(rubricaEvaluacionUi?.rubroEvaluacionId??"");
    //print("Eliminar rubro ${rubricaEvaluacionUi?.rubroEvaluacionId}");
    for(var row in await queryRubroDetalle.get()){
      RubroEvaluacionProcesoData rubroEvaluacionProcesoData = row.readTable(SQL.rubroEvaluacionProceso);

      rubroEvaluacionIdList.add(rubroEvaluacionProcesoData.rubroEvalProcesoId);
      //print("Eliminar rubro ${rubroEvaluacionProcesoData.rubroEvalProcesoId}");
    }

    await (SQL.update(SQL.rubroEvaluacionProceso)
      ..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdList)))
        .write(
        RubroEvaluacionProcesoCompanion(
          estadoId: Value(RubroRepository.ESTADO_ELIMINADO),
          //tareaId: Value(null),// No s epuede eliminar aqui por que aqui se actualiza al firebase
          usuarioAccionId: Value(usuarioId),
          fechaAccion: Value(DateTime.now()),
          syncFlag: Value(EstadoSync.FLAG_UPDATED),
        ));

    await (SQL.update(SQL.tarea)
      ..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdList)))
        .write(
        TareaCompanion(
          rubroEvalProcesoId: Value(null),
        ));


  }

  @override
  Future<void> updatePesoRubro(RubricaEvaluacionUi? rubricaEvaluacionUi, int usuarioId) async {
    AppDataBase SQL = AppDataBase();
    //print("updatePesoRubro: ${rubricaEvaluacionUi?.rubricaIdRubroCabecera}");
    await (SQL.update(SQL.rubroEvaluacionProceso)
      ..where((tbl) => tbl.rubroEvalProcesoId.equals(rubricaEvaluacionUi?.rubricaIdRubroCabecera)))
        .write(
        RubroEvaluacionProcesoCompanion(
          usuarioAccionId: Value(usuarioId),
          fechaAccion: Value(DateTime.now()),
          syncFlag: Value(EstadoSync.FLAG_UPDATED),
        ));
    //print("updatePesoRubro: ${rubricaEvaluacionUi?.peso}");
    await (SQL.update(SQL.rubroEvaluacionProceso)
      ..where((tbl) => tbl.rubroEvalProcesoId.equals(rubricaEvaluacionUi?.rubroEvaluacionId)))
        .write(
        RubroEvaluacionProcesoCompanion(
          peso: Value(rubricaEvaluacionUi?.peso??0),
          usuarioAccionId: Value(usuarioId),
          fechaAccion: Value(DateTime.now()),
          syncFlag: Value(EstadoSync.FLAG_UPDATED),
        ));
  }

  @override
  Future<List<RubricaEvaluacionUi>> getRubroEvaluacionSesionList(int? silaboEventoId, int? calendarioPeriodoId,  int sesionAprendizajeDocenteId, int sesionAprendizajeAlumonId) async{
    print("getRubroEvaluacionSesionList ${sesionAprendizajeDocenteId} ${sesionAprendizajeAlumonId}");
    AppDataBase SQL = AppDataBase();
    var query = SQL.select(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
    query.where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    query.where((tbl) => tbl.sesionAprendizajeId.isIn([sesionAprendizajeDocenteId, sesionAprendizajeAlumonId]));
    //query.where((tbl) => tbl.sesionAprendizajeId.isNotIn([0]));
    query.where((tbl) => tbl.tiporubroid.isIn([TIPO_RUBRO_BIMENSIONAL, TIPO_RUBRO_UNIDIMENCIONAL]));
    //query.where((tbl) => tbl.tipoFormulaId.isNull());
    //query.where((tbl) => tbl.tipoFormulaId.equals(0));
    query.where((tbl) => tbl.estadoId.isNotIn([RubroRepository.ESTADO_ELIMINADO]));
    query.orderBy([(tbl)=> OrderingTerm.desc(tbl.fechaCreacion)]);


    List<String> rubricaIdList =[];
    List<RubricaEvaluacionUi> rubricaEvalProcesoUiList = [];
    List<RubroEvaluacionProcesoData> rubroEvalProcesoList = await query.get();
    print("rubricaEvalProcesoUiList: ${rubroEvalProcesoList.length}");
    for(RubroEvaluacionProcesoData rubroEvaluacionProcesoData in  rubroEvalProcesoList){
      if((rubroEvaluacionProcesoData.tipoFormulaId??0)!=0)continue;
      //if((rubroEvaluacionProcesoData.sesionAprendizajeId??0)==0)continue;
      rubricaIdList.add(rubroEvaluacionProcesoData.rubroEvalProcesoId);
      RubricaEvaluacionUi rubricaEvaluacionUi = convertRubricaEvaluacionUi(rubroEvaluacionProcesoData, 0.0);
      rubricaEvalProcesoUiList.add(rubricaEvaluacionUi);
    }

    var queryEval = SQL.select(SQL.evaluacionProceso).join([
      innerJoin(SQL.rubroEvaluacionProceso, SQL.evaluacionProceso.rubroEvalProcesoId.equalsExp(SQL.rubroEvaluacionProceso.rubroEvalProcesoId))
    ]);
    queryEval.where(SQL.rubroEvaluacionProceso.silaboEventoId.equals(silaboEventoId));
    queryEval.where(SQL.rubroEvaluacionProceso.calendarioPeriodoId.equals(calendarioPeriodoId));

    for(var row in await queryEval.get()){
      EvaluacionProcesoData evalRubroEvalProceso = row.readTable(SQL.evaluacionProceso);
      for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvalProcesoUiList){
        if(rubricaEvaluacionUi.rubroEvaluacionId == evalRubroEvalProceso.rubroEvalProcesoId){
          rubricaEvaluacionUi.cantEvaluaciones = (rubricaEvaluacionUi.cantEvaluaciones??0) + 1;
          if((evalRubroEvalProceso.publicado??0) == 1){
            rubricaEvaluacionUi.cantEvalPublicadas = (rubricaEvaluacionUi.cantEvalPublicadas??0) + 1;
          }
        }
      }
    }
    //#region Agregar la cantidad de rubros Asociados
    var queryRubroDetalle = SQL.select(SQL.rubroEvalRNPFormula).join([
      innerJoin(SQL.rubroEvaluacionProceso, SQL.rubroEvalRNPFormula.rubroEvaluacionSecId.equalsExp(SQL.rubroEvaluacionProceso.rubroEvalProcesoId))
    ]);
    queryRubroDetalle.where(SQL.rubroEvalRNPFormula.rubroEvaluacionPrimId.isIn(rubricaIdList));
    queryRubroDetalle.where(SQL.rubroEvaluacionProceso.estadoId.isNotIn([RubroRepository.ESTADO_ELIMINADO]));

    for(var row in await queryRubroDetalle.get()){
      RubroEvalRNPFormulaData rubroEvalRNPFormulaData = row.readTable(SQL.rubroEvalRNPFormula);
      for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvalProcesoUiList){
        if(rubroEvalRNPFormulaData.rubroEvaluacionPrimId == rubricaEvaluacionUi.rubroEvaluacionId){
          rubricaEvaluacionUi.cantidadRubroDetalle =  (rubricaEvaluacionUi.cantidadRubroDetalle??0) + 1;
        }
      }
    }

    return rubricaEvalProcesoUiList;
  }

  @override
  Future<String?> getRubroEvaluacionIdTarea(String? tareaId) async{
    AppDataBase SQL = AppDataBase();
    var query = SQL.selectSingle(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.tareaId.equals(tareaId));
    query.where((tbl) => tbl.tiporubroid.isIn([TIPO_RUBRO_UNIDIMENCIONAL, TIPO_RUBRO_BIMENSIONAL]));


    RubroEvaluacionProcesoData? rubroEvaluacionProcesoData = await query.getSingleOrNull();

    return rubroEvaluacionProcesoData?.rubroEvalProcesoId;
  }

  @override
  Future<Map<String, dynamic>> getUpdateRubroEvaluacionTareaData(RubricaEvaluacionUi? rubricaEvaluacionUi, int usuarioId) async {

    AppDataBase SQL = AppDataBase();
    Map<String,dynamic> rubroEvaluacionData = Map();
    rubroEvaluacionData["rubroEvaluacionProceso"] = null;
    rubroEvaluacionData["rubroEvaluacionAsociado"] = [];
    rubroEvaluacionData["evaluacionProceso"] = [];
    rubroEvaluacionData["rubroEvalRNPFormula"] = [];
    //rubroEvaluacionData["criterioRubroEvaluacion"] = [];
    //rubroEvaluacionData["rubroCampotematico"] = [];
    //print("rubricaEvaluacionUi: ${rubricaEvaluacionUi?.rubroEvaluacionId}");


    List<double> notas = [];
    for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi?.evaluacionUiList??[]){
      notas.add(evaluacionUi.nota??0);
    }
    rubricaEvaluacionUi?.promedio = DomainTools.promedio(notas);
    rubricaEvaluacionUi?.desviacionEstandar = DomainTools.desviacionEstandar(notas);

    RubroEvaluacionProcesoData rubroEvaluacionProceso = await (SQL.select(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.equals(rubricaEvaluacionUi?.rubroEvaluacionId))).getSingle();

    rubroEvaluacionProceso = rubroEvaluacionProceso.copyWith(
      promedio: rubricaEvaluacionUi?.promedio,
      desviacionEstandar: rubricaEvaluacionUi?.desviacionEstandar,
      syncFlag: rubroEvaluacionProceso.syncFlag != EstadoSync.FLAG_ADDED? EstadoSync.FLAG_UPDATED : EstadoSync.FLAG_ADDED,
      fechaAccion: DateTime.now(),
      usuarioAccionId: usuarioId,
    );
    print("rubroEvaluacionProceso ${rubroEvaluacionProceso.titulo}");
    rubroEvaluacionData["rubroEvaluacionProceso"] = rubroEvaluacionProceso;

    for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi?.evaluacionUiList??[]){
      EvaluacionProcesoData? evaluacionProceso = await (SQL.selectSingle(SQL.evaluacionProceso)..where((tbl) => tbl.evaluacionProcesoId.equals(evaluacionUi.evaluacionId))).getSingleOrNull();

      evaluacionProceso = evaluacionProceso?.copyWith(
        valorTipoNotaId: evaluacionUi.valorTipoNotaId??"",
        publicado: evaluacionUi.publicado,
        nota: evaluacionUi.nota??0,
        syncFlag: EstadoSync.FLAG_UPDATED,
        fechaAccion: DateTime.now(),
        usuarioAccionId: usuarioId,
      );

      if(evaluacionUi.evaluacionId==null){
        String? key = IdGenerator.generateId();
        evaluacionProceso = new EvaluacionProcesoData(
          evaluacionProcesoId: key,
          usuarioCreacionId: usuarioId,
          fechaCreacion: DateTime.now(),
          usuarioAccionId: usuarioId,
          fechaAccion: DateTime.now(),
          rubroEvalProcesoId: (evaluacionUi.rubroEvaluacionId??"").isNotEmpty?evaluacionUi.rubroEvaluacionId:evaluacionUi.rubroEvaluacionUi?.rubroEvaluacionId,
          nombres: evaluacionUi.personaUi?.nombres,
          apellidoPaterno: evaluacionUi.personaUi?.apellidoPaterno,
          apellidoMaterno: evaluacionUi.personaUi?.apellidoMaterno,
          foto: evaluacionUi.personaUi?.foto,
          alumnoId: (evaluacionUi.personaUi?.personaId??0)>0?evaluacionUi.personaUi?.personaId:evaluacionUi.alumnoId,
          calendarioPeriodoId: rubricaEvaluacionUi?.calendarioPeriodoId,
          equipoId: evaluacionUi.equipoId,
          escala: evaluacionUi.escala,
          evaluacionResultadoId: null,
          visto: null,
          valorTipoNotaId: evaluacionUi.valorTipoNotaId,
          msje: null,//Cuando se crea los comentario
          nota: evaluacionUi.nota??0.0,
          sesionAprendizajeId: rubricaEvaluacionUi?.sesionAprendizajeId,
          publicado: evaluacionUi.publicado,
          syncFlag: EstadoSync.FLAG_ADDED,
        );

        evaluacionUi.evaluacionId =key;
        evaluacionUi.personaUi?.soloApareceEnElCurso = false;
      }

      rubroEvaluacionData["evaluacionProceso"]?.add(evaluacionProceso);
    }


    for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUi?.rubrosDetalleList??[]) {

      List<double> notas = [];
      for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi.evaluacionUiList??[]){
        notas.add(evaluacionUi.nota??0);
      }
      rubricaEvaluacionUi.promedio = DomainTools.promedio(notas);
      rubricaEvaluacionUi.desviacionEstandar = DomainTools.desviacionEstandar(notas);

      RubroEvaluacionProcesoData procesoDetalle = await (SQL.select(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.equals(rubricaEvaluacionUi.rubroEvaluacionId))).getSingle();
      rubroEvaluacionProceso = rubroEvaluacionProceso.copyWith(
        promedio: rubricaEvaluacionUi.promedio??0,
        desviacionEstandar: rubricaEvaluacionUi.desviacionEstandar??0,
        syncFlag: EstadoSync.FLAG_UPDATED,
        fechaAccion: DateTime.now(),
        usuarioAccionId: usuarioId,
      );



      rubroEvaluacionData["rubroEvaluacionAsociado"]?.add(procesoDetalle);
      //batch.insert(SQL.rubroEvaluacionProceso, procesoDetalle, mode: InsertMode.insertOrReplace);

      for (EvaluacionUi evaluacionUi in rubricaEvaluacionUi.evaluacionUiList ?? []) {
        EvaluacionProcesoData? evaluacionProceso = await (SQL.selectSingle(SQL.evaluacionProceso)..where((tbl) => tbl.evaluacionProcesoId.equals(evaluacionUi.evaluacionId))).getSingleOrNull();
        evaluacionProceso = evaluacionProceso?.copyWith(
          valorTipoNotaId: evaluacionUi.valorTipoNotaId??"",
          publicado: evaluacionUi.publicado,
          nota: evaluacionUi.nota??0,
          syncFlag: EstadoSync.FLAG_UPDATED,
          fechaAccion: DateTime.now(),
          usuarioAccionId: usuarioId,
        );

        if(evaluacionUi.evaluacionId==null){
          String? key = IdGenerator.generateId();
          evaluacionProceso = new EvaluacionProcesoData(
            evaluacionProcesoId: key,
            usuarioCreacionId: usuarioId,
            fechaCreacion: DateTime.now(),
            usuarioAccionId: usuarioId,
            fechaAccion: DateTime.now(),
            rubroEvalProcesoId: (evaluacionUi.rubroEvaluacionId??"").isNotEmpty?evaluacionUi.rubroEvaluacionId:evaluacionUi.rubroEvaluacionUi?.rubroEvaluacionId,
            nombres: evaluacionUi.personaUi?.nombres,
            apellidoPaterno: evaluacionUi.personaUi?.apellidoPaterno,
            apellidoMaterno: evaluacionUi.personaUi?.apellidoMaterno,
            foto: evaluacionUi.personaUi?.foto,
            alumnoId: (evaluacionUi.personaUi?.personaId??0)>0?evaluacionUi.personaUi?.personaId:evaluacionUi.alumnoId,
            calendarioPeriodoId: rubricaEvaluacionUi.calendarioPeriodoId,
            equipoId: evaluacionUi.equipoId,
            escala: evaluacionUi.escala,
            evaluacionResultadoId: null,
            visto: null,
            valorTipoNotaId: evaluacionUi.valorTipoNotaId,
            msje: null,//Cuando se crea los comentario
            nota: evaluacionUi.nota??0.0,
            sesionAprendizajeId: rubricaEvaluacionUi.sesionAprendizajeId,
            publicado: evaluacionUi.publicado,
            syncFlag: EstadoSync.FLAG_ADDED,
          );

          evaluacionUi.evaluacionId =key;
          evaluacionUi.personaUi?.soloApareceEnElCurso = false;
        }

        rubroEvaluacionData["evaluacionProceso"]?.add(evaluacionProceso);
        //batch.insert(SQL.evaluacionProceso, evaluacionProceso, mode: InsertMode.insertOrReplace);
      }
    }

    return rubroEvaluacionData;

  }

  @override
  Future<bool> isRubroSincronizado(String? rubroEvalProcesoId) async{
    AppDataBase SQL = AppDataBase();
    RubroEvaluacionProcesoData rubroEvaluacionProceso = await (SQL.select(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.equals(rubroEvalProcesoId))).getSingle();
    return rubroEvaluacionProceso.syncFlag != EstadoSync.FLAG_ADDED && rubroEvaluacionProceso.syncFlag != EstadoSync.FLAG_UPDATED && rubroEvaluacionProceso.error_guardar != 1 && rubroEvaluacionProceso.error_guardar != 2;
  }

  @override
  Future<Map<String, dynamic>> updateRubroEvaluacionData(RubricaEvaluacionUi? rubricaEvaluacionUi, int usuarioId) async {
    AppDataBase SQL = AppDataBase();
    Map<String,dynamic> rubroEvaluacionData = Map();
    rubroEvaluacionData["rubroEvaluacionProceso"] = null;
    rubroEvaluacionData["criterioRubroEvaluacion"] = [];
    rubroEvaluacionData["rubroCampotematico"] = [];
    rubroEvaluacionData["rubroEvaluacionAsociado"] = [];
    rubroEvaluacionData["rubroEvalRNPFormula"] = [];
    //rubroEvaluacionId = IdGenerator.generateId();
    RubroEvaluacionProcesoData? rubroEvaluacionProceso = await (SQL.select(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.equals(rubricaEvaluacionUi?.rubroEvaluacionId))).getSingleOrNull();

    rubroEvaluacionProceso = rubroEvaluacionProceso?.copyWith(
      titulo:  rubricaEvaluacionUi?.titulo??"",
      syncFlag: EstadoSync.FLAG_UPDATED,
      tipoEvaluacionId: rubricaEvaluacionUi?.tipoEvaluacionId,
      fechaAccion: DateTime.now(),
      usuarioAccionId: usuarioId,
    );

    print("rubroEvaluacionProceso ${rubroEvaluacionProceso?.titulo}");
    rubroEvaluacionData["rubroEvaluacionProceso"] = rubroEvaluacionProceso;

    if(rubricaEvaluacionUi?.tipoRubroEvaluacion != TipoRubroEvaluacion.UNIDIMENSIONAL){
      for(CriterioPesoUi criterioPesoUi in rubricaEvaluacionUi?.criterioPesoUiList??[]){
        //print("criterioPesoUi ${criterioPesoUi.criterioUi?.rubroEvaluacionId}");
        RubroEvaluacionProcesoData? procesoDetalle = await (SQL.select(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.equals(criterioPesoUi.criterioUi?.rubroEvaluacionId))).getSingleOrNull();
        procesoDetalle = rubroEvaluacionProceso?.copyWith(
          titulo:  rubricaEvaluacionUi?.titulo??"",
          syncFlag: EstadoSync.FLAG_UPDATED,
          tipoEvaluacionId: rubricaEvaluacionUi?.tipoEvaluacionId,
          fechaAccion: DateTime.now(),
          usuarioAccionId: usuarioId,
        );
        print("rubroEvaluacionAsociado ${procesoDetalle?.titulo}");
        rubroEvaluacionData["rubroEvaluacionAsociado"]?.add(procesoDetalle);

        var query = SQL.select(SQL.rubroEvalRNPFormula)..where((tbl) => tbl.rubroEvaluacionPrimId.equals(rubricaEvaluacionUi?.rubroEvaluacionId));
          query.where((tbl) => tbl.rubroEvaluacionSecId.equals(criterioPesoUi.criterioUi?.rubroEvaluacionId));

        RubroEvalRNPFormulaData? rubroEvalRNPFormula = await (query).getSingleOrNull();
        rubroEvalRNPFormula = rubroEvalRNPFormula?.copyWith(
          peso: criterioPesoUi.criterioUi?.peso,
          syncFlag: EstadoSync.FLAG_UPDATED,
          fechaAccion: DateTime.now(),
          usuarioAccionId: usuarioId,
        );
        rubroEvaluacionData["rubroEvalRNPFormula"]?.add(rubroEvalRNPFormula);
        //batch.insert(SQL.rubroEvalRNPFormula, rubroEvalRNPFormula, mode: InsertMode.insertOrReplace);
/*
      for(CriterioValorTipoNotaUi criterioValorTipoNotaUi in rubricaEvaluacionUi?.criterioValorTipoNotaUiList??[]){
        if(criterioValorTipoNotaUi.criterioUi?.desempenioIcdId == criterioPesoUi.criterioUi?.desempenioIcdId){
          CriterioRubroEvaluacionData criterioRubroEvaluacionData = CriterioRubroEvaluacionData(
              criteriosEvaluacionId: IdGenerator.generateId(),
              rubroEvalProcesoId: rubroEvaluacionDetalleId,
              valorTipoNotaId: criterioValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId,
              descripcion: "");
          rubroEvaluacionData["criterioRubroEvaluacion"]?.add(criterioRubroEvaluacionData);
          //batch.insert(SQL.criterioRubroEvaluacion, criterioRubroEvaluacionData);
        }
      }*/



      }
    }


    return rubroEvaluacionData;
  }

  @override
  Future<void> saveComentario(RubroComentarioUi? rubroComentarioUi, int? usuarioId) async{

    AppDataBase SQL = AppDataBase();
    RubroComentarioData? rubroComentarioData = await (SQL.select(SQL.rubroComentario)..where((tbl) => tbl.evaluacionProcesoComentarioId.equals(rubroComentarioUi?.evaluacionRubroComentarioId))).getSingleOrNull();
    if(rubroComentarioData==null){
      rubroComentarioData = RubroComentarioData(
          evaluacionProcesoComentarioId: rubroComentarioUi?.evaluacionRubroComentarioId??"",
          descripcion: rubroComentarioUi?.comentario,
          usuarioCreacionId: usuarioId,
          fechaCreacion: DateTime.now(),
          fechaAccion: DateTime.now(),
          delete: (rubroComentarioUi?.eliminar??false)?1:0,
          comentarioId: '',
          evaluacionProcesoId: rubroComentarioUi?.evaluacionId,
          usuarioAccionId: usuarioId,
          syncFlag: EstadoSync.FLAG_ADDED);
      print("evaluacionProcesoId: ${rubroComentarioUi?.evaluacionId}");
      await SQL.into(SQL.rubroComentario).insert(rubroComentarioData, mode: InsertMode.insertOrReplace);
    }else{

      await (SQL.update(SQL.rubroComentario)
        ..where((tbl) => tbl.evaluacionProcesoComentarioId.equals(rubroComentarioUi?.evaluacionRubroComentarioId)))
          .write(
          RubroComentarioCompanion(
              descripcion:  Value(rubroComentarioUi?.comentario),
              syncFlag: Value(EstadoSync.FLAG_UPDATED),
              fechaAccion: Value(DateTime.now()),
              usuarioAccionId: Value(usuarioId),
              delete: Value((rubroComentarioUi?.eliminar??false)?1:0)
          ));
    }

    await (SQL.update(SQL.rubroEvaluacionProceso)
      ..where((tbl) => tbl.rubroEvalProcesoId.equals(rubroComentarioUi?.rubroEvaluacionId)))
        .write(
        RubroEvaluacionProcesoCompanion(
          usuarioAccionId: Value(usuarioId),
          fechaAccion: Value(DateTime.now()),
          syncFlag: Value(EstadoSync.FLAG_UPDATED),
        ));

  }

  @override
  Future<Map<String, dynamic>> getRubroComentarioData(RubroComentarioUi? rubroComentarioUi, int usuarioId) async{
    AppDataBase SQL = AppDataBase();
    RubroComentarioData? rubroComentarioData = await (SQL.select(SQL.rubroComentario)..where((tbl) => tbl.evaluacionProcesoComentarioId.equals(rubroComentarioUi?.evaluacionRubroComentarioId))).getSingleOrNull();
    if(rubroComentarioData==null){
      rubroComentarioData = RubroComentarioData(
          evaluacionProcesoComentarioId: rubroComentarioUi?.evaluacionRubroComentarioId??"",
          descripcion: rubroComentarioUi?.comentario,
          usuarioCreacionId: usuarioId,
          comentarioId: '0',
          fechaCreacion: rubroComentarioUi?.fechaCreacion,
          fechaAccion: DateTime.now(),
          usuarioAccionId: usuarioId,
          syncFlag: EstadoSync.FLAG_ADDED);
    }else{
      rubroComentarioData = rubroComentarioData.copyWith(
          descripcion:  rubroComentarioUi?.comentario,
          comentarioId: '0',
          syncFlag: EstadoSync.FLAG_UPDATED,
          fechaAccion: DateTime.now(),
          usuarioAccionId: usuarioId,
      );
    }

    return DomainTools.removeNull(rubroComentarioData.toJson());

  }

  @override
  void saveRubroEvidencias(RubroEvidenciaUi? rubroEvidenciaUi, int usuarioId) async{
    AppDataBase SQL = AppDataBase();
    ArchivoRubroData? archivoRubroData = await (SQL.select(SQL.archivoRubro)..where((tbl) => tbl.archivoRubroId.equals(rubroEvidenciaUi?.archivoRubroId))).getSingleOrNull();
    if(archivoRubroData==null){

      archivoRubroData = ArchivoRubroData(
          archivoRubroId: rubroEvidenciaUi?.archivoRubroId??"",
          url: rubroEvidenciaUi?.url,
          usuarioCreacionId: usuarioId,
          fechaCreacion: DateTime.now(),
          fechaAccion: DateTime.now(),
          delete: (rubroEvidenciaUi?.eliminar??false)?1:0,
          evaluacionProcesoId: rubroEvidenciaUi?.evaluacionUi?.evaluacionId,
          usuarioAccionId: usuarioId,
          tipoArchivoId: getTipoId(rubroEvidenciaUi?.tipoRecurso),
          syncFlag: EstadoSync.FLAG_ADDED);
      await SQL.into(SQL.archivoRubro).insert(archivoRubroData, mode: InsertMode.insertOrReplace);
    }else{

      await (SQL.update(SQL.archivoRubro)
        ..where((tbl) => tbl.archivoRubroId.equals(rubroEvidenciaUi?.archivoRubroId)))
          .write(
          ArchivoRubroCompanion(
              url:  Value(rubroEvidenciaUi?.url),
              syncFlag: Value(EstadoSync.FLAG_UPDATED),
              fechaAccion: Value(DateTime.now()),
              usuarioAccionId: Value(usuarioId),
              delete: Value((rubroEvidenciaUi?.eliminar??false)?1:0)
          ));
    }

    await (SQL.update(SQL.rubroEvaluacionProceso)
      ..where((tbl) => tbl.rubroEvalProcesoId.equals(rubroEvidenciaUi?.rubroEvaluacionId)))
        .write(
        RubroEvaluacionProcesoCompanion(
          usuarioAccionId: Value(usuarioId),
          fechaAccion: Value(DateTime.now()),
          syncFlag: Value(EstadoSync.FLAG_UPDATED),
        ));
  }

  int? getTipoId(TipoRecursosUi? tipoRecursosUi){

    switch(tipoRecursosUi){

      case TipoRecursosUi.TIPO_VIDEO:
        return DomainTipos.TIPO_RECURSO_VIDEO;
      case TipoRecursosUi.TIPO_VINCULO:
        return DomainTipos.TIPO_RECURSO_VINCULO;
      case TipoRecursosUi.TIPO_DOCUMENTO:
        return DomainTipos.TIPO_RECURSO_DOCUMENTO;
      case TipoRecursosUi.TIPO_IMAGEN:
        return DomainTipos.TIPO_RECURSO_IMAGEN;
      case TipoRecursosUi.TIPO_AUDIO:
        return DomainTipos.TIPO_RECURSO_AUDIO;
      case TipoRecursosUi.TIPO_HOJA_CALCULO:
        return DomainTipos.TIPO_RECURSO_HOJA_CALUCLO;
      case TipoRecursosUi.TIPO_DIAPOSITIVA:
        return DomainTipos.TIPO_RECURSO_DIAPOSITIVA;
      case TipoRecursosUi.TIPO_PDF:
        return DomainTipos.TIPO_RECURSO_PDF;
      case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
        return DomainTipos.TIPO_RECURSO_YOUTUBE;
      case TipoRecursosUi.TIPO_VINCULO_DRIVE:
        return DomainTipos.TIPO_RECURSO_VINCULO;
      case TipoRecursosUi.TIPO_RECURSO:
        return DomainTipos.TIPO_RECURSO_MATERIALES;
      case TipoRecursosUi.TIPO_ENCUESTA:
        return DomainTipos.TIPO_RECURSO_MATERIALES;
      default:
        return DomainTipos.TIPO_RECURSO_VINCULO;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRubroEvalNoEnviadosServidorSerialAll() async{
    AppDataBase SQL = AppDataBase();
    var query = SQL.select(SQL.rubroEvaluacionProceso);
      //..where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
    //query.where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    query.where((tbl) => tbl.tiporubroid.isIn([TIPO_RUBRO_BIMENSIONAL, TIPO_RUBRO_UNIDIMENCIONAL]));
    //query.where((tbl) => tbl.tipoFormulaId.isNull());
    //query.where((tbl) => tbl.tipoFormulaId.equals(0));
    query.where((tbl) => tbl.estadoId.isNotIn([RubroRepository.ESTADO_ELIMINADO]));
    query.where((tbl) => tbl.syncFlag.isIn([EstadoSync.FLAG_ADDED, EstadoSync.FLAG_UPDATED]));

    List<Map<String,dynamic>> listaExportar = [];
    List<RubroEvaluacionProcesoData> rubroEvalProcesoList = await query.get();
    for(RubroEvaluacionProcesoData rubroEvaluacionProcesoData in rubroEvalProcesoList){
      if((rubroEvaluacionProcesoData.tipoFormulaId??0)!=0)continue;
      listaExportar.add(await transformarRubroEvaluacionDataToSerial(SQL, rubroEvaluacionProcesoData));
  }

    return listaExportar;
  }

  @override
  Future<void> updateEvalEquipo(RubricaEvaluacionUi? rubricaEvaluacionUi, String? equipoId, int? usuarioId) async {
    AppDataBase SQL = AppDataBase();

    List<RubricaEvaluacionEquipoUi> evaluacionesList = [];
    List<double> notas = [];
    for(RubricaEvaluacionEquipoUi evaluacionUi in rubricaEvaluacionUi?.equipoUiList??[]){
      notas.add(evaluacionUi.evaluacionEquipoUi?.nota??0);
      if(evaluacionUi.equipoId == equipoId){
        evaluacionesList.add(evaluacionUi);
      }
    }

    for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUi?.rubrosDetalleList??[]){
      List<double> notas = [];
      for(RubricaEvaluacionEquipoUi evaluacionUi in rubricaEvaluacionUi.equipoUiList??[]){
        notas.add(evaluacionUi.evaluacionEquipoUi?.nota??0);
        if(evaluacionUi.equipoId == equipoId){
          evaluacionesList.add(evaluacionUi);
        }
      }
    }

    for(RubricaEvaluacionEquipoUi evaluacionUi in evaluacionesList){
      await (SQL.update(SQL.equipoEvaluacion)
        ..where((tbl) => tbl.equipoEvaluacionProcesoId.equals(evaluacionUi.evaluacionEquipoUi?.equipoEvaluacionProcesoId)))
          .write(
          EquipoEvaluacionCompanion(
            valorTipoNotaId: Value(evaluacionUi.evaluacionEquipoUi?.valorTipoNotaUi?.valorTipoNotaId),
            nota: Value(evaluacionUi.evaluacionEquipoUi?.nota),
            usuarioAccionId: Value(usuarioId??0,),
            fechaAccion: Value(DateTime.now()),
            syncFlag: Value(EstadoSync.FLAG_UPDATED),
          ));
    }
  }

  @override
  Future<void> eliminarTareaEvaluacion(TareaUi? tareaUi, int usuarioId) async{
    AppDataBase SQL = AppDataBase();


    await (SQL.update(SQL.rubroEvaluacionProceso)
    ..where((tbl) => tbl.tareaId.equals(tareaUi?.tareaId)))
        .write(
    RubroEvaluacionProcesoCompanion(
    estadoId: Value(RubroRepository.ESTADO_ELIMINADO),
    //tareaId: Value(null),// No s epuede eliminar aqui por que aqui se actualiza al firebase
    usuarioAccionId: Value(usuarioId),
    fechaAccion: Value(DateTime.now()),
    syncFlag: Value(EstadoSync.FLAG_EXPORTED),
    ));

    await (SQL.update(SQL.tarea)
    ..where((tbl) => tbl.rubroEvalProcesoId.equals(tareaUi?.tareaId)))
        .write(
    TareaCompanion(
    rubroEvalProcesoId: Value(null),
    ));
  }


}
