import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';

import 'home_presenter.dart';

class HomeController extends Controller{
  final HomePresenter homePresenter;
  VistaIndex _vistaActual;
  UsuarioUi? _userioSession = null;
  UsuarioUi? get usuario => _userioSession; // data used by the View
  int _showLoggin = 0;// 0 cargando, 1 show Loggin, -1 nada
  int get showLoggin => _showLoggin;
  String? _logoApp = null;
  String? get logoApp => _logoApp;
  VistaIndex get vistaActual => _vistaActual;
  bool _conexion = true;
  bool get conexion => _conexion;

  HomeController(usuarioConfiRepo, httpDatosRepo)
      :  _vistaActual = VistaIndex.Principal,
        this.homePresenter = HomePresenter(usuarioConfiRepo, httpDatosRepo),
      super();

  @override
  // this is called automatically by the parent class
  void initListeners() {
    homePresenter.getUserOnNext = (UsuarioUi user) {
      _userioSession = user;
      homePresenter.updateUsuario();
      refreshUI(); // Refreshes the UI manually
    };

    homePresenter.getUserOnComplete = () {

    };

    // On error, show a snackbar, remove the user, and refresh the UI
    homePresenter.getUserOnError = (e) {
      print('Could not retrieve user.');
      _userioSession = null;
      refreshUI(); // Refreshes the UI manually
    };


    homePresenter.validarUsuarioOnComplete = () {
      homePresenter.getUserSession(false);
      _showLoggin = -1;
      print('HomeView validarUsuarioOnComplete');
      refreshUI();
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    homePresenter.validarUsuarioOnError = (e) {
      print('HomeView validarUsuarioOnError');
      _showLoggin = 1;
      refreshUI();
    };

    homePresenter.cerrarCesionOnComplete = (bool success){
      if(success){
        _showLoggin = 1;
        refreshUI();
      }
    };

    homePresenter.cerrarCesionOnError = (e){

    };

    homePresenter.updateUsuarioOnComplete = (bool? datosOffline, bool? errorServidor){
      print("updateUsuarioOnComplete");
      homePresenter.getUserSession(true);
    };

    homePresenter.updateUsuarioOnError = (e){

    };

    homePresenter.getUpdateUserOnNext =  (UsuarioUi user) {
      print("getUpdateUserOnNext ${user.personaUi?.foto}");
      _userioSession?.personaUi?.fechaNacimiento = user.personaUi?.fechaNacimiento;
      _userioSession?.personaUi?.fechaNacimiento2 = user.personaUi?.fechaNacimiento2;
      _userioSession?.personaUi?.correo = user.personaUi?.correo;
      _userioSession?.personaUi?.telefono = user.personaUi?.telefono;
      _userioSession?.personaUi?.nombres = user.personaUi?.nombres;
      _userioSession?.personaUi?.nombreCompleto = user.personaUi?.nombreCompleto;
      _userioSession?.personaUi?.apellidoMaterno = user.personaUi?.apellidoMaterno;
      _userioSession?.personaUi?.apellidoPaterno = user.personaUi?.apellidoPaterno;
      _userioSession?.personaUi?.foto = user.personaUi?.foto;
      refreshUI();
    };


    homePresenter.getUpdateUserOnError = (e) {

    };

    homePresenter.updateContactoDocenteOnComplete = (bool? datosOffline, bool? errorServidor){
      if(datosOffline??false){
        _conexion = false;
      }else if(errorServidor??false){
        _conexion = false;
      }else{
        _conexion = true;
      }
    };

    homePresenter.updateContactoDocenteoOnError = (e){
      _conexion = false;
    };

  }

  @override
  void onInitState() {
    homePresenter.validarUsuario();
    homePresenter.updateContactoDocente();
    getIconoServidor();
    super.onInitState();
  }

  void getIconoServidor() async{
    _logoApp =await homePresenter.getIconoServidor();
    refreshUI();
  }

  void onSelectedVistaAbout() {
    _vistaActual = VistaIndex.SobreNosotros;
    refreshUI(); // Refreshes the UI manually

  }

  void onSelectedVistaFeedBack() {
    _vistaActual = VistaIndex.Sugerencia;
    refreshUI(); // Refreshes the UI manually
  }

  void onSelectedVistaPrincial() {
    _vistaActual = VistaIndex.Principal;
    refreshUI(); // Refreshes the UI manually
  }

  void onSelectedVistaEditUsuario() {
    _vistaActual = VistaIndex.EditarUsuario;
    refreshUI(); // Refreshes the UI manually
  }

  Future<bool> onClickCerrarCession() {
   return homePresenter.cerrarCesion();
  }

  @override
  void onDisposed() {
    super.onDisposed();
    homePresenter.dispose();
  }

  void changeConnected(bool connected) {
    if(!_conexion && connected){
      homePresenter.updateContactoDocente();
    }
  }
}

enum VistaIndex {
  Principal,
  EditarUsuario,
  Sugerencia,
  SobreNosotros,
}