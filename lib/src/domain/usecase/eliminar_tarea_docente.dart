import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class EliminarTareaDocente {
    HttpDatosRepository _httpDatosRepository;
    ConfiguracionRepository configuracionRepository;
    UnidadTareaRepository repository;
    RubroRepository _rubroRepository;

    EliminarTareaDocente(this._httpDatosRepository, this.configuracionRepository, this.repository, this._rubroRepository);

    Future<EliminarTareaDocenteResponse> execute(TareaUi? tareaUi) async{

      String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
      int usuarioId = await configuracionRepository.getSessionUsuarioId();
      bool? success = false;
      bool offline = false;
      int estadoId = UnidadTareaRepository.ESTADO_ELIMINADO;
      try{
        success = await _httpDatosRepository.saveEstadoTareaDocente(urlServidorLocal, tareaUi?.tareaId, estadoId, usuarioId);
        if(success??false){
          tareaUi?.publicado = !(tareaUi.publicado??false);
          Map<String, dynamic> data =  repository.getTareaDosenteSerial(tareaUi, usuarioId);
          await _httpDatosRepository.saveTareaDocenteFlutter(urlServidorLocal, data);//eliminar del firebase
          await repository.saveEstadoTareaDocente(tareaUi, estadoId);
          await _rubroRepository.eliminarTareaEvaluacion(tareaUi, usuarioId);
        }

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