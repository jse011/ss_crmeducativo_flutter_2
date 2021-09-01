import 'package:moor_flutter/moor_flutter.dart';

class CargaCurso extends Table{
  
   IntColumn get cargaCursoId => integer()();
   IntColumn get  planCursoId => integer().nullable()();
   IntColumn get  empleadoId => integer().nullable()();
   IntColumn get  cargaAcademicaId => integer().nullable()();
   IntColumn get  complejo => integer().nullable()();
   IntColumn get  evaluable => integer().nullable()();
   IntColumn get  idempleado => integer().nullable()();
   IntColumn get  idTipoHora => integer().nullable()();
   TextColumn get  descripcion => text().nullable()();
   DateTimeColumn get   fechaInicio => dateTime().nullable()();
   DateTimeColumn get  fechafin => dateTime().nullable()();
   TextColumn get  modo => text().nullable()();
   IntColumn get  estado => integer().nullable()();
   IntColumn get  anioAcademicoId => integer().nullable()();
   IntColumn get  aulaId => integer().nullable()();
   IntColumn get  grupoId => integer().nullable()();
   IntColumn get  idPlanEstudio => integer().nullable()();
   IntColumn get  idPlanEstudioVersion => integer().nullable()();
   IntColumn get  CapacidadVacanteP => integer().nullable()();
   IntColumn get  CapacidadVacanteD => integer().nullable()();
   TextColumn get nombreDocente => text().nullable()();
   IntColumn get personaIdDocente => integer().nullable()();
   TextColumn get fotoDocente => text().nullable()();
   @override
   Set<Column> get primaryKey => {cargaCursoId};
  
}