import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/portal/portal_tarea_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/TareaEvaluacionUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_formula_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_archivo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';
import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/calcular_evaluacion_proceso.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_drive_tools.dart';

class PortalTareaController extends Controller{
  UsuarioUi? usuarioUi;
  CursosUi? cursosUi;
  TareaUi? tareaUi;
  SesionUi? sesionUi;
  UnidadUi? unidadUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;
  RubricaEvaluacionUi? rubricaEvalUI;
  PortalTareaPresenter presenter;

  bool _mostrarAlumnosDosListas = false;
  bool get mostrarDosListasAlumnos => _mostrarAlumnosDosListas;

  List<TareaRecusoUi> _tareaRecursoUiList = [];
  List<TareaRecusoUi> get tareaRecursoUiList => _tareaRecursoUiList;
  List<TareaAlumnoUi> _tareaAlumnoUiList = [];
  List<TareaAlumnoUi> get tareaAlumnoUiList => _tareaAlumnoUiList;
  List<TareaAlumnoUi> _tareaAlumnoUiNoEvaluadosList = [];
  List<TareaAlumnoUi> get tareaAlumnoUiNoEvaluadosList => _tareaAlumnoUiNoEvaluadosList;
  List<TareaAlumnoUi> _tareaAlumnoUiEvaluadosList = [];
  List<TareaAlumnoUi> get tareaAlumnoUiEvaluadosList => _tareaAlumnoUiEvaluadosList;

  int _alumnoEval = 0;
  int get alumnoEval => _alumnoEval;
  int _alumnoSinEval = 0;
  int get alumnoSinEval => _alumnoSinEval;
  bool _toogleGeneral = false;
  bool get toogleGeneral => _toogleGeneral;
  bool _progress = false;
  bool get progress => _progress;
  bool _showDialogEliminar = false;
  bool get showDialogEliminar => _showDialogEliminar;
  bool _cambiosTarea = false;
  bool get showDialogSaveEval => _showDialogSaveEval;
  bool _showDialogSaveEval = false;

  bool _progressRubro = false;
  bool get progressRubro => _progressRubro;
  List<double> get tablecolumnWidths => _tablecolumnWidths;
  List<double> _tablecolumnWidths = [];
  Map<TareaAlumnoUi, List<dynamic>> _mapColumnList = Map();
  Map<TareaAlumnoUi, List<RubricaEvaluacionUi>> _mapRowList = Map();
  Map<TareaAlumnoUi, List<List<dynamic>>> _mapCellListList = Map();
  Map<TareaAlumnoUi, List<dynamic>> get mapColumnList => _mapColumnList;
  Map<TareaAlumnoUi, List<RubricaEvaluacionUi>> get mapRowList => _mapRowList;
  Map<TareaAlumnoUi, List<List<dynamic>>> get mapCellListList => _mapCellListList;
  bool _precision = false;
  bool get precision => _precision;

  Map<TareaAlumnoUi?, HttpStream?> get uploadNotas => _uploadNotas;
  Map<TareaAlumnoUi?, HttpStream?> _uploadNotas = Map();
  Map<TareaAlumnoUi?, RubricaEvaluacionUi?> _erroresAlGuardar = Map();


  String? _mensaje = null;
  String? get mensaje => _mensaje;
  bool get progressEvalTarea => _progressEvalTarea;
  bool _progressEvalTarea = false;

  bool _progressSailrGuardar = false;
  bool get progressSailrGuardar => _progressSailrGuardar;

  HttpStream? uploadSalirGuardar = null;
  bool get cerraryactualizar => _cerraryactualizar;
  bool _cerraryactualizar = false;

  bool get showDialogPublicarEval => _showDialogPublicarEval;
  bool _showDialogPublicarEval = false;

  bool _progressPublicarEval = false;
  bool get progressPublicarEval => _progressPublicarEval;
  HttpStream? procesarEvaluacion = null;

  bool _cambiosEvaluacion = false;
  bool get cambiosEvaluacion => _cambiosEvaluacion;
  bool _progressCambiosEvaluacion = false;
  bool get progressCambiosEvaluacion => _progressCambiosEvaluacion;
  bool _abrirRubrica = false;
  bool get abrirRubrica => _abrirRubrica;
  bool get cambiosEvaluacionFirebase => _cambiosEvaluacionFirebase;
  bool  _cambiosEvaluacionFirebase = false;

  TareaAlumnoArchivoUi? _abrirTareaAlumnoArchivo = null;
  TareaAlumnoArchivoUi? get abrirTareaAlumnoArchivo => _abrirTareaAlumnoArchivo;

  bool _alumnoSearch = false;
  bool get alumnoSearch => _alumnoSearch;
  String? get alumnoFiltro => _alumnoFiltro;
  String? _alumnoFiltro = null;

  PortalTareaController(this.usuarioUi, this.cursosUi, this.tareaUi, this.calendarioPeriodoUI, this.unidadUi, this.sesionUi, HttpDatosRepository httpDatosRepo, UnidadTareaRepository unidadTareaRepo, ConfiguracionRepository configuracionRepo, RubroRepository rubroRepo):
        presenter = PortalTareaPresenter(httpDatosRepo, unidadTareaRepo, configuracionRepo, rubroRepo);

  @override
  void initListeners() {
    print("calendarioId ${calendarioPeriodoUI?.id}");
    presenter.getInformacionTareaOnError = (e){
      _tareaRecursoUiList = [];
      _tareaAlumnoUiList = [];
      _tareaAlumnoUiNoEvaluadosList = [];
      _tareaAlumnoUiEvaluadosList = [];
      _mostrarAlumnosDosListas = false;
      _progress = false;
      refreshUI();
    };

    presenter.getInformacionTareaOnComplete = (List<TareaAlumnoUi>? tareaAlumnoUiList, List<TareaRecusoUi>? tareaRecusoUiList, bool? offlineServidor, bool? errorServidor) async{
      _tareaRecursoUiList = tareaRecusoUiList??[];
      _tareaAlumnoUiList = tareaAlumnoUiList??[];
      _tareaAlumnoUiNoEvaluadosList = [];
      _tareaAlumnoUiEvaluadosList = [];

      for(TareaAlumnoUi tareaAlumnoUi in _tareaAlumnoUiList){
        tareaAlumnoUi.toogle = toogleGeneral;
        if((tareaAlumnoUi.valorTipoNotaId??"").isNotEmpty){
          _tareaAlumnoUiEvaluadosList.add(tareaAlumnoUi);
        }else{
          _tareaAlumnoUiNoEvaluadosList.add(tareaAlumnoUi);
        }
      }

      _mostrarAlumnosDosListas = _tareaAlumnoUiNoEvaluadosList.isNotEmpty && _tareaAlumnoUiEvaluadosList.isNotEmpty;
      /*Solo abrir la caja de evaluaciones abierta del primer foto_alumno*/
      if(_mostrarAlumnosDosListas){
        if(_tareaAlumnoUiEvaluadosList.isNotEmpty){
          _tareaAlumnoUiEvaluadosList[0].toogle = true;
        }else if(_tareaAlumnoUiNoEvaluadosList.isNotEmpty){
          _tareaAlumnoUiNoEvaluadosList[0].toogle = true;
        }
      }else if(_tareaAlumnoUiList.isNotEmpty){
        _tareaAlumnoUiList[0].toogle = true;
      }
      /*o*/


      tareaUi?.recursos = tareaRecusoUiList;
      _progress = false;
      refreshCountEvaluados();
      _progressRubro = true;
      refreshUI();
      //print("onActualizarRubro");
      //await Future.delayed(Duration(seconds: 1));
      presenter.onActualizarRubro(calendarioPeriodoUI, cursosUi, sesionUi, tareaUi);

    };

    presenter.publicarTareaOnMessage = (bool offline){

    };

    presenter.eliminarTareaOnMessage = (bool offline){

    };

    presenter.updateDatosCrearRubroOnNext = (bool? errorConexion, bool? errorServidor)async{
      //print("updateDatosCrearRubroOnNext progressCambiosEvaluacion ${_progressCambiosEvaluacion}");
      if(progressCambiosEvaluacion){
        _progressCambiosEvaluacion = false;
        _cambiosEvaluacion = false;
        _abrirRubrica = true;
      }else{
        presenter.getRubroEvaluacion(tareaUi?.tareaId, cursosUi);
      }
      refreshUI();
    };

    presenter.updateDatosCrearRubroOnError = (e){
      //print("updateDatosCrearRubroOnError");
      this.rubricaEvalUI = null;
      _progressRubro = false;
      refreshUI();
    };


    presenter.getRubroEvaluacionOnNext = (RubricaEvaluacionUi? rubricaEvalUI, List<PersonaUi> alumnoCursoList) {
      //print("getRubroEvaluacionOnNext ${rubricaEvalUI?.rubroEvaluacionId} && rubroEvalProcesoId: ${tareaUi?.rubroEvalProcesoId}");
      this.rubricaEvalUI = rubricaEvalUI;
      _progressRubro= false;

      if((rubricaEvalUI?.rubroEvaluacionId??"").isNotEmpty){
        this.tareaUi?.rubroEvalProcesoId = rubricaEvalUI?.rubroEvaluacionId;
        this.tareaUi?.tipoNotaId = rubricaEvalUI?.tipoNotaId;
        this.tareaUi?.competenciaId = rubricaEvalUI?.competenciaId??0;
        this.tareaUi?.desempenioIcdId = rubricaEvalUI?.desempenioIcdId??0;
      } else{
        this.tareaUi?.rubroEvalProcesoId =null;
        this.tareaUi?.tipoNotaId =null;
        this.tareaUi?.competenciaId = null;
        this.tareaUi?.desempenioIcdId = null;
        this.rubricaEvalUI = null;
        _mostrarAlumnosDosListas = false;
      }

      refreshCountEvaluados();
      initLista(alumnoCursoList, rubricaEvalUI);
      refreshUI();
    };

    presenter.getRubroEvaluacionOnError = (e){
      //print("getRubroEvaluacionOnError");
      this.rubricaEvalUI = null;
      _progressRubro= false;
      refreshUI();
    };

    presenter.saveRubroEvaluacionSucces = (RubricaEvaluacionUi? rubricaEvaluacionUi, RubricaEvaluacionUi? rubricaEvalDetalleUi, TareaAlumnoUi? tareaAlumnoUi){
      tareaAlumnoUi?.success = 2;
      _erroresAlGuardar[tareaAlumnoUi] = null;
      refreshUI();
    };

    presenter.saveRubroEvaluacionError = (RubricaEvaluacionUi? rubricaEvaluacionUi, RubricaEvaluacionUi? rubricaEvalDetalleUi, TareaAlumnoUi? tareaAlumnoUi, bool errorServidor, bool errorConexion, bool errorInterno){
      if(errorConexion){
        tareaAlumnoUi?.success = -1;
        _erroresAlGuardar[tareaAlumnoUi] = rubricaEvaluacionUi;
      }else if(errorServidor){
        tareaAlumnoUi?.success = -1;
        _erroresAlGuardar[tareaAlumnoUi] = rubricaEvaluacionUi;
      }else if(errorInterno){
        tareaAlumnoUi?.success = -1;
        _erroresAlGuardar[tareaAlumnoUi] = rubricaEvaluacionUi;
      }else{
        tareaAlumnoUi?.success = 0;
      }

      refreshUI();
    };

    presenter.saveRubroEvaluacionAllSucces = (List<TareaAlumnoUi?>? tareaAlumnoUiList){
     for(TareaAlumnoUi? tareaAlumnoUi in tareaAlumnoUiList??[]){
       _erroresAlGuardar[tareaAlumnoUi] = null;
       tareaAlumnoUi?.success = 2;
     }

     if(_progressPublicarEval){
       publicarEvaluacion();
     }

     if(_progressSailrGuardar){
       _cerraryactualizar = true;
     }
     _progressSailrGuardar = false;
     _progressEvalTarea = false;

     refreshUI();
    };

    presenter.saveRubroEvaluacionAllError = (List<TareaAlumnoUi?>? tareaAlumnoUiList, bool errorServidor, bool errorConexion, bool errorInterno){

      if(errorConexion){
        _mensaje = "Sin conexión a Internet";
      }else if(errorServidor){
        _mensaje = "Error de servidor";
      }else if(errorInterno){
      _mensaje = "Error interno";
      }else{

      }

      if(_progressSailrGuardar){
        _showDialogSaveEval  = true;
      }
      _progressSailrGuardar = false;
      _progressEvalTarea = false;
      refreshUI();
    };


    presenter.procesarRubroEvaluacionSucces = (){
      _progressPublicarEval = false;
      _cambiosEvaluacion = true;
      _cambiosEvaluacionFirebase = false;
      refreshUI();
    };

    presenter.procesarRubroEvaluacionError = (bool errorServidor, bool errorConexion, bool errorInterno){
      _progressPublicarEval = false;
      if(errorConexion){
        _mensaje = "Sin conexión a Internet";
      }else if(errorServidor){
        _mensaje = "Error de servidor";
      }else if(errorInterno){
        _mensaje = "Error interno";
      }else{

      }
      _cambiosEvaluacion = true;
      refreshUI();


    };

    presenter.getUrlDownloadTareaEvaluacionOnError = (bool errorServidor, bool errorConexion, bool errorInterno, TareaAlumnoArchivoUi? tareaAlumnoArchivoUi){
      tareaAlumnoArchivoUi?.upload = false;
      _abrirTareaAlumnoArchivo = tareaAlumnoArchivoUi;
      print("getUrlDownloadTareaEvaluacionOnError");
      refreshUI();
    };

    presenter.getUrlDownloadTareaEvaluacionOnComplete = (TareaAlumnoArchivoUi? tareaAlumnoArchivoUi){
      tareaAlumnoArchivoUi?.upload = false;
      _abrirTareaAlumnoArchivo = tareaAlumnoArchivoUi;
      print("getUrlDownloadTareaEvaluacionOnComplete");
      refreshUI();
    };

  }

  void initLista(List<PersonaUi> alumnoCursoList, RubricaEvaluacionUi? rubricaEvalUI) {

    for(TareaAlumnoUi tareaAlumnoUi in _tareaAlumnoUiList){

      _mapColumnList[tareaAlumnoUi] = [];
      _mapRowList[tareaAlumnoUi] = [];
      _mapCellListList[tareaAlumnoUi] = [];

      if(rubricaEvalUI?.tipoRubroEvaluacion == TipoRubroEvaluacion.UNIDIMENSIONAL){
        List<RubricaEvaluacionUi> rubroEvalList = [];
        if(rubricaEvalUI!=null)
          rubroEvalList.add(rubricaEvalUI);
        _mapRowList[tareaAlumnoUi]?.addAll(rubroEvalList);
      }else{
        _mapRowList[tareaAlumnoUi]?.addAll(rubricaEvalUI?.rubrosDetalleList??[]);
      }


      //_mapColumnList[tareaAlumnoUi]?.add(RubricaEvaluacionUi());
      TipoNotaUi? tipoNotaUi = null;
      if(rubricaEvalUI?.tipoRubroEvaluacion == TipoRubroEvaluacion.UNIDIMENSIONAL){
        tipoNotaUi = rubricaEvalUI?.tipoNotaUi;
      }else{
        if(rubricaEvalUI?.rubrosDetalleList?.isNotEmpty??false){
          tipoNotaUi = rubricaEvalUI?.rubrosDetalleList?[0].tipoNotaUi;
        }
      }
      if(tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS || tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
        _mapColumnList[tareaAlumnoUi]?.addAll(tipoNotaUi?.valorTipoNotaList??[]);
      }else{
        _mapColumnList[tareaAlumnoUi]?.add(EvaluacionUi());//Teclado numerico
      }
      //_mapColumnList[tareaAlumnoUi]?.add(RubricaEvaluacionFormulaPesoUi(RubricaEvaluacionUi()));//peso_criterio

      for(RubricaEvaluacionUi row in _mapRowList[tareaAlumnoUi]??[]){
        List<dynamic> cellList = [];
        //cellList.add(row);
        String? valorTipoNotaIdFirebase = null;
        double? notaFirebase = null;
        EvaluacionUi? evaluacionUi = null;
        if(row.tipoRubroEvaluacion == TipoRubroEvaluacion.UNIDIMENSIONAL){
          valorTipoNotaIdFirebase = tareaAlumnoUi.valorTipoNotaId;
          notaFirebase = tareaAlumnoUi.nota;
        }else{
          TareaEvaluacionUi? tareaEvaluacionUi = tareaAlumnoUi.evaluacion?.firstWhereOrNull((element) => element.desempenioIcdId == row.desempenioIcdId);
          valorTipoNotaIdFirebase = tareaEvaluacionUi?.valorTipoNotaId;
          notaFirebase = tareaEvaluacionUi?.nota;
        }


        evaluacionUi = row.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == tareaAlumnoUi.personaUi?.personaId);

        if(!_cambiosEvaluacionFirebase){
          //comprobar si existen cambios de evaluacion tarea en base datos y firebase
          print("comprobar ${evaluacionUi?.nota} !=  ${notaFirebase}");
          _cambiosEvaluacionFirebase = (evaluacionUi?.nota??0) != (notaFirebase??0);
        }

        evaluacionUi?.valorTipoNotaId = valorTipoNotaIdFirebase;//remplazar con la nota de la tarea
        evaluacionUi?.nota = notaFirebase;//remplazar con la nota de la tarea
        evaluacionUi?.personaUi = tareaAlumnoUi.personaUi;

        if(tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS || tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
          for(ValorTipoNotaUi valorTipoNotaUi in tipoNotaUi?.valorTipoNotaList??[]){

            EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi = EvaluacionRubricaValorTipoNotaUi();
            evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi = valorTipoNotaUi;
            evaluacionRubricaValorTipoNotaUi.evaluacionUi = evaluacionUi;
            evaluacionRubricaValorTipoNotaUi.toggle = valorTipoNotaUi.valorTipoNotaId == evaluacionUi?.valorTipoNotaId;
            evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi = row;
            cellList.add(evaluacionRubricaValorTipoNotaUi);
          }
        }else{
          cellList.add(evaluacionUi);
        }
        //RubricaEvaluacionFormulaPesoUi pesoUi = RubricaEvaluacionFormulaPesoUi(row);
        //cellList.add(pesoUi);
        _mapCellListList[tareaAlumnoUi]?.add(cellList);
      }
    }

    /*Calular el tamaño*/
    _tablecolumnWidths.clear();
    if(_tareaAlumnoUiList.isNotEmpty){
      for(dynamic s in _mapColumnList[_tareaAlumnoUiList[0]]??[]){
        if(s is ValorTipoNotaUi){
          _tablecolumnWidths.add(35.0);
        }  else if(s is EvaluacionUi){
          _tablecolumnWidths.add(35);
        }else if(s is RubricaEvaluacionFormulaPesoUi){
          _tablecolumnWidths.add(35);
        }else{
          _tablecolumnWidths.add(50.0);
        }
      }
    }
  }

  @override
  void onInitState() {
    super.onInitState();
    _progress = true;
    _progressRubro = true;
    refreshUI();
    presenter.getInformacionTarea(tareaUi, cursosUi, tareaUi?.unidadAprendizajeId);

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



  Future<bool> onClicPublicar() async{
      _progress = true;
      refreshUI();

      tareaUi?.docente = usuarioUi?.personaUi?.nombreCompleto;
      tareaUi?.nroSesion = sesionUi?.nroSesion;
      tareaUi?.tipoPeriodoId = calendarioPeriodoUI?.tipoId;
      tareaUi?.silaboEventoId = unidadUi?.silaboEventoId;

      bool success = await presenter.publicarTarea(tareaUi);
      if(success){
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
    tareaUi?.docente = usuarioUi?.personaUi?.nombreCompleto;
    tareaUi?.nroSesion = sesionUi?.nroSesion;
    tareaUi?.tipoPeriodoId = calendarioPeriodoUI?.tipoId;
    tareaUi?.silaboEventoId = unidadUi?.silaboEventoId;

    bool success = await presenter.eliminarTarea(tareaUi);
    _progress = false;
    refreshUI();
    return success;
  }

  void cambiosTarea() {
    _cambiosTarea = true;
    refreshUI();
  }

  bool onChangeTarea() {
    return _cambiosTarea;
  }

  refreshCountEvaluados(){
    _alumnoEval=0;
    _alumnoSinEval=0;
    for(TareaAlumnoUi tareaAlumnoUi in _tareaAlumnoUiList){
      print("rubricaEvalUI; ${rubricaEvalUI?.rubroEvaluacionId}");
      if((tareaAlumnoUi.valorTipoNotaId??"").isNotEmpty
          && rubricaEvalUI != null)_alumnoEval++;
      else _alumnoSinEval++;
    }
  }

  void successCrearEvaluacion(String? rubricaId) {
    _progressRubro =true;
    refreshUI();
    //Traer las evaluaciones de la tarea del firebase*/
    presenter.getInformacionTarea(tareaUi, cursosUi, tareaUi?.unidadAprendizajeId);//1305160972
  }

  onClicClearEvaluacionAll(ValorTipoNotaUi valorTipoNotaUi, TareaAlumnoUi? tareaAlumnoUi) async {

    if(!(tareaAlumnoUi?.personaUi?.contratoVigente??false))return;//Contrato no vigente

    for(List cellList in mapCellListList[tareaAlumnoUi]??[]){
      for(var cell in cellList){
        if(cell is EvaluacionRubricaValorTipoNotaUi){
          cell.toggle = false;
          cell.evaluacionUi?.nota = 0.0;
          cell.evaluacionUi?.valorTipoNotaId = null;
          cell.evaluacionUi?.valorTipoNotaUi = null;

          TareaEvaluacionUi? tareaEvaluacionUi = tareaAlumnoUi?.evaluacion?.firstWhereOrNull((element) => element.desempenioIcdId == cell.rubricaEvaluacionUi?.desempenioIcdId);
          tareaEvaluacionUi?.valorTipoNotaId = null;
          tareaEvaluacionUi?.nota = 0.0;

        }
      }
    }
    _actualizarCabecera(tareaAlumnoUi);
    refreshCountEvaluados();
    _cambiosTarea = true;
    refreshUI();
    _erroresAlGuardar[tareaAlumnoUi] = null;
    _uploadNotas[tareaAlumnoUi]?.cancel();
    _cambiosEvaluacion = true;
    _uploadNotas[tareaAlumnoUi] = await presenter.updateEvalAlumnoAll(rubricaEvalUI, tareaAlumnoUi, tareaUi, calendarioPeriodoUI);
    tareaAlumnoUi?.success = 1;
    refreshUI();
  }

  onClicEvaluacionAll(ValorTipoNotaUi valorTipoNotaUi, TareaAlumnoUi? tareaAlumnoUi)async {
    if(!(tareaAlumnoUi?.personaUi?.contratoVigente??false))return;//Contrato no vigente

    for(List cellList in mapCellListList[tareaAlumnoUi]??[]){
      for(var cell in cellList){
        if(cell is EvaluacionRubricaValorTipoNotaUi){
          if(cell.valorTipoNotaUi?.valorTipoNotaId == valorTipoNotaUi.valorTipoNotaId){
            cell.toggle = true;

            cell.evaluacionUi?.nota = valorTipoNotaUi.valorNumerico;//actualizar la nota solo cuando no esta selecionado
            cell.evaluacionUi?.valorTipoNotaId = valorTipoNotaUi.valorTipoNotaId;
            cell.evaluacionUi?.valorTipoNotaUi = valorTipoNotaUi;

            TareaEvaluacionUi? tareaEvaluacionUi = tareaAlumnoUi?.evaluacion?.firstWhereOrNull((element) => element.desempenioIcdId == cell.rubricaEvaluacionUi?.desempenioIcdId);
            tareaEvaluacionUi?.valorTipoNotaId = valorTipoNotaUi.valorTipoNotaId;
            tareaEvaluacionUi?.nota = valorTipoNotaUi.valorNumerico;//actualizar la nota solo cuando no esta selecionado
          }else{
            cell.toggle = false;
          }

        }
      }
    }

    _actualizarCabecera(tareaAlumnoUi);
    refreshCountEvaluados();
    _cambiosTarea = true;
    refreshUI();
    _erroresAlGuardar[tareaAlumnoUi] = null;
    _uploadNotas[tareaAlumnoUi]?.cancel();
    _cambiosEvaluacion = true;
    _uploadNotas[tareaAlumnoUi] = await presenter.updateEvalAlumnoAll(rubricaEvalUI, tareaAlumnoUi, tareaUi, calendarioPeriodoUI);
    tareaAlumnoUi?.success = 1;
    refreshUI();
  }

  void onClicEvaluarPresicion(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, TareaAlumnoUi? tareaAlumnoUi, nota)async {
    for (List cellList in mapCellListList[tareaAlumnoUi] ?? []) {
      for (var cell in cellList) {
        if (cell is EvaluacionRubricaValorTipoNotaUi) {
          if (cell.evaluacionUi?.alumnoId == evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId
              && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.rubroEvaluacionId
              && cell != evaluacionRubricaValorTipoNotaUi) {
            cell.toggle = false;
          }
        }
      }
    }

    evaluacionRubricaValorTipoNotaUi.toggle = true;

    evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota = nota;
    evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaId = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId;
    evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaUi = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi;

    TareaEvaluacionUi? tareaEvaluacionUi = tareaAlumnoUi?.evaluacion?.firstWhereOrNull((element) => element.desempenioIcdId == evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.desempenioIcdId);
    tareaEvaluacionUi?.valorTipoNotaId = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId;
    tareaEvaluacionUi?.nota = nota;//actualizar la nota solo cuando no esta selecionado

    _actualizarCabecera(tareaAlumnoUi);
    refreshCountEvaluados();
    _cambiosTarea = true;

    refreshUI();
    _erroresAlGuardar[tareaAlumnoUi] = null;
    _uploadNotas[tareaAlumnoUi]?.cancel();
    _cambiosEvaluacion = true;
    _uploadNotas[tareaAlumnoUi] = await presenter.updateEvalAlumnoUi(rubricaEvalUI, evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi, tareaAlumnoUi, tareaUi, calendarioPeriodoUI, cambiosEvaluacionFirebase);
    tareaAlumnoUi?.success = 1;
    refreshUI();
  }

  void onClicEvaluar(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, TareaAlumnoUi? tareaAlumnoUi) async{


    for (List cellList in mapCellListList[tareaAlumnoUi] ?? []) {
      for (var cell in cellList) {
        if (cell is EvaluacionRubricaValorTipoNotaUi) {
          print("onClicEvaluar tareaAlumnoUi: ${cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId}");
          if (cell.evaluacionUi?.alumnoId == evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId
              && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.rubroEvaluacionId
              && cell != evaluacionRubricaValorTipoNotaUi) {
            cell.toggle = false;
          }
        }
      }
    }
    evaluacionRubricaValorTipoNotaUi.toggle = !(evaluacionRubricaValorTipoNotaUi.toggle ?? false);
    print("onClicEvaluar evaluacion: ${tareaAlumnoUi?.evaluacion}");
    TareaEvaluacionUi? tareaEvaluacionUi = tareaAlumnoUi?.evaluacion?.firstWhereOrNull((element) => element.desempenioIcdId == evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.desempenioIcdId);

    if(evaluacionRubricaValorTipoNotaUi.toggle??false){

      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorNumerico;
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaId = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId;
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaUi = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi;

      tareaEvaluacionUi?.valorTipoNotaId = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId;
      tareaEvaluacionUi?.nota = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorNumerico;
      print("onClicEvaluar evaluacionRubricaValorTipoNotaUi: ${tareaEvaluacionUi?.valorTipoNotaId}");
    }else{
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota = 0.0;
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaId = null;
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaUi = null;
      tareaEvaluacionUi?.valorTipoNotaId = null;
      tareaEvaluacionUi?.nota = 0.0;
      print("onClicEvaluar evaluacionRubricaValorTipoNotaUi: ${evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaId}");
    }



    _actualizarCabecera(tareaAlumnoUi);
    refreshCountEvaluados();
    _cambiosTarea = true;
    refreshUI();
    _erroresAlGuardar[tareaAlumnoUi] = null;
    _uploadNotas[tareaAlumnoUi]?.cancel();
    _cambiosEvaluacion = true;
    _uploadNotas[tareaAlumnoUi] = await presenter.updateEvalAlumnoUi(rubricaEvalUI, evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi,tareaAlumnoUi, tareaUi, calendarioPeriodoUI, cambiosEvaluacion);
    tareaAlumnoUi?.success = 1;
    refreshUI();

    print("changeEvaluacion: ${_uploadNotas[tareaAlumnoUi]?.isFinished()}");
  }

  void seEliminoEvaluacion() {
    print("changeEvaluacion");
    /*_cambiosTarea =true;
    _progress = true;*/
    rubricaEvalUI = null;
    tareaUi?.rubroEvalProcesoId = null;
    _progressRubro = true;
    refreshUI();
    presenter.onActualizarRubro(calendarioPeriodoUI, cursosUi, sesionUi, tareaUi);
  }

  void _actualizarCabecera(TareaAlumnoUi? tareaAlumnoUi) {
    if(rubricaEvalUI?.tipoRubroEvaluacion != TipoRubroEvaluacion.UNIDIMENSIONAL){
      CalcularEvaluacionProceso.actualizarCabecera(rubricaEvalUI, tareaAlumnoUi?.personaUi);
    }

    EvaluacionUi? evaluacionUi = rubricaEvalUI?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == tareaAlumnoUi?.personaUi?.personaId);
    tareaAlumnoUi?.valorTipoNotaId = evaluacionUi?.valorTipoNotaId;
    tareaAlumnoUi?.nota = evaluacionUi?.nota;
    tareaAlumnoUi?.rubroEvalProcesoId = rubricaEvalUI?.rubroEvaluacionId;
    print("valorTipoNotaId: ${evaluacionUi?.valorTipoNotaId}");
  }

  EvaluacionUi? getEvaluacionGeneralPersona(PersonaUi personaUi) {
    EvaluacionUi? evaluacionUi = null;

    for(EvaluacionUi item in rubricaEvalUI?.evaluacionUiList??[]){
      if(item.personaUi?.personaId == personaUi.personaId){
        evaluacionUi = item;
      }
    }
    return evaluacionUi;
  }

  bool onSaveProgressEvaluacion() {
    bool subiendoEvaluacion = false;
    for(var evaluacion in _uploadNotas.entries){
      HttpStream? httpStream = evaluacion.value;
      subiendoEvaluacion = httpStream!=null && !httpStream.isFinished();
      break;
    }
    if(subiendoEvaluacion){
      refreshUI();
      return true;
    }else{
      return false;
    }
  }

  int onCountErrorGuardar() {
    int errorGuardar = 0;
    for(var evaluacion in _erroresAlGuardar.entries){
      if(evaluacion.value!=null){
        errorGuardar++;
      }
    }
    return errorGuardar;
  }

  void hayCambioEnLaConexion()  {
    print("hayCambioEnLaConexion");
      if(onCountErrorGuardar()>0 && !progressPublicarEval){
        print("guardarEvaluacionTarea");
        guardarEvaluacionTarea();
      }else{
        if(_progressSailrGuardar){
          _cerraryactualizar = true;
        }
        _progressSailrGuardar = false;
        _progressEvalTarea = false;
        refreshUI();
      }
  }

  void guardarEvaluacionTarea()async{
    _progressEvalTarea = true;
    refreshUI();

    for(var evaluacion in _uploadNotas.entries){
      HttpStream? httpStream = evaluacion.value;
      httpStream?.cancel();
    }
    List<TareaAlumnoUi> tareaAlumnouiList = [];
    for(TareaAlumnoUi tareaAlumnoUi in _tareaAlumnoUiList){
      if(tareaAlumnoUi.success != null && tareaAlumnoUi.success != 0 && tareaAlumnoUi.success != 2){
        tareaAlumnouiList.add(tareaAlumnoUi);
      }
    }
    print("tareaAlumnouiList ${tareaAlumnouiList.length}");
    uploadSalirGuardar?.cancel();
    await Future.delayed(Duration(seconds: 2));
    _cambiosEvaluacion = true;
    uploadSalirGuardar = await presenter.updateEvaluacionAll(rubricaEvalUI, tareaAlumnouiList, tareaUi, calendarioPeriodoUI);
  }

  void successMsg() {
    _mensaje = null;
  }

  void onClickSalirGuardar() {
    _progressSailrGuardar = true;
    _showDialogSaveEval = false;
    refreshUI();
    hayCambioEnLaConexion();
  }

  void showDialogSaveEvaluacion() {
    _showDialogSaveEval = true;
    refreshUI();
  }

  void closeDialogSaveEvaluacion() {
    _showDialogSaveEval = false;
    refreshUI();
  }

  void clearCerraryactualizar() {
    _cerraryactualizar = false;
  }

  onClickPublicarEvaluacion() {
    _showDialogPublicarEval = true;
    refreshUI();
  }

  void closeDialogPublicarEval() {
    _showDialogPublicarEval = false;
    refreshUI();
  }

  void clickPublicarDialogPublicarEval() async{
    _progressPublicarEval = true;
    _showDialogPublicarEval = false;
    refreshUI();
    if(onCountErrorGuardar()>0){
      guardarEvaluacionTarea();
    }else{
      publicarEvaluacion();
    }
  }

  void publicarEvaluacion() async{
    procesarEvaluacion?.cancel();
    await Future.delayed(Duration(seconds: 2));
    procesarEvaluacion = await presenter.procesarTareaEvaluacion(rubricaEvalUI, calendarioPeriodoUI, tareaUi);
  }

  Future<void> onClickRubrica() async {
    if(_cambiosEvaluacion){
      _progressCambiosEvaluacion = true;
      refreshUI();
      presenter.onActualizarRubro(calendarioPeriodoUI, cursosUi, sesionUi, tareaUi);
    }else{
      _abrirRubrica = true;
      refreshUI();
    }
  }

  void celearAbrirRubrica() {
    _abrirRubrica = false;
  }

  void cambioEvaluacion() {
    presenter.getRubroEvaluacion(tareaUi?.tareaId, cursosUi);
  }

  void onClickTareaArchivoAlumno(TareaAlumnoArchivoUi tareaAlumnoArchivoUi) {
    print("onClickTareaArchivoAlumno ${tareaAlumnoArchivoUi.driveId}");
    if((tareaAlumnoArchivoUi.driveId??"").isNotEmpty ||
        tareaAlumnoArchivoUi.tipoRecurso ==  TipoRecursosUi.TIPO_VINCULO ||
        tareaAlumnoArchivoUi.tipoRecurso ==  TipoRecursosUi.TIPO_VINCULO_DRIVE ||
        tareaAlumnoArchivoUi.tipoRecurso ==  TipoRecursosUi.TIPO_VINCULO_YOUTUBE ||
        tareaAlumnoArchivoUi.tipoRecurso ==  TipoRecursosUi.TIPO_RECURSO){
      _abrirTareaAlumnoArchivo = tareaAlumnoArchivoUi;
      refreshUI();
    }else{
      tareaAlumnoArchivoUi.upload = true;
      refreshUI();
      presenter.getDriveIdTaraeaAlumnoArchivo(tareaAlumnoArchivoUi, tareaUi);
    }
  }

  void clearAbrirTareaAlumnoArchivosConDrive() {
    _abrirTareaAlumnoArchivo = null;
  }

  onClickMostrarBuscador() {
    _alumnoSearch = !_alumnoSearch;
    _alumnoFiltro = null;
    refreshUI();
  }

  void onChangeText(String texto) {
    _alumnoFiltro = texto;
    refreshUI();
  }

  void onClickSearchAlumno(TareaAlumnoUi tareaAlumnoUi) {
    tareaAlumnoUi.toogle = true;
    refreshUI();
  }

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }



}