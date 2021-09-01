import 'package:moor_flutter/moor_flutter.dart';

class TiposRubro extends Table{
  IntColumn get tipoId => integer()();
  TextColumn get objeto => text().nullable()();
  TextColumn get concepto => text().nullable()();
  TextColumn get nombre => text().nullable()();
  TextColumn get codigo => text().nullable()();
  IntColumn get parentId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {tipoId};
}