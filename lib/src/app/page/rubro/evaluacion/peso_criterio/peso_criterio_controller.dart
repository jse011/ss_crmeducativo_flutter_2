import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/capacidad/evaluacion_capacidad_presenter.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/peso_criterio/peso_criterio_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_trasnformada_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_porcentaje_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_peso_selected_ui.dart';
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

class PesoCriterioController extends Controller{
  static int Modifico_Peso_Rubro = 0, Modifico_Evaluacion = 1;
  CapacidadUi capacidadUi;
  CursosUi cursosUi;
  PesoCriterioPresenter presenter;
  List<dynamic> _tableColumns = [];
  List<dynamic> get tableColumns => _tableColumns;
  List<List<dynamic>> _tableCells = [];
  List<List<dynamic>> get tableCells => _tableCells;
  List<RubricaEvaluacionUi> _rubricaEvaluacionList = [];
  List<RubricaEvaluacionUi> get rubricaEvaluacionList => _rubricaEvaluacionList;
  List<RubricaEvaluacionUi?> _rubricaModificadoList = [];
  bool _showDialog = false;
  bool get showDialog => _showDialog;

  PesoCriterioController(this.capacidadUi, this.cursosUi, ConfiguracionRepository configuracionRepo, RubroRepository rubroRepo, HttpDatosRepository httpDatosRepo):
      presenter = PesoCriterioPresenter(configuracionRepo, rubroRepo, httpDatosRepo);

  @override
  void initListeners() {

  }

  @override
  void onInitState() {
    super.onInitState();
    iniciarTablaTipoNota();
  }

  void iniciarTablaTipoNota(){
    _tableColumns.clear();

    _tableCells.clear();
    _rubricaEvaluacionList.clear();

    _rubricaEvaluacionList = capacidadUi.rubricaEvalUiList??[];
    _tableColumns.add("promedio");
    _tableColumns.add("alta");//Nivel complejidad\nalta
    _tableColumns.add("estandar");//Nivel complejidad\nestandar
    _tableColumns.add("baja");//Nivel complejidad\nbaja
    _tableColumns.add("no_usar");//No usar\ncriterio

    _tableColumns.add("peso_criterio");

    List<List<dynamic>> output = [];
    for (int i = 0; i < _rubricaEvaluacionList.length; i++) {
      RubricaEvaluacionUi rubricaEvaluacionUi = _rubricaEvaluacionList[i];
      final List<dynamic> row = [];

      row.add(rubricaEvaluacionUi);

      RubricaEvaluacionPesoSelectedUi criterioPesoAltaUi = RubricaEvaluacionPesoSelectedUi();
      criterioPesoAltaUi.peso = 3;
      criterioPesoAltaUi.rubricaEvaluacionUi = rubricaEvaluacionUi;
      criterioPesoAltaUi.selected = rubricaEvaluacionUi.peso ==3;
      row.add(criterioPesoAltaUi);

      RubricaEvaluacionPesoSelectedUi criterioPesoEstandarUi = RubricaEvaluacionPesoSelectedUi();
      criterioPesoEstandarUi.peso = 2;
      criterioPesoEstandarUi.rubricaEvaluacionUi = rubricaEvaluacionUi;
      criterioPesoEstandarUi.selected = rubricaEvaluacionUi.peso == 2;

      row.add(criterioPesoEstandarUi);

      RubricaEvaluacionPesoSelectedUi criterioPesoBajaUi = RubricaEvaluacionPesoSelectedUi();
      criterioPesoBajaUi.peso = 1;
      criterioPesoBajaUi.rubricaEvaluacionUi = rubricaEvaluacionUi;
      criterioPesoBajaUi.selected = rubricaEvaluacionUi.peso == 1;

      row.add(criterioPesoBajaUi);

      RubricaEvaluacionPesoSelectedUi noUsarCriterioUi = RubricaEvaluacionPesoSelectedUi();
      noUsarCriterioUi.peso = -1;
      noUsarCriterioUi.rubricaEvaluacionUi = rubricaEvaluacionUi;
      noUsarCriterioUi.selected = rubricaEvaluacionUi.peso == -1;
      row.add(noUsarCriterioUi);

      EvaluacionPorcentajeUi rubricaPeso = EvaluacionPorcentajeUi(rubricaEvaluacionUi, capacidadUi);
      row.add(rubricaPeso);
      print("peso: ${rubricaEvaluacionUi.peso}");
      print("rubricaIdRubroCabecera xD: ${rubricaEvaluacionUi.rubricaIdRubroCabecera}");
      //RubricaEvaluacionTotalUi rubricaEvaluacionTotalUi = RubricaEvaluacionTotalUi(evaluacionTransformadaUi);
      //row.add(rubricaEvaluacionTotalUi);
      output.add(row);
    }
    _tableCells = output;
    print("total peso: ${capacidadUi.total_peso}");
  }

  int _actualizarPeso(){
    int pesoTotal = 0;
    for(RubricaEvaluacionUi item in capacidadUi.rubricaEvalUiList??[]){
      int peso = CalcularEvaluacionResultados.getPesoRubro(item);
      pesoTotal = pesoTotal + (peso < 0 ? 0 : peso);//los pesos en negativo se cuentan como 0;
    }
    return pesoTotal;
  }

  onClickPeso(RubricaEvaluacionPesoSelectedUi pesoSelectedUi) {
    for(List list in _tableCells){
      for(dynamic cell in list){
        if(cell is RubricaEvaluacionPesoSelectedUi ){
          if(cell.rubricaEvaluacionUi?.rubroEvaluacionId == pesoSelectedUi.rubricaEvaluacionUi?.rubroEvaluacionId){
            cell.selected = false;
          }
        }
      }
    }


    pesoSelectedUi.selected = !(pesoSelectedUi.selected??false);
    pesoSelectedUi.rubricaEvaluacionUi?.peso = pesoSelectedUi.peso;
    capacidadUi.total_peso = _actualizarPeso();
    print("rubroEvaluacionIdCabecera cLICK: ${pesoSelectedUi.rubricaEvaluacionUi?.rubricaIdRubroCabecera}");
    _rubricaModificadoList.add(pesoSelectedUi.rubricaEvaluacionUi);
    refreshUI();
  }

  Future<bool> onSave() async {
    bool modificado = _rubricaModificadoList.isNotEmpty;
    if(modificado){
      List<String?> rubroEvaluacionIdList = [];

      for(var rubricaEvaluacionUi in _rubricaModificadoList){
        print("rubroEvaluacionId: ${rubricaEvaluacionUi?.rubroEvaluacionId} as");
        print("rubroEvaluacionIdCabecera: ${rubricaEvaluacionUi?.rubricaIdRubroCabecera} as");

        String? rubricaEvalId = rubricaEvaluacionUi?.rubricaIdRubroCabecera??rubricaEvaluacionUi?.rubroEvaluacionId;//obtner el id de los rubrica o el id rubro unidimensional
        bool existeId = rubroEvaluacionIdList.firstWhereOrNull((id) => id == rubricaEvalId) != null;

        if(!existeId){
          rubroEvaluacionIdList.add(rubricaEvalId);
        }
        await presenter.updatePesoRubroEvaluacion(rubricaEvaluacionUi);
        print("rubroEvaluacionIdCabecera: ${rubricaEvaluacionUi?.rubricaIdRubroCabecera}");

      }
      print("rubroEvaluacionIdList: ${rubroEvaluacionIdList.length}");

      await presenter.updateServer(rubroEvaluacionIdList);
    }


     return modificado;

  }

}


