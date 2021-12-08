import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:collection/collection.dart';

class ProcesarTareaEvaluacion{
  ConfiguracionRepository configuracionRepository;
  RubroRepository repository;
  HttpDatosRepository httpDatosRepository;




  ProcesarTareaEvaluacion(
      this.configuracionRepository, this.repository, this.httpDatosRepository);

  Future<HttpStream?> execute(ProcesarTareaEvaluacionParms params, UploadSuccessListen successListen) async{

    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    int georeferenciaId = await configuracionRepository.getGeoreferenciaId();
    print("usuarioId ${usuarioId}");

    return await httpDatosRepository.procesarEvaluacionTarea(urlServidorLocal, georeferenciaId, usuarioId, params.calendarioPeriodoId, params.silaboEventoId, params.unidadEventoId ,params.rubroEvalId, params.tareaId,
            (success, sinConexion) async{
          if(success==null){
            successListen.call(ProcesarTareaEvaluacionResponse(false, sinConexion, true, false));
          }else if(success){
            //await repository.saveRubroEvaluacionData(dataBD);
            //await repository.cambiarEstadoActualizado(params.rubricaEvaluacionUi?.rubroEvaluacionId??"");
            successListen.call(ProcesarTareaEvaluacionResponse(true, sinConexion, false, false));
          }else{
            print("ProcesarTareaEvaluacion :/ error");
            successListen.call(ProcesarTareaEvaluacionResponse(false, sinConexion, false, false));
          }
        });

  }
}
typedef UploadSuccessListen = void Function(ProcesarTareaEvaluacionResponse response);

class ProcesarTareaEvaluacionParms {
  int? calendarioPeriodoId;
  int? silaboEventoId;
  int? unidadEventoId;
  String? rubroEvalId;
  String? tareaId;

  ProcesarTareaEvaluacionParms(
      this.calendarioPeriodoId,
      this.silaboEventoId,
      this.unidadEventoId,
      this.rubroEvalId,
      this.tareaId);
}

class ProcesarTareaEvaluacionResponse {
  bool success;
  bool offline;
  bool errorServidor;
  bool errorInterno;
  ProcesarTareaEvaluacionResponse(this.success, this.offline, this.errorServidor, this.errorInterno);
}
