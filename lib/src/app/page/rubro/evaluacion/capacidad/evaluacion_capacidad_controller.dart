import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/capacidad/evaluacion_capacidad_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_trasnformada_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_porcentaje_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_total_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/calcular_evaluacion_resultado.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/transformar_valor_tipo_nota.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_tipo_nota_resultado.dart';
import 'package:collection/collection.dart';

class EvaluacionCapacidadController extends Controller{
  static int Modifico_Peso_Rubro = 0, Modifico_Evaluacion = 1;
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
  bool _showDialog = false;
  bool get showDialog => _showDialog;
  Map<String?, int> rubroModificadosMap = Map();//Se guarda que rubro se modifico ademas si el contenido es 0 se modifico el peso y si es 1 se modifoco la evaluacion

  EvaluacionCapacidadController(this.evaluacionCapacidadUi, this.cursosUi, ConfiguracionRepository configuracionRepo, RubroRepository rubroRepo, HttpDatosRepository httpDatosRepo):
      presenter = EvaluacionCapacidadPresenter(configuracionRepo, rubroRepo, httpDatosRepo);

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
      _tableTipoNotacolumnWidths.add(80.0);

      _tableTipoNotaColumns.add("total");
      _tableTipoNotacolumnWidths.add(70.0);

      List<List<dynamic>> output = [];
      for (int i = 0; i < _rubricaEvaluacionList.length; i++) {
        RubricaEvaluacionUi rubricaEvaluacionUi = _rubricaEvaluacionList[i];
        final List<dynamic> row = [];
        //row.add(rubricaEvaluacionUi);

        EvaluacionTransformadaUi? evaluacionTransformadaUi = rubricaEvaluacionUi.evaluacionTransformadaUiList?.firstWhereOrNull((element) => element.alumnoId == evaluacionCapacidadUi.personaUi?.personaId);

        if(tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS||tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){

          for (int i = 0; i < ( _tipoNotaUi?.valorTipoNotaList??[]).length; i++) {
            EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi = EvaluacionRubricaValorTipoNotaUi();
            evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi = rubricaEvaluacionUi;
            evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi =  _tipoNotaUi?.valorTipoNotaList?[i];
            evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi = evaluacionTransformadaUi;
            if(evaluacionTransformadaUi?.valorTipoNotaUi?.valorTipoNotaId == evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId){
              evaluacionRubricaValorTipoNotaUi.toggle = true;
            }
            row.add(evaluacionRubricaValorTipoNotaUi);
          }

        }else {
          row.add(evaluacionTransformadaUi);//Notas de tipo Numerico
        }

        EvaluacionPorcentajeUi rubricaPeso = EvaluacionPorcentajeUi(rubricaEvaluacionUi, evaluacionCapacidadUi.capacidadUi);
        row.add(rubricaPeso);
        RubricaEvaluacionTotalUi rubricaEvaluacionTotalUi = RubricaEvaluacionTotalUi(evaluacionTransformadaUi);
        row.add(rubricaEvaluacionTotalUi);
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
          if (cell.evaluacionTransformadaUi?.alumnoId == evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.alumnoId
              && cell.evaluacionTransformadaUi?.rubroEvaluacionUi?.rubricaId == evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.rubricaId
              && cell != evaluacionRubricaValorTipoNotaUi) {
            cell.toggle = false;
          }
        }
      }
    }

    evaluacionRubricaValorTipoNotaUi.toggle = !(evaluacionRubricaValorTipoNotaUi.toggle ?? false);
    if(evaluacionRubricaValorTipoNotaUi.toggle??false){
      evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.nota = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorNumerico;
      evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.valorTipoNotaId = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId;
      evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.valorTipoNotaUi = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi;
    }else{
      evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.nota = 0.0;
      evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.valorTipoNotaId = null;
      evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.valorTipoNotaUi = null;
    }

    CalcularEvaluacionResultados.actualizarEvaluacionOriginal( evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi, tipoNotaUi);
    CalcularEvaluacionResultados.calcularEvaluacionCapacidad(evaluacionCapacidadUi: evaluacionCapacidadUi, tipoNotaUiResultado: tipoNotaUi, alumnoId: evaluacionCapacidadUi.personaUi?.personaId);
    refreshUI();

    validacionModificacion(evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi, Modifico_Evaluacion);

  }

  void onClicEvaluarPresicion(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, nota) {

    for (List cellList in _tableTipoNotaCells) {
      for (var cell in cellList) {
        if (cell is EvaluacionRubricaValorTipoNotaUi) {
          if (cell.evaluacionTransformadaUi?.alumnoId == evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.alumnoId
              && cell.evaluacionTransformadaUi?.rubroEvaluacionUi?.rubricaId == evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.rubricaId
              && cell != evaluacionRubricaValorTipoNotaUi) {
            cell.toggle = false;
          }
        }
      }
    }

    evaluacionRubricaValorTipoNotaUi.toggle = true;
    evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.nota = nota;
    evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.valorTipoNotaId = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId;
    evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.valorTipoNotaUi = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi;

    CalcularEvaluacionResultados.actualizarEvaluacionOriginal( evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi, tipoNotaUi);
    CalcularEvaluacionResultados.calcularEvaluacionCapacidad(evaluacionCapacidadUi: evaluacionCapacidadUi, tipoNotaUiResultado: tipoNotaUi, alumnoId: evaluacionCapacidadUi.personaUi?.personaId);
    refreshUI();
    validacionModificacion(evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi, Modifico_Evaluacion);
  }

  void onSaveTecladoPresicion(double? nota, EvaluacionTransformadaUi? evaluacionUi) {
    if (tipoNotaUi?.tipoNotaTiposUi ==  TipoNotaTiposUi.SELECTOR_VALORES || tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS){
      ValorTipoNotaUi? valorTipoNotaUi = TransformarValoTipoNota.getValorTipoNotaCalculado(tipoNotaUi, nota??0);

      for (List cellList in _tableTipoNotaCells) {
        for (var cell in cellList) {
          if (cell is EvaluacionRubricaValorTipoNotaUi) {
            if (cell.evaluacionTransformadaUi?.alumnoId == evaluacionUi?.alumnoId
                && cell.evaluacionTransformadaUi?.rubroEvaluacionUi?.rubricaId == evaluacionUi?.rubroEvaluacionId
                && cell.valorTipoNotaUi?.valorTipoNotaId == valorTipoNotaUi?.valorTipoNotaId) {
              cell.toggle = true;
            }

            if (cell.evaluacionTransformadaUi?.alumnoId == evaluacionUi?.alumnoId
                && cell.evaluacionTransformadaUi?.rubroEvaluacionUi?.rubricaId == evaluacionUi?.rubroEvaluacionId
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

    CalcularEvaluacionResultados.actualizarEvaluacionOriginal(evaluacionUi, tipoNotaUi);
    CalcularEvaluacionResultados.calcularEvaluacionCapacidad(evaluacionCapacidadUi: evaluacionCapacidadUi, tipoNotaUiResultado: tipoNotaUi, alumnoId: evaluacionCapacidadUi.personaUi?.personaId);
    refreshUI();

    validacionModificacion(evaluacionUi?.rubroEvaluacionUi, Modifico_Evaluacion);
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
            cell.evaluacionTransformadaUi?.nota = valorTipoNotaUi.valorNumerico;//actualizar la nota solo cuando no esta selecionado
            cell.evaluacionTransformadaUi?.valorTipoNotaId = valorTipoNotaUi.valorTipoNotaId;
            cell.evaluacionTransformadaUi?.valorTipoNotaUi = valorTipoNotaUi;
            CalcularEvaluacionResultados.actualizarEvaluacionOriginal(cell.evaluacionTransformadaUi, tipoNotaUi);
          }else{
            cell.toggle = false;
          }

        }
      }
    }

    CalcularEvaluacionResultados.calcularEvaluacionCapacidad(evaluacionCapacidadUi: evaluacionCapacidadUi, tipoNotaUiResultado: tipoNotaUi, alumnoId: evaluacionCapacidadUi.personaUi?.personaId);
    refreshUI();
    for(RubricaEvaluacionUi rubroEvaluacion in evaluacionCapacidadUi.capacidadUi?.rubricaEvalUiList??[]){
      validacionModificacion(rubroEvaluacion, Modifico_Evaluacion);
    }

  }

  validacionModificacion(RubricaEvaluacionUi? rubricaEvaluacionUi, int tipoModificacion){
    if(rubroModificadosMap.containsKey(rubricaEvaluacionUi?.rubricaId) == Modifico_Evaluacion && tipoModificacion == Modifico_Peso_Rubro){
      // Si ya se modifico el peso a evaluacion no es nesario pasar al estado Modifico_Peso_Rubro devido a que con el estado modificacion se actaualizar tambien el peso
      rubroModificadosMap[rubricaEvaluacionUi?.rubricaId] = Modifico_Evaluacion;
    }else{
      rubroModificadosMap[rubricaEvaluacionUi?.rubricaId] = tipoModificacion;
    }
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
          cell.evaluacionTransformadaUi?.nota = 0.0;
          cell.evaluacionTransformadaUi?.valorTipoNotaId = null;
          cell.evaluacionTransformadaUi?.valorTipoNotaUi = null;
          CalcularEvaluacionResultados.actualizarEvaluacionOriginal(cell.evaluacionTransformadaUi, tipoNotaUi);
        }
      }
    }
    _showDialogClearEvaluacion = false;
    CalcularEvaluacionResultados.calcularEvaluacionCapacidad(evaluacionCapacidadUi: evaluacionCapacidadUi, tipoNotaUiResultado: tipoNotaUi, alumnoId: evaluacionCapacidadUi.personaUi?.personaId);

    refreshUI();

    for(RubricaEvaluacionUi rubroEvaluacion in evaluacionCapacidadUi.capacidadUi?.rubricaEvalUiList??[]){
      validacionModificacion(rubroEvaluacion, Modifico_Evaluacion);
    }
  }

  //_trasformarEvaluacion();

  void onSavePeso(int peso, RubricaEvaluacionUi? rubricaEvaluacionUi) {
      rubricaEvaluacionUi?.peso = peso;
      int pesoTotal = 0;
      for(RubricaEvaluacionUi item in evaluacionCapacidadUi.capacidadUi?.rubricaEvalUiList??[]){
        int peso = item.peso??0;
        pesoTotal = pesoTotal + (peso < 0 ? 0 : peso);//los pesos en negativo se cuentan como 0;
      }
      evaluacionCapacidadUi.capacidadUi?.total_peso = pesoTotal;

      CalcularEvaluacionResultados.calcularEvaluacionCapacidad(evaluacionCapacidadUi: evaluacionCapacidadUi, tipoNotaUiResultado: tipoNotaUi, alumnoId: evaluacionCapacidadUi.personaUi?.personaId);

      refreshUI();
      validacionModificacion(rubricaEvaluacionUi, Modifico_Peso_Rubro);

  }

  Future<bool> onSave() async {
    bool modificado = rubroModificadosMap.isNotEmpty;
    print("modificado: ${modificado}");
    List<String> rubroEvaluacionIdList = [];
    if(modificado){
      _showDialog = true;
      for(MapEntry<String?, int> row in rubroModificadosMap.entries) {
        RubricaEvaluacionUi? rubricaEvaluacionUi = evaluacionCapacidadUi.capacidadUi?.rubricaEvalUiList?.firstWhereOrNull((element) => element.rubricaId == row.key);
        if(rubricaEvaluacionUi != null){
          print("modificado1: ${modificado}");
          rubroEvaluacionIdList.add(rubricaEvaluacionUi.rubricaId??"");
          if(row.value == Modifico_Peso_Rubro){
            print("modificado1:Modifico_Peso_Rubro");
            await presenter.updatePesoRubroEvaluacion(rubricaEvaluacionUi);
          }else{
            print("modificado1:Modifico_Evaluacion");
            await presenter.updateEvaluacion(rubricaEvaluacionUi, evaluacionCapacidadUi.personaUi);
          }
        }
     }
      print("modificado2: ${modificado}");
      await presenter.updateServer(rubroEvaluacionIdList);
    }
    print("modificado3: ${modificado}");
    return modificado;
  }



}