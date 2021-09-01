import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/portal/rubro_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_calendario_periodo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:collection/collection.dart';

class RubroController extends Controller{
  OrigenRubroUi _origenRubroUi = OrigenRubroUi.TODOS;
  OrigenRubroUi get origenRubroUi => _origenRubroUi;
  CursosUi cursosUi;
  List<CalendarioPeriodoUI> _calendarioPeriodoList = [];
  List<CalendarioPeriodoUI> get calendarioPeriodoList => _calendarioPeriodoList;
  CalendarioPeriodoUI? _calendarioPeriodoUI = null;
  CalendarioPeriodoUI? get calendarioPeriodoUI => _calendarioPeriodoUI;
  RubroPresenter presenter;
  List<dynamic>? _rubricaEvaluacionUiList = null;
  List<dynamic>? get rubricaEvaluacionUiList => _rubricaEvaluacionUiList;
  List<UnidadUi> _unidadUiList = [];
  List<UnidadUi> get unidadUiList => _unidadUiList;
  Map<SesionUi, List<dynamic>> mapSesionRubroList = new Map();
  String? _msgToast = null;
  String? get msgToast => _msgToast;
  bool _progress = true;
  bool get progress => _progress;
  List<dynamic> _columnList2 = [];
  List<dynamic> get columnList2 => _columnList2;
  List<dynamic> _rowList2 = [];
  List<dynamic> get rowList2 => _rowList2;
  List<List<dynamic>> _cellListList = [];
  List<List<dynamic>> get cellListList => _cellListList;
  TipoNotaUi? _tipoNotaUi = null;
  TipoNotaUi? get tipoNotaUi => _tipoNotaUi;
  bool _showDialogModoOffline = false;
  bool get showDialogModoOffline => _showDialogModoOffline;

  RubroController(this.cursosUi, calendarioPeriodoRepo, configuracionRepo, httpDatosRepo, rubroRepo)
      :this.presenter = RubroPresenter(calendarioPeriodoRepo, configuracionRepo, httpDatosRepo, rubroRepo)
  , super();

  @override
  void initListeners() {
    presenter.getCalendarioPeridoOnComplete = (List<CalendarioPeriodoUI>? calendarioPeridoList, CalendarioPeriodoUI? calendarioPeriodoUI, bool? errorServidor, bool? offlineServidor){
      _calendarioPeriodoList = calendarioPeridoList??[];
      _calendarioPeriodoUI = calendarioPeriodoUI;
      _calendarioPeriodoUI?.habilitado = 1;
      _origenRubroUi = OrigenRubroUi.TODOS;
      _progress = true;
      _showDialogModoOffline = offlineServidor??false;
      refreshUI();
      //presenter.onGetRubricaList(cursosUi, calendarioPeriodoUI, _origenRubroUi);
      //presenter.onGetUnidadRubroEval(cursosUi, calendarioPeriodoUI);
      //presenter.onGetCompetenciaRubroEval(cursosUi, calendarioPeriodoUI);

      if(!(offlineServidor??false)){
        presenter.onActualizarCurso(calendarioPeriodoUI, cursosUi);
      }
    };

    presenter.getCalendarioPeridoOnError = (e){
      _calendarioPeriodoList = [];
      _calendarioPeriodoUI = null;
      _origenRubroUi = OrigenRubroUi.TODOS;
      _progress = false;
      refreshUI();
    };

    presenter.updateDatosCrearRubroOnNext = (bool? errorConexion, bool? errorServidor){
      _progress = true;
      _msgToast = (errorServidor??false)? "!Oops! Al parecer ocurrió un error involuntario.":null;
      _msgToast = (errorConexion??false)? "No hay Conexión a Internet...":null;
      refreshUI();
      print("updateDatosCrearRubroOnNext");
      if(!(errorConexion??false)){
        print("updateDatosCrearRubroOnNext 1");
        onListarTabsRubroEvaluacion();
      }

    };

    presenter.updateDatosCrearRubroOnError = (e){

    };

    presenter.getRubroEvaluacionOnNext = (List<RubricaEvaluacionUi> rubricaEvalUiList){
      _rubricaEvaluacionUiList = [];
      if(calendarioPeriodoUI!=null&&(calendarioPeriodoUI?.habilitado??0)==1){
        _rubricaEvaluacionUiList?.add("add");
      }
      _rubricaEvaluacionUiList?.addAll(rubricaEvalUiList);

      _progress = false;
      refreshUI();
    };

    presenter.getRubroEvaluacionOnError = (e){
      _rubricaEvaluacionUiList = [];
      _progress = false;
      refreshUI();
    };

    presenter.getUnidadRubroEvalOnNext = (List<UnidadUi> unidadUiList){
      _unidadUiList = unidadUiList;
      mapSesionRubroList.clear();
      for(UnidadUi unidadUi in unidadUiList){
        for(SesionUi sesionUi in unidadUi.sesionUiList??[]){
          mapSesionRubroList[sesionUi] = [];
          if(calendarioPeriodoUI!=null&&(calendarioPeriodoUI?.habilitado??0)==1){
            mapSesionRubroList[sesionUi]!.add("add");
          }
          mapSesionRubroList[sesionUi]!.addAll(sesionUi.rubricaEvaluacionUiList??[]);
          int maxCantidad = 4;
          if(mapSesionRubroList[sesionUi]!.length >= maxCantidad){
            List<dynamic> list =[];
            for(int i =0; i < maxCantidad - 1; i++){
              list.add(mapSesionRubroList[sesionUi]![i]);
            }
            list.add("ver_mas");
            mapSesionRubroList[sesionUi] = list;
          }

        }
      }
      refreshUI();
    };

    presenter.getUnidadRubroEvalOnError = (e){
      _unidadUiList = [];
      refreshUI();
    };

    //presenter.getCompetenciaRubroEvalOnNext(response?.competenciaUiList, response?.personaUiList, response?.evaluacionCompetenciaUiList);
    presenter.getCompetenciaRubroEvalOnNext = (List<CompetenciaUi> competenciaUiList, List<PersonaUi> personaUiList, List<EvaluacionCompetenciaUi> evaluacionCompetenciaUiList,  List<EvaluacionCalendarioPeriodoUi> evaluacionCalendarioPeriodoUiList){


      _rowList2.clear();
      _rowList2.addAll(personaUiList);
      _rowList2.add("");//Espacio
      _rowList2.add("");//Espacio
      _rowList2.add("");//Espacio



      _cellListList.clear();
      _columnList2.clear();
      _columnList2.add(ContactoUi());//Titulo alumno

      //Competencia Base
      for(CompetenciaUi competenciaUi in competenciaUiList){
        if(competenciaUi.tipoCompetenciaUi == TipoCompetenciaUi.BASE){
          _columnList2.addAll(competenciaUi.capacidadUiList??[]);
          _columnList2.add(competenciaUi);
        }
      }
      //Competencia Base

      _columnList2.add(calendarioPeriodoUI);

      //Competencia Enfoque Transversal
      for(CompetenciaUi competenciaUi in competenciaUiList){
        if(competenciaUi.tipoCompetenciaUi != TipoCompetenciaUi.BASE){
          _columnList2.addAll(competenciaUi.capacidadUiList??[]);
          _columnList2.add(competenciaUi);
        }
      }
      //Competencia Enfoque Transversal

      _columnList2.add("");// espacio

      for(dynamic column in _rowList2){
        List<dynamic>  cellList = [];
        cellList.add(column);

        //Competencia Base
        for(CompetenciaUi competenciaUi in competenciaUiList){
          if(competenciaUi.tipoCompetenciaUi == TipoCompetenciaUi.BASE){
            if(column is PersonaUi){
              EvaluacionCompetenciaUi? evaluacionCompetenciaUi = evaluacionCompetenciaUiList.firstWhereOrNull((element) => element.personaUi?.personaId == column.personaId && competenciaUi.competenciaId == element.competenciaUi?.competenciaId);

              for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
                EvaluacionCapacidadUi? evaluacionCapacidadUi = evaluacionCompetenciaUi?.evaluacionCapacidadUiList?.firstWhereOrNull((element) => element.personaUi?.personaId == column.personaId && capacidadUi.capacidadId == element.capacidadUi?.capacidadId);
                cellList.add(evaluacionCapacidadUi);
              }
              cellList.add(evaluacionCompetenciaUi);
            }else{//si el row is un espacio
              for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
                cellList.add("");// espacio
              }
              cellList.add("");// espacio
            }
          }
        }
        //Competencia Base
        //Nota Final
        if (column is PersonaUi){
          EvaluacionCalendarioPeriodoUi? evaluacionCalendarioPeriodoUi = evaluacionCalendarioPeriodoUiList.firstWhereOrNull((element) => element.personaUi?.personaId == column.personaId);
          cellList.add(evaluacionCalendarioPeriodoUi);
        } else{//si el row is un espacio
          cellList.add("");// espacio
        }

        //Nota Final
        //Competencia Enfoque y Transversal
        for(CompetenciaUi competenciaUi in competenciaUiList){
          if(competenciaUi.tipoCompetenciaUi != TipoCompetenciaUi.BASE){
            if(column is PersonaUi){
              EvaluacionCompetenciaUi? evaluacionCompetenciaUi = evaluacionCompetenciaUiList.firstWhereOrNull((element) => element.personaUi?.personaId == column.personaId && competenciaUi.competenciaId == element.competenciaUi?.competenciaId);

              for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
                EvaluacionCapacidadUi? evaluacionCapacidadUi = evaluacionCompetenciaUi?.evaluacionCapacidadUiList?.firstWhereOrNull((element) => element.personaUi?.personaId == column.personaId && capacidadUi.capacidadId == element.capacidadUi?.capacidadId);
                cellList.add(evaluacionCapacidadUi);
              }
              cellList.add(evaluacionCompetenciaUi);
            }else{//si el row is un espacio
              for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
                cellList.add("");// espacio
              }
              cellList.add("");// espacio
            }
          }
        }
        //Competencia Enfoque y Transversal


        cellList.add("");// espacio
        _cellListList.add(cellList);
      }


      refreshUI();
    };

    presenter.getCompetenciaRubroEvalOnError = (e){
      _rowList2 = [];
      _columnList2.clear();
      _cellListList.clear();
      refreshUI();
    };
  }


  @override
  void onInitState() {
    presenter.getCalendarioPerido(cursosUi);
    super.onInitState();
  }

  void onSelectedCalendarioPeriodo(CalendarioPeriodoUI calendarioPeriodoUi) {
    this._calendarioPeriodoUI = calendarioPeriodoUi;
    _calendarioPeriodoUI?.habilitado = 1;
    for(var item in  _calendarioPeriodoList){
      item.selected = false;
    }
    calendarioPeriodoUI?.selected = true;
    _origenRubroUi = OrigenRubroUi.TODOS;
    _progress = true;
    //presenter.getEvaluacion(calendarioPeriodoUi);
    refreshUI();
    Future.delayed(const Duration(milliseconds: 1000), () {
      presenter.onActualizarCurso(calendarioPeriodoUI, cursosUi);
    });


    //presenter.onGetRubricaList(cursosUi, calendarioPeriodoUI, _origenRubroUi);
    //presenter.onGetUnidadRubroEval(cursosUi, calendarioPeriodoUI);
    //presenter.onGetCompetenciaRubroEval(cursosUi, calendarioPeriodoUI);
  }

  void onSyncronizarCurso() {
    _progress = true;
    presenter.onActualizarCurso(calendarioPeriodoUI, cursosUi);
    refreshUI();
  }

  void respuestaFormularioCrearRubro() {
    print("respuestaFormularioCrearRubro");
    _progress = true;
    refreshUI();
    onListarTabsRubroEvaluacion();
  }

  void respuestaEvaluacionCapacidad() {
    _progress = true;
    refreshUI();
    onListarTabsRubroEvaluacion();
  }

  void respuestaEvaluacion() {
    _progress = true;
    refreshUI();
    onListarTabsRubroEvaluacion();
  }


  void clicMostrarSolo(OrigenRubroUi origenRubroUi) {
    _origenRubroUi = origenRubroUi;
    _progress = true;
    refreshUI();
    Future.delayed(const Duration(milliseconds: 1000), () {
      presenter.onGetRubricaList(cursosUi, calendarioPeriodoUI, _origenRubroUi);
    });

  }

  void successMsg() {
    _msgToast = null;
  }

  List<dynamic> getRubrosSesionDialog(SesionUi sesionUi) {
    List<dynamic> list = [];
    if(calendarioPeriodoUI!=null&&(calendarioPeriodoUI?.habilitado??0)==1){
      list.add("add");
    }
    list.addAll(sesionUi.rubricaEvaluacionUiList??[]);
    return list;
  }

  void onClicContinuarOffline() {
    _showDialogModoOffline = false;
    refreshUI();
    onListarTabsRubroEvaluacion();
  }

  void onListarTabsRubroEvaluacion(){
    presenter.onGetRubricaList(cursosUi, calendarioPeriodoUI, _origenRubroUi);
    presenter.onGetUnidadRubroEval(cursosUi, calendarioPeriodoUI);
    presenter.onGetCompetenciaRubroEval(cursosUi, calendarioPeriodoUI);
  }

}