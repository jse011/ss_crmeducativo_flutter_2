import 'package:moor_flutter/moor_flutter.dart';

class Rol extends Table{
  IntColumn get rolId => integer()();
  TextColumn get nombre => text().nullable()();
  IntColumn get parentId => integer().nullable()();
  BoolColumn get estado => boolean().nullable()();
  @override
  Set<Column> get primaryKey => {rolId};
}