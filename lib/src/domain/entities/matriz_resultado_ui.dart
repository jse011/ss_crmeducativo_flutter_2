import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/resultado_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/resultado_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/resultado_evaluacion.dart';

import 'capacidad_ui.dart';
import 'competencia_ui.dart';
import 'evaluacion_ui.dart';

class MatrizResultadoUi{
  List<PersonaUi>? personaUiList;
  List<ResultadoCapacidadUi>? capacidadUiList;
  List<ResultadoCompetenciaUi>? competenciaUiList;
  List<ResultadoEvaluacionUi>? evaluacionUiList;
  int? estadoCargaCurCalPerId;
  int? estadoCalendarioPeriodoId;
  int? habilitado;
  int? rangoFecha;
}