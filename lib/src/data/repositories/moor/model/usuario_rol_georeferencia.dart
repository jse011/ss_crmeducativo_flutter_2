import 'package:moor_flutter/moor_flutter.dart';

class UsuarioRolGeoreferencia extends Table{
  IntColumn get usuarioRolGeoreferenciaId => integer()();
  IntColumn get usuarioId => integer().nullable()();
  IntColumn get rolId => integer().nullable()();
  IntColumn get geoReferenciaId => integer().nullable()();
  IntColumn get entidadId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {usuarioRolGeoreferenciaId};
}