import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/indicador/individual/evaluacion_indicador_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_publicado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/calcular_evaluacion_proceso.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/transformar_valor_tipo_nota.dart';

class EvaluacionIndicadorController extends Controller{
  String? rubroEvaluacionId;
  CursosUi? cursosUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;
  EvaluacionIndicadorPresenter presenter;
  List<dynamic> _columnList2 = [];
  bool _showDialogEliminar = false;
  bool get showDialogEliminar => _showDialogEliminar;
  bool _showDialogClearEvaluacion = false;
  bool get showDialogClearEvaluacion => _showDialogClearEvaluacion;
  List<dynamic> get columnList2 => _columnList2;
  List<dynamic> _rowList2 = [];
  List<dynamic> get rowList2 => _rowList2;
  List<List<dynamic>> _cellListList = [];
  List<List<dynamic>> get cellListList => _cellListList;
  bool _precision = false;
  bool get precision => _precision;
  bool _showDialog = false;
  bool get showDialog => _showDialog;
  bool _modificado = false;
  RubricaEvaluacionUi? rubricaEvaluacionUiCebecera;
  RubricaEvaluacionUi? rubricaEvaluacionUiDetalle;

  EvaluacionIndicadorController(this.rubroEvaluacionId, this.cursosUi, this.calendarioPeriodoUI, rubroRepo, configuracionRepo, httpDatosRepo): presenter = EvaluacionIndicadorPresenter(rubroRepo, configuracionRepo, httpDatosRepo);

  @override
  void initListeners() {
    this.rubricaEvaluacionUiCebecera = null;
    this.rubricaEvaluacionUiDetalle = null;

    presenter.getRubroEvaluacionOnError = (e){

    };

    presenter.getRubroEvaluacionOnNext = (RubricaEvaluacionUi? rubroEvaluacionUi, List<PersonaUi> alumnoCursoList,){
      initTable(alumnoCursoList, rubroEvaluacionUi);
      refreshUI();
    };
  }

  @override
  void onInitState() {
    presenter.getRubroEvaluacion(rubroEvaluacionId, cursosUi);

  }

  void initTable(List<PersonaUi> alumnoCursoList, RubricaEvaluacionUi? rubricaEvaluacionUiCebecera){
    this.rubricaEvaluacionUiCebecera = rubricaEvaluacionUiCebecera;

    RubricaEvaluacionUi? rubroEvaluacionUi = rubricaEvaluacionUiCebecera;
     if((rubricaEvaluacionUiCebecera?.rubrosDetalleList?.isNotEmpty??false)){
       rubricaEvaluacionUiDetalle = rubricaEvaluacionUiCebecera?.rubrosDetalleList?[0];//Agregar el detalle
       rubroEvaluacionUi = rubricaEvaluacionUiDetalle;
     }


    _rowList2.clear();
    _cellListList.clear();
    _columnList2.clear();

    _rowList2.addAll(alumnoCursoList);
    _rowList2.add("");//Espacio
    _rowList2.add("");//Espacio
    _rowList2.add("");//Espacio

    _columnList2.add(ContactoUi());//Titulo alumno
    if(rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS||rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
      _columnList2.addAll(rubroEvaluacionUi?.tipoNotaUi?.valorTipoNotaList??[]);

    }else {
      _columnList2.add(EvaluacionUi());//Notas de tipo Numerico
    }

   _columnList2.add(EvaluacionPublicadoUi(EvaluacionUi()));
   _columnList2.add("comentario");
   _columnList2.add("");// espacio

    for(dynamic row in _rowList2){
      List<dynamic>  cellList = [];
      cellList.add(row);

      //#obtner Nota Tatal
      if(row is PersonaUi){

        //Comprobar si la cabecera tiene tiene evaluacion
        EvaluacionUi? evaluacionUiCabecera = this.rubricaEvaluacionUiCebecera?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == row.personaId);
        if(evaluacionUiCabecera==null){
          evaluacionUiCabecera = EvaluacionUi();
          evaluacionUiCabecera.rubroEvaluacionUi = rubricaEvaluacionUiCebecera;
          evaluacionUiCabecera.alumnoId = row.personaId;
          row.soloApareceEnElCurso = true;
          this.rubricaEvaluacionUiCebecera?.evaluacionUiList?.add(evaluacionUiCabecera);
        }

        EvaluacionUi? evaluacionUi = rubroEvaluacionUi?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == row.personaId);
        //Una evaluacion vasia significa que el alumno no tiene evaluacion
        if(evaluacionUi==null){
          evaluacionUi = EvaluacionUi();
          row.soloApareceEnElCurso = true;
          evaluacionUi.rubroEvaluacionUi = rubroEvaluacionUi;
          evaluacionUi.alumnoId = row.personaId;
          rubroEvaluacionUi?.evaluacionUiList?.add(evaluacionUi);
        }
        evaluacionUi.personaUi = row;//se remplasa la persona con la lista de alumno del curso por que contiene informacion de vigencia


        if(rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS||rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){

          for (ValorTipoNotaUi valorTipoNotaUi in rubroEvaluacionUi?.tipoNotaUi?.valorTipoNotaList??[]) {
            EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi = EvaluacionRubricaValorTipoNotaUi();
            evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi = rubroEvaluacionUi;
            evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi =  valorTipoNotaUi;
            evaluacionRubricaValorTipoNotaUi.evaluacionUi = evaluacionUi;
            if(evaluacionUi.valorTipoNotaId == evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId){
              evaluacionRubricaValorTipoNotaUi.toggle = true;
            }
            cellList.add(evaluacionRubricaValorTipoNotaUi);
          }

        }else {
          cellList.add(evaluacionUi);//Notas de tipo Numerico
        }
        cellList.add(EvaluacionPublicadoUi(evaluacionUi));//
        cellList.add("comentario");

      }else{
        if(rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS||rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
          for (ValorTipoNotaUi valorTipoNotaUi in rubroEvaluacionUi?.tipoNotaUi?.valorTipoNotaList??[]) {
            cellList.add("");//Espacio
          }
        }else {
          cellList.add("");//Espacio
        }
        cellList.add("");//Espacio
        cellList.add("");//Espacio
      }
      cellList.add("");// espacio
      _cellListList.add(cellList);
    }

    showTodosPublicados();
  }

  onClicEvaluar(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi) {

    for(List cellList in cellListList){
      for(var cell in cellList){
         if(cell is EvaluacionRubricaValorTipoNotaUi){
           if(cell.evaluacionUi?.alumnoId == evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId
               && cell != evaluacionRubricaValorTipoNotaUi){
             cell.toggle = false;
           }
         }
      }
    }

    evaluacionRubricaValorTipoNotaUi.toggle = !(evaluacionRubricaValorTipoNotaUi.toggle??false);
    if(evaluacionRubricaValorTipoNotaUi.toggle??false){
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorNumerico;//actualizar la nota solo cuando no esta selecionado
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaId = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId;
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaUi = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi;
    }else{
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota = 0.0;
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaId = null;
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaUi = null;
    }
    //evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorNumerico;
    refreshUI();
    _modificado = true;
    _actualizarCabecera(evaluacionRubricaValorTipoNotaUi.evaluacionUi?.personaUi);
    presenter.updateEvaluacion(rubricaEvaluacionUiCebecera, evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId);
  }

  void onClicEvaluarPresicion(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, double nota) {
    for(List cellList in cellListList){
      for(var cell in cellList){
        if(cell is EvaluacionRubricaValorTipoNotaUi){
          if(cell.evaluacionUi?.alumnoId == evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId
              && cell != evaluacionRubricaValorTipoNotaUi){
            cell.toggle = false;
          }
        }
      }
    }

    evaluacionRubricaValorTipoNotaUi.toggle = true;
    evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota = nota;//actualizar la nota solo cuando no esta selecionado
    evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaId = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId;
    evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaUi = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi;
    //evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorNumerico;
    refreshUI();
    _modificado = true;
    _actualizarCabecera(evaluacionRubricaValorTipoNotaUi.evaluacionUi?.personaUi);
    presenter.updateEvaluacion(rubricaEvaluacionUiCebecera, evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId);
  }

  onClicPrecision() {
      this._precision = !_precision;
      refreshUI();
  }

  onClicEvaluacionAll(ValorTipoNotaUi valorTipoNotaUi) {
    for(List cellList in cellListList){
      for(var cell in cellList){
        if(cell is EvaluacionRubricaValorTipoNotaUi){
          if(cell.evaluacionUi?.personaUi?.contratoVigente??false){
            if(cell.valorTipoNotaUi?.valorTipoNotaId == valorTipoNotaUi.valorTipoNotaId){
              cell.toggle = true;
              cell.evaluacionUi?.nota = valorTipoNotaUi.valorNumerico;//actualizar la nota solo cuando no esta selecionado
              cell.evaluacionUi?.valorTipoNotaId = valorTipoNotaUi.valorTipoNotaId;
              cell.evaluacionUi?.valorTipoNotaUi =  valorTipoNotaUi;
            }else{
              cell.toggle = false;
            }
          }
        }
      }
    }
    refreshUI();
    _modificado = true;
    _actualizarCabecera(null);
    presenter.updateEvaluacionAll(rubricaEvaluacionUiCebecera);
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

  void onClicPublicado(EvaluacionPublicadoUi evaluacionPublicadoUi) {

      evaluacionPublicadoUi.publicado = !evaluacionPublicadoUi.publicado;
      showTodosPublicados();
      refreshUI();
      _modificado = true;
      presenter.updateEvaluacion(rubricaEvaluacionUiCebecera, evaluacionPublicadoUi.evaluacionUi?.alumnoId);
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

  void onClicPublicarAll(EvaluacionPublicadoUi evaluacionPublicadoUi) {
    evaluacionPublicadoUi.publicado = !evaluacionPublicadoUi.publicado;
    for(List cellList in cellListList){
      for(var cell in cellList){
        if(cell is EvaluacionPublicadoUi && (cell.evaluacionUi?.personaUi?.contratoVigente??false)){
            cell.publicado = evaluacionPublicadoUi.publicado;
        }
      }
    }
    refreshUI();
    _modificado = true;
    presenter.updateEvaluacionAll(rubricaEvaluacionUiCebecera);
  }

  void onClickCancelarEliminar() {
    _showDialogEliminar = false;
    refreshUI();
  }

  void onClickEliminar() {
    _showDialogEliminar = true;
    refreshUI();
  }

  onClicClearEvaluacionAll() {
    for(List cellList in cellListList){
      for(var cell in cellList){
        if(cell is EvaluacionRubricaValorTipoNotaUi&& (cell.evaluacionUi?.personaUi?.contratoVigente??false)){
            cell.toggle = false;
            cell.evaluacionUi?.nota = 0.0;
            cell.evaluacionUi?.valorTipoNotaId = null;
            cell.evaluacionUi?.valorTipoNotaUi = null;
        }
      }
    }
    _showDialogClearEvaluacion = false;
    refreshUI();
    _modificado = true;
    _actualizarCabecera(null);
    presenter.updateEvaluacionAll(rubricaEvaluacionUiCebecera);
  }

  onClikShowDialogClearEvaluacion() {
    _showDialogClearEvaluacion = true;
    refreshUI();
  }

  void onClickCancelarClearEvaluacion() {
    _showDialogClearEvaluacion = false;
    refreshUI();
  }

  Future<void> onClickAceptarEliminar() async{
    _showDialogEliminar = false;
    _showDialog = true;
    refreshUI();
    await presenter.deleteRubroEvaluacion(rubricaEvaluacionUiCebecera);
    await presenter.updateServer(cursosUi, calendarioPeriodoUI ,rubricaEvaluacionUiCebecera);

  }

  Future<bool?> onSave() async{
    if(_modificado){
      _showDialog = true;
      refreshUI();
      await presenter.updateServer(cursosUi, calendarioPeriodoUI ,rubricaEvaluacionUiCebecera);
    }

    return _modificado;
  }



  void _actualizarCabecera(PersonaUi? personaUi) {
    CalcularEvaluacionProceso.actualizarCabecera(rubricaEvaluacionUiCebecera, personaUi);
  }


}