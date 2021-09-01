class TipoEventoUi{
  int? id;
  String? nombre;
  EventoIconoEnumUI? tipo;
  bool? toogle;
  bool? disable;
}

enum EventoIconoEnumUI{
  DEFAULT, EVENTO, NOTICIA, ACTIVIDAD, TAREA, CITA, AGENDA, TODOS
}