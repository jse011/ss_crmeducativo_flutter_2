import 'package:moor_flutter/moor_flutter.dart';

class PlanEstudio extends Table{
  
   IntColumn get planEstudiosId => integer()();
   IntColumn get programaEduId => integer().nullable()();
   TextColumn get nombrePlan => text().nullable()();
   TextColumn get aliasPlan => text().nullable()();
   IntColumn get estadoId => integer().nullable()();
   TextColumn get nroResolucion => text().nullable()();
   TextColumn get fechaResolucion => text().nullable()();

   @override
   Set<Column> get primaryKey => {planEstudiosId};
  
}