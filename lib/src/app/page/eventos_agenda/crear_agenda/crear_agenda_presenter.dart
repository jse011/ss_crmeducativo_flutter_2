import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_adjunto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_listas_envio_agenda.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/save_evento_docente.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/upload_file_agenda.dart';

class CrearAgendaPresenter extends Presenter{

  GetListaEnvioAgenda _getAlumnos;
  late Function getAlumnosOnError, getAlumnosOnResponse;
  UploadFileAgenda _uploadFileAgenda;
  late Function getCalendarioPeridoOnSucces, getCalendarioPeridoOnProgress;
  SaveEventoDocente _saveEventoDocente;
  late Function saveEventoOnMessage;

  CrearAgendaPresenter(ConfiguracionRepository configuracionRepo, AgendaEventoRepository agendaEventoRepo,HttpDatosRepository httpDatosRepo):
        _getAlumnos = GetListaEnvioAgenda(agendaEventoRepo, configuracionRepo),
        _uploadFileAgenda = UploadFileAgenda(configuracionRepo, httpDatosRepo),
        _saveEventoDocente = SaveEventoDocente(httpDatosRepo, configuracionRepo, agendaEventoRepo);

  void getAlumnos(EventoUi? eventoUi){
    _getAlumnos.execute(_GetAlumnoCase(this), GetListaEnvioAgendaParams(eventoUi?.id));
  }

  @override
  void dispose() {
    _getAlumnos.dispose();
  }


  Future<HttpStream?> uploadEventoAdjuntoUi(EventoUi? eventoUi, EventoAdjuntoUi? eventoAdjuntoUi) async{
    return _uploadFileAgenda.execute(eventoAdjuntoUi,  (progress){
      getCalendarioPeridoOnProgress( progress, eventoAdjuntoUi);
    },(success){
      getCalendarioPeridoOnSucces(success, eventoAdjuntoUi);
    });
  }

  Future<bool> saveAgendaDocente(EventoUi? eventoUi, bool update) async{
    print("update: ${update}");
    var response = await _saveEventoDocente.execute(eventoUi, update);
    saveEventoOnMessage(response.offline);
    return response.success??false;
  }


}

class _GetAlumnoCase extends Observer<GetListaEnvioAgendaResponse> {
  CrearAgendaPresenter presenter;

  _GetAlumnoCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getAlumnosOnError != null);
    presenter.getAlumnosOnError(e);
  }

  @override
  void onNext(GetListaEnvioAgendaResponse? response) {
    assert(presenter.getAlumnosOnResponse != null);
    presenter.getAlumnosOnResponse(response?.alumnoCursoList);
  }

}