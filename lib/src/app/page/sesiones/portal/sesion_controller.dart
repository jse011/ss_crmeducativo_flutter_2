import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/lista/sesion_lista_presenter.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/sesion_presenter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tarea/tarea_unidad.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
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
  List<dynamic> _tareaUiList = [];
  List<dynamic> get tareaUiList => _tareaUiList;
  List<dynamic> _rubricaEvaluacionUiList = [];
  List<dynamic> get rubricaEvaluacionUiList => _rubricaEvaluacionUiList;
  bool _progressEvaluacion =  true;
  bool get progressEvaluacion =>  _progressEvaluacion;

  SesionController(this.cursosUi, this.sesionUi, this.calendarioPeriodoUI, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo, UnidadTareaRepository unidadTareaRepo, RubroRepository rubroRepo):
        presenter = SesionPresenter(configuracionRepo, httpDatosRepo, unidadTareaRepo, rubroRepo);



  @override
  void initListeners() {
    _tareaUiList.clear();
    presenter.getUnidadTareaOnComplete = (List<TareaUi>? tareaUiList, bool? datosOffline, bool? errorServidor){
      // conserver el toogle
      _datosOffline = datosOffline??false;
      _tareaUiList.clear();

      //if(calendarioPeriodoUI.habilitado==1)
        _tareaUiList.add("");
        int count = 0;
       for(TareaUi tareaUi in tareaUiList??[]){
         tareaUi.position = ((tareaUiList??[]).length-count);
         count++;
       }
      _tareaUiList.addAll(tareaUiList??[]);


      //
      _progress = false;
      refreshUI();

    };
    presenter.getUnidadTareaOnError = (e){
      _tareaUiList = [];
      _progress = false;
      refreshUI();
    };

    presenter.updateDatosCrearRubroOnNext = (bool? errorConexion, bool? errorServidor){
      _progress = true;
      print("updateDatosCrearRubroOnNext");
      presenter.onGetSesionRubroEval(cursosUi, calendarioPeriodoUI, sesionUi);
      refreshUI();
    };

    presenter.updateDatosCrearRubroOnError = (e){

    };


    presenter.getSesionRubroEvalOnNext = (List<RubricaEvaluacionUi> rubricaEvalUiList){
      _rubricaEvaluacionUiList = [];
      if(calendarioPeriodoUI!=null&&(calendarioPeriodoUI.habilitado??0)==1){
        _rubricaEvaluacionUiList.add("add");
      }

      int  count = 0;
      for(RubricaEvaluacionUi rubroUi in rubricaEvalUiList){
        rubroUi.position = rubricaEvalUiList.length - count;
        count++;
      }
      _rubricaEvaluacionUiList.addAll(rubricaEvalUiList);

      _progressEvaluacion = false;//ocultar el progress cuando se esta en el tab rubro
      refreshUI();
    };

    presenter.getSesionRubroEvalOnError = (e){
      _rubricaEvaluacionUiList = [];
      _progressEvaluacion = false;//ocultar el progress cuando se esta en el tab rubro
      refreshUI();
    };

  }

  @override
  void onInitState() {
    super.onInitState();
    calendarioPeriodoUI.habilitado = 1;
    presenter.getSesionTarea(cursosUi, calendarioPeriodoUI, sesionUi);
    presenter.onActualizarCurso( calendarioPeriodoUI, cursosUi, sesionUi);
  }

  void refrescarListTarea() {
    _progress = true;
    refreshUI();
    presenter.getSesionTarea(cursosUi, calendarioPeriodoUI, sesionUi);
  }


  @override
  void onDisposed() {
    presenter.dispose();
  }

  void respuestaEvaluacion() {
    _progressEvaluacion = true;
    refreshUI();
    presenter.onGetSesionRubroEval(cursosUi, calendarioPeriodoUI, sesionUi);
  }

  void respuestaFormularioCrearRubro() {
    _progressEvaluacion = true;
    refreshUI();
    presenter.onGetSesionRubroEval(cursosUi, calendarioPeriodoUI, sesionUi);
  }


}