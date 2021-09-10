
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_trasnformada_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';

class RubricaEvaluacionTotalUi{
  EvaluacionTransformadaUi? evaluacionUi;
  RubricaEvaluacionTotalUi(this.evaluacionUi);
  double? get total => evaluacionUi?.nota_ponderada;
  set total(double? total){
    evaluacionUi?.nota_ponderada = total;
  }
}