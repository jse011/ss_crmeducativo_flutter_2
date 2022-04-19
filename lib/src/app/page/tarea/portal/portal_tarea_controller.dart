import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/portal/portal_tarea_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/TareaEvaluacionUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_tarea_alumno_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_tarea_alumno_valor_tipo_nota_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_formula_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_tarea_alumnoUi.dart';
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
import 'package:ss_crmeducativo_2/src/domain/tools/transformar_valor_tipo_nota.dart';

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

  List<TareaRecusoUi> _tareaRecursoUiList2 = [];
  List<TareaRecusoUi> _tareaRecursoUiList = [];
  List<TareaRecusoUi> get tareaRecursoUiList => _tareaRecursoUiList;
  List<TareaAlumnoUi> _tareaAlumnoUiList = [];
  List<TareaAlumnoUi> get tareaAlumnoUiList => _tareaAlumnoUiList;
  List<TareaAlumnoUi> _tareaAlumnoUiList2 = [];
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
  Map<TareaAlumnoUi, List<RubricaEvaluacionTareaAlumnoUi>> _mapRowList = Map();
  Map<TareaAlumnoUi, List<List<dynamic>>> _mapCellListList = Map();
  Map<TareaAlumnoUi, List<dynamic>> get mapColumnList => _mapColumnList;
  Map<TareaAlumnoUi, List<RubricaEvaluacionTareaAlumnoUi>> get mapRowList => _mapRowList;
  Map<TareaAlumnoUi, List<List<dynamic>>> get mapCellListList => _mapCellListList;
  bool _precision = false;
  bool get precision => _precision;

  Map<TareaAlumnoUi?, HttpStream?> get uploadNotas => _uploadNotas;
  Map<TareaAlumnoUi?, HttpStream?> _uploadNotas = Map();


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
  bool _progressCambiosEvaluacion1 = false;
  bool get progressCambiosEvaluacion1 => _progressCambiosEvaluacion1;
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
      _tareaRecursoUiList2 = tareaRecusoUiList??[];
      _tareaAlumnoUiList2 = tareaAlumnoUiList??[];
      _progressRubro = true;
      _progress = false;
      refreshUI();


      //print("onActualizarRubro");
      //await Future.delayed(Duration(seconds: 1));
      presenter.onActualizarRubro(calendarioPeriodoUI, cursosUi, sesionUi, tareaUi);

    };

    presenter.publicarTareaOnMessage = (bool offline){

    };

    presenter.eliminarTareaOnMessage = (bool offline){

    };

    presenter.updateDatosCrearRubroOnNext = (bool? errorConexion, bool? errorServidor){
      getRubro();
    };

    presenter.updateDatosCrearRubroOnError = (e){
      //print("updateDatosCrearRubroOnError");
      this.rubricaEvalUI = null;
      _progressRubro = false;
      actualizarListaAlumnos();
      refreshUI();
    };





    presenter.saveRubroEvaluacionSucces = (RubricaEvaluacionUi? rubricaEvaluacionUi, RubricaEvaluacionTareaAlumnoUi? rubricaEvaluacionTareaAlumnoUi){

      rubricaEvaluacionTareaAlumnoUi?.success = 2;
      print("rubricaEvalDetalleUi?.success ${rubricaEvaluacionTareaAlumnoUi?.success}");
      if(!onSaveProgressEvaluacion()){
        if(progressCambiosEvaluacion1){
          _progressCambiosEvaluacion1 = false;
          _cambiosEvaluacion = false;
          _abrirRubrica = true;
        }
      }
      refreshUI();
    };

    presenter.saveRubroEvaluacionError = (RubricaEvaluacionUi? rubricaEvaluacionUi, RubricaEvaluacionTareaAlumnoUi? rubricaEvaluacionTareaAlumnoUi, bool errorServidor, bool errorConexion, bool errorInterno){
      if(errorConexion){
        rubricaEvaluacionTareaAlumnoUi?.success = -1;
      }else if(errorServidor){
        rubricaEvaluacionTareaAlumnoUi?.success = -1;
      }else if(errorInterno){
        rubricaEvaluacionTareaAlumnoUi?.success = -1;
      }else{
        rubricaEvaluacionTareaAlumnoUi?.success = 0;
      }

      if(!onSaveProgressEvaluacion()){
        if(progressCambiosEvaluacion1){
          _progressCambiosEvaluacion1 = false;
          _cambiosEvaluacion = false;
          _abrirRubrica = true;
        }
      }

      refreshUI();
    };

    presenter.saveRubroEvaluacionAllSucces = (List<TareaAlumnoUi?>? tareaAlumnoUiList){
     for(var evaluacion in _mapRowList.entries){

       for(RubricaEvaluacionTareaAlumnoUi rubricaEvaluacionTareaAlumnoUi in evaluacion.value){
         int? success = rubricaEvaluacionTareaAlumnoUi.success;
         if(success != null && success <= 0){
           rubricaEvaluacionTareaAlumnoUi.success = 2;
         }
       }
     }

     if(_progressPublicarEval){
       publicarEvaluacion();
     }

     if(!onSaveProgressEvaluacion()){
       if(progressCambiosEvaluacion1){
         _progressCambiosEvaluacion1 = false;
         _cambiosEvaluacion = false;
         _abrirRubrica = true;
       }
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

      for(var evaluacion in _mapRowList.entries){

        for(RubricaEvaluacionTareaAlumnoUi rubricaEvaluacionTareaAlumnoUi in evaluacion.value){
          int? success = rubricaEvaluacionTareaAlumnoUi.success;
          if(success != null && success <= 0){
            if(errorConexion){
              rubricaEvaluacionTareaAlumnoUi.success = -1;
            }else if(errorServidor){
              rubricaEvaluacionTareaAlumnoUi.success = -1;
            }else if(errorInterno){
              rubricaEvaluacionTareaAlumnoUi.success = -1;
            }else{
              rubricaEvaluacionTareaAlumnoUi.success = 0;
            }
          }
        }
      }

      if(!onSaveProgressEvaluacion()){
        if(progressCambiosEvaluacion1){
          _progressCambiosEvaluacion1 = false;
          _cambiosEvaluacion = false;
          _abrirRubrica = true;
        }
      }
/*
      for(TareaAlumnoUi? tareaAlumnoUi in tareaAlumnoUiList??[]){
        if(errorConexion){
          tareaAlumnoUi?.success = -1;
        }else if(errorServidor){
          tareaAlumnoUi?.success = -1;
        }else if(errorInterno){
          tareaAlumnoUi?.success = -1;
        }else{
          tareaAlumnoUi?.success = 0;
        }
      }*/

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

      refreshUI();
    };

    presenter.getUrlDownloadTareaEvaluacionOnComplete = (TareaAlumnoArchivoUi? tareaAlumnoArchivoUi){
      tareaAlumnoArchivoUi?.upload = false;
      _abrirTareaAlumnoArchivo = tareaAlumnoArchivoUi;

      refreshUI();
    };

  }

 void initLista(List<PersonaUi> alumnoCursoList, RubricaEvaluacionUi? rubricaEvalUI) {

    for(TareaAlumnoUi tareaAlumnoUi in _tareaAlumnoUiList){

      _mapColumnList[tareaAlumnoUi] = [];
      _mapRowList[tareaAlumnoUi] = [];
      _mapCellListList[tareaAlumnoUi] = [];

      if(rubricaEvalUI?.tipoRubroEvaluacion == TipoRubroEvaluacion.UNIDIMENSIONAL){
        List<RubricaEvaluacionTareaAlumnoUi> rubroEvalList = [];
        if(rubricaEvalUI!=null){
          RubricaEvaluacionTareaAlumnoUi rubricaEvaluacionTareaAlumnoUi = RubricaEvaluacionTareaAlumnoUi();
          rubricaEvaluacionTareaAlumnoUi.tareaAlumnoUi = tareaAlumnoUi;
          rubricaEvaluacionTareaAlumnoUi.rubricaEvaluacionUi = rubricaEvalUI;
          rubroEvalList.add(rubricaEvaluacionTareaAlumnoUi);
        }

        _mapRowList[tareaAlumnoUi]?.addAll(rubroEvalList);
      }else{
        for(RubricaEvaluacionUi rubricaEvaluacionUiDetalle in rubricaEvalUI?.rubrosDetalleList??[]){
          RubricaEvaluacionTareaAlumnoUi rubricaEvaluacionTareaAlumnoUi = RubricaEvaluacionTareaAlumnoUi();
          rubricaEvaluacionTareaAlumnoUi.tareaAlumnoUi = tareaAlumnoUi;
          rubricaEvaluacionTareaAlumnoUi.rubricaEvaluacionUi = rubricaEvaluacionUiDetalle;
          _mapRowList[tareaAlumnoUi]?.add(rubricaEvaluacionTareaAlumnoUi);
        }

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
        _mapColumnList[tareaAlumnoUi]?.add(EvaluacionTareaAlumnoUi());//Teclado numerico
      }
      //_mapColumnList[tareaAlumnoUi]?.add(RubricaEvaluacionFormulaPesoUi(RubricaEvaluacionUi()));//peso_criterio

      for(RubricaEvaluacionTareaAlumnoUi row in _mapRowList[tareaAlumnoUi]??[]){
        List<dynamic> cellList = [];
        //cellList.add(row);
        String? valorTipoNotaIdFirebase = null;
        double? notaFirebase = null;
        EvaluacionUi? evaluacionUi = row.rubricaEvaluacionUi?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == tareaAlumnoUi.personaUi?.personaId);
        EvaluacionUi? evaluacionCabeceraUi = rubricaEvalUI?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == tareaAlumnoUi.personaUi?.personaId);
        if(evaluacionUi== null){
          evaluacionUi = EvaluacionUi();
          evaluacionUi.personaUi = tareaAlumnoUi.personaUi;
          evaluacionUi.personaUi?.soloApareceEnElCurso = true;
          evaluacionUi.alumnoId =  tareaAlumnoUi.personaUi?.personaId;
          evaluacionUi.rubroEvaluacionId = row.rubricaEvaluacionUi?.rubroEvaluacionId;
          evaluacionUi.rubroEvaluacionUi = row.rubricaEvaluacionUi;
          row.rubricaEvaluacionUi?.evaluacionUiList?.add(evaluacionUi);
        }

        if(evaluacionCabeceraUi== null){
          evaluacionCabeceraUi = EvaluacionUi();
          evaluacionCabeceraUi.personaUi = tareaAlumnoUi.personaUi;
          evaluacionCabeceraUi.alumnoId =  tareaAlumnoUi.personaUi?.personaId;
          evaluacionCabeceraUi.rubroEvaluacionId = rubricaEvalUI?.rubroEvaluacionId;
          evaluacionCabeceraUi.rubroEvaluacionUi = rubricaEvalUI;
          evaluacionCabeceraUi.personaUi?.soloApareceEnElCurso = true;
          rubricaEvalUI?.evaluacionUiList?.add(evaluacionCabeceraUi);
        }

        if(row.rubricaEvaluacionUi?.tipoRubroEvaluacion == TipoRubroEvaluacion.UNIDIMENSIONAL){
          valorTipoNotaIdFirebase = tareaAlumnoUi.valorTipoNotaId;
          notaFirebase = tareaAlumnoUi.nota;

          tareaAlumnoUi.valorTipoNotaId = evaluacionUi.valorTipoNotaId;//remplazar con la nota de la tarea
          tareaAlumnoUi.nota = evaluacionUi.nota;//remplazar con la nota de la tarea
          tareaAlumnoUi.tipoNotaUi = row.rubricaEvaluacionUi?.tipoNotaUi;
        }else{
          TareaEvaluacionUi? tareaEvaluacionUi = tareaAlumnoUi.evaluacion?.firstWhereOrNull((element) => element.desempenioIcdId == row.rubricaEvaluacionUi?.desempenioIcdId);
          valorTipoNotaIdFirebase = tareaEvaluacionUi?.valorTipoNotaId;
          notaFirebase = tareaEvaluacionUi?.nota;

          tareaEvaluacionUi?.valorTipoNotaId = evaluacionUi.valorTipoNotaId;//remplazar con la nota de la tarea
          tareaEvaluacionUi?.nota = evaluacionUi.nota;//remplazar con la nota de la tarea

          tareaAlumnoUi.tipoNotaUi = rubricaEvalUI?.tipoNotaUi;
          tareaAlumnoUi.valorTipoNotaId = evaluacionCabeceraUi.valorTipoNotaId;//remplazar con la nota de la tarea
          tareaAlumnoUi.nota = evaluacionCabeceraUi.nota;//remplazar con la nota de la tarea
        }




        if(rubricaEvalUI?.rubroEvaluacionId == tareaAlumnoUi.rubroEvalProcesoId){
          if(!_cambiosEvaluacionFirebase){
            //comprobar si existen cambios de evaluacion tarea en base datos y firebase
            //print("comprobar ${evaluacionUi?.nota} !=  ${notaFirebase}");
            _cambiosEvaluacionFirebase = (evaluacionUi.nota??0) != (notaFirebase??0);
          }
        }

        if(_cambiosEvaluacionFirebase){
          print("comprobar si ${evaluacionUi.nota} !=  ${notaFirebase}");
        }

        //evaluacionUi?.valorTipoNotaId = valorTipoNotaIdFirebase;//remplazar con la nota de la tarea
        //evaluacionUi?.nota = notaFirebase;//remplazar con la nota de la tarea
        evaluacionUi.personaUi = tareaAlumnoUi.personaUi;

        if(tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS || tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
          for(ValorTipoNotaUi valorTipoNotaUi in tipoNotaUi?.valorTipoNotaList??[]){

            EvaluacionTareaAlumnoRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi = EvaluacionTareaAlumnoRubricaValorTipoNotaUi();
            evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi = valorTipoNotaUi;
            evaluacionRubricaValorTipoNotaUi.evaluacionUi = evaluacionUi;
            evaluacionRubricaValorTipoNotaUi.toggle = valorTipoNotaUi.valorTipoNotaId == evaluacionUi.valorTipoNotaId;
            evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionTareaAlumnoUi = row;
            cellList.add(evaluacionRubricaValorTipoNotaUi);
          }
        }else{
          EvaluacionTareaAlumnoUi evaluacionTareaAlumnoUi = EvaluacionTareaAlumnoUi();
          evaluacionTareaAlumnoUi.evaluacionUi = evaluacionUi;
          evaluacionTareaAlumnoUi.rubricaEvaluacionTareaAlumnoUi = row;
          cellList.add(evaluacionTareaAlumnoUi);
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
        }  else if(s is EvaluacionTareaAlumnoUi){
          _tablecolumnWidths.add(55);
        }else if(s is RubricaEvaluacionFormulaPesoUi){
          _tablecolumnWidths.add(35);
        }else{
          _tablecolumnWidths.add(50.0);
        }
      }
    }
    refreshUI();
  }

  void actualizarListaAlumnos(){
    _tareaRecursoUiList = _tareaRecursoUiList2;
    _tareaAlumnoUiList.clear();
    _tareaAlumnoUiList.addAll(_tareaAlumnoUiList2);
    _tareaAlumnoUiList.removeWhere((element) => !(element.personaUi?.contratoVigente??false));
    _tareaAlumnoUiNoEvaluadosList = [];
    _tareaAlumnoUiEvaluadosList = [];
    tareaUi?.recursos = _tareaRecursoUiList2;
    refreshCountEvaluados();
  }

  @override
  void onInitState() {

    _progress = true;
    _progressRubro = true;
    refreshUI();
    presenter.getInformacionTarea(tareaUi, cursosUi, tareaUi?.unidadAprendizajeId);
    super.onInitState();
  }

  @override
  void onDisposed() {
    presenter.dispose();
    super.onDisposed();
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
    _cambiosTarea = true;
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

      switch(tareaAlumnoUi.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO){
        case TipoNotaTiposUi.SELECTOR_VALORES:
        case TipoNotaTiposUi.SELECTOR_ICONOS:
        if((tareaAlumnoUi.valorTipoNotaId??"").isNotEmpty
            && rubricaEvalUI != null)_alumnoEval++;
        else _alumnoSinEval++;
          break;
        default:
          if((tareaAlumnoUi.nota??0) != 0
              && rubricaEvalUI != null)_alumnoEval++;
          else _alumnoSinEval++;
          break;
      }
    }
  }

  void successCrearEvaluacion(String? rubricaId) {
    _progressRubro =true;
    refreshUI();
    _cambiosTarea = true;
    //Traer las evaluaciones de la tarea del firebase*/
    presenter.getInformacionTarea(tareaUi, cursosUi, tareaUi?.unidadAprendizajeId);//1305160972
  }
/*
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
    tareaAlumnoUi?.success = 1;
    refreshUI();
    _uploadNotas[tareaAlumnoUi] = await presenter.updateEvalAlumnoAll(rubricaEvalUI, tareaAlumnoUi, tareaUi, calendarioPeriodoUI);
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
    evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.success = 1;
    refreshUI();
    _uploadNotas[tareaAlumnoUi] = await presenter.updateEvalAlumnoAll(rubricaEvalUI, tareaAlumnoUi, tareaUi, calendarioPeriodoUI);


  }*/

  void onClicEvaluarPresicion(EvaluacionTareaAlumnoRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, TareaAlumnoUi? tareaAlumnoUi, nota)async {
    for (List cellList in mapCellListList[tareaAlumnoUi] ?? []) {
      for (var cell in cellList) {
        if (cell is EvaluacionTareaAlumnoRubricaValorTipoNotaUi) {
          if (cell.evaluacionUi?.alumnoId == evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId
              && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionTareaAlumnoUi?.rubricaEvaluacionUi?.rubroEvaluacionId
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

    TareaEvaluacionUi? tareaEvaluacionUi = tareaAlumnoUi?.evaluacion?.firstWhereOrNull((element) => element.desempenioIcdId == evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionTareaAlumnoUi?.rubricaEvaluacionUi?.desempenioIcdId);
    tareaEvaluacionUi?.valorTipoNotaId = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId;
    tareaEvaluacionUi?.nota = nota;//actualizar la nota solo cuando no esta selecionado

    _actualizarCabecera(tareaAlumnoUi);
    refreshCountEvaluados();
    _cambiosTarea = true;
    //_uploadNotas[tareaAlumnoUi]?.cancel();
    _cambiosEvaluacion = true;
    evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionTareaAlumnoUi?.success = 1;
    refreshUI();
    _uploadNotas[tareaAlumnoUi] = await presenter.updateEvalAlumnoUi(rubricaEvalUI, evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionTareaAlumnoUi, tareaUi, calendarioPeriodoUI);


  }

  void onClicEvaluar(EvaluacionTareaAlumnoRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, TareaAlumnoUi? tareaAlumnoUi) async{


    for (List cellList in mapCellListList[tareaAlumnoUi] ?? []) {
      for (var cell in cellList) {
        if (cell is EvaluacionTareaAlumnoRubricaValorTipoNotaUi) {
          print("onClicEvaluar tareaAlumnoUi: ${cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId}");
          if (cell.evaluacionUi?.alumnoId == evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId
              && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionTareaAlumnoUi?.rubricaEvaluacionUi?.rubroEvaluacionId
              && cell != evaluacionRubricaValorTipoNotaUi) {
            cell.toggle = false;
          }
        }
      }
    }
    evaluacionRubricaValorTipoNotaUi.toggle = !(evaluacionRubricaValorTipoNotaUi.toggle ?? false);
    print("onClicEvaluar evaluacion: ${tareaAlumnoUi?.evaluacion}");
    TareaEvaluacionUi? tareaEvaluacionUi = tareaAlumnoUi?.evaluacion?.firstWhereOrNull((element) => element.desempenioIcdId == evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionTareaAlumnoUi?.rubricaEvaluacionUi?.desempenioIcdId);

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
    evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionTareaAlumnoUi?.success = 1;
    //_uploadNotas[tareaAlumnoUi]?.cancel();
    _cambiosEvaluacion = true;
    refreshUI();
    _uploadNotas[tareaAlumnoUi] = await presenter.updateEvalAlumnoUi(rubricaEvalUI, evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionTareaAlumnoUi, tareaUi, calendarioPeriodoUI);


  }

  void seEliminoEvaluacion() {
    print("changeEvaluacion");
    /*_cambiosTarea =true;
    _progress = true;*/
    rubricaEvalUI = null;
    tareaUi?.rubroEvalProcesoId = null;
    _progressRubro = true;
    _cambiosTarea = true;
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

 /* bool onSaveProgressEvaluacion() {
    bool subiendoEvaluacion = false;
    for(var evaluacion in _uploadNotas.entries){
      HttpStream? httpStream = evaluacion.value;
      print("httpStream.isFinished();: ${httpStream?.isFinished()}");
      subiendoEvaluacion = httpStream!=null && !httpStream.isFinished();
      break;
    }
    print("subiendoEvaluacion: ${subiendoEvaluacion}");
    if(subiendoEvaluacion){
      refreshUI();
      return true;
    }else{
      return false;
    }
  }*/

  bool onSaveProgressEvaluacion() {
    bool subiendoEvaluacion = false;

    for(var evaluacion in _mapRowList.entries){
      for(RubricaEvaluacionTareaAlumnoUi rubricaEvaluacionTareaAlumnoUi in evaluacion.value){
        int? success = rubricaEvaluacionTareaAlumnoUi.success;
        if(success == 1){
          subiendoEvaluacion = true;
          break;
        }
      }
    }
    return subiendoEvaluacion;
  }

  int onCountErrorGuardar() {
    int errorGuardar = 0;

    for(var evaluacion in _mapRowList.entries){

      for(RubricaEvaluacionTareaAlumnoUi rubricaEvaluacionTareaAlumnoUi in evaluacion.value){
        int? success = rubricaEvaluacionTareaAlumnoUi.success;
         if(success != null && success == -1){
           errorGuardar++;
        }
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
    for(var evaluacion in _mapRowList.entries){
      for(RubricaEvaluacionTareaAlumnoUi rubricaEvaluacionTareaAlumnoUi in evaluacion.value){
        int? success = rubricaEvaluacionTareaAlumnoUi.success;
        if(success != null && success == -1){
          TareaAlumnoUi? tareaAlumnoUi = tareaAlumnouiList.firstWhereOrNull((element) => element == evaluacion.key);
          if(tareaAlumnoUi==null){
            tareaAlumnouiList.add(evaluacion.key);
          }
        }
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

      if(onSaveProgressEvaluacion()){
        _progressCambiosEvaluacion1 = true;
        refreshUI();
      }else{
        _abrirRubrica = true;
        refreshUI();
      }

    }else{
      _abrirRubrica = true;
      refreshUI();
    }
  }

  void celearAbrirRubrica() {
    _abrirRubrica = false;
  }

  void cambioEvaluacion() {
    _cambiosTarea = true;
    refreshUI();
    getRubro();
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

  int? tareaAlumnoUiSuccess(TareaAlumnoUi tareaAlumnoUi) {
    List<RubricaEvaluacionTareaAlumnoUi> rubricaEvaluacionUiList = mapRowList[tareaAlumnoUi]??[];
    
    int? success = null;
    for(RubricaEvaluacionTareaAlumnoUi rubricaEvaluacionUi in rubricaEvaluacionUiList){
      if(rubricaEvaluacionUi.success!=null){
        success = rubricaEvaluacionUi.success;
      }
      if(success == 1){
        break;
      }else if(success != null && success == -1){
        break;
      }

    }
    
    return success;
  }

  void onSaveTecladoPresicion(nota, EvaluacionTareaAlumnoUi? evaluacionTareaAlumnoUi, TareaAlumnoUi? tareaAlumnoUi) async{
    if (evaluacionTareaAlumnoUi?.evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi ==  TipoNotaTiposUi.SELECTOR_VALORES || evaluacionTareaAlumnoUi?.evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS){
      ValorTipoNotaUi? valorTipoNotaUi = TransformarValoTipoNota.getValorTipoNota(evaluacionTareaAlumnoUi?.evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi, nota);

      for (List cellList in _mapCellListList[evaluacionTareaAlumnoUi?.evaluacionUi?.personaUi]??[]) {
        for (var cell in cellList) {
          if (cell is EvaluacionTareaAlumnoRubricaValorTipoNotaUi) {
            if (cell.evaluacionUi?.alumnoId == evaluacionTareaAlumnoUi?.evaluacionUi?.alumnoId
                && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionTareaAlumnoUi?.evaluacionUi?.rubroEvaluacionId
                && cell.valorTipoNotaUi?.valorTipoNotaId == valorTipoNotaUi?.valorTipoNotaId) {
              cell.toggle = true;
            }

            if (cell.evaluacionUi?.alumnoId == evaluacionTareaAlumnoUi?.evaluacionUi?.alumnoId
                && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionTareaAlumnoUi?.evaluacionUi?.rubroEvaluacionId
                && cell.valorTipoNotaUi?.valorTipoNotaId != valorTipoNotaUi?.valorTipoNotaId) {
              cell.toggle = false;
            }

          }
        }
      }
      evaluacionTareaAlumnoUi?.evaluacionUi?.valorTipoNotaId = valorTipoNotaUi?.valorTipoNotaId;
      evaluacionTareaAlumnoUi?.evaluacionUi?.valorTipoNotaUi = valorTipoNotaUi;

    }
    evaluacionTareaAlumnoUi?.evaluacionUi?.nota = nota;

    _actualizarCabecera(tareaAlumnoUi);
    refreshCountEvaluados();
    _cambiosTarea = true;
    //_uploadNotas[tareaAlumnoUi]?.cancel();
    _cambiosEvaluacion = true;
    evaluacionTareaAlumnoUi?.rubricaEvaluacionTareaAlumnoUi?.success = 1;
    refreshUI();
    _uploadNotas[tareaAlumnoUi] = await presenter.updateEvalAlumnoUi(rubricaEvalUI, evaluacionTareaAlumnoUi?.rubricaEvaluacionTareaAlumnoUi, tareaUi, calendarioPeriodoUI);


  }

  void getRubro() async{
    var response = await presenter.getRubroEvaluacion(tareaUi?.tareaId, cursosUi);
    this.rubricaEvalUI = response.rubricaEvaluacionUi;
    _progressRubro= false;
    actualizarListaAlumnos();

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


    _tareaAlumnoUiList.clear();
    _tareaAlumnoUiNoEvaluadosList = [];
    _tareaAlumnoUiEvaluadosList = [];

    List<TareaAlumnoUi> tareaAlumnoUiList = [];
    for(PersonaUi item in response.alumnoCursoList){
      TareaAlumnoUi? tareaAlumnoUi = _tareaAlumnoUiList2.firstWhereOrNull((element) => element.personaUi?.personaId == item.personaId);
      if(tareaAlumnoUi != null){
        tareaAlumnoUiList.add(tareaAlumnoUi);
      }
    }
    _tareaAlumnoUiList.addAll(tareaAlumnoUiList);

    initLista(response.alumnoCursoList, rubricaEvalUI);

    for(TareaAlumnoUi tareaAlumnoUi in _tareaAlumnoUiList){
      tareaAlumnoUi.toogle = toogleGeneral;
      switch(tareaAlumnoUi.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO){
        case TipoNotaTiposUi.SELECTOR_VALORES:
        case TipoNotaTiposUi.SELECTOR_ICONOS:
          if((tareaAlumnoUi.valorTipoNotaId??"").isNotEmpty
              && rubricaEvalUI != null){
            _tareaAlumnoUiEvaluadosList.add(tareaAlumnoUi);
          }
          else{
            _tareaAlumnoUiNoEvaluadosList.add(tareaAlumnoUi);
          }
          break;
        default:
          if((tareaAlumnoUi.nota??0) != 0
              && rubricaEvalUI != null){
            _tareaAlumnoUiEvaluadosList.add(tareaAlumnoUi);
          }
          else{
            _tareaAlumnoUiNoEvaluadosList.add(tareaAlumnoUi);
          }
          break;
      }
    }

    _mostrarAlumnosDosListas = (_tareaAlumnoUiNoEvaluadosList.isNotEmpty && _tareaAlumnoUiEvaluadosList.isNotEmpty);

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
    refreshCountEvaluados();
    refreshUI();
  }



}