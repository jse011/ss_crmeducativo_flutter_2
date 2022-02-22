import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_comentario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class SaveRubroComentario {
  ConfiguracionRepository configuracionRepository;
  RubroRepository rubroRepository;

  SaveRubroComentario(this.configuracionRepository, this.rubroRepository);

  Future<void> execute(RubroComentarioUi? rubroComentarioUi)async{
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    rubroRepository.saveComentario(rubroComentarioUi, usuarioId);
  }

}