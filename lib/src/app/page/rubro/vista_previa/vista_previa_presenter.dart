import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_competencia_rubro_eval_2.dart';

class VistaPreviaPresenter extends Presenter{
  GetCompetenciaRubroEval2 _getCompetenciaRubroEval;
  late Function getCompetenciaRubroEvalOnNext, getCompetenciaRubroEvalOnError;


  VistaPreviaPresenter(RubroRepository rubroRepo, ConfiguracionRepository configuracionRepo):
        _getCompetenciaRubroEval = GetCompetenciaRubroEval2(rubroRepo, configuracionRepo);


  void onGetCompetenciaRubroEval(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI){
    _getCompetenciaRubroEval.dispose();
    _getCompetenciaRubroEval.execute(GetCompetenciaRubroEvalCase(this), GetCompetenciaRubro2Params(calendarioPeriodoUI, cursosUi?.silaboEventoId, cursosUi?.cargaCursoId));
  }


  @override
  void dispose() {
    _getCompetenciaRubroEval.dispose();
  }

}

class GetCompetenciaRubroEvalCase extends Observer<GetCompetenciaRubro2Response>{
  VistaPreviaPresenter presenter;

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