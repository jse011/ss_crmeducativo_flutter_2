import 'package:ss_crmeducativo_2/src/domain/entities/TareaEvaluacionUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_archivo_ui.dart';

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

  int? success;//1 progress, 2 success y -1 error
}