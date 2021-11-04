import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';

class EventoPersonaUi{
  int? get personaId => personaUi?.personaId;
  PersonaUi? personaUi;
  bool? selectedAlumno;
  bool? selectedPadre;
  bool? selected;
  int? apoderadoId;
}