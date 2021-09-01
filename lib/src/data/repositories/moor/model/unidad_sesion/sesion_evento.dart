import 'package:moor_flutter/moor_flutter.dart';

class SesionEvento extends Table{
  
  IntColumn get sesionAprendizajeId => integer()();
  IntColumn get unidadAprendizajeId => integer().nullable()();
  TextColumn get titulo => text().nullable()();
  TextColumn get proposito => text().nullable()();
  IntColumn get horas => integer().nullable()();
  TextColumn get contenido => text().nullable()();

  IntColumn get usuarioCreacionId => integer().nullable()();
  IntColumn get fechaCreacion => integer().nullable()();
  IntColumn get usuarioAccionId => integer().nullable()();
  IntColumn get fechaAccion => integer().nullable()();

  IntColumn get estadoId => integer().nullable()();
  IntColumn get fechaEjecucion => integer().nullable()();

  TextColumn get fechaReprogramacion => text().nullable()();
  TextColumn get fechaPublicacion => text().nullable()();
  IntColumn get nroSesion => integer().nullable()();
  IntColumn get rolId => integer().nullable()();
  IntColumn get estadoEjecucionId => integer().nullable()();

  IntColumn get fechaRealizada => integer().nullable()();
  IntColumn get fechaEjecucionFin => integer().nullable()();

  BoolColumn get estadoEvaluacion => boolean().nullable()();
  IntColumn get evaluados => integer().nullable()();
  IntColumn get docenteid => integer().nullable()();
  IntColumn get parentSesionId => integer().nullable()();
  @override
  Set<Column> get primaryKey => {sesionAprendizajeId};
}