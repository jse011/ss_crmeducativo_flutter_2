import 'package:moor_flutter/moor_flutter.dart';

class Tarea extends Table{
  TextColumn get tareaId => text()();
  TextColumn get titulo => text().nullable()();
  TextColumn get instrucciones => text().nullable()();
  IntColumn get numero => integer().nullable()();
  IntColumn get fechaCreacion => integer().nullable()();
  TextColumn get fechaEntrega => text().nullable()();
  TextColumn get horaEntrega => text().nullable()();
  TextColumn get sesionNombre => text().nullable()();
  IntColumn get sesionAprendizajeId => integer().nullable()();
  TextColumn get datosUsuarioCreador => text().nullable()();
  TextColumn get rubroEvalProcesoId => text().nullable()();
  IntColumn get desempenioIcdId => integer().nullable()();
  IntColumn get competenciaId => integer().nullable()();
  TextColumn get tipoNotaId => text().nullable()();
  IntColumn get unidadAprendizajeId => integer().nullable()();
  IntColumn get calendarioPeriodoId => integer().nullable()();
  IntColumn get silaboEventoId => integer().nullable()();
  IntColumn get estadoId => integer().nullable()();
  @override
  Set<Column> get primaryKey => {tareaId};
}