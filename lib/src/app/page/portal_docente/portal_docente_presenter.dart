import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/programa_educativo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_anio_academico.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_cursos.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_programas_educativos.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_usuario.dart';

class PortalDocentePresenter extends Presenter{
  late Function getUserOnNext, getUserOnComplete, getUserOnError;
  GetSessionUsuarioCase _getSessionUsuario;
  GetAnioAcademico _getAnioAcademico;
  late Function getAnioAcadOnComplete, getAnioAcadOnError;
  UpdateProgramasEducativos _updateProgramasEducativos;
  late Function getProgramasEducativosOnComplete, getProgramasEducativosOnError;
  GetCursos _getCursos;
  late Function getCursosOnComplete, getCursosOnError;

  PortalDocentePresenter(ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo)
      : this._getSessionUsuario = new GetSessionUsuarioCase(configuracionRepo), _getAnioAcademico = new GetAnioAcademico(configuracionRepo),
        _updateProgramasEducativos = new UpdateProgramasEducativos(configuracionRepo, httpDatosRepo),
        _getCursos = new GetCursos(configuracionRepo);

  @override
  void dispose() {
    _getSessionUsuario.dispose();
  }

  void getUsuario(){
    _getSessionUsuario.execute(_GetSessionUsuarioCase(this), GetSessionUsuarioCaseParams());
  }

  void getAnioAcademico(){
    _getAnioAcademico.execute(_GetAnioAcademicoCase(this), GetAnioAcademicoParams());
  }

  void updateProgramaEducativo(){
    _updateProgramasEducativos.execute(_GetProgramaEducativoCase(this), GetProgramasEducativosParams());
  }

  void getCursos(ProgramaEducativoUi programaEducativoUi){
    _getCursos.execute(_GetCursosCase(this), GetCursosParams(programaEducativoUi!=null?programaEducativoUi.idPrograma??0:0));
  }

}

class _GetSessionUsuarioCase extends Observer<GetSessionUsuarioCaseResponse>{
  final PortalDocentePresenter presenter;

  _GetSessionUsuarioCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getUserOnComplete != null);
    presenter.getUserOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getUserOnError != null);
    presenter.getUserOnError(e);
  }

  @override
  void onNext(GetSessionUsuarioCaseResponse? response) {
    assert(presenter.getUserOnNext != null);
    presenter.getUserOnNext(response?.usuario);
  }

}

class _GetAnioAcademicoCase extends Observer<GetAnioAcademicoResponse>{
  final PortalDocentePresenter presenter;

  _GetAnioAcademicoCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getAnioAcadOnError != null);
    presenter.getAnioAcadOnError(e);
  }

  @override
  void onNext(GetAnioAcademicoResponse? response) {
    assert(presenter.getAnioAcadOnComplete != null);
    presenter.getAnioAcadOnComplete(response?.anioAcademicoList, response?.anioAcademicoUi);
  }

}

class _GetProgramaEducativoCase extends Observer<GetProgramasEducativosResponse>{
  final PortalDocentePresenter presenter;

  _GetProgramaEducativoCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getProgramasEducativosOnError != null);
    presenter.getAnioAcadOnError(e);
  }

  @override
  void onNext(GetProgramasEducativosResponse? response) {
    assert(presenter.getProgramasEducativosOnComplete != null);
    presenter.getProgramasEducativosOnComplete(response?.programaEducativoUi, response?.programaEducativoUiList, response?.datosOffline, response?.errorServidor);

  }

}

class _GetCursosCase extends Observer<GetCursosResponse>{
  final PortalDocentePresenter presenter;

  _GetCursosCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getCursosOnError != null);
    presenter.getCursosOnError(e);
  }

  @override
  void onNext(GetCursosResponse? response) {
    assert(presenter.getCursosOnComplete != null);
    presenter.getCursosOnComplete(response?.cursolist);

  }

}