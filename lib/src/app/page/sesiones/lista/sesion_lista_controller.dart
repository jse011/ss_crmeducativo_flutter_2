import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/lista/sesion_lista_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
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
  Map<UnidadUi, List<dynamic>> _unidadItemsMap = Map();
  Map<UnidadUi, List<dynamic>> get unidadItemsMap => _unidadItemsMap;
  bool _progressDocente = false;
  bool get progressDocente => _progressDocente;

  bool _datosOffline = false;
  bool get datosOffline => _datosOffline;


  SesionListaController(this.cursosUi, configuracionRepo, calendarioPeriodoRepo, httpDatosRepo, unidadSesionRepo):
      presenter = SesionListaPresenter(configuracionRepo, calendarioPeriodoRepo, httpDatosRepo, unidadSesionRepo);

  @override
  void initListeners() {
    presenter.getCalendarioPeridoOnComplete = (List<CalendarioPeriodoUI>? calendarioPeridoList, CalendarioPeriodoUI? calendarioPeriodoUI){
      _calendarioPeriodoList = calendarioPeridoList??[];
      _calendarioPeriodoUI = calendarioPeriodoUI;
      _progressDocente = true;
      refreshUI();
      presenter.getUnidadAprendizajeDocente(cursosUi, calendarioPeriodoUI);


    };

    presenter.getCalendarioPeridoOnError = (e){
      _calendarioPeriodoList = [];
      _calendarioPeriodoUI = null;
      refreshUI();
    };

    presenter.getUnidadSesionDocenteOnComplete = (List<UnidadUi>? unidadUiList, bool? datosOffline, bool? errorServidor){
      _unidadUiDocenteList = unidadUiList??[];
      _progressDocente = false;
      _datosOffline = datosOffline??false;


      unidadItemsMap.clear();
      for(UnidadUi unidadUi in unidadUiList??[]){
        unidadUi.cantUnidades = unidadUiList!.length;
        unidadItemsMap[unidadUi] = [];

        //if(calendarioPeriodoUI?.habilitado==1)
        //  unidadItemsMap[unidadUi]?.add("");
        int  count = 0;
        for(SesionUi sesionUi in unidadUi.sesionUiList??[]){
          sesionUi.position = unidadUi.sesionUiList!.length - count;
          unidadItemsMap[unidadUi]?.add(sesionUi);
          count++;
        }

      }
      refreshUI();

    };
    presenter.getUnidadSesionDocenteOnError = (e){
      _unidadUiDocenteList = [];
      _progressDocente = false;
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

    _progressDocente = true;
    refreshUI();
    presenter.getUnidadAprendizajeDocente(cursosUi, calendarioPeriodoUI);

  }

  void onSyncronizarUnidades() {
    _progressDocente = true;
    refreshUI();
    presenter.getUnidadAprendizajeDocente(cursosUi, calendarioPeriodoUI);


  }


  @override
  void onDisposed() {
    presenter.dispose();
  }

  void onClickVerMas(UnidadUi unidadUi) {
    unidadUi.toogle = !(unidadUi.toogle??false);
    refreshUI();
  }
}