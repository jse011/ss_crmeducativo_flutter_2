import 'package:ss_crmeducativo_2/src/domain/usecase/resultado_capacidad_ui.dart';

class ResultadoCompetenciaUi{
  static const int ALUMNO = 1, COMPETENCIA = 2, TITULO= 3,TITULO_ALUMNO = 4, ESPACIO_CALENDARIO = 5, COMPETENCIA_FINAL = 6, COMPETENCIA_FINAL_TITULO = 7;
  int? tipo;
  int? rowSpan;
  String? titulo;
  int? rubroResultadoId;
  int? competenciaId;
  int? rubroformal;
  List<ResultadoCapacidadUi>? resulCapacidadUiList;
  
}