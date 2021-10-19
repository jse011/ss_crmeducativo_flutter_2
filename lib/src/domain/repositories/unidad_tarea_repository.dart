import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';

abstract class UnidadTareaRepository {
  static const int ESTADO_CREADO = 263, ESTADO_PUBLICADO = 264, ESTADO_ELIMINADO = 265;
  static const int TIPO_RECURSO_VIDEO = 379, TIPO_RECURSO_VINCULO = 380, TIPO_RECURSO_DOCUMENTO = 397, TIPO_RECURSO_HOJA_CALUCLO = 400, TIPO_RECURSO_IMAGEN = 398, TIPO_RECURSO_AUDIO = 399, TIPO_RECURSO_DIAPOSITIVA = 401, TIPO_RECURSO_PDF = 402, TIPO_RECURSO_MATERIALES = 403, TIPO_RECURSO_YOUTUBE = 581;

  Future<void> saveUnidadTarea(Map<String, dynamic> unidadSesion, int calendarioPeriodoId, int silaboEventoId);
  Future<List<UnidadUi>> getUnidadTarea(int calendarioPeriodoId, int silaboEventoId);
  Future<void> saveInformacionTarea(String? tareaId, Map<String, dynamic> unidadSesion);
  Future<List<TareaRecusoUi>>getRecursosTarea(String? tareaId);
  Future<List<TareaAlumnoUi>> getTareaAlumnos(String? tareaId);
  Map<String, dynamic> getTareaDosenteSerial(TareaUi tareaUi, int usuarioId);
  Future<void> saveSesionTarea(Map<String, dynamic> unidadTareaSesion, int calendarioPeriodoId, int silaboEventoId, int sesionAprendizajeId);
  Future<List<TareaUi>> getSesionTarea(int calendarioPeriodoId, int silaboEventoId, int sesionAprendizajeId);
  Future<void> saveEstadoTareaDocente(TareaUi? tareaUi, int estadoId);

}