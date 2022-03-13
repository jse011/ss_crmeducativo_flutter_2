import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_qr_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/asistencia_qr_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class UploadListaAsistenciaQR{
  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;
  AsistenciaQRRepository asistenciaQRRepository;


  UploadListaAsistenciaQR(this.configuracionRepository, this.httpDatosRepository,
      this.asistenciaQRRepository);

  Future<UploadListaAsistenciaQRResponse> execute(List<AsistenciaQRUi> asistenciaQRUiList) async{
    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();

    bool? success = false;
    bool offline = false;
    try{
      success = await httpDatosRepository.saveListaAsistenciaQR(urlServidorLocal, asistenciaQRUiList);
      if(success??false){
        for(AsistenciaQRUi asistenciaQRUi in asistenciaQRUiList){
          asistenciaQRUi.guardado = true;
          await asistenciaQRRepository.updateAsistenciaQR(asistenciaQRUi);
        }
      }

    }catch(e){
      offline = true;
    }
    return UploadListaAsistenciaQRResponse(success, offline );
  }

}

class UploadListaAsistenciaQRResponse{
  bool? success;
  bool? offline;

  UploadListaAsistenciaQRResponse(this.success, this.offline);
}