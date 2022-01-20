import 'package:moor_flutter/moor_flutter.dart';

class ActividadSesion extends Table{
  IntColumn get actividadAprendizajeId => integer()();
  TextColumn get tipoActividad => text().nullable()();
  IntColumn get tipoActividadId => integer().nullable()();
  TextColumn get actividad => text().nullable()();
  TextColumn get  descripcionActividad => text().nullable()();
  IntColumn get instrumentoEvalId => integer().nullable()();
  IntColumn get parentId => integer().nullable()();
  IntColumn get sesionAprendizajeId  => integer().nullable()();
  IntColumn get secuenciaId  => integer().nullable()();
  TextColumn get secuencia => text().nullable()();
  //subActividad
  //recursoActividad
  //instrumento
  @override
  Set<Column> get primaryKey => {actividadAprendizajeId};
}