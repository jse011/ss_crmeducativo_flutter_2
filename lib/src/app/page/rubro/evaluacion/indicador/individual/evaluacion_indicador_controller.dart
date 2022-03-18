import 'dart:io';

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
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_comentario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_evidencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/calcular_evaluacion_proceso.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/id_generator.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/transformar_valor_tipo_nota.dart';
import 'package:path/path.dart';

class EvaluacionIndicadorController extends Controller{
  int? position;
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
  RubricaEvaluacionUi? rubroEvaluacionUi;
  RubricaEvaluacionUi? rubricaEvaluacionUiCebecera2;
  EvaluacionUi? _evaluacionUiSelected = null;
  EvaluacionUi? get evaluacionUiSelected => _evaluacionUiSelected;
  UsuarioUi? _usuarioUi = null;
  UsuarioUi? get usuarioUi  => _usuarioUi;
  bool _showDialogComentario = false;
  bool get showDialogComentario => _showDialogComentario;
  Map<RubroEvidenciaUi, HttpStream?> mapRubroEvidencia = Map();

  EvaluacionIndicadorController(RubricaEvaluacionUi? rubroEvaluacionUi, this.cursosUi, this.calendarioPeriodoUI, rubroRepo, configuracionRepo, httpDatosRepo)
      : presenter = EvaluacionIndicadorPresenter(rubroRepo, configuracionRepo, httpDatosRepo),
        this.position = rubroEvaluacionUi?.position,
        this.rubroEvaluacionId = rubroEvaluacionUi?.rubroEvaluacionId;

  @override
  void initListeners() {
    this.rubroEvaluacionUi = null;
    this.rubricaEvaluacionUiCebecera2 = null;

    presenter.getRubroEvaluacionOnError = (e){

    };

    presenter.getRubroEvaluacionOnNext = (RubricaEvaluacionUi? rubroEvaluacionUi, List<PersonaUi> alumnoCursoList,){
      initTable(alumnoCursoList, rubroEvaluacionUi);
      refreshUI();
    };

    presenter.getSessionUsuarioOnNext = (UsuarioUi usuarioUi){
      _usuarioUi = usuarioUi;
      refreshUI();
    };

    presenter.getSessionUsuarioOnError = (e) {
      _usuarioUi = null;
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
    presenter.getRubroEvaluacion(rubroEvaluacionId, cursosUi);
    presenter.getSessionUsuario();

  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onDisposed() {
    presenter.dispose();
    super.onDisposed();
  }

  void initTable(List<PersonaUi> alumnoCursoList, RubricaEvaluacionUi? rubroEvaluacionUi){
    this.rubroEvaluacionUi = rubroEvaluacionUi;

     if((rubroEvaluacionUi?.rubrosDetalleList?.isNotEmpty??false)){
       this.rubricaEvaluacionUiCebecera2 = rubroEvaluacionUi?.rubrosDetalleList?[0];//Agregar el detalle
     }else{
       this.rubricaEvaluacionUiCebecera2 = rubroEvaluacionUi;
     }


    _rowList2.clear();
    _cellListList.clear();
    _columnList2.clear();

    _rowList2.addAll(alumnoCursoList);
    _rowList2.add("");//Espacio
    _rowList2.add("");//Espacio
    _rowList2.add("");//Espacio

    _columnList2.add(ContactoUi());//Titulo foto_alumno

    print("tipoNotaUi ${rubroEvaluacionUi?.tipoNotaUi?.nombre}");
    //rubricaEvaluacionUiCebecera2?.tipoNotaUi?.tipoNotaTiposUi = TipoNotaTiposUi.VALOR_NUMERICO;
    //rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi = TipoNotaTiposUi.VALOR_NUMERICO;
    if(rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS||rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
      _columnList2.addAll(rubroEvaluacionUi?.tipoNotaUi?.valorTipoNotaList??[]);
      print("tipoNotaUi 1 ${rubroEvaluacionUi?.tipoNotaUi?.nombre}");
    }else {
      _columnList2.add(EvaluacionUi());//Notas de tipo Numerico
      print("tipoNotaUi 2 ${rubroEvaluacionUi?.tipoNotaUi?.nombre}");
    }

    _columnList2.add("comentario");
   _columnList2.add(EvaluacionPublicadoUi(EvaluacionUi()));

   _columnList2.add("");// espacio

    for(dynamic row in _rowList2){
      List<dynamic>  cellList = [];
      cellList.add(row);

      //#obtner Nota Tatal
      if(row is PersonaUi){

        //Comprobar si la cabecera tiene tiene evaluacion
        EvaluacionUi? evaluacionUiCabecera = this.rubricaEvaluacionUiCebecera2?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == row.personaId);
        if(evaluacionUiCabecera==null){
          evaluacionUiCabecera = EvaluacionUi();
          evaluacionUiCabecera.rubroEvaluacionUi = rubricaEvaluacionUiCebecera2;
          evaluacionUiCabecera.rubroEvaluacionId = rubricaEvaluacionUiCebecera2?.rubroEvaluacionId;
          evaluacionUiCabecera.alumnoId = row.personaId;
          row.soloApareceEnElCurso = true;
          this.rubricaEvaluacionUiCebecera2?.evaluacionUiList?.add(evaluacionUiCabecera);
        }
        evaluacionUiCabecera.personaUi = row;

        EvaluacionUi? evaluacionUi = rubricaEvaluacionUiCebecera2?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == row.personaId);
        //Una evaluacion vasia significa que el foto_alumno no tiene evaluacion
        if(evaluacionUi==null){
          evaluacionUi = EvaluacionUi();
          row.soloApareceEnElCurso = true;
          evaluacionUi.rubroEvaluacionUi = rubricaEvaluacionUiCebecera2;
          evaluacionUi.rubroEvaluacionId = rubricaEvaluacionUiCebecera2?.rubroEvaluacionId;
          evaluacionUi.alumnoId = row.personaId;
          rubroEvaluacionUi?.evaluacionUiList?.add(evaluacionUi);
        }
        evaluacionUi.personaUi = row;//se remplasa la persona con la lista de foto_alumno del carga_curso por que contiene informacion de vigencia


        if(rubricaEvaluacionUiCebecera2?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS||rubricaEvaluacionUiCebecera2?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){

          for (ValorTipoNotaUi valorTipoNotaUi in rubricaEvaluacionUiCebecera2?.tipoNotaUi?.valorTipoNotaList??[]) {
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
        RubroEvidenciaUi rubroEvidenciaUi = RubroEvidenciaUi();
        rubroEvidenciaUi.evaluacionUi = evaluacionUi;
        cellList.add(rubroEvidenciaUi);

        cellList.add(EvaluacionPublicadoUi(evaluacionUi));//
      }else{
        if(rubricaEvaluacionUiCebecera2?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS||rubricaEvaluacionUiCebecera2?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
          for (ValorTipoNotaUi valorTipoNotaUi in rubricaEvaluacionUiCebecera2?.tipoNotaUi?.valorTipoNotaList??[]) {
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
    if(isCalendarioDesactivo())return;
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
    presenter.updateEvaluacion(rubroEvaluacionUi, evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId);
  }

  void onClicEvaluarPresicion(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, double nota) {
    if(isCalendarioDesactivo())return;
    ValorTipoNotaUi? valorTipoNotaUi = TransformarValoTipoNota.getValorTipoNota(evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi, nota);
      print("valorTipoNotaUi: ${valorTipoNotaUi?.titulo}");

      for (List cellList in _cellListList) {
        for (var cell in cellList) {
          if (cell is EvaluacionRubricaValorTipoNotaUi) {

            if (cell.evaluacionUi?.alumnoId == evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId
                //&& cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.rubroEvaluacionId
                && cell.valorTipoNotaUi?.valorTipoNotaId == valorTipoNotaUi?.valorTipoNotaId) {
              cell.toggle = true;
            }

            if (cell.evaluacionUi?.alumnoId == evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId
                //&& cell.evaluacionUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.rubroEvaluacionId
                && cell.valorTipoNotaUi?.valorTipoNotaId != valorTipoNotaUi?.valorTipoNotaId) {
              cell.toggle = false;
            }

          }
        }
      }

    evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota = nota;//actualizar la nota solo cuando no esta selecionado
    evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaId = valorTipoNotaUi?.valorTipoNotaId;
    evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaUi = valorTipoNotaUi;
    //evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorNumerico;
    refreshUI();
    _modificado = true;
    _actualizarCabecera(evaluacionRubricaValorTipoNotaUi.evaluacionUi?.personaUi);
    presenter.updateEvaluacion(rubroEvaluacionUi, evaluacionRubricaValorTipoNotaUi.evaluacionUi?.alumnoId);
  }

  onClicPrecision() {
      this._precision = !_precision;
      refreshUI();
  }

  onClicEvaluacionAll(ValorTipoNotaUi valorTipoNotaUi) {
    if(isCalendarioDesactivo())return;
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
    presenter.updateEvaluacionAll(rubroEvaluacionUi);
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
    //if(isCalendarioDesactivo())return;
      evaluacionPublicadoUi.publicado = !evaluacionPublicadoUi.publicado;
      showTodosPublicados();
      refreshUI();
      _modificado = true;
      presenter.updateEvaluacion(rubroEvaluacionUi, evaluacionPublicadoUi.evaluacionUi?.alumnoId);
  }

  void showTodosPublicados(){
    if(isCalendarioDesactivo())return;
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
    //if(isCalendarioDesactivo())return;
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
    presenter.updateEvaluacionAll(rubroEvaluacionUi);
  }

  void onClickCancelarEliminar() {
    _showDialogEliminar = false;
    refreshUI();
  }

  void onClickEliminar() {
    if(isCalendarioDesactivo())return;
    _showDialogEliminar = true;
    print("rubroEvaluacionUi: ${rubroEvaluacionUi?.rubroEvaluacionId}");
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
    presenter.updateEvaluacionAll(rubroEvaluacionUi);
  }

  onClikShowDialogClearEvaluacion() {
    if(isCalendarioDesactivo())return;
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
    await presenter.deleteRubroEvaluacion(rubroEvaluacionUi);
    await presenter.updateServer(cursosUi, calendarioPeriodoUI ,rubroEvaluacionUi);

  }

  Future<bool?> onSave() async{
    if(_modificado){
      _showDialog = true;
      refreshUI();
      await presenter.updateServer(cursosUi, calendarioPeriodoUI ,rubroEvaluacionUi);
    }

    return _modificado;
  }



  void _actualizarCabecera(PersonaUi? personaUi) {
    if(rubroEvaluacionUi?.rubrosDetalleList?.isNotEmpty??false){
      CalcularEvaluacionProceso.actualizarCabecera(rubroEvaluacionUi, personaUi);
    }
  }

  bool isCalendarioDesactivo() {
    return calendarioPeriodoUI?.habilitadoProceso != 1;
  }

  void onSaveTecladoPresicion(nota, EvaluacionUi? evaluacionUi) {
    if(isCalendarioDesactivo())return;
    if (evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi ==  TipoNotaTiposUi.SELECTOR_VALORES || evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS){
      ValorTipoNotaUi? valorTipoNotaUi = TransformarValoTipoNota.getValorTipoNota(evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi, nota);
      print("valorTipoNotaUi: ${valorTipoNotaUi?.titulo}");
      for (List cellList in _cellListList) {
        for (var cell in cellList) {
          if (cell is EvaluacionRubricaValorTipoNotaUi) {
            if (cell.evaluacionTransformadaUi?.alumnoId == evaluacionUi?.alumnoId
                && cell.evaluacionTransformadaUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionUi?.rubroEvaluacionId
                && cell.valorTipoNotaUi?.valorTipoNotaId == valorTipoNotaUi?.valorTipoNotaId) {
              cell.toggle = true;
            }

            if (cell.evaluacionTransformadaUi?.alumnoId == evaluacionUi?.alumnoId
                && cell.evaluacionTransformadaUi?.rubroEvaluacionUi?.rubroEvaluacionId == evaluacionUi?.rubroEvaluacionId
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

    refreshUI();
    _modificado = true;
    _actualizarCabecera(evaluacionUi?.personaUi);
    presenter.updateEvaluacion(rubroEvaluacionUi, evaluacionUi?.alumnoId);
  }

  void onClickComentario(EvaluacionUi? evaluacionUi) {
    _evaluacionUiSelected = evaluacionUi;
    _showDialogComentario = true;
    refreshUI();
  }

  void onhideDialogComentario() {
    _evaluacionUiSelected = null;
    _showDialogComentario = false;
    refreshUI();
  }

  void saveComentario(String comentario, EvaluacionUi? evaluacionUi) async{
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

  void eliminarComentario(RubroComentarioUi rubroComentarioUi, EvaluacionUi? evaluacionUi) async{
    rubroComentarioUi.eliminar = true;
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
        rubroEvidenciaUi.rubroEvaluacionId = _evaluacionUiSelected?.rubroEvaluacionId;
        rubroEvidenciaUi.evaluacionUi = _evaluacionUiSelected;
        rubroEvidenciaUi.titulo = newName??basename(file.path);
        rubroEvidenciaUi.tipoRecurso = DomainTools.getType(file.path);
        rubroEvidenciaUi.file = file;
        _evaluacionUiSelected?.evidencias?.add(rubroEvidenciaUi);

        HttpStream? httpStream = await presenter.uploadEvidencia(rubroEvidenciaUi, cursosUi);
        mapRubroEvidencia[rubroEvidenciaUi] = httpStream;
      }
      refreshUI();
      _modificado = true;
    }


  }

  void removeRubroEvidencia(RubroEvidenciaUi rubroEvidenciaUi) {
    if(rubroEvidenciaUi.success == null){
      if(mapRubroEvidencia.containsKey(rubroEvidenciaUi)){
        HttpStream? httpStream = mapRubroEvidencia[rubroEvidenciaUi];
        httpStream?.cancel();
        mapRubroEvidencia.remove(rubroEvidenciaUi);
      }
    }
    rubroEvidenciaUi.evaluacionUi?.evidencias?.remove(rubroEvidenciaUi);
    rubroEvidenciaUi.eliminar = true;
    presenter.saveRubroEvidenciaUi(rubroEvidenciaUi);
    refreshUI();
    _modificado = true;
  }

  void refreshRubroEvidenciaUi(RubroEvidenciaUi rubroEvidenciaUi) async{
    rubroEvidenciaUi.progress = null;
    rubroEvidenciaUi.success = null;
    HttpStream? httpStream = await presenter.uploadEvidencia(rubroEvidenciaUi, cursosUi);
    mapRubroEvidencia[rubroEvidenciaUi] = httpStream;
  }

}