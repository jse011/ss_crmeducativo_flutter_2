
import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';

class ValidarUsuario extends UseCase<ValidarUsuarioCaseResponse, ValidarUsuarioCaseParams> {
  ConfiguracionRepository repository;


  ValidarUsuario(this.repository);

  @override
  Future<Stream<ValidarUsuarioCaseResponse?>> buildUseCaseStream(ValidarUsuarioCaseParams? params) async{
    final controller = StreamController<ValidarUsuarioCaseResponse>();
    try {
      // Adding it triggers the .onNext() in the `Observer`
      // It is usually better to wrap the reponse inside a respose object.
      if(!await this.repository.validarUsuario())throw Exception("Error validar el usuario");

      controller.add(ValidarUsuarioCaseResponse());
      logger.finest('ValidarUsuario successful.');
      controller.close();
    } catch (e) {
      logger.severe('ValidarUsuario unsuccessful: ' + e.toString());
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }



}
/// Wrapping params inside an object makes it easier to change later
class ValidarUsuarioCaseParams {
  ValidarUsuarioCaseParams();

}

/// Wrapping response inside an object makes it easier to change later
class ValidarUsuarioCaseResponse {

}