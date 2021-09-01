import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/base/base_sync.dart';

class RubroCampotematico extends BaseSync {
    /*String? rubroEvalProcesoId;
    int? campoTematicoId;*/

    TextColumn get rubroEvalProcesoId => text()();
    IntColumn get campoTematicoId => integer()();

    @override
    Set<Column> get primaryKey => {rubroEvalProcesoId, campoTematicoId};
}

