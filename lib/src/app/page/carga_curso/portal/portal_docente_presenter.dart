import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/programa_educativo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_anio_academico.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_cursos.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_contacto_docente.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_programas_educativos.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_usuario.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_session_anio_academico.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_session_programa_academico.dart';

class PortalDocentePresenter extends Presenter{
  late Function getUserOnNext, getUserOnComplete, getUserOnError;
  GetSessionUsuarioCase _getSessionUsuario;
  GetAnioAcademico _getAnioAcademico;
  late Function getAnioAcadOnComplete, getAnioAcadOnError;
  UpdateProgramasEducativos _updateProgramasEducativos;
  late Function getProgramasEducativosOnComplete, getProgramasEducativosOnError;
  GetCursos _getCursos;
  late Function getCursosOnComplete, getCursosOnError;
  UpdateSessionAnioAcademico _updateSessionAnioAcademico;
  UpdateSessionProgramaAcademico _updateSessionProgramaAcademico;
  UpdateContactoDocente _updateContactoDocente;
  late Function updateContactoDocenteoOnError, updateContactoDocenteOnComplete;

  PortalDocentePresenter(ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo)
      : this._getSessionUsuario = new GetSessionUsuarioCase(configuracionRepo), _getAnioAcademico = new GetAnioAcademico(configuracionRepo),
        _updateProgramasEducativos = new UpdateProgramasEducativos(configuracionRepo, httpDatosRepo),
        _updateSessionAnioAcademico = new UpdateSessionAnioAcademico(configuracionRepo),
        _updateSessionProgramaAcademico = new UpdateSessionProgramaAcademico(configuracionRepo),
        _getCursos = new GetCursos(configuracionRepo),
        _updateContactoDocente  = UpdateContactoDocente(configuracionRepo, httpDatosRepo);

  @override
  void dispose() {
    _getSessionUsuario.dispose();
    //_updateContactoDocente.dispose();
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

  void getCursos(ProgramaEducativoUi? programaEducativoUi){
    _getCursos.execute(_GetCursosCase(this), GetCursosParams(programaEducativoUi!=null?programaEducativoUi.idPrograma??0:0));
  }

  void updateSessionAnioAcademicoId(int anioAcademicoId) {
    _updateSessionAnioAcademico.execute(anioAcademicoId);
  }

  void updateSessionProgramaAcademicoId(int programaAcademicoId) {
    _updateSessionProgramaAcademico.execute(programaAcademicoId);
  }

  void updateContactoDocente(){
    _updateContactoDocente.execute(_UpdateContactoDocenteCase(this), UpdateContactoDocenteParams());
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
    presenter.getAnioAcadOnComplete(response?.georeferenciaUiList, response?.anioAcademicoUi);
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

class _UpdateContactoDocenteCase extends Observer<UpdateContactoDocenteResponse>{
  final PortalDocentePresenter presenter;

  _UpdateContactoDocenteCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {

  }

  @override
  void onNext(UpdateContactoDocenteResponse? response) {

  }

}