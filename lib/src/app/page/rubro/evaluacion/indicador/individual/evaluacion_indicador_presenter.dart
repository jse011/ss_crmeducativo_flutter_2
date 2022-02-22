import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_comentario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_evidencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/delete_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_rubro_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_usuario.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/save_rubro_comentario.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/save_rubro_evidencia.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_server_evaluacion_rubro.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/upload_file_rubro_evidencia.dart';

class EvaluacionIndicadorPresenter extends Presenter{
  GetRubroEvaluacion _getRubroEvaluacion;
  late Function getRubroEvaluacionOnError, getRubroEvaluacionOnNext;
  UpdateEvaluacion _updateEvalaucionIndividual;
  UpdateServerEvaluacionRubro _updateServerEvaluacionRubro;
  DeleteEvaluacion _deleteEvaluacion;
  GetSessionUsuarioCase _getSessionUsuario;
  late Function getSessionUsuarioOnError, getSessionUsuarioOnNext;
  SaveRubroComentario _saveComentario;
  UploadFileRubroEvidencia _uploadFileRubroEvidencia;
  late Function uploadFileRubroEvidenciaOnSucces, uploadFileRubroEvidenciaOnProgress;
  SaveRubroEvidencia _saveRubroEvidencia;


  EvaluacionIndicadorPresenter(RubroRepository rubroRepo, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo):
        _getRubroEvaluacion = GetRubroEvaluacion(rubroRepo, configuracionRepo),
        _updateEvalaucionIndividual = UpdateEvaluacion(rubroRepo, configuracionRepo),
        _updateServerEvaluacionRubro = UpdateServerEvaluacionRubro(configuracionRepo, httpDatosRepo, rubroRepo),
        _deleteEvaluacion = DeleteEvaluacion(rubroRepo, configuracionRepo),
        _getSessionUsuario = GetSessionUsuarioCase(configuracionRepo),
        _saveComentario =  SaveRubroComentario(configuracionRepo, rubroRepo),
        _uploadFileRubroEvidencia = UploadFileRubroEvidencia(configuracionRepo, httpDatosRepo),
        _saveRubroEvidencia = SaveRubroEvidencia(configuracionRepo, rubroRepo);

  void getRubroEvaluacion(String? rubroEvaluacionId, CursosUi? cursosUi ){
    _getRubroEvaluacion.execute(_GetRubroEvaluacionCase(this), GetRubroEvaluacionParms(rubroEvaluacionId, cursosUi?.cargaCursoId));
  }

  @override
  void dispose() {
    _getRubroEvaluacion.dispose();
  }

  void getSessionUsuario(){
    _getSessionUsuario.execute(_GetSessionUsuarioCase(this),GetSessionUsuarioCaseParams());
  }

  void updateEvaluacionAll(RubricaEvaluacionUi? rubricaEvaluacionUi) {
    _updateEvalaucionIndividual.execute(rubricaEvaluacionUi, null);
  }

  void updateEvaluacion(RubricaEvaluacionUi? rubricaEvaluacionUi, int? alumnoId) {
    _updateEvalaucionIndividual.execute(rubricaEvaluacionUi, alumnoId);
  }

  Future<UpdateServerEvaluacionRubroResponse> updateServer(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI, RubricaEvaluacionUi? rubricaEvaluacionUi) async{
    return  _updateServerEvaluacionRubro.execute(UpdateServerEvaluacionRubroParms(rubricaEvaluacionUi?.rubroEvaluacionId, calendarioPeriodoUI?.id, cursosUi?.silaboEventoId));
  }

  Future<void> deleteRubroEvaluacion(RubricaEvaluacionUi? rubricaEvaluacionUi) async{
    return _deleteEvaluacion.execute(rubricaEvaluacionUi);
  }

  Future<void> uploadComentario(RubroComentarioUi? rubroComentarioUi, EvaluacionUi? evaluacionUi) {
    return _saveComentario.execute(rubroComentarioUi);
  }

  Future<HttpStream?> uploadEvidencia(RubroEvidenciaUi rubroEvidenciaUi, CursosUi? cursosUi) async{
    return _uploadFileRubroEvidencia.execute(cursosUi?.silaboEventoId??0, rubroEvidenciaUi,  (progress){
      uploadFileRubroEvidenciaOnProgress( progress, rubroEvidenciaUi);
    },(success){
      uploadFileRubroEvidenciaOnSucces(success, rubroEvidenciaUi);
    });
  }

  Future<void> saveRubroEvidenciaUi(RubroEvidenciaUi? rubroEvidenciaUi) {
    return _saveRubroEvidencia.execute(rubroEvidenciaUi);
  }
}

class _GetRubroEvaluacionCase extends Observer<GetRubroEvaluacionResponse> {
  EvaluacionIndicadorPresenter presenter;

  _GetRubroEvaluacionCase(this.presenter);

  @override
  void onComplete() {

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

class _GetSessionUsuarioCase extends Observer<GetSessionUsuarioCaseResponse> {
  EvaluacionIndicadorPresenter presenter;

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
