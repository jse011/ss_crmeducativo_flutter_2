
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';

class RubricaEvaluacionTotalUi{
  EvaluacionUi? evaluacionUi;
  RubricaEvaluacionTotalUi(this.evaluacionUi);
  double? get total => evaluacionUi?.nota_ponderada;
  set total(double? total){
    evaluacionUi?.nota_ponderada = total;
  }
}