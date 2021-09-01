import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/base/base_sync.dart';

class RubroEvaluacionProceso extends BaseSync{

  TextColumn get rubroEvalProcesoId => text()();
  TextColumn get titulo => text().nullable()();
  TextColumn get subtitulo => text().nullable()();
  TextColumn get colorFondo => text().nullable()();
  BoolColumn get mColorFondo => boolean().nullable()();
  TextColumn get valorDefecto => text().nullable()();
  IntColumn get competenciaId => integer().nullable()();
  IntColumn get calendarioPeriodoId => integer().nullable()();
  TextColumn get anchoColumna => text().nullable()();
  BoolColumn get ocultarColumna => boolean().nullable()();
  IntColumn get tipoFormulaId => integer().nullable()();
  IntColumn get silaboEventoId => integer().nullable()();
  IntColumn get tipoRedondeoId => integer().nullable()();
  IntColumn get valorRedondeoId => integer().nullable()();
  IntColumn get rubroEvalResultadoId => integer().nullable()();
  TextColumn get tipoNotaId => text().nullable()();
  IntColumn get sesionAprendizajeId => integer().nullable()();
  IntColumn get desempenioIcdId => integer().nullable()();
  IntColumn get campoTematicoId => integer().nullable()();
  IntColumn get tipoEvaluacionId => integer().nullable()();
  IntColumn get estadoId => integer().nullable()();
  IntColumn get tipoEscalaEvaluacionId => integer().nullable()();
  IntColumn get tipoColorRubroProceso => integer().nullable()();
  IntColumn get tiporubroid => integer().nullable()();
  IntColumn get formaEvaluacionId => integer().nullable()();
  IntColumn get countIndicador => integer().nullable()();
  IntColumn get rubroFormal => integer().nullable()();
  IntColumn get msje => integer().nullable()();
  RealColumn get promedio => real().nullable()();
  RealColumn get desviacionEstandar => real().nullable()();
  IntColumn get unidadAprendizajeId => integer().nullable()();
  IntColumn get estrategiaEvaluacionId => integer().nullable()();
  TextColumn get tareaId => text().nullable()();
  TextColumn get resultadoTipoNotaId => text().nullable()();
  TextColumn get instrumentoEvalId => text().nullable()();
  TextColumn get preguntaEvalId => text().nullable()();
  IntColumn get error_guardar => integer().nullable()();

  @override
  Set<Column> get primaryKey => {rubroEvalProcesoId};
}