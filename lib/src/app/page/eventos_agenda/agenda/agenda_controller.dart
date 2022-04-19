import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/eventos_agenda/agenda/agenda_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class AgendaController extends Controller{
  CursosUi? cursosUi;
  UsuarioUi? usuarioUi;
  AgendaPresenter _presenter;
  List<EventoUi> _eventoUiList = [];
  List<EventoUi> get eventoUiList => _eventoUiList;
  bool _progress = false;
  bool get progress => _progress;
  bool _showDialogEliminar = false;
  bool get showDialogEliminar => _showDialogEliminar;
  EventoUi? _eventoUiSelected = null;
  EventoUi? get eventoUiSelected => _eventoUiSelected;
  bool _conexion = true;
  bool get conexion => _conexion;

  bool _dialogAdjuntoDownload = false;
  bool get dialogAdjuntoDownload => _dialogAdjuntoDownload;

  AgendaController(this.cursosUi, this.usuarioUi, AgendaEventoRepository agendaEventoRepo, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo):
        this._presenter = AgendaPresenter(agendaEventoRepo, configuracionRepo, httpDatosRepo);

  @override
  void initListeners() {
    _presenter.getEventoAgendaOnError = (e){
      _eventoUiList = [];
      _progress = false;
      _conexion = false;
      refreshUI();
    };
    _presenter.getEventoAgendaOnNext = (List<TipoEventoUi>? tipoEvantoList, List<EventoUi>? eventoList, bool? errorServidor, bool? datosOffline){
      _eventoUiList = eventoList??[];
      if(datosOffline??false){
        _conexion = false;
      }else if(errorServidor??false){
        _conexion = false;
      }else{
        _conexion = true;
      }
      _progress = false;
      refreshUI();
    };
  }
@override
  void onInitState() {
    super.onInitState();
    _progress = true;
    refreshUI();
    _presenter.getEventoAgenda(cursosUi);
  }

  @override
  void onDisposed() {
    _presenter.dispose();
    super.onDisposed();
  }

  void cambiosEvento() {
    _progress = true;
    refreshUI();
    _presenter.getEventoAgenda(cursosUi);
  }

  void onClickCancelarEliminar() {
    _showDialogEliminar = false;
    refreshUI();
  }

  Future<bool?> onClickAceptarEliminar() async{
    _progress = true;
    refreshUI();
     bool? result = await _presenter.eliminarEvento(_eventoUiSelected);
     if(result??false){
       _eventoUiList.remove(_eventoUiSelected);
       _showDialogEliminar = false;
     }else{

     }
    _progress = false;
    refreshUI();
     return result;
  }

  void onClickElimarEvento(EventoUi? eventoUi) {
    _showDialogEliminar = true;
    _eventoUiSelected = eventoUi;
    refreshUI();
  }

  Future<bool?> onClickPublicar(EventoUi? eventoUi) async{
    _progress = true;
    refreshUI();
    bool? result = await _presenter.publicadoEvento(eventoUi);
    _progress = false;
    refreshUI();
    return result;
  }

  void onClickMoreEventoAdjuntoDowload(EventoUi? eventoUi) {
    _eventoUiSelected = eventoUi;
    _dialogAdjuntoDownload = true;
    refreshUI();
  }

  void onClickAtrasDialogEventoAdjuntoDownload() {
    _dialogAdjuntoDownload = false;
    _eventoUiSelected = null;
    refreshUI();
  }

}