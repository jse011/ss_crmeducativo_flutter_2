import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/desempenio_ui.dart';
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
  int? total_peso;//Calculo del resultado
  bool? toogle;
  int? rubroResultadoId;
  int? rubroResultadoPrincipalId;
  bool? evaluable;
  String? tipoCapacidad;
  List<DesempenioUi>? desempenioUiList;
  bool? round;//campo solo visual para capacidades

}