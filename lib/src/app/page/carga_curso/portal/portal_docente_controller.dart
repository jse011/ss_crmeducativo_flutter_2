import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/carga_curso/portal/portal_docente_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/anio_academico_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/georeferencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/programa_educativo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';

class PortalDocenteController extends Controller{
  PortalDocentePresenter presenter;
  UsuarioUi? _usuarioUi = null;
  UsuarioUi? get usuarioUi => _usuarioUi;
  List<GeoreferenciaUi> _georeferenciaUiList = [];
  List<GeoreferenciaUi> get georeferenciaUiList => _georeferenciaUiList;
  GeoreferenciaUi? _georeferenciaUi = null;
  GeoreferenciaUi? get georeferenciaUi => _georeferenciaUi;
  AnioAcademicoUi? _anioAcademicoUi = null;
  AnioAcademicoUi? get anioAcademicoUi => _anioAcademicoUi;
  List<ProgramaEducativoUi> _programaEducativoUiList = [];
  List<ProgramaEducativoUi> get programaEducativoUiList => _programaEducativoUiList;
  ProgramaEducativoUi? _programaEducativoUi = null;
  ProgramaEducativoUi? get programaEducativoUi => _programaEducativoUi;
  List<CursosUi> _cursosUiList = [];
  List<CursosUi> get cursosUiList => _cursosUiList;
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  bool _conexion = true;
  bool get conexion => _conexion;
  bool? _datosAntesActualizar;

  PortalDocenteController(usuarioConfiRepo, httpDatosRepo)
      :this.presenter = PortalDocentePresenter(usuarioConfiRepo, httpDatosRepo)
      , super();

  @override
  void initListeners() {
    presenter.getUserOnNext = (UsuarioUi user) {
      _usuarioUi = user;
      refreshUI(); // Refreshes the UI manually
    };

    presenter.getUserOnComplete = () {

    };
    // On error, show a snackbar, remove the user, and refresh the UI
    presenter.getUserOnError = (e) {
      _usuarioUi = null;
      refreshUI(); // Refreshes the UI manually
    };

    presenter.getAnioAcadOnComplete = (georeferenciaUiList, anioAcademicoSelected){
      _anioAcademicoUi = anioAcademicoSelected;
      _georeferenciaUi = _anioAcademicoUi?.georeferenciaUi;
      _georeferenciaUiList = georeferenciaUiList;
      refreshUI();
      presenter.updateProgramaEducativo();
    };

    presenter.getAnioAcadOnError = (e){
      _anioAcademicoUi = null;
      _georeferenciaUiList = [];
      _isLoading = false;
      refreshUI();
    };

    presenter.getProgramasEducativosOnComplete = (ProgramaEducativoUi? programaEducativoUi, List<ProgramaEducativoUi>? programaEducativoList, bool? datosOffline, bool? errorServidor, bool? datosAntesActualizar){
      _datosAntesActualizar = datosAntesActualizar;
      if(!(_datosAntesActualizar??false)){
        if(datosOffline??false){
          _conexion = false;
        }else if(errorServidor??false){
          _conexion = false;
        }else{
          _conexion = true;
        }
      }
      presenter.getCursos(programaEducativoUi);

      _programaEducativoUi = programaEducativoUi;
      _programaEducativoUiList = programaEducativoList??[];
      refreshUI();

    };

    presenter.getProgramasEducativosOnError = (e){
      _datosAntesActualizar = false;
      _programaEducativoUi = null;
      _programaEducativoUiList = [];
      refreshUI();
      _conexion = false;
    };

    presenter.getCursosOnComplete = (List<CursosUi> cursosUiList){
      _cursosUiList = cursosUiList;
      print("_datosAntesActualizar ${_datosAntesActualizar}");
      if(!(_datosAntesActualizar??false)){
        _isLoading = false; //No ocultar el progreso si aun no se actualizo la data
      }
      refreshUI();
    };

    presenter.getCursosOnError = (e){
      _cursosUiList = [];
      _isLoading = false;
      refreshUI();
    };

  }

  void onInitState() {
    _isLoading = true;
    refreshUI();
    presenter.getUsuario();
    presenter.getAnioAcademico();
    super.onInitState();
  }

  void clicProgramaEducativo(ProgramaEducativoUi programaEducativoUi) {
    _programaEducativoUi = programaEducativoUi;
    refreshUI();
    presenter.getCursos(programaEducativoUi);
  }

  void onSelectAnioAcademico(item) {
    _anioAcademicoUi = item;
    presenter.updateSessionAnioAcademicoId(anioAcademicoUi?.anioAcademicoId??0);
    _isLoading = true;
    refreshUI();
    presenter.updateProgramaEducativo();
    print("updateContactoDocente");
    presenter.updateContactoDocente();
  }

  void onSelectPrograma(item) {
    _programaEducativoUi = item;
    _isLoading = false;
    presenter.updateSessionProgramaAcademicoId(_programaEducativoUi?.idPrograma??0);
    refreshUI();
    presenter.getCursos(_programaEducativoUi);
  }

  void onSelectGeoreferencia(item) {
    _georeferenciaUi = item;
    _anioAcademicoUi = null;
    for (AnioAcademicoUi anioAcademicoUi in georeferenciaUi?.anioAcademicoUiList??[]) {
      if (anioAcademicoUi.vigente??false) {
        _anioAcademicoUi = anioAcademicoUi;
      }
    }

    if(_anioAcademicoUi == null && (georeferenciaUi?.anioAcademicoUiList??[]).isNotEmpty){
      _anioAcademicoUi = georeferenciaUi?.anioAcademicoUiList![0];
    }

    onSelectAnioAcademico(_anioAcademicoUi);
  }

  void changeConnected(bool connected) {
    if(!_conexion && connected){
      if(_anioAcademicoUi==null){
        for (AnioAcademicoUi anioAcademicoUi in georeferenciaUi?.anioAcademicoUiList??[]) {
          if (anioAcademicoUi.vigente??false) {
            _anioAcademicoUi = anioAcademicoUi;
          }
        }
      }

      if(_anioAcademicoUi == null && (georeferenciaUi?.anioAcademicoUiList??[]).isNotEmpty){
        _anioAcademicoUi = georeferenciaUi?.anioAcademicoUiList![0];
      }

      onSelectAnioAcademico(_anioAcademicoUi);
    }
  }

}