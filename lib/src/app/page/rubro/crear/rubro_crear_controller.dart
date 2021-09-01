import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/crear/rubro_crear_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/forma_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/crear_server_rubro_evaluacion.dart';

class RubroCrearController extends Controller{

  RubroCrearPresenter presenter;
  CursosUi? cursosUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;
  RubricaEvaluacionUi? rubroUi;
  String? _mensaje = null;
  bool _showDialog = false;
  bool get showDialog => _showDialog;
  String? get mensaje => _mensaje;
  String?  _tituloRubrica = null;
  String? get tituloRubrica => _tituloRubrica;
  FormaEvaluacionUi? _formaEvaluacionUi = null;
  FormaEvaluacionUi? get formaEvaluacionUi => _formaEvaluacionUi;
  List<FormaEvaluacionUi> _formaEvaluacionUiList = [];
  List<FormaEvaluacionUi> get formaEvaluacionUiList => _formaEvaluacionUiList;
  TipoEvaluacionUi? _tipoEvaluacionUi = null;
  TipoEvaluacionUi? get tipoEvaluacionUi => _tipoEvaluacionUi;
  List<TipoEvaluacionUi> _tipoEvaluacionUiList = [];
  List<TipoEvaluacionUi> get tipoEvaluacionUiList => _tipoEvaluacionUiList;

  TipoNotaUi? _tipoNotaUi = null;
  TipoNotaUi? get tipoNotaUi => _tipoNotaUi;
  List<TipoNotaUi> _tipoNotaUiList = [];
  List<TipoNotaUi> get tipoNotaUiList => _tipoNotaUiList;

  List<CriterioUi> _criterioUiList = [];
  List<CriterioUi> get criterioUiList => _criterioUiList;

  List<CompetenciaUi> _competenciaUiBaseList = [];
  List<CompetenciaUi> get competenciaUiBaseList => _competenciaUiBaseList;
  List<CompetenciaUi> _competenciaUiTransversalList = [];
  List<CompetenciaUi> get competenciaUiTransversalList => _competenciaUiTransversalList;
  List<CompetenciaUi> _competenciaUiEnfoqueList = [];
  List<CompetenciaUi> get competenciaUiEnfoqueList => _competenciaUiEnfoqueList;

  List<dynamic> _tableTipoNotaColumns = [];
  List<dynamic> get tableTipoNotaColumns => _tableTipoNotaColumns;
  List<List<dynamic>> _tableTipoNotaCells = [];
  List<List<dynamic>> get tableTipoNotaCells => _tableTipoNotaCells;
  List<double> _tableTipoNotacolumnWidths = [];
  List<double> get tableTipoNotacolumnWidths => _tableTipoNotacolumnWidths;

  String? _tituloCriterio = null;
  String? get tituloCriterio => _tituloCriterio;
  List<TemaCriterioUi> _temaCriterioEditList = [];
  List<TemaCriterioUi> get temaCriterioEditList => _temaCriterioEditList;
  RubroCrearController(this.cursosUi, this.calendarioPeriodoUI, this.rubroUi, rubroRepo, usuarioRepo, httpDatosRepo): presenter = new RubroCrearPresenter(rubroRepo,usuarioRepo, httpDatosRepo);

  @override
  void initListeners() {
    presenter.getFormaEvaluacionOnNext = (List<FormaEvaluacionUi> formaEvaluacionUiList, FormaEvaluacionUi? formaEvaluacionUi){
      _formaEvaluacionUiList = formaEvaluacionUiList;
      _formaEvaluacionUi = formaEvaluacionUi;
      //refreshUI();
    };

    presenter.getFormaEvaluacionOnError = (e){
      _formaEvaluacionUiList = [];
      _formaEvaluacionUi = null;
      refreshUI();
    };
    presenter.getTipoEvaluacionOnNext = (List<TipoEvaluacionUi> tipoEvaluacionUiList, TipoEvaluacionUi? tipoEvaluacionUi){
      _tipoEvaluacionUiList = tipoEvaluacionUiList;
      _tipoEvaluacionUi = tipoEvaluacionUi;
      //refreshUI();
    };

    presenter.getFormaEvaluacionOnError = (e){
      _tipoEvaluacionUiList = [];
      _tipoEvaluacionUi = null;
      refreshUI();
    };

    presenter.getTipoNotaOnNext = (List<TipoNotaUi> tipoNotaUiList, TipoNotaUi? tipoNotaUi){
      _tipoNotaUiList = tipoNotaUiList;
      _tipoNotaUi = tipoNotaUi;
      iniciarTablaTipoNota();
      refreshUI();
    };

    presenter.getTipoNotaOnError = (e){
      _tipoNotaUiList = [];
      _tipoNotaUi = null;
      iniciarTablaTipoNota();
      refreshUI();
    };



    presenter.getTemaCriteriosOnNext = (List<CompetenciaUi> competenciaUiList){
      _competenciaUiBaseList.clear();
      _competenciaUiTransversalList.clear();
      _competenciaUiEnfoqueList.clear();
      for(CompetenciaUi co in competenciaUiList){
        if(co.tipoCompetenciaUi == TipoCompetenciaUi.BASE)_competenciaUiBaseList.add(co);
        if(co.tipoCompetenciaUi == TipoCompetenciaUi.TRANSVERSAL)_competenciaUiTransversalList.add(co);
        if(co.tipoCompetenciaUi == TipoCompetenciaUi.ENFOQUE)_competenciaUiEnfoqueList.add(co);
      }
      refreshUI();
    };
    presenter.getTemaCriteriosOnError = (e){
      _competenciaUiBaseList.clear();
      _competenciaUiTransversalList.clear();
      _competenciaUiEnfoqueList.clear();
      refreshUI();
    };

  }


  void iniciarTablaTipoNota(){
    _tableTipoNotaColumns.clear();
    _tableTipoNotacolumnWidths.clear();
    _tableTipoNotaCells.clear();
    _criterioUiList.clear();

    List<CompetenciaUi> competenciaUiList = [];
    competenciaUiList.addAll(_competenciaUiBaseList);
    competenciaUiList.addAll(_competenciaUiTransversalList);
    competenciaUiList.addAll(_competenciaUiEnfoqueList);
    for(CompetenciaUi competenciaUi in competenciaUiList){
      for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
        for(CriterioUi criterioUi in capacidadUi.criterioUiList??[]){
          if(criterioUi.toogle??false)_criterioUiList.add(criterioUi);
        }
      }
    }

    if(_tipoNotaUi!=null){
      _tableTipoNotaColumns.add("Criterios");
      _tableTipoNotacolumnWidths.add(125.0);
      for (ValorTipoNotaUi valorTipoNotaUi in _tipoNotaUi?.valorTipoNotaList??[]) {
        _tableTipoNotaColumns.add(valorTipoNotaUi);
        _tableTipoNotacolumnWidths.add(50.0);
      }
      _tableTipoNotaColumns.add(true);
      _tableTipoNotacolumnWidths.add(45.0);
      List<int> percentParts = getPercentPartsV2(100, _criterioUiList.length);
      List<List<dynamic>> output = [];
      for (int i = 0; i < _criterioUiList.length; i++) {
        CriterioUi criterioUi = _criterioUiList[i];
        final List<dynamic> row = [];
        row.add(criterioUi);
        for (int i = 0; i < ( _tipoNotaUi?.valorTipoNotaList??[]).length; i++) {
          CriterioValorTipoNotaUi criterioValorTipoNotaUi = CriterioValorTipoNotaUi();
          criterioValorTipoNotaUi.criterioUi = criterioUi;
          criterioValorTipoNotaUi.valorTipoNotaUi =  _tipoNotaUi?.valorTipoNotaList?[i];
          row.add(criterioValorTipoNotaUi);
        }
        CriterioPesoUi criterioPesoUi = CriterioPesoUi();
        criterioPesoUi.peso = percentParts[i];
        criterioPesoUi.criterioUi = criterioUi;
        row.add(criterioPesoUi);
        output.add(row);
      }
      _tableTipoNotaCells = output;
    }

  }

  List<int> getPercentPartsV2(int? totalPeso, int? cantidad) {
    if (cantidad == null||cantidad == 0) return [];
    List<int> percentParts = [];

    int subtotalPeso =  ((totalPeso??0)/cantidad).toInt();
    int diferencia = (totalPeso??0) - (subtotalPeso * cantidad);

    for (int i = 0; i < cantidad; i++) {
      percentParts.add(subtotalPeso);
    }

    for (int i = 0; i < diferencia; i++) {
      percentParts[i]+=1;
    }

    return percentParts;
  }


  @override
  void onInitState() {
    presenter.getFormaEvaluacion();
    presenter.getTipoEvaluacion();
    presenter.getTipoNota();
    presenter.getTemaCriterios(cursosUi, calendarioPeriodoUI);
    print("getFormaEvaluacion");
    super.onInitState();
  }

  void successMsg() {
    _mensaje = null;
  }

  Future<int> onSave()async {
    if((_tituloRubrica??"").isEmpty){
      _mensaje = "Ingrese el título de la rúbrica";
      refreshUI();
      return 0;
    }

    if(_formaEvaluacionUi==null){
      _mensaje = "Forma evaluación vacío";
      refreshUI();
      return 0;
    }

    if(_tipoEvaluacionUi==null){
      _mensaje = "Tipo evaluación vacío";
      refreshUI();
      return 0;
    }

    if(_tipoEvaluacionUi==null) {
      _mensaje = "Promedio de logro vacío";
      refreshUI();
      return 0;
    }

   if(_criterioUiList.isEmpty){
     _mensaje = "No ha seleccionado criterios";
     refreshUI();
     return 0;
   }
   /*Vasta que un indicador este selecionado para guardar*/
    /*Esta validacion puede cambiar privio analisis*/
    bool camposTemaSelecionado  = false;
   for(CriterioUi criterioUi in _criterioUiList){
     camposTemaSelecionado = sinSelecionarCampoAccion(criterioUi.temaCriterioUiList??[]);
     if(camposTemaSelecionado)break;
   }
    if(!camposTemaSelecionado){
      _mensaje = "No ha seleccionado campo Acción";
      refreshUI();
      return 0;
    }

    if(!validarPeso(_tableTipoNotaCells)){
      _mensaje = "El peso de los inidicadores erroneos";
      refreshUI();
      return 0;
    }

    List<CriterioValorTipoNotaUi> criterioValorTipoNotaUiList = [];
    List<CriterioPesoUi> criterioPesoUiList = [];
    for(List<dynamic> list in _tableTipoNotaCells){
       for(dynamic o in list){
          if(o is CriterioValorTipoNotaUi){
            criterioValorTipoNotaUiList.add(o);
          }else if(o is CriterioPesoUi){
            criterioPesoUiList.add(o);
          }
       }
    }

    _showDialog = true;
    refreshUI();
    SaveRubroEvaluacionResponse? response = await presenter.save(cursosUi, calendarioPeriodoUI, tituloRubrica, formaEvaluacionUi, tipoEvaluacionUi, tipoNotaUi, criterioPesoUiList, criterioValorTipoNotaUiList);
    _showDialog = false;
    refreshUI();

    if(response.success??false){
      return 1;
    }else if(response.offline){
      return -2;
    }else{
      return -1;
    }
  }

  void clearTitulo() {
    _tituloRubrica = null;
    refreshUI();

  }

  void changeTituloRubrica(String str) {
    _tituloRubrica = str;
    refreshUI();
  }

  void onSelectFormaEvaluacion(item) {
    _formaEvaluacionUi = item;
    refreshUI();
  }

  void onSelectTipoEvaluacion(item) {
    _tipoEvaluacionUi = item;
    refreshUI();
  }

  void onSelectedTipoNota(TipoNotaUi tipoNotaUi) {
    _tipoNotaUi = tipoNotaUi;
    iniciarTablaTipoNota();
    refreshUI();
  }

  void onClickCriterio(CriterioUi criterioUi) {
    criterioUi.toogle = !(criterioUi.toogle??false);
    for(TemaCriterioUi item in criterioUi.temaCriterioUiList??[]){
        if((item.temaCriterioUiList??[]).isEmpty){
          item.toogle =  criterioUi.toogle;
        }else{
          for(TemaCriterioUi subitem in item.temaCriterioUiList??[]){
            subitem.toogle =  criterioUi.toogle;
          }
        }
    }
    iniciarTablaTipoNota();
    refreshUI();
  }

  void onClickTemaCriterio(TemaCriterioUi childtemaCriterioUi, CriterioUi criterioUi) {
    childtemaCriterioUi.toogle = !(childtemaCriterioUi.toogle??false);
    bool todosTemasSelecionados = false;
    for(TemaCriterioUi item in criterioUi.temaCriterioUiList??[]){
      if((item.temaCriterioUiList??[]).isEmpty){
        if((item.toogle??false)){
          todosTemasSelecionados = true;
          break;
        }
      }else{
        for(TemaCriterioUi subitem in item.temaCriterioUiList??[]){
          if((subitem.toogle??false)){
            todosTemasSelecionados = true;
            break;
          }
        }
      }
    }
    criterioUi.toogle = todosTemasSelecionados;
    iniciarTablaTipoNota();
    refreshUI();
  }

  void clearTituloCriterio(CriterioUi criterioUi) {
    _tituloCriterio = "";
  }

  void changeCriterioTitulo(String texto, CriterioUi criterioUi) {
    _tituloCriterio = texto;
  }

  void showDialogEditCriterio(CriterioUi criterioUi) {
    _tituloCriterio = criterioUi.icdTituloEditado??criterioUi.icdTituloEditado??criterioUi.icdTitulo??"";
    _temaCriterioEditList.clear();
    for(TemaCriterioUi item in criterioUi.temaCriterioUiList??[]){
        TemaCriterioUi temaCriterioUi = TemaCriterioUi.copy(item);
        temaCriterioUi.temaCriterioUiList = [];
        for(TemaCriterioUi subitem in item.temaCriterioUiList??[]){
          TemaCriterioUi subtemaCriterioUi = TemaCriterioUi.copy(subitem);
          subtemaCriterioUi.parent = temaCriterioUi;
          temaCriterioUi.temaCriterioUiList?.add(subtemaCriterioUi);
        }
        _temaCriterioEditList.add(temaCriterioUi);
    }
  }

  bool onSaveCriterio(CriterioUi criterioUi) {

    if((_tituloCriterio??"").isEmpty){
      _mensaje = "Título vacio";
      refreshUI();
      return false;
    }

    if(!sinSelecionarCampoAccion(_temaCriterioEditList)){
      _mensaje = "Seleccione un campo de acción";
      refreshUI();
      return false;
    }

    if((_tituloCriterio??"").isNotEmpty) criterioUi.icdTituloEditado = _tituloCriterio;
    for(TemaCriterioUi item in _temaCriterioEditList){
      TemaCriterioUi? temaCriterioUi = criterioUi.temaCriterioUiList?.firstWhere((element) => element.campoTematicoId == item.campoTematicoId);
      temaCriterioUi?.toogle = item.toogle;
      for(TemaCriterioUi subitem in item.temaCriterioUiList??[]){
        TemaCriterioUi? subtemaCriterioUi = temaCriterioUi?.temaCriterioUiList?.firstWhere((element) => element.campoTematicoId == subitem.campoTematicoId);
        subtemaCriterioUi?.toogle = subitem.toogle;
      }
    }

    iniciarTablaTipoNota();
    refreshUI();

    return true;

  }

  void onClickTemaCriterioEdit(TemaCriterioUi childtemaCriterioUi) {
    childtemaCriterioUi.toogle = !(childtemaCriterioUi.toogle??false);
  }

  bool sinSelecionarCampoAccion(List<TemaCriterioUi> temaCriterioEditList) {
   bool sinCampoAccion = false;
    for(TemaCriterioUi item in temaCriterioEditList){
      if(item.toogle??false){
        sinCampoAccion = true;
        break;
      }
      for(TemaCriterioUi subitem in item.temaCriterioUiList??[]){
        if(subitem.toogle??false){
          sinCampoAccion = true;
          break;
        }
      }
    }
    return sinCampoAccion;
  }

  bool validarPeso(List<List<dynamic>> bodyList) {
    int porcentaje = 0;
    for (List<dynamic> cellList in bodyList) {
      CriterioPesoUi? criterioPesoUi = null;
      for(var o in cellList){
        if(o is CriterioPesoUi){
          criterioPesoUi = o;
        }
      }
      porcentaje += criterioPesoUi?.peso??0;
      if((criterioPesoUi?.peso??0)==0)return false;
    }

    print("TAG Peso: " + porcentaje.toString());
    if (porcentaje == 100) {
      return true;
    } else {
      return false;
    }

  }



}