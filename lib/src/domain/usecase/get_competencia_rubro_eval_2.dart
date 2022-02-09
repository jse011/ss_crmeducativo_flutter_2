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
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_trasnformada_ui.dart';
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
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/calcular_evaluacion_resultado.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/transformar_valor_tipo_nota.dart';

class GetCompetenciaRubroEval2 extends UseCase<GetCompetenciaRubro2Response, GetCompetenciaRubro2Params>{
  RubroRepository rubroRepository;
  ConfiguracionRepository repository;


  GetCompetenciaRubroEval2(this.rubroRepository, this.repository);

  @override
  Future<Stream<GetCompetenciaRubro2Response?>> buildUseCaseStream(GetCompetenciaRubro2Params? params) async{
    final controller = StreamController<GetCompetenciaRubro2Response>();
    try{
      TipoNotaUi? tipoNotaUi = await rubroRepository.getGetTipoNotaResultado(params?.silaboEventoId);

      List<PersonaUi> alumnoCursoList = await repository.getListAlumnoCurso(params?.cargaCursoId??0);

      List<CompetenciaUi> competenciaUiList = await rubroRepository.getRubroCompetencia(params?.silaboEventoId, params?.calendarioPeriodoUI?.id, params?.cargaCursoId);


      for(CompetenciaUi competenciaUi in competenciaUiList){
        bool evaluableCompetencia = false;
        List<CapacidadUi> capacidadUiList = [];
        for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
          //if((capacidadUi.evaluable??false)){
          bool evaluableCapacidad = false;
          for(RubricaEvaluacionUi rubricaEvaluacionUi in capacidadUi.rubricaEvalUiList??[]){
            int cantidadEvaluados = 0;
            for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi.evaluacionUiList??[]){
              if((rubricaEvaluacionUi.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS ||
                  rubricaEvaluacionUi.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES) ){
                if(evaluacionUi.valorTipoNotaId != null){
                  cantidadEvaluados++;
                }
              }else {
                if((evaluacionUi.nota??0) > 0){
                  cantidadEvaluados++;
                }
              }
            }
            rubricaEvaluacionUi.cantiEvalCalificadas = cantidadEvaluados;
            if(cantidadEvaluados!=0){
              evaluableCapacidad =  true;
            }
          }
          if(evaluableCapacidad){
            capacidadUiList.add(capacidadUi);
            evaluableCompetencia = true;
          }
          //}
        }
        capacidadUiList.sort((o1, o2){
          return (o1.rubroResultadoId??0).compareTo((o2.rubroResultadoId??0));
        });
        competenciaUi.capacidadUiList = capacidadUiList;
        competenciaUi.evaluable = evaluableCompetencia;
      }
      competenciaUiList.removeWhere((element) => !(element.evaluable??false));

      alumnoCursoList.sort((o1, o2){
        return (o1.apellidos??"").compareTo((o2.apellidos??""));
      });

      competenciaUiList.sort((o1, o2){
        return (o1.competenciaId??0).compareTo((o2.competenciaId??0));
      });


      for(CompetenciaUi competenciaUi in competenciaUiList){
        for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
          int totalpeso = 0;
          capacidadUi.rubricaEvalUiList?.sort((o1, o2){

            int value1 = (o2.fechaCreacion??DateTime(1995)).compareTo(o1.fechaCreacion??DateTime(1995));
            if(value1 == 0){
              int value2 = (o1.tituloRubroCabecera??"").compareTo(o2.tituloRubroCabecera??"");
              if(value2 == 0){
                return (o1.titulo??"").compareTo(o2.titulo??"");
              }else{
                return value2;
              }
            }
            return 1;
          });
          print("rubricaEvaluacionUi count: ${capacidadUi.rubricaEvalUiList?.length}");
          for(RubricaEvaluacionUi rubricaEvaluacionUi in capacidadUi.rubricaEvalUiList??[]){
            rubricaEvaluacionUi.ningunaEvalCalificada = CalcularEvaluacionResultados.ningunaEvalCalificada(rubricaEvaluacionUi);

            int cantidadEvaluados = 0;
            for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi.evaluacionUiList??[]){
              if((rubricaEvaluacionUi.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS ||
                  rubricaEvaluacionUi.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES) ){
                  if(evaluacionUi.valorTipoNotaId != null){
                    cantidadEvaluados++;
                  }
              }else {
                if((evaluacionUi.nota??0) > 0){
                  cantidadEvaluados++;
                }
              }
          }
            rubricaEvaluacionUi.cantiEvalCalificadas = cantidadEvaluados;

            int peso = CalcularEvaluacionResultados.getPesoRubro(rubricaEvaluacionUi);
            totalpeso = totalpeso + (peso < 0 ? 0 : peso);//los pesos en negativo se cuentan como 0;

            List<EvaluacionTransformadaUi> evaluacionTransformadaUiList = [];

            for(PersonaUi alumnoCurso in alumnoCursoList){

              EvaluacionUi? evaluacionUi = rubricaEvaluacionUi.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == alumnoCurso.personaId);
              //Una evaluacion vasia significa que el foto_alumno no tiene evaluacion
              if(evaluacionUi==null){
                evaluacionUi = EvaluacionUi();
                alumnoCurso.soloApareceEnElCurso = true;
                rubricaEvaluacionUi.evaluacionUiList?.add(evaluacionUi);
                evaluacionUi.rubroEvaluacionUi = rubricaEvaluacionUi;
                evaluacionUi.alumnoId = alumnoCurso.personaId;
              }
              evaluacionUi.personaUi = alumnoCurso;

              //Crear y calcular la nueva evaluacion transformada a la nota del resultado
              EvaluacionTransformadaUi evaluacionTransformadaUi = EvaluacionTransformadaUi();
              evaluacionTransformadaUi.alumnoId = evaluacionUi.alumnoId;
              evaluacionTransformadaUi.personaUi = alumnoCurso;  // Buscar el foto_alumno que pertenece al carga_curso para saver si esta con el contrato vigente
              evaluacionTransformadaUi.publicado = evaluacionUi.publicado;
              evaluacionTransformadaUi.evaluacionId = evaluacionUi.evaluacionId;
              evaluacionTransformadaUi.rubroEvaluacionId = evaluacionUi.rubroEvaluacionId;
              evaluacionTransformadaUi.rubroEvaluacionUi = evaluacionUi.rubroEvaluacionUi;
              evaluacionTransformadaUi.evaluacionUiOriginal = evaluacionUi;
              CalcularEvaluacionResultados.actualizarEvaluacionTransformada(evaluacionTransformadaUi, tipoNotaUi);
              evaluacionTransformadaUiList.add(evaluacionTransformadaUi);

            }

            rubricaEvaluacionUi.evaluacionTransformadaUiList = evaluacionTransformadaUiList;

            CriterioUi? criterioUi = capacidadUi.criterioUiList?.firstWhereOrNull((element) => rubricaEvaluacionUi.desempenioIcdId == element.desempenioIcdId);
            rubricaEvaluacionUi.criterioUi = criterioUi;
          }
          capacidadUi.total_peso = totalpeso;
        }
      }

      List<EvaluacionCompetenciaUi> evaluacionCompetenciaUiList = [];

      for(PersonaUi personaUi in alumnoCursoList){
        //#region cacular competencia
        for(CompetenciaUi competenciaUi in competenciaUiList){
          double notaCompetencia = 0;
          EvaluacionCompetenciaUi evaluacionCompetenciaUi = EvaluacionCompetenciaUi();
          evaluacionCompetenciaUi.competenciaUi = competenciaUi;
          evaluacionCompetenciaUi.personaUi = personaUi;
          evaluacionCompetenciaUi.nota = 0.0;
          evaluacionCompetenciaUi.evaluacionCapacidadUiList = [];
          bool fueCalificado = false;
          for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
            EvaluacionCapacidadUi evaluacionCapacidadUi = EvaluacionCapacidadUi();
            evaluacionCapacidadUi.capacidadUi = capacidadUi;
            evaluacionCapacidadUi.personaUi = personaUi;
            evaluacionCapacidadUi.nota = 0.0;

            CalcularEvaluacionResultados.calcularEvaluacionCapacidad(evaluacionCapacidadUi: evaluacionCapacidadUi, tipoNotaUiResultado: tipoNotaUi, alumnoId: personaUi.personaId);
            double notaCapacidad = evaluacionCapacidadUi.nota??0;

            notaCompetencia += notaCapacidad;
            evaluacionCompetenciaUi.evaluacionCapacidadUiList?.add(evaluacionCapacidadUi);

            if(tipoNotaUi.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS||
                tipoNotaUi.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
              if(evaluacionCapacidadUi.valorTipoNotaUi!=null){
                fueCalificado = true;
              }
            }else{
              if((evaluacionCapacidadUi.nota??0)>0){
                fueCalificado = true;
              }
            }

          }

          if(fueCalificado){
            notaCompetencia = (competenciaUi.capacidadUiList?.length??0) > 0? notaCompetencia/competenciaUi.capacidadUiList!.length :0.0;

            evaluacionCompetenciaUi.nota = notaCompetencia;
            if (tipoNotaUi.tipoNotaTiposUi ==  TipoNotaTiposUi.SELECTOR_VALORES || tipoNotaUi.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS){
              ValorTipoNotaUi? valorTipoNotaUi = TransformarValoTipoNota.getValorTipoNota(tipoNotaUi, notaCompetencia);
              evaluacionCompetenciaUi.valorTipoNotaUi = valorTipoNotaUi;
            }
          }else{
            evaluacionCompetenciaUi.nota = null;
            evaluacionCompetenciaUi.valorTipoNotaUi = null;
          }


          evaluacionCompetenciaUiList.add(evaluacionCompetenciaUi);

        }
        //#endregion cacular competencia
      }


      List<EvaluacionCalendarioPeriodoUi> evaluacionCalendarioPeriodoUiList = [];
      for(PersonaUi personaUi in alumnoCursoList){

        double notaCalendario = 0;
        int cantidadCompetencias = 0;
        EvaluacionCalendarioPeriodoUi evaluacionCalendarioPeriodoUi = EvaluacionCalendarioPeriodoUi();
        evaluacionCalendarioPeriodoUi.calendarioPeriodoUI = params?.calendarioPeriodoUI;
        evaluacionCalendarioPeriodoUi.personaUi = personaUi;
        evaluacionCalendarioPeriodoUi.nota = 0.0;
        //#region calacular Totales
        bool fueCalificado = false;
        for(EvaluacionCompetenciaUi evaluacionCompetenciaUi in evaluacionCompetenciaUiList){
          if(personaUi.personaId == evaluacionCompetenciaUi.personaUi?.personaId && evaluacionCompetenciaUi.competenciaUi?.tipoCompetenciaUi == TipoCompetenciaUi.BASE){
            notaCalendario += evaluacionCompetenciaUi.nota??0.0;
            cantidadCompetencias++;

            if(tipoNotaUi.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS||
                tipoNotaUi.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
              if(evaluacionCompetenciaUi.valorTipoNotaUi!=null){
                fueCalificado = true;
              }
            }else{
              if((evaluacionCompetenciaUi.nota??0)>0){
                fueCalificado = true;
              }
            }
          }
        }
        if(fueCalificado){
          notaCalendario = cantidadCompetencias > 0? notaCalendario/cantidadCompetencias :0.0;
          evaluacionCalendarioPeriodoUi.nota = notaCalendario;
          if (tipoNotaUi.tipoNotaTiposUi ==  TipoNotaTiposUi.SELECTOR_VALORES || tipoNotaUi.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS){
            ValorTipoNotaUi? valorTipoNotaUi = TransformarValoTipoNota.getValorTipoNota(tipoNotaUi, notaCalendario);
            evaluacionCalendarioPeriodoUi.valorTipoNotaUi = valorTipoNotaUi;
          }
        }else{
          evaluacionCalendarioPeriodoUi.nota = null;
          evaluacionCalendarioPeriodoUi.valorTipoNotaUi = null;
        }
        //#endregion
        evaluacionCalendarioPeriodoUiList.add(evaluacionCalendarioPeriodoUi);

      }


      controller.add(GetCompetenciaRubro2Response(competenciaUiList,alumnoCursoList,evaluacionCompetenciaUiList, evaluacionCalendarioPeriodoUiList, tipoNotaUi));
      controller.close();
    } catch (e) {
      logger.severe('GetUnidadRubroEval unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }

  //if (bETipoNota.tipoId == 409 || bETipoNota.tipoId == 412)

}

class GetCompetenciaRubro2Response {
  List<CompetenciaUi> competenciaUiList;
  List<PersonaUi> personaUiList;
  List<EvaluacionCompetenciaUi> evaluacionCompetenciaUiList;
  List<EvaluacionCalendarioPeriodoUi> evaluacionCalendarioPeriodoUiList;
  TipoNotaUi tipoNotaUi;

  GetCompetenciaRubro2Response(this.competenciaUiList, this.personaUiList, this.evaluacionCompetenciaUiList, this.evaluacionCalendarioPeriodoUiList, this.tipoNotaUi);
}

class GetCompetenciaRubro2Params {
  CalendarioPeriodoUI? calendarioPeriodoUI;
  int? silaboEventoId;
  int? cargaCursoId;

  GetCompetenciaRubro2Params(this.calendarioPeriodoUI, this.silaboEventoId, this.cargaCursoId);
}