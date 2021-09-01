import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';

class EvaluacionCompetenciaUi{
  PersonaUi? personaUi;
  CompetenciaUi? competenciaUi;
  double? nota;
  List<EvaluacionCapacidadUi>? evaluacionCapacidadUiList;
  ValorTipoNotaUi? valorTipoNotaUi;
}