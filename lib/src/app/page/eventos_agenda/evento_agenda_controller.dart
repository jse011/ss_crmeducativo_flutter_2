import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';

import 'evento_agenda_presenter.dart';

class EventoAgendaController extends Controller{

  String? _msgConexion = null;
  String? get msgConexion => _msgConexion;
  late Timer selectedTipoEventoTimer;
  EventoUi? _selectedEventoUi = null;
  EventoUi? get selectedEventoUi => _selectedEventoUi;
  List<TipoEventoUi> _tipoEventoList = [];
  List<TipoEventoUi> get tipoEventoList => _tipoEventoList;
  TipoEventoUi? _selectedTipoEventoUi = null;
  TipoEventoUi? get selectedTipoEventoUi => _selectedTipoEventoUi;
  List<EventoUi> _eventoUilIst = [];
  List<EventoUi> get eventoUiList => _eventoUilIst;
  bool _isLoading = false;
  get isLoading => _isLoading;

  EventoAgendaPresenter presenter;

  EventoAgendaController(httpRepo, configuracionRepo, agendaEventoRepo):this.presenter = new EventoAgendaPresenter(httpRepo, configuracionRepo, agendaEventoRepo);

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

      _eventoUilIst = eventoList??[];
      hideProgress();
      refreshUI();
    };
  }

  @override
  void onInitState() {
    showProgress();
    presenter.onInitState();
  }

  @override
  void dispose() {
    super.dispose();
    if(selectedTipoEventoTimer!=null)selectedTipoEventoTimer.cancel();

  }

  void onSelectedTipoEvento(TipoEventoUi tipoEvento) {
    if(tipoEvento.disable??false)return;
    showProgress();
    _selectedTipoEventoUi = tipoEvento;
    for(var item in _tipoEventoList)item.toogle = false;
    tipoEvento.toogle = true;
    refreshUI();
    if(selectedTipoEventoTimer!=null)selectedTipoEventoTimer.cancel();
    selectedTipoEventoTimer = Timer(Duration(milliseconds: 1000), () {
      presenter.getEventoAgenda(tipoEvento);
    });

  }

  void showProgress(){
    _isLoading = true;
  }

  void hideProgress(){
    _isLoading = false;
  }


  void onClickVerEvento(EventoUi eventoUi) {
    _selectedEventoUi = eventoUi;
  }

}