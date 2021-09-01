import 'package:moor_flutter/moor_flutter.dart';

class CalendarioPeriodo extends Table{

   IntColumn get calendarioPeriodoId => integer()();
   DateTimeColumn get fechaInicio => dateTime().nullable()();
   DateTimeColumn get fechaFin => dateTime().nullable()();
   IntColumn get calendarioAcademicoId => integer().nullable()();
   IntColumn get tipoId => integer().nullable()();
   IntColumn get estadoId => integer().nullable()();
   BoolColumn get habilitado => boolean().nullable()();
   IntColumn get diazPlazo => integer().nullable()();

   @override
   Set<Column> get primaryKey => {calendarioPeriodoId};
  
}