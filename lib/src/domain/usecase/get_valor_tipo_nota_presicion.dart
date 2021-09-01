import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';

class GetValorTipoNotaPresicion {

  List<int> execute(ValorTipoNotaUi? valorTipoNotaUi){

    int limiteSuperior = valorTipoNotaUi?.limiteSuperior?.toInt()??0;
    int limiteInferior = valorTipoNotaUi?.limiteInferior?.toInt()??0;

    int cantidad = limiteSuperior - limiteInferior + 1;
    List<int> notaCircularUis  = [];
    for (int i = 0; i<cantidad; i++){
      notaCircularUis.add(limiteInferior);
      limiteInferior ++;
    }

    int? removeNotaInferior = null;
    int? removeNotaSuperior = null;

    if(!(valorTipoNotaUi?.incluidoLInferior??false)){
    removeNotaInferior = notaCircularUis[0];
    }

    if(!(valorTipoNotaUi?.incluidoLSuperior??false)){
    removeNotaSuperior = notaCircularUis[cantidad-1];
    }
    if(removeNotaInferior!=null)notaCircularUis.remove(removeNotaInferior);
    if(removeNotaSuperior!=null)notaCircularUis.remove(removeNotaSuperior);

    return notaCircularUis.reversed.toList();
  }


}