import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';
import 'package:collection/collection.dart';
class GetRubroEvalTarea {
  RubroRepository repository;
  ConfiguracionRepository configuracionRepository;

  GetRubroEvalTarea(this.repository, this.configuracionRepository);

  @override
  Future<GetRubroEvalTareaResponse> execute(GetRubroEvalTareaParms? params) async{
    String? rubroEvaluacionId = await repository.getRubroEvaluacionIdTarea(params?.tareaId);

    RubricaEvaluacionUi rubricaEvaluacionUi =  await repository.getRubroEvaluacion(rubroEvaluacionId);

    /*Obtner alumnos*/
    List<PersonaUi> alumnoCursoList = await configuracionRepository.getListAlumnoCurso(params?.cargaCursoId??0);

    List<PersonaUi> personaUiListDesavilitadas = [];
    for(PersonaUi personaUi in alumnoCursoList){
      if(!(personaUi.contratoVigente??false)){
        personaUiListDesavilitadas.add(personaUi);
      }
    }
    for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi.evaluacionUiList??[]){
      PersonaUi? personaUi = personaUiListDesavilitadas.firstWhereOrNull((element) => element.personaId == evaluacionUi.personaUi?.personaId);
      if(personaUi!=null && !(personaUi.contratoVigente??false)){
        personaUiListDesavilitadas.remove(personaUi);
      }
    }
    for(PersonaUi personaUi in personaUiListDesavilitadas){
      alumnoCursoList.remove(personaUi);
    }

    return GetRubroEvalTareaResponse(rubricaEvaluacionUi, alumnoCursoList);
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