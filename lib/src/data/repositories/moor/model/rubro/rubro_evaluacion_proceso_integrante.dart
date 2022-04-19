import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/base/base_sync.dart';

class RubroEvaluacionProcesoIntegrante extends BaseSync{

  TextColumn get rubroEvaluacionEquipoId => text()();
  IntColumn get personaId => integer()();
  @override
  Set<Column> get primaryKey => {rubroEvaluacionEquipoId, personaId};

}