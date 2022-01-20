import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_sesion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_calendario_periodo.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_unidad_sesion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_sesion_estado.dart';

class SesionListaPresenter extends Presenter{
  GetCalendarioPerido _getCalendarioPerido;
  late Function getCalendarioPeridoOnComplete, getCalendarioPeridoOnError;
  GetUnidadSesion _getUnidadSesion;
  late Function getUnidadSesionDocenteOnComplete, getUnidadSesionDocenteOnError;
  UpdateSesionEstado _updateSesionEstado;
  late Function updateSesionEstadoOnMessage;

  SesionListaPresenter(ConfiguracionRepository configuracionRepo, CalendarioPeriodoRepository calendarioPeriodoRepo, HttpDatosRepository httpDatosRepo, UnidadSesionRepository unidadSesionRepo):
        _getCalendarioPerido = GetCalendarioPerido(configuracionRepo, calendarioPeriodoRepo),
        _getUnidadSesion = GetUnidadSesion(httpDatosRepo, configuracionRepo, unidadSesionRepo),
        _updateSesionEstado = UpdateSesionEstado(configuracionRepo, httpDatosRepo, unidadSesionRepo);

  void getCalendarioPerido(CursosUi? cursosUi){
    _getCalendarioPerido.execute(_GetCalendarioPeriodoCase(this), GetCalendarioPeridoParams(cursosUi?.cargaCursoId??0));
  }

  @override
  void dispose() {
      _getCalendarioPerido.dispose();
      _getUnidadSesion.dispose();
  }

  void getUnidadAprendizajeDocente(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI) {
    print("getUnidadAprendizajeDocente");
    _getUnidadSesion.execute(_GetUnidadSesionDocenteCase(this), GetUnidadSesionParams(calendarioPeriodoUI?.tipoId, cursosUi?.silaboEventoId, 0));
  }

  Future<bool> onUpdateSesionEstado(SesionUi? sesionUi)async {
     var response = await _updateSesionEstado.execute(sesionUi);
     updateSesionEstadoOnMessage(response.offline, response.success);
     return response.success??false;
  }

}

class _GetCalendarioPeriodoCase extends Observer<GetCalendarioPeridoResponse>{
  SesionListaPresenter presenter;

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

class _GetUnidadSesionDocenteCase extends Observer<GetUnidadSesionResponse>{
  SesionListaPresenter presenter;

  _GetUnidadSesionDocenteCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getUnidadSesionDocenteOnError!=null);
    presenter.getUnidadSesionDocenteOnError(e);
  }

  @override
  void onNext(GetUnidadSesionResponse? response) {
    print("getCalendarioPeridoOnComplete");
    assert(presenter.getUnidadSesionDocenteOnComplete!=null);
    presenter.getUnidadSesionDocenteOnComplete(response?.unidadUiList, response?.datosOffline, response?.errorServidor);
  }

}
