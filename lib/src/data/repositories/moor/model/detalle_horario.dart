import 'package:moor_flutter/moor_flutter.dart';

class DetalleHorario extends Table
{
  IntColumn get idDetalleHorario => integer().nullable()();
  IntColumn get idTipoHora => integer().nullable()();
  IntColumn get idTipoTurno => integer().nullable()();
  TextColumn get horaInicio => text().nullable()();
  TextColumn get horaFin => text().nullable()();
  IntColumn get idHorarioDia => integer().nullable()();
  IntColumn get timeChange => integer().nullable()();

  @override
  Set<Column> get primaryKey => {idDetalleHorario};
}