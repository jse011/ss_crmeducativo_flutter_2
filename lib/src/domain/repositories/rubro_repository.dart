import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/forma_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';

abstract class RubroRepository{
  static const int ESTADO_ANCLADA=313, ESTADO_EVALUADO=314, ESTADO_CREADO =237, ESTADO_ACTUALIZADO = 239, ESTADO_ELIMINADO = 280;
  Future<void> saveDatosCrearRubros(Map<String, dynamic> crearRubro, int silaboEventoId, int calendarioPeriodoId, int sesionAprendizajeDocenteId);

  Future<void> saveDatosRubrosEval(Map<String, dynamic> rubro, int silaboEventoId, int calendarioPeriodoId, int sesionAprendizajeDocenteId, int sesionAprendizajeAlumonId, String? tareaId);

  Future<List<FormaEvaluacionUi>> getGetFormaEvaluacion();

  Future<List<TipoEvaluacionUi>> getGetTipoEvaluacion();

  Future<List<TipoNotaUi>> getGetTipoNota(int programaEducativoId);

  Future<List<CompetenciaUi>> getTemasCriterios(int calendarioPeriodoId, int silaboEventoId);

  Future<void> saveRubroEvaluacionData(Map<String, dynamic> rubroEvaluacionData);

  Future<Map<String, dynamic>?> getRubroEvaluacionIdSerial(String? rubroEvaluacionId);

  Future<Map<String,dynamic>> getRubroEvaluacionSerial(Map<String, dynamic> rubroEvaluacionData);

  Future<List<RubricaEvaluacionUi>> getRubroEvaluacionList(int calendarioPeriodoId, int silaboEventoId, OrigenRubroUi origenRubroUi);

  Future<List<UnidadUi>> getUnidadAprendizaje(int? silaboEventoId, int? calendarioPeriodoId);

  Future<List<CompetenciaUi>> getRubroCompetencia(int? silaboEventoId, int? calendarioPeriodoId, int? competenciaId);

  Future<TipoNotaUi> getGetTipoNotaResultado(int? silaboEventoId);

  Future<RubricaEvaluacionUi> getRubroEvaluacion(String? rubroEvaluacionId);

  cambiarEstadoActualizado(String? rubroEvaluacionId);

  Future<List<Map<String,dynamic>>> getRubroEvalNoEnviadosServidorSerial(int? silaboEventoId, int? calendarioPeriodoId);

  Future<void> updateEvaluacion(RubricaEvaluacionUi? rubricaEvaluacionUi,int? alumnoId, int? usuarioId);

  Future<void> eliminarEvaluacion(RubricaEvaluacionUi? rubricaEvaluacionUi, int usuarioId);

  Future<void> updatePesoRubro(RubricaEvaluacionUi? rubricaEvaluacionUi, int usuarioId);

  Future<List<RubricaEvaluacionUi>> getRubroEvaluacionSesionList(int? silaboEventoId, int? calendarioPeriodoId,  int sesionAprendizajeDocenteId, int sesionAprendizajeAlumonId);

  Future<String?> getRubroEvaluacionIdTarea(String? tareaId);

  Future<void> eliminarEvalQueNoSeExportaron(String? rubroEvaluacionId);

  Future<Map<String,dynamic>> createRubroEvaluacionData(RubricaEvaluacionUi? rubricaEvaluacionUi, int? usuarioId);

  Future<Map<String, dynamic>> getUpdateRubroEvaluacionData(RubricaEvaluacionUi? rubricaEvaluacionUi, int usuarioId);

  Future<bool> isRubroSincronizado(String? rubroEvalProcesoId);

  Future<Map<String,dynamic>> updateRubroEvaluacionData(RubricaEvaluacionUi? rubricaEvaluacionUi, int usuarioId);

}