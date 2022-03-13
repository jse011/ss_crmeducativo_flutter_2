class EvaluacionFirebaseSesionUi{
  EvaluacionFirebaseTipoUi? tipo;
  String? key;
  String? nombre;
  Map<String,dynamic>? data;
  bool? selected;
}

enum  EvaluacionFirebaseTipoUi{
  TAREA, INSTRUMENTO, PREGUNTA, TAREAUNIDAD
}
