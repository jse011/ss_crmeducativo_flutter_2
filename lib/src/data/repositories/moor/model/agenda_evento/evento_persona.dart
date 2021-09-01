import 'package:moor_flutter/moor_flutter.dart';

class EventoPersona extends Table{
  TextColumn get eventoPersonaId=> text()();
  TextColumn get eventoId=> text().nullable()();
  IntColumn get personaId=> integer().nullable()();
  BoolColumn get estado=> boolean().nullable()();
  IntColumn get rolId=> integer().nullable()();
  IntColumn get apoderadoId=> integer().nullable()();
  TextColumn get key=> text().nullable()();
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
  Set<Column> get primaryKey => {eventoPersonaId};
}