import 'package:moor_flutter/moor_flutter.dart';

class CalendarioPeriodoCargaCurso extends Table{

   IntColumn get calendarioPeriodoId => integer()();
   DateTimeColumn get fechaInicio => dateTime().nullable()();
   DateTimeColumn get fechaFin => dateTime().nullable()();
   IntColumn get calendarioAcademicoId => integer().nullable()();
   IntColumn get tipoId => integer().nullable()();
   IntColumn get estadoId => integer().nullable()();
   BoolColumn get selecionado => boolean().nullable()();
   IntColumn get diazPlazo => integer().nullable()();
   TextColumn get nombre => text().nullable()();
   IntColumn get habilitado => integer().nullable()();
   IntColumn get cargaCursoId => integer()();
   IntColumn get habilitadoProceso => integer().nullable()();
   IntColumn get habilitadoResultado => integer().nullable()();

   @override
   Set<Column> get primaryKey => {calendarioPeriodoId, cargaCursoId};
  
}