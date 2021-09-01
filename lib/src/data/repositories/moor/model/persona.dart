import 'package:moor_flutter/moor_flutter.dart';

class Persona extends Table{
  IntColumn get personaId  => integer()();
  TextColumn get nombres => text().nullable()();
  TextColumn get apellidoPaterno => text().nullable()();
  TextColumn get apellidoMaterno => text().nullable()();
  TextColumn get celular => text().nullable()();
  TextColumn get telefono => text().nullable()();
  TextColumn get foto => text().nullable()();
  TextColumn get fechaNac => text().nullable()();
  TextColumn get genero => text().nullable()();
  TextColumn get estadoCivil => text().nullable()();
  TextColumn get numDoc => text().nullable()();
  TextColumn get ocupacion => text().nullable()();
  IntColumn get estadoId => integer().nullable()();
  TextColumn get correo => text().nullable()();
  TextColumn get direccion => text().nullable()();
  TextColumn get path => text().nullable()();

  @override
  Set<Column> get primaryKey => {personaId};
}