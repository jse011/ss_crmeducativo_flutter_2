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
  void saveDatosCrearRubros(Map<String, dynamic> crearRubro, int silaboEventoId, int calendarioPeriodoId);

  void saveDatosRubrosEval(Map<String, dynamic> rubro, int silaboEventoId, int calendarioPeriodoId);

  Future<List<FormaEvaluacionUi>> getGetFormaEvaluacion();

  Future<List<TipoEvaluacionUi>> getGetTipoEvaluacion();

  Future<List<TipoNotaUi>> getGetTipoNota(int programaEducativoId);

  Future<List<CompetenciaUi>> getTemasCriterios(int calendarioPeriodoId, int silaboEventoId);

  Future<String?> saveRubroEvaluacion(String? titulo, int? formaEvaluacionId, int? tipoEvaluacionId, String? promedioLogroId, int? calendarioPeriodoId, int? silaboEventoId, int? cargaCursoId, int? sesionAprendizajeId, String? tareaId, int? usuarioId, List<CriterioPesoUi>? criterioPesoUiList, List<CriterioValorTipoNotaUi>? criterioValorTipoNotaUiList, TipoNotaUi? tipoNotaUi);

  Future<List<RubricaEvaluacionUi>> getRubroEvaluacionList(int calendarioPeriodoId, int silaboEventoId, OrigenRubroUi origenRubroUi);

  Future<List<UnidadUi>> getUnidadAprendizaje(int? silaboEventoId, int? calendarioPeriodoId);

  Future<List<CompetenciaUi>> getRubroCompetencia(int? silaboEventoId, int? calendarioPeriodoId, int? competenciaId);

  Future<TipoNotaUi> getGetTipoNotaResultado(int? silaboEventoId);

  Future<RubricaEvaluacionUi> getRubroEvaluacion(String? rubroEvaluacionId);

  Future<Map<String, dynamic>?> getRubroEvaluacionSerial(String rubroEvaluacionId);

  cambiarEstadoActualizado(String rubroEvaluacionId);

  Future<List<Map<String,dynamic>>> getRubroEvalNoEnviadosServidorSerial(int? silaboEventoId, int? calendarioPeriodoId);

  Future<void> updateEvaluacion(RubricaEvaluacionUi? rubricaEvaluacionUi,int? alumnoId, int? usuarioId);

  Future<void> eliminarEvaluacion(RubricaEvaluacionUi? rubricaEvaluacionUi, int usuarioId);

}