import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';

class CapacidadUi{
  int? capacidadId;
  CompetenciaUi? competenciaUi;
  List<CriterioUi>? criterioUiList;
  String? nombre;
  String? descripcion;
  int? tipoId;
  int? competenciaId;
  List<RubricaEvaluacionUi>? rubricaEvalUiList;
}