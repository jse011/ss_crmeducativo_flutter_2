import 'package:moor_flutter/moor_flutter.dart';

class TipoNotaRubro extends Table{
  TextColumn get tipoNotaId => text()();
  TextColumn get nombre => text().nullable()();
  IntColumn get tipoId => integer().nullable()();
  TextColumn get tiponombre => text().nullable()();
  TextColumn get valorDefecto => text().nullable()();
  RealColumn get longitudPaso => real().nullable()();
  BoolColumn get intervalo => boolean().nullable()();
  BoolColumn get estatico => boolean().nullable()();
  IntColumn get entidadId => integer().nullable()();
  IntColumn get georeferenciaId => integer().nullable()();
  IntColumn get organigramaId => integer().nullable()();
  IntColumn get estadoId => integer().nullable()();
  IntColumn get tipoFuenteId => integer().nullable()();
  IntColumn get valorMinimo => integer().nullable()();
  IntColumn get valorMaximo => integer().nullable()();
  IntColumn get escalaEvaluacionId => integer().nullable()();
  TextColumn get escalanombre => text().nullable()();
  IntColumn get escalavalorMinimo => integer().nullable()();
  IntColumn get escalavalorMaximo => integer().nullable()();
  IntColumn get escalaestado => integer().nullable()();
  BoolColumn get escaladefecto => boolean().nullable()();
  IntColumn get escalaentidadId => integer().nullable()();
  IntColumn get programaEducativoId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {tipoNotaId};
}