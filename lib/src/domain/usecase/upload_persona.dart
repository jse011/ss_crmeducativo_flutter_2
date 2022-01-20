
import 'dart:io';

import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class UploadPersona{

  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;

  UploadPersona(this.configuracionRepository, this.httpDatosRepository);

  Future<HttpStream?> execute(PersonaUi? personaUi, File? foto, bool soloCambiarFoto, bool removeFoto, UploadProgressListen listen, UploadSuccessListen successListen) async{
    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    return httpDatosRepository.uploadFilePersona(urlServidorLocal, personaUi, foto, soloCambiarFoto, removeFoto,(progress) {
      listen.call(progress);
    }, (sucess, value){
      if(sucess){

        PersonaUi newPersonaUi = configuracionRepository.transformarUpdatePersona(value);
        print("${newPersonaUi.toString()}");
        configuracionRepository.updatePersona(newPersonaUi);

        personaUi?.telefono = newPersonaUi.telefono;
        personaUi?.correo = newPersonaUi.correo;
        if((newPersonaUi.foto??"").isNotEmpty){
          personaUi?.foto = newPersonaUi.foto;
        }
      }
      successListen.call(sucess, personaUi);
    });

  }

}

typedef UploadProgressListen = void Function(double? progress);
typedef UploadSuccessListen = void Function(bool success, PersonaUi? personaUi);