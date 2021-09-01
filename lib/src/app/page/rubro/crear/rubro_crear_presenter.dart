import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/forma_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_forma_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_temas_criterio.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_tipo_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_tipo_nota.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/crear_server_rubro_evaluacion.dart';

class RubroCrearPresenter extends Presenter{

  GetFormaEvaluacion _getFormaEvaluacion;
  late Function getFormaEvaluacionOnNext, getFormaEvaluacionOnError;
  GetTipoEvaluacion _getTipoEvaluacion;
  late Function getTipoEvaluacionOnNext, getTipoEvaluacionOnError;
  GetTipoNota _getTipoNota;
  late Function getTipoNotaOnNext, getTipoNotaOnError;
  GetTemaCriterios _getTemaCriterios;
  late Function getTemaCriteriosOnNext, getTemaCriteriosOnError;
  CrearServerRubroEvaluacion _saveRubroEvaluacion;

  RubroCrearPresenter(RubroRepository rubroRepo, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo):
      _getFormaEvaluacion = new GetFormaEvaluacion(rubroRepo),
      _getTipoEvaluacion = new GetTipoEvaluacion(rubroRepo),
      _getTipoNota = new GetTipoNota(configuracionRepo, rubroRepo),
        _getTemaCriterios = new GetTemaCriterios(rubroRepo),
        _saveRubroEvaluacion = CrearServerRubroEvaluacion(configuracionRepo, rubroRepo, httpDatosRepo),
        super();

  getFormaEvaluacion(){
    _getFormaEvaluacion.execute(_GetFormaEvaluacionCase(this), GetFormaEvaluacionParams());
  }

  @override
  void dispose() {
   _getFormaEvaluacion.dispose();
   _getTipoEvaluacion.dispose();
   _getTipoNota.dispose();
   _getTemaCriterios.dispose();
   //_saveRubroEvaluacion.dispose();
  }

  void getTipoEvaluacion() {
    _getTipoEvaluacion.execute(_GetTipoEvaluacionCase(this), GetTipoEvaluacionParms());
  }

  void getTipoNota() {
    _getTipoNota.execute(_GetTipoNotaCase(this), GetTipoNotaParms());
  }

  void getTemaCriterios(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI){
    _getTemaCriterios.execute(_GetTemaCriteriosCase(this), GetTemaCriteriosParms(calendarioPeriodoUI?.id, cursosUi?.silaboEventoId));
  }

  Future<SaveRubroEvaluacionResponse> save(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI, String? tituloRubrica, FormaEvaluacionUi? formaEvaluacionUi, TipoEvaluacionUi? tipoEvaluacionUi, TipoNotaUi? tipoNotaUi, List<CriterioPesoUi> criterioPesoUiList, List<CriterioValorTipoNotaUi> criterioValorTipoNotaUiList) async{
    var response = await _saveRubroEvaluacion.execute(SaveRubroEvaluacionParms(null, tituloRubrica, formaEvaluacionUi?.id, tipoEvaluacionUi?.id, tipoNotaUi?.tipoNotaId, calendarioPeriodoUI?.id, cursosUi?.silaboEventoId, cursosUi?.cargaCursoId, null, null, criterioPesoUiList, criterioValorTipoNotaUiList, tipoNotaUi));
    return response;
  }

}

class _GetFormaEvaluacionCase extends Observer<GetFormaEvaluacionResponse>{
  RubroCrearPresenter presenter;

  _GetFormaEvaluacionCase(this.presenter);

  @override
  void onComplete() {
    // TODO: implement onComplete
  }

  @override
  void onError(e) {
    assert(presenter.getFormaEvaluacionOnError!=null);
    presenter.getFormaEvaluacionOnError(e);
  }

  @override
  void onNext(GetFormaEvaluacionResponse? response) {
    assert(presenter.getFormaEvaluacionOnNext!=null);
    presenter.getFormaEvaluacionOnNext(response?.formaEvaluacionUiList, response?.formaEvaluacionUi);
  }

}

class _GetTipoEvaluacionCase extends Observer<GetTipoEvaluacionResponse> {
  RubroCrearPresenter presenter;

  _GetTipoEvaluacionCase(this.presenter);

  @override
  void onComplete() {
    // TODO: implement onComplete
  }

  @override
  void onError(e) {
    assert(presenter.getTipoEvaluacionOnError != null);
    presenter.getTipoEvaluacionOnError(e);
  }

  @override
  void onNext(GetTipoEvaluacionResponse? response) {
    assert(presenter.getTipoEvaluacionOnNext != null);
    presenter.getTipoEvaluacionOnNext(
        response?.tipoEvaluacionUiList, response?.tipoEvaluacionUi);
  }

}

class _GetTipoNotaCase extends Observer<GetTipoNotaResponse>{
  RubroCrearPresenter presenter;

  _GetTipoNotaCase(this.presenter);

  @override
  void onComplete() {
    // TODO: implement onComplete
  }

  @override
  void onError(e) {
    assert(presenter.getTipoNotaOnError!=null);
    presenter.getTipoNotaOnError(e);
  }

  @override
  void onNext(GetTipoNotaResponse? response) {
    assert(presenter.getTipoNotaOnNext!=null);
    presenter.getTipoNotaOnNext(response?.tipoNotaUiList, response?.tipoEvaluacionUi);
  }

}

class _GetTemaCriteriosCase extends Observer<GetTemaCriteriosResponse>{
  RubroCrearPresenter presenter;

  _GetTemaCriteriosCase(this.presenter);

  @override
  void onComplete() {
    // TODO: implement onComplete
  }

  @override
  void onError(e) {
    assert(presenter.getTemaCriteriosOnError!=null);
    presenter.getTemaCriteriosOnError(e);
  }

  @override
  void onNext(GetTemaCriteriosResponse? response) {
    assert(presenter.getTemaCriteriosOnNext!=null);
    presenter.getTemaCriteriosOnNext(response?.competenciaUiList);
  }

}
