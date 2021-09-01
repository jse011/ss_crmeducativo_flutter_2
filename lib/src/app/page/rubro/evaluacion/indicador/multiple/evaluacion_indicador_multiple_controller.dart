import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/indicador/multiple/evaluacion_indicador_multiple_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_publicado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/app_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/transformar_valor_tipo_nota.dart';
import 'package:collection/collection.dart';

class EvaluacionIndicadorMultipleController extends Controller {
  String rubroEvaluacionId;
  CursosUi cursosUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;
  EvaluacionIndicadorMultiplePresenter presenter;
  RubricaEvaluacionUi? rubroEvaluacionUi;
  List<dynamic> _columnList2 = [];

  UsuarioUi? _usuarioUi = null;

  UsuarioUi? get usuarioUi  => _usuarioUi;
  List<dynamic> get columnList2 => _columnList2;
  List<dynamic> _rowList2 = [];
  List<dynamic> get rowList2 => _rowList2;
  List<List<dynamic>> _cellListList = [];
  List<List<dynamic>> get cellListList => _cellListList;
  List<PersonaUi> _alumnoCursoList = [];
  List<PersonaUi> _alumnoCursoListDesordenado = [];
  List<PersonaUi> get alumnoCursoList => _alumnoCursoListDesordenado;

  Map<PersonaUi, List<dynamic>> _mapColumnList = Map();
  Map<PersonaUi, List<RubricaEvaluacionUi>> _mapRowList = Map();
  Map<PersonaUi, List<List<dynamic>>> _mapCellListList = Map();
  Map<PersonaUi, List<dynamic>> get mapColumnList => _mapColumnList;
  Map<PersonaUi, List<RubricaEvaluacionUi>> get mapRowList => _mapRowList;
  Map<PersonaUi, List<List<dynamic>>> get mapCellListList => _mapCellListList;

  bool _tipoMatriz = true;
  bool get tipoMatriz => _tipoMatriz;

  bool _precision = false;
  bool get precision => _precision;

  bool _showDialogEliminar = false;
  bool get showDialogEliminar => _showDialogEliminar;


  EvaluacionIndicadorMultipleController(this.rubroEvaluacionId, this.cursosUi, this.calendarioPeriodoUI,
      RubroRepository rubroRepo, ConfiguracionRepository configuracionRepo) :
        presenter = EvaluacionIndicadorMultiplePresenter(
            rubroRepo, configuracionRepo);

  @override
  void initListeners() {
    presenter.getRubroEvaluacionOnError = (e){

    };

    presenter.getSessionUsuarioOnNext = (UsuarioUi usuarioUi){
      _usuarioUi = usuarioUi;
    };

    presenter.getSessionUsuarioOnError = (e) {
      this.rubroEvaluacionUi = null;
    };

    presenter.getRubroEvaluacionOnNext =
        (RubricaEvaluacionUi? rubroEvaluacionUi,
        List<PersonaUi> alumnoCursoList,) {
      this.rubroEvaluacionUi = rubroEvaluacionUi;
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

    _columnList2.add(ContactoUi()); //Titulo alumno
    _columnList2.add(EvaluacionUi()); //Titulo Nota Final
    _columnList2.add(EvaluacionPublicadoUi(EvaluacionUi()));
    _columnList2.addAll(rubricaEvaluacionUi?.rubrosDetalleList??[]);

    _columnList2.add(""); // espacio

    for (dynamic row in _rowList2) {
      List<dynamic> cellList = [];

      cellList.add(row);

      //#obtner Nota Tatal
      if (row is PersonaUi) {
        EvaluacionUi? evaluacionUi = rubricaEvaluacionUi?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == row.personaId);
        if (evaluacionUi == null) evaluacionUi = EvaluacionUi(); //Una evaluacion vasia significa que el alumno no tiene evaluacion
        evaluacionUi.personaUi = row; //se remplasa la persona con la lista de alumno del curso por que contiene informacion de vigencia
        cellList.add(evaluacionUi);
        cellList.add(EvaluacionPublicadoUi(evaluacionUi));
      } else {
        cellList.add(""); //Espacio
        cellList.add(""); //Espacio
      }

      //#obtner Nota RubroDetalle
      for (RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUi?.rubrosDetalleList ?? []) {
        if (row is PersonaUi) {
          EvaluacionUi? evaluacionUi = rubricaEvaluacionUi.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == row.personaId);
          if (evaluacionUi == null) evaluacionUi = EvaluacionUi(); //Una evaluacion vasia significa que el alumno no tiene evaluacion
          evaluacionUi.personaUi = row; //se remplasa la persona con la lista de alumno del curso por que contiene informacion de vigencia
          cellList.add(evaluacionUi);
        } else {
          cellList.add(""); //Espacio
        }
      }

      //#obtner Validar si todos los rubros detalles esta publicados

      cellList.add("");

      print("length: f "+cellList.length.toString());
      _cellListList.add(cellList);
    }
  }

  void onClicPublicadoAll(EvaluacionPublicadoUi evaluacionPublicadoUi) {
    evaluacionPublicadoUi.publicado = !evaluacionPublicadoUi.publicado;
    for(List cellList in cellListList){
      for(var cell in cellList){
        if(cell is EvaluacionPublicadoUi){
          cell.publicado = evaluacionPublicadoUi.publicado;
        }
      }
    }
    refreshUI();
  }

  void onClicPublicado(EvaluacionPublicadoUi evaluacionPublicadoUi) {
    evaluacionPublicadoUi.publicado = !evaluacionPublicadoUi.publicado;
    bool todosPublicados = true;
    for(List cellList in cellListList){
      for(var cell in cellList){
        if(cell is EvaluacionPublicadoUi){
          if(!cell.publicado)todosPublicados = false;
        }
      }
    }

    for(var column in columnList2){
      if(column is EvaluacionPublicadoUi){
        column.publicado = todosPublicados;
      }
    }
    refreshUI();
  }

  void initLista(List<PersonaUi> alumnoCursoList, RubricaEvaluacionUi? rubroEvaluacionUi) {
    _alumnoCursoList = alumnoCursoList;
    _alumnoCursoListDesordenado.clear();
    _alumnoCursoListDesordenado.addAll(alumnoCursoList);
    _mapColumnList.clear();
    _mapRowList.clear();
    _mapCellListList.clear();
    for(PersonaUi personaUi in alumnoCursoList){

      _mapColumnList[personaUi] = [];
      _mapRowList[personaUi] = [];
      _mapCellListList[personaUi] = [];

      _mapRowList[personaUi]?.addAll(rubroEvaluacionUi?.rubrosDetalleList??[]);

      _mapColumnList[personaUi]?.add(RubricaEvaluacionUi());
      TipoNotaUi? tipoNotaUi = null;
      if(rubroEvaluacionUi?.rubrosDetalleList?.isNotEmpty??false){
        tipoNotaUi = rubroEvaluacionUi?.rubrosDetalleList?[0].tipoNotaUi;
      }
      if(tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS || tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
        _mapColumnList[personaUi]?.addAll(tipoNotaUi?.valorTipoNotaList??[]);
      }else{
        _mapColumnList[personaUi]?.add(EvaluacionUi());//Teclado numerico
      }
      _mapColumnList[personaUi]?.add(RubricaEvaluacionPesoUi(RubricaEvaluacionUi()));//peso

      for(RubricaEvaluacionUi row in _mapRowList[personaUi]??[]){
        List<dynamic> cellList = [];
        cellList.add(row);
        EvaluacionUi? evaluacionUi = row.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == personaUi.personaId);
        if(evaluacionUi==null)evaluacionUi = EvaluacionUi();//Una evaluacion vasia significa que el alumno no tiene evaluacion
        evaluacionUi.personaUi = personaUi;//se remplasa la persona con la lista de alumno del curso por que contiene informacion de vigencia

        if(tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS || tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
          for(ValorTipoNotaUi valorTipoNotaUi in tipoNotaUi?.valorTipoNotaList??[]){
            EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi = EvaluacionRubricaValorTipoNotaUi();
            evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi = valorTipoNotaUi;
            evaluacionRubricaValorTipoNotaUi.evaluacionUi = evaluacionUi;
            evaluacionRubricaValorTipoNotaUi.toggle = (evaluacionUi.evaluacionId??"").isNotEmpty && valorTipoNotaUi.valorTipoNotaId == evaluacionUi.valorTipoNotaId;
            evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi = row;
            cellList.add(evaluacionRubricaValorTipoNotaUi);
          }
        }else{
          cellList.add(evaluacionUi);
        }
        RubricaEvaluacionPesoUi pesoUi = RubricaEvaluacionPesoUi(row);
        cellList.add(pesoUi);
        _mapCellListList[personaUi]?.add(cellList);
      }
    }

    refreshUI();

  }

  onClicEvaluacionRubrica(EvaluacionUi evaluacionUi) {
    _alumnoCursoListDesordenado.clear();
    _alumnoCursoListDesordenado.addAll(_alumnoCursoList);
    _alumnoCursoListDesordenado.firstWhereOrNull((element) => false);

    _alumnoCursoListDesordenado.remove(evaluacionUi.personaUi);
    _alumnoCursoListDesordenado.insert(0,evaluacionUi.personaUi??PersonaUi());
    _tipoMatriz = false;
    refreshUI();
  }

  onClicVolverMatriz(){
    _tipoMatriz = true;
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
    _showDialogEliminar = true;
    refreshUI();
  }

  void onClicEvaluar(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, PersonaUi personaUi) {
    if(evaluacionRubricaValorTipoNotaUi.evaluacionUi?.evaluacionId!=null) {
      for (List cellList in mapCellListList[personaUi] ?? []) {
        for (var cell in cellList) {
          if (cell is EvaluacionRubricaValorTipoNotaUi) {
            if (cell.evaluacionUi?.alumnoId == evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId
                && cell.evaluacionUi?.rubroEvaluacionUi?.rubricaId == evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.rubricaId
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

      refreshUI();
    }
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

  onClicEvaluacionAll(ValorTipoNotaUi valorTipoNotaUi, PersonaUi personaUi) {

    for(List cellList in mapCellListList[personaUi]??[]){
      for(var cell in cellList){
        if(cell is EvaluacionRubricaValorTipoNotaUi){
          if(cell.evaluacionUi?.evaluacionId!=null){
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
    }
    _actualizarCabecera(personaUi);
    refreshUI();
  }

  void _actualizarCabecera(PersonaUi personaUi) {
    EvaluacionUi? evaluacionUi = getEvaluacionGeneralPersona(personaUi);

    List<EvaluacionUi> evaluacionUiList = [];
    for(RubricaEvaluacionUi rubroEvaluacionUi in rubroEvaluacionUi?.rubrosDetalleList??[]){
      for(EvaluacionUi item in rubroEvaluacionUi.evaluacionUiList??[]){
        if(item.personaUi?.personaId == personaUi.personaId){
          evaluacionUiList.add(item);
        }
      }
    }

    double notaDetalle = 0.0;
    int notaMaxRubro = 0;
    int notaMinRubro = 0;
    int countSelecionado = 0;
    for(EvaluacionUi evaluacionUi in evaluacionUiList){
      notaDetalle += AppTools.roundDouble((evaluacionUi.nota??0.0)*(evaluacionUi.rubroEvaluacionUi?.peso??1),2);//Para evitar calcular con muchos decimasles se redonde a dos
      notaMaxRubro = evaluacionUi.rubroEvaluacionUi?.tipoNotaUi?.escalavalorMaximo??0;
      notaMinRubro = evaluacionUi.rubroEvaluacionUi?.tipoNotaUi?.escalavalorMinimo??0;
      if(evaluacionUi.valorTipoNotaId!=null)countSelecionado++;
    }

    if(countSelecionado>0){
      TransformarValoTipoNotaResponse response = TransformarValoTipoNota.execute(TransformarValoTipoNotaParams(notaDetalle, notaMinRubro, notaMaxRubro, rubroEvaluacionUi?.tipoNotaUi));
      evaluacionUi?.valorTipoNotaId = response.valorTipoNotaUi?.valorTipoNotaId;
      evaluacionUi?.valorTipoNotaUi = response.valorTipoNotaUi;
      evaluacionUi?.nota = AppTools.roundDouble(response.nota??0.0, 2);// Se redondea a dos diguitos pero se muesta solo un digito para mostar al usuario
    }else{
      evaluacionUi?.valorTipoNotaId = null;
      evaluacionUi?.valorTipoNotaUi = null;
      evaluacionUi?.nota = 0.0;// Se redondea a dos diguitos pero se muesta solo un digito para mostar al usuario
    }
    refreshUI();
  }

  EvaluacionUi? getEvaluacionGeneralPersona(PersonaUi personaUi) {
    EvaluacionUi? evaluacionUi = null;
    for(EvaluacionUi item in rubroEvaluacionUi?.evaluacionUiList??[]){
      if(item.personaUi?.personaId == personaUi.personaId){
        evaluacionUi = item;
      }
    }
    return evaluacionUi;
  }

  onClicClearEvaluacionAll(ValorTipoNotaUi valorTipoNotaUi, PersonaUi personaUi) {
    for(List cellList in mapCellListList[personaUi]??[]){
      for(var cell in cellList){
        if(cell is EvaluacionRubricaValorTipoNotaUi){
          if(cell.evaluacionUi?.evaluacionId!=null){
              cell.toggle = false;
              cell.evaluacionUi?.nota = 0.0;
              cell.evaluacionUi?.valorTipoNotaId = null;
              cell.evaluacionUi?.valorTipoNotaUi = null;
          }
        }
      }
    }
    refreshUI();
  }



}