import 'package:moor_flutter/moor_flutter.dart';

class DesempenioIcdSesion extends Table{
  IntColumn get  desempenioIcdId => integer()();
  IntColumn get  sesionAprendizajeId => integer()();
  IntColumn get  desempenioId => integer().nullable()();
  TextColumn get  desempenio => text().nullable()();
  IntColumn get  competenciaId => integer().nullable()();
  IntColumn get  icdId => integer().nullable()();
  TextColumn get  icd => text().nullable()();
  TextColumn get  icdAlias => text().nullable()();

  @override
  Set<Column> get primaryKey => {sesionAprendizajeId, desempenioIcdId};
}