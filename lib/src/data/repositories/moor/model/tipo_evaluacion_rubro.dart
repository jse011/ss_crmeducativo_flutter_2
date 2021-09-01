import 'package:moor_flutter/moor_flutter.dart';

class TipoEvaluacionRubro extends Table{
 IntColumn get tipoEvaluacionId => integer()();
 TextColumn get nombre => text().nullable()();
  BoolColumn get estado => boolean().nullable()();

 @override
  Set<Column> get primaryKey => {tipoEvaluacionId};
}