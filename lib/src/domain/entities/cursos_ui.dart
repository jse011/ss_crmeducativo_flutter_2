import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';

class CursosUi{
  int? cargaCursoId;
  int? cargaAcademicaId;
  String? nombreCurso;
  String? gradoSeccion;
  String? gradoSeccion2;
  String? nroSalon;
  int? silaboEventoId;
  String? color1;
  String? color2;
  String? color3;
  String? banner;
  EstadoSilabo estadoSilabo = EstadoSilabo.NO_AUTORIZADO;
  int? cantidadPersonas;
  bool? tutor;
  String? nivelAcademico;
  List<PersonaUi>? alumnoUiList;

}


enum EstadoSilabo{
  NO_AUTORIZADO,//creado
  AUTORIZADO,
  SIN_SILABO
}