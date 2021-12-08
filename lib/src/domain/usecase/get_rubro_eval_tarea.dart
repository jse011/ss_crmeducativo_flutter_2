import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class GetRubroEvalTarea extends UseCase<GetRubroEvalTareaResponse, GetRubroEvalTareaParms>{
  RubroRepository repository;
  ConfiguracionRepository configuracionRepository;

  GetRubroEvalTarea(this.repository, this.configuracionRepository);

  @override
  Future<Stream<GetRubroEvalTareaResponse?>> buildUseCaseStream(GetRubroEvalTareaParms? params) async{
    final controller = StreamController<GetRubroEvalTareaResponse>();
    try{
      String? rubroEvaluacionId = await repository.getRubroEvaluacionIdTarea(params?.tareaId);
      print("GetRubroEvalTarea rubroEvaluacionUi: ${params?.tareaId}");
      RubricaEvaluacionUi rubricaEvaluacionUi =  await repository.getRubroEvaluacion(rubroEvaluacionId);
      print("GetRubroEvalTarea 2 rubroEvaluacionUi: ${rubricaEvaluacionUi.rubroEvaluacionId}");
      /*Obtner alumnos*/
      List<PersonaUi> alumnoCursoList = await configuracionRepository.getListAlumnoCurso(params?.cargaCursoId??0);


      controller.add(GetRubroEvalTareaResponse(rubricaEvaluacionUi, alumnoCursoList));
      controller.close();
    } catch (e) {
      logger.severe('GetRubroEvaluacion unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetRubroEvalTareaParms{
  String? tareaId;
  int? cargaCursoId;

  GetRubroEvalTareaParms(this.tareaId, this.cargaCursoId);
}

class GetRubroEvalTareaResponse{
  RubricaEvaluacionUi rubricaEvaluacionUi;
  List<PersonaUi> alumnoCursoList;

  GetRubroEvalTareaResponse(this.rubricaEvaluacionUi, this.alumnoCursoList);
}