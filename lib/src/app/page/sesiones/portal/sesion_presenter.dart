import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_sesion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_actividades_sesion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_aprendizaje_sesion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_rubro_evaluacion_sesion_list.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_datos_crear_rubros.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_sesion_tarea.dart';

class SesionPresenter extends Presenter{

  UpdateSesionTarea _getSesionTarea;
  late Function getUnidadTareaOnComplete, getUnidadTareaOnError;

  UpdateDatosCrearRubro _getDatosCrearRubro;
  late Function updateDatosCrearRubroOnNext, updateDatosCrearRubroOnError, updateAprendizajeOnNext;

  GetRubroEvaluacionSesionList _getSesionRubroEval;
  late Function getSesionRubroEvalOnNext, getSesionRubroEvalOnError;

  GetAprendizaje _getAprendizaje;
  late Function getAprendizajeOnNext, getAprendizajeOnError;

  GetActividadesSesion _getActividadesSesion;
  late Function getActividadesSesionOnNext, getActividadesSesionOnError;

  SesionPresenter(ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo, UnidadTareaRepository unidadTareaRepo, RubroRepository rubroRepo, UnidadSesionRepository unidadSesionRepo):
        _getSesionTarea = UpdateSesionTarea(httpDatosRepo, configuracionRepo, unidadTareaRepo),
        _getDatosCrearRubro = UpdateDatosCrearRubro(httpDatosRepo, configuracionRepo, rubroRepo),
        _getSesionRubroEval = GetRubroEvaluacionSesionList(rubroRepo),
        _getAprendizaje = GetAprendizaje(httpDatosRepo, configuracionRepo, unidadSesionRepo),
        _getActividadesSesion = GetActividadesSesion(httpDatosRepo, configuracionRepo, unidadSesionRepo),
        super();

  @override
  void dispose() {
    _getSesionTarea.dispose();
    _getDatosCrearRubro.dispose();
  }

  void getSesionTarea(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI, SesionUi sesionUi) {
    _getSesionTarea.execute(_GetUnidadTareaCase(this), GetSesionTareaParams(calendarioPeriodoUI?.id, cursosUi?.silaboEventoId, sesionUi.sesionAprendizajeId));
  }

  void onActualizarCurso(CalendarioPeriodoUI? calendarioPeriodoUI, CursosUi cursosUi, SesionUi sesionUi) {
    _getDatosCrearRubro.dispose();
    _getDatosCrearRubro.execute(_GetDatosCrearRubroCase(this), new UpdateDatosCrearRubroParams(calendarioPeriodoUI?.id??0, cursosUi.silaboEventoId??0, sesionUi, null, false, true));
  }

  void onGetSesionRubroEval(CursosUi cursosUi, CalendarioPeriodoUI calendarioPeriodoUI, SesionUi sesionUi) {

    _getSesionRubroEval.execute(_GetRubroEvaluacionCase(this), GetRubroEvaluacionSesionListParms(calendarioPeriodoUI.id, cursosUi.silaboEventoId, sesionUi.sesionAprendizajePadreId??0, sesionUi.sesionAprendizajeId??0));
  }

  void onGetCompetencias(SesionUi sesionUi) {
    _getAprendizaje.execute(_GetAprendizajeCase(this), GetAprendizajeParams(sesionUi.sesionAprendizajeId));
  }

  void onGetActividades(SesionUi sesionUi) {
    _getActividadesSesion.execute(GetActividadesSesionCase(this), GetActividadesSesionParams(sesionUi.sesionAprendizajeId));
  }

}


class _GetUnidadTareaCase extends Observer<GetSesionTareaResponse>{
  SesionPresenter presenter;

  _GetUnidadTareaCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getUnidadTareaOnError!=null);
    presenter.getUnidadTareaOnError(e);
  }

  @override
  void onNext(GetSesionTareaResponse? response) {
    print("getCalendarioPeridoOnComplete");
    assert(presenter.getUnidadTareaOnComplete!=null);
    presenter.getUnidadTareaOnComplete(response?.tareaUiList, response?.datosOffline, response?.errorServidor);
  }

}

class _GetDatosCrearRubroCase extends Observer<UpdateDatosCrearRubroResponse>{
  SesionPresenter presenter;

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

    if(response?.successAprendizaje??false){
      presenter.updateAprendizajeOnNext();
    }else{
      presenter.updateDatosCrearRubroOnNext(response?.errorConexion, response?.errorServidor);
    }
  }

}

class _GetRubroEvaluacionCase extends Observer<GetRubroEvaluacionSesionListResponse>{
  SesionPresenter presenter;

  _GetRubroEvaluacionCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getSesionRubroEvalOnError!=null);
    presenter.getSesionRubroEvalOnError(e);
  }

  @override
  void onNext(GetRubroEvaluacionSesionListResponse? response) {
    assert(presenter.getSesionRubroEvalOnNext!=null);
    presenter.getSesionRubroEvalOnNext(response?.rubricaEvaluacionList);
  }

}

class _GetAprendizajeCase extends Observer<GetAprendizajeResponse>{
  SesionPresenter presenter;

  _GetAprendizajeCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getAprendizajeOnError!=null);
    presenter.getAprendizajeOnError(e);
  }

  @override
  void onNext(GetAprendizajeResponse? response) {
    assert(presenter.getAprendizajeOnNext!=null);
    presenter.getAprendizajeOnNext(response?.errorServidor, response?.datosOffline, response?.competenciaUiList, response?.temaCriterioUiList, response?.sesionRecursoUiList);
  }

}

class GetActividadesSesionCase extends Observer<GetActividadesSesionResponse>{
  SesionPresenter presenter;

  GetActividadesSesionCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getAprendizajeOnError!=null);
    presenter.getActividadesSesionOnError(e);
  }

  @override
  void onNext(GetActividadesSesionResponse? response) {
    assert(presenter.getAprendizajeOnNext!=null);
    presenter.getActividadesSesionOnNext(response?.errorServidor, response?.datosOffline, response?.sesionUi?.actividadUiList, response?.sesionUi?.instrumentoEvaluacionUiList);
  }

}
