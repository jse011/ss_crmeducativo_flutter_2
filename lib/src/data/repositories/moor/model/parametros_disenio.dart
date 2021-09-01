import 'package:moor_flutter/moor_flutter.dart';

class ParametrosDisenio extends Table{
  
  IntColumn get parametroDisenioId => integer()();
  TextColumn get objeto => text().nullable()();
  TextColumn get concepto => text().nullable()();
  TextColumn get nombre => text().nullable()();
  TextColumn get path => text().nullable()();
  TextColumn get color1 => text().nullable()();
  TextColumn get color2 => text().nullable()();
  TextColumn get color3 => text().nullable()();
  BoolColumn get estado => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {parametroDisenioId};

}