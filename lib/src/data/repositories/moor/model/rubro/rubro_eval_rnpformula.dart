
import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/base/base_sync.dart';

class RubroEvalRNPFormula extends BaseSync {
  /*
   String? rubroFormulaId;
   String? rubroEvaluacionPrimId;
   String? rubroEvaluacionSecId;
   int? estado;*/

    TextColumn get rubroFormulaId => text()();
    TextColumn get rubroEvaluacionPrimId => text().nullable()();
    TextColumn get rubroEvaluacionSecId => text().nullable()();
    RealColumn get peso => real().nullable()();
    @override
  Set<Column> get primaryKey => {rubroFormulaId};
}
