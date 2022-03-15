import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/carga_curso/curso/curso_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/anio_academico_ui.dart';
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
  AnioAcademicoUi anioAcademicoUi;

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

    cursoPresenter.getCalendarioPeridoOnComplete = ( ){
      _progress = false;
      refreshUI();
    };

    cursoPresenter.getCalendarioPeridoOnError = (e){
      _progress = false;
      refreshUI();
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

}