
import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/base/base_sync.dart';

class ArchivoRubro extends BaseSync {

    /*String? archivoRubroId;
    String? url;
    int? tipoArchivoId;
    String? evaluacionProcesoId;
    String? localpath;
    int? delete;*/

    TextColumn get archivoRubroId => text()();
    TextColumn get url => text().nullable()();
    IntColumn get tipoArchivoId => integer().nullable()();
    TextColumn get evaluacionProcesoId => text().nullable()();
    TextColumn get localpath => text().nullable()();
    IntColumn get delete => integer().nullable()();

    @override
  Set<Column> get primaryKey => {archivoRubroId};
}
