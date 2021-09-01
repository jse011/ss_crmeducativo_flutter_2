import 'package:moor_flutter/moor_flutter.dart';

class ValorTipoNotaResultado extends Table{
  IntColumn get silaboEventoId => integer()();
  TextColumn get valorTipoNotaId => text()();
  TextColumn get tipoNotaId => text().nullable()();
  TextColumn get titulo => text().nullable()();
  TextColumn get alias => text().nullable()();
  RealColumn get limiteInferior => real().nullable()();
  RealColumn get limiteSuperior => real().nullable()();
  RealColumn get valorNumerico => real().nullable()();
  TextColumn get icono => text().nullable()();
  IntColumn get estadoId => integer().nullable()();
  BoolColumn get incluidoLInferior => boolean().nullable()();
  BoolColumn get incluidoLSuperior => boolean().nullable()();
  IntColumn get tipoId => integer().nullable()();

  IntColumn get usuarioCreacionId => integer().nullable()();
  IntColumn get usuarioCreadorId => integer().nullable()();
  IntColumn get fechaCreacion => integer().nullable()();
  IntColumn get usuarioAccionId => integer().nullable()();
  IntColumn get fechaAccion => integer().nullable()();
  IntColumn get fechaEnvio => integer().nullable()();
  IntColumn get fechaEntrega => integer().nullable()();
  IntColumn get fechaRecibido => integer().nullable()();
  IntColumn get fechaVisto => integer().nullable()();
  IntColumn get fechaRespuesta => integer().nullable()();
  TextColumn get getSTime => text().nullable()();

  @override
  Set<Column> get primaryKey => {valorTipoNotaId, silaboEventoId};
}