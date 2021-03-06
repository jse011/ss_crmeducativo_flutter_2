import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_trasnformada_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/transformar_valor_tipo_nota.dart';

class CalcularEvaluacionResultados {
/*
  static calcularEvaluacionCapacidad({required EvaluacionCapacidadUi? evaluacionCapacidadUi, required TipoNotaUi? tipoNotaUiResultado, required int? alumnoId}){
    CapacidadUi? capacidadUi = evaluacionCapacidadUi?.capacidadUi;

    double notaCapacidad = 0;

    bool existenRubros = false;

    for(RubricaEvaluacionUi rubricaEvaluacionUi in capacidadUi?.rubricaEvalUiList??[]){
      int totalPeso = (capacidadUi?.total_peso??0);
      EvaluacionTransformadaUi? evaluacionTransformadaUi = rubricaEvaluacionUi.evaluacionTransformadaUiList?.firstWhereOrNull((element) => element.alumnoId == alumnoId);
      if(rubricaEvaluacionUi.peso == RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO){
        evaluacionTransformadaUi?.nota_ponderada = 0;
      }else{
        if(rubricaEvaluacionUi.ningunaEvalCalificada??false){
          //si ninguna evaluacion tiene calificacion la nota ponderada es 0
          evaluacionTransformadaUi?.nota_ponderada = 0;
        }else{
          existenRubros = true;
          evaluacionTransformadaUi?.nota_ponderada = (evaluacionTransformadaUi.nota??0) * (rubricaEvaluacionUi.peso??0)/(totalPeso!=0?totalPeso:1);
        }
      }

      notaCapacidad += evaluacionTransformadaUi?.nota_ponderada??0;
    }

    if(existenRubros){

      evaluacionCapacidadUi?.nota = notaCapacidad;
      if (tipoNotaUiResultado?.tipoNotaTiposUi ==  TipoNotaTiposUi.SELECTOR_VALORES || tipoNotaUiResultado?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS){
        ValorTipoNotaUi? valorTipoNotaUi = TransformarValoTipoNota.getValorTipoNotaCalculado(tipoNotaUiResultado, notaCapacidad);
        evaluacionCapacidadUi?.valorTipoNotaUi = valorTipoNotaUi;
      }

    }else{
      evaluacionCapacidadUi?.nota = null;
      evaluacionCapacidadUi?.valorTipoNotaUi = null;
    }


  }

  //A 20 a A1 resultado
  static actualizarEvaluacionTransformada(EvaluacionTransformadaUi? evaluacionTransformadaUi, TipoNotaUi? tipoNotaUiResultado){
    EvaluacionUi? evaluacionUi =  evaluacionTransformadaUi?.evaluacionUiOriginal;
    TipoNotaUi? tipoNotaUi = evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi;
    int notaMaxRubro = evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi?.escalavalorMaximo??0;
    int notaMinRubro = evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi?.escalavalorMinimo??0;
    TransformarValoTipoNotaResponse response = TransformarValoTipoNota.execute(TransformarValoTipoNotaParams(evaluacionUi?.nota, notaMinRubro, notaMaxRubro, tipoNotaUiResultado));
    evaluacionTransformadaUi?.nota = response.nota;
    //Si el valor TipoNotaId es null la transformada tambien es null
    if((evaluacionUi?.valorTipoNotaId??"").isNotEmpty && (tipoNotaUi?.tipoNotaTiposUi ==  TipoNotaTiposUi.SELECTOR_VALORES || tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS)){
      evaluacionTransformadaUi?.valorTipoNotaId = response.valorTipoNotaUi?.valorTipoNotaId;
      evaluacionTransformadaUi?.valorTipoNotaUi = response.valorTipoNotaUi;
    }else{
      evaluacionTransformadaUi?.evaluacionId = null;
      evaluacionTransformadaUi?.valorTipoNotaUi = null;
    }

  }

  static actualizarEvaluacionOriginal(EvaluacionTransformadaUi? evaluacionTransformadaUi,  TipoNotaUi? tipoNotaUiResultado){
    EvaluacionUi? evaluacionUi =  evaluacionTransformadaUi?.evaluacionUiOriginal;
    int notaMaxResultado = tipoNotaUiResultado?.escalavalorMaximo??0;
    int notaMinResultado = tipoNotaUiResultado?.escalavalorMinimo??0;
    TransformarValoTipoNotaResponse response = TransformarValoTipoNota.execute(TransformarValoTipoNotaParams(evaluacionTransformadaUi?.nota, notaMinResultado, notaMaxResultado, evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi));
    evaluacionUi?.nota = response.nota;

    if((evaluacionTransformadaUi?.valorTipoNotaId??"").isNotEmpty && (tipoNotaUiResultado?.tipoNotaTiposUi ==  TipoNotaTiposUi.SELECTOR_VALORES || tipoNotaUiResultado?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS)){
      evaluacionUi?.valorTipoNotaId = response.valorTipoNotaUi?.valorTipoNotaId;
      evaluacionUi?.valorTipoNotaUi = response.valorTipoNotaUi;
    }else{
      evaluacionUi?.valorTipoNotaId = null;
      evaluacionUi?.valorTipoNotaUi = null;
    }

  }

  static bool ningunaEvalCalificada(RubricaEvaluacionUi? rubricaEvaluacionUi)  {
    int cant_evaluacines_calificadas = 0;
    for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi?.evaluacionUiList??[]){
      if((evaluacionUi.nota??0) > 0){
        cant_evaluacines_calificadas++;
      }
    }
    //return cant_evaluacines_calificadas == 0;
    return false;
  }

  static int getPesoRubro(RubricaEvaluacionUi? rubricaEvaluacionUi){

    if((rubricaEvaluacionUi?.peso??0) < 0 ){
      rubricaEvaluacionUi?.peso = RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO;
    }else if((rubricaEvaluacionUi?.peso??0) == 0){
      switch(rubricaEvaluacionUi?.origenRubroUi){
        case OrigenRubroUi.GENERADO_INSTRUMENTO:
          rubricaEvaluacionUi?.peso = RubricaEvaluacionUi.PESO_NORMAL;//Peso Normal 2
          break;
        case OrigenRubroUi.GENERADO_TAREA:
          rubricaEvaluacionUi?.peso = RubricaEvaluacionUi.PESO_NORMAL;//Peso Normal 2
          break;
        case OrigenRubroUi.GENERADO_PREGUNTA:
          rubricaEvaluacionUi?.peso = RubricaEvaluacionUi.PESO_BAJO;//Peso BAJO 1
          break;
        default:
          rubricaEvaluacionUi?.peso = RubricaEvaluacionUi.PESO_NORMAL;//Peso Normal  2
          break;
      }
    }

    if(rubricaEvaluacionUi?.ningunaEvalCalificada??false){
        return 0;
    }
    return rubricaEvaluacionUi?.peso??0;

  }
*/
}