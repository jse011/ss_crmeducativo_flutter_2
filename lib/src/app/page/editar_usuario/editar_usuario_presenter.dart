import 'dart:io';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/upload_persona.dart';
class EditarUsuarioPresenter extends Presenter{
  UploadPersona uploadPersona;
  late Function uploadPersonaOnSucces, uploadPersonaOnProgress;

  EditarUsuarioPresenter(ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo):
        uploadPersona = UploadPersona(configuracionRepo, httpDatosRepo);


  @override
  void dispose() {

  }

  void onUpdate(PersonaUi? personaUi, File? file, bool soloCambiarFoto, bool removeFoto) {
    uploadPersona.execute(personaUi, file, soloCambiarFoto, removeFoto, (progress) {
      uploadPersonaOnProgress(progress);
    }, (success, personaUI) {
      uploadPersonaOnSucces(success, personaUI);
    });
  }

}