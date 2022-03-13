import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_qr_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_asistencia_qr_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/asistencia_qr_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_asistencia_qr_hoy.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_asistencia_qr_no_enviadas.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_fecha_actual_asistencia_qr.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/save_asistencia_qr.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_asistencia_qr.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_lista_asistencia_qr.dart';

class AsistenciaQRPresenter extends Presenter{
  GetFechaActualAsistenciaQR getFechaActualAsistenciaQR;
  late Function getFechaActualAsistenciaQROnError, getFechaActualAsistenciaQROnResponse;
  SaveAsistenciaQR saveAsistenciaQR;
  GetAsistenciaQRHoy getAsistenciaQRHoy;
  UploadAsistenciaQR _uploadAsistenciaQR;
  late Function uploadAsistenciaQROnSucces;
  GetAsistenciaQRNoEnviadas getAsistenciaQRNoEnviadas;
  UploadListaAsistenciaQR _uploadListaAsistenciaQR;
  late Function uploadListaAsistenciaQROnSuccess;

  AsistenciaQRPresenter(HttpDatosRepository httpDatosRepo, ConfiguracionRepository configuracionRepo, AsistenciaQRRepository asistenciaQRRepo):
        this.getFechaActualAsistenciaQR = GetFechaActualAsistenciaQR(configuracionRepo, httpDatosRepo),
        getAsistenciaQRHoy = GetAsistenciaQRHoy(asistenciaQRRepo, configuracionRepo),
        saveAsistenciaQR = SaveAsistenciaQR(configuracionRepo, asistenciaQRRepo),
        _uploadAsistenciaQR = UploadAsistenciaQR(configuracionRepo, httpDatosRepo, asistenciaQRRepo),
        getAsistenciaQRNoEnviadas = GetAsistenciaQRNoEnviadas(asistenciaQRRepo, configuracionRepo),
        _uploadListaAsistenciaQR = UploadListaAsistenciaQR(configuracionRepo, httpDatosRepo, asistenciaQRRepo);

  void getFecha(){
    getFechaActualAsistenciaQR.execute(_GetFechaActualAsistenciaQRCase(this), GetFechaActualAsistenciaQRParams());
  }

  Future<HttpStream?> uploadAsistenciaQR(AsistenciaQRUi? asistenciaQRUi){
    return _uploadAsistenciaQR.execute(asistenciaQRUi,
            (success, asistenciaQRUi) {
              uploadAsistenciaQROnSucces(success, asistenciaQRUi);
            });
  }


  @override
  void dispose() {
    getFechaActualAsistenciaQR.dispose();
  }

  Future<void> onSaveAsistencia(AsistenciaQRUi asistenciaQRUi) {
    return saveAsistenciaQR.execute(asistenciaQRUi);
  }

  Future<List<AsistenciaQRUi>> getAsistenciaUiHoy(DateTime? dateTime){
    return getAsistenciaQRHoy.execute(dateTime);
  }

  Future<List<GrupoAsistenciaQRUi>> existenAsistenciaNoEnviadas() async{

    return await getAsistenciaQRNoEnviadas.execute();
  }

  Future<bool> guardarListAsistenciaQR(List<AsistenciaQRUi> asistenciaQRList)async {
     var response = await _uploadListaAsistenciaQR.execute(asistenciaQRList);
     uploadListaAsistenciaQROnSuccess(response.success, response.offline);
     return response.success??false;
  }

}

class _GetFechaActualAsistenciaQRCase extends Observer<GetFechaActualAsistenciaQRResponse>{
  AsistenciaQRPresenter presenter;

  _GetFechaActualAsistenciaQRCase(this.presenter);

  @override
  void onComplete() {
    // TODO: implement onComplete
  }

  @override
  void onError(e) {
    assert(presenter.getFechaActualAsistenciaQROnError!=null);
    presenter.getFechaActualAsistenciaQROnError(e);
  }

  @override
  void onNext(GetFechaActualAsistenciaQRResponse? response) {
    assert(presenter.getFechaActualAsistenciaQROnResponse!=null);
    presenter.getFechaActualAsistenciaQROnResponse(response?.errorServidor, response?.offlineServidor, response?.dfechaServidor);
  }

}