import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/programa_educativo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class UpdateContactoDocente extends UseCase<UpdateContactoDocenteResponse, UpdateContactoDocenteParams> {

  HttpDatosRepository httpDatosRepo;
  ConfiguracionRepository repository;

  UpdateContactoDocente(this.repository, this.httpDatosRepo);

  @override
  Future<Stream<UpdateContactoDocenteResponse?>> buildUseCaseStream(
      UpdateContactoDocenteParams? params) async {
    final controller = StreamController<UpdateContactoDocenteResponse>();

    try {
      int empleadoId = await repository.getSessionEmpleadoId();
      int anioAcademicoIdSelect = await repository.getSessionAnioAcademicoId();
      String urlServidorLocal = await repository.getSessionUsuarioUrlServidor();


      Future<void> executeDatos() async {
        bool offlineServidor = false;
        bool errorServidor = false;

        try {

          Map<String, dynamic>? contactoDocente = await httpDatosRepo.getContactoDocente(urlServidorLocal, empleadoId, anioAcademicoIdSelect);
          errorServidor = contactoDocente == null;

          if (!errorServidor) {
            await repository.saveContactoDocente(contactoDocente, empleadoId, anioAcademicoIdSelect);
          }
        } catch (e) {
          offlineServidor = true;
        }
        
        controller.add(UpdateContactoDocenteResponse(offlineServidor, errorServidor));

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


class UpdateContactoDocenteParams {

}
class UpdateContactoDocenteResponse{
  bool datosOffline;
  bool errorServidor;

  UpdateContactoDocenteResponse(
      this.datosOffline, this.errorServidor);
}
