import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/base/base_sync.dart';

class IntegranteEquipo2 extends BaseSync{
  TextColumn get equipoIntegranteId => text()();
  TextColumn get equipoId => text().nullable()();
  IntColumn get alumnoId => integer().nullable()();
  TextColumn get nombre => text().nullable()();
  TextColumn get foto => text().nullable()();

  @override
  Set<Column> get primaryKey => {equipoIntegranteId};

}