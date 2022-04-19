import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

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
  Map<PersonaUi?, HttpStream?> https = new Map();
  bool _conexion = true;
  bool get conexion => _conexion;
  String? _mensaje = null;
  String? get mensaje => _mensaje;

  FotoAlumnoController(this.cursosUi, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo):
          presenter = FotoAlumnoPresenter(configuracionRepo, httpDatosRepo);

  @override
  void initListeners() {
    presenter.updateContactoDocenteOnComplete = (bool? datosOffline,bool? errorServidor){
      presenter.getFotoAlumnos();
      if(datosOffline??false){
        _conexion = false;
      }else if(errorServidor??false){
        _conexion = false;
      }else{
        _conexion = true;
      }
      refreshUI();
    };
    presenter.updateContactoDocenteOnError = (e){
      _progress = false;
      _conexion = false;
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

    presenter.uploadPersonaOnProgress = (double? progress, PersonaUi? personaUi){
      personaUi?.progressCount = progress;
      refreshUI();
    };

    presenter.uploadPersonaOnSucces = (bool? sucess, PersonaUi? personaUi){
      personaUi?.progress = false;
      if(personaUi?.fileFoto == null){
        personaUi?.success = null;
      }else{
        personaUi?.success = sucess;
      }

      if(!(sucess??false)){
        if(personaUi?.fileFoto!=null){
          _mensaje = "Error al subir la foto";
        }else{
          _mensaje = "Error al borrar la foto";
        }
      }else{
        personaUi?.fileFoto = null;
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

  void _updateImage(FileFoto? fileFoto)async {
    _personaUiSelected?.success = null;
    _personaUiSelected?.progress = true;
    _personaUiSelected?.progressCount = 1;
    refreshUI();
    if(_personaUiSelected!=null&&fileFoto != null){
      _personaUiSelected?.fileFoto = fileFoto;
      https[_personaUiSelected] = await presenter.onUpdate(_personaUiSelected, fileFoto, true, false);
    }else{
      _personaUiSelected?.progress = false;
      _mensaje = "Error desconocido";
      refreshUI();
      return null;
    }
  }

  void updateImage(File? file)async {
    FileFoto fileFoto = FileFoto();
    fileFoto.file = file;
    _updateImage(fileFoto);
  }

 void onClickRemoverFotoPersona(PersonaUi? personaUi) async{
   personaUi?.progress = true;
   personaUi?.success = null;
   personaUi?.progressCount = 0;
   personaUi?.fileFoto = null;
    refreshUI();
    https[personaUi] = await presenter.onUpdate(personaUi, null, true, true);
  }

  void cerrarProgress() {
    _progress = false;
    refreshUI();
  }

  void onClickGuardarVerMasTarde() {

  }

  void successMsg() {
    _mensaje = null;
  }

  void reintentarSubirFoto(PersonaUi o) {
    _personaUiSelected = o;
    _updateImage(o.fileFoto);
  }

  void updateImageCrop(Uint8List? image) {
    FileFoto fileFoto = FileFoto();
    fileFoto.filebyte = image;
    _updateImage(fileFoto);
  }


}