import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_sesion_repository.dart';

class UpdateCerrarCurso {
  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;

  UpdateCerrarCurso(this.configuracionRepository, this.httpDatosRepository);

  Future<UpdateSesionEstadoResponse> execute(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI) async{

    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    bool? success = false;
    bool offline = false;
    try{
      success = await httpDatosRepository.cerrarCursoDocente(urlServidorLocal, cursosUi?.cargaCursoId, calendarioPeriodoUI?.id, usuarioId);
      print("UpdateCerrarSesion ${success}");
      if(success??false){
        calendarioPeriodoUI?.habilitadoProceso = 0;
        //await unidadSesionRepository.saveEstadoSesion(sesionUi?.sesionAprendizajeId, UnidadSesionRepository.ESTADO_HECHO);
      }
    }catch(e){
      offline = true;
    }
    return UpdateSesionEstadoResponse(success, offline );
  }


}

class UpdateSesionEstadoResponse{
  bool? success;
  bool offline;
  UpdateSesionEstadoResponse(this.success, this.offline);
}