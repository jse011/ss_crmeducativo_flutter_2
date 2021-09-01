import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';

class RubricaEvaluacionUi{
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
  String? tipoNotaId;
  TipoNotaUi? tipoNotaUi;
  int? cantidadRubroDetalle;
  List<RubricaEvaluacionUi>? rubrosDetalleList;
  double? peso;
  bool? guardadoLocal;
  int? calendarioPeriodoId;
}