import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';

class ValidarNotaTeclado{

  ValidarNotaTecladoResponse execute(ValorTipoNotaUi? valorTipoNotaUi, double nota){
    if(!validarInclucionInferior(nota, valorTipoNotaUi?.limiteInferior, valorTipoNotaUi?.incluidoLInferior)){
      return ValidarNotaTecladoResponse(false);
    }else if(!validarInclucionSuperior(nota, valorTipoNotaUi?.limiteSuperior, valorTipoNotaUi?.incluidoLSuperior)){
      return ValidarNotaTecladoResponse(false);
    }else {
      return ValidarNotaTecladoResponse(true);
    }
  }

  bool validarInclucionInferior(double nota, double? limite, bool? limiteIncluido){
    if(limiteIncluido??false){
      if(nota >= (limite??0)){
        return  true;
      }else {
        return  false;
      }
    }else {
      if(nota > (limite??0)){
        return  true;
      }else {
        return  false;
      }
    }
  }

  bool validarInclucionSuperior(double nota, double? limite, bool? limiteIncluido){
    if(limiteIncluido??false){
      if(nota <= (limite??0)){
        return  true;
      }else {
        return  false;
      }
    }else {
      if(nota < (limite??0)){
        return  true;
      }else {
        return  false;
      }
    }
  }

}

class ValidarNotaTecladoResponse {
  bool? success;

  ValidarNotaTecladoResponse(this.success);
}