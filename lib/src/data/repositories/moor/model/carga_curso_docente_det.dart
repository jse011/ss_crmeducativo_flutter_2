import 'package:moor_flutter/moor_flutter.dart';

class CargaCursoDocenteDet extends Table
{
  IntColumn get cargaCursoDocenteId => integer().nullable()();
  IntColumn get alumnoId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {cargaCursoDocenteId};
}