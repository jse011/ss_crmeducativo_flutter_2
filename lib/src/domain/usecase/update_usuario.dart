import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class UpdateUsuario extends UseCase<UpdateUsuarioResponse, UpdateUsuarioParams> {

  HttpDatosRepository httpDatosRepo;
  ConfiguracionRepository repository;

  UpdateUsuario(this.repository, this.httpDatosRepo);

  @override
  Future<Stream<UpdateUsuarioResponse?>> buildUseCaseStream(
      UpdateUsuarioParams? params) async {
    final controller = StreamController<UpdateUsuarioResponse>();

    try {
      int usuarioId = await repository.getSessionUsuarioId();
      String urlServidorLocal = await repository.getSessionUsuarioUrlServidor();


      Future<void> executeDatos() async {
        bool offlineServidor = false;
        bool errorServidor = false;

        try {

          Map<String, dynamic>? usuarioJson = await httpDatosRepo.updateUsuario(urlServidorLocal, usuarioId);
          errorServidor = usuarioJson == null;
          if (!errorServidor) {
           await repository.udpateUsuario(usuarioId, usuarioJson);
          }
        } catch (e) {
          offlineServidor = true;
        }
        
        controller.add(UpdateUsuarioResponse(offlineServidor, errorServidor));

        controller.close();
      }


      executeDatos().catchError((e) {
        controller.addError(e);
      });

    } catch (e) {
      logger.severe('EventoAgenda unsuccessful: '+e.toString());
      controller.addError(e);
    }

    return controller.stream;
  }

}


class UpdateUsuarioParams {

}
class UpdateUsuarioResponse{
  bool datosOffline;
  bool errorServidor;

  UpdateUsuarioResponse(
      this.datosOffline, this.errorServidor);
}
