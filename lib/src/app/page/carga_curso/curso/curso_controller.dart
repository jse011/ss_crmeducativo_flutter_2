import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/carga_curso/curso/curso_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/anio_academico_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';

class CursoController extends Controller{
  CursoPresenter cursoPresenter;
  UsuarioUi? usuarioUi;
  CursosUi? _cursosUi;
  CursosUi? get cursos => _cursosUi;
  String? _fechaHoy;
  String? get fechaHoy => _fechaHoy;
  bool _progress = true;
  bool get progress => _progress;
  bool _showProgress = false;
  bool get showProgress => _showProgress;
  AnioAcademicoUi anioAcademicoUi;
  bool _conexion = true;
  bool get conexion => _conexion;
  List<CalendarioPeriodoUI> _calendarioPeriodoUiList = [];
  List<CalendarioPeriodoUI> get calendarioPeriodoUiList => _calendarioPeriodoUiList;
  CursoController(this.usuarioUi, this.anioAcademicoUi, cursosUi,configuracionRepo, calendarioPeriodoRepo, httpDatosRepo):
        this._cursosUi = cursosUi,
        this.cursoPresenter = CursoPresenter(configuracionRepo, calendarioPeriodoRepo, httpDatosRepo);

  @override
  void initListeners() {

    cursoPresenter.getCursoOnComplete = (CursosUi cursosUi){
      _cursosUi = cursos;
      refreshUI();
    };
    cursoPresenter.getCursoOnError = (e){
      _cursosUi = null;
      refreshUI();
    };

    cursoPresenter.updateCalendarioPeridoOnComplete = (bool? errorServidor, bool? datosOffline ){
      _progress = false;
      _showProgress = false;
      if(datosOffline??false){
        _conexion = false;
      }else if(errorServidor??false){
        _conexion = false;
      }else{
        _conexion = true;
      }
      refreshUI();
    };

    cursoPresenter.updateCalendarioPeridoOnError = (e){
      _progress = false;
      _conexion = false;
      _showProgress = false;
      refreshUI();
    };

    cursoPresenter.getCalendarioPeridoOnComplete = (List<CalendarioPeriodoUI>? calendarioPeriodoUiList, CalendarioPeriodoUI? cursosUi){
      _calendarioPeriodoUiList = calendarioPeriodoUiList??[];
      _progress = true;
      if(_calendarioPeriodoUiList.isEmpty){
        _showProgress = true;
      }else{
        _showProgress = false;
      }
      refreshUI();
      cursoPresenter.updateCalendarioPerido(_cursosUi);
    };

    cursoPresenter.getCalendarioPeridoOnError = (e){
      _calendarioPeriodoUiList = [];
      _progress = true;
      _showProgress = true;
      refreshUI();
      cursoPresenter.updateCalendarioPerido(_cursosUi);
    };

  }

  @override
  void onInitState() {
    cursoPresenter.getCalendarioPerido(_cursosUi);
  }

  void getFecha() {
    _fechaHoy = DomainTools.f_fecha_letras(DateTime.now());
    refreshUI();
  }

  void changeConnected(bool connected) {

  }

  void cerrarProgreso() {
    _showProgress = false;
    refreshUI();

  }

}