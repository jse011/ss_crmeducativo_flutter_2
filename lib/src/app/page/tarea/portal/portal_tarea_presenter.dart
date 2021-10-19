import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/eliminar_tarea_docente.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_informacion_tarea.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/publicar_tarea_docente.dart';

class PortalTareaPresenter extends Presenter{
  GetInformacionTarea _getInformacionTarea;
  late Function getInformacionTareaOnComplete, getInformacionTareaOnError;
  PublicarTareaDocente _publicarTareaDocente;
  late Function publicarTareaOnMessage;
  EliminarTareaDocente _eliminarTareaDocente;
  late Function eliminarTareaOnMessage;
  PortalTareaPresenter(HttpDatosRepository httpDatosRepo, UnidadTareaRepository unidadTareaRepo, ConfiguracionRepository configuracionRepo):
        _getInformacionTarea  = GetInformacionTarea(httpDatosRepo, unidadTareaRepo, configuracionRepo),
        _publicarTareaDocente = PublicarTareaDocente(httpDatosRepo, configuracionRepo, unidadTareaRepo),
        _eliminarTareaDocente = EliminarTareaDocente(httpDatosRepo, configuracionRepo, unidadTareaRepo);

  void getInformacionTarea(TareaUi? tareaUi, String? rubroEvaluacionId, CursosUi? cursosUi, int? unidadEventoId){
    _getInformacionTarea.execute(_GetInformacionTareaCase(this), GetInformacionTareaParams(tareaUi, rubroEvaluacionId, cursosUi?.cargaCursoId, cursosUi?.silaboEventoId, unidadEventoId));
  }

  @override
  void dispose() {
    _getInformacionTarea.dispose();
  }

  Future<bool> publicarTarea(TareaUi? tareaUi) async{
    var response = await _publicarTareaDocente.execute(tareaUi);
    publicarTareaOnMessage(response.offline);
    return response.success??false;
  }

  Future<bool> eliminarTarea(TareaUi? tareaUi)async{
    var response = await _eliminarTareaDocente.execute(tareaUi);
    eliminarTareaOnMessage(response.offline);
    return response.success??false;
  }
}

class _GetInformacionTareaCase extends Observer<GetInformacionTareaResponse>{
  PortalTareaPresenter presenter;

  _GetInformacionTareaCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getInformacionTareaOnError!=null);
    presenter.getInformacionTareaOnError(e);
  }

  @override
  void onNext(GetInformacionTareaResponse? response) {
    print("getInformacionTareaOnComplete");
    assert(presenter.getInformacionTareaOnComplete!=null);
    presenter.getInformacionTareaOnComplete(response?.tareaAlumnoUiList, response?.tareaRecusoUiList, response?.offlineServidor, response?.errorServidor);
  }

}