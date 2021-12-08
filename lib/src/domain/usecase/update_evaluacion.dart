
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class UpdateEvaluacion {
  RubroRepository repository;
  ConfiguracionRepository configuracionRepository;
  UpdateEvaluacion(this.repository, this.configuracionRepository);

  Future<void> execute(RubricaEvaluacionUi? rubricaEvaluacionUi, int? alumnoId) async {
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    return repository.updateEvaluacion(rubricaEvaluacionUi, alumnoId, usuarioId);
  }

}


