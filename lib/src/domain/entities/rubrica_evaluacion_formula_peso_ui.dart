import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';


class RubricaEvaluacionFormulaPesoUi{
  RubricaEvaluacionUi? rubricaEvaluacionUi;
  double get formula_peso => rubricaEvaluacionUi?.formula_peso??0.0;
  set formula_peso(double peso){
    rubricaEvaluacionUi?.formula_peso = peso;
  }
  RubricaEvaluacionFormulaPesoUi(this.rubricaEvaluacionUi);
}