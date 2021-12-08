import 'package:moor_flutter/moor_flutter.dart';

class CampotematicoSesion extends Table{
  IntColumn get campoTematicoId => integer()();
  IntColumn get  sesionAprendizajeId => integer()();
  TextColumn get campoTematico => text().nullable()();
  IntColumn get  desempenioIcdId => integer().nullable()();
  IntColumn get  campoTematicoPadreId => integer().nullable()();
  TextColumn get campoTematicoPadre => text().nullable()();
  @override
  Set<Column> get primaryKey => {campoTematicoId, desempenioIcdId, sesionAprendizajeId};
}