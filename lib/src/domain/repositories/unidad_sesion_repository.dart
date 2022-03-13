import 'package:ss_crmeducativo_2/src/domain/entities/actividad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_firebase_sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_hoy_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';

abstract class UnidadSesionRepository{
  static const int ESTADO_CREADO = 315, ESTADO_PROGRAMADO = 316, ESTADO_HECHO = 317, ESTADO_PENDIENTE = 318;

  Future<void> saveUnidadSesion(Map<String, dynamic> unidadSesion, int usuarioId, int calendarioId, int silaboEventoId, int rol);
  Future<List<UnidadUi>> getUnidadSesion(int usuarioId, int calendarioId, int silaboEventoId, int rolId);
  List<SesionHoyUi> transformarSesionHoy(List<dynamic> sesionHoyListData);
  Future<void> saveAprendizajeSesion(int? sesionAprendizajeId, Map<String, dynamic> unidadAprendizaje);
  Future<SesionUi> getAprendizajeSesion(int? sesionAprendizajeId);
  Future<void> saveEstadoSesion(int? sesionAprendizajeId, int estadoId);
  Future<void> saveActividadesSesion(int? sesionAprendizajeId, List actividades);
  Future<SesionUi> getActividadSesion(int? sesionAprendizajeId);
  List<EvaluacionFirebaseSesionUi>? transformarEvaluacionesData(Map<String, dynamic> evalaucionesSesionesData);

}