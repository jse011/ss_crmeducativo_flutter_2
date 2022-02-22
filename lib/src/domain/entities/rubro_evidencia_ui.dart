import 'dart:io';

import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';

class RubroEvidenciaUi{
  TipoRecursosUi? tipoRecurso;
  String? url;
  double? progress;
  File? file;
  bool? success;
  String? archivoRubroId;
  bool? eliminar;
  EvaluacionUi? evaluacionUi;
  String? rubroEvaluacionId;
  DateTime? fechaCreacion;
  String? titulo;
}