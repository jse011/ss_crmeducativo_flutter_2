import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/login.dart';

class LoginPresenter extends Presenter{

  Login _login;
  late Function loginOnComplete, loginOnNextValidate, loginOnError, loginOnNextDatos;
  LoginPresenter(HttpRepo, UsuarioConfRepo):this._login = Login(HttpRepo, UsuarioConfRepo);


  void login(String usuario, String contrasenia, String dni, String correo){
    _login.execute(_LoginUseCase(this), LoginParams(usuario: usuario, password: contrasenia, dni: dni, correo: correo));
  }


  @override
  void dispose() {
    _login.dispose();
  }

}

class _LoginUseCase extends Observer<LoginResponse>{
  final LoginPresenter presenter;

  _LoginUseCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.loginOnComplete != null);
    presenter.loginOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.loginOnError != null);
    presenter.loginOnError(e);
  }

  @override
  void onNext(LoginResponse? response) {

    if(response is LoginResponseValidate){
      assert(presenter.loginOnNextValidate != null);
      presenter.loginOnNextValidate(response.loginUi, response.errorServidor);
    }else if(response is LoginResponseDatos){
      presenter.loginOnNextDatos(response.errorServidor, response.rolValidado);
    }

  }

}