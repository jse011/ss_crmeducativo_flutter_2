import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/indicador/multiple/evaluacion_indicador_multiple_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_publicado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_formula_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/calcular_evaluacion_proceso.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/transformar_valor_tipo_nota.dart';
import 'package:collection/collection.dart';

class EvaluacionIndicadorMultipleController extends Controller {
  String rubroEvaluacionId;
  CursosUi cursosUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;
  EvaluacionIndicadorMultiplePresenter presenter;
  RubricaEvaluacionUi? rubroEvaluacionUi;
  List<dynamic> _columnList2 = [];
  bool get modificado => _modificado;
  bool _modificado = false;
  UsuarioUi? _usuarioUi = null;
  UsuarioUi? get usuarioUi  => _usuarioUi;
  List<dynamic> get columnList2 => _columnList2;
  List<dynamic> _rowList2 = [];
  List<dynamic> get rowList2 => _rowList2;
  List<List<dynamic>> _cellListList = [];
  List<List<dynamic>> get cellListList => _cellListList;
  List<PersonaUi> _alumnoCursoList = [];
  /*List<PersonaUi> _alumnoCursoListDesordenado = [];*/
  List<PersonaUi> get alumnoCursoList => _alumnoCursoList;
  Map<PersonaUi, List<dynamic>> _mapColumnList = Map();
  Map<PersonaUi, List<RubricaEvaluacionUi>> _mapRowList = Map();
  Map<PersonaUi, List<List<dynamic>>> _mapCellListList = Map();
  Map<PersonaUi, List<dynamic>> get mapColumnList => _mapColumnList;
  Map<PersonaUi, List<RubricaEvaluacionUi>> get mapRowList => _mapRowList;
  Map<PersonaUi, List<List<dynamic>>> get mapCellListList => _mapCellListList;

  bool _precision = false;
  bool get precision => _precision;

  bool _showDialogEliminar = false;
  bool get showDialogEliminar => _showDialogEliminar;

  bool _showDialog = false;
  bool get showDialog => _showDialog;

  PersonaUi? _personaUiSelected = null;
  PersonaUi? get personaUiSelected => _personaUiSelected;

  bool _atras = false;
  bool get atras => _atras;
  bool _siguiente = false;
  bool get siguiente => _siguiente;

  EvaluacionIndicadorMultipleController(this.rubroEvaluacionId, this.cursosUi, this.calendarioPeriodoUI,
      RubroRepository rubroRepo, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo) :
        presenter = EvaluacionIndicadorMultiplePresenter(
            rubroRepo, configuracionRepo, httpDatosRepo);

  @override
  void initListeners() {
    presenter.getRubroEvaluacionOnError = (e){
      this.rubroEvaluacionUi = null;
    };

    presenter.getSessionUsuarioOnNext = (UsuarioUi usuarioUi){
      _usuarioUi = usuarioUi;
    };

    presenter.getSessionUsuarioOnError = (e) {
      _usuarioUi = null;
    };

    presenter.getRubroEvaluacionOnNext =
        (RubricaEvaluacionUi? rubroEvaluacionUi,
        List<PersonaUi> alumnoCursoList,) {
      this.rubroEvaluacionUi = rubroEvaluacionUi;
      //print("rubroEvaluacionUi: ${this.rubroEvaluacionUi?.evaluacionUiList?.length}");
      initTable(alumnoCursoList, rubroEvaluacionUi);
      initLista(alumnoCursoList, rubroEvaluacionUi);
      refreshUI();
    };
  }

  @override
  void onInitState() {
    super.onInitState();
    presenter.getSessionUsuario();
    presenter.getRubroEvaluacion(rubroEvaluacionId, cursosUi);
  }

  void initTable(List<PersonaUi> alumnoCursoList,
      RubricaEvaluacionUi? rubricaEvaluacionUi) {
    _rowList2.clear();
    _cellListList.clear();
    _columnList2.clear();

    _rowList2.addAll(alumnoCursoList);
    _rowList2.add(""); //Espacio
    _rowList2.add(""); //Espacio
    _rowList2.add(""); //Espacio

    _columnList2.add(ContactoUi()); //Titulo foto_alumno

    _columnList2.addAll(rubricaEvaluacionUi?.rubrosDetalleList??[]);
    _columnList2.add(EvaluacionUi()); //Titulo Nota Final
    _columnList2.add(EvaluacionPublicadoUi(EvaluacionUi()));
    _columnList2.add(""); // espacio

    for (dynamic row in _rowList2) {
      List<dynamic> cellList = [];

      cellList.add(row);
      EvaluacionPublicadoUi? evaluacionPublicadoUi = null;
      EvaluacionUi? evaluacionUiCabecera = null;
      //#obtner Nota Tatal
      if (row is PersonaUi) {

        evaluacionUiCabecera = rubricaEvaluacionUi?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == row.personaId);
        if (evaluacionUiCabecera == null){
          evaluacionUiCabecera = EvaluacionUi(); //Una evaluacion vasia significa que el foto_alumno no tiene evaluacion
          evaluacionUiCabecera.rubroEvaluacionUi = rubricaEvaluacionUi;
          row.soloApareceEnElCurso = true;
          evaluacionUiCabecera.alumnoId = row.personaId;
          rubricaEvaluacionUi?.evaluacionUiList?.add(evaluacionUiCabecera);
        }
        evaluacionUiCabecera.personaUi = row; //se remplasa la persona con la lista de foto_alumno del carga_curso por que contiene informacion de vigencia

        //cellList.add(evaluacionUiCabecera);
        evaluacionPublicadoUi = EvaluacionPublicadoUi(evaluacionUiCabecera);

        //Comprobar si el detalle tiene tiene evaluacion
        for (RubricaEvaluacionUi rubricaEvaluacionUiDetalle in rubricaEvaluacionUi?.rubrosDetalleList ?? []) {
          EvaluacionUi? evaluacionUiDetalle = rubricaEvaluacionUiDetalle.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == row.personaId);
          if(evaluacionUiDetalle==null){
            evaluacionUiDetalle = EvaluacionUi();
            evaluacionUiDetalle.rubroEvaluacionUi = rubricaEvaluacionUiDetalle;
            evaluacionUiDetalle.alumnoId = row.personaId;
            row.soloApareceEnElCurso = true;
            rubricaEvaluacionUiDetalle.evaluacionUiList?.add(evaluacionUiDetalle);
          }
        }



      } else {
        cellList.add(""); //Espacio
      }

      //#obtner Nota RubroDetalle
      for (RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUi?.rubrosDetalleList ?? []) {
        if (row is PersonaUi) {
          EvaluacionUi? evaluacionUi = rubricaEvaluacionUi.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == row.personaId);
          if (evaluacionUi == null){
            evaluacionUi = EvaluacionUi(); //Una evaluacion vasia significa que el foto_alumno no tiene evaluacion
            evaluacionUi.rubroEvaluacionUi = rubricaEvaluacionUi;
            evaluacionUi.rubroEvaluacionId = rubricaEvaluacionUi.rubroEvaluacionId;
            row.soloApareceEnElCurso = true;
          }
          evaluacionUi.personaUi = row; //se remplasa la persona con la lista de foto_alumno del carga_curso por que contiene informacion de vigencia
          cellList.add(evaluacionUi);
        } else {
          cellList.add(""); //Espacio
        }
      }

      cellList.add(evaluacionUiCabecera);

      //#obtner Validar si todos los rubros detalles esta publicados
      if(evaluacionPublicadoUi!=null){
        cellList.add(evaluacionPublicadoUi);
      }else{
        cellList.add(""); //Espacio
      }
      cellList.add("");

      print("length: f "+cellList.length.toString());
      _cellListList.add(cellList);
    }
    showTodosPublicados();
  }

  void onClicPublicadoAll(EvaluacionPublicadoUi evaluacionPublicadoUi) {
    evaluacionPublicadoUi.publicado = !evaluacionPublicadoUi.publicado;
    for(List cellList in cellListList){
      for(var cell in cellList){
        if(cell is EvaluacionPublicadoUi){
          if(cell is EvaluacionPublicadoUi && (cell.evaluacionUi?.personaUi?.contratoVigente??false)){
            cell.publicado = evaluacionPublicadoUi.publicado;
          }

        }
      }
    }
    _modificado = true;
    refreshUI();
    presenter.updateEvaluacionAll(rubroEvaluacionUi);
  }

  void onClicPublicado(EvaluacionPublicadoUi evaluacionPublicadoUi) {
    evaluacionPublicadoUi.publicado = !evaluacionPublicadoUi.publicado;
    showTodosPublicados();
    _modificado = true;
    refreshUI();

    presenter.updateEvaluacion(rubroEvaluacionUi, evaluacionPublicadoUi.evaluacionUi?.alumnoId);
  }

  void showTodosPublicados(){
    bool todosPublicados = true;
    for(List cellList in cellListList){
      for(var cell in cellList){
        if(cell is EvaluacionPublicadoUi){
          if(cell.evaluacionUi?.personaUi?.contratoVigente??false){
            if(!cell.publicado)todosPublicados = false;
          }
        }
      }
    }

    for(var column in columnList2){
      if(column is EvaluacionPublicadoUi){
        column.publicado = todosPublicados;
      }
    }
  }

  void initLista(List<PersonaUi> alumnoCursoList, RubricaEvaluacionUi? rubroEvaluacionUi) {
    _alumnoCursoList = alumnoCursoList;
    //_alumnoCursoListDesordenado.clear();
    //_alumnoCursoListDesordenado.addAll(alumnoCursoList);
    _mapColumnList.clear();
    _mapRowList.clear();
    _mapCellListList.clear();




    for(PersonaUi personaUi in alumnoCursoList){

      _mapColumnList[personaUi] = [];
      _mapRowList[personaUi] = [];
      _mapCellListList[personaUi] = [];

      _mapRowList[personaUi]?.addAll(rubroEvaluacionUi?.rubrosDetalleList??[]);

      //_mapColumnList[personaUi]?.add(RubricaEvaluacionUi());
      TipoNotaUi? tipoNotaUi = null;
      if(rubroEvaluacionUi?.rubrosDetalleList?.isNotEmpty??false){
        tipoNotaUi = rubroEvaluacionUi?.rubrosDetalleList?[0].tipoNotaUi;
      }
//      tipoNotaUi?.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_NUMERICO;
      if(tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS || tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
        _mapColumnList[personaUi]?.addAll(tipoNotaUi?.valorTipoNotaList??[]);
      }else{
        _mapColumnList[personaUi]?.add(EvaluacionUi());//Teclado numerico
      }
      //_mapColumnList[personaUi]?.add(RubricaEvaluacionFormulaPesoUi(RubricaEvaluacionUi()));//peso_criterio

      for(RubricaEvaluacionUi row in _mapRowList[personaUi]??[]){
        List<dynamic> cellList = [];
        //cellList.add(row);
        EvaluacionUi? evaluacionUi = row.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == personaUi.personaId);

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
        _mapCellListList[personaUi]?.add(cellList);
      }
    }



    refreshUI();

  }

  onClicEvaluacionRubrica(EvaluacionUi evaluacionUi) {
    _personaUiSelected = evaluacionUi.personaUi;
    comprobarButtom();
   /* _alumnoCursoListDesordenado.clear();
    _alumnoCursoListDesordenado.addAll(_alumnoCursoList);
    _alumnoCursoListDesordenado.firstWhereOrNull((element) => false);

    _alumnoCursoListDesordenado.remove(evaluacionUi.personaUi);
    _alumnoCursoListDesordenado.insert(0,evaluacionUi.personaUi??PersonaUi());
    _tipoMatriz = false;*/
    refreshUI();
  }

  onClicVolverMatriz(){
   // _tipoMatriz = true;
    refreshUI();
  }

  void onClicPrecision() {
    this._precision = !_precision;
    refreshUI();
  }

  void onClickCancelarEliminar() {
    _showDialogEliminar = false;
    refreshUI();
  }

  void onClickEliminar() {
    if(isCalendarioDesactivo())return;
    _showDialogEliminar = true;

    refreshUI();
  }

  void onClicEvaluar(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, PersonaUi? personaUi) {
    if(isCalendarioDesactivo())return;
    for (List cellList in mapCellListList[personaUi] ?? []) {
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

    evaluacionRubricaValorTipoNotaUi.toggle = !(evaluacionRubricaValorTipoNotaUi.toggle ?? false);
    if(evaluacionRubricaValorTipoNotaUi.toggle??false){
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorNumerico;
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaId = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId;
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaUi = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi;
    }else{
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota = 0.0;
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaId = null;
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaUi = null;
    }

    _actualizarCabecera(personaUi);
    _modificado = true;
    refreshUI();

    presenter.updateEvaluacion(rubroEvaluacionUi, personaUi?.personaId);
  }

  void onClicEvaluarPresicion(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, PersonaUi? personaUi, nota) {
    if(isCalendarioDesactivo())return;
    /*for (List cellList in mapCellListList[personaUi] ?? []) {
      for (var cell in cellList) {
        if (cell is EvaluacionRubricaValorTipoNotaUi) {
          if (cell.evaluacionUi?.alumnoId == evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId
              && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.rubroEvaluacionId
              && cell != evaluacionRubricaValorTipoNotaUi) {
            cell.toggle = false;
          }
        }
      }
    }*/

    ValorTipoNotaUi? valorTipoNotaUi = TransformarValoTipoNota.getValorTipoNota(evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi, nota);

    for (List cellList in _mapCellListList[evaluacionRubricaValorTipoNotaUi.evaluacionUi?.personaUi]??[]) {
      for (var cell in cellList) {
        if (cell is EvaluacionRubricaValorTipoNotaUi) {
          if (cell.evaluacionUi?.alumnoId == evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId
              && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.rubroEvaluacionId
              && cell.valorTipoNotaUi?.valorTipoNotaId == valorTipoNotaUi?.valorTipoNotaId) {
            cell.toggle = true;
          }

          if (cell.evaluacionUi?.alumnoId == evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId
              && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.rubroEvaluacionId
              && cell.valorTipoNotaUi?.valorTipoNotaId != valorTipoNotaUi?.valorTipoNotaId) {
            cell.toggle = false;
          }

        }
      }
    }

    //evaluacionRubricaValorTipoNotaUi.toggle = true;
    evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota = nota;
    evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaId = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId;
    evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaUi = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi;

    _actualizarCabecera(personaUi);
    _modificado = true;
    refreshUI();
    presenter.updateEvaluacion(rubroEvaluacionUi, personaUi?.personaId);
  }

  String getRangoNota(ValorTipoNotaUi? valorTipoNotaUi){
    String rango =  "";

    if(valorTipoNotaUi?.incluidoLSuperior??false){
      rango += "[ ";
    }else {
      rango += "< ";
    }
    rango += "${(valorTipoNotaUi?.limiteSuperior??0).toStringAsFixed(1)}";
    rango += " - ";
    rango += "${(valorTipoNotaUi?.limiteInferior??0).toStringAsFixed(1)}";
    if(valorTipoNotaUi?.incluidoLInferior??false){
      rango += " ]";
    }else {
      rango += " >";
    }
    return rango;
  }

  onClicEvaluacionAll(ValorTipoNotaUi valorTipoNotaUi, PersonaUi? personaUi) {
    if(isCalendarioDesactivo())return;
    for(List cellList in mapCellListList[personaUi]??[]){
      for(var cell in cellList){
        if(cell is EvaluacionRubricaValorTipoNotaUi){
          if(cell.valorTipoNotaUi?.valorTipoNotaId == valorTipoNotaUi.valorTipoNotaId){
            cell.toggle = true;
            cell.evaluacionUi?.nota = valorTipoNotaUi.valorNumerico;//actualizar la nota solo cuando no esta selecionado
            cell.evaluacionUi?.valorTipoNotaId = valorTipoNotaUi.valorTipoNotaId;
            cell.evaluacionUi?.valorTipoNotaUi = valorTipoNotaUi;
          }else{
            cell.toggle = false;
          }

        }
      }
    }
    
    _actualizarCabecera(personaUi);
    _modificado = true;
    refreshUI();

    presenter.updateEvaluacionAll(rubroEvaluacionUi);
  }

  void _actualizarCabecera(PersonaUi? personaUi) {
    CalcularEvaluacionProceso.actualizarCabecera(rubroEvaluacionUi, personaUi);
    refreshUI();
  }

  EvaluacionUi? getEvaluacionGeneralPersona(PersonaUi? personaUi) {
    EvaluacionUi? evaluacionUi = null;

    for(EvaluacionUi item in rubroEvaluacionUi?.evaluacionUiList??[]){
      if(item.personaUi?.personaId == personaUi?.personaId){
        evaluacionUi = item;
      }
    }
    return evaluacionUi;
  }

  onClicClearEvaluacionAll(ValorTipoNotaUi valorTipoNotaUi, PersonaUi? personaUi) {
    if(isCalendarioDesactivo())return;
    for(List cellList in mapCellListList[personaUi]??[]){
      for(var cell in cellList){
        if(cell is EvaluacionRubricaValorTipoNotaUi){
          cell.toggle = false;
          cell.evaluacionUi?.nota = 0.0;
          cell.evaluacionUi?.valorTipoNotaId = null;
          cell.evaluacionUi?.valorTipoNotaUi = null;
        }
      }
    }
    _actualizarCabecera(personaUi);
    _modificado = true;
    refreshUI();

    presenter.updateEvaluacionAll(rubroEvaluacionUi);
  }

  Future<bool> onSave() async{
    if(_modificado){
      _showDialog = true;
      refreshUI();
      await presenter.updateServer(cursosUi, calendarioPeriodoUI ,rubroEvaluacionUi);
    }
    return _modificado;
  }

  onClickAceptarEliminar() async{
    _showDialogEliminar = false;
    _showDialog = true;
    refreshUI();
    await presenter.deleteRubroEvaluacion(rubroEvaluacionUi);
    await presenter.updateServer(cursosUi, calendarioPeriodoUI ,rubroEvaluacionUi);
  }

  onClicGuardar() async{

  }

  void onClickFinalizarEvaluacion() {
    _personaUiSelected = null;
    refreshUI();
  }

  void onClickAtrasEvaluacion() {
    int count = _alumnoCursoList.indexOf(_personaUiSelected!);
    _personaUiSelected = _alumnoCursoList[count-1];
    comprobarButtom();
    refreshUI();
  }

  void comprobarButtom() {
    int size = _alumnoCursoList.length;
    int count = _alumnoCursoList.indexOf(_personaUiSelected!);
    print("count ${count} size ${size}");
    _atras =  count != 0;
    _siguiente = (size-1) != count;
  }

  void onClickSiguienteEvaluacion() {
    int count = _alumnoCursoList.indexOf(_personaUiSelected!);
    _personaUiSelected = _alumnoCursoList[count+1];
    comprobarButtom();
    refreshUI();
  }

  bool isCalendarioDesactivo() {
    return calendarioPeriodoUI?.habilitadoProceso != 1;
  }

  void onSaveTecladoPresicion(nota, EvaluacionUi? evaluacionUi) {
    if(isCalendarioDesactivo())return;
    if (evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi ==  TipoNotaTiposUi.SELECTOR_VALORES || evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS){
      ValorTipoNotaUi? valorTipoNotaUi = TransformarValoTipoNota.getValorTipoNota(evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi, nota);

      for (List cellList in _mapCellListList[evaluacionUi?.personaUi]??[]) {
        for (var cell in cellList) {
          if (cell is EvaluacionRubricaValorTipoNotaUi) {
            if (cell.evaluacionUi?.alumnoId == evaluacionUi?.alumnoId
                && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionUi?.rubroEvaluacionId
                && cell.valorTipoNotaUi?.valorTipoNotaId == valorTipoNotaUi?.valorTipoNotaId) {
              cell.toggle = true;
            }

            if (cell.evaluacionUi?.alumnoId == evaluacionUi?.alumnoId
                && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionUi?.rubroEvaluacionId
                && cell.valorTipoNotaUi?.valorTipoNotaId != valorTipoNotaUi?.valorTipoNotaId) {
              cell.toggle = false;
            }

          }
        }
      }
      evaluacionUi?.valorTipoNotaId = valorTipoNotaUi?.valorTipoNotaId;
      evaluacionUi?.valorTipoNotaUi = valorTipoNotaUi;

    }
    evaluacionUi?.nota = nota;

    _actualizarCabecera(evaluacionUi?.personaUi);
    _modificado = true;
    refreshUI();
    presenter.updateEvaluacion(rubroEvaluacionUi, evaluacionUi?.personaUi?.personaId);
  }




}