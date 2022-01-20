
import 'dart:io';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_foto_alumnos.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_contacto_docente.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/upload_persona.dart';

class FotoAlumnoPresenter extends Presenter{
  UpdateContactoDocente _updateContactoDocente;
  late Function updateContactoDocenteOnError, updateContactoDocenteOnComplete;
  GetFotoAlumnos _getFotoAlumnos;
  late Function getFotoAlumnosError, getFotoAlumnosComplete;
  UploadPersona uploadPersona;
  late Function uploadPersonaOnSucces, uploadPersonaOnProgress;


  FotoAlumnoPresenter(ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo):
        this._updateContactoDocente = UpdateContactoDocente(configuracionRepo, httpDatosRepo),
        _getFotoAlumnos = GetFotoAlumnos(configuracionRepo),
        uploadPersona = UploadPersona(configuracionRepo, httpDatosRepo);


  void updateContactosAlumno(){
    _updateContactoDocente.execute(_UpdateContactoDocenteCase(this), UpdateContactoDocenteParams());
  }

  void getFotoAlumnos(){
    _getFotoAlumnos.execute(_GetFotoAlumnosCase(this), GetFotoAlumnosCaseParams());
  }

  void onUpdate(PersonaUi? personaUi, File? file, bool soloCambiarFoto, bool removeFoto) {
    uploadPersona.execute(personaUi, file, soloCambiarFoto, removeFoto, (progress) {
      uploadPersonaOnProgress(progress);
    }, (success, personaUI) {
      uploadPersonaOnSucces(success, personaUI);
    });
  }



  @override
  void dispose() {
    _updateContactoDocente.dispose();
    _getFotoAlumnos.dispose();
  }

}

class _UpdateContactoDocenteCase extends Observer<UpdateContactoDocenteResponse>{
  final FotoAlumnoPresenter presenter;

  _UpdateContactoDocenteCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.updateContactoDocenteOnError!=null);
    presenter.updateContactoDocenteOnError(e);
  }

  @override
  void onNext(UpdateContactoDocenteResponse? response) {
    assert(presenter.updateContactoDocenteOnComplete!=null);
    presenter.updateContactoDocenteOnComplete(response?.datosOffline, response?.errorServidor);
  }

}

class _GetFotoAlumnosCase extends Observer<GetFotoAlumnosCaseResponse>{
  final FotoAlumnoPresenter presenter;

  _GetFotoAlumnosCase(this.presenter);

  @override
  void onComplete() {

  }

  @override
  void onError(e) {
    assert(presenter.getFotoAlumnosError!=null);
    presenter.getFotoAlumnosError(e);
  }

  @override
  void onNext(GetFotoAlumnosCaseResponse? response) {
    assert(presenter.getFotoAlumnosComplete!=null);
    presenter.getFotoAlumnosComplete(response?.cursoUiList);
  }

}