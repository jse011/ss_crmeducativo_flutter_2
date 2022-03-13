import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/transformar_valor_tipo_nota.dart';

import 'domain_tools.dart';

class CalcularEvaluacionProceso {
  static void actualizarCabecera(RubricaEvaluacionUi? rubricaEvaluacionUi, PersonaUi? personaUi) {

    var transformar = (int? personaId){
      EvaluacionUi? evaluacionUiCabecera = rubricaEvaluacionUi?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == personaId);
      List<EvaluacionUi> evaluacionUiDetalleList = [];
      for(RubricaEvaluacionUi rubroEvaluacionUi in rubricaEvaluacionUi?.rubrosDetalleList??[]){
        for(EvaluacionUi item in rubroEvaluacionUi.evaluacionUiList??[]){
          if(item.personaUi?.personaId == personaId){
            evaluacionUiDetalleList.add(item);
          }
        }
      }
      double notaDetalle = 0.0;
      int countSelecionado = 0;
      TipoNotaUi? tipoNotaUiDetalle;
      for(EvaluacionUi evaluacionUi in evaluacionUiDetalleList){
        double peso = (evaluacionUi.rubroEvaluacionUi?.formula_peso??0)/100;
        notaDetalle += DomainTools.roundDouble((evaluacionUi.nota??0.0) * peso,2);//Para evitar calcular con muchos decimasles se redonde a dos
        tipoNotaUiDetalle = evaluacionUi.rubroEvaluacionUi?.tipoNotaUi;
        if((evaluacionUi.valorTipoNotaId??"").isNotEmpty)countSelecionado++;
      }
      print("modificado12:countSelecionado ${countSelecionado}");
      if(countSelecionado>0){
        double? nota = TransformarValoTipoNota.transformarNota(notaDetalle, tipoNotaUiDetalle, null, rubricaEvaluacionUi?.tipoNotaUi);
        ValorTipoNotaUi? valorTipoNotaUi = TransformarValoTipoNota.transformarTipoNota(notaDetalle, tipoNotaUiDetalle, null, rubricaEvaluacionUi?.tipoNotaUi);
        print("modificado12:countSelecionado ${valorTipoNotaUi?.alias}");
        evaluacionUiCabecera?.valorTipoNotaId = valorTipoNotaUi?.valorTipoNotaId;
        evaluacionUiCabecera?.valorTipoNotaUi = valorTipoNotaUi;
        evaluacionUiCabecera?.nota = DomainTools.roundDouble(nota??0.0, 2);// Se redondea a dos diguitos pero se muesta solo un digito para mostar al usuario
      }else{
        evaluacionUiCabecera?.valorTipoNotaId = null;
        evaluacionUiCabecera?.valorTipoNotaUi = null;
        evaluacionUiCabecera?.nota = 0.0;// Se redondea a dos diguitos pero se muesta solo un digito para mostar al usuario
      }
    };

    if(personaUi?.personaId != null){
      transformar(personaUi?.personaId);
    }else{
      for(EvaluacionUi item in rubricaEvaluacionUi?.evaluacionUiList??[]){
        transformar(item.alumnoId);
      }
    }
  }

}