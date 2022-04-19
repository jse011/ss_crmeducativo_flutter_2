import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/lista_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/grupo_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_alumno_curso.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_local_json.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/save_grupo.dart';

class GrupoPresenter extends Presenter{
  GetAlumnoCurso _getAlumnoCurso;
  late Function getAlumnoCursoError, getAlumnoCursoComplete;
  GetLocalJson getLocalJson;
  SaveGrupo _saveGrupo;

  GrupoPresenter(ConfiguracionRepository configuracionRepo, GrupoRepository grupoRepository, HttpDatosRepository httpDatosRepository):
        this._getAlumnoCurso = GetAlumnoCurso(configuracionRepo),
        this._saveGrupo = SaveGrupo(configuracionRepo, grupoRepository, httpDatosRepository),
        this.getLocalJson = GetLocalJson();

  void getAlumnoCurso(CursosUi? cursosUi){
    _getAlumnoCurso.execute(_GetAlumnoCursoCase(this), GetAlumnoCursoParams(cursosUi?.cargaCursoId));
  }

  Future<List<String>> getNombreAnimales() async {
    return getLocalJson.readAnimalesJson();
  }

  Future<SaveGrupoResponse> saveGrupo(ListaGrupoUi? listaGrupoUi){
    return _saveGrupo.execute(listaGrupoUi);
  }

  @override
  void dispose() {
    _getAlumnoCurso.dispose();
  }

  Future<List<String>> getNombreColores() async {
    return getLocalJson.readColoresJson();
  }

  Future<List<String>> getNombrePaises() async {
    return getLocalJson.readPaisesJson();
  }


}

class _GetAlumnoCursoCase extends Observer<GetAlumnoCursoResponse>{
  final GrupoPresenter presenter;

  _GetAlumnoCursoCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getAlumnoCursoError != null);
    presenter.getAlumnoCursoError(e);
  }

  @override
  void onNext(GetAlumnoCursoResponse? response) {
    assert(presenter.getAlumnoCursoComplete != null);
    presenter.getAlumnoCursoComplete(response?.contactoUiList);

  }

}