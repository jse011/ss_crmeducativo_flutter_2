import 'dart:io';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/portal/portal_tarea_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class PortalTareaController extends Controller{

  CursosUi? cursosUi;
  TareaUi? tareaUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;
  PortalTareaPresenter presenter;
  List<TareaRecusoUi> _tareaRecursoUiList = [];
  List<TareaRecusoUi> get tareaRecursoUiList => _tareaRecursoUiList;
  List<TareaAlumnoUi> _tareaAlumnoUiList = [];
  List<TareaAlumnoUi> get tareaAlumnoUiList => _tareaAlumnoUiList;
  bool _toogleGeneral = true;
  bool get toogleGeneral => _toogleGeneral;
  bool _progress = false;
  bool get progress => _progress;
  bool _showDialogEliminar = false;
  bool get showDialogEliminar => _showDialogEliminar;
  bool _cambiosTarea = false;
  PortalTareaController(this.cursosUi, this.tareaUi, this.calendarioPeriodoUI, HttpDatosRepository httpDatosRepo, UnidadTareaRepository unidadTareaRepo, ConfiguracionRepository configuracionRepo):
        presenter = PortalTareaPresenter(httpDatosRepo, unidadTareaRepo, configuracionRepo);

  @override
  void initListeners() {
    presenter.getInformacionTareaOnError = (e){
      _tareaRecursoUiList = [];
      _tareaAlumnoUiList = [];
      _progress = false;
      refreshUI();
    };

    presenter.getInformacionTareaOnComplete = (List<TareaAlumnoUi>? tareaAlumnoUiList, List<TareaRecusoUi>? tareaRecusoUiList, bool? offlineServidor, bool? errorServidor){
      _tareaRecursoUiList = tareaRecusoUiList??[];
      _tareaAlumnoUiList = tareaAlumnoUiList??[];
      for(TareaAlumnoUi tareaAlumnoUi in _tareaAlumnoUiList){
        tareaAlumnoUi.toogle = toogleGeneral;
      }
      tareaUi?.recursos = tareaRecusoUiList;
      _progress = false;
      refreshUI();
    };

    presenter.publicarTareaOnMessage = (bool offline){

    };

    presenter.eliminarTareaOnMessage = (bool offline){

    };
  }

  @override
  void onInitState() {
    super.onInitState();
    _progress = true;
    refreshUI();
    presenter.getInformacionTarea(tareaUi, tareaUi?.rubroEvalProcesoId, cursosUi, tareaUi?.unidadAprendizajeId);
  }

  @override
  void onDisposed() {
    super.onDisposed();
    presenter.dispose();
  }

  void onClickTareaAlumno(TareaAlumnoUi tareaAlumnoUi) {
    tareaAlumnoUi.toogle = !(tareaAlumnoUi.toogle??false);
    if(tareaAlumnoUi.toogle??false){
     bool selecionado = true;
      for(TareaAlumnoUi tareaAlumnoUi in _tareaAlumnoUiList){
        if(!(tareaAlumnoUi.toogle??false)){
          selecionado = false;
          break;
        }
      }
      _toogleGeneral = selecionado;
    }else{
      _toogleGeneral = false;
    }


    refreshUI();
  }

  onClickMostrarTodo() {
    _toogleGeneral = !_toogleGeneral;
    for(TareaAlumnoUi tareaAlumnoUi in _tareaAlumnoUiList){
      tareaAlumnoUi.toogle = _toogleGeneral;

    }
    refreshUI();
  }

  void refrescarListTarea() {
    refreshUI();
  }

  Future<bool> onClicPublicar() async{
      _progress = true;
      refreshUI();
      bool success = await presenter.publicarTarea(tareaUi);
      if(success){
        tareaUi?.publicado = !(tareaUi?.publicado??false);
        _cambiosTarea = true;
      }
      _progress = false;
      refreshUI();
      return success;
  }

 void onClicEliminar(){
    _showDialogEliminar = true;
    refreshUI();

  }

  void onClickCancelarEliminar() {
    _showDialogEliminar = false;

    refreshUI();
  }

  Future<bool> onClickAceptarEliminar() async{
    _showDialogEliminar = false;
    _progress = true;
    refreshUI();
    bool success = await presenter.eliminarTarea(tareaUi);
    _progress = false;
    refreshUI();
    return success;
  }

  void cambiosTarea() {
    _cambiosTarea = true;
    refrescarListTarea();
  }

  bool onChangeTarea() {
    return _cambiosTarea;
  }


}