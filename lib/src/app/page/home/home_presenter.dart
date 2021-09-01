import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_usuario.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_contacto_docente.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/validar_usuario.dart';

class HomePresenter extends Presenter{
  late Function getUserOnNext, getUserOnComplete, getUserOnError;
  GetSessionUsuarioCase getSessionUsuario;
  late Function validarUsuarioOnError, validarUsuarioOnComplete;
  ValidarUsuario _validarUsuario;
  late Function cerrarCesionOnError, cerrarCesionOnComplete;
  UpdateContactoDocente _updateContactoDocente;

  HomePresenter(ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo)
      :  _validarUsuario = ValidarUsuario(configuracionRepo), getSessionUsuario = new GetSessionUsuarioCase(configuracionRepo),
        _updateContactoDocente = UpdateContactoDocente(configuracionRepo, httpDatosRepo);

  @override
  void dispose() {
    getSessionUsuario.dispose();
    _validarUsuario.dispose();
    _updateContactoDocente.dispose();
  }


  void validarUsuario(){
    _validarUsuario.execute(_ValidarUsuarioUseCase(this), ValidarUsuarioCaseParams());
  }

  void getUserSession() {
    getSessionUsuario.execute(_GetSessionUsuarioCase(this), GetSessionUsuarioCaseParams());
  }

  void updateContactoDocente(){
    _updateContactoDocente.execute(_UpdateContactoDocenteCase(this), UpdateContactoDocenteParams());
  }


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
class _UpdateContactoDocenteCase extends Observer<UpdateContactoDocenteResponse>{
  final HomePresenter presenter;

  _UpdateContactoDocenteCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {

  }

  @override
  void onNext(UpdateContactoDocenteResponse? response) {

  }

}