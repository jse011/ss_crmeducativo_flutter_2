
import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/base/base_sync.dart';

class EquipoEvaluacion extends BaseSync {
    /*
    String? equipoEvaluacionProcesoId;
    String? rubroEvalProcesoId;
    int? sesionAprendizajeId;
    String? equipoId;
    double? nota;
    String? escala;
    String? valorTipoNotaId;*/

    TextColumn get equipoEvaluacionProcesoId => text()();
    TextColumn get rubroEvalProcesoId => text().nullable()();
    IntColumn get sesionAprendizajeId => integer().nullable()();
    TextColumn get equipoId => text().nullable()();
    RealColumn get nota => real().nullable()();
    TextColumn get escala => text().nullable()();
    TextColumn get valorTipoNotaId => text().nullable()();

    @override
  Set<Column> get primaryKey => {equipoEvaluacionProcesoId};
}
