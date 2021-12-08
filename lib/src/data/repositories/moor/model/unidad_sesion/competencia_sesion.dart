import 'package:moor_flutter/moor_flutter.dart';

class CompetenciaSesion extends Table{
  IntColumn get competenciaId => integer()();
  IntColumn get sesionAprendizajeId => integer()();
  TextColumn get competencia => text().nullable()();
  TextColumn get  tipoCompetencia => text().nullable()();
  TextColumn get  descCompetencia => text().nullable()();
  IntColumn get capacidadId  => integer()();
  TextColumn get  tipoCapacidad => text().nullable()();
  TextColumn get  capacidad => text().nullable()();
  TextColumn get  descrCapacidad => text().nullable()();
  

  @override
  Set<Column> get primaryKey => {competenciaId, sesionAprendizajeId};

}