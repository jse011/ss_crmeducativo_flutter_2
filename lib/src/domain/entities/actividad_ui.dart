import 'package:ss_crmeducativo_2/src/domain/entities/actividad_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/instrumento_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';

class ActividadUi{
  int? actividadAprendizajeId;
  String? actividad;
  String? tipoNombre;
  String? descripcion;
  InstrumentoEvaluacionUi? instrumentoEvaluacionUi;
  List<ActividadUi>? subActividades;
  List<ActividadRecursoUi>? recursos;
  String? secuencia;
  ActividadTipo? tipo;
  bool? toogle;
}
enum ActividadTipo{
  CONECTA, TEORIA, APRENDIZAJE, PRACTICA
}