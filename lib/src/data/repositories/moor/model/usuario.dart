import 'package:moor_flutter/moor_flutter.dart';

class Usuario extends Table{

  IntColumn get usuarioId => integer()();
  IntColumn get personaId => integer().nullable()();
  TextColumn get usuario => text().nullable()();
  TextColumn get password  => text().nullable()();
  BoolColumn get estado  => boolean().nullable()();
  BoolColumn get habilitarAcceso  => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {usuarioId};
}