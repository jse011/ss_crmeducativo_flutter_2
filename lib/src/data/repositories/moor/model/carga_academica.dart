import 'package:moor_flutter/moor_flutter.dart';

class CargaAcademica extends Table
{
  IntColumn get cargaAcademicaId => integer()();
  IntColumn get seccionId => integer().nullable()();
  IntColumn get periodoId => integer().nullable()();
  IntColumn get aulaId => integer().nullable()();
  IntColumn get idPlanEstudio => integer().nullable()();
  IntColumn get idPlanEstudioVersion => integer().nullable()();
  IntColumn get idAnioAcademico => integer().nullable()();
  IntColumn get idEmpleadoTutor => integer().nullable()();
  IntColumn get estadoId => integer().nullable()();
  IntColumn get idPeriodoAcad => integer().nullable()();
  IntColumn get idGrupo => integer().nullable()();
  IntColumn get capacidadVacante => integer().nullable()();
  IntColumn get capacidadVacanteD => integer().nullable()();

  @override
  Set<Column> get primaryKey => {cargaAcademicaId};
}