import 'package:moor_flutter/moor_flutter.dart';

class NivelAcademico extends Table{
  IntColumn get nivelAcadId => integer()();
  TextColumn get nombre => text().nullable()();
  BoolColumn get activo => boolean().nullable()();
  IntColumn get entidadId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {nivelAcadId};
}