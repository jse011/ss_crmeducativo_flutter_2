import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/resultado_respository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_alumno_curso.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_calendario_periodo.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_competencia_rubro_eval.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_resultados.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_datos_crear_rubros.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_rubro_evaluacion_list.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_tipo_nota_resultado.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_unidad_rubro_eval.dart';

class RubroPresenter extends Presenter{
  GetCalendarioPerido _getCalendarioPerido;
  late Function getCalendarioPeridoOnComplete, getCalendarioPeridoOnError;
  UpdateDatosCrearRubro _getDatosCrearRubro;
  late Function updateDatosCrearRubroOnNext, updateDatosCrearRubroOnError;
  GetRubroEvaluacionList _getRubroEvaluacion;
  late Function getRubroEvaluacionOnNext, getRubroEvaluacionOnError;

  GetUnidadRubroEval _getUnidadRubroEval;
  late Function getUnidadRubroEvalOnNext, getUnidadRubroEvalOnError;

  GetCompetenciaRubroEval _getCompetenciaRubroEval;
  late Function getCompetenciaRubroEvalOnNext, getCompetenciaRubroEvalOnError;

  GetTipoNotaResultado _getTipoNotaResultado;
  late Function getTipoNotaResultadoOnNext, getTipoNotaResultadoEvalOnError;

  GetResultados _getResultados;
  late Function getResultadosOnComplete, getResultadosOnError;

  RubroPresenter(CalendarioPeriodoRepository calendarioPeriodoRepo, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo, RubroRepository rubroRepo, ResultadoRepository resultadoRepo) :
                          _getCalendarioPerido = new GetCalendarioPerido(configuracionRepo, calendarioPeriodoRepo),
                          _getDatosCrearRubro = new UpdateDatosCrearRubro(httpDatosRepo, configuracionRepo, rubroRepo),
                          _getRubroEvaluacion = GetRubroEvaluacionList(rubroRepo),
                          _getUnidadRubroEval = GetUnidadRubroEval(rubroRepo),
                          _getCompetenciaRubroEval = GetCompetenciaRubroEval(rubroRepo, configuracionRepo),
                          _getTipoNotaResultado = GetTipoNotaResultado(rubroRepo),
                          _getResultados = GetResultados(httpDatosRepo, configuracionRepo, resultadoRepo);

  void getCalendarioPerido(CursosUi? cursosUi){
    _getCalendarioPerido.execute(_GetCalendarioPeriodoCase(this), GetCalendarioPeridoParams(cursosUi?.cargaCursoId??0));
  }


  @override
  void dispose() {
      _getCalendarioPerido.dispose();
      _getDatosCrearRubro.dispose();
      _getRubroEvaluacion.dispose();
      _getUnidadRubroEval.dispose();
      _getCompetenciaRubroEval.dispose();
      _getTipoNotaResultado.dispose();
  }

  void onActualizarCurso(CalendarioPeriodoUI? calendarioPeriodoUI, CursosUi cursosUi) {
    _getDatosCrearRubro.dispose();
    _getDatosCrearRubro.execute(_GetDatosCrearRubroCase(this), new UpdateDatosCrearRubroParams(calendarioPeriodoUI?.id??0, cursosUi.silaboEventoId??0, null));
  }

  void onGetRubricaList(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI, OrigenRubroUi? origenRubroUi){
    _getRubroEvaluacion.dispose();
    _getRubroEvaluacion.execute(_GetRubroEvaluacionCase(this), GetRubroEvaluacionListParms(calendarioPeriodoUI?.id, cursosUi?.silaboEventoId, origenRubroUi));
  }

  void onGetUnidadRubroEval(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI){
    _getUnidadRubroEval.dispose();
    _getUnidadRubroEval.execute(_GetUnidadRubroEvalCase(this), GetUnidadRubroEvalParams(calendarioPeriodoUI?.id, cursosUi?.silaboEventoId));
  }

  void onGetCompetenciaRubroEval(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI){
    _getCompetenciaRubroEval.dispose();
    _getCompetenciaRubroEval.execute(GetCompetenciaRubroEvalCase(this), GetCompetenciaRubroParams(calendarioPeriodoUI, cursosUi?.silaboEventoId, cursosUi?.cargaCursoId));
  }

  void onGetTipoNotaResultado(CursosUi? cursosUi){
    _getTipoNotaResultado.dispose();
    _getTipoNotaResultado.execute(GetTipoNotaResultadoCase(this), GetTipoNotaResultadoParms(cursosUi?.silaboEventoId));
  }

  void getResultados(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI){
    _getResultados.dispose();
    _getResultados.execute(_GetResultadosCase(this), GetResultadosParams(cursosUi, calendarioPeriodoUI?.id));
  }

}

class _GetCalendarioPeriodoCase extends Observer<GetCalendarioPeridoResponse>{
  RubroPresenter presenter;

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

class _GetDatosCrearRubroCase extends Observer<UpdateDatosCrearRubroResponse>{
  RubroPresenter presenter;

  _GetDatosCrearRubroCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.updateDatosCrearRubroOnError!=null);
    presenter.updateDatosCrearRubroOnError(e);
  }

  @override
  void onNext(UpdateDatosCrearRubroResponse? response) {
    assert(presenter.updateDatosCrearRubroOnNext!=null);
    presenter.updateDatosCrearRubroOnNext(response?.errorConexion, response?.errorServidor);
  }

}

class _GetRubroEvaluacionCase extends Observer<GetRubroEvaluacionListResponse>{
  RubroPresenter presenter;

  _GetRubroEvaluacionCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getRubroEvaluacionOnError!=null);
    presenter.getRubroEvaluacionOnError(e);
  }

  @override
  void onNext(GetRubroEvaluacionListResponse? response) {
    assert(presenter.getRubroEvaluacionOnNext!=null);
    presenter.getRubroEvaluacionOnNext(response?.rubricaEvaluacionList);
  }

}

class _GetUnidadRubroEvalCase extends Observer<GetUnidadRubroEvalResponse>{
  RubroPresenter presenter;

  _GetUnidadRubroEvalCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getUnidadRubroEvalOnError!=null);
    presenter.getUnidadRubroEvalOnError(e);
  }

  @override
  void onNext(GetUnidadRubroEvalResponse? response) {
    assert(presenter.getUnidadRubroEvalOnNext!=null);
    presenter.getUnidadRubroEvalOnNext(response?.unidadUiList);
  }

}

class GetCompetenciaRubroEvalCase extends Observer<GetCompetenciaRubroResponse>{
  RubroPresenter presenter;

  GetCompetenciaRubroEvalCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getCompetenciaRubroEvalOnError!=null);
    presenter.getCompetenciaRubroEvalOnError(e);
  }

  @override
  void onNext(GetCompetenciaRubroResponse? response) {
    assert(presenter.getCompetenciaRubroEvalOnNext!=null);
    presenter.getCompetenciaRubroEvalOnNext(response?.competenciaUiList, response?.personaUiList, response?.evaluacionCompetenciaUiList, response?.evaluacionCalendarioPeriodoUiList, response?.tipoNotaUi);
  }

}

class GetTipoNotaResultadoCase extends Observer<GetTipoNotaResultadoResponse>{
  RubroPresenter presenter;

  GetTipoNotaResultadoCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getTipoNotaResultadoEvalOnError!=null);
    presenter.getTipoNotaResultadoEvalOnError(e);
  }

  @override
  void onNext(GetTipoNotaResultadoResponse? response) {
    assert(presenter.getTipoNotaResultadoOnNext!=null);
    presenter.getTipoNotaResultadoOnNext(response?.tipoEvaluacionUi);
  }

}

class _GetResultadosCase extends Observer<GetResultadosResponse>{
  RubroPresenter presenter;

  _GetResultadosCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getResultadosOnError!=null);
    presenter.getResultadosOnError(e);
  }

  @override
  void onNext(GetResultadosResponse? response) {
    print("getResultadosOnComplete");
    assert(presenter.getResultadosOnComplete!=null);
    presenter.getResultadosOnComplete(response?.matrizResultadoUi, response?.offlineServidor, response?.errorServidor);
  }

}