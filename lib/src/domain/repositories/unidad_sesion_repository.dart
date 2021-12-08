import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_hoy_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';

abstract class UnidadSesionRepository{
  Future<void> saveUnidadSesion(Map<String, dynamic> unidadSesion, int usuarioId, int calendarioId, int silaboEventoId, int rol);
  Future<List<UnidadUi>> getUnidadSesion(int usuarioId, int calendarioId, int silaboEventoId, int rolId);
  List<SesionHoyUi> transformarSesionHoy(List<dynamic> sesionHoyListData);
  Future<void> saveAprendizajeSesion(int? sesionAprendizajeId, Map<String, dynamic> unidadAprendizaje);
  Future<List<CompetenciaUi>> getAprendizajeSesion(int? sesionAprendizajeId);
}