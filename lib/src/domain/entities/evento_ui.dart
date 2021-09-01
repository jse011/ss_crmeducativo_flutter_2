import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';

class EventoUi {
  String? id;
  String? nombreEmisor;
  String? rolEmisor;
  String? fotoEntidad;
  String? nombreEntidad;
  DateTime? fecha;
  String? nombreFecha;
  String? titulo;

  String? descripcion;
  String? foto;
  TipoEventoUi? tipoEventoUi;
  int? cantLike;
  bool? externo;

  DateTime getFecha() {
    return this.fecha??DateTime(1900);
  }
}