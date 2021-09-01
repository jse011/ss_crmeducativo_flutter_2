import 'package:moor_flutter/moor_flutter.dart';

class AnioAcademico extends Table{

  IntColumn get idAnioAcademico => integer()();
  TextColumn get nombre => text().nullable()();
  TextColumn get fechaInicio => text().nullable()();
  TextColumn get fechaFin => text().nullable()();
  TextColumn get denominacion => text().nullable()();
  IntColumn get georeferenciaId => integer().nullable()();
  IntColumn get organigramaId => integer().nullable()();
  IntColumn get estadoId => integer().nullable()();
  IntColumn get tipoId => integer().nullable()();
  BoolColumn get toogle => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {idAnioAcademico};
}