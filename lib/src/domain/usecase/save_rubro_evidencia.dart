import 'package:ss_crmeducativo_2/src/domain/entities/rubro_evidencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class SaveRubroEvidencia{
  ConfiguracionRepository configuracionRepository;
  RubroRepository rubroRepository;

  SaveRubroEvidencia(this.configuracionRepository, this.rubroRepository);

  Future<void> execute(RubroEvidenciaUi? rubroEvidenciaUi)async{
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    rubroRepository.saveRubroEvidencias(rubroEvidenciaUi, usuarioId);
  }
}
