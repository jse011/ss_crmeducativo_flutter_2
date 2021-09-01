import 'package:moor_flutter/moor_flutter.dart';

class PlanCursos extends Table{

   IntColumn get planCursoId => integer()();
   IntColumn get cursoId => integer().nullable()();
   IntColumn get periodoId => integer().nullable()();
   IntColumn get planEstudiosId => integer().nullable()();

   @override
   Set<Column> get primaryKey => {planCursoId};
}