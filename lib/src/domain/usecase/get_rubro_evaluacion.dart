import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:collection/collection.dart';

class GetRubroEvaluacion extends UseCase<GetRubroEvaluacionResponse, GetRubroEvaluacionParms>{

  RubroRepository repository;
  ConfiguracionRepository configuracionRepository;

  GetRubroEvaluacion(this.repository, this.configuracionRepository);

  @override
  Future<Stream<GetRubroEvaluacionResponse?>> buildUseCaseStream(GetRubroEvaluacionParms? params) async{
    final controller = StreamController<GetRubroEvaluacionResponse>();
    try{

      RubricaEvaluacionUi rubricaEvaluacionUi =  await repository.getRubroEvaluacion(params?.rubroEvaluacionId);
      /*Obtner alumnos*/
      List<PersonaUi> alumnoCursoList = await configuracionRepository.getListAlumnoCurso(params?.cargaCursoId??0);
/*
      List<PersonaUi> personaUiList = [];
      for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi.evaluacionUiList??[]){
        PersonaUi? personaUi = personaUiList.firstWhereOrNull((element) => element.personaId == evaluacionUi.alumnoId);
        if(personaUi==null)personaUiList.add(evaluacionUi.personaUi!);
      }

      for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUi.rubrosDetalleList??[]){
        for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi.evaluacionUiList??[]){
          PersonaUi? personaUi = personaUiList.firstWhereOrNull((element) => element.personaId == evaluacionUi.alumnoId);
          if(personaUi==null)personaUiList.add(evaluacionUi.personaUi!);
        }
      }

      for(PersonaUi alumnoCurso in alumnoCursoList){
        PersonaUi? personaUi = personaUiList.firstWhereOrNull((element) => element.personaId == alumnoCurso.personaId);
        if(personaUi==null){
          alumnoCurso.soloApareceEnElCurso = true;
        }
      }*/

      controller.add(GetRubroEvaluacionResponse(rubricaEvaluacionUi, alumnoCursoList));
      controller.close();
    } catch (e) {
      logger.severe('GetRubroEvaluacion unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetRubroEvaluacionParms{
  String? rubroEvaluacionId;
  int? cargaCursoId;

  GetRubroEvaluacionParms(this.rubroEvaluacionId, this.cargaCursoId);
}

class GetRubroEvaluacionResponse{
 RubricaEvaluacionUi rubricaEvaluacionUi;
 List<PersonaUi> alumnoCursoList;

  GetRubroEvaluacionResponse(this.rubricaEvaluacionUi, this.alumnoCursoList);
}