import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';

class GetSessionUsuarioCase extends UseCase<GetSessionUsuarioCaseResponse, GetSessionUsuarioCaseParams>{
  final ConfiguracionRepository repository;

  GetSessionUsuarioCase(this.repository);

  @override
  Future<Stream<GetSessionUsuarioCaseResponse?>> buildUseCaseStream(
      GetSessionUsuarioCaseParams? params) async {
    final controller = StreamController<GetSessionUsuarioCaseResponse>();

    try {
      // get user
      final usuarioUi = await repository.getSessionUsuario();
      // Adding it triggers the .onNext() in the `Observer`
      // It is usually better to wrap the reponse inside a respose object.
      controller.add(GetSessionUsuarioCaseResponse(usuarioUi));
      logger.finest('GetUserUseCase successful.');
      controller.close();
    } catch (e) {
      logger.severe('GetUserUseCase unsuccessful: ' + e.toString());
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

}

/// Wrapping params inside an object makes it easier to change later
class GetSessionUsuarioCaseParams {

}

/// Wrapping response inside an object makes it easier to change later
class GetSessionUsuarioCaseResponse {
  final UsuarioUi usuario;
  GetSessionUsuarioCaseResponse(this.usuario);
}