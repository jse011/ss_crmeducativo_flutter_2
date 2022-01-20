import 'package:ss_crmeducativo_2/src/domain/entities/TareaEvaluacionUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';

abstract class UnidadTareaRepository {
  static const int ESTADO_CREADO = 263, ESTADO_PUBLICADO = 264, ESTADO_ELIMINADO = 265;


  Future<void> saveUnidadTarea(Map<String, dynamic> unidadSesion, int calendarioPeriodoId, int silaboEventoId);
  Future<List<UnidadUi>> getUnidadTarea(int calendarioPeriodoId, int silaboEventoId);
  Future<void> saveInformacionTarea(String? tareaId, Map<String, dynamic> unidadSesion);
  Future<List<TareaRecusoUi>>getRecursosTarea(String? tareaId);
  Future<List<TareaAlumnoUi>> getTareaAlumnos(String? tareaId);
  Map<String, dynamic> getTareaDosenteSerial(TareaUi? tareaUi, int usuarioId);
  Future<void> saveSesionTarea(Map<String, dynamic> unidadTareaSesion, int calendarioPeriodoId, int silaboEventoId, int sesionAprendizajeId);
  Future<List<TareaUi>> getSesionTarea(int calendarioPeriodoId, int silaboEventoId, int sesionAprendizajeId);
  Future<void> saveEstadoTareaDocente(TareaUi? tareaUi, int estadoId);
  Future<void> saveTareaDocenteSerial(Map<String, dynamic> data);
  Future<void> saveDriveIdTareaAlumno(Map<String, dynamic> serial, String? tareaAlumnoArchivoId);
  Future<String?> getDriveIdTareaAlumno(String? tareaAlumnoArchivoId);


}