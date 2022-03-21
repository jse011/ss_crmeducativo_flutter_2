import 'package:ss_crmeducativo_2/src/domain/entities/actividad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/instrumento_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_recurso_ui.dart';

class SesionUi{
  int? sesionAprendizajeId;
  String? tituloUnidad;
  int? nroUnidad;
  int? nroSesion;
  String? titulo;
  String? proposito;
  List<RubricaEvaluacionUi>? rubricaEvaluacionUiList;
  int? sesionAprendizajePadreId;
  String? horas;
  String? fechaEjecucion;
  //int? estadoEjecucionId;
  //String? estadoEjecucion;
  //String? colorSesion;
  SesionEstado? sesionEstado;
  String? fechaEjecucionFin;
  int? position;
  int? unidadAprendizajeId;
  bool? ver_mas;
  bool? toogle2;
  int? cantSesion;
  int? rolId;
  DateTime? fechaEjecucionDate;
  List<ActividadUi>? actividadUiList;
  List<InstrumentoEvaluacionUi>? instrumentoEvaluacionUiList;
  List<CompetenciaUi>? competenciaUiList;
  List<SesionRecursoUi>? recursosUiList;
  int? programaIdSesionHoy;
}

enum SesionEstado{
 CREADO, PROGRAMADO, HECHO, PENDIENTE
}