import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/resultado/resultado_presenter.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/resultado/table_resultado.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/matriz_resultado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/resultado_respository.dart';

class ResultadoController extends Controller{

  ResultadoPresenter _presenter;
  CursosUi cursosUi;
  List<CalendarioPeriodoUI> _calendarioPeriodoList = [];
  List<CalendarioPeriodoUI> get calendarioPeriodoList => _calendarioPeriodoList;
  CalendarioPeriodoUI? _calendarioPeriodoUI = null;
  CalendarioPeriodoUI? get calendarioPeriodoUI => _calendarioPeriodoUI;
  bool _progress = true;
  bool get progress => _progress;
  bool _datosOffline = false;
  bool get datosOffline => _datosOffline;
  List<dynamic> _rows = [];
  List<dynamic> get rows =>_rows;
  List<dynamic> _columns = [];
  List<dynamic> get columns => _columns;
  List<List<dynamic>> _cells = [];
  List<List<dynamic>> get cells => _cells;
  bool _precision = false;
  bool get precision => _precision;

  ResultadoController(this.cursosUi, this._calendarioPeriodoUI, ConfiguracionRepository configuracionRepo, CalendarioPeriodoRepository calendarioPeriodoRepo, ResultadoRepository resultadoRepo, HttpDatosRepository httpDatosRepo):
        this._presenter = ResultadoPresenter(configuracionRepo, calendarioPeriodoRepo, resultadoRepo, httpDatosRepo);

  @override
  void initListeners() {
    _presenter.getCalendarioPeridoOnComplete = (List<CalendarioPeriodoUI>? calendarioPeridoList, CalendarioPeriodoUI? calendarioPeriodoUI){
      _calendarioPeriodoList = calendarioPeridoList??[];

      if(_calendarioPeriodoUI!=null){
        for(var calendarioPeriodoUi in _calendarioPeriodoList){
          if(calendarioPeriodoUi.id == _calendarioPeriodoUI?.id){
            _calendarioPeriodoUI = calendarioPeriodoUi;
          }
        }
      }else{
        _calendarioPeriodoUI = calendarioPeriodoUI;
      }

      if(_calendarioPeriodoUI!=null&&(_calendarioPeriodoUI?.id??0) > 0){
        _presenter.getResultados(cursosUi, _calendarioPeriodoUI);
      }else{
        _progress = false;
      }

      refreshUI();

    };

    _presenter.getCalendarioPeridoOnError = (e){
      _calendarioPeriodoList = [];
      _calendarioPeriodoUI = null;
      refreshUI();
    };

    _presenter.getResultadosOnComplete = (MatrizResultadoUi? matrizResultadoUi, bool? offlineServidor, bool? errorServidor){
      _rows = [];
      _columns = [];
      _cells = [];

      var result = TableResultadoUtils.getTableResulData(matrizResultadoUi, calendarioPeriodoUI);

      _rows.addAll(result.rows??[]);
      _columns.addAll(result.columns??[]);
      _cells.addAll(result.cells??[]);

      _progress = false;
      refreshUI();
    };

    _presenter.getResultadosOnError = (e){
      _cells.clear();
      _rows.clear();
      _columns.clear();
      _progress = false;
      refreshUI();
    };
  }

  @override
  void onInitState() {
    _presenter.getCalendarioPerido(cursosUi);
    super.onInitState();
  }

  @override
  void onDisposed() {
    super.onDisposed();
    _presenter.dispose();
  }

  void onSelectedCalendarioPeriodo(CalendarioPeriodoUI? calendarioPeriodoUI) {
    this._calendarioPeriodoUI = calendarioPeriodoUI;
    for(var item in  _calendarioPeriodoList){
      item.selected = false;
    }
    calendarioPeriodoUI?.selected = true;
    _progress = true;
    refreshUI();
    if(_calendarioPeriodoUI!=null&&(_calendarioPeriodoUI?.id??0) > 0){
      _presenter.getResultados(cursosUi, _calendarioPeriodoUI);
    }else{
      _progress = false;
    }
  }



}

