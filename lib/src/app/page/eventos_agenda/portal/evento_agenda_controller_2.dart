import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/eventos_agenda/portal/evento_agenda_presenter_2.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';

class EventoAgendaController2 extends Controller{
  UsuarioUi? usuarioUi;
  String? _msgConexion = null;
  String? get msgConexion => _msgConexion;
  Timer? selectedTipoEventoTimer = null;
  List<TipoEventoUi> _tipoEventoList = [];
  List<TipoEventoUi> get tipoEventoList => _tipoEventoList;
  TipoEventoUi? _selectedTipoEventoUi = null;
  TipoEventoUi? get selectedTipoEventoUi => _selectedTipoEventoUi;
  List<EventoUi> _eventoUilIst = [];
  List<EventoUi> get eventoUiList => _eventoUilIst;
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
      hideProgress();
      _msgConexion = "!Oops! Al parecer ocurrió un error involuntario.";
      refreshUI();
    };
    presenter.getEventoAgendaOnNext = (List<TipoEventoUi>? tipoEvantoList, List<EventoUi>? eventoList, bool errorServidor, bool datosOffline) {
      print("tipoEventoUiList :3 size: " + (tipoEvantoList?.length??0).toString());
      print("eventoUIList :3 size: " + (eventoList?.length??0).toString());
      _tipoEventoList = tipoEvantoList??[];
      _msgConexion = errorServidor? "!Oops! Al parecer ocurrió un error involuntario.":null;
      _msgConexion = datosOffline? "No hay Conexión a Internet...":null;

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
      if(_eventoUilIst!=null){
        hideProgress();
        print("isLoading");
      }
      _eventoUilIst = eventoList??[];

      refreshUI();
    };
  }

  @override
  void onInitState() {
    showProgress();
    presenter.onInitState();
  }

  @override
  void onDisposed() {
    super.onDisposed();
    selectedTipoEventoTimer?.cancel();
    presenter.dispose();
  }


  void onSelectedTipoEvento(TipoEventoUi tipoEvento) {
    if(tipoEvento.disable??false)return;
    showProgress();
    _selectedTipoEventoUi = tipoEvento;
    for(var item in _tipoEventoList)item.toogle = false;
    tipoEvento.toogle = true;
    refreshUI();
   selectedTipoEventoTimer?.cancel();
    selectedTipoEventoTimer = Timer(Duration(milliseconds: 500), () {
      showProgress();
      presenter.getEventoAgenda(tipoEvento, false);
    });

  }

  void showProgress(){
    _isLoading = true;
    print("jse showProgress");
  }

  void hideProgress(){
    _isLoading = false;
    print("jse hideProgress");
  }


  void onBackPress() {
    if(_dialogAdjuntoDownload){
      _dialogAdjuntoDownload = false;
      _eventoUiSelected = null;
      refreshUI(); 
    }
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
    showProgress();
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
      _eventoUilIst.remove(_eventoUiSelected);
      _showDialogEliminar = false;
    }else{

    }
    _isLoading = false;
    refreshUI();
    return result;
  }

}