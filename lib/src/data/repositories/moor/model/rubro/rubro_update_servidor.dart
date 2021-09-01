import 'package:moor_flutter/moor_flutter.dart';

class RubroUpdateServidor extends Table {

  IntColumn get calendarioId => integer()();
  IntColumn get silaboEventoId => integer()();

  @override
  Set<Column> get primaryKey => {calendarioId, silaboEventoId};
}
