import 'package:moor_flutter/moor_flutter.dart';

class AsistenciaQR extends Table{
  TextColumn get aistenciaQRId => text()();
  TextColumn get alumno => text().nullable()();
  TextColumn get code => text().nullable()();
  IntColumn get hora => integer().nullable()();
  IntColumn get minuto => integer().nullable()();
  IntColumn get segundo => integer().nullable()();
  IntColumn get dia => integer().nullable()();
  IntColumn get mes => integer().nullable()();
  IntColumn get anio => integer().nullable()();
  BoolColumn get enviado => boolean().nullable()();
  BoolColumn get repetido => boolean().nullable()();
  @override
  Set<Column> get primaryKey => {aistenciaQRId};
}