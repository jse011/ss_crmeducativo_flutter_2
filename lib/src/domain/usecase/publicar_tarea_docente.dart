import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class PublicarTareaDocente {
    HttpDatosRepository _httpDatosRepository;
    ConfiguracionRepository configuracionRepository;
    UnidadTareaRepository repository;

    PublicarTareaDocente(this._httpDatosRepository, this.configuracionRepository, this.repository);

    Future<SaveTareaDocenteResponse> execute(TareaUi? tareaUi) async{

      String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
      int usuarioId = await configuracionRepository.getSessionUsuarioId();
      bool? success = false;
      bool offline = false;
      int estadoId = !(tareaUi?.publicado??false)?UnidadTareaRepository.ESTADO_PUBLICADO:UnidadTareaRepository.ESTADO_CREADO;
      try{
        success = await _httpDatosRepository.saveEstadoTareaDocente(urlServidorLocal, tareaUi?.tareaId, estadoId, usuarioId);
        if(success??false){
          tareaUi?.publicado = !(tareaUi.publicado??false);
          Map<String, dynamic> data =  repository.getTareaDosenteSerial(tareaUi, usuarioId);
          await _httpDatosRepository.saveTareaDocenteFlutter(urlServidorLocal, data);
        }
        await repository.saveEstadoTareaDocente(tareaUi, estadoId);
      }catch(e){
        offline = true;
      }
      return SaveTareaDocenteResponse(success, offline );
    }



}

class SaveTareaDocenteResponse{
  bool? success;
  bool offline;
  SaveTareaDocenteResponse(this.success, this.offline);
}