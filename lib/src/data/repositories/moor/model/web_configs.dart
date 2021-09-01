import 'package:moor_flutter/moor_flutter.dart';

class WebConfigs extends Table {
  TextColumn get nombre => text().nullable()();
  TextColumn get content => text().nullable()();

  @override
  Set<Column> get primaryKey => {nombre,content};
}