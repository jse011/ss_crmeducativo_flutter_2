import 'package:moor_flutter/moor_flutter.dart';

class UnidadEvento extends Table{
  IntColumn get unidadAprendizajeId => integer()();
  IntColumn get nroUnidad => integer().nullable()();
  TextColumn get titulo => text().nullable()();
  TextColumn get situacionSignificativa => text().nullable()();
  IntColumn get nroSemanas => integer().nullable()();
  IntColumn get nroHoras => integer().nullable()();
  IntColumn get nroSesiones => integer().nullable()();
  IntColumn get estadoId => integer().nullable()();
  IntColumn get silaboEventoId => integer().nullable()();
  TextColumn get situacionSignificativaComplementaria => text().nullable()();
  TextColumn get desafio => text().nullable()();
  TextColumn get reto => text().nullable()();

  @override
  Set<Column> get primaryKey => {unidadAprendizajeId};
}