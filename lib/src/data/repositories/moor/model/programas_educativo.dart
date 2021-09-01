import 'package:moor_flutter/moor_flutter.dart';

class ProgramasEducativo extends Table{

  IntColumn get programaEduId => integer()();
  TextColumn get  nombre => text().nullable()();
  TextColumn get  nroCiclos => text().nullable()();
  IntColumn get  nivelAcadId => integer().nullable()();
  IntColumn get  tipoEvaluacionId => integer().nullable()();
  IntColumn get  estadoId => integer().nullable()();
  IntColumn get  entidadId => integer().nullable()();
  IntColumn get  tipoInformeSiagieId => integer().nullable()();
  BoolColumn get  toogle => boolean().nullable()();
  IntColumn get  tipoProgramaId => integer().nullable()();
  IntColumn get  tipoMatriculaId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {programaEduId};

}