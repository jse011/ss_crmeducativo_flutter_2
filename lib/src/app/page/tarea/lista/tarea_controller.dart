import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/lista/tarea_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class TareaController extends Controller{
  CursosUi cursosUi;
  UsuarioUi? usuarioUi;
  List<CalendarioPeriodoUI> _calendarioPeriodoList = [];

  CalendarioPeriodoUI? _calendarioPeriodoUI = null;

  bool _progress = true;
  bool get progress => _progress;
  List<UnidadUi> _unidadUiList = [];
  List<UnidadUi> get unidadUiList => _unidadUiList;
  Map<UnidadUi, List<dynamic>> _unidadItemsMap = Map();
  Map<UnidadUi, List<dynamic>> get unidadItemsMap => _unidadItemsMap;
  CalendarioPeriodoUI? get calendarioPeriodoUI => _calendarioPeriodoUI;
  List<CalendarioPeriodoUI> get calendarioPeriodoList => _calendarioPeriodoList;
  TareaPresenter _presenter;
  bool _conexion = true;
  bool get conexion => _conexion;

  TareaController(this.usuarioUi, this.cursosUi, ConfiguracionRepository configuracionRepo, CalendarioPeriodoRepository calendarioPeriodoRepo, HttpDatosRepository httpDatosRepo, UnidadTareaRepository unidadTareaRepo):
        _presenter = TareaPresenter(configuracionRepo, calendarioPeriodoRepo, httpDatosRepo, unidadTareaRepo);

  @override
  void initListeners() {
    _presenter.getCalendarioPeridoOnComplete = (List<CalendarioPeriodoUI>? calendarioPeridoList, CalendarioPeriodoUI? calendarioPeriodoUI){
      _calendarioPeriodoList = calendarioPeridoList??[];
      _calendarioPeriodoUI = calendarioPeriodoUI;
      if(_calendarioPeriodoUI!=null&&(_calendarioPeriodoUI?.id??0) > 0){
        _presenter.updateUnidadTarea(cursosUi, _calendarioPeriodoUI);
      }else{
        _progress = false;
      }

      refreshUI();

    };

    _presenter.getCalendarioPeridoOnError = (e){
      _calendarioPeriodoList = [];
      _calendarioPeriodoUI = null;
      refreshUI();
    };

    _presenter.updateUnidadTareaOnComplete = (bool? datosOffline, bool? errorServidor){
      // conserver el toogle
      if(datosOffline??false){
        _conexion = false;
      }else if(errorServidor??false){
        _conexion = false;
      }else{
        _conexion = true;
      }

       _presenter.getUnidadTarea(cursosUi, calendarioPeriodoUI);
    };

    _presenter.updateUnidadTareaOnError = (e){
      //Si suscede un error inesperado al actualizar
      _unidadUiList = [];
      unidadItemsMap.clear();
      _progress = false;
      refreshUI();
    };

    _presenter.getUnidadTareaOnComplete = (List<UnidadUi>? unidadUiList){

      for(UnidadUi newUnidadUi in unidadUiList??[]){
        for(UnidadUi unidadUi in _unidadUiList){
          if(newUnidadUi.unidadAprendizajeId == unidadUi.unidadAprendizajeId){
            newUnidadUi.toogle = unidadUi.toogle;
          }
        }
      }
      //

      _unidadUiList = unidadUiList??[];


      unidadItemsMap.clear();
      for(UnidadUi unidadUi in unidadUiList??[]){
        unidadUi.cantUnidades = unidadUiList!.length;
        unidadItemsMap[unidadUi] = [];

        //if(calendarioPeriodoUI?.habilitado==1)
        unidadItemsMap[unidadUi]?.add("");
        print("tareaUiList: ${unidadUi.tareaUiList?.length}");
        int  count = 0;
        for(TareaUi tareaUi in unidadUi.tareaUiList??[]){
          tareaUi.position = unidadUi.tareaUiList!.length - count;

          unidadItemsMap[unidadUi]?.add(tareaUi);
          count++;
        }
      }
      _progress = false;
      refreshUI();
    };

    _presenter.getUnidadTareaOnError = (e){
      _unidadUiList = [];
      unidadItemsMap.clear();
      _progress = false;
      refreshUI();
    };

  }

  @override
  void onInitState() {
    _presenter.getCalendarioPerido(cursosUi);
    super.onInitState();
  }

  void onSelectedCalendarioPeriodo(CalendarioPeriodoUI calendarioPeriodoUi) {
    this._calendarioPeriodoUI = calendarioPeriodoUi;
    for(var item in  _calendarioPeriodoList){
      item.selected = false;
    }
    calendarioPeriodoUI?.selected = true;
    _progress = true;

    if(_calendarioPeriodoUI!=null&&(_calendarioPeriodoUI?.id??0) > 0){
      _presenter.updateUnidadTarea(cursosUi, calendarioPeriodoUI);
    }else{
      _progress = false;
    }
    refreshUI();

  }

  void onClickTarea(TareaUi tareaUi) {

  }

  void onClickVerMas(UnidadUi unidadUi) {
    unidadUi.toogle = !(unidadUi.toogle??false);
    refreshUI();
  }

  void refrescarListTarea(UnidadUi unidadUi) {
    print("refrescarListTarea ${unidadUi.titulo}");
    _progress = true;
    _presenter.getUnidadTarea(cursosUi, calendarioPeriodoUI);
    refreshUI();
  }

  @override
  void onDetached() {
    super.onDetached();
    _presenter.dispose();
  }

  SesionUi? getSesionUi(TareaUi o) {
    SesionUi? sesionUi = null;
    if((o.sesionAprendizajeId??0)>0){
      sesionUi = SesionUi();
      sesionUi.sesionAprendizajeId =o.sesionAprendizajeId;
      sesionUi.nroSesion =o.nroSesion;
    }
    print("sesionAprendizajeId: ${sesionUi?.sesionAprendizajeId}");
    return sesionUi;
  }

  void changeConnected(bool connected) {
    if(!_conexion && connected){
      _progress = true;
      refreshUI();
      if(_calendarioPeriodoUI!=null&&(_calendarioPeriodoUI?.id??0) > 0){
        _presenter.updateUnidadTarea(cursosUi, calendarioPeriodoUI);
      }else{
        _progress = false;
      }
    }
  }



}