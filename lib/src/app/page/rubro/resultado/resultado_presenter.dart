import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/resultado_respository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_calendario_periodo.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_resultados.dart';

class ResultadoPresenter extends Presenter{
  GetCalendarioPerido _getCalendarioPerido;
  late Function getCalendarioPeridoOnComplete, getCalendarioPeridoOnError;
  GetResultados _getResultados;
  late Function getResultadosOnComplete, getResultadosOnError;

  ResultadoPresenter(ConfiguracionRepository configuracionRepo, CalendarioPeriodoRepository calendarioPeriodoRepo, ResultadoRepository resultadoRepo, HttpDatosRepository httpDatosRepo):
        _getCalendarioPerido = GetCalendarioPerido(configuracionRepo, calendarioPeriodoRepo),
        _getResultados = GetResultados(httpDatosRepo, configuracionRepo, resultadoRepo);

  void getCalendarioPerido(CursosUi? cursosUi){
    _getCalendarioPerido.execute(_GetCalendarioPeriodoCase(this), GetCalendarioPeridoParams(cursosUi?.cargaCursoId??0));
  }

  void getResultados(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI){
    _getResultados.execute(_GetResultadosCase(this), GetResultadosParams(cursosUi, calendarioPeriodoUI?.id));
  }

  @override
  void dispose() {
    _getCalendarioPerido.dispose();
  }

}

class _GetCalendarioPeriodoCase extends Observer<GetCalendarioPeridoResponse>{
  ResultadoPresenter presenter;

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
    print("getCalendarioPeridoOnCompletevi");
    assert(presenter.getCalendarioPeridoOnComplete!=null);
    presenter.getCalendarioPeridoOnComplete(response?.calendarioPeriodoList, response?.calendarioPeriodoUI);
  }

}

class _GetResultadosCase extends Observer<GetResultadosResponse>{
  ResultadoPresenter presenter;

  _GetResultadosCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getResultadosOnError!=null);
    presenter.getResultadosOnError(e);
  }

  @override
  void onNext(GetResultadosResponse? response) {
    print("getCalendarioPeridoOnCompletevi");
    assert(presenter.getResultadosOnComplete!=null);
    presenter.getResultadosOnComplete(response?.matrizResultadoUi, response?.offlineServidor, response?.errorServidor);
  }

}