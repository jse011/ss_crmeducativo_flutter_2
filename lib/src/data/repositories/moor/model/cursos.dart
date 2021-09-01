import 'package:moor_flutter/moor_flutter.dart';

class Cursos extends Table{
  IntColumn get cursoId => integer()();
  TextColumn get nombre => text().nullable()();
  IntColumn get estadoId => integer().nullable()();
  TextColumn get descripcion => text().nullable()();
  TextColumn get cursoAlias => text().nullable()();
  IntColumn get entidadId => integer().nullable()();
  IntColumn get nivelAcadId => integer().nullable()();
  IntColumn get tipoCursoId => integer().nullable()();
  IntColumn get tipoConceptoId => integer().nullable()();
  TextColumn get color => text().nullable()();
  TextColumn get creditos => text().nullable()();
  TextColumn get totalHP => text().nullable()();
  TextColumn get totalHT => text().nullable()();
  TextColumn get notaAprobatoria => text().nullable()();
  TextColumn get sumilla => text().nullable()();
  IntColumn get superId => integer().nullable()();
  IntColumn get idServicioLaboratorio => integer().nullable()();
  IntColumn get horasLaboratorio => integer().nullable()();
  BoolColumn get tipoSubcurso => boolean().nullable()();
  TextColumn get foto => text().nullable()();
  TextColumn get codigo => text().nullable()();

  @override
  Set<Column> get primaryKey => {cursoId};

}