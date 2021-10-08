import 'package:moor_flutter/moor_flutter.dart';

class TareaRecursoDidactico extends Table {


  TextColumn get recursoDidacticoId => text()();
  TextColumn get  titulo => text().nullable()();
  TextColumn get  descripcion => text().nullable()();
  IntColumn get  tipoId => integer().nullable()();
  IntColumn get  silaboEventoId => integer().nullable()();
  IntColumn get  estado => integer().nullable()();
  IntColumn get  planCursoId => integer().nullable()();
  TextColumn get  url => text().nullable()();
  TextColumn get  driveId => text().nullable()();
  TextColumn get  tareaId => text().nullable()();
  IntColumn get  fechaCreacion => integer().nullable()();

  @override
  Set<Column> get primaryKey => {recursoDidacticoId};
}