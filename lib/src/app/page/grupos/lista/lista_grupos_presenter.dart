import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/grupo_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_listas_grupos.dart';

class ListaGruposPresenter extends Presenter{
  GetListaGrupos _getListaGrupos;
  late Function getListaGruposError, getListaGruposComplete;


  ListaGruposPresenter( GrupoRepository repository, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo):
        _getListaGrupos = GetListaGrupos(repository, configuracionRepo, httpDatosRepo);

  @override
  void dispose() {
    _getListaGrupos.dispose();
  }

  void getListaGrupos(CursosUi? cursosUi, bool? sincronizar) {
    _getListaGrupos.execute(_GetAlumnoCursoCase(this), GetListaGruposParams(cursosUi?.cargaAcademicaId, cursosUi?.cargaCursoId, sincronizar));
  }

}

class _GetAlumnoCursoCase extends Observer<GetListaGruposResponse>{
  final ListaGruposPresenter presenter;

  _GetAlumnoCursoCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getListaGruposError != null);
    presenter.getListaGruposError(e);
  }

  @override
  void onNext(GetListaGruposResponse? response) {
    assert(presenter.getListaGruposComplete != null);
    presenter.getListaGruposComplete(response?.offlineServidor, response?.errorServidor, response?.listaGrupoUiList);

  }

}