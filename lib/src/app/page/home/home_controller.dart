import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';

import 'home_presenter.dart';

class HomeController extends Controller{
  final HomePresenter homePresenter;
  VistaIndex _vistaActual;
  UsuarioUi? _userioSession = null;
  bool _splash = true;
  bool get splash => _splash;
  UsuarioUi? get usuario => _userioSession; // data used by the View
  int _showLoggin = 0;// 0 cargando, 1 show Loggin, -1 nada
  int get showLoggin => _showLoggin;

  VistaIndex get vistaActual => _vistaActual;

  HomeController(usuarioConfiRepo, httpDatosRepo)
      :  _vistaActual = VistaIndex.Principal,
        this.homePresenter = HomePresenter(usuarioConfiRepo, httpDatosRepo),
      super();

  @override
  // this is called automatically by the parent class
  void initListeners() {
    homePresenter.getUserOnNext = (UsuarioUi user) {
      _userioSession = user;
      refreshUI(); // Refreshes the UI manually
    };

    homePresenter.getUserOnComplete = () {
      Future.delayed(const Duration(milliseconds: 3000), () {
        _splash = false;
        refreshUI();
      });
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    homePresenter.getUserOnError = (e) {
      print('Could not retrieve user.');
      _userioSession = null;
      refreshUI(); // Refreshes the UI manually
    };


    homePresenter.validarUsuarioOnComplete = () {
      homePresenter.getUserSession();
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

  }

  @override
  void onInitState() {
    homePresenter.validarUsuario();
    homePresenter.updateContactoDocente();
    super.onInitState();
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

  void onClickCerrarCession() {
   // homePresenter.cerrarCesion();
  }

  @override
  void onDisposed() {
    super.onDisposed();
    homePresenter.dispose();
  }
}

enum VistaIndex {
  Principal,
  EditarUsuario,
  Sugerencia,
  SobreNosotros,
}