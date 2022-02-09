import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/cerrar_session.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_server_icon.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_usuario.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_contacto_docente.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_usuario.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/validar_usuario.dart';

class HomePresenter extends Presenter{
  late Function getUserOnNext, getUserOnComplete, getUserOnError;
  late Function getUpdateUserOnNext, getUpdateUserOnError;
  GetSessionUsuarioCase getSessionUsuario;
  late Function validarUsuarioOnError, validarUsuarioOnComplete;
  ValidarUsuario _validarUsuario;
  late Function cerrarCesionOnError, cerrarCesionOnComplete;
  UpdateContactoDocente _updateContactoDocente;
  late Function updateContactoDocenteoOnError, updateContactoDocenteOnComplete;
  UpdateUsuario _updateUsuario;
  late Function updateUsuarioOnError, updateUsuarioOnComplete;
  CerrarSession _cerrarSession;
  GetServerIcono _getServerIcono;

  HomePresenter(ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo)
      :  _validarUsuario = ValidarUsuario(configuracionRepo), getSessionUsuario = new GetSessionUsuarioCase(configuracionRepo),
        _updateContactoDocente = UpdateContactoDocente(configuracionRepo, httpDatosRepo),
        _getServerIcono = GetServerIcono(configuracionRepo),
        _cerrarSession = CerrarSession(configuracionRepo),
        _updateUsuario = UpdateUsuario(configuracionRepo, httpDatosRepo);

  @override
  void dispose() {
    getSessionUsuario.dispose();
    _validarUsuario.dispose();
    _updateContactoDocente.dispose();
    _updateUsuario.dispose();
  }


  void validarUsuario(){
    _validarUsuario.execute(_ValidarUsuarioUseCase(this), ValidarUsuarioCaseParams());
  }

  void getUserSession(bool update) {
    getSessionUsuario.execute(_GetSessionUsuarioCase(this, update), GetSessionUsuarioCaseParams());
  }

  void updateContactoDocente(){
    _updateContactoDocente.execute(_UpdateContactoDocenteCase(this), UpdateContactoDocenteParams());
  }

  void updateUsuario(){
    _updateUsuario.execute(_UpdateUsuarioCase(this), UpdateUsuarioParams());
  }

  Future<bool> cerrarCesion() {
    return _cerrarSession.execute();
  }

  Future<String?> getIconoServidor() => _getServerIcono.execute();

}

class _ValidarUsuarioUseCase extends Observer<ValidarUsuarioCaseResponse>{
  final HomePresenter presenter;

  _ValidarUsuarioUseCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.validarUsuarioOnComplete != null);
    presenter.validarUsuarioOnComplete();
  }

  @override
  void onError(e) {
    print("HomeView Error");
    assert(presenter.validarUsuarioOnError != null);
    presenter.validarUsuarioOnError(e);
  }

  @override
  void onNext(ValidarUsuarioCaseResponse? response) {

  }

}

class _GetSessionUsuarioCase extends Observer<GetSessionUsuarioCaseResponse>{
  final HomePresenter presenter;
  final bool update;
  _GetSessionUsuarioCase(this.presenter, this.update);

  @override
  void onComplete() {
    assert(presenter.getUserOnComplete != null);
    presenter.getUserOnComplete();
  }

  @override
  void onError(e) {
    if(update){
      assert(presenter.getUpdateUserOnError != null);
      presenter.getUpdateUserOnError(e);
    }else{
      assert(presenter.getUserOnError != null);
      presenter.getUserOnError(e);
    }

  }

  @override
  void onNext(GetSessionUsuarioCaseResponse? response) {
    if(update){
      assert(presenter.getUpdateUserOnNext != null);
      presenter.getUpdateUserOnNext(response?.usuario);
    }else{
      assert(presenter.getUserOnNext != null);
      presenter.getUserOnNext(response?.usuario);
    }
  }

}
class _UpdateContactoDocenteCase extends Observer<UpdateContactoDocenteResponse>{
  final HomePresenter presenter;

  _UpdateContactoDocenteCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.updateContactoDocenteoOnError!=null);
    presenter.updateContactoDocenteoOnError(e);
  }

  @override
  void onNext(UpdateContactoDocenteResponse? response) {
    assert(presenter.updateContactoDocenteOnComplete!=null);
    presenter.updateContactoDocenteOnComplete(response?.datosOffline, response?.errorServidor);
  }

}
class _UpdateUsuarioCase extends Observer<UpdateUsuarioResponse>{
  final HomePresenter presenter;

  _UpdateUsuarioCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.updateUsuarioOnError!=null);
    presenter.updateUsuarioOnError(e);
  }

  @override
  void onNext(UpdateUsuarioResponse? response) {
    assert(presenter.updateUsuarioOnComplete!=null);
    presenter.updateUsuarioOnComplete(response?.datosOffline, response?.errorServidor);
  }

}