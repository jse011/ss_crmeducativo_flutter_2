import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';

class EvaluacionUi{
  String? evaluacionId;
  String? rubroEvaluacionId;
  int? alumnoId;
  PersonaUi? personaUi;
  int? publicado;
  String? equipoId;
  ValorTipoNotaUi? valorTipoNotaUi;
  String? valorTipoNotaId;
  double? nota;
  RubricaEvaluacionUi? rubroEvaluacionUi;
  String? escala;

   EvaluacionUi copyWithSimple({String? evaluacionId,String? rubroEvaluacionId,  int? alumnoId, String? valorTipoNotaId, double? nota}) {
    EvaluacionUi item = new EvaluacionUi();
    item.evaluacionId = evaluacionId??this.evaluacionId;
    item.rubroEvaluacionId = rubroEvaluacionId??this.rubroEvaluacionId;
    item.alumnoId = alumnoId??this.alumnoId;
    item.valorTipoNotaId = valorTipoNotaId??this.valorTipoNotaId;
    item.nota = nota??this.nota;

    return item;
  }

}