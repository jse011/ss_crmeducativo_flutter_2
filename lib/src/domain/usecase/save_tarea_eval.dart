import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:collection/collection.dart';

class SaveTareaEval{
  ConfiguracionRepository configuracionRepository;
  RubroRepository repository;
  HttpDatosRepository httpDatosRepository;


  SaveTareaEval(
      this.configuracionRepository, this.repository, this.httpDatosRepository);

  Future<HttpStream?> execute(SaveTareaEvalParms params, UploadSuccessListen successListen) async{

    RubricaEvaluacionUi rubricaEvaluacionUi = new RubricaEvaluacionUi();
    rubricaEvaluacionUi.rubroEvaluacionId = params.rubricaEvaluacionUi?.rubroEvaluacionId;
    rubricaEvaluacionUi.promedio = params.rubricaEvaluacionUi?.promedio;
    rubricaEvaluacionUi.desviacionEstandar = params.rubricaEvaluacionUi?.desviacionEstandar;
    rubricaEvaluacionUi.desempenioIcdId = params.rubricaEvaluacionUi?.desempenioIcdId;
    List<EvaluacionUi> evaluacionUiList = [];
    for(EvaluacionUi evaluacionUi in params.rubricaEvaluacionUi?.evaluacionUiList??[]){
      int? alumnoId = params.alumnoIdList.firstWhereOrNull((element) => element == evaluacionUi.alumnoId);
      if(alumnoId!=null){
        //print("valorTipoNotaId a enviar: ${evaluacionUi.valorTipoNotaId}");
        evaluacionUiList.add(evaluacionUi);
      }
    }
    rubricaEvaluacionUi.evaluacionUiList = evaluacionUiList;

    List<RubricaEvaluacionUi> rubricaEvalDetalleUiList = [];
    for(RubricaEvaluacionUi rubricaEvalDetalleUi in params.rubricaEvaluacionUi?.rubrosDetalleList??[]){
      if((rubricaEvalDetalleUi.rubroEvaluacionId == params.rubroEvalDetalleId || params.rubroEvalDetalleId == null)){
        RubricaEvaluacionUi rubricaEvaluacionUi = new RubricaEvaluacionUi();
        rubricaEvaluacionUi.rubroEvaluacionId = rubricaEvalDetalleUi.rubroEvaluacionId;
        rubricaEvaluacionUi.desempenioIcdId = rubricaEvalDetalleUi.desempenioIcdId;
        rubricaEvaluacionUi.promedio = rubricaEvalDetalleUi.promedio;
        rubricaEvaluacionUi.desviacionEstandar = rubricaEvalDetalleUi.desviacionEstandar;
        List<EvaluacionUi> evaluacionUiList = [];
        for(EvaluacionUi evaluacionUi in rubricaEvalDetalleUi.evaluacionUiList??[]){
          int? alumnoId = params.alumnoIdList.firstWhereOrNull((element) => element == evaluacionUi.alumnoId);
          if(alumnoId!=null){
            evaluacionUiList.add(evaluacionUi);
          }
        }
        rubricaEvaluacionUi.evaluacionUiList = evaluacionUiList;
        rubricaEvalDetalleUiList.add(rubricaEvaluacionUi);
      }
    }
    rubricaEvaluacionUi.rubrosDetalleList = rubricaEvalDetalleUiList;

    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    int georeferenciaId = await configuracionRepository.getGeoreferenciaId();
    //print("SaveRubroEvaluacionResponse");
    Map<String, dynamic>? dataBDEvaluacion =  await repository.getUpdateRubroEvaluacionData(rubricaEvaluacionUi, usuarioId);

    bool success = true;
    if(await repository.isRubroSincronizado(rubricaEvaluacionUi.rubroEvaluacionId)){
      Map<String, dynamic>? data = await repository.getRubroEvaluacionIdSerial(rubricaEvaluacionUi.rubroEvaluacionId??"");
      if(data!=null){
        try{
          success = await httpDatosRepository.updateEvaluacionRubroFlutter(urlServidorLocal, params.calendarioPeriodoUI?.id??0, params.tareaUi?.silaboEventoId??0, georeferenciaId, usuarioId, data)??false;
        }catch(e){
          success = false;
          print(e.toString());
        }

        if(success){
          await repository.saveRubroEvaluacionData(dataBDEvaluacion);
          await repository.cambiarEstadoActualizado(rubricaEvaluacionUi.rubroEvaluacionId??"");
        }
      }
    }

    Map<String, dynamic>? dataSerial = await repository.getRubroEvaluacionSerial(dataBDEvaluacion);

    if(dataSerial!=null && success){
      return await httpDatosRepository.saveTareaEvalDocente(urlServidorLocal, georeferenciaId, usuarioId, params.calendarioPeriodoUI?.id,params.tareaUi?.silaboEventoId, params.tareaUi?.unidadAprendizajeId ,params.tareaUi?.tareaId,dataSerial,
              (success, sinConexion) async{
            if(success==null){
              successListen.call(SaveTareaEvalResponse(dataBDEvaluacion, false, sinConexion, true, false));
            }else if(success){
              //
              //await repository.cambiarEstadoActualizado(params.rubricaEvaluacionUi?.rubroEvaluacionId??"");
              successListen.call(SaveTareaEvalResponse(dataBDEvaluacion, true, sinConexion, false, false));
            }else{
              //print("saveRubroEvaluacionAllError :/ error");
              successListen.call(SaveTareaEvalResponse(dataBDEvaluacion,false, sinConexion, false, false));
            }
          });

    }else{
      successListen.call(SaveTareaEvalResponse(dataBDEvaluacion,false, false, false, true));
      return null;
    }

  }
}
typedef UploadSuccessListen = void Function(SaveTareaEvalResponse response);

class SaveTareaEvalParms {
  RubricaEvaluacionUi? rubricaEvaluacionUi;
  List<int?> alumnoIdList;
  String? rubroEvalDetalleId;
  TareaUi? tareaUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;
  SaveTareaEvalParms(this.rubricaEvaluacionUi,this.alumnoIdList ,this.rubroEvalDetalleId, this.tareaUi, this.calendarioPeriodoUI);
}

class SaveTareaEvalResponse {
  bool success;
  bool offline;
  bool errorServidor;
  bool errorInterno;
  Map<String, dynamic> dataBD;
  SaveTareaEvalResponse(this.dataBD, this.success, this.offline, this.errorServidor, this.errorInterno);
}
