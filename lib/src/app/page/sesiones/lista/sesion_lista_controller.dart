import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/lista/sesion_lista_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';

class SesionListaController extends Controller{
  SesionListaPresenter presenter;
  CursosUi cursosUi;
  List<CalendarioPeriodoUI> _calendarioPeriodoList = [];

  UnidadUi? unidadUiSelected;
  List<CalendarioPeriodoUI> get calendarioPeriodoList => _calendarioPeriodoList;
  CalendarioPeriodoUI? _calendarioPeriodoUI = null;
  CalendarioPeriodoUI? get calendarioPeriodoUI => _calendarioPeriodoUI;
  List<UnidadUi> _unidadUiDocenteList = [];
  List<UnidadUi> get unidadUiDocenteList => _unidadUiDocenteList;
  List<UnidadUi> _unidadUiAlumnoList = [];
  List<UnidadUi> get unidadAUiAlumnoList => _unidadUiAlumnoList;
  bool _progressDocente = false;
  bool get progressDocente => _progressDocente;
  bool _progressAlumno = false;
  bool get progressAlumno => _progressAlumno;
  Function? _progressUnidades;
  Function? get progressUnidades => _progressUnidades;

  SesionListaController(this.cursosUi, configuracionRepo, calendarioPeriodoRepo, httpDatosRepo, unidadSesionRepo):
      presenter = SesionListaPresenter(configuracionRepo, calendarioPeriodoRepo, httpDatosRepo, unidadSesionRepo);

  @override
  void initListeners() {
    presenter.getCalendarioPeridoOnComplete = (List<CalendarioPeriodoUI>? calendarioPeridoList, CalendarioPeriodoUI? calendarioPeriodoUI){
      _calendarioPeriodoList = calendarioPeridoList??[];
      _calendarioPeriodoUI = calendarioPeriodoUI;
      _progressAlumno = true;
      _progressDocente = true;
      refreshUI();
      presenter.getUnidadAprendizajeDocente(cursosUi, calendarioPeriodoUI);
      presenter.getUnidadAprendizajeAlumno(cursosUi, calendarioPeriodoUI);

    };

    presenter.getCalendarioPeridoOnError = (e){
      _calendarioPeriodoList = [];
      _calendarioPeriodoUI = null;
      refreshUI();
    };

    presenter.getUnidadSesionDocenteOnComplete = (List<UnidadUi>? unidadUiList, bool? datosOffline, bool? errorServidor){
      _unidadUiDocenteList = unidadUiList??[];
      _progressDocente = false;
      refreshUI();

    };
    presenter.getUnidadSesionDocenteOnError = (e){
      _unidadUiDocenteList = [];
      _progressDocente = false;
      refreshUI();
    };

    presenter.getUnidadSesionAlumnoOnComplete = (List<UnidadUi>? unidadUiList, bool? datosOffline, bool? errorServidor){
      _unidadUiAlumnoList = unidadUiList??[];
      _progressAlumno = false;
      refreshUI();

    };
    presenter.getUnidadSesionAlumnoOnError = (e){
      _unidadUiAlumnoList = [];
      _progressAlumno = false;
      refreshUI();

    };
  }


  @override
  void onInitState() {
    presenter.getCalendarioPerido(cursosUi);
    super.onInitState();
  }

  void onSelectedCalendarioPeriodo(CalendarioPeriodoUI calendarioPeriodoUi) {
    this._calendarioPeriodoUI = calendarioPeriodoUi;
    for(var item in  _calendarioPeriodoList){
      item.selected = false;
    }
    calendarioPeriodoUI?.selected = true;

    _progressAlumno = true;
    _progressDocente = true;
    refreshUI();
    presenter.getUnidadAprendizajeDocente(cursosUi, calendarioPeriodoUI);
    presenter.getUnidadAprendizajeAlumno(cursosUi, calendarioPeriodoUI);
  }

  void onSyncronizarUnidades() {
    _progressAlumno = true;
    _progressDocente = true;
    refreshUI();
    presenter.getUnidadAprendizajeDocente(cursosUi, calendarioPeriodoUI);
    presenter.getUnidadAprendizajeAlumno(cursosUi, calendarioPeriodoUI);

  }

  @override
  void dispose() {

  }

  @override
  void onDisposed() {

  }
}