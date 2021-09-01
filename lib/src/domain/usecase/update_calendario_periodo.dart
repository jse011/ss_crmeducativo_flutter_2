import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class UpdateCalendarioPerido extends UseCase<GetCalendarioPeridoResponse, GetCalendarioPeridoParams>{
  ConfiguracionRepository configuracionRepository;
  CalendarioPeriodoRepository repository;
  HttpDatosRepository httpDatosRepo;


  UpdateCalendarioPerido(this.configuracionRepository, this.repository, this.httpDatosRepo);

  @override
  Future<Stream<GetCalendarioPeridoResponse?>> buildUseCaseStream(GetCalendarioPeridoParams? params) async{
    final controller = StreamController<GetCalendarioPeridoResponse>();
    try {
      String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
      int anioAcademicoIdSelect = await configuracionRepository.getSessionAnioAcademicoId();
      int programaEducativoIdSelect = await configuracionRepository.getSessionProgramaEducativoId();

      Future<void> executeDatos() async {
        bool offlineServidor = false;
        bool errorServidor = false;

        try {

          List<dynamic>? calendarioPeriodoList = await httpDatosRepo.getCalendarioPeriodoCursoFlutter(urlServidorLocal, anioAcademicoIdSelect, programaEducativoIdSelect, params?.cargaCursoId??0);
          errorServidor = calendarioPeriodoList == null;

          if (!errorServidor) {
            await repository.saveCalendarioPeriodoCursoFlutter(calendarioPeriodoList, urlServidorLocal, anioAcademicoIdSelect, programaEducativoIdSelect, params?.cargaCursoId??0);
          }
        } catch (e) {
          offlineServidor = true;
        }
        await getCalendarioPerido(controller, anioAcademicoIdSelect, programaEducativoIdSelect, params?.cargaCursoId??0, errorServidor, offlineServidor);
        controller.close();
        logger.finest('GetCalendarioPeridoResponse successful. ');
      }

      executeDatos().catchError((e) {
        controller.addError(e);
      });

      // Adding it triggers the .onNext() in the `Observer`
      // It is usually better to wrap the reponse inside a respose object.


    } catch (e) {
      logger.severe('GetCalendarioPeridoResponse unsuccessful: ' + e.toString());
      // Trigger .onError
      controller.addError(e);
    }

    return controller.stream;
  }

  Future<void> getCalendarioPerido(StreamController<GetCalendarioPeridoResponse> controller,int anioAcademicoId, int programaEducativoId, int cargaCursoId,bool errorServidor, bool offlineServidor) async{
    CalendarioPeriodoUI? calendarioPeriodoUI = null;

    final List<CalendarioPeriodoUI> calendarioPeriodoList = await repository.getCalendarioPerios(programaEducativoId, cargaCursoId, anioAcademicoId);


    for(CalendarioPeriodoUI item in calendarioPeriodoList){
      if((item.habilitado??0)==1){
        calendarioPeriodoUI = item;
      }
    }

    calendarioPeriodoUI?.selected = true;

    controller.add(GetCalendarioPeridoResponse(calendarioPeriodoList, calendarioPeriodoUI, offlineServidor, errorServidor));
  }

}
class GetCalendarioPeridoResponse{
  List<CalendarioPeriodoUI> calendarioPeriodoList;
  CalendarioPeriodoUI? calendarioPeriodoUI;
  bool offlineServidor;
  bool errorServidor;

  GetCalendarioPeridoResponse(this.calendarioPeriodoList,
      this.calendarioPeriodoUI, this.offlineServidor, this.errorServidor);
}
class GetCalendarioPeridoParams{
  int cargaCursoId;

  GetCalendarioPeridoParams(this.cargaCursoId);
}