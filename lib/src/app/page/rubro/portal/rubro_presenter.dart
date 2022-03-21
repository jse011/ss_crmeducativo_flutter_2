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
import 'package:ss_crmeducativo_2/src/domain/usecase/get_competencia_rubro_eval_2.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_resultados.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_calendario_periodo.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_cerrar_curso.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_datos_crear_rubros.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_rubro_evaluacion_list.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_tipo_nota_resultado.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_unidad_rubro_eval.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_resultado_curso.dart';

class RubroPresenter extends Presenter{
  GetCalendarioPerido _getCalendarioPerido;
  late Function getCalendarioPeridoOnComplete, getCalendarioPeridoOnError;
  UpdateDatosCrearRubro _getDatosCrearRubro;
  late Function updateDatosCrearRubroOnNext, updateDatosCrearRubroOnError;
  GetRubroEvaluacionList _getRubroEvaluacion;
  late Function getRubroEvaluacionOnNext, getRubroEvaluacionOnError;

  GetUnidadRubroEval _getUnidadRubroEval;
  late Function getUnidadRubroEvalOnNext, getUnidadRubroEvalOnError;

  GetCompetenciaRubroEval2 _getCompetenciaRubroEval;
  late Function getCompetenciaRubroEvalOnNext, getCompetenciaRubroEvalOnError;


  GetResultados _getResultados;
  late Function getResultadosOnComplete, getResultadosOnError;

  UpdateCerrarCurso _updateCerrarSesion;
  UpdateResultadoCurso _updateResultadoCurso;
  late Function UpdateCursoOnMessage;

  UpdateCalendarioPerido _updateCalendarioPerido;
  late Function updateCalendarioPeridoOnComplete, updateCalendarioPeridoOnError;

  List<UpdateDatosCrearRubroParams> cancels = [];
  RubroPresenter(CalendarioPeriodoRepository calendarioPeriodoRepo, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo, RubroRepository rubroRepo, ResultadoRepository resultadoRepo) :
                          _getCalendarioPerido = new GetCalendarioPerido(configuracionRepo, calendarioPeriodoRepo),
                          _getDatosCrearRubro = new UpdateDatosCrearRubro(httpDatosRepo, configuracionRepo, rubroRepo),
                          _getRubroEvaluacion = GetRubroEvaluacionList(rubroRepo),
                          _getUnidadRubroEval = GetUnidadRubroEval(rubroRepo),
                          _getCompetenciaRubroEval = GetCompetenciaRubroEval2(rubroRepo, configuracionRepo),
                          _getResultados = GetResultados(httpDatosRepo, configuracionRepo, resultadoRepo),
                          _updateCerrarSesion = UpdateCerrarCurso(configuracionRepo, httpDatosRepo),
                          _updateResultadoCurso = UpdateResultadoCurso(configuracionRepo, httpDatosRepo, rubroRepo),
                            _updateCalendarioPerido = UpdateCalendarioPerido(configuracionRepo, calendarioPeriodoRepo, httpDatosRepo);

  void updateCalendarioPerido(CursosUi? cursosUi){
    _updateCalendarioPerido.execute(_UpdateCalendarioPeriodoCase(this), UpdateCalendarioPeridoParams(cursosUi?.cargaCursoId??0));
  }

  void getCalendarioPerido(CursosUi? cursosUi, bool updateResultado){
    _getCalendarioPerido.execute(_GetCalendarioPeriodoCase(this, updateResultado), GetCalendarioPeridoParams(cursosUi?.cargaCursoId??0));
  }


  @override
  void dispose() {
      _getCalendarioPerido.dispose();
      _getDatosCrearRubro.dispose();
      _getRubroEvaluacion.dispose();
      _getUnidadRubroEval.dispose();
      _getCompetenciaRubroEval.dispose();
  }

  void onActualizarCurso(CalendarioPeriodoUI? calendarioPeriodoUI, CursosUi cursosUi) {
    for(var item in cancels){
      item.cancelar = true;
    }
    _getDatosCrearRubro.dispose();
    var params = UpdateDatosCrearRubroParams(calendarioPeriodoUI?.id??0, cursosUi.silaboEventoId??0, null,null, false, false, null);
    cancels.add(params);
    _getDatosCrearRubro.execute(_GetDatosCrearRubroCase(this), params);
  }

  void onCancelarActualizarCurso() {
    for(var item in cancels){
      item.cancelar = true;
    }
    _getDatosCrearRubro.dispose();
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
    _getCompetenciaRubroEval.execute(GetCompetenciaRubroEvalCase(this), GetCompetenciaRubro2Params(calendarioPeriodoUI, cursosUi?.silaboEventoId, cursosUi?.cargaCursoId));
  }

  void getResultados(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI){
    _getResultados.dispose();
    _getResultados.execute(_GetResultadosCase(this), GetResultadosParams(cursosUi, calendarioPeriodoUI?.id));
  }

  Future<bool> onUpdateEstadoCursoCerrado(CursosUi cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI) async{
    var response = await _updateCerrarSesion.execute(cursosUi, calendarioPeriodoUI);
    UpdateCursoOnMessage(response.offline, response.success);
    return response.success??false;
  }

  Future<bool> updateResultado(CursosUi cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI)async {
    var response = await _updateResultadoCurso.execute(cursosUi, calendarioPeriodoUI);
    UpdateCursoOnMessage(response.offline, response.success);
    return response.success??false;
  }

}

class _GetCalendarioPeriodoCase extends Observer<GetCalendarioPeridoResponse>{
  RubroPresenter presenter;
  bool updateResultado;
  _GetCalendarioPeriodoCase(this.presenter, this.updateResultado);

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
    presenter.getCalendarioPeridoOnComplete(response?.calendarioPeriodoList, response?.calendarioPeriodoUI,updateResultado);
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

class GetCompetenciaRubroEvalCase extends Observer<GetCompetenciaRubro2Response>{
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
  void onNext(GetCompetenciaRubro2Response? response) {
    assert(presenter.getCompetenciaRubroEvalOnNext!=null);
    presenter.getCompetenciaRubroEvalOnNext(response?.competenciaUiList, response?.personaUiList, response?.evaluacionCompetenciaUiList, response?.evaluacionCalendarioPeriodoUiList, response?.tipoNotaUi);
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


class _UpdateCalendarioPeriodoCase extends Observer<UpdateCalendarioPeridoResponse>{
  RubroPresenter presenter;

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
    print("updateCalendarioPeridoOnComplete");
    assert(presenter.updateCalendarioPeridoOnComplete!=null);
    presenter.updateCalendarioPeridoOnComplete();
  }

}
