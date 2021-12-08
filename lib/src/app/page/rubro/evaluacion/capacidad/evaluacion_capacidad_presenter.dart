import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_cursos.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_tipo_nota_resultado.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_evaluacion_capacidad.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_peso_rubro.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_server_evaluacion_capacidad.dart';

class EvaluacionCapacidadPresenter extends Presenter {
  GetTipoNotaResultado _getTipoNotaResultado;
  late Function getTipoNotaResultadoOnNext, getTipoNotaResultadoEvalOnError;
  UpdateEvaluacionCapacidad _updateEvaluacion;
  UpdatePesoRubro _updatePesoRubro;
  UpdateServerEvaluacionCompetencia _updateServerEvaluacionCompetencia;

  EvaluacionCapacidadPresenter( ConfiguracionRepository configuracionRepo, RubroRepository rubroRepo, HttpDatosRepository httpDatosRepo)
      : _updateEvaluacion = UpdateEvaluacionCapacidad(rubroRepo, configuracionRepo, httpDatosRepo),
        _updatePesoRubro = UpdatePesoRubro(rubroRepo, configuracionRepo),
        _getTipoNotaResultado = GetTipoNotaResultado(rubroRepo),
        _updateServerEvaluacionCompetencia = UpdateServerEvaluacionCompetencia(configuracionRepo, httpDatosRepo, rubroRepo);

  @override
  void dispose() {
    _getTipoNotaResultado.dispose();
  }

  getTipoNotaResultado(CursosUi? cursosUi){
    _getTipoNotaResultado.execute(GetTipoNotaResultadoCase(this), GetTipoNotaResultadoParms(cursosUi?.silaboEventoId));
  }

  Future<void> updatePesoRubroEvaluacion(RubricaEvaluacionUi? rubricaEvaluacionUi) {
    return _updatePesoRubro.execute(rubricaEvaluacionUi);
  }

  Future<void> updateEvaluacion(RubricaEvaluacionUi? rubroEvaluacionUiDetalle, PersonaUi? personaUi) {
    return _updateEvaluacion.execute(rubroEvaluacionUiDetalle, personaUi);
  }

  Future<void> updateServer(List<String?> rubroEvaluacionIdList) {
    return _updateServerEvaluacionCompetencia.execute(UpdateServerEvaluacionRubroParms(rubroEvaluacionIdList));
  }


}

class GetTipoNotaResultadoCase extends Observer<GetTipoNotaResultadoResponse>{
  EvaluacionCapacidadPresenter presenter;

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