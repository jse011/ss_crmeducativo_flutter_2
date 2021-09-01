import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/app_tools.dart';

class TransformarValoTipoNota{

  static TransformarValoTipoNotaResponse execute(TransformarValoTipoNotaParams params){
    ValorTipoNotaUi? valorTipoNotaUi = null;
    double notaRubro = AppTools.transformacionInvariante(params.notaValorMinimo.toDouble(), params.notaValorMaximo.toDouble(), params.nota??0.0, params.tipoNotaUi?.escalavalorMinimo?.toDouble()??0.0, params.tipoNotaUi?.escalavalorMaximo?.toDouble()??0.0);
    if (params.tipoNotaUi?.tipoNotaTiposUi ==  TipoNotaTiposUi.SELECTOR_VALORES || params.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS){
      valorTipoNotaUi = _getValorTipoNotaCalculado(params.tipoNotaUi, notaRubro);
    }
    return TransformarValoTipoNotaResponse(notaRubro, valorTipoNotaUi);
  }

  static ValorTipoNotaUi? _getValorTipoNotaCalculado(TipoNotaUi? bETipoNota, double nota)
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

class TransformarValoTipoNotaParams{
  double? nota;
  int notaValorMinimo;
  int notaValorMaximo;
  TipoNotaUi? tipoNotaUi;

  TransformarValoTipoNotaParams(
      this.nota, this.notaValorMinimo, this.notaValorMaximo, this.tipoNotaUi);
}

class TransformarValoTipoNotaResponse{
  double? nota;
  ValorTipoNotaUi? valorTipoNotaUi;

  TransformarValoTipoNotaResponse(this.nota, this.valorTipoNotaUi);
}
