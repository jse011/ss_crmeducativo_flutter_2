import 'package:moor_flutter/moor_flutter.dart';

class TareaAlumnoArchivo extends Table{

  TextColumn get  tareaId => text().nullable()();
  IntColumn get alumnoId => integer().nullable()();
  BoolColumn get repositorio => boolean().nullable()();
  TextColumn get  nombre => text().nullable()();
  TextColumn get  path => text().nullable()();
  IntColumn? silaboEventoId;
  TextColumn get  tareaAlumnoArchivoId => text()();
  
}