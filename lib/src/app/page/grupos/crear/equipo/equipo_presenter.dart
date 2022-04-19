import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_alumno_curso.dart';

class EquipoPresenter extends Presenter{

  GetAlumnoCurso _getAlumnoCurso;
  late Function getAlumnoCursoError, getAlumnoCursoComplete;


  EquipoPresenter(ConfiguracionRepository configuracionRepo):
        this._getAlumnoCurso = GetAlumnoCurso(configuracionRepo);

  void getAlumnoCurso(CursosUi? cursosUi){
    _getAlumnoCurso.execute(_GetAlumnoCursoCase(this), GetAlumnoCursoParams(cursosUi?.cargaCursoId));
  }

  @override
  void dispose() {
    _getAlumnoCurso.dispose();
  }

}

class _GetAlumnoCursoCase extends Observer<GetAlumnoCursoResponse>{
  final EquipoPresenter presenter;

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