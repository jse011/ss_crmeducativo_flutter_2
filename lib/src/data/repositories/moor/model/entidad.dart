import 'package:moor_flutter/moor_flutter.dart';

class Entidad extends Table{
  IntColumn get entidadId => integer()();
  IntColumn get tipoId => integer().nullable()();
  IntColumn get parentId => integer().nullable()();
  TextColumn get nombre => text().nullable()();
  TextColumn get ruc => text().nullable()();
  TextColumn get site => text().nullable()();
  TextColumn get telefono => text().nullable()();
  TextColumn get correo => text().nullable()();
  TextColumn get foto => text().nullable()();
  IntColumn get estadoId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {entidadId};
}