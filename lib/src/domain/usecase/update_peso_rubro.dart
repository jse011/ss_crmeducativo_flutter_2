import 'dart:async';

import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class UpdatePesoRubro {
  RubroRepository repository;
  ConfiguracionRepository configuracionRepository;
  UpdatePesoRubro(this.repository, this.configuracionRepository);

  Future<void> execute(RubricaEvaluacionUi? rubricaEvaluacionUi) async {
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    return repository.updatePesoRubro(rubricaEvaluacionUi, usuarioId);
  }

}


