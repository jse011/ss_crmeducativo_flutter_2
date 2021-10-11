import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_calendario_periodo.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_unidad_tarea.dart';

class SesionPresenter extends Presenter{

  UpdateUnidadTarea _getUnidadTarea;
  late Function getUnidadTareaOnComplete, getUnidadTareaOnError;

  SesionPresenter(ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo, UnidadTareaRepository unidadTareaRepo):
      _getUnidadTarea = UpdateUnidadTarea(httpDatosRepo, configuracionRepo, unidadTareaRepo),
        super();

  @override
  void dispose() {
    _getUnidadTarea.dispose();
  }

  void getUnidadTarea(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI) {
    print("getUnidadTarea");

    _getUnidadTarea.execute(_GetUnidadTareaCase(this), GetUnidadTareaParams(calendarioPeriodoUI?.id, cursosUi?.silaboEventoId));
  }
}


class _GetUnidadTareaCase extends Observer<GetUnidadTareaResponse>{
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
  void onNext(GetUnidadTareaResponse? response) {
    print("getCalendarioPeridoOnComplete");
    assert(presenter.getUnidadTareaOnComplete!=null);
    presenter.getUnidadTareaOnComplete(response?.unidadUiList, response?.datosOffline, response?.errorServidor);
  }

}


