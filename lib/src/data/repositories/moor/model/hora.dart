import 'package:moor_flutter/moor_flutter.dart';

class Hora extends Table
{
  IntColumn get idHora => integer()();
  TextColumn get horaInicio => text().nullable()();
  TextColumn get horaFin => text().nullable()();

  @override
  Set<Column> get primaryKey => {idHora};
}
