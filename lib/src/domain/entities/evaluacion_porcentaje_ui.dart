import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';

class EvaluacionPorcentajeUi{
  RubricaEvaluacionUi? rubricaEvaluacionUi;
  CapacidadUi? capacidadUi;

  EvaluacionPorcentajeUi(this.rubricaEvaluacionUi, this.capacidadUi);
}