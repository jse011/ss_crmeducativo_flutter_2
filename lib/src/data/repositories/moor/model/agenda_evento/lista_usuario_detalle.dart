import 'package:moor_flutter/moor_flutter.dart';

class ListaUsuarioDetalle extends Table{
  IntColumn get listaUsuarioId=> integer()();
  IntColumn get usuarioId=> integer()();

  @override
  Set<Column> get primaryKey => {listaUsuarioId, usuarioId};
}