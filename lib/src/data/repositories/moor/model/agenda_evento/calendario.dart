import 'package:moor_flutter/moor_flutter.dart';

class Calendario extends Table {
  TextColumn get  calendarioId=> text()();
  TextColumn get  nombre=> text().nullable()();
  TextColumn get  descripcion=> text().nullable()();
  IntColumn get  estado=> integer().nullable()();
  IntColumn get  entidadId=> integer().nullable()();
  IntColumn get  georeferenciaId=> integer().nullable()();
  TextColumn get  nUsuario=> text().nullable()();
  TextColumn get  cargo=> text().nullable()();
  IntColumn get  usuarioId=> integer().nullable()();
  IntColumn get  cargaAcademicaId=> integer().nullable()();
  IntColumn get  cargaCursoId=> integer().nullable()();
  IntColumn get  estadoPublicaciN=> integer().nullable()();
  IntColumn get  estadoPublicacion=> integer().nullable()();
  IntColumn get  rolId=> integer().nullable()();
  IntColumn get  usuarioCreacionId=> integer().nullable()();
  IntColumn get  usuarioCreadorId=> integer().nullable()();
  IntColumn get  fechaCreacion=> integer().nullable()();
  IntColumn get  usuarioAccionId=> integer().nullable()();
  IntColumn get  fechaAccion=> integer().nullable()();
  IntColumn get  fechaEnvio=> integer().nullable()();
  IntColumn get  fechaEntrega=> integer().nullable()();
  IntColumn get  fechaRecibido=> integer().nullable()();
  IntColumn get  fechaVisto=> integer().nullable()();
  IntColumn get  fechaRespuesta=> integer().nullable()();
  TextColumn get  getSTime=> text().nullable()();

  @override
  Set<Column> get primaryKey => {calendarioId};
}