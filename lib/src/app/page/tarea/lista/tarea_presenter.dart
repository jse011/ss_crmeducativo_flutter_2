import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_calendario_periodo.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_unidad_tarea.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_unidad_tarea.dart';

class TareaPresenter extends Presenter{

  GetCalendarioPerido _getCalendarioPerido;
  late Function getCalendarioPeridoOnComplete, getCalendarioPeridoOnError;
  UpdateUnidadTarea _updateUnidadTarea;
  late Function updateUnidadTareaOnComplete, updateUnidadTareaOnError;
  GetUnidadTarea _getUnidadTarea;
  late Function getUnidadTareaOnComplete, getUnidadTareaOnError;

  TareaPresenter(ConfiguracionRepository configuracionRepo, CalendarioPeriodoRepository calendarioPeriodoRepo, HttpDatosRepository httpDatosRepo, UnidadTareaRepository unidadTareaRepo):
        _getCalendarioPerido = GetCalendarioPerido(configuracionRepo, calendarioPeriodoRepo),
        _updateUnidadTarea = UpdateUnidadTarea(httpDatosRepo, configuracionRepo, unidadTareaRepo),
        _getUnidadTarea = GetUnidadTarea(unidadTareaRepo);

  @override
  void dispose() {
    _getCalendarioPerido.dispose();
    _updateUnidadTarea.dispose();
  }

  void getCalendarioPerido(CursosUi? cursosUi){
    _getCalendarioPerido.execute(_GetCalendarioPeriodoCase(this), GetCalendarioPeridoParams(cursosUi?.cargaCursoId??0));
  }

  void updateUnidadTarea(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI) {
    _updateUnidadTarea.execute(_UpdateUnidadTareaCase(this), UpdateUnidadTareaParams(calendarioPeriodoUI?.id, cursosUi?.silaboEventoId));
  }

  void getUnidadTarea(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI) {
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

class _UpdateUnidadTareaCase extends Observer<UpdateUnidadTareaResponse>{
  TareaPresenter presenter;

  _UpdateUnidadTareaCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.updateUnidadTareaOnError!=null);
    presenter.updateUnidadTareaOnError(e);
  }

  @override
  void onNext(UpdateUnidadTareaResponse? response) {
    print("updateUnidadTareaOnComplete");
    assert(presenter.updateUnidadTareaOnComplete!=null);
    presenter.updateUnidadTareaOnComplete(response?.datosOffline, response?.errorServidor);
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
    assert(presenter.getUnidadTareaOnComplete!=null);
    presenter.getUnidadTareaOnComplete(response?.eventoUIList);
  }

}

