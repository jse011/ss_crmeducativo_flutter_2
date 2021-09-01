import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_rubro_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_usuario.dart';

class EvaluacionIndicadorMultiplePresenter extends Presenter {

  GetSessionUsuarioCase _getSessionUsuario;
  late Function getSessionUsuarioOnError, getSessionUsuarioOnNext;
  GetRubroEvaluacion _getRubroEvaluacion;
  late Function getRubroEvaluacionOnError, getRubroEvaluacionOnNext;

  EvaluacionIndicadorMultiplePresenter(RubroRepository rubroRepo, ConfiguracionRepository configuracionRepo):
        _getRubroEvaluacion = GetRubroEvaluacion(rubroRepo, configuracionRepo),
        _getSessionUsuario = GetSessionUsuarioCase(configuracionRepo);

  void getRubroEvaluacion(String? rubroEvaluacionId, CursosUi? cursosUi ){
    _getRubroEvaluacion.execute(_GetRubroEvaluacionCase(this), GetRubroEvaluacionParms(rubroEvaluacionId, cursosUi?.cargaCursoId));
  }

  void getSessionUsuario(){
    _getSessionUsuario.execute(_GetSessionUsuarioCase(this),GetSessionUsuarioCaseParams());
  }

  @override
  void dispose() {
    _getRubroEvaluacion.dispose();
    _getSessionUsuario.dispose();
  }



}

class _GetSessionUsuarioCase extends Observer<GetSessionUsuarioCaseResponse> {
  EvaluacionIndicadorMultiplePresenter presenter;

  _GetSessionUsuarioCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getSessionUsuarioOnError != null);
    presenter.getSessionUsuarioOnError(e);
  }

  @override
  void onNext(GetSessionUsuarioCaseResponse? response) {
    assert(presenter.getSessionUsuarioOnNext != null);
    presenter.getSessionUsuarioOnNext(
        response?.usuario);
  }

}

class _GetRubroEvaluacionCase extends Observer<GetRubroEvaluacionResponse> {
  EvaluacionIndicadorMultiplePresenter presenter;

  _GetRubroEvaluacionCase(this.presenter);

  @override
  void onComplete() {
    // TODO: implement onComplete
  }

  @override
  void onError(e) {
    assert(presenter.getRubroEvaluacionOnError != null);
    presenter.getRubroEvaluacionOnError(e);
  }

  @override
  void onNext(GetRubroEvaluacionResponse? response) {
    assert(presenter.getRubroEvaluacionOnNext != null);
    presenter.getRubroEvaluacionOnNext(
        response?.rubricaEvaluacionUi, response?.alumnoCursoList);
  }

}