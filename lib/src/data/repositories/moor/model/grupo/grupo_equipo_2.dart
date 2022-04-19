import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/base/base_sync.dart';


class GrupoEquipo2 extends BaseSync{

  TextColumn get grupoEquipoId => text()();
  IntColumn get tipoId => integer().nullable()();
  TextColumn get nombre => text().nullable()();
  IntColumn get cargaAcademicaId => integer().nullable()();
  IntColumn get cargaCursoId => integer().nullable()();
  IntColumn get docenteId => integer().nullable()();
  IntColumn get estado => integer().nullable()();
  TextColumn get color1 => text().nullable()();
  TextColumn get color2 => text().nullable()();
  TextColumn get color3 => text().nullable()();
  TextColumn get path => text().nullable()();
  TextColumn get cursoNombre => text().nullable()();
  @override
  Set<Column> get primaryKey => {grupoEquipoId};
}