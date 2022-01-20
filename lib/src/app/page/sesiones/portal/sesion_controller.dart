import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/lista/sesion_lista_presenter.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/sesion_presenter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tarea/tarea_unidad.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/actividad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/instrumento_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_sesion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class SesionController extends Controller{
  SesionPresenter presenter;
  UsuarioUi? usuarioUi;
  CursosUi cursosUi;
  SesionUi sesionUi;
  UnidadUi unidadUi;
  CalendarioPeriodoUI calendarioPeriodoUI;
  bool _datosOffline =  false;
  bool get datosOffline =>  _datosOffline;

  List<dynamic> _tareaUiList = [];
  List<dynamic> get tareaUiList => _tareaUiList;
  List<dynamic> _rubricaEvaluacionUiList = [];
  List<dynamic> get rubricaEvaluacionUiList => _rubricaEvaluacionUiList;
  bool _progressEvaluacion =  true;
  bool get progressEvaluacion =>  _progressEvaluacion;
  List<CompetenciaUi> _competenciaUiList = [];
  List<CompetenciaUi> get competenciaUiList => _competenciaUiList;
  List<TemaCriterioUi> _temaCriterioUiList = [];
  List<TemaCriterioUi> get temaCriterioUiList => _temaCriterioUiList;
  List<SesionRecursoUi> _sesionRecursoUiList = [];
  List<SesionRecursoUi> get sesionRecursoUiList => _sesionRecursoUiList;
  OnTapSesione onTapSesione = OnTapSesione.APRENDIZAJE;

  bool _progressAprendizaje =  false;
  bool get progressAprendizaje =>  _progressAprendizaje;

  bool _progressTarea =  true;
  bool get progressTarea =>  _progressTarea;

  bool _progressActividad =  false;
  bool get progressActividad =>  _progressActividad;

  List<ActividadUi> _actividadUiList = [];
  List<ActividadUi> get actividadUiList => _actividadUiList;
  List<InstrumentoEvaluacionUi> _instrumentoEvaluacionUiList = [];
  List<InstrumentoEvaluacionUi> get instrumentoEvaluacionUiList => _instrumentoEvaluacionUiList;
  bool _contenedorInstrumentos =  true;
  bool get contenedorInstrumentos =>  _contenedorInstrumentos;

  SesionController(this.usuarioUi, this.cursosUi, this.unidadUi, this.sesionUi, this.calendarioPeriodoUI, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo, UnidadTareaRepository unidadTareaRepo, RubroRepository rubroRepo, UnidadSesionRepository unidadSesionRepo):
        presenter = SesionPresenter(configuracionRepo, httpDatosRepo, unidadTareaRepo, rubroRepo, unidadSesionRepo);

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

      _progressTarea = false;
      refreshUI();

    };
    presenter.getUnidadTareaOnError = (e){
      _tareaUiList = [];
      _progressTarea = false;
      refreshUI();
    };

    presenter.updateDatosCrearRubroOnNext = (bool? errorConexion, bool? errorServidor){
      //_progress = true;
      print("updateDatosCrearRubroOnNext");
      presenter.onGetSesionRubroEval(cursosUi, calendarioPeriodoUI, sesionUi);
      refreshUI();
    };

    presenter.updateDatosCrearRubroOnError = (e){
      _progressEvaluacion = false;
      _progressAprendizaje = false;
      _progressActividad = false;
      refreshUI();
    };

    presenter.updateAprendizajeOnNext = (){
      print("updateAprendizajeOnNext");
      presenter.onGetCompetencias(sesionUi);
      refreshUI();
    };


    presenter.getSesionRubroEvalOnNext = (List<RubricaEvaluacionUi> rubricaEvalUiList){
      _rubricaEvaluacionUiList = [];
      if(calendarioPeriodoUI!=null&&(calendarioPeriodoUI.habilitadoProceso??0)==1){
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

    presenter.getAprendizajeOnNext = (bool? errorServidor, bool? offline, List<CompetenciaUi>? competenciaUiList,  List<TemaCriterioUi>? temaCriterioUiList, List<SesionRecursoUi>? sesionRecursoUiList){
      _competenciaUiList = competenciaUiList??[];
      _temaCriterioUiList = temaCriterioUiList??[];
      _sesionRecursoUiList = sesionRecursoUiList??[];
      _progressAprendizaje = false;
      refreshUI();
    };
    presenter.getAprendizajeOnError = (e){
      _competenciaUiList = [];
      _temaCriterioUiList = [];
      _sesionRecursoUiList = [];
      _progressAprendizaje = false;
      refreshUI();
    };

    presenter.getActividadesSesionOnNext = (bool? errorServidor, bool? offline, List<ActividadUi>? actividadUiList, List<InstrumentoEvaluacionUi>? instrumentoEvaluacionUiList){
      _actividadUiList = actividadUiList??[];
      _instrumentoEvaluacionUiList = instrumentoEvaluacionUiList??[];
      _progressActividad = false;
      refreshUI();
    };
    presenter.getActividadesSesionOnError = (e){
      _actividadUiList = [];
      _instrumentoEvaluacionUiList = [];
      _progressActividad = false;
      refreshUI();
    };
  }

  @override
  void onInitState() {
    super.onInitState();
    _progressAprendizaje = true;
    _progressEvaluacion = true;
    _progressTarea = true;
    _progressActividad = true;
    refreshUI();
    presenter.getSesionTarea(cursosUi, calendarioPeriodoUI, sesionUi);
    presenter.onActualizarCurso( calendarioPeriodoUI, cursosUi, sesionUi);
    presenter.onGetActividades(sesionUi);
  }

  void refrescarListTarea() {
    _progressTarea = true;
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

  void onTabAprendizaje() {
    onTapSesione = OnTapSesione.APRENDIZAJE;
    refreshUI();
  }

  void onTabActividades() {
    onTapSesione = OnTapSesione.ACTIVIDADES;
    refreshUI();
  }

  void onTabEvaluacion() {
    onTapSesione = OnTapSesione.EVALUACIONES;
    refreshUI();
  }

  void onTrabajo() {
    onTapSesione = OnTapSesione.TRABAJO;
    refreshUI();
  }

  void onClickActividad(ActividadUi actividadUi) {
    for(var item in actividadUiList){
      if(actividadUi != item)item.toogle = false;
    }
    actividadUi.toogle = !(actividadUi.toogle??false);
    if(actividadUi.toogle == true){
      _contenedorInstrumentos = false;
    }
    refreshUI();
  }

  void onClickContenedorInstrumentos() {
    _contenedorInstrumentos = !_contenedorInstrumentos;
    if(_contenedorInstrumentos){
      for(var item in actividadUiList){
        item.toogle = false;
      }
    }
    refreshUI();
  }


}

enum OnTapSesione{
  APRENDIZAJE, ACTIVIDADES, EVALUACIONES, TRABAJO
}