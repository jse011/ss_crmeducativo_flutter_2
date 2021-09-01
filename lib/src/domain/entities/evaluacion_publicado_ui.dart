import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';

class EvaluacionPublicadoUi {
  EvaluacionUi? evaluacionUi;

  EvaluacionPublicadoUi(this.evaluacionUi);

  bool get publicado => (evaluacionUi?.publicado??0)==1;
  set publicado(bool publicado){
    evaluacionUi?.publicado = publicado?1:0;
  }
}