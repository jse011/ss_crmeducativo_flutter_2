import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/forma_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';

import 'evaluacion_trasnformada_ui.dart';

class RubricaEvaluacionUi{
  static const int  PESO_BAJO = 1,  PESO_NORMAL = 2, PESO_ALTO= 3, PESO_RUBRO_EXCLUIDO = -1, PESO_SIN_ASIGNAR = 0;
  String? rubroEvaluacionId;
  String? titulo;
  String? mediaDesvicion;
  String? fechaCreacion_;
  double? promedio;
  double? desvicion;
  DateTime? fechaCreacion;
  bool? publicado;
  bool? rubroGrupal;
  int? cantEvaluaciones;
  int? cantEvalPublicadas;
  int? cantiEvalCalificadas;
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
  int? position;
  int? formaEvaluacionId;
  int? tipoEvaluacionId;
  List<CriterioPesoUi>? criterioPesoUiList;
  List<CriterioValorTipoNotaUi>? criterioValorTipoNotaUiList;
  TareaUi? tareaUi;
  int? silaboEventoId;
  int? cargaCursoId;
  String? subtitulo;
  double? desviacionEstandar;
  TipoRubroEvaluacion?  tipoRubroEvaluacion;
  int? competenciaId;
  bool? update;

}

enum TipoRubroEvaluacion{
  UNIDIMENSIONAL,
  BIDIMENSIONAL,
  BIDIMENSIONAL_DETALLE,
}