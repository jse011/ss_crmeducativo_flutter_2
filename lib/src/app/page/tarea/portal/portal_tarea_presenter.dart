import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_tarea_alumnoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_archivo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/delete_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/eliminar_tarea_docente.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_informacion_tarea.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_rubro_eval_tarea.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_rubro_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_url_download_tarea_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/procesar_tarea_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/publicar_tarea_docente.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/save_tarea_eval.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_datos_crear_rubros.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_server_evaluacion_rubro.dart';

class PortalTareaPresenter extends Presenter{
  GetInformacionTarea _getInformacionTarea;
  late Function getInformacionTareaOnComplete, getInformacionTareaOnError;
  PublicarTareaDocente _publicarTareaDocente;
  late Function publicarTareaOnMessage;
  EliminarTareaDocente _eliminarTareaDocente;
  late Function eliminarTareaOnMessage;
  GetRubroEvalTarea _getRubroEvaluacion;
  SaveTareaEval _saveTareaEval;
  late Function saveRubroEvaluacionSucces, saveRubroEvaluacionError;
  late Function saveRubroEvaluacionAllSucces, saveRubroEvaluacionAllError;
  GetUrlDownloadTareaEvaluacion _getUrlDownloadTareaEvaluacion;
  late Function getUrlDownloadTareaEvaluacionOnComplete, getUrlDownloadTareaEvaluacionOnError;
 
  UpdateDatosCrearRubro _getDatosCrearRubro;
  late Function updateDatosCrearRubroOnNext, updateDatosCrearRubroOnError;

  ProcesarTareaEvaluacion _procesarTareaEvaluacion;
  late Function procesarRubroEvaluacionSucces, procesarRubroEvaluacionError;
  PortalTareaPresenter(HttpDatosRepository httpDatosRepo, UnidadTareaRepository unidadTareaRepo, ConfiguracionRepository configuracionRepo, RubroRepository rubroRepo):
        _getInformacionTarea  = GetInformacionTarea(httpDatosRepo, unidadTareaRepo, configuracionRepo),
        _publicarTareaDocente = PublicarTareaDocente(httpDatosRepo, configuracionRepo, unidadTareaRepo),
        _eliminarTareaDocente = EliminarTareaDocente(httpDatosRepo, configuracionRepo, unidadTareaRepo, rubroRepo),
        _getDatosCrearRubro = UpdateDatosCrearRubro(httpDatosRepo, configuracionRepo, rubroRepo),
        _getRubroEvaluacion = GetRubroEvalTarea(rubroRepo, configuracionRepo),
        _saveTareaEval = SaveTareaEval(configuracionRepo,rubroRepo, httpDatosRepo),
        _procesarTareaEvaluacion = ProcesarTareaEvaluacion(configuracionRepo, rubroRepo, httpDatosRepo),
        _getUrlDownloadTareaEvaluacion = GetUrlDownloadTareaEvaluacion(configuracionRepo, httpDatosRepo, unidadTareaRepo);


  void getInformacionTarea(TareaUi? tareaUi, CursosUi? cursosUi, int? unidadEventoId){
    _getInformacionTarea.dispose();
    _getInformacionTarea.execute(_GetInformacionTareaCase(this), GetInformacionTareaParams(tareaUi, cursosUi?.cargaCursoId, cursosUi?.silaboEventoId, unidadEventoId));
  }

  @override
  void dispose() {
    _getInformacionTarea.dispose();
    _getDatosCrearRubro.dispose();
  }

  Future<bool> publicarTarea(TareaUi? tareaUi) async{
    var response = await _publicarTareaDocente.execute(tareaUi);
    publicarTareaOnMessage(response.offline);
    return response.success??false;
  }

  Future<bool> eliminarTarea(TareaUi? tareaUi)async{
    var response = await _eliminarTareaDocente.execute(tareaUi);
    eliminarTareaOnMessage(response.offline);
    return response.success??false;
  }

  void onActualizarRubro(CalendarioPeriodoUI? calendarioPeriodoUI, CursosUi? cursosUi, SesionUi? sesionUi, TareaUi? tareaUi) {
    _getDatosCrearRubro.execute(_GetDatosCrearRubroCase(this), new UpdateDatosCrearRubroParams(calendarioPeriodoUI?.id??0, cursosUi?.silaboEventoId??0, sesionUi, tareaUi?.tareaId, true, false, sesionUi?.programaIdSesionHoy));
  }

  Future<GetRubroEvalTareaResponse> getRubroEvaluacion(String? tareaId, CursosUi? cursosUi ){
    return _getRubroEvaluacion.execute(GetRubroEvalTareaParms(tareaId, cursosUi?.cargaCursoId));
  }


  Future<HttpStream?> updateEvalAlumnoUi(RubricaEvaluacionUi? rubricaEvaluacionUi, RubricaEvaluacionTareaAlumnoUi? rubricaEvaluacionTareaAlumnoUi, TareaUi? tareaUi, CalendarioPeriodoUI? calendarioPeriodoUI) {
    List<int?> personaIdList = [];
    personaIdList.add(rubricaEvaluacionTareaAlumnoUi?.tareaAlumnoUi?.personaUi?.personaId);
    return _saveTareaEval.execute(SaveTareaEvalParms(rubricaEvaluacionUi, personaIdList, rubricaEvaluacionTareaAlumnoUi?.rubricaEvaluacionUi?.rubroEvaluacionId, tareaUi, calendarioPeriodoUI), (response){
      if(response.success){
        saveRubroEvaluacionSucces(rubricaEvaluacionUi, rubricaEvaluacionTareaAlumnoUi);
      }else {
        saveRubroEvaluacionError(rubricaEvaluacionUi, rubricaEvaluacionTareaAlumnoUi, response.errorServidor, response.offline, response.errorInterno);
      }
    });
  }

  Future<HttpStream?> updateEvalAlumnoAll(RubricaEvaluacionUi? rubricaEvaluacionUi, TareaAlumnoUi? tareaAlumnoUi, TareaUi? tareaUi, CalendarioPeriodoUI? calendarioPeriodoUI) {
    List<int?> personaIdList = [];
    personaIdList.add(tareaAlumnoUi?.personaUi?.personaId);
    return _saveTareaEval.execute(SaveTareaEvalParms(rubricaEvaluacionUi, personaIdList, null, tareaUi, calendarioPeriodoUI), (response){
      if(response.success){
        saveRubroEvaluacionSucces(rubricaEvaluacionUi, null, tareaAlumnoUi);
      }else {
        saveRubroEvaluacionError(rubricaEvaluacionUi, null, tareaAlumnoUi, response.errorServidor, response.offline, response.errorInterno);
      }
    });
  }

  Future<HttpStream?> updateEvaluacionAll(RubricaEvaluacionUi? rubricaEvaluacionUi, List<TareaAlumnoUi> tareaAlumnoUiList, TareaUi? tareaUi, CalendarioPeriodoUI? calendarioPeriodoUI) {

    List<int?> personaIdList = [];
    for(TareaAlumnoUi tareaAlumnoUi in tareaAlumnoUiList){
      personaIdList.add(tareaAlumnoUi.personaUi?.personaId);
    }

    return _saveTareaEval.execute(SaveTareaEvalParms(rubricaEvaluacionUi, personaIdList, null, tareaUi, calendarioPeriodoUI), (response){
      if(response.success){
        saveRubroEvaluacionAllSucces(tareaAlumnoUiList);
      }else {
        print("saveRubroEvaluacionAllError :3 error");
        saveRubroEvaluacionAllError(tareaAlumnoUiList, response.errorServidor, response.offline, response.errorInterno);
      }
    });
  }

  Future<HttpStream?> procesarTareaEvaluacion(RubricaEvaluacionUi? rubricaEvaluacionUi, CalendarioPeriodoUI? calendarioPeriodoUI, TareaUi ? tareaUi) {
    print("procesarTareaEvaluacion");
    return _procesarTareaEvaluacion.execute(ProcesarTareaEvaluacionParms( calendarioPeriodoUI?.id, tareaUi?.silaboEventoId, tareaUi?.unidadAprendizajeId, rubricaEvaluacionUi?.rubroEvaluacionId, tareaUi?.tareaId), (response){
      if(response.success){
        procesarRubroEvaluacionSucces();
      }else {
        procesarRubroEvaluacionError(response.errorServidor, response.offline, response.errorInterno);
      }
    });
  }

  void getDriveIdTaraeaAlumnoArchivo(TareaAlumnoArchivoUi tareaAlumnoArchivoUi, TareaUi? tareaUi) {
    _getUrlDownloadTareaEvaluacion.execute(GetUrlDownloadTareaEvalParams(tareaAlumnoArchivoUi, tareaUi), (response) {
      if(response.success){
        getUrlDownloadTareaEvaluacionOnComplete(response.tareaAlumnoArchivoUi);
      }else{
        getUrlDownloadTareaEvaluacionOnError(response.errorServidor, response.offline, response.errorInterno, response.tareaAlumnoArchivoUi);
      }
    });

  }




}


class _GetInformacionTareaCase extends Observer<GetInformacionTareaResponse>{
  PortalTareaPresenter presenter;

  _GetInformacionTareaCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getInformacionTareaOnError!=null);
    presenter.getInformacionTareaOnError(e);
  }

  @override
  void onNext(GetInformacionTareaResponse? response) {
    print("getInformacionTareaOnComplete");
    assert(presenter.getInformacionTareaOnComplete!=null);
    presenter.getInformacionTareaOnComplete(response?.tareaAlumnoUiList, response?.tareaRecusoUiList, response?.offlineServidor, response?.errorServidor);
  }

}

class _GetDatosCrearRubroCase extends Observer<UpdateDatosCrearRubroResponse>{
  PortalTareaPresenter presenter;

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