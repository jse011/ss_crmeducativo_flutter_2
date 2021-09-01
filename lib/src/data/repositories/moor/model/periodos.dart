import 'package:moor_flutter/moor_flutter.dart';

class Periodos extends Table{
  IntColumn get periodoId => integer()();
  TextColumn get nombre => text().nullable()();
  IntColumn get estadoId => integer().nullable()();
  TextColumn get aliasPeriodo => text().nullable()();
  TextColumn get fecComienzo => text().nullable()();
  TextColumn get fecTermino => text().nullable()();
  IntColumn get tipoId => integer().nullable()();
  IntColumn get superId => integer().nullable()();
  IntColumn get geoReferenciaId => integer().nullable()();
  IntColumn get organigramaId => integer().nullable()();
  IntColumn get entidadId => integer().nullable()();
  BoolColumn get activo => boolean().nullable()();
  IntColumn get cicloId => integer().nullable()();
  IntColumn get docenteId => integer().nullable()();
  TextColumn get gruponombre => text().nullable()();
  IntColumn get grupoId => integer().nullable()();
  TextColumn get nivelAcademico => text().nullable()();
  IntColumn get nivelAcademicoId => integer().nullable()();
  IntColumn get tutorId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {periodoId};

}