import 'package:moor_flutter/moor_flutter.dart';

class Empleado extends Table{
  IntColumn get empleadoId => integer()();
  IntColumn get personaId => integer().nullable()();
  TextColumn get linkURL => text().nullable()();
  BoolColumn get estado => boolean().nullable()();
  IntColumn get tipoId => integer().nullable()();
  TextColumn get web => text().nullable()();

  @override
  Set<Column> get primaryKey => {empleadoId};
}