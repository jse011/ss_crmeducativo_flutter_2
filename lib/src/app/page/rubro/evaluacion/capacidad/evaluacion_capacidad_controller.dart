import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/capacidad/evaluacion_capacidad_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_peso_ui.dart';
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
  TipoNotaUi? get tipoNotaUi => _tipoNotaUi;
  List<dynamic> _tableTipoNotaColumns = [];
  List<dynamic> get tableTipoNotaColumns => _tableTipoNotaColumns;
  List<List<dynamic>> _tableTipoNotaCells = [];
  List<List<dynamic>> get tableTipoNotaCells => _tableTipoNotaCells;
  List<double> _tableTipoNotacolumnWidths = [];
  List<double> get tableTipoNotacolumnWidths => _tableTipoNotacolumnWidths;
  List<RubricaEvaluacionUi> _rubricaEvaluacionList = [];
  List<RubricaEvaluacionUi> get rubricaEvaluacionList => _rubricaEvaluacionList;

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
    presenter.getTipoNotaResultado(cursosUi);
  }

  void iniciarTablaTipoNota(){
    _tableTipoNotaColumns.clear();
    _tableTipoNotacolumnWidths.clear();
    _tableTipoNotaCells.clear();
    _rubricaEvaluacionList.clear();

    _rubricaEvaluacionList = evaluacionCapacidadUi.capacidadUi?.rubricaEvalUiList??[];

    if(_tipoNotaUi!=null){
      _tableTipoNotaColumns.add("Evaluación");
      _tableTipoNotacolumnWidths.add(125.0);
      for (ValorTipoNotaUi valorTipoNotaUi in _tipoNotaUi?.valorTipoNotaList??[]) {
        _tableTipoNotaColumns.add(valorTipoNotaUi);
        _tableTipoNotacolumnWidths.add(50.0);
      }
      _tableTipoNotaColumns.add(true);
      _tableTipoNotacolumnWidths.add(45.0);
      List<int> percentParts = getPercentPartsV2(100, _rubricaEvaluacionList.length);
      List<List<dynamic>> output = [];
      for (int i = 0; i < _rubricaEvaluacionList.length; i++) {
        RubricaEvaluacionUi rubricaEvaluacionUi = _rubricaEvaluacionList[i];
        final List<dynamic> row = [];
        row.add(rubricaEvaluacionUi);
        int notaMaxRubro = rubricaEvaluacionUi.tipoNotaUi?.escalavalorMaximo??0;
        int notaMinRubro = rubricaEvaluacionUi.tipoNotaUi?.escalavalorMinimo??0;
        EvaluacionUi? evaluacionUi = rubricaEvaluacionUi.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == evaluacionCapacidadUi.personaUi?.personaId);
        TransformarValoTipoNotaResponse response = TransformarValoTipoNota.execute(TransformarValoTipoNotaParams(evaluacionUi?.nota, notaMinRubro, notaMaxRubro, _tipoNotaUi));

        for (int i = 0; i < ( _tipoNotaUi?.valorTipoNotaList??[]).length; i++) {
          EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi = EvaluacionRubricaValorTipoNotaUi();
          evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi = rubricaEvaluacionUi;
          evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi =  _tipoNotaUi?.valorTipoNotaList?[i];
          evaluacionRubricaValorTipoNotaUi.evaluacionUi = evaluacionUi;
          if(response.valorTipoNotaUi?.valorTipoNotaId == evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId){
            evaluacionRubricaValorTipoNotaUi.toggle = true;
          }
          row.add(evaluacionRubricaValorTipoNotaUi);
        }


        RubricaPeso rubricaPeso = RubricaPeso();
        rubricaPeso.peso = percentParts[i];
        rubricaPeso.criterioUi = rubricaEvaluacionUi;
        row.add(rubricaPeso);
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

}