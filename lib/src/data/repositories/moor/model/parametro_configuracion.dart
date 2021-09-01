import 'package:moor_flutter/moor_flutter.dart';

class  ParametroConfiguracion extends Table {
  IntColumn get id => integer()();
  TextColumn get concepto => text().nullable()();
  TextColumn get parametro => text().nullable()();
  IntColumn get entidadId => integer().nullable()();
  IntColumn get orden => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}