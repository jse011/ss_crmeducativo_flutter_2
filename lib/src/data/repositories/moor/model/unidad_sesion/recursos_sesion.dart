import 'package:moor_flutter/moor_flutter.dart';

class RecursoSesion extends Table{
  TextColumn get recursoDidacticoId => text()();
  TextColumn get titulo => text().nullable()();
  TextColumn get descripcion => text().nullable()();
  IntColumn get tipoId => integer().nullable()();
  TextColumn get driveId => text().nullable()();
  IntColumn get sesionAprendizajeId => integer().nullable()();
  TextColumn get tipoRecursoActNombre => text().nullable()();
  IntColumn get tipoRecursoActId => integer().nullable()();
  @override
  Set<Column> get primaryKey => {recursoDidacticoId, sesionAprendizajeId};
}