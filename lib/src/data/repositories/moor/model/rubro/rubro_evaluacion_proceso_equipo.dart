import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/base/base_sync.dart';

class RubroEvaluacionProcesoEquipo extends BaseSync{
  TextColumn get rubroEvaluacionEquipoId => text()();
  TextColumn get equipoId => text().nullable()();
  TextColumn get nombreEquipo => text().nullable()();
  TextColumn get rubroEvalProcesoId => text().nullable()();
  IntColumn get orden => integer().nullable()();
  @override
  Set<Column> get primaryKey => {rubroEvaluacionEquipoId};
}