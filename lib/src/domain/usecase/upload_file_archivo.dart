import 'package:ss_crmeducativo_2/src/domain/entities/tarea_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class UploadFileArchivo{

  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;

  UploadFileArchivo(this.configuracionRepository, this.httpDatosRepository);

  Future<HttpStream?> execute(int silaboEventoId, TareaRecusoUi tareaRecusoUi, UploadProgressListen listen, UploadSuccessListen successListen) async{
    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    if(tareaRecusoUi.file!=null && (tareaRecusoUi.file?.path??"").isNotEmpty){
      return httpDatosRepository.uploadFileArchivoDocente(urlServidorLocal, silaboEventoId, tareaRecusoUi.titulo??"", tareaRecusoUi.file!, (progress) {
        listen.call(progress);
      }, (sucess, value){
          if(sucess){
            tareaRecusoUi.driveId = value;
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