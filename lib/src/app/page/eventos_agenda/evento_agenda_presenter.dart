import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_evento_agenda.dart';

class EventoAgendaPresenter extends Presenter{

  GetEventoAgenda _getEventoAgenda;
  late Function getEventoAgendaOnNext, getEventoAgendaOnError;

  EventoAgendaPresenter(HttpDatosRepository httpRepo, ConfiguracionRepository configuracionRepo, AgendaEventoRepository agendaEventoRepo):
        this._getEventoAgenda = GetEventoAgenda(agendaEventoRepo, configuracionRepo, httpRepo);

  void getEventoAgenda(TipoEventoUi? tipoEventoUi){
    _getEventoAgenda.execute(_GetEventoAgendaCase(this), GetEventoAgendaParams(tipoEventoUi?.id));
  }

  void onInitState() {
    getEventoAgenda(null);
  }

  @override
  void dispose() {
    _getEventoAgenda.dispose();
  }

}

class _GetEventoAgendaCase extends Observer<GetEvaluacionCaseResponse>{
  final EventoAgendaPresenter presenter;

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

