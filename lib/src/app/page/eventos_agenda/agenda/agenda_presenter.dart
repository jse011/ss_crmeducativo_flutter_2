import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/change_estado_evento_docente.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_evento_agenda.dart';

class AgendaPresenter extends Presenter{
  GetEventoAgenda _getEventoAgenda;
  ChangeEstadoEventoDocente _changeEstadoEventoDocente;

  late Function getEventoAgendaOnNext, getEventoAgendaOnError;


  AgendaPresenter(AgendaEventoRepository agendaEventoRepo, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo):
        _getEventoAgenda = GetEventoAgenda(agendaEventoRepo, configuracionRepo, httpDatosRepo),
        _changeEstadoEventoDocente = ChangeEstadoEventoDocente(httpDatosRepo, configuracionRepo, agendaEventoRepo);

  void getEventoAgenda(){
    _getEventoAgenda.execute(_GetEventoAgendaCase(this), GetEventoAgendaParams(620, false));//620 = tipo Agenda
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

    return respuesta;
  }


}

class _GetEventoAgendaCase extends Observer<GetEvaluacionCaseResponse>{
  final AgendaPresenter presenter;

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