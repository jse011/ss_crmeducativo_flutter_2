import 'package:moor_flutter/moor_flutter.dart';

class CargaCursoDocente extends Table
{
  IntColumn get cargaCursoDocenteId => integer()();
  IntColumn get cargaCursoId => integer().nullable()();
  IntColumn get docenteId => integer().nullable()();
  BoolColumn get responsable => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {cargaCursoDocenteId};
}