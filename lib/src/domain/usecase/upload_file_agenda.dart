import 'package:ss_crmeducativo_2/src/domain/entities/evento_adjunto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class UploadFileAgenda {

  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;

  UploadFileAgenda(this.configuracionRepository, this.httpDatosRepository);

  Future<HttpStream?> execute(EventoAdjuntoUi? eventoAdjuntoUi, UploadProgressListen listen, UploadSuccessListen successListen) async{
    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    if(eventoAdjuntoUi?.file!=null){
      return httpDatosRepository.uploadFileAgendaDocente(urlServidorLocal, eventoAdjuntoUi?.titulo??"", eventoAdjuntoUi!.file!, (progress) {
        listen.call(progress);
      }, (sucess, value){
        if(sucess){
          eventoAdjuntoUi.driveId = value;
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