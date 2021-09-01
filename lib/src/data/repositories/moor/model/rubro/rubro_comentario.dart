
import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/base/base_sync.dart';

class RubroComentario extends BaseSync{

    /*String? evaluacionProcesoComentarioId;
    String? evaluacionProcesoId;
    String? comentarioId;
    String? descripcion;
    int? delete;*/

    TextColumn get evaluacionProcesoComentarioId => text()();
    TextColumn get evaluacionProcesoId => text().nullable()();
    TextColumn get comentarioId => text().nullable()();
    TextColumn get descripcion => text().nullable()();
    IntColumn get delete => integer().nullable()();

    @override
    Set<Column> get primaryKey => {evaluacionProcesoComentarioId};

}
