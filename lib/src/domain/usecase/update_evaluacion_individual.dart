import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class UpdateEvaluacionIndividual {
  RubroRepository repository;
  ConfiguracionRepository configuracionRepository;
  UpdateEvaluacionIndividual(this.repository, this.configuracionRepository);

  void execute(RubricaEvaluacionUi? rubricaEvaluacionUi, int? alumnoId) async {
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    await repository.updateEvaluacion(rubricaEvaluacionUi, alumnoId, usuarioId);
  }

}


