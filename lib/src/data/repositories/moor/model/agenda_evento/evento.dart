
import 'package:moor_flutter/moor_flutter.dart';

class Evento extends Table{
  TextColumn get eventoId=> text()();
  TextColumn get titulo=> text().nullable()();
  TextColumn get descripcion=> text().nullable()();
  TextColumn get calendarioId=> text().nullable()();
  IntColumn get tipoEventoId=> integer().nullable()();
  IntColumn get estadoId=> integer().nullable()();
  BoolColumn get estadoPublicacion=> boolean().nullable()();
  IntColumn get entidadId=> integer().nullable()();
  IntColumn get georeferenciaId=> integer().nullable()();
  IntColumn get fechaEvento=> integer().nullable()();
  TextColumn get horaEvento=> text().nullable()();
  BoolColumn get envioPersonalizado=> boolean().nullable()();
  TextColumn get getSTime=> text().nullable()();
  IntColumn get syncFlag=> integer().nullable()();
  IntColumn get usuarioReceptorId=> integer().nullable()();
  IntColumn get eventoHijoId=> integer().nullable()();
  TextColumn get key=> text().nullable()();
  IntColumn get usuarioCreacionId=> integer().nullable()();
  IntColumn get usuarioCreadorId=> integer().nullable()();
  IntColumn get fechaCreacion=> integer().nullable()();
  IntColumn get usuarioAccionId=> integer().nullable()();
  IntColumn get fechaAccion=> integer().nullable()();
  IntColumn get fechaEnvio=> integer().nullable()();
  IntColumn get fechaEntrega=> integer().nullable()();
  IntColumn get fechaRecibido=> integer().nullable()();
  IntColumn get fechaVisto=> integer().nullable()();
  IntColumn get fechaRespuesta=> integer().nullable()();
  TextColumn get pathImagen=> text().nullable()();
  IntColumn get likeCount => integer().nullable()();
  BoolColumn get like => boolean().nullable()();
  TextColumn get nombreEntidad=> text().nullable()();
  TextColumn get fotoEntidad=> text().nullable()();

}