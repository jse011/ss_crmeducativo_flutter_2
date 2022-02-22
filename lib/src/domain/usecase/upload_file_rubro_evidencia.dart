import 'package:ss_crmeducativo_2/src/domain/entities/rubro_evidencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class UploadFileRubroEvidencia{

  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;

  UploadFileRubroEvidencia(this.configuracionRepository, this.httpDatosRepository);

  Future<HttpStream?> execute(int silaboEventoId, RubroEvidenciaUi rubroEvidenciaUi, UploadProgressListen listen, UploadSuccessListen successListen) async{
    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    if(rubroEvidenciaUi.file!=null && (rubroEvidenciaUi.file?.path??"").isNotEmpty){
      return httpDatosRepository.uploadFileRubroEvidencia(urlServidorLocal, rubroEvidenciaUi.titulo??"", rubroEvidenciaUi.file!, (progress) {
        listen.call(progress);
      }, (sucess, value){
          if(sucess){
            rubroEvidenciaUi.url = value;
          }
          successListen.call(sucess);
      });

    }else{
      return null;
    }

  }

}

typedef UploadProgressListen = void Function(double? progress);
typedef UploadSuccessListen = void Function(bool success);