import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';

class TransformarValoTipoNota {

  static ValorTipoNotaUi? transformarTipoNota(double? notaEntrada, TipoNotaUi? tipoNotaEntraUi, ValorTipoNotaUi? valorTipoNotaEntradaUi, TipoNotaUi? tipoNotaSalidaUi)
  {

    if((tipoNotaSalidaUi?.resultado??false)||(tipoNotaEntraUi?.resultado??false)){
      double? notaRubro = 0;
      switch(tipoNotaEntraUi?.tipoNotaTiposUi){
        case TipoNotaTiposUi.SELECTOR_VALORES:
        case TipoNotaTiposUi.SELECTOR_ICONOS:

          notaRubro = valorTipoNotaEntradaUi?.valorNumericoTransf??0;
          break;
        case TipoNotaTiposUi.SELECTOR_NUMERICO:
        case TipoNotaTiposUi.VALOR_NUMERICO:
        default:
          notaRubro = notaEntrada;
          break;
      }

      return getValorTipoNotaTransformada(notaRubro, tipoNotaSalidaUi);

    }else{
      double? notaRubro = DomainTools.transformacionInvariante(
          tipoNotaEntraUi?.escalavalorMinimo?.toDouble()??0,
          tipoNotaEntraUi?.escalavalorMaximo?.toDouble()??0,
          notaEntrada,
          tipoNotaSalidaUi?.escalavalorMinimo?.toDouble() ?? 0.0,
          tipoNotaSalidaUi?.escalavalorMaximo?.toDouble() ?? 0.0);

        return getValorTipoNota(tipoNotaSalidaUi, notaRubro);
    }

  }

  static double? transformarNota(double? notaEntrada, TipoNotaUi? tipoNotaEntraUi, ValorTipoNotaUi? valorTipoNotaEntradaUi, TipoNotaUi? tipoNotaSalidaUi)
  {

    print("transformarNota notaEntrada: ${notaEntrada}");

    if((tipoNotaSalidaUi?.resultado??false)||(tipoNotaEntraUi?.resultado??false)){
      double? notaRubro = 0;
      switch(tipoNotaEntraUi?.tipoNotaTiposUi){
        case TipoNotaTiposUi.SELECTOR_VALORES:
        case TipoNotaTiposUi.SELECTOR_ICONOS:
          if(tipoNotaEntraUi?.escalavalorMaximo == tipoNotaSalidaUi?.escalavalorMaximo &&
              tipoNotaEntraUi?.escalavalorMinimo == tipoNotaSalidaUi?.escalavalorMinimo){
            notaRubro = notaEntrada;
          }else{
            notaRubro = valorTipoNotaEntradaUi?.valorNumericoTransf;
          }
          print("transformarNota valorNumericoTransf: ${notaRubro}");
          break;
        case TipoNotaTiposUi.SELECTOR_NUMERICO:
        case TipoNotaTiposUi.VALOR_NUMERICO:
        default:
        notaRubro = notaEntrada;
          break;
      }
      print("transformarNota notaRubro: ${notaRubro}");
      print("transformarNota tipoNotaSalidaUi: ${tipoNotaSalidaUi?.tipoNotaTiposUi}");
      switch(tipoNotaSalidaUi?.tipoNotaTiposUi){
        case TipoNotaTiposUi.SELECTOR_VALORES:
        case TipoNotaTiposUi.SELECTOR_ICONOS:
        if(tipoNotaEntraUi?.escalavalorMaximo == tipoNotaSalidaUi?.escalavalorMaximo &&
            tipoNotaEntraUi?.escalavalorMinimo == tipoNotaSalidaUi?.escalavalorMinimo){
          notaRubro = notaEntrada;
        }else{
          ValorTipoNotaUi? valorTipoNotaUi = getValorTipoNotaTransformada(notaRubro, tipoNotaSalidaUi);
          notaRubro = valorTipoNotaUi?.valorNumerico;
        }
          print("transformarNota notaRubro: ${notaRubro}");
          break;
        case TipoNotaTiposUi.SELECTOR_NUMERICO:
        case TipoNotaTiposUi.VALOR_NUMERICO:
        default:

          break;
      }
      return notaRubro;
    }else{


      return DomainTools.transformacionInvariante(
          tipoNotaEntraUi?.escalavalorMinimo?.toDouble()??0,
          tipoNotaEntraUi?.escalavalorMaximo?.toDouble()??0,
          notaEntrada,
          tipoNotaSalidaUi?.escalavalorMinimo?.toDouble() ?? 0.0,
          tipoNotaSalidaUi?.escalavalorMaximo?.toDouble() ?? 0.0);

      //log.Info(string.Format("getValorTipoNotaCalculado: bETipoNota: id{0}, nombre:{1}, intervalo{2}", bETipoNota.TipoNotaId, bETipoNota.Nombre, bETipoNota.Intervalo));
    }


  }

  static ValorTipoNotaUi? getValorTipoNotaTransformada(double? nota, TipoNotaUi? tipoNotaResultadoUi){
    ValorTipoNotaUi? result = null;
    nota = nota!=null?DomainTools.roundDouble(nota,0):null;

    for (ValorTipoNotaUi bEValorTipoNota in tipoNotaResultadoUi?.valorTipoNotaList??[])
    {
      bool valorInferior = false;
      bool valorSuperior = false;

      if (bEValorTipoNota.incluidoLSuperiorTransf??false)
      {
        if ((bEValorTipoNota.limiteSuperiorTransf??0) >= (nota??0))
        {
          valorSuperior = true;
        }
      }
      else
      {
        if ((bEValorTipoNota.limiteSuperiorTransf??0) >  (nota??0))
        {
          valorSuperior = true;
        }
      }

      if (bEValorTipoNota.incluidoLInferiorTransf??false)
      {
        if ((bEValorTipoNota.limiteInferiorTransf??0) <=  (nota??0))
        {
          valorInferior = true;
        }
      }
      else
      {
        if ((bEValorTipoNota.limiteInferiorTransf??0) <  (nota??0))
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

    return result;
  }

  static ValorTipoNotaUi? getValorTipoNota(TipoNotaUi? bETipoNota, double? nota)
  {
    //log.Info(string.Format("getValorTipoNotaCalculado: bETipoNota: id{0}, nombre:{1}, intervalo{2}", bETipoNota.TipoNotaId, bETipoNota.Nombre, bETipoNota.Intervalo));
    nota = nota!=null?DomainTools.roundDouble(nota,0):null;
    ValorTipoNotaUi? result = null;
    if (bETipoNota?.intervalo??false)
    {
      for (ValorTipoNotaUi bEValorTipoNota in bETipoNota?.valorTipoNotaList??[])
      {
        bool valorInferior = false;
        bool valorSuperior = false;

        if (bEValorTipoNota.incluidoLSuperior??false)
        {
          if ((bEValorTipoNota.limiteSuperior??0) >= (nota??0))
          {
            valorSuperior = true;
          }
        }
        else
        {
          if ((bEValorTipoNota.limiteSuperior??0) > (nota??0))
          {
            valorSuperior = true;
          }
        }

        if (bEValorTipoNota.incluidoLInferior??false)
        {
          if ((bEValorTipoNota.limiteInferior??0) <= (nota??0))
          {
            valorInferior = true;
          }
        }
        else
        {
          if ((bEValorTipoNota.limiteInferior??0) < (nota??0))
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

      int? notaEntera = nota!=null?DomainTools.roundDouble(nota,0).toInt():null;
      if ((bETipoNota?.valorTipoNotaList?.length??0 )== 2)
      {
        int valorintermedio = ((bETipoNota?.escalavalorMaximo??0)  + (bETipoNota?.escalavalorMinimo??0) / 2).round();

        List<ValorTipoNotaUi> vlst_valoresOrdenados = []..addAll(bETipoNota?.valorTipoNotaList??[]);
        vlst_valoresOrdenados.sort((o1, o2) =>  (o1.valorNumerico??0).compareTo(o2.valorNumerico??0));

        if (valorintermedio >= (notaEntera??0))
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