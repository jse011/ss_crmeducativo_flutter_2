import 'package:moor_flutter/moor_flutter.dart';

class ListaUsuarios extends Table{
  IntColumn get listaUsuarioId=> integer()();
  TextColumn get nombre=> text().nullable()();
  TextColumn get descripcion=> text().nullable()();
  IntColumn get entidadId=> integer().nullable()();
  IntColumn get georeferenciaId=> integer().nullable()();
  IntColumn get organigramaId=> integer().nullable()();
  BoolColumn get estado=> boolean().nullable()();
  IntColumn get usuarioCreacionId=> integer().nullable()();
  IntColumn get usuarioCreadorId=> integer().nullable()();
  IntColumn get fechaCreacion=> integer().nullable()();
  IntColumn get usuarioAccionId=> integer().nullable()();
  IntColumn get fechaAccion=> integer().nullable()();
  IntColumn get fechaEnvio=> integer().nullable()();
  IntColumn get fechaEntrega=> integer().nullable()();
  IntColumn get fechaRecibido=> integer().nullable()();
  IntColumn get fechaVisto=> integer().nullable()();
  IntColumn get fechaRespuesta=> integer().nullable()();
  TextColumn get getSTime=> text().nullable()();

  @override
  Set<Column> get primaryKey => {listaUsuarioId};


}