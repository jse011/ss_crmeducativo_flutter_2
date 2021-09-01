import 'package:moor_flutter/moor_flutter.dart';

class RelacionesEvento extends Table{
  IntColumn get idRelacion=> integer()();
  IntColumn get personaPrincipalId=> integer().nullable()();
  IntColumn get personaVinculadaId=> integer().nullable()();
  IntColumn get tipoId=> integer().nullable()();
  BoolColumn get activo=> boolean().nullable()();

  @override
  Set<Column> get primaryKey => {idRelacion};
}