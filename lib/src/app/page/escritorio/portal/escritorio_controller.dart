import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/escritorio/portal/escritorio_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_hoy_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';

class EscritorioController extends Controller{

  EscritorioPresenter escritorioPresenter;
  List<SesionHoyUi> _sesionHoyUiList = [];
  List<SesionHoyUi> get sesionHoyUiList => _sesionHoyUiList;
  bool _sesionToogle = false;
  bool get sesionToogle => _sesionToogle;
  UsuarioUi? _usuarioUi = null;
  UsuarioUi? get usuarioUi => _usuarioUi;
  bool _sesionProgress = false;
  bool get sesionProgress => _sesionProgress;

  EscritorioController(configuracionRepository, httpRepository, unidadSesionRepository):
        escritorioPresenter = EscritorioPresenter(configuracionRepository, httpRepository, unidadSesionRepository);

  @override
  void initListeners() {
    escritorioPresenter.getUserOnNext = (UsuarioUi user) {
      _usuarioUi = user;
      _sesionProgress = true;
      refreshUI(); // Refreshes the UI manually
      escritorioPresenter.getSesionesHoy();
    };

    escritorioPresenter.getUserOnComplete = () {

    };
    // On error, show a snackbar, remove the user, and refresh the UI
    escritorioPresenter.getUserOnError = (e) {
      _usuarioUi = null;
      refreshUI(); // Refreshes the UI manually
    };

    escritorioPresenter.getSesionesHoyOnError = (e){
      _sesionHoyUiList = [];
      _sesionProgress = false;
      refreshUI();
    };
    escritorioPresenter.getSesionesHoyOnSuccess = (bool? datosOffline, bool? errorServidor, List<SesionHoyUi>? sesionHoyUiList){
      _sesionHoyUiList = sesionHoyUiList??[];
      _sesionProgress = false;
      refreshUI();
    };
  }

  @override
  void onInitState() {
    escritorioPresenter.getUsuario();
    super.onInitState();
  }

  void onClickVerMasSesiones() {
    _sesionToogle = !_sesionToogle;
    refreshUI();
  }




}