import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class DeleteEvaluacion {
  RubroRepository repository;
  ConfiguracionRepository configuracionRepository;
  DeleteEvaluacion(this.repository, this.configuracionRepository);

  Future<void> execute(RubricaEvaluacionUi? rubricaEvaluacionUi) async {
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    return repository.eliminarEvaluacion(rubricaEvaluacionUi, usuarioId);
  }

}


