import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';

abstract class UnidadTareaRepository {
  Future<void> saveUnidadTarea(Map<String, dynamic> unidadSesion, int calendarioPeriodoId, int silaboEventoId);
  Future<List<UnidadUi>> getUnidadTarea(int calendarioPeriodoId, int silaboEventoId);
  Future<void> saveInformacionTarea(String? tareaId, Map<String, dynamic> unidadSesion);
  Future<List<TareaRecusoUi>>getRecursosTarea(String? tareaId);
  Future<List<TareaAlumnoUi>> getTareaAlumnos(String? tareaId);
  Map<String, dynamic> getTareaDosenteSerial(TareaUi tareaUi, int usuarioId);

}