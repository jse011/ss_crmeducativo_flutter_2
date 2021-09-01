import 'package:moor_flutter/moor_flutter.dart';

class CalendarioListaUsuario extends Table{
  TextColumn get calendarioId => text()();
  IntColumn get listaUsuarioId => integer()();

  @override
  Set<Column> get primaryKey => {calendarioId, listaUsuarioId};
}