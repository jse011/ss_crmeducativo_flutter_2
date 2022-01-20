import 'package:ss_crmeducativo_2/src/domain/entities/evento_adjunto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_lista_envio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';

class EventoUi {
  String? id;
  String? nombreEmisor;
  String? rolEmisor;
  String? fotoEntidad;
  String? nombreEntidad;
  DateTime? fecha;//Fecha con hora
  DateTime? fechaEvento;//Fecha sin hora
  String? nombreFecha;
  String? titulo;

  String? descripcion;
  String? foto;
  TipoEventoUi? tipoEventoUi;
  int? cantLike;
  bool? externo;
  List<EventoAdjuntoUi>? eventoAdjuntoUiList;
  List<EventoAdjuntoUi>? eventoAdjuntoUiEncuestaList;
  List<EventoAdjuntoUi>? eventoAdjuntoUiDownloadList;
  List<EventoAdjuntoUi>? eventoAdjuntoUiPreviewList;
  String? nombreFechaPublicacion;
  DateTime? fechaPublicacion;
  bool? publicado;
  String? horaEvento;
  EventosListaEnvioUi? listaEnvioUi;
  DateTime? fecaCreacion;
  int? estadoId;
  String? nombreCalendario;
  int? cargaCursoId;
  int? cargaAcademicaId;
  DateTime getFecha() {
    return this.fecha??DateTime(1900);
  }
}