import 'package:moor_flutter/moor_flutter.dart';

class RelUnidadEvento extends Table{
  IntColumn get unidadaprendizajeId => integer()();
  IntColumn get tipoid => integer()();
  @override
  Set<Column> get primaryKey => {unidadaprendizajeId, tipoid};
}