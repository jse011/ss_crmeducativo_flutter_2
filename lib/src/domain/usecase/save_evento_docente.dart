import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class SaveEventoDocente {
    HttpDatosRepository _httpDatosRepository;
    ConfiguracionRepository configuracionRepository;
    AgendaEventoRepository repository;

    SaveEventoDocente(this._httpDatosRepository, this.configuracionRepository, this.repository);

    Future<SaveTareaDocenteResponse> execute(EventoUi? eventoUi, bool update) async{

      String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
      int entidadId = await configuracionRepository.getSessionEntidadId();
      int georeferenciaId = await configuracionRepository.getSessionGeoreferenciaId();
      int usuarioId = await configuracionRepository.getSessionUsuarioId();
      bool? success = false;
      bool offline = false;
      try{
        Map<String, dynamic> data =  repository.getEventoDocenteSerial(eventoUi, usuarioId, entidadId, georeferenciaId, update);
        success = await _httpDatosRepository.saveEventoDocente(urlServidorLocal, data);
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