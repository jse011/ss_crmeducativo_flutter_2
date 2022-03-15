import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_lista_envio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';

class GetListaEnvioAgenda extends UseCase<GetListaEnvioAgendaResponse, GetListaEnvioAgendaParams>{

  AgendaEventoRepository repository;
  ConfiguracionRepository configuracionRepo;

  GetListaEnvioAgenda(this.repository, this.configuracionRepo);

  @override
  Future<Stream<GetListaEnvioAgendaResponse?>> buildUseCaseStream(GetListaEnvioAgendaParams? params)async {
    final controller = StreamController<GetListaEnvioAgendaResponse>();
    try{
      int empleadoId = await configuracionRepo.getSessionEmpleadoId();
      List<EventosListaEnvioUi> alumnoCursoList = [];
      if(params?.eventoId!=null){
        alumnoCursoList = await repository.getListaAlumnosSelecionado(empleadoId, params?.eventoId??"");
      }else{
        alumnoCursoList = await repository.getListaAlumnos(empleadoId);
      }

      for(EventosListaEnvioUi salonUi in alumnoCursoList){
        salonUi.personasUiList?.sort((o1, o2) => (o1.personaUi?.nombreCompleto??"").compareTo((o2.personaUi?.nombreCompleto??"")));
      }
      logger.severe('GetListaEnvioAgendaResponse alumnoCursoList: ${alumnoCursoList.length}');
      controller.add(GetListaEnvioAgendaResponse(alumnoCursoList));
      controller.close();
    } catch (e) {
      logger.severe('GetListaEnvioAgendaResponse unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;

  }

}

class GetListaEnvioAgendaParams{
  String? eventoId;

  GetListaEnvioAgendaParams(this.eventoId);
}

class GetListaEnvioAgendaResponse{
  List<EventosListaEnvioUi> alumnoCursoList;

  GetListaEnvioAgendaResponse(this.alumnoCursoList);
}
