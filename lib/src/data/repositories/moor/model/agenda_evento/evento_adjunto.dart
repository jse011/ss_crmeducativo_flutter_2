import 'package:moor_flutter/moor_flutter.dart';

class EventoAdjunto extends Table{
  TextColumn get eventoAdjuntoId => text()();
  TextColumn get eventoId => text().nullable()();
  TextColumn get titulo => text().nullable()();
  IntColumn get tipoId => integer().nullable()();
  TextColumn get driveId => text().nullable()();

  @override
  Set<Column> get primaryKey => {eventoAdjuntoId};
}