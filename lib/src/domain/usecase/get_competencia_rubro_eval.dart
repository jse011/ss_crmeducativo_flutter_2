import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_calendario_periodo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
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
          for(RubricaEvaluacionUi rubricaEvaluacionUi in capacidadUi.rubricaEvalUiList??[]){
              for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi.evaluacionUiList??[]){
                PersonaUi? personaUi = personaUiList.firstWhereOrNull((element) => element.personaId == evaluacionUi.alumnoId);
                if(personaUi==null)personaUiList.add(evaluacionUi.personaUi!);
              }
          }
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
            for(RubricaEvaluacionUi rubricaEvaluacionUi in capacidadUi.rubricaEvalUiList??[]){
              int notaMaxRubro = rubricaEvaluacionUi.tipoNotaUi?.escalavalorMaximo??0;
              int notaMinRubro = rubricaEvaluacionUi.tipoNotaUi?.escalavalorMinimo??0;
              EvaluacionUi? evaluacionUi = rubricaEvaluacionUi.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == personaUi.personaId);
              double notaRubro = AppTools.transformacionInvariante(notaMinRubro.toDouble(), notaMaxRubro.toDouble(), evaluacionUi?.nota??0.0, notaMinResultado.toDouble(), notaMaxResultado.toDouble());;
              notaCapacidad += notaRubro;
            }
            notaCapacidad = (capacidadUi.rubricaEvalUiList?.length??0) > 0? notaCapacidad/capacidadUi.rubricaEvalUiList!.length :0.0;
            evaluacionCapacidadUi.nota = notaCapacidad;
            if (tipoNotaUi.tipoNotaTiposUi ==  TipoNotaTiposUi.SELECTOR_VALORES || tipoNotaUi.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS){
              ValorTipoNotaUi? valorTipoNotaUi = _getValorTipoNotaCalculado(tipoNotaUi, notaCapacidad);
              evaluacionCapacidadUi.valorTipoNotaUi = valorTipoNotaUi;
            }
            notaCompetencia += notaCapacidad;
            evaluacionCompetenciaUi.evaluacionCapacidadUiList?.add(evaluacionCapacidadUi);
          }
          notaCompetencia = (competenciaUi.capacidadUiList?.length??0) > 0? notaCompetencia/competenciaUi.capacidadUiList!.length :0.0;

          evaluacionCompetenciaUi.nota = notaCompetencia;
          if (tipoNotaUi.tipoNotaTiposUi ==  TipoNotaTiposUi.SELECTOR_VALORES || tipoNotaUi.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS){
            ValorTipoNotaUi? valorTipoNotaUi = _getValorTipoNotaCalculado(tipoNotaUi, notaCompetencia);
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
          ValorTipoNotaUi? valorTipoNotaUi = _getValorTipoNotaCalculado(tipoNotaUi, notaCalendario);
          evaluacionCalendarioPeriodoUi.valorTipoNotaUi = valorTipoNotaUi;
        }
        evaluacionCalendarioPeriodoUiList.add(evaluacionCalendarioPeriodoUi);
      }


      controller.add(GetCompetenciaRubroResponse(competenciaUiList,alumnoCursoList,evaluacionCompetenciaUiList, evaluacionCalendarioPeriodoUiList));
      controller.close();
    } catch (e) {
      logger.severe('GetUnidadRubroEval unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }

  //if (bETipoNota.tipoId == 409 || bETipoNota.tipoId == 412)
  ValorTipoNotaUi? _getValorTipoNotaCalculado(TipoNotaUi? bETipoNota, double nota)
  {
    //log.Info(string.Format("getValorTipoNotaCalculado: bETipoNota: id{0}, nombre:{1}, intervalo{2}", bETipoNota.TipoNotaId, bETipoNota.Nombre, bETipoNota.Intervalo));
    ValorTipoNotaUi? result = null;
    if (bETipoNota?.intervalo??false)
    {
      for (ValorTipoNotaUi bEValorTipoNota in bETipoNota?.valorTipoNotaList??[])
      {
        bool valorInferior = false;
        bool valorSuperior = false;

        if (bEValorTipoNota.incluidoLSuperior??false)
        {
          if ((bEValorTipoNota.limiteSuperior??0) >= nota)
          {
            valorSuperior = true;
          }
        }
        else
        {
          if ((bEValorTipoNota.limiteSuperior??0) > nota)
          {
            valorSuperior = true;
          }
        }

        if (bEValorTipoNota.incluidoLInferior??false)
        {
          if ((bEValorTipoNota.limiteInferior??0) <= nota)
          {
            valorInferior = true;
          }
        }
        else
        {
          if ((bEValorTipoNota.limiteInferior??0) < nota)
          {
            valorInferior = true;
          }
        }

        if (valorInferior && valorSuperior)
        {
          result = bEValorTipoNota;
          break;
        }
      }
    }
    else
    {

      int notaEntera = nota.round();
      if ((bETipoNota?.valorTipoNotaList?.length??0 )== 2)
      {
        int valorintermedio = ((bETipoNota?.escalavalorMaximo??0)  + (bETipoNota?.escalavalorMinimo??0) / 2).round();

        List<ValorTipoNotaUi> vlst_valoresOrdenados = []..addAll(bETipoNota?.valorTipoNotaList??[]);
        vlst_valoresOrdenados.sort((o1, o2) =>  (o1.valorNumerico??0).compareTo(o2.valorNumerico??0));

        if (valorintermedio >= notaEntera)
        {
          result = vlst_valoresOrdenados[0];
        }
        else
        {
          result = vlst_valoresOrdenados[1];
        }
      }
      else
      {
        for (ValorTipoNotaUi bEValorTipoNota in bETipoNota?.valorTipoNotaList??[])
        {
          //log.Info(string.Format("bEValorTipoNota.ValorNumerico: {0} == nota: {1}", bEValorTipoNota.ValorNumerico, notaEntera));
          if (bEValorTipoNota.valorNumerico == notaEntera)
          {
            result = bEValorTipoNota;
            break;
          }
        }
      }

      //Si no se encontro su valor tipo nota retornar el menor posible
      if (notaEntera == 0 && result == null && (bETipoNota?.valorTipoNotaList?.length??0) > 0)
      {
        //result = new List<BEValorTipoNota>(bETipoNota.valores).OrderBy(o1 => o1.valorNumerico).ToList()[0];
        result = (([]..addAll(bETipoNota?.valorTipoNotaList??[]))..sort((o1, o2) =>  (o1.valorNumerico??0).compareTo(o2.valorNumerico??0)))[0];
      }

    }
    return result;
  }
}

class GetCompetenciaRubroResponse {
  List<CompetenciaUi> competenciaUiList;
  List<PersonaUi> personaUiList;
  List<EvaluacionCompetenciaUi> evaluacionCompetenciaUiList;
  List<EvaluacionCalendarioPeriodoUi> evaluacionCalendarioPeriodoUiList;

  GetCompetenciaRubroResponse(this.competenciaUiList, this.personaUiList, this.evaluacionCompetenciaUiList, this.evaluacionCalendarioPeriodoUiList);
}

class GetCompetenciaRubroParams {
  CalendarioPeriodoUI? calendarioPeriodoUI;
  int? silaboEventoId;
  int? cargaCursoId;

  GetCompetenciaRubroParams(this.calendarioPeriodoUI, this.silaboEventoId, this.cargaCursoId);
}