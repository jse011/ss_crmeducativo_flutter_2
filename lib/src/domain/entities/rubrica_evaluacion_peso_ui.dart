import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';

class RubricaEvaluacionPesoUi{

  RubricaEvaluacionUi? rubricaEvaluacionUi;
  double get peso => rubricaEvaluacionUi?.peso??0.0;
  set peso(double peso){
    this.peso = peso;
  }
  RubricaEvaluacionPesoUi(this.rubricaEvaluacionUi);
}