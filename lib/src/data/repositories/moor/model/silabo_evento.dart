import 'package:moor_flutter/moor_flutter.dart';

class SilaboEvento extends Table {
 
  IntColumn get silaboEventoId => integer()();
  TextColumn get titulo => text().nullable()();
  TextColumn get descripcionGeneral => text().nullable()();
  IntColumn get planCursoId => integer().nullable()();
  IntColumn get entidadId => integer().nullable()();
  IntColumn get  docenteId => integer().nullable()();
  IntColumn get seccionId => integer().nullable()();
  IntColumn get estadoId => integer().nullable()();
  IntColumn get anioAcademicoId => integer().nullable()();
  IntColumn get georeferenciaId => integer().nullable()();
  IntColumn get silaboBaseId => integer().nullable()();
  IntColumn get cargaCursoId => integer().nullable()();
  IntColumn get parametroDisenioId => integer().nullable()();
  TextColumn get fechaInicio => text().nullable()();
  TextColumn get fechaFin => text().nullable()();
  @override
  Set<Column> get primaryKey => {silaboEventoId};


}