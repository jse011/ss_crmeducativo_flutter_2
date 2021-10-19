import 'package:ss_crmeducativo_2/src/domain/entities/criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';

import 'evaluacion_trasnformada_ui.dart';

class RubricaEvaluacionUi{
  static const int  PESO_BAJO = 1,  PESO_NORMAL = 2, PESO_ALTO= 3, PESO_RUBRO_EXCLUIDO = -1, PESO_SIN_ASIGNAR = 0;
  String? rubricaId;
  String? titulo;
  String? mediaDesvicion;
  String? efechaCreacion;
  DateTime? fechaCreacion;
  bool? publicado;
  bool? rubroGrupal;
  int? cantEvaluaciones;
  int? cantEvalPublicadas;
  OrigenRubroUi? origenRubroUi;
  int? sesionAprendizajeId;
  List<EvaluacionUi>? evaluacionUiList;
  List<EvaluacionTransformadaUi>? evaluacionTransformadaUiList;
  String? tipoNotaId;
  TipoNotaUi? tipoNotaUi;
  int? cantidadRubroDetalle;
  List<RubricaEvaluacionUi>? rubrosDetalleList;
  double? formula_peso;
  int? peso;//Calculo del resultado
  bool? ningunaEvalCalificada;//Calculo del resultado
  bool? guardadoLocal;
  int? calendarioPeriodoId;
  int? desempenioIcdId;
  CriterioUi? criterioUi;
  String? tituloRubroCabecera;//POr ahora solo trae cunado se listan los rubros por competencia
  String? rubricaIdRubroCabecera;
  int? position;//POr ahora solo trae cunado se listan los rubros por competencia


}