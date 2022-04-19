import 'package:ss_crmeducativo_2/src/domain/entities/TareaEvaluacionUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_archivo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';

class TareaAlumnoUi{
  bool? entregado;
  bool? entregado_retraso;
  int? fechaServidor;
  int? fechaEntrega;
  List<TareaAlumnoArchivoUi>? archivos;
  int? alumnoId;
  String? tareaId;
  PersonaUi? personaUi;
  String? valorTipoNotaId;
  double? nota;
  bool? toogle;
  String? rubroEvalProcesoId;
  List<TareaEvaluacionUi>? evaluacion;
  TipoNotaUi? tipoNotaUi;
}