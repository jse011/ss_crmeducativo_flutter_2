import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_equipo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_eval_equipo_integrante_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';

class RubricaEvaluacionEquipoUi{
  String? rubroEvaluacionEquipoId;
  int? orden;
  String? nombreEquipo;
  List<RubricaEvalEquipoIntegranteUi>? integrantesUiList;
  RubricaEvaluacionUi? rubricaEvaluacionUi;
  EvaluacionEquipoUi? evaluacionEquipoUi;
  String? equipoId;
}
