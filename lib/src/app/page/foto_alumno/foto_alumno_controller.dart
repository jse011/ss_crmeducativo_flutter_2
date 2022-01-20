import 'dart:io';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/foto_alumno/foto_alumno_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class FotoAlumnoController extends Controller{
  CursosUi? cursosUi;
  FotoAlumnoPresenter presenter;
  bool _progress = false;
  bool get progress => _progress;
  List<CursosUi> _cursosUiList = [];
  List<CursosUi> get cursosUiList => _cursosUiList;
  CursosUi? _cursosUiSelected = null;
  CursosUi? get cursosUiSelected => _cursosUiSelected;
  List<PersonaUi> _personasUiList = [];
  List<PersonaUi> get personasUiList => _personasUiList;
  PersonaUi? _personaUiSelected = null;
  PersonaUi? get personaUiSelected => _personaUiSelected;
  File? _fotoFile = null;
  File? get fotoFile => _fotoFile;

  FotoAlumnoController(this.cursosUi, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo):
          presenter = FotoAlumnoPresenter(configuracionRepo, httpDatosRepo);

  @override
  void initListeners() {
    presenter.updateContactoDocenteOnComplete = (bool? datosOffline,bool? errorServidor){
      presenter.getFotoAlumnos();
    };
    presenter.updateContactoDocenteOnError = (e){
      _progress = false;
      presenter.getFotoAlumnos();
      refreshUI();
    };

    presenter.getFotoAlumnosComplete = (List<CursosUi>? cursosUiList){
      _progress = false;
      _cursosUiList = cursosUiList??[];
      if(_cursosUiList.isNotEmpty){
        _cursosUiSelected = _cursosUiList[0];
        _personasUiList = _cursosUiSelected?.alumnoUiList??[];
      }
      refreshUI();
    };

    presenter.getFotoAlumnosError = (e){
      _progress = false;
      refreshUI();
    };

    presenter.uploadPersonaOnProgress = (double? progress){

    };

    presenter.uploadPersonaOnSucces = (bool? sucess, PersonaUi? personaUi){
      _progress = false;
      if(sucess??false){
       _personaUiSelected = personaUi;
      }
      refreshUI();
    };

  }

  @override
  void onInitState() {
    _progress = true;
    refreshUI();
    presenter.updateContactosAlumno();
    super.onInitState();
  }

  void onSelectCursoUi(item) {
    _cursosUiSelected = item;
    _personasUiList = _cursosUiSelected?.alumnoUiList??[];
    refreshUI();
  }

  @override
  void onDisposed() {
    presenter.dispose();
    super.onDisposed();
  }

  void onClickEditarFotoAlumno(PersonaUi personaUi) {
    _personaUiSelected = personaUi;
  }

  void updateImage(File? image) {
    _progress = true;
    if(_personaUiSelected!=null){
      _fotoFile = image;
      presenter.onUpdate(_personaUiSelected, image, true, false);
    }
  }

  onClickRemoverFotoPersona(PersonaUi? personaUi) {
    _progress = true;
    presenter.onUpdate(_personaUiSelected, null, true, true);
  }

}