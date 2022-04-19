import 'dart:io';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/indicador/multiple/evaluacion_indicador_multiple_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_equipo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_publicado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_grupo_valor_tipo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/integrante_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_eval_equipo_integrante_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_equipo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_formula_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_comentario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_evidencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/calcular_evaluacion_proceso.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/id_generator.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/transformar_valor_tipo_nota.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart';

class EvaluacionIndicadorMultipleController extends Controller {
  String rubroEvaluacionId;
  CursosUi cursosUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;
  EvaluacionIndicadorMultiplePresenter presenter;
  RubricaEvaluacionUi? rubroEvaluacionUi;
  List<dynamic> _columnList2 = [];
  EvaluacionUi? _evaluacionGeneralUiSelect = null;
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

  List<RubricaEvaluacionEquipoUi> _rubricaEvaluacionEquipoUiList = [];
  List<RubricaEvaluacionEquipoUi> get rubricaEvaluacionEquipoUiList => _rubricaEvaluacionEquipoUiList;
  Map<String?, List<dynamic>> _mapColumnEquipoList = Map();
  Map<String?, List<RubricaEvaluacionUi>> _mapRowEquipoList = Map();
  Map<String?, List<List<dynamic>>> _mapCellListEquipoList = Map();
  Map<String?, List<dynamic>> get mapColumnEquipoList => _mapColumnEquipoList;
  Map<String?, List<RubricaEvaluacionUi>> get mapRowEquipoList => _mapRowEquipoList;
  Map<String?, List<List<dynamic>>> get mapCellListEquipoList => _mapCellListEquipoList;


  RubricaEvaluacionEquipoUi? _rubricaEvaluacionEquipoUiSelected = null;
  RubricaEvaluacionEquipoUi? get rubricaEvaluacionEquipoUiSelected => _rubricaEvaluacionEquipoUiSelected;

  bool _atrasGrupo = false;
  bool get atrasGrupo => _atrasGrupo;
  bool _siguienteGrupo = false;
  bool get siguienteGrupo => _siguienteGrupo;

  Map<RubroEvidenciaUi, HttpStream?> mapRubroEvidencia = Map();

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
      _alumnoCursoList = alumnoCursoList;
      //print("rubroEvaluacionUi: ${this.rubroEvaluacionUi?.evaluacionUiList?.length}");
      initTable(alumnoCursoList, rubroEvaluacionUi);
      initLista(alumnoCursoList, rubroEvaluacionUi);
      initListaGrupo( rubroEvaluacionUi);
      refreshUI();
    };

    presenter.uploadFileRubroEvidenciaOnProgress = (double? progress,  RubroEvidenciaUi? rubroEvidenciaUi){
      rubroEvidenciaUi?.progress = progress;
      refreshUI();
    };

    presenter.uploadFileRubroEvidenciaOnSucces = (bool success, RubroEvidenciaUi? rubroEvidenciaUi){
      rubroEvidenciaUi?.success = success;
      if(success){
        presenter.saveRubroEvidenciaUi(rubroEvidenciaUi);
      }else{
        //_mensaje = "Error al subir el archivo";
      }
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


    if((rubricaEvaluacionUi?.equipoUiList??[]).isNotEmpty){

      List<PersonaUi> newAlumnoCursoList = [];

      for(RubricaEvaluacionEquipoUi rubricaEvaluacionEquipoUi in rubricaEvaluacionUi?.equipoUiList??[]){
        _rowList2.add(rubricaEvaluacionEquipoUi);

        for(RubricaEvalEquipoIntegranteUi equipoUi in rubricaEvaluacionEquipoUi.integrantesUiList??[]){
          equipoUi.personaUi = alumnoCursoList.firstWhereOrNull((element) => element.personaId == equipoUi.personaId);
        }

        rubricaEvaluacionEquipoUi.integrantesUiList?.sort((a, b) {
          String o1 = a.personaUi?.nombreCompleto??"";
          String o2 = b.personaUi?.nombreCompleto??"";
          return o1.compareTo(o2);
        });

        int posicion = 0;
        for(RubricaEvalEquipoIntegranteUi equipoUi in rubricaEvaluacionEquipoUi.integrantesUiList??[]){
          if(equipoUi.personaUi!=null){
            posicion++;
            equipoUi.posicion = posicion;
            _rowList2.add(equipoUi);
            newAlumnoCursoList.add(equipoUi.personaUi!);
          }
        }

      }

      List<PersonaUi> alumnoCursoListSingrupo = [];
      alumnoCursoListSingrupo.addAll(_alumnoCursoList);
      for(var item in newAlumnoCursoList){
        alumnoCursoListSingrupo.removeWhere((element) => element.personaId == item.personaId);
      }
      if(alumnoCursoListSingrupo.isNotEmpty){
        RubricaEvaluacionEquipoUi rubricaEvaluacionEquipoUi = RubricaEvaluacionEquipoUi();
        rubricaEvaluacionEquipoUi.orden = (rubricaEvaluacionUi?.equipoUiList?.length??0)+1;
        rubricaEvaluacionEquipoUi.nombreEquipo = "Alumnos sin equipo";
        _rowList2.add(rubricaEvaluacionEquipoUi);
        int posicion = 0;
        for(var item in alumnoCursoListSingrupo){
          posicion++;
          RubricaEvalEquipoIntegranteUi rubricaEvalEquipoIntegranteUi = RubricaEvalEquipoIntegranteUi();
          rubricaEvalEquipoIntegranteUi.personaUi = item;
          rubricaEvalEquipoIntegranteUi.posicion = posicion;
          _rowList2.add(rubricaEvalEquipoIntegranteUi);
          newAlumnoCursoList.add(item);
        }
      }

      print("newAlumnoCursoList");
      _alumnoCursoList.clear(); //Se modifica el orden de la lista
      _alumnoCursoList.addAll(newAlumnoCursoList);

      //neri.moreno
      //inicia 3
      //matias
      //asistencia
      //

    }else{
      _rowList2.addAll(alumnoCursoList);
    }

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
      dynamic? evaluacionUiCabecera = null;
      //#obtner Nota Tatal
      if (row is PersonaUi || row is RubricaEvalEquipoIntegranteUi) {
        RubricaEvalEquipoIntegranteUi? rubricaEvalEquipoIntegranteUi = null;
        if(row is RubricaEvalEquipoIntegranteUi){
          rubricaEvalEquipoIntegranteUi = row;
          row = row.personaUi;
        }

        evaluacionUiCabecera = rubricaEvaluacionUi?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == row.personaId);
        if (evaluacionUiCabecera == null){
          evaluacionUiCabecera = EvaluacionUi(); //Una evaluacion vasia significa que el foto_alumno no tiene evaluacion
          evaluacionUiCabecera.rubroEvaluacionUi = rubricaEvaluacionUi;
          evaluacionUiCabecera.rubroEvaluacionId = rubricaEvaluacionUi?.rubroEvaluacionId;
          row.soloApareceEnElCurso = true;
          evaluacionUiCabecera.alumnoId = row.personaId;
          rubricaEvaluacionUi?.evaluacionUiList?.add(evaluacionUiCabecera);
        }
        evaluacionUiCabecera.personaUi = row; //se remplasa la persona con la lista de foto_alumno del carga_curso por que contiene informacion de vigencia
        evaluacionUiCabecera.equipoId = rubricaEvalEquipoIntegranteUi?.rubricaEvaluacionEquipoUi?.equipoId;
        //cellList.add(evaluacionUiCabecera);
        evaluacionPublicadoUi = EvaluacionPublicadoUi(evaluacionUiCabecera);

        //Comprobar si el detalle tiene tiene evaluacion
        for (RubricaEvaluacionUi rubricaEvaluacionUiDetalle in rubricaEvaluacionUi?.rubrosDetalleList ?? []) {
          EvaluacionUi? evaluacionUiDetalle = rubricaEvaluacionUiDetalle.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == row.personaId);
          if(evaluacionUiDetalle==null){
            evaluacionUiDetalle = EvaluacionUi();
            evaluacionUiDetalle.rubroEvaluacionUi = rubricaEvaluacionUiDetalle;
            evaluacionUiDetalle.rubroEvaluacionId = rubricaEvaluacionUiDetalle.rubroEvaluacionId;
            evaluacionUiDetalle.alumnoId = row.personaId;
            row.soloApareceEnElCurso = true;
            rubricaEvaluacionUiDetalle.evaluacionUiList?.add(evaluacionUiDetalle);
          }
          evaluacionUiDetalle.personaUi = row;
        }

      }else if(row is RubricaEvaluacionEquipoUi){
        evaluacionUiCabecera = row.evaluacionEquipoUi??EvaluacionEquipoUi();
      } else {
        cellList.add(""); //Espacio
      }

      //#obtner Nota RubroDetalle
      for (RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUi?.rubrosDetalleList ?? []) {
        if (row is PersonaUi || row is RubricaEvalEquipoIntegranteUi) {
          RubricaEvalEquipoIntegranteUi? rubricaEvalEquipoIntegranteUi = null;
          if(row is RubricaEvalEquipoIntegranteUi){
            rubricaEvalEquipoIntegranteUi = row;
            row = row.personaUi;
          }

          EvaluacionUi? evaluacionUi = rubricaEvaluacionUi.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == row.personaId);
          if (evaluacionUi == null){
            evaluacionUi = EvaluacionUi(); //Una evaluacion vasia significa que el foto_alumno no tiene evaluacion
            evaluacionUi.rubroEvaluacionUi = rubricaEvaluacionUi;
            evaluacionUi.rubroEvaluacionId = rubricaEvaluacionUi.rubroEvaluacionId;
            evaluacionUi.alumnoId = row.personaId;
            evaluacionUi.equipoId = rubricaEvalEquipoIntegranteUi?.rubricaEvaluacionEquipoUi?.equipoId;
            row.soloApareceEnElCurso = true;
          }
          evaluacionUi.personaUi = row; //se remplasa la persona con la lista de foto_alumno del carga_curso por que contiene informacion de vigencia
          cellList.add(evaluacionUi);
        }else if(row is RubricaEvaluacionEquipoUi){
         
          RubricaEvaluacionEquipoUi? rubricaEvaluacionEquipoUi = rubricaEvaluacionUi.equipoUiList?.firstWhereOrNull(
                  (element) => element.rubricaEvaluacionUi?.rubroEvaluacionId == rubricaEvaluacionUi.rubroEvaluacionId &&
                    element.equipoId == row.equipoId);

          cellList.add(rubricaEvaluacionEquipoUi?.evaluacionEquipoUi??EvaluacionEquipoUi());
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

  void initListaGrupo(RubricaEvaluacionUi? rubroEvaluacionUi) {
    _rubricaEvaluacionEquipoUiList = rubroEvaluacionUi?.equipoUiList??[];
    //_alumnoCursoListDesordenado.clear();
    //_alumnoCursoListDesordenado.addAll(alumnoCursoList);
    _mapColumnEquipoList.clear();
    _mapRowEquipoList.clear();
    _mapCellListEquipoList.clear();




    for(RubricaEvaluacionEquipoUi rubricaEvaluacionEquipoUi in rubroEvaluacionUi?.equipoUiList??[]){

      _mapColumnEquipoList[rubricaEvaluacionEquipoUi.equipoId] = [];
      _mapRowEquipoList[rubricaEvaluacionEquipoUi.equipoId] = [];
      _mapCellListEquipoList[rubricaEvaluacionEquipoUi.equipoId] = [];

      _mapRowEquipoList[rubricaEvaluacionEquipoUi.equipoId]?.addAll(rubroEvaluacionUi?.rubrosDetalleList??[]);

      //_mapColumnList[personaUi]?.add(RubricaEvaluacionUi());
      TipoNotaUi? tipoNotaUi = null;
      if(rubroEvaluacionUi?.rubrosDetalleList?.isNotEmpty??false){
        tipoNotaUi = rubroEvaluacionUi?.rubrosDetalleList?[0].tipoNotaUi;
      }
//      tipoNotaUi?.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_NUMERICO;
      if(tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS || tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
        _mapColumnEquipoList[rubricaEvaluacionEquipoUi.equipoId]?.addAll(tipoNotaUi?.valorTipoNotaList??[]);
      }else{
        _mapColumnEquipoList[rubricaEvaluacionEquipoUi.equipoId]?.add(RubricaEvaluacionEquipoUi());//Teclado numerico
      }
      //_mapColumnList[personaUi]?.add(RubricaEvaluacionFormulaPesoUi(RubricaEvaluacionUi()));//peso_criterio

      for(RubricaEvaluacionUi row in _mapRowEquipoList[rubricaEvaluacionEquipoUi.equipoId]??[]){
        List<dynamic> cellList = [];
        //cellList.add(row);
        //print("search: ${rubricaEvaluacionEquipoUi.equipoId}");
        RubricaEvaluacionEquipoUi? search = row.equipoUiList?.firstWhereOrNull(
                (element) => element.rubricaEvaluacionUi?.rubroEvaluacionId == row.rubroEvaluacionId &&
                element.equipoId == rubricaEvaluacionEquipoUi.equipoId);
        //print("search: ${search?.rubroEvaluacionEquipoId}");
        if(tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS || tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
          for(ValorTipoNotaUi valorTipoNotaUi in tipoNotaUi?.valorTipoNotaList??[]){
            EvaluacionRubricaGrupoValorTipoNotaUi evaluacionRubricaGrupoValorTipoNotaUi = EvaluacionRubricaGrupoValorTipoNotaUi();
            evaluacionRubricaGrupoValorTipoNotaUi.valorTipoNotaUi = valorTipoNotaUi;
            evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi = search;
            evaluacionRubricaGrupoValorTipoNotaUi.toggle = valorTipoNotaUi.valorTipoNotaId == search?.evaluacionEquipoUi?.valorTipoNotaUi?.valorTipoNotaId;
            evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionUi = row;
            cellList.add(evaluacionRubricaGrupoValorTipoNotaUi);
          }
        }else{
          RubricaEvaluacionEquipoUi? search = row.equipoUiList?.firstWhereOrNull(
                  (element) => element.rubricaEvaluacionUi?.rubroEvaluacionId == row.rubroEvaluacionId &&
                  element.equipoId == rubricaEvaluacionEquipoUi.equipoId);

          cellList.add(search);
        }
        //RubricaEvaluacionFormulaPesoUi pesoUi = RubricaEvaluacionFormulaPesoUi(row);
        //cellList.add(pesoUi);
        _mapCellListEquipoList[rubricaEvaluacionEquipoUi.equipoId]?.add(cellList);
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

  RubricaEvaluacionEquipoUi? getEvaluacionGeneralEquipo(RubricaEvaluacionEquipoUi? rubricaEvaluacionEquipoUi) {

    RubricaEvaluacionEquipoUi? search = null;
    for(RubricaEvaluacionEquipoUi item in rubroEvaluacionUi?.equipoUiList??[]){
      if(item.equipoId == rubricaEvaluacionEquipoUi?.equipoId){
        search = item;
      }
    }

    return search;
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

  void comprobarButtomEquipo() {
    int size = _rubricaEvaluacionEquipoUiList.length;
    int count = _rubricaEvaluacionEquipoUiList.indexWhere((element) => element.equipoId == _rubricaEvaluacionEquipoUiSelected?.equipoId);
    print("_rubricaEvaluacionEquipoUiSelected ${_rubricaEvaluacionEquipoUiSelected?.equipoId}");
    print("count ${count} size ${size}");
    _atrasGrupo =  count != 0;
    _siguienteGrupo = (size-1) != count;
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

  void saveComentario(String? comentario, EvaluacionUi? evaluacionUi) async{
    RubroComentarioUi rubroComentarioUi = RubroComentarioUi();
    rubroComentarioUi.comentario = comentario;
    rubroComentarioUi.rubroEvaluacionId = evaluacionUi?.rubroEvaluacionId;
    rubroComentarioUi.evaluacionId = evaluacionUi?.evaluacionId;
    rubroComentarioUi.evaluacionRubroComentarioId = IdGenerator.generateId();
    evaluacionUi?.comentarios?.add(rubroComentarioUi);
    refreshUI();
    await presenter.uploadComentario(rubroComentarioUi, evaluacionUi);
    _modificado = true;
  }

  void eliminarComentario(RubroComentarioUi? rubroComentarioUi, EvaluacionUi? evaluacionUi)async {
    rubroComentarioUi?.eliminar = true;
    if(rubroComentarioUi!=null)evaluacionUi?.comentarios?.remove(rubroComentarioUi);
    refreshUI();
    await presenter.uploadComentario(rubroComentarioUi, evaluacionUi);
    _modificado = true;
  }

  void addEvidencia(List<File?> files, String? newName) async {
    for(File? file in files){
      if(file!=null){
        RubroEvidenciaUi rubroEvidenciaUi = RubroEvidenciaUi();
        rubroEvidenciaUi.archivoRubroId = IdGenerator.generateId();
        rubroEvidenciaUi.rubroEvaluacionId = _evaluacionGeneralUiSelect?.rubroEvaluacionId;
        rubroEvidenciaUi.evaluacionUi = _evaluacionGeneralUiSelect;
        rubroEvidenciaUi.titulo = newName??basename(file.path);
        rubroEvidenciaUi.tipoRecurso = DomainTools.getType(file.path);
        rubroEvidenciaUi.file = file;
        _evaluacionGeneralUiSelect?.evidencias?.add(rubroEvidenciaUi);

        HttpStream? httpStream = await presenter.uploadEvidencia(rubroEvidenciaUi, cursosUi);
        mapRubroEvidencia[rubroEvidenciaUi] = httpStream;
      }
      refreshUI();
      _modificado = true;
    }


  }

  void removeRubroEvidencia(RubroEvidenciaUi rubroEvidenciaUi, EvaluacionUi? evaluacionUi) {
    if(rubroEvidenciaUi.success == null){
      if(mapRubroEvidencia.containsKey(rubroEvidenciaUi)){
        HttpStream? httpStream = mapRubroEvidencia[rubroEvidenciaUi];
        httpStream?.cancel();
        mapRubroEvidencia.remove(rubroEvidenciaUi);
      }
    }
    evaluacionUi?.evidencias?.remove(rubroEvidenciaUi);
    rubroEvidenciaUi.eliminar = true;
    presenter.saveRubroEvidenciaUi(rubroEvidenciaUi);
    refreshUI();
    _modificado = true;
  }

  @override
  void dispose() {
    mapRubroEvidencia.forEach((key, value) {
      if(!(key.success??false)){
        key.evaluacionUi?.evidencias?.remove(key);
      }
      value?.cancel();
    });
    presenter.dispose();
    super.dispose();
  }

  void refreshRubroEvidenciaUi(RubroEvidenciaUi rubroEvidenciaUi) async{
    rubroEvidenciaUi.progress = null;
    rubroEvidenciaUi.success = null;
    HttpStream? httpStream = await presenter.uploadEvidencia(rubroEvidenciaUi, cursosUi);
    mapRubroEvidencia[rubroEvidenciaUi] = httpStream;
  }

  void onSelectedEvaluacionGeneral(EvaluacionUi? evaluacionGeneralUi) {
    _evaluacionGeneralUiSelect = evaluacionGeneralUi;
  }

  void onClicEvaluacionRubricaEquipo(EvaluacionEquipoUi evaluacionEquipoUi) {
    print("${evaluacionEquipoUi.equipoEvaluacionProcesoId}");
    _rubricaEvaluacionEquipoUiSelected = evaluacionEquipoUi.rubricaEvaluacionEquipoUi;
    comprobarButtomEquipo();
    refreshUI();
  }

  void onClickFinalizarEvalEquipo() {
    _rubricaEvaluacionEquipoUiSelected = null;
    refreshUI();
  }

  void onClickAtrasEvalEquipo() {
    int count = _rubricaEvaluacionEquipoUiList.indexWhere((element) => element.equipoId == _rubricaEvaluacionEquipoUiSelected?.equipoId);
    _rubricaEvaluacionEquipoUiSelected = _rubricaEvaluacionEquipoUiList[count-1];
    comprobarButtomEquipo();
    refreshUI();
  }

  void onClickSiguienteEvalEquipo() {
    int count = _rubricaEvaluacionEquipoUiList.indexWhere((element) => element.equipoId == _rubricaEvaluacionEquipoUiSelected?.equipoId);
    print("count ${count}");
    _rubricaEvaluacionEquipoUiSelected = _rubricaEvaluacionEquipoUiList[count+1];
    comprobarButtomEquipo();
    refreshUI();
  }

  RubricaEvaluacionEquipoUi? getRubricaEvaluacionEquipoUiCabecera(EvaluacionUi? evaluacionUi){
    return rubroEvaluacionUi?.equipoUiList?.firstWhereOrNull((element) => element.equipoId == evaluacionUi?.equipoId);
  }

  void onClicEvaluarEquipo(EvaluacionRubricaGrupoValorTipoNotaUi evaluacionRubricaGrupoValorTipoNotaUi, RubricaEvaluacionEquipoUi? rubricaEvaluacionEquipoUi) {
    if(isCalendarioDesactivo())return;
    for (List cellList in mapCellListEquipoList[rubricaEvaluacionEquipoUi?.equipoId] ?? []) {
      for (var cell in cellList) {
        if (cell is EvaluacionRubricaGrupoValorTipoNotaUi) {
          if (cell.rubricaEvaluacionEquipoUi?.rubroEvaluacionEquipoId == evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.rubroEvaluacionEquipoId
              && cell.valorTipoNotaUi?.valorTipoNotaId != evaluacionRubricaGrupoValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId) {
            cell.toggle = false;
          }
        }
      }
    }

    evaluacionRubricaGrupoValorTipoNotaUi.toggle = !(evaluacionRubricaGrupoValorTipoNotaUi.toggle ?? false);
    if(evaluacionRubricaGrupoValorTipoNotaUi.toggle??false){
      evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.nota = evaluacionRubricaGrupoValorTipoNotaUi.valorTipoNotaUi?.valorNumerico;
      evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi = evaluacionRubricaGrupoValorTipoNotaUi.valorTipoNotaUi;
    }else{
      evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.nota = 0.0;
      evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi = null;
    }


    for(RubricaEvalEquipoIntegranteUi integranteUi in rubricaEvaluacionEquipoUi?.integrantesUiList??[]){
      PersonaUi? personaUi = alumnoCursoList.firstWhereOrNull((element) => element.personaId == integranteUi.personaId);
      if(personaUi?.contratoVigente??false){
        for (List cellList in mapCellListList[personaUi] ?? []) {
          for (var cell in cellList) {
            if (cell is EvaluacionRubricaValorTipoNotaUi) {
              if (cell.evaluacionUi?.alumnoId == integranteUi.personaId
                  && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionUi?.rubroEvaluacionId
                  && cell.valorTipoNotaUi?.valorTipoNotaId != evaluacionRubricaGrupoValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId) {
                cell.toggle = false;
              }else if(cell.evaluacionUi?.alumnoId == integranteUi.personaId
                  && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionUi?.rubroEvaluacionId
                  && cell.valorTipoNotaUi?.valorTipoNotaId == evaluacionRubricaGrupoValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId){
                cell.toggle = evaluacionRubricaGrupoValorTipoNotaUi.toggle;
                cell.evaluacionUi?.nota = evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi?.valorNumerico;
                cell.evaluacionUi?.valorTipoNotaId =  evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi?.valorTipoNotaId;
                cell.evaluacionUi?.valorTipoNotaUi = evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi;

              }
            }
          }
        }
      }

      if(personaUi!=null){
        _actualizarCabecera(personaUi);
        presenter.updateEvaluacion(rubroEvaluacionUi, personaUi.personaId);
      }
    }


    _actualizarCabeceraEquipo(rubricaEvaluacionEquipoUi);
    _modificado = true;
    refreshUI();

    presenter.updateEvaluacionEquipo(rubroEvaluacionUi, rubricaEvaluacionEquipoUi?.equipoId);
  }

  void _actualizarCabeceraEquipo(RubricaEvaluacionEquipoUi? rubricaEvaluacionEquipoUi) {
    CalcularEvaluacionProceso.actualizarCabeceraEquipo(rubroEvaluacionUi, rubricaEvaluacionEquipoUi);
    refreshUI();
  }

  void onClicEvaluarPresicionEquipo(EvaluacionRubricaGrupoValorTipoNotaUi evaluacionRubricaGrupoValorTipoNotaUi, nota) {
    ValorTipoNotaUi? valorTipoNotaUi = TransformarValoTipoNota.getValorTipoNota(evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi, nota);

    for (List cellList in _mapCellListEquipoList[evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.equipoId]??[]) {
      for (var cell in cellList) {

        if (cell is EvaluacionRubricaGrupoValorTipoNotaUi) {

          if (cell.rubricaEvaluacionEquipoUi?.rubroEvaluacionEquipoId == evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.rubroEvaluacionEquipoId
              && cell.valorTipoNotaUi?.valorTipoNotaId == valorTipoNotaUi?.valorTipoNotaId) {
            cell.toggle = true;
          }

          if (cell.rubricaEvaluacionEquipoUi?.rubroEvaluacionEquipoId == evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.rubroEvaluacionEquipoId
              && cell.valorTipoNotaUi?.valorTipoNotaId != valorTipoNotaUi?.valorTipoNotaId) {
            cell.toggle = false;
          }

        }
      }
    }

    //evaluacionRubricaValorTipoNotaUi.toggle = true;
    evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.nota = nota;
    evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi = evaluacionRubricaGrupoValorTipoNotaUi.valorTipoNotaUi;


    for(RubricaEvalEquipoIntegranteUi integranteUi in evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.integrantesUiList??[]){
      PersonaUi? personaUi = alumnoCursoList.firstWhereOrNull((element) => element.personaId == integranteUi.personaId);
      if(personaUi?.contratoVigente??false){
        for (List cellList in mapCellListList[personaUi] ?? []) {
          for (var cell in cellList) {
            if (cell is EvaluacionRubricaValorTipoNotaUi) {
              if (cell.evaluacionUi?.alumnoId == integranteUi.personaId
                  && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionUi?.rubroEvaluacionId
                  && cell.valorTipoNotaUi?.valorTipoNotaId != valorTipoNotaUi?.valorTipoNotaId) {
                cell.toggle = false;
              }else if(cell.evaluacionUi?.alumnoId == integranteUi.personaId
                  && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionUi?.rubroEvaluacionId
                  && cell.valorTipoNotaUi?.valorTipoNotaId == valorTipoNotaUi?.valorTipoNotaId){
                cell.toggle = true;
                cell.evaluacionUi?.nota = nota;
                cell.evaluacionUi?.valorTipoNotaId =  evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi?.valorTipoNotaId;
                cell.evaluacionUi?.valorTipoNotaUi = evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi;

              }
            }
          }
        }
      }

      if(personaUi!=null){
        _actualizarCabecera(personaUi);
        presenter.updateEvaluacion(rubroEvaluacionUi, personaUi.personaId);
      }
    }


    _actualizarCabeceraEquipo(evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi);
    _modificado = true;
    refreshUI();

    presenter.updateEvaluacionEquipo(rubroEvaluacionUi, evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.equipoId);
  }

  void onSaveTecladoPresicionEquipo(nota, RubricaEvaluacionEquipoUi? rubricaEvaluacionEquipoUi) {
    ValorTipoNotaUi? valorTipoNotaUi = TransformarValoTipoNota.getValorTipoNota(rubricaEvaluacionEquipoUi?.rubricaEvaluacionUi?.tipoNotaUi, nota);
    print("onSaveTecladoPresicionEquipo ${valorTipoNotaUi?.valorTipoNotaId}");
    for (List cellList in _mapCellListEquipoList[rubricaEvaluacionEquipoUi?.equipoId]??[]) {
      for (var cell in cellList) {

        if (cell is EvaluacionRubricaGrupoValorTipoNotaUi) {

          if (cell.rubricaEvaluacionEquipoUi?.rubroEvaluacionEquipoId ==  rubricaEvaluacionEquipoUi?.rubroEvaluacionEquipoId
              && cell.valorTipoNotaUi?.valorTipoNotaId == valorTipoNotaUi?.valorTipoNotaId) {
            cell.toggle = true;
          }

          if (cell.rubricaEvaluacionEquipoUi?.rubroEvaluacionEquipoId == rubricaEvaluacionEquipoUi?.rubroEvaluacionEquipoId
              && cell.valorTipoNotaUi?.valorTipoNotaId != valorTipoNotaUi?.valorTipoNotaId) {
            cell.toggle = false;
          }

        }
      }
    }

    //evaluacionRubricaValorTipoNotaUi.toggle = true;
    rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.nota = nota;
    rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi = valorTipoNotaUi;


    for(RubricaEvalEquipoIntegranteUi integranteUi in rubricaEvaluacionEquipoUi?.integrantesUiList??[]){
      PersonaUi? personaUi = alumnoCursoList.firstWhereOrNull((element) => element.personaId == integranteUi.personaId);
      if(personaUi?.contratoVigente??false){
        for (List cellList in mapCellListList[personaUi] ?? []) {
          for (var cell in cellList) {
            if (cell is EvaluacionRubricaValorTipoNotaUi) {
              if (cell.evaluacionUi?.alumnoId == integranteUi.personaId
                  && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == rubricaEvaluacionEquipoUi?.rubricaEvaluacionUi?.rubroEvaluacionId
                  && cell.valorTipoNotaUi?.valorTipoNotaId != valorTipoNotaUi?.valorTipoNotaId) {
                cell.toggle = false;
              }else if(cell.evaluacionUi?.alumnoId == integranteUi.personaId
                  && cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == rubricaEvaluacionEquipoUi?.rubricaEvaluacionUi?.rubroEvaluacionId
                  && cell.valorTipoNotaUi?.valorTipoNotaId == valorTipoNotaUi?.valorTipoNotaId){
                cell.toggle = true;
                cell.evaluacionUi?.nota = nota;
                cell.evaluacionUi?.valorTipoNotaId =  rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi?.valorTipoNotaId;
                cell.evaluacionUi?.valorTipoNotaUi =  rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi;

              }
            }else if(cell is EvaluacionUi){

              if (cell.alumnoId == integranteUi.personaId
                  && cell.rubroEvaluacionUi?.rubroEvaluacionId == rubricaEvaluacionEquipoUi?.rubricaEvaluacionUi?.rubroEvaluacionId) {
                    cell.nota = nota;
                    cell.valorTipoNotaUi =  rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi;
              }

            }else{

            }
          }
        }
      }

      if(personaUi!=null){
        _actualizarCabecera(personaUi);
        presenter.updateEvaluacion(rubroEvaluacionUi, personaUi.personaId);
      }
    }

    _actualizarCabeceraEquipo(rubricaEvaluacionEquipoUi);
    _modificado = true;
    refreshUI();

    presenter.updateEvaluacionEquipo(rubroEvaluacionUi, rubricaEvaluacionEquipoUi?.equipoId);
  }

  void respuestaFormularioCrearRubro() {
    //print("respuestaFormularioCrearRubro");
    //presenter.getRubroEvaluacion(rubroEvaluacionId, cursosUi);
    _modificado = true;
    refreshUI();
  }

  onClicClearEvaluacionAllEquipo(ValorTipoNotaUi valorTipoNotaUi, RubricaEvaluacionEquipoUi? rubricaEvaluacionEquipoUi) {
    if(isCalendarioDesactivo())return;
    for(List cellList in mapCellListEquipoList[rubricaEvaluacionEquipoUi?.equipoId]??[]){
      for(var cell in cellList){
        if(cell is EvaluacionRubricaGrupoValorTipoNotaUi){
          cell.toggle = false;
          cell.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.nota = 0.0;
          cell.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi = null;
        }
      }
    }

    for(RubricaEvalEquipoIntegranteUi integranteUi in rubricaEvaluacionEquipoUi?.integrantesUiList??[]){
      PersonaUi? personaUi = alumnoCursoList.firstWhereOrNull((element) => element.personaId == integranteUi.personaId);
      if(personaUi?.contratoVigente??false){
        for(List cellList in mapCellListList[personaUi]??[]){
          for(var cell in cellList){
            if(cell is EvaluacionRubricaValorTipoNotaUi){
              cell.toggle = false;
              cell.evaluacionUi?.nota = 0.0;
              cell.evaluacionUi?.valorTipoNotaId = null;
              cell.evaluacionUi?.valorTipoNotaUi = null;
            }
          }
          _actualizarCabecera(personaUi);
        }
      }

    }
    _actualizarCabeceraEquipo(rubricaEvaluacionEquipoUi);
    _modificado = true;
    refreshUI();
    presenter.updateEvaluacionEquipo(rubroEvaluacionUi, rubricaEvaluacionEquipoUi?.equipoId);
    presenter.updateEvaluacionAll(rubroEvaluacionUi);
  }

  onClicEvaluacionAllEquipo(ValorTipoNotaUi valorTipoNotaUi, RubricaEvaluacionEquipoUi? rubricaEvaluacionEquipoUi) {
    if(isCalendarioDesactivo())return;
    for(List cellList in mapCellListEquipoList[rubricaEvaluacionEquipoUi?.equipoId]??[]){
      for(var cell in cellList){
        if(cell is EvaluacionRubricaGrupoValorTipoNotaUi){
          if(cell.rubricaEvaluacionEquipoUi?.equipoId ==  rubricaEvaluacionEquipoUi?.equipoId
              &&  cell.valorTipoNotaUi?.valorTipoNotaId == valorTipoNotaUi.valorTipoNotaId){
            cell.toggle = true;
            cell.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.nota = valorTipoNotaUi.valorNumerico;//actualizar la nota solo cuando no esta selecionado
            cell.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi = valorTipoNotaUi;
          }else{
            cell.toggle = false;
          }
        }
      }
    }

    for(RubricaEvalEquipoIntegranteUi integranteUi in rubricaEvaluacionEquipoUi?.integrantesUiList??[]){
      PersonaUi? personaUi = alumnoCursoList.firstWhereOrNull((element) => element.personaId == integranteUi.personaId);
      if(personaUi?.contratoVigente??false){
        for(List cellList in mapCellListList[personaUi]??[]){
          for(var cell in cellList){
            if(cell is EvaluacionRubricaValorTipoNotaUi){
              if(cell.evaluacionUi?.personaUi?.personaId == personaUi?.personaId
                  && cell.valorTipoNotaUi?.valorTipoNotaId == valorTipoNotaUi.valorTipoNotaId){
                cell.toggle = true;
                cell.evaluacionUi?.nota = valorTipoNotaUi.valorNumerico;//actualizar la nota solo cuando no esta selecionado
                cell.evaluacionUi?.valorTipoNotaId = valorTipoNotaUi.valorTipoNotaId;
                cell.evaluacionUi?.valorTipoNotaUi = valorTipoNotaUi;
              }else{
                cell.toggle = false;
              }

            }
          }
          _actualizarCabecera(personaUi);
        }
      }

    }
    _actualizarCabeceraEquipo(rubricaEvaluacionEquipoUi);
    _modificado = true;
    refreshUI();
    presenter.updateEvaluacionEquipo(rubroEvaluacionUi, rubricaEvaluacionEquipoUi?.equipoId);
    presenter.updateEvaluacionAll(rubroEvaluacionUi);
  }

}