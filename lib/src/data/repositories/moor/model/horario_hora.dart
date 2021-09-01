import 'package:moor_flutter/moor_flutter.dart';

class HorarioHora extends Table
{
  IntColumn get idHorarioHora => integer()();
  IntColumn get horaId => integer().nullable()();
  IntColumn get detalleHoraId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {idHorarioHora};
}
