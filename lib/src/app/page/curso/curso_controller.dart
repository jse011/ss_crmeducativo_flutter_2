import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/curso/curso_presenter.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_utils.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/anio_acemico_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/app_tools.dart';

class CursoController extends Controller{
  CursoPresenter cursoPresenter;
  CursosUi? _cursosUi = null;
  CursosUi? get cursos => _cursosUi;
  String? _fechaHoy = null;
  String? get fechaHoy => _fechaHoy;

  CursoController(cursosUi,configuracionRepo):this._cursosUi = cursosUi, this.cursoPresenter = CursoPresenter(configuracionRepo);

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
  }

  @override
  void onInitState() {
    getFecha();
    super.onInitState();
  }

  void getFecha() {
    _fechaHoy = AppTools.f_fecha_letras(DateTime.now());
    refreshUI();
  }

}