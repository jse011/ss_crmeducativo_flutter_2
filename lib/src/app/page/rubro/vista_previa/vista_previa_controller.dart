import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/vista_previa/vista_previa_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_calendario_periodo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:collection/collection.dart';

class VistaPreviaController extends Controller {
  CursosUi? cursosUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;
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

  VistaPreviaPresenter presenter;

  VistaPreviaController(this.cursosUi, this.calendarioPeriodoUI, RubroRepository rubroRepo, ConfiguracionRepository configuracionRepo):
        presenter = VistaPreviaPresenter(rubroRepo, configuracionRepo);

  @override
  void initListeners() {
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
      _columnList2.add(ContactoUi());//Titulo foto_alumno

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
              competenciaUi.round = true;
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

      _progress = false;//ocultar el progress cuando se esta en el tab competencia
      refreshUI();
    };

    presenter.getCompetenciaRubroEvalOnError = (e){
      _tipoNotaUi = null;
      _rowList2 = [];
      _columnList2.clear();
      _cellListList.clear();
     _progress = false;//ocultar el progress cuando se esta en el tab competencia
      refreshUI();
    };
  }

  @override
  void onInitState() {
    presenter.onGetCompetenciaRubroEval(cursosUi, calendarioPeriodoUI);
    super.onInitState();
  }

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }

}