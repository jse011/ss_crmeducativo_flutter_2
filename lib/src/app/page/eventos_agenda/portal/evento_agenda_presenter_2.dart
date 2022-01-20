import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/change_estado_evento_docente.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_evento_agenda.dart';

class EventoAgendaPresenter2 extends Presenter{

  GetEventoAgenda _getEventoAgenda;
  late Function getEventoAgendaOnNext, getEventoAgendaOnError;
  ChangeEstadoEventoDocente _changeEstadoEventoDocente;

  EventoAgendaPresenter2(HttpDatosRepository httpRepo, ConfiguracionRepository configuracionRepo, AgendaEventoRepository agendaEventoRepo):
        this._getEventoAgenda = GetEventoAgenda(agendaEventoRepo, configuracionRepo, httpRepo),
        this._changeEstadoEventoDocente = ChangeEstadoEventoDocente(httpRepo, configuracionRepo, agendaEventoRepo);

  void getEventoAgenda(TipoEventoUi? tipoEventoUi, bool traerTipos){
    _getEventoAgenda.execute(_GetEventoAgendaCase(this), GetEventoAgendaParams(tipoEventoUi?.id, traerTipos, null));
  }


  @override
  void dispose() {
    _getEventoAgenda.dispose();
  }

  Future<bool?> eliminarEvento(EventoUi? eventoUi) {
    eventoUi?.estadoId = AgendaEventoRepository.ESTADO_ELIMINADO;
    eventoUi?.publicado = false;
    return _changeEstadoEventoDocente.execute(eventoUi);
  }

  Future<bool?> publicadoEvento(EventoUi? eventoUi) async{
    eventoUi?.estadoId = AgendaEventoRepository.ESTADO_ACTUALIZADO;
    eventoUi?.publicado = !(eventoUi.publicado??false);

    bool?  respuesta = await _changeEstadoEventoDocente.execute(eventoUi);
    if(!(respuesta??false)){
      eventoUi?.publicado = !(eventoUi.publicado??false);//reaser
    }
  }

}

class _GetEventoAgendaCase extends Observer<GetEvaluacionCaseResponse>{
  final EventoAgendaPresenter2 presenter;

  _GetEventoAgendaCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getEventoAgendaOnError != null);
    presenter.getEventoAgendaOnError(e);
  }

  @override
  void onNext(GetEvaluacionCaseResponse? response) {
    assert(presenter.getEventoAgendaOnNext != null);
    print("tipoEventoUiList size: " + (response?.tipoEventoUiList.length??0).toString());
    presenter.getEventoAgendaOnNext(response?.tipoEventoUiList, response?.eventoUiList, response?.errorServidor, response?.datosOffline);
  }

}

