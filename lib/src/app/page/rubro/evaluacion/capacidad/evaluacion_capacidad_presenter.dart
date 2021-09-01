import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_cursos.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_tipo_nota_resultado.dart';

class EvaluacionCapacidadPresenter extends Presenter {
  GetTipoNotaResultado _getTipoNotaResultado;
  late Function getTipoNotaResultadoOnNext, getTipoNotaResultadoEvalOnError;

  EvaluacionCapacidadPresenter(this._getTipoNotaResultado);

  @override
  void dispose() {
    _getTipoNotaResultado.dispose();
  }

  getTipoNotaResultado(CursosUi? cursosUi){
    _getTipoNotaResultado.execute(GetTipoNotaResultadoCase(this), GetTipoNotaResultadoParms(cursosUi?.silaboEventoId));
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