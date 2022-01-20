import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_lista_envio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';

abstract class AgendaEventoRepository {
  static const int ESTADO_ELIMINADO = 346 , ESTADO_ACTUALIZADO = 345, ESTADO_CREADO = 344;

  Future<List<TipoEventoUi>> getTiposEvento();

  Future<void> saveEventoAgenda(Map<String, dynamic> eventoAgenda, int usuarioId, int georeferenciaId, int tipoEventoId);

  Future<List<EventoUi>> getEventosAgenda(int usuarioId, int georeferenciaId, int tipoEventoId, int? cargaCursoId);

  Future<List<EventosListaEnvioUi>> getListaAlumnos(int empleadoId);

  Map<String, dynamic> getEventoDocenteSerial(EventoUi? eventoUi, int usuarioId, int entidadId, int georeferenciaId, bool update);

  Future<List<EventosListaEnvioUi>> getListaAlumnosSelecionado(int empleadoId, String enventoId);

}