import 'package:moor_flutter/moor_flutter.dart';

class InstrumentoEvaluacionSesion extends Table{
  IntColumn get instrumentoEvalId => integer()();
  TextColumn get nombre => text().nullable()();
  TextColumn get imagen => text().nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get fechaLanzamiento => text().nullable()();
  TextColumn get fechaCierre => text().nullable()();
  IntColumn get cantidadPreguntas => integer().nullable()();
  TextColumn get rubroEvaluacionId => text().nullable()();
  TextColumn get tipoNotaId => text().nullable()();
  IntColumn get sesionAprendizajeId => integer()();

  @override
  Set<Column> get primaryKey => {instrumentoEvalId, sesionAprendizajeId};
}