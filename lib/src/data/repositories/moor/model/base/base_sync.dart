import 'package:moor_flutter/moor_flutter.dart';

abstract class BaseSync extends Table{

  IntColumn get syncFlag => integer().nullable()();
  DateTimeColumn get timestampFlag => dateTime().nullable()();
  IntColumn get usuarioCreacionId => integer().nullable()();
  DateTimeColumn get fechaCreacion => dateTime().nullable()();
  IntColumn get usuarioAccionId => integer().nullable()();
  DateTimeColumn get fechaAccion => dateTime().nullable()();

}