import 'package:moor_flutter/moor_flutter.dart';

class Dia extends Table
{
  IntColumn get diaId => integer()();
  TextColumn get nombre => text().nullable()();
  BoolColumn get estado => boolean().nullable()();
  TextColumn get alias_ => text().nullable()();

  @override
  Set<Column> get primaryKey => {diaId};
}