import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class UpdateServerEvaluacionCompetencia {
  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;
  RubroRepository repository;

  UpdateServerEvaluacionCompetencia(
      this.configuracionRepository, this.httpDatosRepository, this.repository);

  Future<UpdateServerEvaluacionRubroResponse> execute(UpdateServerEvaluacionRubroParms params) async{
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    int georeferenciaId = await configuracionRepository.getGeoreferenciaId();

    bool? success = false;
    bool offline = false;
    try{
      List<Map<String, dynamic>?> mapList = [];
      for(String rubroEvaluacionId in params.rubroEvaluacionIdList??[]){
        Map<String, dynamic>? data = await repository.getRubroEvaluacionSerial(rubroEvaluacionId);
        if(data != null) mapList.add(data);
      }
      print("mapList: ${mapList.length}");
      print("mapList: ${mapList.isNotEmpty}");
      if(mapList.isNotEmpty){

        success = await httpDatosRepository.updateCompetenciaRubroFlutter(urlServidorLocal, georeferenciaId, usuarioId, mapList);
        if(success??false){
          for(String rubroEvaluacionId in params.rubroEvaluacionIdList??[]){
            await repository.cambiarEstadoActualizado(rubroEvaluacionId);
          }
        }
      }
    }catch(e){
      offline = true;
    }
    print("UpdateServerEvaluacionRubroResponse");
    return UpdateServerEvaluacionRubroResponse(success, offline );
  }

}

class UpdateServerEvaluacionRubroParms{
  List<String>? rubroEvaluacionIdList;

  UpdateServerEvaluacionRubroParms(
      this.rubroEvaluacionIdList);

}

class UpdateServerEvaluacionRubroResponse{
  bool? success;
  bool offline;
  UpdateServerEvaluacionRubroResponse(this.success, this.offline);
}

