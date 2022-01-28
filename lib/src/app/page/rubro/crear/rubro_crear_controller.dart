import 'package:flutter/scheduler.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/crear/rubro_crear_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/dialog_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/forma_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/id_generator.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/crear_server_rubro_evaluacion.dart';

class RubroCrearController extends Controller{
  bool modoOnline;//se usa cuando se crea un rubro desde la tarea
  RubroCrearPresenter presenter;
  CursosUi? cursosUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;
  SesionUi? sesionUi;
  RubricaEvaluacionUi? rubricaEvaluacionUi;
  TareaUi? tareaUi;
  String? newRubroEvalid = IdGenerator.generateId();
  String? _mensaje = null;
  bool _showGuardarProgress = false;
  bool get showGuardarProgress => _showGuardarProgress;
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
  bool? get errorServidor => _errorServidor;
  bool? _errorServidor = false;
  bool? get errorConexion => _errorConexion;
  bool? _errorConexion = false;
  int get countReintentos => _countReintentos;
  int _countReintentos =0;
  bool get cerraryactualizar => _cerraryactualizar;
  bool _cerraryactualizar = false;
  bool get dialogGuardarLocal => _dialogGuardarLocal;
  bool _dialogGuardarLocal = false;
  bool get dialogReintentar => _dialogReintentar;
  bool _dialogReintentar = false;
  HttpStream? _cancelSaveRubro = null;


      RubroCrearController(this.cursosUi, this.calendarioPeriodoUI, this.rubricaEvaluacionUi, this.sesionUi, this.tareaUi, this.modoOnline,rubroRepo, usuarioRepo, httpDatosRepo): presenter = new RubroCrearPresenter(rubroRepo,usuarioRepo, httpDatosRepo);

  @override
  void initListeners() {



    presenter.getFormaEvaluacionOnNext = (List<FormaEvaluacionUi> formaEvaluacionUiList, FormaEvaluacionUi? formaEvaluacionUi){
      _formaEvaluacionUiList = formaEvaluacionUiList;
      for(FormaEvaluacionUi formaEvaluacionUi in _formaEvaluacionUiList){
        if(rubricaEvaluacionUi?.formaEvaluacionId == formaEvaluacionUi.id){
          _formaEvaluacionUi = formaEvaluacionUi;
          break;
        }
      }
      if(_formaEvaluacionUi==null){
        _formaEvaluacionUi = formaEvaluacionUi;
      }
      //refreshUI();
    };

    presenter.getFormaEvaluacionOnError = (e){
      _formaEvaluacionUiList = [];
      _formaEvaluacionUi = null;
      refreshUI();
    };
    presenter.getTipoEvaluacionOnNext = (List<TipoEvaluacionUi> tipoEvaluacionUiList, TipoEvaluacionUi? tipoEvaluacionUi){
      _tipoEvaluacionUiList = tipoEvaluacionUiList;
      for(TipoEvaluacionUi tipoEvaluacionUi in _tipoEvaluacionUiList){
        if(rubricaEvaluacionUi?.tipoEvaluacionId == tipoEvaluacionUi.id){
          _tipoEvaluacionUi = tipoEvaluacionUi;
          break;
        }
      }
      if(_tipoEvaluacionUi==null){
        _tipoEvaluacionUi = tipoEvaluacionUi;
      }
      //refreshUI();
    };

    presenter.getFormaEvaluacionOnError = (e){
      _tipoEvaluacionUiList = [];
      _tipoEvaluacionUi = null;
      refreshUI();
    };

    presenter.getTipoNotaOnNext = (List<TipoNotaUi> tipoNotaUiList, TipoNotaUi? tipoNotaUi){
      _tipoNotaUiList = tipoNotaUiList;
      for(TipoNotaUi tipoNotaUi in _tipoNotaUiList){
        if(rubricaEvaluacionUi?.tipoNotaId == tipoNotaUi.tipoNotaId){
          _tipoNotaUi = tipoNotaUi;
          break;
        }
      }
      if(_tipoNotaUi==null){
        _tipoNotaUi = tipoNotaUi;
      }

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
      if(rubricaEvaluacionUi!=null){
        for(RubricaEvaluacionUi rubroEvalUi in rubricaEvaluacionUi?.rubrosDetalleList??[]){
          for(CompetenciaUi competenciaUi in competenciaUiList){
            for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
              for(CriterioUi criterioUi in capacidadUi.criterioUiList??[]){
                if(rubroEvalUi.desempenioIcdId == criterioUi.desempenioIcdId){
                  criterioUi.toogle = true;
                  criterioUi.icdTituloEditado = rubroEvalUi.titulo;
                  criterioUi.peso = rubroEvalUi.formula_peso;
                  criterioUi.rubroEvaluacionId = rubroEvalUi.rubroEvaluacionId;
                }
              }
            }
          }
        }
      }
      refreshUI();
    };
    presenter.getTemaCriteriosOnError = (e){
      _competenciaUiBaseList.clear();
      _competenciaUiTransversalList.clear();
      _competenciaUiEnfoqueList.clear();
      refreshUI();
    };

    presenter.saveRubroEvaluacionSucces = (){
      _cerraryactualizar = true;
      refreshUI();
    };

    presenter.saveRubroEvaluacionSuccesError = (bool errorServidor, bool errorConexion, bool errorInterno){
      _showGuardarProgress = false;
      _errorConexion = errorConexion;
      _errorServidor = errorServidor;
      if(!modoOnline){ // modo hecho especialmente para la tarea por que es online
        _dialogGuardarLocal = false;
        _dialogReintentar = true;
      }else{
        if(countReintentos<2){
          _dialogGuardarLocal = false;
          _dialogReintentar = true;
        }else{
          _dialogGuardarLocal = true;
          _dialogReintentar = false;
        }
      }


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
      //_tableTipoNotaColumns.add("Criterios");
      //_tableTipoNotacolumnWidths.add(130.0);
      for (ValorTipoNotaUi valorTipoNotaUi in _tipoNotaUi?.valorTipoNotaList??[]) {
        _tableTipoNotaColumns.add(valorTipoNotaUi);
        _tableTipoNotacolumnWidths.add(50.0);
      }
      _tableTipoNotaColumns.add(true);
      _tableTipoNotacolumnWidths.add(45.0);
      _tableTipoNotaColumns.add(0);
      _tableTipoNotacolumnWidths.add(24.0);
      List<int> percentParts = getPercentPartsV2(100, _criterioUiList.length);
      List<List<dynamic>> output = [];
      for (int i = 0; i < _criterioUiList.length; i++) {
        CriterioUi criterioUi = _criterioUiList[i];
        final List<dynamic> row = [];
        //row.add(criterioUi);
        for (int i = 0; i < ( _tipoNotaUi?.valorTipoNotaList??[]).length; i++) {
          CriterioValorTipoNotaUi criterioValorTipoNotaUi = CriterioValorTipoNotaUi();
          criterioValorTipoNotaUi.criterioUi = criterioUi;
          criterioValorTipoNotaUi.valorTipoNotaUi =  _tipoNotaUi?.valorTipoNotaList?[i];
          row.add(criterioValorTipoNotaUi);
        }
        CriterioPesoUi criterioPesoUi = CriterioPesoUi();
        criterioPesoUi.criterioUi = criterioUi;
        if(rubricaEvaluacionUi==null){
          criterioPesoUi.criterioUi?.peso = percentParts[i].toDouble();
        }
        row.add(criterioPesoUi);
        row.add(0);
        output.add(row);
      }
      _tableTipoNotaCells = output;
    }

  }

  List<int> getPercentPartsV2(int? totalPeso, int? cantidad) {
    if (cantidad == null||cantidad == 0) return [];
    List<int> percentParts = [];
    //int subtotalPeso =  ((totalPeso??0)/cantidad).toInt();
    int subtotalPeso =  ((totalPeso??0)~/cantidad);
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
    presenter.getTemaCriterios(rubricaEvaluacionUi, cursosUi, calendarioPeriodoUI);

    print("rubricaEvaluacionUi ${rubricaEvaluacionUi?.tipoNotaId}");
    if(rubricaEvaluacionUi!=null){
      _tituloRubrica = rubricaEvaluacionUi?.titulo;
    }else if(tareaUi!=null){
      _tituloRubrica = tareaUi?.titulo;
    }
    print("getFormaEvaluacion");
    super.onInitState();
  }

  void successMsg() {
    _mensaje = null;
  }

  void onSave()async {
    if((_tituloRubrica??"").isEmpty){
      _mensaje = "Ingrese el título de la rúbrica";
      refreshUI();
      return;
    }

    if(_formaEvaluacionUi==null){
      _mensaje = "Forma evaluación vacío";
      refreshUI();
      return;
    }

    if(_tipoEvaluacionUi==null){
      _mensaje = "Tipo evaluación vacío";
      refreshUI();
      return;
    }

    if(_tipoEvaluacionUi==null) {
      _mensaje = "Promedio de logro vacío";
      refreshUI();
      return;
    }

   if(_criterioUiList.isEmpty){
     _mensaje = "No ha seleccionado criterios";
     refreshUI();
     return;
   }
   /*Vasta que un indicador este selecionado para guardar*/
    /*Esta validacion puede cambiar privio analisis*/
    bool camposTemaSelecionado  = false;
   for(CriterioUi criterioUi in _criterioUiList){
     camposTemaSelecionado = sinSelecionarCampoAccion(criterioUi.temaCriterioUiList??[]);
     if(camposTemaSelecionado)break;
   }
    if(!camposTemaSelecionado && rubricaEvaluacionUi == null){
      _mensaje = "No ha seleccionado campo acción";
      refreshUI();
      return;
    }

    if(!validarPeso(_tableTipoNotaCells)){
      _mensaje = "El peso_criterio de los inidicadores erroneos";
      refreshUI();
      return;
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

    _showGuardarProgress = true;
    _errorConexion = false;
    _errorServidor = false;
    refreshUI();

    if(rubricaEvaluacionUi==null){
      rubricaEvaluacionUi = RubricaEvaluacionUi();
      rubricaEvaluacionUi?.rubroEvaluacionId = newRubroEvalid;
      rubricaEvaluacionUi?.titulo = tituloRubrica;
      rubricaEvaluacionUi?.formaEvaluacionId = formaEvaluacionUi?.id;
      rubricaEvaluacionUi?.tipoEvaluacionId = tipoEvaluacionUi?.id;
      rubricaEvaluacionUi?.tipoNotaUi = tipoNotaUi;
      rubricaEvaluacionUi?.criterioPesoUiList = criterioPesoUiList;
      rubricaEvaluacionUi?.criterioValorTipoNotaUiList = criterioValorTipoNotaUiList;
      rubricaEvaluacionUi?.sesionAprendizajeId = sesionUi?.sesionAprendizajeId;
      rubricaEvaluacionUi?.tareaUi = tareaUi;
      rubricaEvaluacionUi?.calendarioPeriodoId = calendarioPeriodoUI?.id;
      rubricaEvaluacionUi?.silaboEventoId = cursosUi?.silaboEventoId;
      rubricaEvaluacionUi?.cargaCursoId = cursosUi?.cargaCursoId;

      _cancelSaveRubro = await presenter.save(rubricaEvaluacionUi);
    }else{
      rubricaEvaluacionUi?.titulo = tituloRubrica;
      rubricaEvaluacionUi?.criterioPesoUiList = criterioPesoUiList;
      rubricaEvaluacionUi?.criterioValorTipoNotaUiList = criterioValorTipoNotaUiList;
      rubricaEvaluacionUi?.tipoEvaluacionId = tipoEvaluacionUi?.id;
      _cancelSaveRubro = await presenter.update(rubricaEvaluacionUi);
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
      _mensaje = "Título vacío";
      refreshUI();
      return false;
    }

    if(!sinSelecionarCampoAccion(_temaCriterioEditList)&&rubricaEvaluacionUi==null){
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
    double porcentaje = 0;
    for (List<dynamic> cellList in bodyList) {
      CriterioPesoUi? criterioPesoUi = null;
      for(var o in cellList){
        if(o is CriterioPesoUi){
          criterioPesoUi = o;
        }
      }
      porcentaje += criterioPesoUi?.criterioUi?.peso??0;
      if((criterioPesoUi?.criterioUi?.peso??0)==0)return false;
    }

    print("TAG Peso: " + porcentaje.toString());
    if (porcentaje == 100) {
      return true;
    } else {
      return false;
    }

  }

  void onClickMostrarTodo(CompetenciaUi competenciaUi) {
    competenciaUi.toogle = !(competenciaUi.toogle??false);

    for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
      capacidadUi.toogle =  competenciaUi.toogle;
    }
  }



  void onClickCapacidad(CapacidadUi capacidadUi, CompetenciaUi competenciaUi) {
    capacidadUi.toogle = !(capacidadUi.toogle??false);

    if(capacidadUi.toogle??false){
      bool selecionado = true;
      for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
        if(!(capacidadUi.toogle??false)){
          selecionado = false;
          break;
        }
      }
      competenciaUi.toogle = selecionado;
    }else{
      competenciaUi.toogle = false;
    }
  }

  void showCamposAccion() {

    List<CompetenciaUi> competenciaUiList = [];
    competenciaUiList.addAll(_competenciaUiBaseList);
    competenciaUiList.addAll(_competenciaUiTransversalList);
    competenciaUiList.addAll(_competenciaUiEnfoqueList);
    for(CompetenciaUi competenciaUi in competenciaUiList){
      for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
        bool toogle = false;
        for(CriterioUi criterioUi in capacidadUi.criterioUiList??[]){
          if(criterioUi.toogle??false)toogle=true;
        }
        if(toogle && !(capacidadUi.toogle??false)) onClickCapacidad(capacidadUi, competenciaUi);
      }
    }
  }

  void retornoDialogCamposAccion() {
    iniciarTablaTipoNota();
    refreshUI();
  }

  void onClickGuardarVerMasTarde() async{
    _cerraryactualizar = true;
    _cancelSaveRubro?.cancel();
    await presenter.saveLocal(rubricaEvaluacionUi);
    refreshUI();
  }

  void cerrarProgress() {
    _cancelSaveRubro?.cancel();
    _showGuardarProgress = false;
    refreshUI();
  }

  void onClickAtrasReintentar() {
    _dialogReintentar = false;
    refreshUI();
  }

  void onClickReintentar() {
    _countReintentos++;
    _dialogReintentar = false;
    onSave();
  }

  void onClickAtrasGuardarLocal() {
    _dialogGuardarLocal = false;
    _countReintentos=0;
    refreshUI();
  }

  void clearCerraryactualizar() {
    _cerraryactualizar = false;
  }




}
