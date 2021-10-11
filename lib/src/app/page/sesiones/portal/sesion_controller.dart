import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/lista/sesion_lista_presenter.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/sesion_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class SesionController extends Controller{
  SesionPresenter presenter;
  CursosUi cursosUi;
  SesionUi sesionUi;
  CalendarioPeriodoUI calendarioPeriodoUI;
  bool _datosOffline =  false;
  bool get datosOffline =>  _datosOffline;
  bool _progress =  false;
  bool get progress =>  _progress;
  List<TareaUi> _tareaUiList = [];
  List<TareaUi> get tareaUiList => _tareaUiList;



  SesionController(this.cursosUi, this.sesionUi, this.calendarioPeriodoUI, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo, UnidadTareaRepository unidadTareaRepo):
        presenter = SesionPresenter(configuracionRepo, httpDatosRepo, unidadTareaRepo);



  @override
  void initListeners() {
    _tareaUiList.clear();
    presenter.getUnidadTareaOnComplete = (List<UnidadUi>? unidadUiList, bool? datosOffline, bool? errorServidor){
      // conserver el toogle
      _datosOffline = datosOffline??false;
      for(UnidadUi unidadUi in unidadUiList??[]){
        for(TareaUi tareaUi in unidadUi.tareaUiList??[]){
          _tareaUiList.add(tareaUi);
        }
      }
      //
      _progress = false;
      refreshUI();

    };
    presenter.getUnidadTareaOnError = (e){
      _tareaUiList = [];
      _progress = false;
      refreshUI();
    };

  }

  @override
  void onInitState() {
    super.onInitState();
    presenter.getUnidadTarea(cursosUi, calendarioPeriodoUI);
  }

  void refrescarListTarea(UnidadUi unidadUi) {

  }

  void onClickVerMas(UnidadUi unidadUi) {}

  @override
  void onDisposed() {
    presenter.dispose();
  }
}