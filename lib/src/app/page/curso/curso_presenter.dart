import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_anio_academico.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_curso.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_cursos.dart';

class CursoPresenter extends Presenter {
  late GetCurso _getCurso;
  late Function getCursoOnComplete, getCursoOnError;

  CursoPresenter(ConfiguracionRepository configuracionRepository)
      : _getCurso = new GetCurso(configuracionRepository);

  @override
  void dispose() {
    _getCurso.dispose();
  }

  void getCursoParams(int cargaCursoId){
    _getCurso.execute(_GetCursoCase(this), GetCursoParams(cargaCursoId));
  }

}


class _GetCursoCase extends Observer<GetCursoResponse>{
  final CursoPresenter presenter;

  _GetCursoCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getCursoOnError != null);
    presenter.getCursoOnError(e);
  }

  @override
  void onNext(GetCursoResponse? response) {
    assert(presenter.getCursoOnComplete != null);
    presenter.getCursoOnComplete(response?.cursoUi);
  }

}
