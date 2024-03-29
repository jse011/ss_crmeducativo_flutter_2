import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/eventos_agenda/portal/evento_agenda_presenter_2.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:collection/collection.dart';

class EventoAgendaController2 extends Controller{
  UsuarioUi? usuarioUi;
  bool _conexion = true;
  bool get conexion => _conexion;
  Timer? selectedTipoEventoTimer = null;
  List<TipoEventoUi> _tipoEventoList = [];
  List<TipoEventoUi> get tipoEventoList => _tipoEventoList;
  List<TipoEventoUi> get tipoEventoListInvert {
    List<TipoEventoUi> list = [];
    list.addAll(_tipoEventoList);
    TipoEventoUi? tipoEventoUi = list.firstWhereOrNull((element) => element.id == 0);
    if(tipoEventoUi!=null)list.remove(tipoEventoUi);
    if(tipoEventoUi!=null)list.insert(0, tipoEventoUi);

    return list;
  }
  TipoEventoUi? _selectedTipoEventoUi = null;
  TipoEventoUi? get selectedTipoEventoUi => _selectedTipoEventoUi;
  List<EventoUi>? _eventoUilIst = null;
  List<EventoUi>? get eventoUiList => _eventoUilIst;
  bool _isLoading = false;
  get isLoading => _isLoading;

  bool _dialogAdjuntoDownload = false;
  bool get dialogAdjuntoDownload => _dialogAdjuntoDownload;

  EventoUi? _eventoUiSelected = null;
  EventoUi? get eventoUiSelected => _eventoUiSelected;
  bool _showDialogEliminar = false;
  bool get showDialogEliminar => _showDialogEliminar;


  EventoAgendaPresenter2 presenter;

  EventoAgendaController2(this.usuarioUi, httpRepo, configuracionRepo, agendaEventoRepo):this.presenter = new EventoAgendaPresenter2(httpRepo, configuracionRepo, agendaEventoRepo);

  @override
  void initListeners() {

    presenter.getEventoAgendaOnError = (e) {
      print('evento error');
      if(tipoEventoList!=null){
        for(TipoEventoUi tipoEventoUi in tipoEventoList){
          tipoEventoUi.toogle = false;
        }
      }

      _eventoUilIst = [];
      _isLoading = false;
      _conexion = false;
      refreshUI();
    };

    presenter.getEventoAgendaOnNext = (List<TipoEventoUi>? tipoEvantoList, List<EventoUi>? eventoList, bool? errorServidor, bool? datosOffline) {

      _tipoEventoList = tipoEvantoList??[];
      if(errorServidor??false){
        _conexion = false;
      }else if(datosOffline??false){
        _conexion = false;
      }else{
        _conexion = true;
      }
      //_conexion = errorServidor? "!Oops! Al parecer ocurrió un error involuntario.":null;
      //_conexion = datosOffline? "No hay Conexión a Internet...":null;

      if(_selectedTipoEventoUi==null){
        for(TipoEventoUi tipoEventoUi in tipoEventoList){
          if(tipoEventoUi.id == 0){
            tipoEventoUi.toogle = true;
            _selectedTipoEventoUi = tipoEventoUi;
          }
        }
      }else{
        for(TipoEventoUi tipoEventoUi in tipoEventoList){
          if(_selectedTipoEventoUi?.id == tipoEventoUi.id){
            tipoEventoUi.toogle = true;
            _selectedTipoEventoUi = tipoEventoUi;
          }
        }
      }

      _eventoUilIst = eventoList;

      if(_eventoUilIst!=null){
        _isLoading = false;
      }

      refreshUI();
    };
  }

  @override
  void onInitState() {
    _isLoading = true;
    refreshUI();
    presenter.getEventoAgenda(null, true);

  }

  @override
  void onDisposed() {
    super.onDisposed();
    selectedTipoEventoTimer?.cancel();
    presenter.dispose();
  }


  void onSelectedTipoEvento(TipoEventoUi tipoEvento) {
    if(tipoEvento.disable??false)return;
    _isLoading = true;
    _selectedTipoEventoUi = tipoEvento;
    for(var item in _tipoEventoList)item.toogle = false;
    tipoEvento.toogle = true;
    refreshUI();

   selectedTipoEventoTimer?.cancel();
    selectedTipoEventoTimer = Timer(Duration(milliseconds: 500), () {
      _isLoading = true;
      refreshUI();
      presenter.getEventoAgenda(tipoEvento, false);
    });

  }


  bool onBackPress() {
    if(_dialogAdjuntoDownload){
      _dialogAdjuntoDownload = false;
      _eventoUiSelected = null;
      refreshUI();
      return false;
    }
    return true;
  }

  void onClickAtrasDialogEventoAdjuntoDownload() {
    _dialogAdjuntoDownload = false;
    _eventoUiSelected = null;
    refreshUI();
  }

  void onClickMoreEventoAdjuntoDowload(EventoUi? eventoUi) {
    _eventoUiSelected = eventoUi;
    _dialogAdjuntoDownload = true;
    refreshUI();
  }

  void cambiosEvento() {
    _isLoading = true;
    refreshUI();
    presenter.getEventoAgenda(_selectedTipoEventoUi, false);
  }
  void onClickElimarEvento(EventoUi? eventoUi) {
    _showDialogEliminar = true;
    _eventoUiSelected = eventoUi;
    refreshUI();
  }

  Future<bool?> onClickPublicar(EventoUi? eventoUi) async{
    _isLoading = true;
    refreshUI();
    bool? result = await presenter.publicadoEvento(eventoUi);
    _isLoading = false;
    refreshUI();
    return result;
  }

  void onClickCancelarEliminar() {
    _showDialogEliminar = false;
    refreshUI();
  }

  Future<bool?> onClickAceptarEliminar() async{
    _isLoading = true;
    refreshUI();
    bool? result = await presenter.eliminarEvento(_eventoUiSelected);
    if(result??false){
      _eventoUilIst?.remove(_eventoUiSelected);
      _showDialogEliminar = false;
    }else{

    }
    _isLoading = false;
    refreshUI();
    return result;
  }

  void changeConnected(bool connected) {
    if(!_conexion && connected){
      _isLoading = true;
      refreshUI();
      presenter.getEventoAgenda(null, true);
    }
  }

}