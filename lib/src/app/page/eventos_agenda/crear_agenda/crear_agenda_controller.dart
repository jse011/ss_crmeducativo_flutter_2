import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_adjunto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_lista_envio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/id_generator.dart';

import 'crear_agenda_presenter.dart';

class CrearAgendaController extends Controller{
  CrearAgendaPresenter presenter;
  EventoUi? eventoUi;
  CursosUi? cursosUi;
  String newEventoId = IdGenerator.generateId();
  bool _progress = false;
  String? _tituloEvento = null;
  String? get tituloEvento => _tituloEvento;
  String? _informacion = null;
  String? get informacion => _informacion;
  bool get progress => _progress;
  DateTime? _fechaEvento = null;
  DateTime? get fechaEvento => _fechaEvento;
  String? _horaEvento = null;
  String? get horaEvento => _horaEvento;
  List<EventoAdjuntoUi> _eventoAdjuntoUiList = [];
  List<EventoAdjuntoUi> get eventoAdjuntoUiList => _eventoAdjuntoUiList;
  List<dynamic> _personasUiList = [];
  List<dynamic> get personasUiList => _personasUiList;
  List<EventosListaEnvioUi> _eventosListaEnvioUiList = [];
  List<EventosListaEnvioUi> get eventosListaEnvioUiList => _eventosListaEnvioUiList;
  EventosListaEnvioUi? _eventosListaEnvioUi = null;
  EventosListaEnvioUi? get eventosListaEnvioUi => _eventosListaEnvioUi;
  bool _todosPadres = false;
  bool get todosPadres => _todosPadres;
  bool _todosAlumnos = false;
  bool get todosAlumnos => _todosAlumnos;
  String? _mensaje = null;
  String? get mensaje => _mensaje;
  String _nombresSelected = "";
  String get nombresSelected => _nombresSelected;

  Map<EventoAdjuntoUi, HttpStream?> mapRecurso = Map();

  CrearAgendaController(this.eventoUi, this.cursosUi, ConfiguracionRepository configuracionRepository, AgendaEventoRepository agendaEventoRepo, HttpDatosRepository httpDatosRepo):
            presenter = CrearAgendaPresenter(configuracionRepository, agendaEventoRepo, httpDatosRepo);

  @override
  void initListeners() {
    presenter.getAlumnosOnResponse = (List<EventosListaEnvioUi> salonUiList){
      _eventosListaEnvioUiList = salonUiList;
      print("cursosUi?.cargaCursoId ${cursosUi?.cargaCursoId}");
      for(EventosListaEnvioUi salonUi in salonUiList){
        if(cursosUi?.cargaCursoId!=null && salonUi.cargaCursoId == cursosUi?.cargaCursoId){
          _eventosListaEnvioUi = salonUi;
        }
        if(_eventosListaEnvioUi==null)_eventosListaEnvioUi = salonUi;
      }

      _personasUiList.clear();

      for(EventoPersonaUi personaUi in _eventosListaEnvioUi?.personasUiList??[]){
        _personasUiList.add(personaUi);
      }
      if(_personasUiList.isNotEmpty){
        _personasUiList.insert(0, _eventosListaEnvioUi?.nombre??"");
      }

      validarTodosPadre();
      validarTodosAlumno();
      changeNombresSelected ();

      refreshUI();
    };

    presenter.getAlumnosOnError = (e){
      _eventosListaEnvioUiList = [];
      _eventosListaEnvioUi = null;
      _personasUiList = [];
      refreshUI();
    };

    presenter.getCalendarioPeridoOnProgress = (double? progress,  EventoAdjuntoUi? eventoAdjuntoUi){
      eventoAdjuntoUi?.progress = progress;
      refreshUI();
    };

    presenter.getCalendarioPeridoOnSucces = (bool success, EventoAdjuntoUi? eventoAdjuntoUi){
      eventoAdjuntoUi?.success = success;
      if(!success){
        _mensaje = "Error al subir el archivo";
      }
      refreshUI();
    };

    presenter.saveEventoOnMessage = (bool offline){

    };

    _tituloEvento = eventoUi?.titulo;
    _informacion = eventoUi?.descripcion;
    _horaEvento = eventoUi?.horaEvento;
    _fechaEvento = eventoUi?.fechaEvento;
    _eventoAdjuntoUiList = eventoUi?.eventoAdjuntoUiList??[];

  }

  @override
  void onInitState() {
    super.onInitState();
    presenter.getAlumnos(eventoUi);
  }

  void clearTitulo() {
    _tituloEvento = null;
    refreshUI();
  }

  void changeTitulo(String str) {
    _tituloEvento = str;
    refreshUI();
  }

  void clearInformacion() {
    _informacion = null;
    refreshUI();
  }

  void changeInformacion(String str) {
    _informacion = str;
    refreshUI();
  }

  void changeFecha(DateTime? dateTime) {
    _fechaEvento = dateTime;
  }

  void changeHora(String? str) {
    _horaEvento = str;
  }

  void addEventoAdjunto(List<File?> files) async {
    for (File? file in files) {
      if (file != null) {
        EventoAdjuntoUi eventoAdjuntoUi = EventoAdjuntoUi();
        eventoAdjuntoUi.eventoAdjuntoId = IdGenerator.generateId();
        eventoAdjuntoUi.titulo = basename(file.path);
        eventoAdjuntoUi.tipoRecursosUi = DomainTools.getType(file.path);
        eventoAdjuntoUi.file = file;
        _eventoAdjuntoUiList.add(eventoAdjuntoUi);

        HttpStream? httpStream = await presenter.uploadEventoAdjuntoUi(eventoUi, eventoAdjuntoUi);
        mapRecurso[eventoAdjuntoUi] = httpStream;
      }
      refreshUI();
    }
  }


  void onClickTodosPadres() {
    _todosPadres = !_todosPadres;
    for(dynamic o in personasUiList){
      if(o is EventoPersonaUi){
        o.selectedPadre = _todosPadres;
      }
    }
    changeNombresSelected ();
    refreshUI();
  }

  @override
  void onDisposed() {
    presenter.dispose();
    super.onDisposed();
  }

  void onClickTodoAlumnos() {
    _todosAlumnos = !_todosAlumnos;
    for(dynamic o in personasUiList){
      if(o is EventoPersonaUi){
        o.selectedAlumno = _todosAlumnos;
      }
    }
    changeNombresSelected ();
    refreshUI();
  }

  void onClickAlumnoPadre(EventoPersonaUi eventoPersonaUi) {
    if(!(eventoPersonaUi.selectedAlumno??false) && !(eventoPersonaUi.selectedPadre??false)){
      eventoPersonaUi.selectedAlumno = true;
      eventoPersonaUi.selectedPadre = true;
    }else if(!(eventoPersonaUi.selectedAlumno??false) || !(eventoPersonaUi.selectedPadre??false)){
      eventoPersonaUi.selectedAlumno = false;
      eventoPersonaUi.selectedPadre = false;
    } else{
      eventoPersonaUi.selectedAlumno = false;
      eventoPersonaUi.selectedPadre = false;
    }
    validarTodosPadre();
    validarTodosAlumno();
    changeNombresSelected ();
    refreshUI();

  }

  void onClickAlumnoSoloPadres(EventoPersonaUi eventoPersonaUi) {
    eventoPersonaUi.selectedPadre = !(eventoPersonaUi.selectedPadre??false);
    validarTodosPadre();
    changeNombresSelected ();
    refreshUI();
  }

  void onClickAlumnoSoloAlumno(EventoPersonaUi eventoPersonaUi) {
    eventoPersonaUi.selectedAlumno = !(eventoPersonaUi.selectedAlumno??false);
    validarTodosAlumno();
    changeNombresSelected ();
    refreshUI();
  }

  void validarTodosPadre(){
    bool selecteAll = true;
    for(dynamic o in personasUiList){
      if(o is EventoPersonaUi){
        if(!(o.selectedPadre??false)){
          selecteAll = false;
          break;
        }

      }
    }
    _todosPadres = selecteAll;
  }
  void validarTodosAlumno(){
    bool selecteAll = true;
    for(dynamic o in personasUiList){
      if(o is EventoPersonaUi){
        if(!(o.selectedAlumno??false)){
          selecteAll = false;
          break;
        }

      }
    }
    _todosAlumnos = selecteAll;
  }

  void changeNombresSelected (){
    _nombresSelected = "";
    for (dynamic o in personasUiList){
      if(o is EventoPersonaUi){
        if((o.selectedAlumno??false) || (o.selectedPadre??false)){
          if(_nombresSelected.length >0)_nombresSelected += ", ";

          if((o.selectedPadre??false)&&!(o.selectedAlumno??false))_nombresSelected += "Los padres de ";
          _nombresSelected += "${o.personaUi?.apellidoPaterno} ${o.personaUi?.nombres}";
        }
      }
    }
  }

  Future<dynamic> onClickGuardarEvento() async{
    return guardarEvento(false);
  }

  Future<dynamic> onClickPublicarEvento() async{
    return guardarEvento(true);
  }

  Future<dynamic> guardarEvento(bool publicar) async{

    if((_tituloEvento??"").isEmpty){
      _mensaje = "Digite un título";
      refreshUI();
      return 0;//si es numerico  y 0 se contrae el panel
    }

    List<EventoPersonaUi> listaEnvio = [];
    for (dynamic o in personasUiList){
      if(o is EventoPersonaUi) if((o.selectedAlumno??false)||(o.selectedPadre??false))listaEnvio.add(o);
    }
    if(listaEnvio.isEmpty){
      _mensaje = "Seleccione a quien va dirigido";
      refreshUI();
      return 1;//si es numerico  y 1 se levanta el panel
    }
    bool subiendo_archivos = false;
    for(var archivos in mapRecurso.entries){
      HttpStream? httpStream = archivos.value;
      subiendo_archivos = httpStream!=null && !httpStream.isFinished();
    }
    if(subiendo_archivos){
      _mensaje = "Subida de recursos en progreso";
      refreshUI();
      return false;
    }

    if(eventoUi==null){

      EventoUi eventoUi = EventoUi();
      eventoUi.id = newEventoId;
      eventoUi.titulo = _tituloEvento;
      eventoUi.descripcion = informacion;
      eventoUi.fechaEvento = fechaEvento;
      eventoUi.horaEvento = horaEvento;
      eventoUi.publicado = publicar;
      eventoUi.eventoAdjuntoUiList = eventoAdjuntoUiList;
      eventoUi.listaEnvioUi = eventosListaEnvioUi;
      eventoUi.cargaCursoId = cursosUi?.cargaCursoId;
      _progress = true;
      refreshUI();

      bool respuesta = await presenter.saveAgendaDocente(eventoUi, false);
      if(!respuesta) _mensaje = "Error al guardar";
      _progress = false;
      refreshUI();
      return respuesta;

    }else{

      eventoUi?.titulo = _tituloEvento;
      eventoUi?.descripcion = informacion;
      eventoUi?.fechaEvento = fechaEvento;
      eventoUi?.horaEvento = horaEvento;
      eventoUi?.publicado = publicar;
      eventoUi?.eventoAdjuntoUiList = eventoAdjuntoUiList;
      eventoUi?.listaEnvioUi = eventosListaEnvioUi;
      _progress = false;
      refreshUI();

      bool respuesta = await presenter.saveAgendaDocente(eventoUi, true);
      if(!respuesta) _mensaje = "Error al actualizar";
      _progress = false;
      refreshUI();
      return respuesta;
    }



  }

  void successMsg() {
    _mensaje = null;
  }

  void removeEventoAdjuntoUi(EventoAdjuntoUi eventoAdjuntoUi) {
    if(eventoAdjuntoUi.success == null){
      if(mapRecurso.containsKey(eventoAdjuntoUi)){
        HttpStream? httpStream = mapRecurso[eventoAdjuntoUi];
        httpStream?.cancel();
        mapRecurso.remove(eventoAdjuntoUi);
      }
    }
    _eventoAdjuntoUiList.remove(eventoAdjuntoUi);

    refreshUI();
  }

  void refreshEventoAdjuntoUi(EventoAdjuntoUi eventoAdjuntoUi) async {
    eventoAdjuntoUi.success = null;
    eventoAdjuntoUi.progress = null;
    HttpStream? httpStream = await presenter.uploadEventoAdjuntoUi(eventoUi, eventoAdjuntoUi);
    mapRecurso[eventoAdjuntoUi] = httpStream;
  }

  void onSelectListaEnvio(EventosListaEnvioUi eventosListaEnvioUi) {
    _eventosListaEnvioUi = eventosListaEnvioUi;
    _personasUiList.clear();

    for(EventoPersonaUi eventoPersonaUi in _eventosListaEnvioUi?.personasUiList??[]){
      _personasUiList.add(eventoPersonaUi);
    }
    if(_personasUiList.isNotEmpty){
      _personasUiList.insert(0, _eventosListaEnvioUi?.nombre??"");
    }

    validarTodosPadre();
    validarTodosAlumno();
    changeNombresSelected ();

    refreshUI();
  }

}