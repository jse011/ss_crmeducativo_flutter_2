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

  static calcularEvaluacionCapacidad({required EvaluacionCapacidadUi? evaluacionCapacidadUi, required TipoNotaUi? tipoNotaUiResultado, required int? alumnoId}){
    CapacidadUi? capacidadUi = evaluacionCapacidadUi?.capacidadUi;

    double notaCapacidad = 0;

    bool fueCalificado = false;
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
          evaluacionTransformadaUi?.nota_ponderada = (evaluacionTransformadaUi.nota??0) * (rubricaEvaluacionUi.peso??0)/(totalPeso!=0?totalPeso:1);
        }
      }

      notaCapacidad += evaluacionTransformadaUi?.nota_ponderada??0;

      if(tipoNotaUiResultado?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS||
          tipoNotaUiResultado?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
         if(evaluacionTransformadaUi?.valorTipoNotaUi!=null){
           fueCalificado = true;
         }
      }else{
        if((evaluacionTransformadaUi?.nota_ponderada??0)>0){
          fueCalificado = true;
        }
      }
    }

    if(fueCalificado){
      evaluacionCapacidadUi?.nota = notaCapacidad;
      if (tipoNotaUiResultado?.tipoNotaTiposUi ==  TipoNotaTiposUi.SELECTOR_VALORES || tipoNotaUiResultado?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS){
        ValorTipoNotaUi? valorTipoNotaUi = TransformarValoTipoNota.getValorTipoNota(tipoNotaUiResultado, notaCapacidad);
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

    evaluacionTransformadaUi?.nota = TransformarValoTipoNota.transformarNota(evaluacionUi?.nota, tipoNotaUi, evaluacionUi?.valorTipoNotaUi, tipoNotaUiResultado);
    ValorTipoNotaUi? valorTipoNotaUiResultado = TransformarValoTipoNota.transformarTipoNota(evaluacionUi?.nota, tipoNotaUi, evaluacionUi?.valorTipoNotaUi, tipoNotaUiResultado);

    evaluacionTransformadaUi?.valorTipoNotaId = valorTipoNotaUiResultado?.valorTipoNotaId;
    evaluacionTransformadaUi?.valorTipoNotaUi = valorTipoNotaUiResultado;

  }

  static actualizarEvaluacionOriginal(EvaluacionTransformadaUi? evaluacionTransformadaUi,  TipoNotaUi? tipoNotaUiResultado){
    EvaluacionUi? evaluacionUi =   evaluacionTransformadaUi?.evaluacionUiOriginal;;
    print("actualizarEvaluacionOriginal");
    evaluacionUi?.nota = TransformarValoTipoNota.transformarNota(evaluacionTransformadaUi?.nota, tipoNotaUiResultado, evaluacionTransformadaUi?.valorTipoNotaUi, evaluacionUi.rubroEvaluacionUi?.tipoNotaUi);
    print("actualizarEvaluacionOriginal ${ evaluacionUi?.nota}");
    ValorTipoNotaUi? valorTipoNotaUiProceso = TransformarValoTipoNota.transformarTipoNota(evaluacionTransformadaUi?.nota, tipoNotaUiResultado, evaluacionTransformadaUi?.valorTipoNotaUi, evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi);

    evaluacionUi?.valorTipoNotaId = valorTipoNotaUiProceso?.valorTipoNotaId;
    evaluacionUi?.valorTipoNotaUi = valorTipoNotaUiProceso;

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

}