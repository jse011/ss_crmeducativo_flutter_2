import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class ChangeEstadoEventoDocente {
    HttpDatosRepository _httpDatosRepository;
    ConfiguracionRepository configuracionRepository;
    AgendaEventoRepository repository;

    ChangeEstadoEventoDocente(this._httpDatosRepository, this.configuracionRepository, this.repository);

    Future<bool?> execute(EventoUi? eventoUi) async{
      String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
      int usuarioId = await configuracionRepository.getSessionUsuarioId();
      String? eventoId = eventoUi?.id;
      int? estadoId = eventoUi?.estadoId;
      bool? publicado = eventoUi?.publicado;
      return await _httpDatosRepository.changeEventoEstadoDocente(urlServidorLocal,eventoId, estadoId, publicado, usuarioId);
    }



}

class SaveTareaDocenteResponse{
  bool? success;
  bool offline;
  SaveTareaDocenteResponse(this.success, this.offline);
}