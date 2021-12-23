import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/portal/rubro_presenter.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/resultado/table_resultado.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_calendario_periodo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/matriz_resultado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
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
  Map<SesionUi, List<dynamic>> _sesionItemsMap = new Map();
  Map<SesionUi, List<dynamic>> get sesionItemsMap => _sesionItemsMap;
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
  bool _showDialogInformar = false;
  bool get showDialogInformar => _showDialogInformar;
  int _seletedItem = 0;
  int get seletedItem => _seletedItem;
  bool _precision = false;
  bool get precision => _precision;

  bool _listar_eval_sesiones = false;
  bool get listar_eval_sesiones => _listar_eval_sesiones;

  bool _datosOfflineResultado = false;
  bool get datosOfflineResultado => _datosOfflineResultado;
  List<dynamic> _rowsResultado = [];
  List<dynamic> get rowsResultado =>_rowsResultado;
  List<dynamic> _columnsResultado = [];
  List<dynamic> get columnsResultado => _columnsResultado;
  List<List<dynamic>> _cellsResultado = [];
  List<List<dynamic>> get cellsResultado => _cellsResultado;
  bool _precisionResultado = false;
  bool get precisionResultado => _precisionResultado;
  bool _listarResultado = true;
  bool _progressResultado = true;
  bool get progressResultado => _progressResultado;
  double _scrollResultadoX = 0;
  double get scrollResultadoX => _scrollResultadoX;
  double _scrollResultadoY = 0;
  double get scrollResultadoY => _scrollResultadoY;

  double _scrollRubroProcesoX = 0;
  double get scrollRubroProcesoX => _scrollRubroProcesoX;

  double _scrollRubroProcesoY = 0;
  double get scrollRubroProcesoY => _scrollRubroProcesoY;

  RubroController(this.cursosUi, calendarioPeriodoRepo, configuracionRepo, httpDatosRepo, rubroRepo, resultadoRepo)
      :this.presenter = RubroPresenter(calendarioPeriodoRepo, configuracionRepo, httpDatosRepo, rubroRepo, resultadoRepo)
  , super();



  @override
  void initListeners() {
    presenter.getCalendarioPeridoOnComplete = (List<CalendarioPeriodoUI>? calendarioPeridoList, CalendarioPeriodoUI? calendarioPeriodoUI){
      _calendarioPeriodoList = calendarioPeridoList??[];
      _calendarioPeriodoUI = calendarioPeriodoUI;
      //_calendarioPeriodoUI?.habilitado = 1;
      _origenRubroUi = OrigenRubroUi.TODOS;
      _progress = true;
      refreshUI();
      //presenter.onGetRubricaList(cursosUi, calendarioPeriodoUI, _origenRubroUi);
      //presenter.onGetUnidadRubroEval(cursosUi, calendarioPeriodoUI);
      //presenter.onGetCompetenciaRubroEval(cursosUi, calendarioPeriodoUI);
      print("Finish updateDatosCrearRubroOnNext");
      presenter.onActualizarCurso(calendarioPeriodoUI, cursosUi);
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
      //_showDialogModoOffline = errorConexion??false;
      print("Finish updateDatosCrearRubroOnNext");
      onListarTabsRubroEvaluacion();

      refreshUI();
    };

    presenter.updateDatosCrearRubroOnError = (e){

    };

    presenter.getRubroEvaluacionOnNext = (List<RubricaEvaluacionUi> rubricaEvalUiList){
      _rubricaEvaluacionUiList = [];
      if(calendarioPeriodoUI!=null&&(calendarioPeriodoUI?.habilitado??0)==1){
        _rubricaEvaluacionUiList?.add("add");
      }

      int  count = 0;
      for(RubricaEvaluacionUi rubroUi in rubricaEvalUiList){
        rubroUi.position = rubricaEvalUiList.length - count;
        count++;
      }
      _rubricaEvaluacionUiList?.addAll(rubricaEvalUiList);

      if(_seletedItem==0||_seletedItem==2)_progress = false;//ocultar el progress cuando se esta en el tab rubro

      print("_seletedItem: ${_seletedItem}");
      refreshUI();
    };

    presenter.getRubroEvaluacionOnError = (e){
      _rubricaEvaluacionUiList = [];
      if(_seletedItem==0||_seletedItem==2)_progress = false;//ocultar el progress cuando se esta en el tab rubro
      print("_seletedItem: ${_seletedItem}");
      refreshUI();
    };

    presenter.getUnidadRubroEvalOnNext = (List<UnidadUi> unidadUiList){
      _unidadUiList = unidadUiList;
      _sesionItemsMap.clear();
      for(UnidadUi unidadUi in unidadUiList){
        int count_sesion = 0;
        for(SesionUi sesionUi in unidadUi.sesionUiList??[]){
          sesionUi.cantSesion = unidadUi.sesionUiList?.length;
          //if(count_sesion==0)sesionUi.toogle2 = true;
          _sesionItemsMap[sesionUi] = [];

          if(calendarioPeriodoUI?.habilitado==1)
          _sesionItemsMap[sesionUi]?.add("");

          int  count = 0;
          for(RubricaEvaluacionUi rubroUi in sesionUi.rubricaEvaluacionUiList??[]){
            rubroUi.position = sesionUi.rubricaEvaluacionUiList!.length - count;
            _sesionItemsMap[sesionUi]?.add(rubroUi);
            count++;
          }
          count_sesion ++;
        }
      }
      if(_seletedItem==0||_seletedItem==2)_progress = false;
      print("_seletedItem: ${_seletedItem}");
      refreshUI();
    };

    presenter.getUnidadRubroEvalOnError = (e){
      _unidadUiList = [];
      _sesionItemsMap.clear();
      if(_seletedItem==0||_seletedItem==2)_progress = false;
      print("_seletedItem: ${_seletedItem}");
      refreshUI();
    };

    //presenter.getCompetenciaRubroEvalOnNext(response?.competenciaUiList, response?.personaUiList, response?.evaluacionCompetenciaUiList);
    presenter.getCompetenciaRubroEvalOnNext = (List<CompetenciaUi> competenciaUiList, List<PersonaUi> personaUiList, List<EvaluacionCompetenciaUi> evaluacionCompetenciaUiList,  List<EvaluacionCalendarioPeriodoUi> evaluacionCalendarioPeriodoUiList, TipoNotaUi tipoNotaUi){
     _tipoNotaUi = tipoNotaUi;
     // static const int TN_VALOR_NUMERICO = 410, TN_SELECTOR_NUMERICO = 411, TN_SELECTOR_VALORES = 412, TN_SELECTOR_ICONOS = 409, TN_VALOR_ASISTENCIA= 474;
     //_tipoNotaUi?.tipoId = 409;
     //_tipoNotaUi?.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_ICONOS;
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
     bool round = false;//solo es visual para la redondera
      for(CompetenciaUi competenciaUi in competenciaUiList){
        if(competenciaUi.tipoCompetenciaUi != TipoCompetenciaUi.BASE){
          if(!round){
            if((competenciaUi.capacidadUiList??[]).isNotEmpty){
              round = true;
              CapacidadUi capacidadUi = competenciaUi.capacidadUiList![0];
              capacidadUi.round = true;
            }
          }

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

      if(_seletedItem==1||_seletedItem==2)_progress = false;//ocultar el progress cuando se esta en el tab competencia
     print("_seletedItem: ${_seletedItem}");
      refreshUI();
    };

    presenter.getCompetenciaRubroEvalOnError = (e){
      _tipoNotaUi = null;
      _rowList2 = [];
      _columnList2.clear();
      _cellListList.clear();
      if(_seletedItem==1||_seletedItem==2)_progress = false;//ocultar el progress cuando se esta en el tab competencia
      print("_seletedItem: ${_seletedItem}");
      refreshUI();
    };


    presenter.getResultadosOnComplete = (MatrizResultadoUi? matrizResultadoUi, bool? offlineServidor, bool? errorServidor){
      _rowsResultado = [];
      _columnsResultado = [];
      _cellsResultado = [];

      var result = TableResultadoUtils.getTableResulData(matrizResultadoUi, calendarioPeriodoUI);
      _rowsResultado.addAll(result.rows??[]);
      _columnsResultado.addAll(result.columns??[]);
      _cellsResultado.addAll(result.cells??[]);

      _progressResultado = false;
      print("_seletedItem: ${_seletedItem}");
      refreshUI();
    };

    presenter.getResultadosOnError = (e){
      _cellsResultado.clear();
      _rowsResultado.clear();
      _columnsResultado.clear();
      _progressResultado = false;
      print("_seletedItem: ${_seletedItem}");
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
    //_calendarioPeriodoUI?.habilitado = 1;
    for(var item in  _calendarioPeriodoList){
      item.selected = false;
    }
    calendarioPeriodoUI?.selected = true;
    _origenRubroUi = OrigenRubroUi.TODOS;
    _progress = true;
    //presenter.getEvaluacion(calendarioPeriodoUi);

    if(_seletedItem == 2){
      _progressResultado = true;
      presenter.getResultados(cursosUi, calendarioPeriodoUI);
    }

    _scrollResultadoX = 0;
    _scrollResultadoY = 0;
    _scrollRubroProcesoX = 0;
    _scrollRubroProcesoY = 0;
    refreshUI();

    presenter.onActualizarCurso(calendarioPeriodoUI, cursosUi);

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
    _progress = true;
    refreshUI();
    onListarTabsRubroEvaluacion();
  }

  void respuestaEvaluacionCapacidad() {
    print("respuestaEvaluacionCapacidad");
    _progress = true;
    refreshUI();
    onListarTabsRubroEvaluacion2();
  }

  void respuestaEvaluacion() {
    _progress = true;
    refreshUI();
    onListarTabsRubroEvaluacion();
  }


  void clicMostrarSolo(OrigenRubroUi origenRubroUi) {
    _origenRubroUi = origenRubroUi;
    _listar_eval_sesiones = false;
    _progress = true;
    refreshUI();
    presenter.onGetRubricaList(cursosUi, calendarioPeriodoUI, _origenRubroUi);

  }

  void clicMostrarSoloSesiones() {
    _origenRubroUi = origenRubroUi;
    _listar_eval_sesiones = true;
    _progress = true;
    refreshUI();
    presenter.onGetUnidadRubroEval(cursosUi, calendarioPeriodoUI);
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
    /*Se limpia la tabla competencia debio que en las prubas en modo debug se demora en mostarar la tabla siembar en relase no existe el problema de espera*/
    _rowList2 = [];
    _columnList2.clear();
    _cellListList.clear();
    refreshUI();
    /*Se limpia la tabla competencia*/

    if(!_listar_eval_sesiones){
      presenter.onGetRubricaList(cursosUi, calendarioPeriodoUI, _origenRubroUi);
    }else{
      presenter.onGetUnidadRubroEval(cursosUi, calendarioPeriodoUI);
    }

    presenter.onGetCompetenciaRubroEval(cursosUi, calendarioPeriodoUI);
  }

  void onListarTabsRubroEvaluacion2(){

    if(!_listar_eval_sesiones){
      presenter.onGetRubricaList(cursosUi, calendarioPeriodoUI, _origenRubroUi);
    }else{
      presenter.onGetUnidadRubroEval(cursosUi, calendarioPeriodoUI);
    }

    presenter.onGetCompetenciaRubroEval(cursosUi, calendarioPeriodoUI);
  }

  void onChangeTab(int index) {
    if(_seletedItem != index && index == 2 && _listarResultado){
      _progressResultado = true;
      _listarResultado = false;
      presenter.getResultados(cursosUi, calendarioPeriodoUI);
    }
    _seletedItem = index;
    refreshUI();
  }

  onClicPrecision() {
    this._precision = !_precision;
    refreshUI();
  }

  void respuestaPesoCriterio() {
    print("respuestaPesoCriterio");
    _progress = true;
    refreshUI();
    onListarTabsRubroEvaluacion2();
  }

  void onClickSalirDialogInformar() {
    _showDialogInformar = false;
    refreshUI();
  }

  void onClickShowDialogInformar() {
    _showDialogInformar = true;
    refreshUI();
  }

  void onClickVerMas(SesionUi sesionUi) {
    sesionUi.ver_mas = !(sesionUi.ver_mas??false);
    refreshUI();
  }

  void onClickSesion(SesionUi sesionUi, UnidadUi unidadUi) {
    sesionUi.toogle2 = !(sesionUi.toogle2??false);

    if(sesionUi.toogle2??false){
      bool selecionado = true;
      for(SesionUi sesionUi in unidadUi.sesionUiList??[]){
        if(!(sesionUi.toogle2??false)){
          selecionado = false;
          break;
        }
      }
      unidadUi.toogle = selecionado;
    }else{
      unidadUi.toogle = false;
    }
    refreshUI();
  }

  onClickMostrarTodo(UnidadUi unidadUi) {
    unidadUi.toogle = !(unidadUi.toogle??false);
    for(SesionUi sesionUi in unidadUi.sesionUiList??[]){
      sesionUi.toogle2 =  unidadUi.toogle;
    }
    refreshUI();
  }

  void scrollResultado(double x, double y) {
    _scrollResultadoX = x;
    _scrollResultadoY = y;
  }

  void scrollRubroProceso(double x, double y) {
    _scrollRubroProcesoX = x;
    _scrollRubroProcesoY = y;
  }

  onClicPrecisionResultado() {
    _precisionResultado = !_precisionResultado;
    refreshUI();
  }
  
}

