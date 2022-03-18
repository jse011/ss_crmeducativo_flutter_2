import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_calendario_periodo.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_curso.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_calendario_periodo.dart';

class CursoPresenter extends Presenter {
  late GetCurso _getCurso;
  late Function getCursoOnComplete, getCursoOnError;

  UpdateCalendarioPerido _updateCalendarioPerido;
  late Function updateCalendarioPeridoOnComplete, updateCalendarioPeridoOnError;

  GetCalendarioPerido _getCalendarioPerido;
  late Function getCalendarioPeridoOnComplete, getCalendarioPeridoOnError;

  CursoPresenter(ConfiguracionRepository configuracionRepo, CalendarioPeriodoRepository calendarioPeriodoRepo, HttpDatosRepository httpDatosRepo)
      : _getCurso = GetCurso(configuracionRepo),
        _updateCalendarioPerido = UpdateCalendarioPerido(configuracionRepo, calendarioPeriodoRepo, httpDatosRepo),
        _getCalendarioPerido = GetCalendarioPerido(configuracionRepo, calendarioPeriodoRepo);

  void updateCalendarioPerido(CursosUi? cursosUi){
    _updateCalendarioPerido.execute(_UpdateCalendarioPeriodoCase(this), UpdateCalendarioPeridoParams(cursosUi?.cargaCursoId??0));
  }

  @override
  void dispose() {
    _getCurso.dispose();
    _updateCalendarioPerido.dispose();
  }

  void getCursoParams(int cargaCursoId){
    _getCurso.execute(_GetCursoCase(this), GetCursoParams(cargaCursoId));
  }

  void getCalendarioPerido(CursosUi? cursosUi){
    _getCalendarioPerido.execute(_GetCalendarioPeriodoCase(this), GetCalendarioPeridoParams(cursosUi?.cargaCursoId??0));
  }

}


class _GetCursoCase extends Observer<GetCursoResponse>{
  final CursoPresenter presenter;

  _GetCursoCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getCursoOnError != null);
    presenter.getCursoOnError(e);
  }

  @override
  void onNext(GetCursoResponse? response) {
    assert(presenter.getCursoOnComplete != null);
    presenter.getCursoOnComplete(response?.cursoUi);
  }

}

class _UpdateCalendarioPeriodoCase extends Observer<UpdateCalendarioPeridoResponse>{
  CursoPresenter presenter;

  _UpdateCalendarioPeriodoCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.updateCalendarioPeridoOnError!=null);
    presenter.updateCalendarioPeridoOnError(e);
  }

  @override
  void onNext(UpdateCalendarioPeridoResponse? response) {
    print("getCalendarioPeridoOnComplete");
    assert(presenter.updateCalendarioPeridoOnComplete!=null);
    presenter.updateCalendarioPeridoOnComplete(response?.errorServidor, response?.offlineServidor);
  }

}

class _GetCalendarioPeriodoCase extends Observer<GetCalendarioPeridoResponse>{
  CursoPresenter presenter;

  _GetCalendarioPeriodoCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getCalendarioPeridoOnError!=null);
    presenter.getCalendarioPeridoOnError(e);
  }

  @override
  void onNext(GetCalendarioPeridoResponse? response) {
    print("getCalendarioPeridoOnComplete");
    assert(presenter.getCalendarioPeridoOnComplete!=null);
    presenter.getCalendarioPeridoOnComplete(response?.calendarioPeriodoList, response?.calendarioPeriodoUI);
  }

}
