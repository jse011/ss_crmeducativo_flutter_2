import 'package:moor_flutter/moor_flutter.dart';

class ContactoDocente extends Table{
  IntColumn get personaId => integer()();
  TextColumn get nombres => text().nullable()();
  TextColumn get  apellidoPaterno => text().nullable()();
  TextColumn get  apellidoMaterno => text().nullable()();
  TextColumn get  ocupacion => text().nullable()();
  IntColumn get estadoId => integer().nullable()();
  TextColumn get  telefono => text().nullable()();
  TextColumn get  celular => text().nullable()();
  TextColumn get  fechaNac => text().nullable()();
  TextColumn get  correo => text().nullable()();
  TextColumn get  genero => text().nullable()();
  TextColumn get  estadoCivil => text().nullable()();
  TextColumn get  numDoc => text().nullable()();
  TextColumn get  foto => text().nullable()();
  TextColumn get  nombreTipo => text().nullable()();
  IntColumn get tipo => integer()();
  IntColumn get hijoRelacionId => integer().nullable()();
  TextColumn get  relacion => text().nullable()();
  IntColumn get cargaCursoId => integer()();
  IntColumn get cursoId => integer().nullable()();
  TextColumn get  cursoNombre => text().nullable()();
  IntColumn get periodoId => integer().nullable()();
  TextColumn get  periodoNombre => text().nullable()();
  IntColumn get grupoId => integer().nullable()();
  TextColumn get  grupoNombre => text().nullable()();
  IntColumn get aulaId => integer().nullable()();
  TextColumn get  aulaNombre => text().nullable()();
  IntColumn get contratoEstadoId => integer().nullable()();
  BoolColumn get contratoVigente => boolean().nullable()();
  IntColumn get relacionId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {personaId, tipo, cargaCursoId};

}