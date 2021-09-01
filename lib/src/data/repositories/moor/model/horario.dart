import 'package:moor_flutter/moor_flutter.dart';

class Horario extends Table
{
  IntColumn get idHorario => integer()();
  TextColumn get nombre => text().nullable()();
  TextColumn get descripcion => text().nullable()();
  TextColumn get fecCreacion => text().nullable()();
  TextColumn get fecActualizacion => text().nullable()();
  BoolColumn get estado => boolean().nullable()();
  IntColumn get idUsuario => integer().nullable()();
  IntColumn get entidadId => integer().nullable()();
  IntColumn get georeferenciaId => integer().nullable()();
  IntColumn get organigramaId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {idHorario};
}