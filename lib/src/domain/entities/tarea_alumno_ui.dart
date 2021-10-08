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
  bool? toogle;
}