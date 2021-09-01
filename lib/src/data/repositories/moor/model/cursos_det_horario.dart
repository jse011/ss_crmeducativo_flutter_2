import 'package:moor_flutter/moor_flutter.dart';

class CursosDetHorario extends Table
{
  IntColumn get idCursosDetHorario => integer()();
  IntColumn get idDetHorario => integer().nullable()();
  IntColumn get idCargaCurso => integer().nullable()();

  @override
  Set<Column> get primaryKey => {idCursosDetHorario};
}