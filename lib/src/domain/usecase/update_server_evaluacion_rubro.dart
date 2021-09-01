import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class UpdateServerEvaluacionRubro {
  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;
  RubroRepository repository;

  UpdateServerEvaluacionRubro(
      this.configuracionRepository, this.httpDatosRepository, this.repository);

  Future<UpdateServerEvaluacionRubroResponse> execute(UpdateServerEvaluacionRubroParms params) async{
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    int georeferenciaId = await configuracionRepository.getGeoreferenciaId();

    bool? success = false;
    bool offline = false;
    try{
      Map<String, dynamic>? data = await repository.getRubroEvaluacionSerial(params.rubroEvaluacionId??"");
      if(data!=null){
        success = await httpDatosRepository.updateEvaluacionRubroFlutter(urlServidorLocal, params.calendarioPeriodoId??0, params.silaboEventoId??0, georeferenciaId, usuarioId, data);
        if(success??false) await repository.cambiarEstadoActualizado(params.rubroEvaluacionId??"");
      }
    }catch(e){
      offline = true;
    }
    return UpdateServerEvaluacionRubroResponse(success, offline );
  }

}

class UpdateServerEvaluacionRubroParms{
  String? rubroEvaluacionId;
  int? calendarioPeriodoId;
  int? silaboEventoId;

  UpdateServerEvaluacionRubroParms(
      this.rubroEvaluacionId, this.calendarioPeriodoId, this.silaboEventoId);

}

class UpdateServerEvaluacionRubroResponse{
  bool? success;
  bool offline;
  UpdateServerEvaluacionRubroResponse(this.success, this.offline);
}

