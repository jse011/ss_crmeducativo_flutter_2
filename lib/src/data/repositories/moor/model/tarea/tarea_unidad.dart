import 'package:moor_flutter/moor_flutter.dart';

class TareaUnidad extends Table{
  IntColumn get unidadAprendizajeId => integer()();
  TextColumn get titulo => text().nullable()();
  IntColumn get nroUnidad => integer().nullable()();
  IntColumn get calendarioPeriodoId => integer().nullable()();
  IntColumn get silaboEventoId => integer().nullable()();
  @override
  Set<Column> get primaryKey => {unidadAprendizajeId};

}