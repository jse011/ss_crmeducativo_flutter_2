import 'package:moor_flutter/moor_flutter.dart';

class Aula extends Table
{
  IntColumn get aulaId => integer()();
  TextColumn get descripcion => text().nullable()();
  TextColumn get numero => text().nullable()();
  IntColumn get capacidad => integer().nullable()();
  IntColumn get estado => integer().nullable()();

  @override
  Set<Column> get primaryKey => {aulaId};
}