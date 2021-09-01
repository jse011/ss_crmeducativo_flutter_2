import 'package:moor_flutter/moor_flutter.dart';

class Georeferencia extends Table {

  IntColumn get georeferenciaId => integer()();
  TextColumn get nombre => text().nullable()();
  IntColumn get entidadId => integer().nullable()();
  TextColumn get geoAlias => text().nullable()();
  IntColumn get estadoId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {georeferenciaId};
}