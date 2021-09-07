import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/capacidad/evaluacion_capacidad_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_total_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/transformar_valor_tipo_nota.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_tipo_nota_resultado.dart';
import 'package:collection/collection.dart';

class EvaluacionCapacidadController extends Controller{
  EvaluacionCapacidadUi evaluacionCapacidadUi;
  CursosUi cursosUi;
  EvaluacionCapacidadPresenter presenter;
  TipoNotaUi? _tipoNotaUi = null;
  bool _precision = true;
  bool get precision => _precision;
  TipoNotaUi? get tipoNotaUi => _tipoNotaUi;
  List<dynamic> _tableTipoNotaColumns = [];
  List<dynamic> get tableTipoNotaColumns => _tableTipoNotaColumns;
  List<List<dynamic>> _tableTipoNotaCells = [];
  List<List<dynamic>> get tableTipoNotaCells => _tableTipoNotaCells;
  List<double> _tableTipoNotacolumnWidths = [];
  List<double> get tableTipoNotacolumnWidths => _tableTipoNotacolumnWidths;
  List<RubricaEvaluacionUi> _rubricaEvaluacionList = [];
  List<RubricaEvaluacionUi> get rubricaEvaluacionList => _rubricaEvaluacionList;
  bool _showMsgAlumnoNoVigente = false;
  bool get showMsgAlumnoNoVigente => _showMsgAlumnoNoVigente;
  bool _showDialogClearEvaluacion = false;
  bool get showDialogClearEvaluacion => _showDialogClearEvaluacion;

  EvaluacionCapacidadController(this.evaluacionCapacidadUi, this.cursosUi, RubroRepository rubroRepo):
      presenter = EvaluacionCapacidadPresenter(GetTipoNotaResultado(rubroRepo));

  @override
  void initListeners() {
    presenter.getTipoNotaResultadoEvalOnError = (e){
       _tipoNotaUi = null;
    };

    presenter.getTipoNotaResultadoOnNext = (TipoNotaUi tipoNotaUi){
      _tipoNotaUi = tipoNotaUi;
      iniciarTablaTipoNota();
    };
  }

  @override
  void onInitState() {
    super.onInitState();
    if(!(evaluacionCapacidadUi.personaUi?.contratoVigente??false)){
      _showMsgAlumnoNoVigente = true;
      refreshUI();
    }
    presenter.getTipoNotaResultado(cursosUi);
  }

  void iniciarTablaTipoNota(){
    _tableTipoNotaColumns.clear();
    _tableTipoNotacolumnWidths.clear();
    _tableTipoNotaCells.clear();
    _rubricaEvaluacionList.clear();

    _rubricaEvaluacionList = evaluacionCapacidadUi.capacidadUi?.rubricaEvalUiList??[];

    if(_tipoNotaUi!=null){
      if(tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS||tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
        for (ValorTipoNotaUi valorTipoNotaUi in _tipoNotaUi?.valorTipoNotaList??[]) {
          _tableTipoNotaColumns.add(valorTipoNotaUi);
          _tableTipoNotacolumnWidths.add(50.0);
        }

      }else {
        _tableTipoNotaColumns.add(EvaluacionUi());//Notas de tipo Numerico
        _tableTipoNotacolumnWidths.add(50.0);
      }

      _tableTipoNotaColumns.add("peso");
      _tableTipoNotacolumnWidths.add(50.0);

      _tableTipoNotaColumns.add("total");
      _tableTipoNotacolumnWidths.add(50.0);

      List<List<dynamic>> output = [];
      for (int i = 0; i < _rubricaEvaluacionList.length; i++) {
        RubricaEvaluacionUi rubricaEvaluacionUi = _rubricaEvaluacionList[i];
        final List<dynamic> row = [];
        //row.add(rubricaEvaluacionUi);
        int notaMaxRubro = rubricaEvaluacionUi.tipoNotaUi?.escalavalorMaximo??0;
        int notaMinRubro = rubricaEvaluacionUi.tipoNotaUi?.escalavalorMinimo??0;
        EvaluacionUi? evaluacionUi = rubricaEvaluacionUi.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == evaluacionCapacidadUi.personaUi?.personaId);

        TransformarValoTipoNotaResponse response = TransformarValoTipoNota.execute(TransformarValoTipoNotaParams(evaluacionUi?.nota, notaMinRubro, notaMaxRubro, _tipoNotaUi));
        rubricaEvaluacionUi.peso = 1;//el peso para este calculo no viene de la tabla trnFormula

        if(tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS||tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){

          for (int i = 0; i < ( _tipoNotaUi?.valorTipoNotaList??[]).length; i++) {
            EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi = EvaluacionRubricaValorTipoNotaUi();
            evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi = rubricaEvaluacionUi;
            evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi =  _tipoNotaUi?.valorTipoNotaList?[i];
            
            evaluacionRubricaValorTipoNotaUi.evaluacionUi = EvaluacionUi();
            evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId = evaluacionUi?.alumnoId;
            evaluacionRubricaValorTipoNotaUi.evaluacionUi?.personaUi = evaluacionCapacidadUi.personaUi;//agregar la persona de la capacidad para saver si el alumno esta con el contrato vigente
            evaluacionRubricaValorTipoNotaUi.evaluacionUi?.publicado = evaluacionUi?.publicado;
            evaluacionRubricaValorTipoNotaUi.evaluacionUi?.evaluacionId = evaluacionUi?.evaluacionId;
            evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota = response.nota;
            evaluacionRubricaValorTipoNotaUi.evaluacionUi?.rubroEvaluacionId = evaluacionUi?.rubroEvaluacionId;
            evaluacionRubricaValorTipoNotaUi.evaluacionUi?.rubroEvaluacionUi = evaluacionUi?.rubroEvaluacionUi;
            evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaId = response.valorTipoNotaUi?.valorTipoNotaId;
            evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaUi = response.valorTipoNotaUi;

            if(response.valorTipoNotaUi?.valorTipoNotaId == evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId){
              evaluacionRubricaValorTipoNotaUi.toggle = true;
            }
            row.add(evaluacionRubricaValorTipoNotaUi);
          }

        }else {
          row.add(evaluacionUi);//Notas de tipo Numerico
        }



        RubricaEvaluacionPesoUi rubricaPeso = RubricaEvaluacionPesoUi(rubricaEvaluacionUi);
        rubricaPeso.peso = rubricaPeso.peso;
        rubricaPeso.rubricaEvaluacionUi = rubricaEvaluacionUi;
        row.add(rubricaPeso);

        RubricaEvaluacionTotalUi rubricaEvaluacionPesoUi = RubricaEvaluacionTotalUi();
        rubricaEvaluacionPesoUi.evaluacionUi = evaluacionUi;
        double? nota = evaluacionUi?.nota;

        if(nota!=null){
          rubricaEvaluacionPesoUi.total = nota;
        }else{
          rubricaEvaluacionPesoUi.total = null;
        }
        row.add(rubricaEvaluacionPesoUi);
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

  onClicPrecision() {
    _precision = !_precision;
    refreshUI();
  }

  void onClickEliminar() {}

  void onClicEvaluar(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi) {
    for (List cellList in _tableTipoNotaCells) {
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

    //_actualizarCabecera(personaUi);
    //_modificado = true;
    refreshUI();

    //presenter.updateEvaluacion(rubroEvaluacionUi, personaUi.personaId);
  }

  void onClicEvaluarPresicion(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, nota) {
    for (List cellList in _tableTipoNotaCells) {
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
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota = nota;
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaId = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId;
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaUi = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi;
    }else{
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota = 0.0;
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaId = null;
      evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaUi = null;
    }

    //_actualizarCabecera(personaUi);
    //_modificado = true;
    refreshUI();

    //presenter.updateEvaluacion(rubroEvaluacionUi, personaUi.personaId);
  }

  void hideMsgAlumnoNoVigente() {
    _showMsgAlumnoNoVigente = false;
    refreshUI();
  }

  void showControNoVigente() {
    _showMsgAlumnoNoVigente = true;
    refreshUI();
  }

  onClicEvaluacionAll(ValorTipoNotaUi valorTipoNotaUi) {

    for (List cellList in _tableTipoNotaCells) {
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

    //_actualizarCabecera(personaUi);
    //_modificado = true;
    refreshUI();

    //presenter.updateEvaluacionAll(rubroEvaluacionUi);
  }

  onClickCancelarClearEvaluacion() {
    _showDialogClearEvaluacion = false;
    refreshUI();
  }

  onClikShowDialogClearEvaluacion() {
    _showDialogClearEvaluacion = true;
    refreshUI();
  }

  void onClicClearEvaluacionAll() {
    for(List cellList in _tableTipoNotaCells){
      for(var cell in cellList){
        if(cell is EvaluacionRubricaValorTipoNotaUi){
          cell.toggle = false;
          cell.evaluacionUi?.nota = 0.0;
          cell.evaluacionUi?.valorTipoNotaId = null;
          cell.evaluacionUi?.valorTipoNotaUi = null;
        }
      }
    }
    _showDialogClearEvaluacion = false;
    //_actualizarCabecera();
    refreshUI();
    //_modificado = true;

    //presenter.updateEvaluacionAll(rubricaEvaluacionUiCebecera);
  }

}