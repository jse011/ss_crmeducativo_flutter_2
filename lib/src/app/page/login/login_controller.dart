import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/login_ui.dart';

import 'login_presenter.dart';

class LoginController extends Controller{
  bool _ocultarContrasenia = true;
  String? _mensaje = null;
  String _usuario = "";
  bool _correoValidate = false;
  String get usuario => _usuario;
  String _password = "";
  String get password => _password;
  String _dni = "";
  String get dni => _dni;
  String _correo = "";
  String get correo => _correo;


  String? get mensaje => _mensaje;
  bool _dismis = false;
  bool get dismis => _dismis;
  bool _progress = false;
  bool get progress => _progress;
  LoginUi? _loginUi = null;
  bool get ocultarContrasenia => _ocultarContrasenia;

  bool _progressData = false;
  bool get progressData => _progressData;

  LoginPresenter presenter;
  LoginTypeView _typeView = LoginTypeView.USUARIO;
  LoginTypeView get typeView => _typeView;
  LoginController(HttpRepo, UsuarioConfRepo):this.presenter = LoginPresenter(HttpRepo, UsuarioConfRepo);

  @override
  void initListeners() {
    presenter.loginOnNextValidate = (LoginUi loginUi, bool errorServidor){
      _loginUi = loginUi;

      _mensaje = null;
      if(errorServidor){
        _mensaje = "!Oops! Al parecer ocurrió un error involuntario.";
      }else{
        if(_loginUi == LoginUi.INVALIDO){
          if(typeView == LoginTypeView.USUARIO){
            _mensaje = "Credenciales incorrectos";
          }else if(typeView == LoginTypeView.CORREO){
            _mensaje = "Ingresar su correo electrónico";
          }else{
            _mensaje = "Correo electrónico incorrecto";
          }

        }else if(_loginUi == LoginUi.DUPLICADO){
          if(typeView == LoginTypeView.USUARIO){
            _typeView = LoginTypeView.CORREO;
          }else if(typeView == LoginTypeView.CORREO){
            _typeView = LoginTypeView.DNI;
          }
        }else if(_loginUi == LoginUi.SUCCESS){
          //_dismis = true;
         _progressData = true;
        }
      }
      _progress = false;
      refreshUI();
    };

    presenter.loginOnNextDatos = (bool errorServidor, bool rolValidado){
      if(errorServidor){
        _mensaje = "!Oops! Al parecer ocurrió un error involuntario.";
        //_typeView = LoginTypeView.USUARIO;
        _progressData = false;
      }else{
        if(rolValidado){
          _dismis = true;
        }else{
          _progressData = false;
          _mensaje = "Usuario sin acceso";
        }
      }

      refreshUI();
    };

    presenter.loginOnComplete = (){


    };

    presenter.loginOnError = (e){
      _loginUi = null;
      _progress = false;
      _progressData = false;
      _mensaje = "No hay Conexión a Internet...";
      refreshUI();
    };
  }

  void onClikMostarContrasenia() {
    _ocultarContrasenia = !_ocultarContrasenia;
    refreshUI();
  }

  void onClikAtrasLogin() {
    if(typeView == LoginTypeView.DNI){
      _typeView = LoginTypeView.USUARIO;
    }else if(typeView == LoginTypeView.CORREO){
      _typeView = LoginTypeView.DNI;
    }else{
      _typeView = LoginTypeView.USUARIO;
    }
    refreshUI();
  }

  void onClickInciarSesion() {
    if(_typeView == LoginTypeView.USUARIO){
      if(_vailidarUsuario()){
        _mensaje = "Ingresar usuario";
        refreshUI();
        return;
      }
      if(_vailidarPassword()!=null){
        _mensaje = _vailidarPassword();
        refreshUI();
        return;
      }
      _progress = true;
      refreshUI();
      presenter.login(_usuario, _password, "", "");
    }else if(_typeView == LoginTypeView.DNI){
      if(_vailidarDNI()){
        _mensaje = "Documento Incorrecto";
        refreshUI();
        return;
      }
      _progress = true;
      refreshUI();
      presenter.login(_usuario, _password, _dni, "");

    }else if(_typeView == LoginTypeView.CORREO){
      if(_vailidarCorreo()!=null){
        _mensaje = _vailidarCorreo();
        refreshUI();
        return;
      }
      _progress = true;
      refreshUI();
      presenter.login(_usuario, _password, _dni, _correo);
    }

  }

  bool _vailidarUsuario(){
    return _usuario==null||_usuario.isEmpty;
  }

  String? _vailidarPassword(){
    //return _password==null || _password.length < 3;
    String? mensaje = null;
    if(_password==null||_password.isEmpty){
      mensaje = "Ingresar contraseña";
    }else if( _password.length < 3){
      mensaje = "Contraseña demasiado corta";
    }

    return mensaje;
  }

  bool _vailidarDNI(){
    return _dni==null||_dni.isEmpty;
  }

  String? _vailidarCorreo(){
    String? mensaje = null;
    if(_dni==null||_dni.isEmpty){
      mensaje = "Ingresar su correo electrónico";
    }else if(!_correoValidate){
      mensaje = "Correo electrónico incorrecto";
    }

    return mensaje;
  }

  void onChangeUsuario(String str) {
    _usuario = str;
  }

  void onChangeContrasenia(String str) {
    _password = str;
  }

  void onChangeDni(String str) {
    _dni = str;
  }

  void onChangeCorreo(String str) {
    _correo = str;
  }

  void successMsg() {
    _mensaje = null;
  }

  void onValidatorCorreo(bool validate) {
    _correoValidate = validate;
  }

}

enum LoginTypeView{
  USUARIO,
  DNI,
  CORREO,
}