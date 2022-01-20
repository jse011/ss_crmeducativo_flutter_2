import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_sesion_repository.dart';

class UpdateSesionEstado {
  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;
  UnidadSesionRepository unidadSesionRepository;

  UpdateSesionEstado(this.configuracionRepository, this.httpDatosRepository, this.unidadSesionRepository);

  Future<UpdateSesionResponse> execute(SesionUi? sesionUi) async{

    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    bool? success = false;
    bool offline = false;
    try{
      success = await httpDatosRepository.saveEstadoSesion(urlServidorLocal, sesionUi?.sesionAprendizajeId, UnidadSesionRepository.ESTADO_HECHO, usuarioId);
      if(success??false){
        sesionUi?.sesionEstado = SesionEstado.HECHO;
        await unidadSesionRepository.saveEstadoSesion(sesionUi?.sesionAprendizajeId, UnidadSesionRepository.ESTADO_HECHO);
      }
    }catch(e){
      offline = true;
    }
    return UpdateSesionResponse(success, offline );
  }


}

class UpdateSesionResponse{
  bool? success;
  bool offline;
  UpdateSesionResponse(this.success, this.offline);
}