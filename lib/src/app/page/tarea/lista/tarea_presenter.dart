import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_calendario_periodo.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_unidad_tarea.dart';

class TareaPresenter extends Presenter{

  GetCalendarioPerido _getCalendarioPerido;
  late Function getCalendarioPeridoOnComplete, getCalendarioPeridoOnError;
  UpdateUnidadTarea _getUnidadTarea;
  late Function getUnidadTareaOnComplete, getUnidadTareaOnError;

  TareaPresenter(ConfiguracionRepository configuracionRepo, CalendarioPeriodoRepository calendarioPeriodoRepo, HttpDatosRepository httpDatosRepo, UnidadTareaRepository unidadTareaRepo):
        _getCalendarioPerido = GetCalendarioPerido(configuracionRepo, calendarioPeriodoRepo),
        _getUnidadTarea = UpdateUnidadTarea(httpDatosRepo, configuracionRepo, unidadTareaRepo);

  @override
  void dispose() {
    _getCalendarioPerido.dispose();
    _getUnidadTarea.dispose();
  }

  void getCalendarioPerido(CursosUi? cursosUi){
    _getCalendarioPerido.execute(_GetCalendarioPeriodoCase(this), GetCalendarioPeridoParams(cursosUi?.cargaCursoId??0));
  }

  void getUnidadTarea(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI) {
    print("getUnidadTarea");

    _getUnidadTarea.execute(_GetUnidadTareaCase(this), GetUnidadTareaParams(calendarioPeriodoUI?.id, cursosUi?.silaboEventoId));
  }

}

class _GetCalendarioPeriodoCase extends Observer<GetCalendarioPeridoResponse>{
  TareaPresenter presenter;

  _GetCalendarioPeriodoCase(this.presenter);

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
    presenter.getCalendarioPeridoOnComplete(response?.calendarioPeriodoList, response?.calendarioPeriodoUI);
  }

}

class _GetUnidadTareaCase extends Observer<GetUnidadTareaResponse>{
  TareaPresenter presenter;

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

