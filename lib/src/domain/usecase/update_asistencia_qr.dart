import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_qr_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/asistencia_qr_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class UploadAsistenciaQR{
  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;
  AsistenciaQRRepository asistenciaQRRepository;


  UploadAsistenciaQR(this.configuracionRepository, this.httpDatosRepository,
      this.asistenciaQRRepository);

  Future<HttpStream?> execute(AsistenciaQRUi? asistenciaQRUi, UploadSuccessListen listen) async{
    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
      return httpDatosRepository.uploadAsistenciaQR(urlServidorLocal, asistenciaQRUi?.codigo, asistenciaQRUi?.anio, asistenciaQRUi?.mes, asistenciaQRUi?.dia, asistenciaQRUi?.hora, asistenciaQRUi?.minuto,  asistenciaQRUi?.segundo,
              (sucess, value) async{
            if(sucess && value == 2){
              //asistenciaQRUi?.repetido = true;
              asistenciaQRUi?.guardado = true;
            }else if(sucess && (value??0) <= 0){
              asistenciaQRUi?.guardado = false;
            }else{
              asistenciaQRUi?.guardado = sucess;
            }
            await asistenciaQRRepository.updateAsistenciaQR(asistenciaQRUi);

            listen.call(sucess, asistenciaQRUi);

          });
  }

}

typedef UploadSuccessListen = void Function(bool success, AsistenciaQRUi? asistenciaQRUi);