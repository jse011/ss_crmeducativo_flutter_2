import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/curso/curso_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';

class CursoController extends Controller{
  CursoPresenter cursoPresenter;
  CursosUi? _cursosUi = null;
  CursosUi? get cursos => _cursosUi;
  String? _fechaHoy = null;
  String? get fechaHoy => _fechaHoy;
  bool _progress = true;
  bool get progress => _progress;
  CursoController(cursosUi,configuracionRepo, calendarioPeriodoRepo, httpDatosRepo):
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
    super.onInitState();
  }

  void getFecha() {
    _fechaHoy = DomainTools.f_fecha_letras(DateTime.now());
    refreshUI();
  }

}