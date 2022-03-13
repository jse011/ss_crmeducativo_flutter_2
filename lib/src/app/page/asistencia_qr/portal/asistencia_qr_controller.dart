import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/asistencia_qr/portal/asistencia_qr_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_qr_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/dialog_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_asistencia_qr_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/asistencia_qr_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/id_generator.dart';
import 'package:collection/collection.dart';

class AsistenciaQRController extends Controller{
  AsistenciaQRPresenter presenter;

  Timer? timer;

  DialogUi? _dialogUi = null;
  DialogUi? get dialogUi => _dialogUi;

  bool get existeAsistenciaNoEnviadas => _existeAsistenciaNoEnviadas;
  bool _existeAsistenciaNoEnviadas = false;
  List<GrupoAsistenciaQRUi> get grupoAsistenciaQRUiList => _grupoAsistenciaQRUiList;
  List<GrupoAsistenciaQRUi> _grupoAsistenciaQRUiList = [];
  bool get progress => _progress;
  bool  _progress = false ;
  List<AsistenciaQRUi> get asistenciaQRList => _asistenciaQRList;
  List<AsistenciaQRUi> _asistenciaQRList = [];
  AsistenciaQRUi? get asistenciahoy => _asistenciahoy;
  AsistenciaQRUi? _asistenciahoy = null;
  DateTime? get dfechaServidor => _dfechaServidor;
  DateTime? _dfechaServidor = null;
  Map<AsistenciaQRUi, HttpStream?> mapRecurso = Map();
  bool get showEvaluacionesNoEnviadas => _showEvaluacionesNoEnviadas;
  bool  _showEvaluacionesNoEnviadas = false ;
  bool  _intencionSalirApp = false ;
  bool get salirApp => _salirApp;
  bool _salirApp = false;


  AsistenciaQRController(HttpDatosRepository httpDatosRepo, ConfiguracionRepository configuracionRepo, AsistenciaQRRepository asistenciaQRRepo):
    presenter = AsistenciaQRPresenter(httpDatosRepo, configuracionRepo, asistenciaQRRepo);

  @override
  void initListeners() {

    presenter.getFechaActualAsistenciaQROnError = (e){
      print("fechaServidor ${e.toString()}");
      _dfechaServidor = null;
      stopTimer();
      _progress = false;
      _asistenciaQRList = [];
      refreshUI();
    };

    presenter.getFechaActualAsistenciaQROnResponse = (bool? errorServidor, bool? offlineServidor, DateTime? dfechaServidor) async{
      _dfechaServidor = dfechaServidor;
      print("fechaServidor ${dfechaServidor!=null}");
      _progress = false;
      startTimer();
      getAsistenciaUiHoy();
      await existenAsistenciaNoEnviadas();

      if(_existeAsistenciaNoEnviadas){
        _showEvaluacionesNoEnviadas = true;

      }else{
        _showEvaluacionesNoEnviadas = false;

      }
      refreshUI();
    };

    presenter.uploadAsistenciaQROnSucces = (bool? success, AsistenciaQRUi? asistenciaQRUi) async{
      asistenciaQRUi?.progreso = false;
      print("guardadoD: ${asistenciaQRUi?.guardado}");
      if(!(asistenciaQRUi?.guardado??false)){
        await existenAsistenciaNoEnviadas();
      }
      refreshUI();
    };

    presenter.uploadListaAsistenciaQROnSuccess = (bool? success, bool? offline){
      if(offline??false){
        _dialogUi = DialogUi.errorInternet();
        refreshUI();
      }else if(!(success??false)){
        _dialogUi = DialogUi.errorServidor();
        refreshUI();
      }
    };

  }


  @override
  void onInitState() {
    _progress = true;
    stopTimer();
    refreshUI();
    presenter.getFecha();
    super.onInitState();
  }

  void startTimer(){
    int? minuto = null;
   timer = Timer.periodic(Duration(seconds: 1), (timer) {
     if(_dfechaServidor!=null){
       _dfechaServidor = dfechaServidor!.add(Duration(seconds: 1));
       if(minuto==null){
         refreshUI();
         minuto = _dfechaServidor!.minute;
       }else if(minuto != _dfechaServidor!.minute){
         minuto = _dfechaServidor!.minute;
         refreshUI();
       }
     }

    });
  }

  void stopTimer(){
    timer?.cancel();
  }

  void scanCodeAlumno(String code, String nombre) async{
    AsistenciaQRUi asistenciaQRUi = AsistenciaQRUi();
    asistenciaQRUi.aistenciaQRId = IdGenerator.generateId();
    asistenciaQRUi.codigo = code;
    asistenciaQRUi.alumno = nombre;
    DateTime dateTime = DateTime(dfechaServidor?.year??0,
        dfechaServidor?.month??0, dfechaServidor?.day??0, dfechaServidor?.hour??0, dfechaServidor?.minute??0, dfechaServidor?.second??0);

    asistenciaQRUi.hora = dateTime.hour;
    asistenciaQRUi.minuto = dateTime.minute;
    asistenciaQRUi.segundo = dateTime.second;

    asistenciaQRUi.dia = dateTime.day;
    asistenciaQRUi.mes = dateTime.month;
    asistenciaQRUi.anio = dateTime.year;
    asistenciaQRUi.progreso = true;
    _asistenciahoy = asistenciaQRUi;
    AsistenciaQRUi? asistenciaQRUiOriginal = _asistenciaQRList.firstWhereOrNull((element) => element.codigo == asistenciaQRUi.codigo);
    if(asistenciaQRUiOriginal!=null){
      asistenciaQRUi.repetido = true;
      asistenciaQRUi.guardado = true;
    }
    _asistenciaQRList.insert(0, asistenciaQRUi);
    refreshUI();
    await presenter.onSaveAsistencia(asistenciaQRUi);
    if(!(asistenciaQRUi.repetido??false)){
      mapRecurso[asistenciaQRUi] = await presenter.uploadAsistenciaQR(asistenciaQRUi);
    }
  }

  void getAsistenciaUiHoy() async{
    _asistenciaQRList = await presenter.getAsistenciaUiHoy(dfechaServidor);
    if(_asistenciaQRList.isNotEmpty){
      _asistenciahoy = _asistenciaQRList[0];
    }
    refreshUI();
  }

  Future<void> existenAsistenciaNoEnviadas() async{
    _grupoAsistenciaQRUiList = await presenter.existenAsistenciaNoEnviadas();
    _existeAsistenciaNoEnviadas = _grupoAsistenciaQRUiList.isNotEmpty;
    print("existenAsistenciaNoEnviadas: ${_grupoAsistenciaQRUiList.length}");
  }

  @override
  void dispose() {
    presenter.dispose();
    stopTimer();
    for(var item in mapRecurso.entries){
      item.value?.cancel();
    }
    super.dispose();
  }

  void reintentar(AsistenciaQRUi asistenciaQRUi)async {
    asistenciaQRUi.progreso = true;
    //mapRecurso[asistenciaQRUi]?.cancel();
    mapRecurso[asistenciaQRUi] = await presenter.uploadAsistenciaQR(asistenciaQRUi);
  }

  void onClickCancelarAsistenciaNoEnvidas() {
    _showEvaluacionesNoEnviadas = false;
    if(_intencionSalirApp){
      _salirApp = true;
    }
    _intencionSalirApp = false;
    refreshUI();
  }

  void onClickGuardarAsistenciaNoEnvidas() async{
    _showEvaluacionesNoEnviadas = false;
    _progress = true;
    refreshUI();
    bool success = await presenter.guardarListAsistenciaQR(asistenciaQRList);
    await existenAsistenciaNoEnviadas();
    if(success){
      if(_intencionSalirApp){
        _salirApp = true;
      }
      _intencionSalirApp = false;
    }
    _progress = false;
    refreshUI();
  }

  bool salirAplicacion() {
    if(existeAsistenciaNoEnviadas){
      _showEvaluacionesNoEnviadas = true;
      _intencionSalirApp = true;
      refreshUI();
      return false;
    }else{
      return true;
    }
  }

  void clearSalirApp() {
    _salirApp = false;
  }

  void clearDialog() {
    _dialogUi = null;
  }

  void closeDialogo() {
    if(_intencionSalirApp){
      _salirApp = true;
    }
    refreshUI();
  }

  void guardarAhora() async{
    _progress = true;
    refreshUI();
    await presenter.guardarListAsistenciaQR(asistenciaQRList);
    await existenAsistenciaNoEnviadas();
    _progress = false;
    refreshUI();
  }

}