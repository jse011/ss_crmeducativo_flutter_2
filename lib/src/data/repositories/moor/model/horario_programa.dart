import 'package:moor_flutter/moor_flutter.dart';

class HorarioPrograma extends Table
{
  IntColumn get idHorarioPrograma => integer()();
  IntColumn get idHorario => integer().nullable()();
  IntColumn get activo => integer().nullable()();
  IntColumn get idProgramaEducativo => integer().nullable()();
  IntColumn get idAnioAcademico => integer().nullable()();
  IntColumn get idUsuarioActualizacion => integer().nullable()();
  IntColumn get idUsuarioCreacion => integer().nullable()();
  TextColumn get fechaCreacion => text().nullable()();
  TextColumn get fechaActualizacion => text().nullable()();

  @override
  Set<Column> get primaryKey => {idHorarioPrograma};
}