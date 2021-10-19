import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class EliminarTareaDocente {
    HttpDatosRepository _httpDatosRepository;
    ConfiguracionRepository configuracionRepository;
    UnidadTareaRepository repository;

    EliminarTareaDocente(this._httpDatosRepository, this.configuracionRepository, this.repository);

    Future<EliminarTareaDocenteResponse> execute(TareaUi? tareaUi) async{

      String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
      int usuarioId = await configuracionRepository.getSessionUsuarioId();
      bool? success = false;
      bool offline = false;
      int estadoId = UnidadTareaRepository.ESTADO_ELIMINADO;
      try{
        success = await _httpDatosRepository.saveEstadoTareaDocente(urlServidorLocal, tareaUi?.tareaId, estadoId, usuarioId);
        await repository.saveEstadoTareaDocente(tareaUi, estadoId);
      }catch(e){
        offline = true;
      }
      return EliminarTareaDocenteResponse(success, offline );
    }
}

class EliminarTareaDocenteResponse{
  bool? success;
  bool offline;
  EliminarTareaDocenteResponse(this.success, this.offline);
}