import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';

abstract class AgendaEventoRepository {
  Future<List<TipoEventoUi>> getTiposEvento();

  Future<void> saveEventoAgenda(Map<String, dynamic> eventoAgenda, int usuarioId, int georeferenciaId, int tipoEventoId);

  Future<List<EventoUi>> getEventosAgenda(int usuarioId, int georeferenciaId, int tipoEventoId);

}