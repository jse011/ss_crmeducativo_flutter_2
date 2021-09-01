import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/portal_docente/portal_docente_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/anio_acemico_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/programa_educativo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';

class PortalDocenteController extends Controller{
  PortalDocentePresenter presenter;
  UsuarioUi? _usuarioUi = null;
  UsuarioUi? get usuarioUi => _usuarioUi;
  List<AnioAcademicoUi> _anioAcademicoUiList = [];
  List<AnioAcademicoUi> get anioAcademicoUiList => _anioAcademicoUiList;
  AnioAcademicoUi? _anioAcademicoUi = null;
  AnioAcademicoUi? get anioAcademicoUi => _anioAcademicoUi;
  List<ProgramaEducativoUi> _programaEducativoUiList = [];
  List<ProgramaEducativoUi> get programaEducativoUiList => _programaEducativoUiList;
  ProgramaEducativoUi? _programaEducativoUi = null;
  ProgramaEducativoUi? get programaEducativoUi => _programaEducativoUi;
  List<CursosUi> _cursosUiList = [];
  List<CursosUi> get cursosUiList => _cursosUiList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

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

    presenter.getAnioAcadOnComplete = (anioAcademicoList, anioAcademicoSelected){
      _anioAcademicoUi = anioAcademicoSelected;
      _anioAcademicoUiList = anioAcademicoUiList;
      _isLoading = true;
      refreshUI();
      presenter.updateProgramaEducativo();
    };

    presenter.getAnioAcadOnError = (e){
      _anioAcademicoUi = null;
      _anioAcademicoUiList = [];
      refreshUI();
    };

    presenter.getProgramasEducativosOnComplete = (ProgramaEducativoUi programaEducativoUi, List<ProgramaEducativoUi> programaEducativoList, bool datosOffline, bool errorServidor){
      _programaEducativoUi = programaEducativoUi;
      _programaEducativoUiList = programaEducativoList;
      _isLoading = false;
      refreshUI();
      presenter.getCursos(programaEducativoUi);
    };

    presenter.getProgramasEducativosOnError = (e){
      _programaEducativoUi = null;
      _programaEducativoUiList = [];
      _isLoading = false;
      refreshUI();
    };

    presenter.getCursosOnComplete = (List<CursosUi> cursosUiList){
      _cursosUiList = cursosUiList;
      refreshUI();
    };

    presenter.getCursosOnError = (e){
      _cursosUiList = [];
      refreshUI();
    };

  }

  void onInitState() {
    presenter.getUsuario();
    presenter.getAnioAcademico();
    super.onInitState();
  }

  void clicProgramaEducativo(ProgramaEducativoUi programaEducativoUi) {
    _programaEducativoUi = programaEducativoUi;
    refreshUI();
    presenter.getCursos(programaEducativoUi);
  }

}