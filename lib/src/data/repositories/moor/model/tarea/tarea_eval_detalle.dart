import 'package:moor_flutter/moor_flutter.dart';

class TareaEvalDetalle extends Table{
  TextColumn get tareaId => text()();
  IntColumn get desempenioIcdId => integer()();
  IntColumn get alumnoId => integer()();
  TextColumn get valorTipoNotaId => text().nullable()();
  RealColumn get nota => real().nullable()();
  @override
  Set<Column> get primaryKey => {tareaId, alumnoId, desempenioIcdId};

}