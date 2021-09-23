import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/lista/tarea_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class TareaController extends Controller{
  CursosUi cursosUi;
  List<CalendarioPeriodoUI> _calendarioPeriodoList = [];

  CalendarioPeriodoUI? _calendarioPeriodoUI = null;

  List<UnidadUi> _unidadUiList = [];

  bool _progress = true;
  bool get progress => _progress;
  List<UnidadUi> get unidadUiList => _unidadUiList;
  CalendarioPeriodoUI? get calendarioPeriodoUI => _calendarioPeriodoUI;
  List<CalendarioPeriodoUI> get calendarioPeriodoList => _calendarioPeriodoList;
  TareaPresenter _presenter;

  TareaController(this.cursosUi, ConfiguracionRepository configuracionRepo, CalendarioPeriodoRepository calendarioPeriodoRepo, HttpDatosRepository httpDatosRepo, UnidadTareaRepository unidadTareaRepo):
        _presenter = TareaPresenter(configuracionRepo, calendarioPeriodoRepo, httpDatosRepo, unidadTareaRepo);

  @override
  void initListeners() {
    _presenter.getCalendarioPeridoOnComplete = (List<CalendarioPeriodoUI>? calendarioPeridoList, CalendarioPeriodoUI? calendarioPeriodoUI){
      _calendarioPeriodoList = calendarioPeridoList??[];
      _calendarioPeriodoUI = calendarioPeriodoUI;
      _presenter.getUnidadTarea(cursosUi, calendarioPeriodoUI);
      refreshUI();

    };

    _presenter.getCalendarioPeridoOnError = (e){
      _calendarioPeriodoList = [];
      _calendarioPeriodoUI = null;
      refreshUI();
    };

    _presenter.getUnidadTareaOnComplete = (List<UnidadUi>? unidadUiList, bool? datosOffline, bool? errorServidor){
      _unidadUiList = unidadUiList??[];
      _progress = false;
      refreshUI();

    };
    _presenter.getUnidadTareaOnError = (e){
      _unidadUiList = [];
      _progress = false;
      refreshUI();
    };

  }

  @override
  void onInitState() {
    _presenter.getCalendarioPerido(cursosUi);
    super.onInitState();
  }

  void onSelectedCalendarioPeriodo(CalendarioPeriodoUI calendarioPeriodoUi) {
    this._calendarioPeriodoUI = calendarioPeriodoUi;
    for(var item in  _calendarioPeriodoList){
      item.selected = false;
    }
    calendarioPeriodoUI?.selected = true;
    _progress = true;
    refreshUI();
    _presenter.getUnidadTarea(cursosUi, calendarioPeriodoUI);

  }


}