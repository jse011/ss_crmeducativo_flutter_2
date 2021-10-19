import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/resultado_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/resultado_competencia_ui.dart';

class ResultadoEvaluacionUi{
  static const int ALUMNO = 1, NOTA = 2, ESPACIO_CALENDARIO = 3;
  int? tipo;
  int? evaluacionResultadoId;
  int? alumnoId;
  int? rubroEvalResultadoId;
  String? color;
  double? nota;
  String? valorTipoNotaId;
  String? tituloNota;
  int? orden;
  int? orden2;
  bool? evaluado;
  bool? rFEditable;
  bool? notaDup;
  String? conclusionDescriptiva;
  bool? promedio;
  int? parentId;
  TipoNotaTiposUi? tipoNotaTiposUi;
  bool? bimestrNoVigente;
  bool? bimestrCerrado;
  bool? notaNoGenerada;
  bool? alumnoVigencia;
  ResultadoCapacidadUi? capacidadUi;
  ResultadoCompetenciaUi? competenciaUi;
  PersonaUi? personaUi;
}