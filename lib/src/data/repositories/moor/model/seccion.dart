import 'package:moor_flutter/moor_flutter.dart';

class Seccion extends Table{
  IntColumn get seccionId => integer()();
  TextColumn get nombre => text().nullable()();
  TextColumn get descripcion => text().nullable()();
  BoolColumn get estado => boolean().nullable()();
  IntColumn get georeferenciaId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {seccionId};
}