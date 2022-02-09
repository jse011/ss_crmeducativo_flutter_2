import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';

class GetEventoAgenda extends UseCase<GetEvaluacionCaseResponse, GetEventoAgendaParams>{
  AgendaEventoRepository agendaRepository;
  ConfiguracionRepository  configuracionRepository;
  HttpDatosRepository httpRepository;
  SingletonEventos _singletonEventos;

  GetEventoAgenda(
      this.agendaRepository, this.configuracionRepository, this.httpRepository):
        _singletonEventos = SingletonEventos();

  @override
  Future<Stream<GetEvaluacionCaseResponse?>> buildUseCaseStream(GetEventoAgendaParams? params) async{
    final controller = StreamController<GetEvaluacionCaseResponse>();
    try {
      if(params?.traerTipos??false){
        List<TipoEventoUi> tiposUiList = await agendaRepository.getTiposEvento();
        print("tipoEventoUiList size: " + tiposUiList.length.toString());
        for(TipoEventoUi tipoEventoUi in tiposUiList)tipoEventoUi.disable = false;
        controller.add(GetEvaluacionCaseResponse(tiposUiList, null, false, false));
      }

      int georeferenciaId =  await configuracionRepository.getGeoreferenciaId();
      int usuarioId = await configuracionRepository.getSessionUsuarioId();
       executeServidor() async{
        bool offlineServidor = false;
        bool errorServidor = false;
        try{
          String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
          Map<String, dynamic>? eventoAgenda = await httpRepository.getEventoAgenda(urlServidorLocal, usuarioId,  georeferenciaId,  params?.tipoEventoId??0);
          errorServidor = eventoAgenda==null;
          if(!errorServidor){
            await agendaRepository.saveEventoAgenda(eventoAgenda, usuarioId, georeferenciaId, params?.tipoEventoId??0);
            _singletonEventos.cargando = false;
          }
        }catch(e){
          offlineServidor = true;
        }

        List<TipoEventoUi> tiposUiList = await agendaRepository.getTiposEvento();
        print("tipoEventoUiList jse size: " + tiposUiList.length.toString());
        for(TipoEventoUi tipoEventoUi in tiposUiList)tipoEventoUi.disable = false;

        List<EventoUi> eventoUIList = await getEventos(usuarioId, georeferenciaId, params?.tipoEventoId, params?.cargaCursoId);

        controller.add(GetEvaluacionCaseResponse(tiposUiList, eventoUIList, errorServidor, offlineServidor));
        controller.close();
      }

      executeServidor().catchError((e) {
        controller.addError(e);
        // Finally, callback fires.
        // throw Exception(e);              // Future completes with 42.
      });

    } catch (e) {
      logger.severe('EventoAgenda unsuccessful: '+e.toString());
      // Trigger .onError
      controller.addError(e);

    }
    return controller.stream;
  }


  Future<List<EventoUi>> getEventos(int? usuarioId,int? georeferenciaId, int? tipoEventoId, int? cargaCursoId) async{

    List<EventoUi> eventoUIList = await agendaRepository.getEventosAgenda(usuarioId??0, georeferenciaId??0, tipoEventoId??0,cargaCursoId??0);

    eventoUIList.sort((o1, o2){

      DateTime? date1 = (o1.tipoEventoUi?.tipo == EventoIconoEnumUI.AGENDA)? o1.fecaCreacion : o1.fechaPublicacion;
      if((date1?.year??0)<2000) date1= o1.fechaPublicacion;

      DateTime? date2 = (o2.tipoEventoUi?.tipo == EventoIconoEnumUI.AGENDA)? o2.fecaCreacion : o2.fechaPublicacion;
      if((date2?.year??0)<2000) date2= o2.fechaPublicacion;

      return date2?.compareTo(date1??DateTime(1995))??0;

    });


    for(var eventosUi in eventoUIList){
      DateTime fechaEntrega =  eventosUi.fecha??DateTime(1950);
      if(fechaEntrega.millisecondsSinceEpoch>912402000000){
        switch (eventosUi.tipoEventoUi?.tipo??EventoIconoEnumUI.EVENTO){
          case EventoIconoEnumUI.EVENTO:
            eventosUi.nombreFecha = DomainTools.tiempoFechaCreacionAgenda(eventosUi.fecha);
            break;
          case EventoIconoEnumUI.NOTICIA:
            eventosUi.nombreFecha = DomainTools.getFechaDiaMesAnho(eventosUi.fecha);
            break;
          default:
            eventosUi.nombreFecha = DomainTools.tiempoFechaCreacionAgenda(eventosUi.fecha);
            break;
        }
      }else{
        eventosUi.nombreFecha = "";
      }

      if((eventosUi.fechaEvento?.millisecondsSinceEpoch??0)<=912402000000){
        eventosUi.fechaEvento = null;
      }

      if((eventosUi.fechaPublicacion?.millisecondsSinceEpoch??0)>912402000000){
        eventosUi.nombreFechaPublicacion = DomainTools.f_fecha_letras(eventosUi.fechaPublicacion);
      }

    }
    return eventoUIList;
  }

}

class GetEventoAgendaParams {
  int? tipoEventoId;
  bool? traerTipos;
  int? cargaCursoId;
  GetEventoAgendaParams(this.tipoEventoId, this.traerTipos, this.cargaCursoId);
}

class GetEvaluacionCaseResponse {
  List<TipoEventoUi> tipoEventoUiList;
  bool datosOffline;
  List<EventoUi>? eventoUiList;
  bool errorServidor;

  GetEvaluacionCaseResponse(this.tipoEventoUiList, this.eventoUiList, this.errorServidor, this.datosOffline);
}

class SingletonEventos{
  static final SingletonEventos _singleton = SingletonEventos._internal();
  bool? cargando = false;

  factory SingletonEventos() {
    return _singleton;
  }

  SingletonEventos._internal();

}