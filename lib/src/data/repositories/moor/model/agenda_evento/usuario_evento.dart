import 'package:moor_flutter/moor_flutter.dart';

class UsuarioEvento extends Table{
  IntColumn get usuarioId=> integer()();
  IntColumn get personaId=> integer().nullable()();
  BoolColumn get estado=> boolean().nullable()();
  IntColumn get entidadId=> integer().nullable()();
  IntColumn get georeferenciaId=> integer().nullable()();

  @override
  Set<Column> get primaryKey => {usuarioId};
}