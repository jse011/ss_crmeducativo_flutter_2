import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/eventos_agenda/informacion/evento_informacion_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_adjunto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';

class EventoInformacionController extends Controller{
  EventoInformacionPresenter presenter;
  EventoUi? eventoUi;
  EventoAdjuntoUi? eventoAdjuntoUi;
  bool _dialogAdjuntoDownload = false;
  bool get dialogAdjuntoDownload => _dialogAdjuntoDownload;

  EventoUi? _eventoUiSelected = null;
  EventoUi? get eventoUiSelected => _eventoUiSelected;

  EventoInformacionController(this.eventoUi, this.eventoAdjuntoUi):
        presenter = EventoInformacionPresenter();

  @override
  void initListeners() {
    // TODO: implement initListeners
  }

  @override
  void onDisposed() {

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

  bool onBackPress() {
    if(_dialogAdjuntoDownload){
      _dialogAdjuntoDownload = false;
      _eventoUiSelected = null;
      refreshUI();
      return false;
    }
    return true;
  }

}