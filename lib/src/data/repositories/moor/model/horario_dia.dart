import 'package:moor_flutter/moor_flutter.dart';

class HorarioDia extends Table
{
  IntColumn get idHorarioDia => integer()();
  IntColumn get idHorario => integer().nullable()();
  IntColumn get idDia => integer().nullable()();

  @override
  Set<Column> get primaryKey => {idDia};

}