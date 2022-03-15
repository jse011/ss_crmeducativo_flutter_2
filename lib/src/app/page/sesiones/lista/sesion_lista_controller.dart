import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/lista/sesion_lista_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_firebase_sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';

class SesionListaController extends Controller{
  SesionListaPresenter presenter;
  UsuarioUi? usuarioUi;
  CursosUi cursosUi;
  List<CalendarioPeriodoUI> _calendarioPeriodoList = [];

  UnidadUi? unidadUiSelected;
  SesionUi? sesionUiSelected;
  bool _showRealizarSesion = false;
  bool get showRealizarSesion => _showRealizarSesion;
  String? _msgRealizarSesion = null;
  String? get msgRealizarSesion => _msgRealizarSesion;



  List<CalendarioPeriodoUI> get calendarioPeriodoList => _calendarioPeriodoList;
  CalendarioPeriodoUI? _calendarioPeriodoUI = null;
  CalendarioPeriodoUI? get calendarioPeriodoUI => _calendarioPeriodoUI;
  List<UnidadUi> _unidadUiDocenteList = [];
  List<UnidadUi> get unidadUiDocenteList => _unidadUiDocenteList;
  Map<UnidadUi, List<dynamic>> _unidadItemsMap = Map();
  Map<UnidadUi, List<dynamic>> get unidadItemsMap => _unidadItemsMap;
  bool? _agregarunidadTarea;
  bool? get agregarunidadTarea => _agregarunidadTarea;
  bool _progressDocente = false;
  bool get progressDocente => _progressDocente;

  Map<EvaluacionFirebaseTipoUi?, List<EvaluacionFirebaseSesionUi>>? _evaluacionFirebaseUiMap;
  Map<EvaluacionFirebaseTipoUi?, List<EvaluacionFirebaseSesionUi>>? get evaluacionFirebaseUiMap => _evaluacionFirebaseUiMap;

  List<EvaluacionFirebaseSesionUi>? _evaluacionFirebaseUiUnidadList;
  List<EvaluacionFirebaseSesionUi>? get evaluacionFirebaseUiUnidadList => _evaluacionFirebaseUiUnidadList;

  Map<EvaluacionFirebaseSesionUi, bool>? _checkedMap;
  Map<EvaluacionFirebaseSesionUi, bool>? get checkedMap => _checkedMap;

  bool _progressFirebase = false;
  bool get progressFirebase => _progressFirebase;

  bool _conexion = true;
  bool get conexion => _conexion;

  bool _conexionPublicarFirebase = true;
  bool get conexionPublicarFirebase => _conexionPublicarFirebase;

  SesionListaController(this.usuarioUi, this.cursosUi, configuracionRepo, calendarioPeriodoRepo, httpDatosRepo, unidadSesionRepo):
      presenter = SesionListaPresenter(configuracionRepo, calendarioPeriodoRepo, httpDatosRepo, unidadSesionRepo);

  @override
  void initListeners() {
    presenter.getCalendarioPeridoOnComplete = (List<CalendarioPeriodoUI>? calendarioPeridoList, CalendarioPeriodoUI? calendarioPeriodoUI){
      _calendarioPeriodoList = calendarioPeridoList??[];
      _calendarioPeriodoUI = calendarioPeriodoUI;
      //_calendarioPeriodoUI?.habilitadoProceso = 1;
      //_calendarioPeriodoUI?.habilitadoResultado = 1;
      _progressDocente = true;
      if(_calendarioPeriodoUI!=null&&(_calendarioPeriodoUI?.id??0) > 0){
        presenter.getUnidadAprendizajeDocente(cursosUi, calendarioPeriodoUI);
      }else{
        _progressDocente = false;
      }
      refreshUI();



    };

    presenter.getCalendarioPeridoOnError = (e){
      _calendarioPeriodoList = [];
      _calendarioPeriodoUI = null;
      refreshUI();
    };

    presenter.getUnidadSesionDocenteOnComplete = (List<UnidadUi>? unidadUiList, bool? datosOffline, bool? errorServidor){
      _unidadUiDocenteList = unidadUiList??[];
      _progressDocente = false;
      if(datosOffline??false){
        _conexion = false;
      }else if(errorServidor??false){
        _conexion = false;
      }else{
        _conexion = true;
      }


      unidadItemsMap.clear();
      for(UnidadUi unidadUi in unidadUiList??[]){
        unidadUi.cantUnidades = unidadUiList!.length;
        unidadItemsMap[unidadUi] = [];

        //if(calendarioPeriodoUI?.habilitado==1)
        //  unidadItemsMap[unidadUi]?.add("");
        int  count = 0;
        for(SesionUi sesionUi in unidadUi.sesionUiList??[]){
          sesionUi.position = unidadUi.sesionUiList!.length - count;
          unidadItemsMap[unidadUi]?.add(sesionUi);
          count++;
        }

      }
      refreshUI();

    };
    presenter.getUnidadSesionDocenteOnError = (e){
      _unidadUiDocenteList = [];
      _progressDocente = false;
      refreshUI();
    };

    presenter.updateSesionEstadoOnMessage = (bool? offline, bool? success, List<int> instrumentoEvalIdErrorList, List<String> preguntaPortalAlumnoIdErrorList, List<String> tareaIdErrorList){
      print("updateSesionEstadoOnMessage");
      _checkedMap?.forEach((key, value) {

        if(key.tipo == EvaluacionFirebaseTipoUi.PREGUNTA){
          for(String preguntaId in preguntaPortalAlumnoIdErrorList){
            if(preguntaId == key.key){
              print("updateSesionEstadoOnMessage ${key.nombre}");
              _checkedMap?[key] = false;
            }
          }
        }else if(key.tipo == EvaluacionFirebaseTipoUi.TAREA || key.tipo == EvaluacionFirebaseTipoUi.TAREAUNIDAD){
          for(String tareaId in tareaIdErrorList){
            if(tareaId == key.key){
              print("updateSesionEstadoOnMessage ${key.nombre}");
              _checkedMap?[key] = false;
            }
          }
        }else if(key.tipo == EvaluacionFirebaseTipoUi.INSTRUMENTO){

          for(int instrumentoId in instrumentoEvalIdErrorList){
            if(instrumentoId.toString() == key.key){
              print("updateSesionEstadoOnMessage ${key.nombre}");
              _checkedMap?[key] = false;
            }
          }
        }
      });
      if(success??false){
        _showRealizarSesion = false;
        _msgRealizarSesion = null;
      }else{
        _showRealizarSesion = true;
        _msgRealizarSesion = "Error en la evaluación. Se desmarcaron los recursos que lo causaron, reintente otra vez.";
      }
      refreshUI();
    };

    presenter.getEvaluacionSesionesFirebaseOnComplete = (Map<EvaluacionFirebaseTipoUi?, List<EvaluacionFirebaseSesionUi>>? evaluacionFirebaseUiMap, bool? datosOffline, bool? errorServidor){
      if(datosOffline??false){
        _conexionPublicarFirebase = false;
      }else if(errorServidor??false){
        _conexionPublicarFirebase = false;
      }else{
        _conexionPublicarFirebase = true;
      }
      _evaluacionFirebaseUiMap = Map();
      _evaluacionFirebaseUiUnidadList = [];
      evaluacionFirebaseUiMap?.forEach((key, value) {
        if(key != EvaluacionFirebaseTipoUi.TAREAUNIDAD){
          _evaluacionFirebaseUiMap![key] = value;
        }else{
          _evaluacionFirebaseUiUnidadList?.addAll(value);
        }
      });
      _checkedMap = Map();
      evaluacionFirebaseUiMap?.forEach((key, value) {
        for(var item in value){
          _checkedMap![item] = key!=EvaluacionFirebaseTipoUi.TAREAUNIDAD;
        }
      });
      _progressFirebase = false;
      refreshUI();
    };

    presenter.getEvaluacionSesionesFirebaseOnError = (e){
      _evaluacionFirebaseUiMap = null;
      _evaluacionFirebaseUiUnidadList = null;
      _checkedMap = null;
      _progressFirebase = false;
      refreshUI();
    };

  }

  void showEvaluacionSesionesFirebase(SesionUi? sesionUi, UnidadUi unidadUi){
    _evaluacionFirebaseUiMap = null;
    _evaluacionFirebaseUiUnidadList = null;
    _progressFirebase = true;
    _agregarunidadTarea = false;
    sesionUiSelected = sesionUi;
    unidadUiSelected = unidadUi;
    _showRealizarSesion = true;
    _msgRealizarSesion = null;
    refreshUI();
    presenter.getEvaluacionSesionesFirebase(calendarioPeriodoUI, cursosUi, sesionUi);

  }

  @override
  void onInitState() {
    presenter.getCalendarioPerido(cursosUi);
    super.onInitState();
  }

  void onSelectedCalendarioPeriodo(CalendarioPeriodoUI calendarioPeriodoUi) {
    this._calendarioPeriodoUI = calendarioPeriodoUi;
    for(var item in  _calendarioPeriodoList){
      item.selected = false;
    }
    calendarioPeriodoUI?.selected = true;
    //_calendarioPeriodoUI?.habilitadoProceso = 1;
    //_calendarioPeriodoUI?.habilitadoResultado = 1;
    _progressDocente = true;
    refreshUI();
    presenter.getUnidadAprendizajeDocente(cursosUi, calendarioPeriodoUI);

  }

  void onSyncronizarUnidades() {
    _progressDocente = true;
    refreshUI();
    presenter.getUnidadAprendizajeDocente(cursosUi, calendarioPeriodoUI);


  }


  @override
  void onDisposed() {
    presenter.dispose();
  }

  void onClickVerMas(UnidadUi unidadUi) {
    unidadUi.toogle = !(unidadUi.toogle??false);
    refreshUI();
  }

  Future<bool> onClickSessionHecho() async{
    _progressDocente = true;
    refreshUI();
    List<EvaluacionFirebaseSesionUi> list = [];
    checkedMap?.forEach((key, value) {
      if(value){
        list.add(key);
      }
    });
    var response = await presenter.onUpdateSesionEstado(sesionUiSelected, unidadUiSelected, cursosUi, calendarioPeriodoUI, list);
    _progressDocente = false;
    if(response){
      refreshUI();
    }
    return response;
  }

  void onClickEvaluacionFirebase(EvaluacionFirebaseSesionUi evaluacionFirebaseSesionUi) {
    _checkedMap?[evaluacionFirebaseSesionUi] = !(_checkedMap?[evaluacionFirebaseSesionUi]??false);
    //evaluacionFirebaseSesionUi.selected = !(evaluacionFirebaseSesionUi.selected??false);
   // refreshUI();
  }

  void onClickAgregarUnidadTarea() {
    _agregarunidadTarea = true;
    for(EvaluacionFirebaseSesionUi item in evaluacionFirebaseUiUnidadList??[]){
      _checkedMap![item] = true;
    }
    refreshUI();
  }

  void successShowRealizarSesion() {
    _showRealizarSesion = false;
  }

  void changeConnected(bool connected) {
    if(!_conexion && connected){
      _progressDocente = true;

      if(_calendarioPeriodoUI!=null&&(_calendarioPeriodoUI?.id??0) > 0){
        presenter.getUnidadAprendizajeDocente(cursosUi, calendarioPeriodoUI);
      }else{
        _progressDocente = false;
      }

      refreshUI();
    }
  }


}