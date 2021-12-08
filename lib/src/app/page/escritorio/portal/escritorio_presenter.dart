import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_sesion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_sesiones_hoy.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_usuario.dart';

class EscritorioPresenter extends Presenter{

  late Function getUserOnNext, getUserOnComplete, getUserOnError;
  GetSessionUsuarioCase _getSessionUsuario;

  GetSesionesHoy _getSesionesHoy;
  late Function getSesionesHoyOnSuccess, getSesionesHoyOnError;

  EscritorioPresenter(ConfiguracionRepository  configuracionRepository, HttpDatosRepository httpRepository, UnidadSesionRepository unidadSesionRepository):
        _getSesionesHoy = GetSesionesHoy(configuracionRepository, httpRepository, unidadSesionRepository),
        _getSessionUsuario = new GetSessionUsuarioCase(configuracionRepository);

  void getSesionesHoy(){
    _getSesionesHoy.execute(_GetSesionesHoyCase(this), GetSesionesHoyParams());
  }

  void getUsuario(){
    _getSessionUsuario.execute(_GetSessionUsuarioCase(this), GetSessionUsuarioCaseParams());
  }

  @override
  void dispose() {
    _getSesionesHoy.dispose();
    _getSessionUsuario.dispose();
  }

}


class _GetSesionesHoyCase extends Observer<GetSesionesHoyResponse>{
  EscritorioPresenter presenter;

  _GetSesionesHoyCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getSesionesHoyOnError!=null);
    presenter.getSesionesHoyOnError(e);
  }

  @override
  void onNext(GetSesionesHoyResponse? response) {
    print("getInformacionTareaOnComplete");
    assert(presenter.getSesionesHoyOnSuccess!=null);
    presenter.getSesionesHoyOnSuccess(response?.datosOffline, response?.errorServidor, response?.sesionHoyUiList);
  }

}

class _GetSessionUsuarioCase extends Observer<GetSessionUsuarioCaseResponse>{
  final EscritorioPresenter presenter;

  _GetSessionUsuarioCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getUserOnComplete != null);
    presenter.getUserOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getUserOnError != null);
    presenter.getUserOnError(e);
  }

  @override
  void onNext(GetSessionUsuarioCaseResponse? response) {
    assert(presenter.getUserOnNext != null);
    presenter.getUserOnNext(response?.usuario);
  }

}