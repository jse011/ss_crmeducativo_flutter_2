import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_utils.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_calendario_periodo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/app_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/transformar_valor_tipo_nota.dart';

class GetCompetenciaRubroEval extends UseCase<GetCompetenciaRubroResponse, GetCompetenciaRubroParams>{
  RubroRepository rubroRepository;
  ConfiguracionRepository repository;


  GetCompetenciaRubroEval(this.rubroRepository, this.repository);

  @override
  Future<Stream<GetCompetenciaRubroResponse?>> buildUseCaseStream(GetCompetenciaRubroParams? params) async{
    final controller = StreamController<GetCompetenciaRubroResponse>();
    try{

      List<PersonaUi> alumnoCursoList = await repository.getListAlumnoCurso(params?.cargaCursoId??0);

      List<PersonaUi> personaUiList = [];
      List<CompetenciaUi> competenciaUiList = await rubroRepository.getRubroCompetencia(params?.silaboEventoId, params?.calendarioPeriodoUI?.id, params?.cargaCursoId);
      for(CompetenciaUi competenciaUi in competenciaUiList){
        for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
          int totalpeso = 0;
          for(RubricaEvaluacionUi rubricaEvaluacionUi in capacidadUi.rubricaEvalUiList??[]){

            for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi.evaluacionUiList??[]){
                PersonaUi? personaUi = personaUiList.firstWhereOrNull((element) => element.personaId == evaluacionUi.alumnoId);
                if(personaUi==null)personaUiList.add(evaluacionUi.personaUi!);
              }

              CriterioUi? criterioUi = capacidadUi.criterioUiList?.firstWhereOrNull((element) => rubricaEvaluacionUi.desempenioIcdId == element.desempenioIcdId);
              rubricaEvaluacionUi.criterioUi = criterioUi;

              int peso = rubricaEvaluacionUi.peso??0;//Si es nullo es 0
              if(peso != RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO){//Si el peso es igual -1 este rubro no es contando
                if(peso==0){
                  switch(rubricaEvaluacionUi.origenRubroUi){
                    case OrigenRubroUi.GENERADO_INSTRUMENTO:
                      peso = RubricaEvaluacionUi.PESO_NORMAL;//Peso Normal 2
                      break;
                    case OrigenRubroUi.GENERADO_TAREA:
                      peso = RubricaEvaluacionUi.PESO_NORMAL;//Peso Normal 2
                      break;
                    case OrigenRubroUi.GENERADO_PREGUNTA:
                      peso = RubricaEvaluacionUi.PESO_BAJO;//Peso BAJO 1
                      break;
                    default:
                      peso = RubricaEvaluacionUi.PESO_NORMAL;//Peso Normal  2
                      break;
                  }
                  rubricaEvaluacionUi.peso = peso;
                }
                totalpeso = totalpeso + peso;
              }
          }
          capacidadUi.total_peso = totalpeso;
        }
      }

      for(PersonaUi alumnoCurso in alumnoCursoList){
        PersonaUi? personaUi = personaUiList.firstWhereOrNull((element) => element.personaId == alumnoCurso.personaId);
        if(personaUi==null){
          alumnoCurso.soloApareceEnElCurso = true;
          alumnoCursoList.add(alumnoCurso);
        }
      }


      List<EvaluacionCompetenciaUi> evaluacionCompetenciaUiList = [];
      TipoNotaUi? tipoNotaUi = await rubroRepository.getGetTipoNotaResultado(params?.silaboEventoId);
      int notaMaxResultado = tipoNotaUi.escalavalorMaximo??0;
      int notaMinResultado = tipoNotaUi.escalavalorMinimo??0;
      for(PersonaUi personaUi in alumnoCursoList){
        for(CompetenciaUi competenciaUi in competenciaUiList){
          double notaCompetencia = 0;
          EvaluacionCompetenciaUi evaluacionCompetenciaUi = EvaluacionCompetenciaUi();
          evaluacionCompetenciaUi.competenciaUi = competenciaUi;
          evaluacionCompetenciaUi.personaUi = personaUi;
          evaluacionCompetenciaUi.nota = 0.0;
          evaluacionCompetenciaUi.evaluacionCapacidadUiList = [];
          for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
            EvaluacionCapacidadUi evaluacionCapacidadUi = EvaluacionCapacidadUi();
            evaluacionCapacidadUi.capacidadUi = capacidadUi;
            evaluacionCapacidadUi.personaUi = personaUi;
            evaluacionCapacidadUi.nota = 0.0;

            double notaCapacidad = 0;

            bool existenRubros = capacidadUi.rubricaEvalUiList?.isNotEmpty??false;

            for(RubricaEvaluacionUi rubricaEvaluacionUi in capacidadUi.rubricaEvalUiList??[]){

              if(rubricaEvaluacionUi.peso == RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO)continue;//Si el peso es igual -1 este rubro no es contando

              int notaMaxRubro = rubricaEvaluacionUi.tipoNotaUi?.escalavalorMaximo??0;
              int notaMinRubro = rubricaEvaluacionUi.tipoNotaUi?.escalavalorMinimo??0;
              EvaluacionUi? evaluacionUi = rubricaEvaluacionUi.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == personaUi.personaId);
              double notaRubro = AppTools.transformacionInvariante(notaMinRubro.toDouble(), notaMaxRubro.toDouble(), evaluacionUi?.nota??0.0, notaMinResultado.toDouble(), notaMaxResultado.toDouble());;
              //notaCapacidad += notaRubro; //se calcula ahora apartir de pesos
              int totalPeso = (capacidadUi.total_peso??0);
              evaluacionUi?.nota_ponderada = notaRubro * (rubricaEvaluacionUi.peso??0)/(totalPeso!=0?totalPeso:1);
              notaCapacidad += evaluacionUi?.nota_ponderada??0;



            }

            if(existenRubros){

              evaluacionCapacidadUi.nota = notaCapacidad;
              if (tipoNotaUi.tipoNotaTiposUi ==  TipoNotaTiposUi.SELECTOR_VALORES || tipoNotaUi.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS){
                ValorTipoNotaUi? valorTipoNotaUi = TransformarValoTipoNota.getValorTipoNotaCalculado(tipoNotaUi, notaCapacidad);
                evaluacionCapacidadUi.valorTipoNotaUi = valorTipoNotaUi;
              }

            }else{
              evaluacionCapacidadUi.nota = null;
              evaluacionCapacidadUi.valorTipoNotaUi = null;
            }

            notaCompetencia += notaCapacidad;
            evaluacionCompetenciaUi.evaluacionCapacidadUiList?.add(evaluacionCapacidadUi);
          }
          notaCompetencia = (competenciaUi.capacidadUiList?.length??0) > 0? notaCompetencia/competenciaUi.capacidadUiList!.length :0.0;

          evaluacionCompetenciaUi.nota = notaCompetencia;
          if (tipoNotaUi.tipoNotaTiposUi ==  TipoNotaTiposUi.SELECTOR_VALORES || tipoNotaUi.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS){
            ValorTipoNotaUi? valorTipoNotaUi = TransformarValoTipoNota.getValorTipoNotaCalculado(tipoNotaUi, notaCompetencia);
            evaluacionCompetenciaUi.valorTipoNotaUi = valorTipoNotaUi;
          }
          evaluacionCompetenciaUiList.add(evaluacionCompetenciaUi);

        }
      }

      List<EvaluacionCalendarioPeriodoUi> evaluacionCalendarioPeriodoUiList = [];
      for(PersonaUi personaUi in alumnoCursoList){
        double notaCalendario = 0;
        int cantidadCompetencias = 0;
        EvaluacionCalendarioPeriodoUi evaluacionCalendarioPeriodoUi = EvaluacionCalendarioPeriodoUi();
        evaluacionCalendarioPeriodoUi.calendarioPeriodoUI = params?.calendarioPeriodoUI;
        evaluacionCalendarioPeriodoUi.personaUi = personaUi;
        evaluacionCalendarioPeriodoUi.nota = 0.0;

        for(EvaluacionCompetenciaUi evaluacionCompetenciaUi in evaluacionCompetenciaUiList){
          if(personaUi.personaId == evaluacionCompetenciaUi.personaUi?.personaId && evaluacionCompetenciaUi.competenciaUi?.tipoCompetenciaUi == TipoCompetenciaUi.BASE){
            notaCalendario += evaluacionCompetenciaUi.nota??0.0;
            cantidadCompetencias++;
          }
        }
        notaCalendario = cantidadCompetencias > 0? notaCalendario/cantidadCompetencias :0.0;
        evaluacionCalendarioPeriodoUi.nota = notaCalendario;
        if (tipoNotaUi.tipoNotaTiposUi ==  TipoNotaTiposUi.SELECTOR_VALORES || tipoNotaUi.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS){
          ValorTipoNotaUi? valorTipoNotaUi = TransformarValoTipoNota.getValorTipoNotaCalculado(tipoNotaUi, notaCalendario);
          evaluacionCalendarioPeriodoUi.valorTipoNotaUi = valorTipoNotaUi;
        }
        evaluacionCalendarioPeriodoUiList.add(evaluacionCalendarioPeriodoUi);
      }


      controller.add(GetCompetenciaRubroResponse(competenciaUiList,alumnoCursoList,evaluacionCompetenciaUiList, evaluacionCalendarioPeriodoUiList, tipoNotaUi));
      controller.close();
    } catch (e) {
      logger.severe('GetUnidadRubroEval unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }

  //if (bETipoNota.tipoId == 409 || bETipoNota.tipoId == 412)

}

class GetCompetenciaRubroResponse {
  List<CompetenciaUi> competenciaUiList;
  List<PersonaUi> personaUiList;
  List<EvaluacionCompetenciaUi> evaluacionCompetenciaUiList;
  List<EvaluacionCalendarioPeriodoUi> evaluacionCalendarioPeriodoUiList;
  TipoNotaUi tipoNotaUi;

  GetCompetenciaRubroResponse(this.competenciaUiList, this.personaUiList, this.evaluacionCompetenciaUiList, this.evaluacionCalendarioPeriodoUiList, this.tipoNotaUi);
}

class GetCompetenciaRubroParams {
  CalendarioPeriodoUI? calendarioPeriodoUI;
  int? silaboEventoId;
  int? cargaCursoId;

  GetCompetenciaRubroParams(this.calendarioPeriodoUI, this.silaboEventoId, this.cargaCursoId);
}