import 'package:moor_flutter/moor_flutter.dart';

class CalendarioAcademico extends Table
{
  IntColumn get calendarioAcademicoId => integer()();
  IntColumn get programaEduId => integer().nullable()();
  IntColumn get idAnioAcademico => integer().nullable()();
  IntColumn get estadoId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {calendarioAcademicoId};
}