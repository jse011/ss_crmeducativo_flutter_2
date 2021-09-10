import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';

import 'evaluacion_trasnformada_ui.dart';

class EvaluacionRubricaValorTipoNotaUi {
  RubricaEvaluacionUi? rubricaEvaluacionUi;
  ValorTipoNotaUi? valorTipoNotaUi;
  bool? toggle;
  EvaluacionUi? evaluacionUi;
  EvaluacionTransformadaUi? evaluacionTransformadaUi;//se usa cunado se transforma un evaluacion aotra escala para no perder la evaluacion original


}