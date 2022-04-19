import 'package:ss_crmeducativo_2/src/domain/entities/grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';

class IntegranteGrupoUi{
  String? equipoIntegranteId;
  PersonaUi? personaUi;
  bool? toogle;
  bool? showMore;
  GrupoUi? grupoUi;

   IntegranteGrupoUi copy(){
    IntegranteGrupoUi r = IntegranteGrupoUi();
    r.equipoIntegranteId = equipoIntegranteId;
    r.personaUi = personaUi;
    r.toogle = toogle;
    r.grupoUi = grupoUi;
    r.showMore = showMore;
    return r;
  }
}