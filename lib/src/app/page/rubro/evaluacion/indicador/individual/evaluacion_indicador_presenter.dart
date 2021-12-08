import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/delete_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_rubro_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_server_evaluacion_rubro.dart';

class EvaluacionIndicadorPresenter extends Presenter{
  GetRubroEvaluacion _getRubroEvaluacion;
  late Function getRubroEvaluacionOnError, getRubroEvaluacionOnNext;
  UpdateEvaluacion _updateEvalaucionIndividual;
  UpdateServerEvaluacionRubro _updateServerEvaluacionRubro;
  DeleteEvaluacion _deleteEvaluacion;

  EvaluacionIndicadorPresenter(RubroRepository rubroRepo, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo):
        _getRubroEvaluacion = GetRubroEvaluacion(rubroRepo, configuracionRepo),
        _updateEvalaucionIndividual = UpdateEvaluacion(rubroRepo, configuracionRepo),
        _updateServerEvaluacionRubro = UpdateServerEvaluacionRubro(configuracionRepo, httpDatosRepo, rubroRepo),
        _deleteEvaluacion = DeleteEvaluacion(rubroRepo, configuracionRepo);

  void getRubroEvaluacion(String? rubroEvaluacionId, CursosUi? cursosUi ){
    _getRubroEvaluacion.execute(_GetRubroEvaluacionCase(this), GetRubroEvaluacionParms(rubroEvaluacionId, cursosUi?.cargaCursoId));
  }

  @override
  void dispose() {
    _getRubroEvaluacion.dispose();
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
