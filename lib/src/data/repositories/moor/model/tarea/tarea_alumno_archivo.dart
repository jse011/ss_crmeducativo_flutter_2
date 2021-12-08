import 'package:moor_flutter/moor_flutter.dart';

class TareaAlumnoArchivo extends Table{

  TextColumn get  tareaId => text().nullable()();
  IntColumn get alumnoId => integer().nullable()();
  BoolColumn get repositorio => boolean().nullable()();
  TextColumn get nombre => text().nullable()();
  TextColumn get path => text().nullable()();
  IntColumn? get silaboEventoId => integer().nullable()();
  TextColumn get tareaAlumnoArchivoId => text()();
  TextColumn get driveId => text().nullable()();

  @override
  Set<Column> get primaryKey => {tareaAlumnoArchivoId};

}