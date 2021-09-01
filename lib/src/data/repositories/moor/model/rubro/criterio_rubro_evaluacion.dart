import 'package:moor_flutter/moor_flutter.dart';

class CriterioRubroEvaluacion extends Table{
 TextColumn get criteriosEvaluacionId => text()();
 TextColumn get rubroEvalProcesoId => text().nullable()();
 TextColumn get valorTipoNotaId => text().nullable()();
 TextColumn get descripcion => text().nullable()();
 @override
 Set<Column> get primaryKey => {criteriosEvaluacionId};
}