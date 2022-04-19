import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/base/base_sync.dart';

class Equipo2 extends BaseSync{
  TextColumn get equipoId => text()();
  TextColumn get grupoEquipoId => text().nullable()();
  TextColumn get nombre => text().nullable()();
  IntColumn get orden => integer().nullable()();
  TextColumn get foto => text().nullable()();
  IntColumn get estado => integer().nullable()();
  @override
  Set<Column> get primaryKey => {equipoId};
}