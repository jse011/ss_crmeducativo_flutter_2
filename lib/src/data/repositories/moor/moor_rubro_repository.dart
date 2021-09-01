import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/rubro_comentario.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/rubro_update_servidor.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/data_convert.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/estado_sync.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_publicado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/forma_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/app_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/id_generator.dart';


import 'database/app_database.dart';

class MoorRubroRepository extends RubroRepository{
  static const int TN_VALOR_NUMERICO = 410, TN_SELECTOR_NUMERICO = 411, TN_SELECTOR_VALORES = 412, TN_SELECTOR_ICONOS = 409, TN_VALOR_ASISTENCIA= 474;
  static const int COMPETENCIA_BASE = 347, COMPETENCIA_TRANS = 348, COMPETENCIA_ENFQ = 349;
  static const int TIPO_RUBRO_UNIDIMENCIONAL = 470, TIPO_RUBRO_BIMENSIONAL = 471, TIPO_RUBRO_BIDIMENCIONAL_DETALLE = 473;
  static const int FORMA_EVAL_INDIVIDUAL = 477, FORMA_EVAL_GRUPAL = 478;
  static const int ESTADO_ANCLADA=313, ESTADO_EVALUADO=314, ESTADO_CREADO =237, ESTADO_ACTUALIZADO = 239, ESTADO_ELIMINADO = 280;

  @override
  void saveDatosCrearRubros(Map<String, dynamic> crearRubro, int silaboEventoId, int calendarioPeriodoId) async {
    AppDataBase SQL = AppDataBase();
    int anioAcademicoId = 0;
    int  empleadoId = 0;
    await SQL.batch((batch) async {
      // functions in a batch don't have to be awaited - just
      // await the whole batch afterwards.
      if(crearRubro.containsKey("sessionAprendizajeCriterios")||crearRubro.containsKey("unidadAprendizajeCriterios")){
        //&& t.calendarioPeriodoId.equals(calendarioPeriodoId)
        //batch.deleteWhere(SQL.criterio, (Criterio t) => t.silaboEventoId.equals(silaboEventoId));
        var query = SQL.delete(SQL.criterio)..where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
        query.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
        query.go();
      }

      if(crearRubro.containsKey("sessionAprendizajeCriterios")){
        batch.insertAll(SQL.criterio, SerializableConvert.converListSerializeCriterio(crearRubro["sessionAprendizajeCriterios"])  , mode: InsertMode.insertOrReplace );
      }

      if(crearRubro.containsKey("unidadAprendizajeCriterios")){
        batch.insertAll(SQL.criterio, SerializableConvert.converListSerializeCriterio(crearRubro["unidadAprendizajeCriterios"])  , mode: InsertMode.insertOrReplace );
      }

      if(crearRubro.containsKey("crearRubrosOfflinetipos")){
        batch.deleteWhere(SQL.tiposRubro, (row) => const Constant(true));
        batch.insertAll(SQL.tiposRubro, SerializableConvert.converListSerializeTiposRubro(crearRubro["crearRubrosOfflinetipos"])  , mode: InsertMode.insertOrReplace );
      }

      if(crearRubro.containsKey("crearRubrosOfflinetipos_evaluacion")){
        batch.deleteWhere(SQL.tipoEvaluacionRubro, (row) => const Constant(true));
        batch.insertAll(SQL.tipoEvaluacionRubro, SerializableConvert.converListSerializeTipoEvaluacionRubro(crearRubro["crearRubrosOfflinetipos_evaluacion"])  , mode: InsertMode.insertOrReplace );
      }

      if(crearRubro.containsKey("valorTipoNota")){
        batch.deleteWhere(SQL.valorTipoNotaRubro, ($ValorTipoNotaRubroTable row) => Constant(true));
        batch.insertAll(SQL.valorTipoNotaRubro, SerializableConvert.converListSerializeValorTipoNotaRubro(crearRubro["valorTipoNota"]), mode: InsertMode.insertOrReplace);
        batch.insertAll(SQL.valorTipoNotaResultado, SerializableConvert.converListSerializeValorTipoNotaResultado(crearRubro["valorTipoNota"]), mode: InsertMode.insertOrReplace);
      }

      if(crearRubro.containsKey("tipoNotaEscala")){
        batch.deleteWhere(SQL.tipoNotaRubro, (row) => Constant(true));
        batch.insertAll(SQL.tipoNotaRubro, SerializableConvert.converListSerializeTipoNotaRubro(crearRubro["tipoNotaEscala"]), mode: InsertMode.insertOrReplace);
        batch.insertAll(SQL.tipoNotaResultado, SerializableConvert.converListSerializeTipoNotaResultado(crearRubro["tipoNotaEscala"]), mode: InsertMode.insertOrReplace);
      }

    });
  }

  @override
  void saveDatosRubrosEval(Map<String, dynamic> rubro, int silaboEventoId, int calendarioPeriodoId) async {
    AppDataBase SQL = AppDataBase();
    print("saveDatosRubrosEval");
    await SQL.batch((batch) async {

      if(rubro.containsKey("rubroEvaluaciones")){

        var queryRubro = SQL.selectOnly(SQL.rubroEvaluacionProceso)
          ..addColumns([SQL.rubroEvaluacionProceso.rubroEvalProcesoId]);
        queryRubro.where(SQL.rubroEvaluacionProceso.silaboEventoId.equals(silaboEventoId));
        queryRubro.where(SQL.rubroEvaluacionProceso.calendarioPeriodoId.equals(calendarioPeriodoId));
        //queryRubro.where(SQL.rubroEvaluacionProceso.syncFlag.isNotIn([EstadoSync.FLAG_UPDATED, EstadoSync.FLAG_ADDED])); El servidor devuelve los rubros que solo estan en el celular

        var queryEval = SQL.selectOnly(SQL.evaluacionProceso)..addColumns([SQL.evaluacionProceso.evaluacionProcesoId]);
        queryEval.where(SQL.evaluacionProceso.rubroEvalProcesoId.isInQuery(queryRubro));

        (SQL.delete(SQL.evaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.isInQuery(queryRubro))).go();
        (SQL.delete(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.isInQuery(queryRubro))).go();
        (SQL.delete(SQL.rubroComentario)..where((tbl) => tbl.evaluacionProcesoId.isInQuery(queryEval))).go();
        (SQL.delete(SQL.archivoRubro)..where((tbl) => tbl.evaluacionProcesoId.isInQuery(queryEval))).go();
        (SQL.delete(SQL.rubroCampotematico)..where((tbl) => tbl.rubroEvalProcesoId.isInQuery(queryRubro))).go();
        (SQL.delete(SQL.rubroEvalRNPFormula)..where((tbl) => tbl.rubroEvaluacionPrimId.isInQuery(queryRubro))).go();
        //(SQL.delete(SQL.equipoEvaluacion)..where((tbl) => tbl.rubroEvalProcesoId.isInQuery(queryRubro))).go();
        //(SQL.delete(SQL.equipoEvaluacion)..where((tbl) => tbl.rubroEvalProcesoId.isInQuery(queryRubro))).go();
        batch.insertAll(SQL.rubroEvaluacionProceso, SerializableConvert.converListSerializeRubroEvaluacionProceso(rubro["rubroEvaluaciones"]), mode: InsertMode.insertOrReplace );
        batch.insertAll(SQL.evaluacionProceso, SerializableConvert.converListSerializeEvaluacionProceso(rubro["evaluaciones"]), mode: InsertMode.insertOrReplace );
        batch.insertAll(SQL.rubroEvalRNPFormula, SerializableConvert.converListSerializeRubroEvalRNPFormula(rubro["rubroFormulas"]), mode: InsertMode.insertOrReplace );


      }

    });
  }

  @override
  Future<List<FormaEvaluacionUi>> getGetFormaEvaluacion() async {
    AppDataBase SQL = AppDataBase();

    var query = SQL.select(SQL.tiposRubro)..where((tbl) => tbl.concepto.equals("Forma Evaluacion"));
    query.where((tbl) => tbl.objeto.equals("T_RN_MAE_RUBRO_EVALUACION_PROCESO"));
    List<TiposRubroData> formaEvaluacionData =  await query.get();
    List<FormaEvaluacionUi> formaEvaluacionUiList = [];
    for(TiposRubroData tipoRubroData in formaEvaluacionData){
      FormaEvaluacionUi formaEvaluacionUi = FormaEvaluacionUi();
      formaEvaluacionUi.id = tipoRubroData.tipoId;
      formaEvaluacionUi.nombre = tipoRubroData.nombre;
      formaEvaluacionUiList.add(formaEvaluacionUi);
    }
    return formaEvaluacionUiList;
  }

  @override
  Future<List<TipoEvaluacionUi>> getGetTipoEvaluacion() async{
    AppDataBase SQL = AppDataBase();
   List<TipoEvaluacionUi> tipoEvaluacionUiList = [];
    List<TipoEvaluacionRubroData> tipoEvaluacionRubroDataList =  await SQL.select(SQL.tipoEvaluacionRubro).get();
    for(TipoEvaluacionRubroData tipoEvaluacionRubroData in tipoEvaluacionRubroDataList){
      TipoEvaluacionUi tipoEvaluacionUi = TipoEvaluacionUi();
      tipoEvaluacionUi.id= tipoEvaluacionRubroData.tipoEvaluacionId;
      tipoEvaluacionUi.nombre = tipoEvaluacionRubroData.nombre;
      tipoEvaluacionUiList.add(tipoEvaluacionUi);
    }
    return tipoEvaluacionUiList;
  }

  @override
  Future<List<TipoNotaUi>> getGetTipoNota(int programaEducativoId) async{
    AppDataBase SQL = AppDataBase();
    List<TipoNotaUi> tipoNotaUiList = [];

    var query = SQL.select(SQL.tipoNotaRubro)..where((tbl) => tbl.programaEducativoId.equals(programaEducativoId));
    query.where((tbl) => tbl.tipoId.isNotIn([TN_VALOR_ASISTENCIA]));
    //query.where((tbl) => tbl.silaboEventoId.isNotIn([0]));
    List<TipoNotaRubroData> tipoNotaList = await query.get();
    for(TipoNotaRubroData tipoNotaRubroData in tipoNotaList){

      TipoNotaUi tipoNotaUi = convertTipoNotaUi(tipoNotaRubroData);

        List<ValorTipoNotaUi> valorTipoNotaUiList = [];
        List<ValorTipoNotaRubroData> valorTipoNotaRubroList = await (SQL.select(SQL.valorTipoNotaRubro)..where((tbl) => tbl.tipoNotaId.equals(tipoNotaRubroData.tipoNotaId))).get();
        valorTipoNotaRubroList.sort((a, b) => (b.valorNumerico??0).compareTo(a.valorNumerico??0));

        for(ValorTipoNotaRubroData valorTipoNotaRubroData in valorTipoNotaRubroList){
          ValorTipoNotaUi valorTipoNotaUi = convertValorTipoNotaUi(valorTipoNotaRubroData);
          valorTipoNotaUi.tipoNotaUi = tipoNotaUi;
          valorTipoNotaUiList.add(valorTipoNotaUi);
        }

        tipoNotaUi.valorTipoNotaList = valorTipoNotaUiList;
        tipoNotaUiList.add(tipoNotaUi);
        tipoNotaUiList.sort((a, b) => (b.valorTipoNotaList??[]).length.compareTo((a.valorTipoNotaList??[]).length));
    }
    return tipoNotaUiList;

  }

  TipoNotaUi convertTipoNotaUi(TipoNotaRubroData? tipoNotaRubroData){
    TipoNotaUi tipoNotaUi = TipoNotaUi();
    tipoNotaUi.tipoNotaId = tipoNotaRubroData?.tipoNotaId;
    tipoNotaUi.nombre = tipoNotaRubroData?.nombre;
    tipoNotaUi.escalanombre = tipoNotaRubroData?.escalanombre;
    tipoNotaUi.escalavalorMaximo = tipoNotaRubroData?.escalavalorMaximo;
    tipoNotaUi.escalavalorMinimo = tipoNotaRubroData?.escalavalorMinimo;
    tipoNotaUi.tiponombre = tipoNotaRubroData?.tiponombre;
    tipoNotaUi.tipoId = tipoNotaRubroData?.tipoId;
    tipoNotaUi.intervalo = tipoNotaRubroData?.intervalo;

    switch(tipoNotaRubroData?.tipoId??0){
      case TN_SELECTOR_ICONOS:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_ICONOS;
        break;
      case TN_SELECTOR_NUMERICO:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_NUMERICO;
        break;
      case TN_SELECTOR_VALORES:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_VALORES;
        break;
      case TN_VALOR_NUMERICO:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_ICONOS;
        break;
      case TN_VALOR_ASISTENCIA:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.VALOR_ASISTENCIA;
        break;
    }
    return tipoNotaUi;
  }

  ValorTipoNotaUi convertValorTipoNotaUi(ValorTipoNotaRubroData? valorTipoNotaRubroData){
    ValorTipoNotaUi valorTipoNotaUi = ValorTipoNotaUi();
    valorTipoNotaUi.valorTipoNotaId = valorTipoNotaRubroData?.valorTipoNotaId;
    valorTipoNotaUi.titulo = valorTipoNotaRubroData?.titulo;
    valorTipoNotaUi.alias = valorTipoNotaRubroData?.alias;
    valorTipoNotaUi.icono = valorTipoNotaRubroData?.icono;
    valorTipoNotaUi.incluidoLInferior = valorTipoNotaRubroData?.incluidoLInferior;
    valorTipoNotaUi.incluidoLSuperior = valorTipoNotaRubroData?.incluidoLSuperior;
    valorTipoNotaUi.valorNumerico = valorTipoNotaRubroData?.valorNumerico;
    valorTipoNotaUi.limiteInferior = valorTipoNotaRubroData?.limiteInferior;
    valorTipoNotaUi.limiteSuperior = valorTipoNotaRubroData?.limiteSuperior;
    return valorTipoNotaUi;
  }
  @override
  Future<List<CompetenciaUi>> getTemasCriterios(int calendarioPeriodoId, int silaboEventoId) async{
    AppDataBase SQL = AppDataBase();
    var query = SQL.select(SQL.criterio)..where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
    query.where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));

    List<CompetenciaUi> competenciaUiList = [];
    //List<CapacidadUi> capacidadUiList = [];
    //List<CriterioUi> criterioUiList = [];

    //List<TemaCriterioUi> padreTemaCriterioDataList = [];
    //List<TemaCriterioUi> temaCriterioDataList = [];

    List<CriterioData> criterioDataList = await query.get();
    for(CriterioData criterioData in criterioDataList){


      CompetenciaUi? competenciaUi = competenciaUiList.firstWhereOrNull((element) => element.competenciaId == criterioData.superCompetenciaId);
      if(competenciaUi==null){
        competenciaUi = CompetenciaUi();
        competenciaUi.capacidadUiList = [];
        competenciaUi.competenciaId = criterioData.superCompetenciaId;
        competenciaUi.nombre = criterioData.superCompetenciaNombre;
        competenciaUi.descripcion = criterioData.superCompetenciaDescripcion;
        competenciaUi.url = criterioData.url;
        switch( criterioData.superCompetenciaTipoId??0){
          case COMPETENCIA_BASE:
            competenciaUi.tipoCompetenciaUi = TipoCompetenciaUi.BASE;
            break;
          case COMPETENCIA_ENFQ:
            competenciaUi.tipoCompetenciaUi = TipoCompetenciaUi.ENFOQUE;
            break;
          case COMPETENCIA_TRANS:
            competenciaUi.tipoCompetenciaUi = TipoCompetenciaUi.TRANSVERSAL;
            break;
        }

        competenciaUiList.add(competenciaUi);
      }

      CapacidadUi? capacidadUi = competenciaUi.capacidadUiList?.firstWhereOrNull((element) => element.capacidadId == criterioData.competenciaId);
      if(capacidadUi==null){
        capacidadUi = CapacidadUi();
        capacidadUi.criterioUiList = [];
        capacidadUi.capacidadId = criterioData.competenciaId;
        capacidadUi.nombre = criterioData.competenciaNombre;
        capacidadUi.descripcion = criterioData.competenciaDescripcion;
        capacidadUi.tipoId = criterioData.competenciaTipoId;
        capacidadUi.competenciaId = criterioData.superCompetenciaId;
        capacidadUi.competenciaUi = competenciaUi;
        competenciaUi.capacidadUiList?.add(capacidadUi);
      }

      CriterioUi? criterioUi = capacidadUi.criterioUiList?.firstWhereOrNull((element) => element.desempenioIcdId == criterioData.desempenioIcdId);
      if(criterioUi==null){
        criterioUi= CriterioUi();
        criterioUi.temaCriterioUiList = [];
        criterioUi.desempenioIcdId = criterioData.desempenioIcdId;
        criterioUi.desempenioId = criterioData.desempenioId;
        criterioUi.icdId = criterioData.icdId;
        criterioUi.desempenioDescripcion = criterioData.DesempenioDescripcion;
        criterioUi.peso = criterioData.peso;
        criterioUi.icdTitulo = criterioData.icdTitulo;
        criterioUi.icdDescripcion = criterioData.icdDescripcion;
        criterioUi.desempenioIcdDescripcion = criterioData.desempenioIcdDescripcion;
        criterioUi.capacidadId = criterioData.competenciaId;
        criterioUi.capacidadUi = capacidadUi;
        criterioUi.tipoId = criterioData.tipoId;
        criterioUi.url = criterioData.url;
        capacidadUi.criterioUiList?.add(criterioUi);

      }

      if((criterioData.campoTematicoParentId??0) > 0) {
        TemaCriterioUi? padreTemaCriterioUi = criterioUi.temaCriterioUiList?.firstWhereOrNull((element) => element.campoTematicoId == criterioData.campoTematicoParentId);
        if (padreTemaCriterioUi == null) {
          padreTemaCriterioUi = TemaCriterioUi();
          padreTemaCriterioUi.temaCriterioUiList = [];
          padreTemaCriterioUi.campoTematicoId =
              criterioData.campoTematicoParentId;
          padreTemaCriterioUi.titulo = criterioData.campoTematicoParentTitulo;
          padreTemaCriterioUi.descripcion =
              criterioData.campoTematicoParentDescripcion;
          padreTemaCriterioUi.parentId = criterioData.campoTematicoParentId;
          criterioUi.temaCriterioUiList?.add(padreTemaCriterioUi);
        }


        TemaCriterioUi? temaCriterioUi = padreTemaCriterioUi.temaCriterioUiList?.firstWhereOrNull((element) => element.campoTematicoId == criterioData.campoTematicoId);
        if(temaCriterioUi==null){
          temaCriterioUi = TemaCriterioUi();
          temaCriterioUi.campoTematicoId = criterioData.campoTematicoId;
          temaCriterioUi.titulo = criterioData.campoTematicoTitulo;
          temaCriterioUi.descripcion = criterioData.campoTematicoDescripcion;
          temaCriterioUi.parentId = criterioData.campoTematicoParentId;
          temaCriterioUi.parent = padreTemaCriterioUi;
          padreTemaCriterioUi.temaCriterioUiList?.add(temaCriterioUi);
        }

      }else{
        TemaCriterioUi? temaCriterioUi = criterioUi.temaCriterioUiList?.firstWhereOrNull((element) => element.campoTematicoId == criterioData.campoTematicoId);
        if(temaCriterioUi==null){
          temaCriterioUi = TemaCriterioUi();
          temaCriterioUi.campoTematicoId = criterioData.campoTematicoId;
          temaCriterioUi.titulo = criterioData.campoTematicoTitulo;
          temaCriterioUi.descripcion = criterioData.campoTematicoDescripcion;
          temaCriterioUi.parentId = criterioData.campoTematicoParentId;
          criterioUi.temaCriterioUiList?.add(temaCriterioUi);
        }
      }

    }
   // print("competenciaUiList size "+competenciaUiList.length.toString());
    return competenciaUiList;
  }

  @override
  Future<String?> saveRubroEvaluacion(String? titulo, int? formaEvaluacionId, int? tipoEvaluacionId, String? promedioLogroId, int? calendarioPeriodoId, int? silaboEventoId, int? cargaCursoId, int? sesionAprendizajeId, String? tareaId, int? usuarioId, List<CriterioPesoUi>? criterioPesoUiList, List<CriterioValorTipoNotaUi>? criterioValorTipoNotaUiList, TipoNotaUi? tipoNotaUi) async {
    AppDataBase SQL = AppDataBase();
    String? rubroEvaluacionId = null;
    await SQL.batch((batch) async {
      List<ContactoDocenteData> alumnoList = [];
      if(formaEvaluacionId == FORMA_EVAL_INDIVIDUAL) {
        var query = SQL.select(SQL.contactoDocente)
          ..where((tbl) => tbl.cargaCursoId.equals(cargaCursoId));
        query.where((tbl) => tbl.tipo.equals(1));
        query.where((tbl) => tbl.contratoVigente.equals(true));
        alumnoList = await query.get();
      }

      rubroEvaluacionId = IdGenerator.generateId();
      RubroEvaluacionProcesoData rubroEvaluacionProceso = RubroEvaluacionProcesoData(
        rubroEvalProcesoId: rubroEvaluacionId!,
        titulo: titulo,
        subtitulo: "",
        tiporubroid: TIPO_RUBRO_BIMENSIONAL,
        calendarioPeriodoId: calendarioPeriodoId,
        competenciaId: 0,
        sesionAprendizajeId: sesionAprendizajeId,
        tipoNotaId: promedioLogroId,
        formaEvaluacionId: formaEvaluacionId,
        tipoEvaluacionId: tipoEvaluacionId,
        silaboEventoId: silaboEventoId,
        estadoId: ESTADO_CREADO,
        syncFlag: EstadoSync.FLAG_ADDED,
        countIndicador: criterioPesoUiList?.length,
        estrategiaEvaluacionId: 0,
        anchoColumna: "",
        colorFondo: "",
        tipoFormulaId: 0,
        //estrategiaEvaluacionId: Falta
        tareaId: tareaId,
        fechaCreacion: DateTime.now(),
        fechaAccion: DateTime.now(),
        usuarioAccionId: usuarioId,
        usuarioCreacionId: usuarioId,
      );

      batch.insert(SQL.rubroEvaluacionProceso, rubroEvaluacionProceso,
          mode: InsertMode.insertOrReplace);

      if(formaEvaluacionId == FORMA_EVAL_INDIVIDUAL){

        for(ContactoDocenteData alumno in alumnoList){
          EvaluacionProcesoData evaluacionProceso = EvaluacionProcesoData(
            evaluacionProcesoId: IdGenerator.generateId(),
            rubroEvalProcesoId: rubroEvaluacionId,
            alumnoId: alumno.personaId,
            syncFlag: EstadoSync.FLAG_ADDED,
            fechaCreacion: DateTime.now(),
            fechaAccion: DateTime.now(),
            usuarioAccionId: usuarioId,
            usuarioCreacionId: usuarioId,
          );
          batch.insert(SQL.evaluacionProceso, evaluacionProceso, mode: InsertMode.insertOrReplace);
        }

      }

      for(CriterioPesoUi criterioPesoUi in criterioPesoUiList??[]){

        CapacidadUi? capacidadUi = criterioPesoUi.criterioUi?.capacidadUi;
        int? peso = criterioPesoUi.peso;
        String rubroEvaluacionDetalleId = IdGenerator.generateId();
        RubroEvaluacionProcesoData procesoDetalle = RubroEvaluacionProcesoData(
          rubroEvalProcesoId: rubroEvaluacionDetalleId,
          titulo: criterioPesoUi.criterioUi?.icdTituloEditado??criterioPesoUi.criterioUi?.icdTitulo??"",
          subtitulo: '',
          desempenioIcdId: criterioPesoUi.criterioUi?.desempenioIcdId,
          tiporubroid: TIPO_RUBRO_BIDIMENCIONAL_DETALLE,
          tipoNotaId: tipoNotaUi?.tipoNotaId,
          silaboEventoId: silaboEventoId,
          competenciaId: capacidadUi?.capacidadId,
          calendarioPeriodoId: calendarioPeriodoId,
          sesionAprendizajeId: sesionAprendizajeId,
          tipoEvaluacionId: tipoEvaluacionId,
          formaEvaluacionId: formaEvaluacionId,
          estadoId: ESTADO_CREADO,
          rubroFormal: capacidadUi?.tipoId == COMPETENCIA_BASE? 1:0,
          syncFlag: EstadoSync.FLAG_ADDED,
          fechaCreacion: DateTime.now(),
          fechaAccion: DateTime.now(),
          usuarioAccionId: usuarioId,
          usuarioCreacionId: usuarioId,
        );

        batch.insert(SQL.rubroEvaluacionProceso, procesoDetalle, mode: InsertMode.insertOrReplace);

        if(formaEvaluacionId == FORMA_EVAL_INDIVIDUAL){

          for(ContactoDocenteData alumno in alumnoList){
            EvaluacionProcesoData evaluacionProceso = EvaluacionProcesoData(
              evaluacionProcesoId: IdGenerator.generateId(),
              rubroEvalProcesoId: rubroEvaluacionDetalleId,
              alumnoId: alumno.personaId,
              nombres: alumno.nombres,
              apellidoMaterno: alumno.apellidoMaterno,
              apellidoPaterno: alumno.apellidoPaterno,
              foto: alumno.foto,
              syncFlag: EstadoSync.FLAG_ADDED,
              fechaCreacion: DateTime.now(),
              fechaAccion: DateTime.now(),
              usuarioAccionId: usuarioId,
              usuarioCreacionId: usuarioId,
            );
            batch.insert(SQL.evaluacionProceso, evaluacionProceso, mode: InsertMode.insertOrReplace);
          }

        }

        RubroEvalRNPFormulaData rubroEvalRNPFormula = RubroEvalRNPFormulaData(
          rubroFormulaId: IdGenerator.generateId(),
          rubroEvaluacionPrimId: rubroEvaluacionId,
          rubroEvaluacionSecId: rubroEvaluacionDetalleId,
          peso: peso?.toDouble(),
          syncFlag: EstadoSync.FLAG_ADDED,
          fechaCreacion: DateTime.now(),
          fechaAccion: DateTime.now(),
          usuarioAccionId: usuarioId,
          usuarioCreacionId: usuarioId,
        );
        batch.insert(SQL.rubroEvalRNPFormula, rubroEvalRNPFormula, mode: InsertMode.insertOrReplace);

        for(CriterioValorTipoNotaUi criterioValorTipoNotaUi in criterioValorTipoNotaUiList??[]){
          if(criterioValorTipoNotaUi.criterioUi?.desempenioIcdId == criterioPesoUi.criterioUi?.desempenioIcdId){
            CriterioRubroEvaluacionData criterioRubroEvaluacionData = CriterioRubroEvaluacionData(
                criteriosEvaluacionId: IdGenerator.generateId(),
                rubroEvalProcesoId: rubroEvaluacionDetalleId,
                valorTipoNotaId: criterioValorTipoNotaUi.valorTipoNotaUi?.valorTipoNotaId,
                descripcion: "");
            batch.insert(SQL.criterioRubroEvaluacion, criterioRubroEvaluacionData);
          }
        }

        List<TemaCriterioUi> temaCriterioUiList = [];
        for(TemaCriterioUi temaCriterioUi in criterioPesoUi.criterioUi?.temaCriterioUiList??[]){
          if((temaCriterioUi.temaCriterioUiList??[]).isEmpty && (temaCriterioUi.toogle??false))temaCriterioUiList.add(temaCriterioUi);
          for(TemaCriterioUi subtemaCriterioUi in temaCriterioUi.temaCriterioUiList??[]){
            if(subtemaCriterioUi.toogle??false)temaCriterioUiList.add(subtemaCriterioUi);
          }
        }

        for(TemaCriterioUi temaCriterioUi in temaCriterioUiList){
          if(temaCriterioUi.toogle??false){
            RubroCampotematicoData rubroCampotematicoData = RubroCampotematicoData(
              rubroEvalProcesoId: rubroEvaluacionDetalleId,
              campoTematicoId: temaCriterioUi.campoTematicoId??0,
              syncFlag: EstadoSync.FLAG_ADDED,
              fechaCreacion: DateTime.now(),
              fechaAccion: DateTime.now(),
              usuarioAccionId: usuarioId,
              usuarioCreacionId: usuarioId,
            );

            batch.insert(SQL.rubroCampotematico, rubroCampotematicoData, mode: InsertMode.insertOrReplace);
          }
        }
      }
    });

    return rubroEvaluacionId;
  }

  @override
  Future<List<RubricaEvaluacionUi>> getRubroEvaluacionList(int calendarioPeriodoId, int silaboEventoId, OrigenRubroUi origenRubroUi) async {
    AppDataBase SQL = AppDataBase();
    var query = SQL.select(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
    query.where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    query.where((tbl) => tbl.tiporubroid.isIn([TIPO_RUBRO_BIMENSIONAL, TIPO_RUBRO_UNIDIMENCIONAL]));
    //query.where((tbl) => tbl.tipoFormulaId.isNull());
    query.where((tbl) => tbl.tipoFormulaId.equals(0));
    query.where((tbl) => tbl.estadoId.isNotIn([ESTADO_ELIMINADO]));
    query.orderBy([(tbl)=> OrderingTerm.desc(tbl.fechaCreacion)]);

    List<String> rubricaIdList =[];
    List<RubricaEvaluacionUi> rubricaEvalProcesoUiList = [];
    List<RubroEvaluacionProcesoData> rubroEvalProcesoList = await query.get();
    for(RubroEvaluacionProcesoData rubroEvaluacionProcesoData in  rubroEvalProcesoList){
      rubricaIdList.add(rubroEvaluacionProcesoData.rubroEvalProcesoId);
      RubricaEvaluacionUi rubricaEvaluacionUi = convertRubricaEvaluacionUi(rubroEvaluacionProcesoData, 0.0);
      if(origenRubroUi == OrigenRubroUi.TODOS){
        rubricaEvalProcesoUiList.add(rubricaEvaluacionUi);
      }else if(origenRubroUi == rubricaEvaluacionUi.origenRubroUi){
        rubricaEvalProcesoUiList.add(rubricaEvaluacionUi);
      }
    }

    var queryEval = SQL.select(SQL.evaluacionProceso).join([
        innerJoin(SQL.rubroEvaluacionProceso, SQL.evaluacionProceso.rubroEvalProcesoId.equalsExp(SQL.rubroEvaluacionProceso.rubroEvalProcesoId))
    ]);
    
    queryEval.where(SQL.rubroEvaluacionProceso.silaboEventoId.equals(silaboEventoId));
    queryEval.where(SQL.rubroEvaluacionProceso.calendarioPeriodoId.equals(calendarioPeriodoId));

    for(var row in await queryEval.get()){
      EvaluacionProcesoData evalRubroEvalProceso = row.readTable(SQL.evaluacionProceso);
      for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvalProcesoUiList){
        if(rubricaEvaluacionUi.rubricaId == evalRubroEvalProceso.rubroEvalProcesoId){
          rubricaEvaluacionUi.cantEvaluaciones = (rubricaEvaluacionUi.cantEvaluaciones??0) + 1;
          if((evalRubroEvalProceso.publicado??0) == 1){
            rubricaEvaluacionUi.cantEvalPublicadas = (rubricaEvaluacionUi.cantEvalPublicadas??0) + 1;
          }
        }
      }
    }
    //#region Agregar la cantidad de rubros Asociados
    var queryRubroDetalle = SQL.select(SQL.rubroEvalRNPFormula).join([
      innerJoin(SQL.rubroEvaluacionProceso, SQL.rubroEvalRNPFormula.rubroEvaluacionSecId.equalsExp(SQL.rubroEvaluacionProceso.rubroEvalProcesoId))
    ]);
    queryRubroDetalle.where(SQL.rubroEvalRNPFormula.rubroEvaluacionPrimId.isIn(rubricaIdList));
    queryRubroDetalle.where(SQL.rubroEvaluacionProceso.estadoId.isNotIn([ESTADO_ELIMINADO]));

    for(var row in await queryRubroDetalle.get()){
      RubroEvalRNPFormulaData rubroEvalRNPFormulaData = row.readTable(SQL.rubroEvalRNPFormula);
      for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvalProcesoUiList){
        if(rubroEvalRNPFormulaData.rubroEvaluacionPrimId == rubricaEvaluacionUi.rubricaId){
          rubricaEvaluacionUi.cantidadRubroDetalle =  (rubricaEvaluacionUi.cantidadRubroDetalle??0) + 1;
        }
      }
    }
    return rubricaEvalProcesoUiList;
  }

  RubricaEvaluacionUi convertRubricaEvaluacionUi(RubroEvaluacionProcesoData? rubroEvaluacionProcesoData, double peso){
    RubricaEvaluacionUi rubricaEvaluacionUi = RubricaEvaluacionUi();
    rubricaEvaluacionUi.rubricaId = rubroEvaluacionProcesoData?.rubroEvalProcesoId;
    rubricaEvaluacionUi.titulo = rubroEvaluacionProcesoData?.titulo;
    rubricaEvaluacionUi.efechaCreacion = AppTools.f_fecha_letras(rubroEvaluacionProcesoData?.fechaCreacion);
    rubricaEvaluacionUi.fechaCreacion = rubroEvaluacionProcesoData?.fechaCreacion;
    rubricaEvaluacionUi.mediaDesvicion = '${(rubroEvaluacionProcesoData?.promedio??0).toStringAsFixed(1)} (${(rubroEvaluacionProcesoData?.desviacionEstandar??0).toStringAsFixed(1)})';
    rubricaEvaluacionUi.rubroGrupal = rubroEvaluacionProcesoData?.formaEvaluacionId == FORMA_EVAL_GRUPAL;
    rubricaEvaluacionUi.sesionAprendizajeId = rubroEvaluacionProcesoData?.sesionAprendizajeId;
    if((rubroEvaluacionProcesoData?.tareaId??"").isNotEmpty)rubricaEvaluacionUi.origenRubroUi = OrigenRubroUi.GENERADO_TAREA;
    else if((rubroEvaluacionProcesoData?.instrumentoEvalId??"").isNotEmpty)rubricaEvaluacionUi.origenRubroUi = OrigenRubroUi.GENERADO_INSTRUMENTO;
    else if((rubroEvaluacionProcesoData?.preguntaEvalId??"").isNotEmpty)rubricaEvaluacionUi.origenRubroUi = OrigenRubroUi.GENERADO_PREGUNTA;
    else rubricaEvaluacionUi.origenRubroUi = OrigenRubroUi.CREADO_DOCENTE;
    rubricaEvaluacionUi.tipoNotaId = rubroEvaluacionProcesoData?.tipoNotaId;
    rubricaEvaluacionUi.peso = peso;
    rubricaEvaluacionUi.guardadoLocal = (rubroEvaluacionProcesoData?.syncFlag == EstadoSync.FLAG_ADDED ||  rubroEvaluacionProcesoData?.syncFlag == EstadoSync.FLAG_UPDATED);
    rubricaEvaluacionUi.calendarioPeriodoId = rubroEvaluacionProcesoData?.calendarioPeriodoId;
    return rubricaEvaluacionUi;
  }

  EvaluacionUi convertEvaluacionUi(EvaluacionProcesoData evaluacionProcesoData){
    EvaluacionUi evaluacionUi = EvaluacionUi();
    evaluacionUi.evaluacionId = evaluacionProcesoData.evaluacionProcesoId;
    evaluacionUi.rubroEvaluacionId = evaluacionProcesoData.rubroEvalProcesoId;
    evaluacionUi.alumnoId = evaluacionProcesoData.alumnoId;
    evaluacionUi.personaUi = PersonaUi();
    evaluacionUi.personaUi?.personaId = evaluacionProcesoData.alumnoId;
    evaluacionUi.personaUi?.nombres = evaluacionProcesoData.nombres;
    evaluacionUi.personaUi?.nombreCompleto = '${AppTools.capitalize(evaluacionProcesoData.nombres??"")} ${AppTools.capitalize(evaluacionProcesoData.apellidoPaterno??"")} ${AppTools.capitalize(evaluacionProcesoData.apellidoMaterno??"")}';
    evaluacionUi.personaUi?.apellidos  = '${AppTools.capitalize(evaluacionProcesoData.apellidoPaterno??"")} ${AppTools.capitalize(evaluacionProcesoData.apellidoMaterno??"")}';
    evaluacionUi.personaUi?.apellidoPaterno = evaluacionProcesoData.apellidoPaterno;
    evaluacionUi.personaUi?.apellidoMaterno = evaluacionProcesoData.apellidoMaterno;
    evaluacionUi.personaUi?.foto = evaluacionProcesoData.foto;
    evaluacionUi.publicado = evaluacionProcesoData.publicado;
    evaluacionUi.equipoId = evaluacionProcesoData.equipoId;
    evaluacionUi.valorTipoNotaId =  evaluacionProcesoData.valorTipoNotaId;
    evaluacionUi.nota = evaluacionProcesoData.nota;
    return evaluacionUi;
  }
  @override
  Future<List<UnidadUi>> getUnidadAprendizaje(int? silaboEventoId, int? calendarioPeriodoId) async {
    AppDataBase SQL = AppDataBase();
    List<UnidadUi> unidadUiList = [];
    List<SesionUi> sesionUiList = [];
    var query = SQL.selectOnly(SQL.criterio, distinct: true)//..where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    //query.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
      ..addColumns([SQL.criterio.silaboEventoId,
        SQL.criterio.unidadAprendiajeId,
        SQL.criterio.tituloUnidad,
        SQL.criterio.nroUnidad,
        SQL.criterio.sesionAprendizajeId,
        SQL.criterio.sesionAprendizajePadreId,
        SQL.criterio.nroSesion,
        SQL.criterio.propositoSesion,
        SQL.criterio.rolIdSesion,
        SQL.criterio.tituloSesion,
      ]);
    query.where(SQL.criterio.silaboEventoId.equals(silaboEventoId));
    query.where(SQL.criterio.calendarioPeriodoId.equals(calendarioPeriodoId));
    query.orderBy([ OrderingTerm(expression: SQL.criterio.nroUnidad, mode: OrderingMode.desc),  OrderingTerm(expression: SQL.criterio.nroSesion, mode: OrderingMode.desc)]);
    query.map((row){
    UnidadUi? unidadUi = unidadUiList.firstWhereOrNull((element) => element.unidadAprendizajeId == row.read(SQL.criterio.unidadAprendiajeId));
    if(unidadUi == null){
      unidadUi = UnidadUi();
      unidadUi.sesionUiList = [];
      unidadUiList.add(unidadUi);
    }
    unidadUi.unidadAprendizajeId = row.read(SQL.criterio.unidadAprendiajeId);
    unidadUi.titulo = row.read(SQL.criterio.tituloUnidad);
    unidadUi.nroUnidad = row.read(SQL.criterio.nroUnidad);
    SesionUi sesionUi = SesionUi();
    sesionUi.sesionAprendizajeId =  row.read(SQL.criterio.sesionAprendizajeId);
    sesionUi.sesionAprendizajePadreId = row.read(SQL.criterio.sesionAprendizajePadreId);
    sesionUi.tituloUnidad = unidadUi.titulo;
    sesionUi.nroUnidad = unidadUi.nroUnidad;
    sesionUi.nroSesion = row.read(SQL.criterio.nroSesion);
    sesionUi.titulo = row.read(SQL.criterio.tituloSesion);
    sesionUi.proposito = row.read(SQL.criterio.propositoSesion);
    sesionUi.rubricaEvaluacionUiList = [];
    if((sesionUi.sesionAprendizajeId??0)>0){
      unidadUi.sesionUiList?.add(sesionUi);
      sesionUiList.add(sesionUi);
    }

    return unidadUi;
    }).get();


    var queryRubro = SQL.select(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
    queryRubro.where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    queryRubro.where((tbl) => tbl.tiporubroid.isIn([TIPO_RUBRO_BIMENSIONAL, TIPO_RUBRO_UNIDIMENCIONAL]));
    //query.where((tbl) => tbl.tipoFormulaId.isNull());
    queryRubro.where((tbl) => tbl.tipoFormulaId.equals(0));
    queryRubro.where((tbl) => tbl.sesionAprendizajeId.isNotNull());
    queryRubro.orderBy([(tbl)=> OrderingTerm.desc(tbl.fechaCreacion)]);

    List<RubroEvaluacionProcesoData> rubroEvalProcesoList = await queryRubro.get();
    for(RubroEvaluacionProcesoData rubroEvaluacionProcesoData in  rubroEvalProcesoList){
      for(SesionUi sesionUi in sesionUiList){
        if(sesionUi.sesionAprendizajeId == rubroEvaluacionProcesoData.sesionAprendizajeId || sesionUi.sesionAprendizajePadreId ==  rubroEvaluacionProcesoData.sesionAprendizajeId){
          RubricaEvaluacionUi rubricaEvaluacionUi = convertRubricaEvaluacionUi(rubroEvaluacionProcesoData, 0.0);
          sesionUi.rubricaEvaluacionUiList?.add(rubricaEvaluacionUi);
        }
      }
    }

    return unidadUiList;
  }

  @override
  Future<List<CompetenciaUi>> getRubroCompetencia(int? silaboEventoId, int? calendarioPeriodoId, int? competenciaId) async{
    AppDataBase SQL = AppDataBase();

    var queryRubro = SQL.select(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
    queryRubro.where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    queryRubro.where((tbl) => tbl.tiporubroid.isIn([TIPO_RUBRO_BIMENSIONAL, TIPO_RUBRO_UNIDIMENCIONAL]));
    //query.where((tbl) => tbl.tipoFormulaId.isNull());
    queryRubro.where((tbl) => tbl.tipoFormulaId.equals(0));
    //queryRubro.where((tbl) => tbl.sesionAprendizajeId.isNotNull());
    queryRubro.orderBy([(tbl)=> OrderingTerm.desc(tbl.fechaCreacion)]);

    List<RubroEvaluacionProcesoData> rubroEvalProcesoList = await queryRubro.get();
    List<String> rubroEvalProcesoIdList = [];
    List<String> rubroTipoNotaIdList = [];
    for(RubroEvaluacionProcesoData rubroEvalProcesoData in rubroEvalProcesoList){
      rubroEvalProcesoIdList.add(rubroEvalProcesoData.rubroEvalProcesoId);
      rubroTipoNotaIdList.add(rubroEvalProcesoData.tipoNotaId??"");
    }

    List<TipoNotaUi> tipoNotaUiList = [];
    List<EvaluacionProcesoData> evaluacionProcesoDataList = await (SQL.select(SQL.evaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvalProcesoIdList))).get();
    var queryTipoNota = SQL.select(SQL.tipoNotaRubro)..where((tbl) => tbl.tipoNotaId.isIn(rubroTipoNotaIdList));
    //queryTipoNota.where((tbl) => tbl.silaboEventoId.equals(0));
    List<TipoNotaRubroData> tipoNotaList = await (queryTipoNota).get();
    for(TipoNotaRubroData tipoNotaRubroData in tipoNotaList){

      TipoNotaUi tipoNotaUi = convertTipoNotaUi(tipoNotaRubroData);
      List<ValorTipoNotaUi> valorTipoNotaUiList = [];

      var queryValorTipoNota = SQL.select(SQL.valorTipoNotaRubro)..where((tbl) => tbl.tipoNotaId.equals(tipoNotaRubroData.tipoNotaId));
      //queryValorTipoNota.where((tbl) => tbl.silaboEventoId.equals(0));
      List<ValorTipoNotaRubroData> valorTipoNotaRubroList = await queryValorTipoNota.get();
      valorTipoNotaRubroList.sort((a, b) => (b.valorNumerico??0).compareTo(a.valorNumerico??0));

      for(ValorTipoNotaRubroData valorTipoNotaRubroData in valorTipoNotaRubroList){
        ValorTipoNotaUi valorTipoNotaUi = convertValorTipoNotaUi(valorTipoNotaRubroData);
        valorTipoNotaUi.tipoNotaUi = tipoNotaUi;
        valorTipoNotaUiList.add(valorTipoNotaUi);
      }

      tipoNotaUi.valorTipoNotaList = valorTipoNotaUiList;
      tipoNotaUiList.add(tipoNotaUi);
    }

    print("evaluacionProcesoDataList: ${evaluacionProcesoDataList.length}");
   List<CompetenciaUi> competenciaUiList = await getTemasCriterios(calendarioPeriodoId??0, silaboEventoId??0);
    for(CompetenciaUi competenciaUi in competenciaUiList){
      for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
        capacidadUi.rubricaEvalUiList = [];
        for(RubroEvaluacionProcesoData rubroEvaluacionProcesoData in  rubroEvalProcesoList){
          if(capacidadUi.capacidadId == rubroEvaluacionProcesoData.competenciaId){
            RubricaEvaluacionUi rubricaEvaluacionUi = convertRubricaEvaluacionUi(rubroEvaluacionProcesoData, 0.0);
            rubricaEvaluacionUi.evaluacionUiList = [];
            TipoNotaUi? tipoNotaUi = tipoNotaUiList.firstWhereOrNull((element)=> element.tipoNotaId == rubricaEvaluacionUi.tipoNotaId);
            rubricaEvaluacionUi.tipoNotaUi = tipoNotaUi;
            for(EvaluacionProcesoData evaluacionProcesoData in evaluacionProcesoDataList){
              if(evaluacionProcesoData.rubroEvalProcesoId ==  rubroEvaluacionProcesoData.rubroEvalProcesoId){
                EvaluacionUi evaluacionUi = convertEvaluacionUi(evaluacionProcesoData);
                ValorTipoNotaUi? valorTipoNotaUi = tipoNotaUi?.valorTipoNotaList?.firstWhereOrNull((element) => element.valorTipoNotaId == evaluacionUi.valorTipoNotaId);
                evaluacionUi.valorTipoNotaUi = valorTipoNotaUi;
                evaluacionUi.rubroEvaluacionUi =  rubricaEvaluacionUi;
                rubricaEvaluacionUi.evaluacionUiList?.add(evaluacionUi);
              }
            }
            capacidadUi.rubricaEvalUiList?.add(rubricaEvaluacionUi);
          }
        }
      }
    }

    return competenciaUiList;
  }


  @override
  Future<TipoNotaUi> getGetTipoNotaResultado(int? silaboEventoId) async{
    AppDataBase SQL = AppDataBase();
    var query =  SQL.selectSingle(SQL.tipoNotaResultado);
    query.where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));

    TipoNotaResultadoData? tipoNotaRubroData = await query.getSingleOrNull();

    TipoNotaUi tipoNotaUi = TipoNotaUi();
    tipoNotaUi.tipoNotaId = tipoNotaRubroData?.tipoNotaId;
    tipoNotaUi.nombre = tipoNotaRubroData?.nombre;
    tipoNotaUi.escalanombre = tipoNotaRubroData?.escalanombre;
    tipoNotaUi.escalavalorMaximo = tipoNotaRubroData?.escalavalorMaximo;
    tipoNotaUi.escalavalorMinimo = tipoNotaRubroData?.escalavalorMinimo;
    tipoNotaUi.tiponombre = tipoNotaRubroData?.tiponombre;
    tipoNotaUi.tipoId = tipoNotaRubroData?.tipoId;
    tipoNotaUi.intervalo = tipoNotaRubroData?.intervalo;

    switch(tipoNotaRubroData?.tipoId??0){
      case TN_SELECTOR_ICONOS:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_ICONOS;
        break;
      case TN_SELECTOR_NUMERICO:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_NUMERICO;
        break;
      case TN_SELECTOR_VALORES:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_VALORES;
        break;
      case TN_VALOR_NUMERICO:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_ICONOS;
        break;
      case TN_VALOR_ASISTENCIA:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.VALOR_ASISTENCIA;
        break;
    }

    List<ValorTipoNotaUi> valorTipoNotaUiList = [];
    var queryValorTipoNota = SQL.select(SQL.valorTipoNotaResultado);
    queryValorTipoNota..where((tbl) => tbl.tipoNotaId.equals(tipoNotaRubroData?.tipoNotaId));
    queryValorTipoNota.where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    List<ValorTipoNotaResultadoData> valorTipoNotaRubroList = await queryValorTipoNota.get();


    valorTipoNotaRubroList.sort((a, b) => (b.valorNumerico??0).compareTo(a.valorNumerico??0));

    for(ValorTipoNotaResultadoData valorTipoNotaRubroData in valorTipoNotaRubroList){
      ValorTipoNotaUi valorTipoNotaUi = ValorTipoNotaUi();
      valorTipoNotaUi.valorTipoNotaId = valorTipoNotaRubroData.valorTipoNotaId;
      valorTipoNotaUi.titulo = valorTipoNotaRubroData.titulo;
      valorTipoNotaUi.alias = valorTipoNotaRubroData.alias;
      valorTipoNotaUi.icono = valorTipoNotaRubroData.icono;
      valorTipoNotaUi.incluidoLInferior = valorTipoNotaRubroData.incluidoLInferior;
      valorTipoNotaUi.incluidoLSuperior = valorTipoNotaRubroData.incluidoLSuperior;
      valorTipoNotaUi.tipoNotaUi = tipoNotaUi;
      valorTipoNotaUi.tipoNotaId = valorTipoNotaRubroData.tipoNotaId;
      valorTipoNotaUi.valorNumerico = valorTipoNotaRubroData.valorNumerico;
      valorTipoNotaUi.limiteInferior = valorTipoNotaRubroData.limiteInferior;
      valorTipoNotaUi.limiteSuperior = valorTipoNotaRubroData.limiteSuperior;
      valorTipoNotaUiList.add(valorTipoNotaUi);
    }
    print("valorTipoNotaList: " + (valorTipoNotaUiList.length).toString());
    tipoNotaUi.valorTipoNotaList = valorTipoNotaUiList;
    return tipoNotaUi;
  }

  Future<TipoNotaUi> getTipoNota(String? tipoNotaId) async{
    AppDataBase SQL = AppDataBase();
    var query =  SQL.selectSingle(SQL.tipoNotaRubro)..where((tbl) => tbl.tipoNotaId.equals(tipoNotaId));

    TipoNotaRubroData? tipoNotaRubroData = await query.getSingleOrNull();

    TipoNotaUi tipoNotaUi = TipoNotaUi();
    tipoNotaUi.tipoNotaId = tipoNotaRubroData?.tipoNotaId;
    tipoNotaUi.nombre = tipoNotaRubroData?.nombre;
    tipoNotaUi.escalanombre = tipoNotaRubroData?.escalanombre;
    tipoNotaUi.escalavalorMaximo = tipoNotaRubroData?.escalavalorMaximo;
    tipoNotaUi.escalavalorMinimo = tipoNotaRubroData?.escalavalorMinimo;
    tipoNotaUi.tiponombre = tipoNotaRubroData?.tiponombre;
    tipoNotaUi.tipoId = tipoNotaRubroData?.tipoId;
    tipoNotaUi.intervalo = tipoNotaRubroData?.intervalo;

    switch(tipoNotaRubroData?.tipoId??0){
      case TN_SELECTOR_ICONOS:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_ICONOS;
        break;
      case TN_SELECTOR_NUMERICO:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_NUMERICO;
        break;
      case TN_SELECTOR_VALORES:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_VALORES;
        break;
      case TN_VALOR_NUMERICO:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_ICONOS;
        break;
      case TN_VALOR_ASISTENCIA:
        tipoNotaUi.tipoNotaTiposUi = TipoNotaTiposUi.VALOR_ASISTENCIA;
        break;
    }
    print("getTipoNota ${tipoNotaRubroData?.tipoId}");
    List<ValorTipoNotaUi> valorTipoNotaUiList = [];
    var queryValorTipoNota = SQL.select(SQL.valorTipoNotaRubro)..where((tbl) => tbl.tipoNotaId.equals(tipoNotaRubroData?.tipoNotaId));
    List<ValorTipoNotaRubroData> valorTipoNotaRubroList = await queryValorTipoNota.get();
    valorTipoNotaRubroList.sort((a, b) => (b.valorNumerico??0).compareTo(a.valorNumerico??0));

    for(ValorTipoNotaRubroData valorTipoNotaRubroData in valorTipoNotaRubroList){
      ValorTipoNotaUi valorTipoNotaUi = ValorTipoNotaUi();
      valorTipoNotaUi.valorTipoNotaId = valorTipoNotaRubroData.valorTipoNotaId;
      valorTipoNotaUi.titulo = valorTipoNotaRubroData.titulo;
      valorTipoNotaUi.alias = valorTipoNotaRubroData.alias;
      valorTipoNotaUi.icono = valorTipoNotaRubroData.icono;
      valorTipoNotaUi.incluidoLInferior = valorTipoNotaRubroData.incluidoLInferior;
      valorTipoNotaUi.incluidoLSuperior = valorTipoNotaRubroData.incluidoLSuperior;
      valorTipoNotaUi.tipoNotaUi = tipoNotaUi;
      valorTipoNotaUi.tipoNotaId = valorTipoNotaRubroData.tipoNotaId;
      valorTipoNotaUi.valorNumerico = valorTipoNotaRubroData.valorNumerico;
      valorTipoNotaUi.limiteInferior = valorTipoNotaRubroData.limiteInferior;
      valorTipoNotaUi.limiteSuperior = valorTipoNotaRubroData.limiteSuperior;


      valorTipoNotaUiList.add(valorTipoNotaUi);
    }

    tipoNotaUi.valorTipoNotaList = valorTipoNotaUiList;
    return tipoNotaUi;
  }

  @override
  Future<RubricaEvaluacionUi> getRubroEvaluacion(String? rubroEvaluacionId)async {
    AppDataBase SQL = AppDataBase();
    RubroEvaluacionProcesoData? rubroEvaluacionProcesoData = await (SQL.selectSingle(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.equals(rubroEvaluacionId))).getSingleOrNull();
    RubricaEvaluacionUi rubricaEvaluacionUi = convertRubricaEvaluacionUi(rubroEvaluacionProcesoData, 0.0);
    List<RubricaEvaluacionUi> rubricaEvaluacionUiDetalleList = [];
    if(rubroEvaluacionProcesoData?.tiporubroid == TIPO_RUBRO_BIMENSIONAL){
      var queryRubroDetalle = SQL.select(SQL.rubroEvaluacionProceso).join([
        innerJoin(SQL.rubroEvalRNPFormula, SQL.rubroEvalRNPFormula.rubroEvaluacionSecId.equalsExp(SQL.rubroEvaluacionProceso.rubroEvalProcesoId))
      ]);
      queryRubroDetalle.where(SQL.rubroEvaluacionProceso.estadoId.isNotIn([ESTADO_ELIMINADO]));
      queryRubroDetalle.where(SQL.rubroEvalRNPFormula.rubroEvaluacionPrimId.equals(rubroEvaluacionId));
      print("getRubroEvaluacion " + (rubroEvaluacionId??"null"));
      for(var row in await queryRubroDetalle.get()){
        RubroEvaluacionProcesoData rubroEvaluacionProcesoData = row.readTable(SQL.rubroEvaluacionProceso);
        RubroEvalRNPFormulaData rubroEvalRNPFormulaData = row.readTable(SQL.rubroEvalRNPFormula);
        rubricaEvaluacionUiDetalleList.add(convertRubricaEvaluacionUi(rubroEvaluacionProcesoData, rubroEvalRNPFormulaData.peso??0.0));
      }
      print("rubrosDetalleList " + rubricaEvaluacionUiDetalleList.length.toString());
    }

    /*Obtener Tipo Nota*/
    rubricaEvaluacionUi.tipoNotaUi = await getTipoNota(rubricaEvaluacionUi.tipoNotaId);

    List<TipoNotaUi> tipoNotaUiDetalleList = [];//Validacion por no hacer muchas consultas
    for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUiDetalleList){
      TipoNotaUi? tipoNotaUi = tipoNotaUiDetalleList.firstWhereOrNull((element) => element.tipoNotaId == rubricaEvaluacionUi.tipoNotaId);
      if(tipoNotaUi==null){
        tipoNotaUi = await getTipoNota(rubricaEvaluacionUi.tipoNotaId);
        tipoNotaUiDetalleList.add(tipoNotaUi);
      }
      rubricaEvaluacionUi.tipoNotaUi = tipoNotaUi;
    }
    /*Obtener Evaluacion*/
    List<String> rubroEvaluacionIdEvaluacionList = [];
    List<RubricaEvaluacionUi> rubroEvaluacionUiEvaluacionList = [];
    rubroEvaluacionIdEvaluacionList.add(rubricaEvaluacionUi.rubricaId??"");
    rubroEvaluacionUiEvaluacionList.add(rubricaEvaluacionUi);
    for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUiDetalleList){
      rubroEvaluacionIdEvaluacionList.add(rubricaEvaluacionUi.rubricaId??"");
      rubroEvaluacionUiEvaluacionList.add(rubricaEvaluacionUi);
    }

    if(rubroEvaluacionProcesoData?.formaEvaluacionId == FORMA_EVAL_INDIVIDUAL){
      List<EvaluacionProcesoData> evaluacionProcesoDataList = await (SQL.select(SQL.evaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdEvaluacionList))).get();
      for(RubricaEvaluacionUi rubricaEvaluacionUi in rubroEvaluacionUiEvaluacionList){
        rubricaEvaluacionUi.evaluacionUiList = [];
        for(EvaluacionProcesoData evaluacionProcesoData in evaluacionProcesoDataList){
          if(evaluacionProcesoData.rubroEvalProcesoId == rubricaEvaluacionUi.rubricaId){
            EvaluacionUi evaluacionUi = convertEvaluacionUi(evaluacionProcesoData);
            ValorTipoNotaUi? valorTipoNotaUi = rubricaEvaluacionUi.tipoNotaUi?.valorTipoNotaList?.firstWhereOrNull((element) => element.valorTipoNotaId == evaluacionUi.valorTipoNotaId);
            evaluacionUi.valorTipoNotaUi = valorTipoNotaUi;
            evaluacionUi.rubroEvaluacionUi =  rubricaEvaluacionUi;
            rubricaEvaluacionUi.evaluacionUiList?.add(evaluacionUi);
          }
        }
      }
    }
    /*Obtener Evaluacuion*/
    rubricaEvaluacionUi.rubrosDetalleList = rubricaEvaluacionUiDetalleList;
    return rubricaEvaluacionUi;
  }

  @override
  Future<Map<String, dynamic>?> getRubroEvaluacionSerial(String rubroEvaluacionId) async {
    AppDataBase SQL = AppDataBase();
    RubroEvaluacionProcesoData? rubroEvaluacionProcesoData = await (SQL.selectSingle(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.equals(rubroEvaluacionId)))
        .getSingleOrNull();
    if(rubroEvaluacionProcesoData != null){
      return transformarEvaluaciones(SQL, rubroEvaluacionProcesoData);
    }else{
      return null;
    }
  }

  Future<Map<String, dynamic>> transformarEvaluaciones(AppDataBase SQL, RubroEvaluacionProcesoData rubroEvaluacionProcesoData) async{
    Map<String, dynamic> bERubroEvalEnvioSimple = new Map<String, dynamic>();
    List<RubroEvaluacionProcesoData> rubroEvaluacionDataList = [];
    List<RubroEvalRNPFormulaData> rubroFormulaDataList = [];
    List<String> rubroEvaluacionIdEvaluacionList = [];

    rubroEvaluacionIdEvaluacionList.add(rubroEvaluacionProcesoData.rubroEvalProcesoId);
    if(rubroEvaluacionProcesoData.tiporubroid == TIPO_RUBRO_BIMENSIONAL){
      var queryRubroDetalle = SQL.select(SQL.rubroEvaluacionProceso).join([
        innerJoin(SQL.rubroEvalRNPFormula, SQL.rubroEvalRNPFormula.rubroEvaluacionSecId.equalsExp(SQL.rubroEvaluacionProceso.rubroEvalProcesoId))
      ]);
      queryRubroDetalle.where(SQL.rubroEvaluacionProceso.estadoId.isNotIn([ESTADO_ELIMINADO]));
      queryRubroDetalle.where(SQL.rubroEvalRNPFormula.rubroEvaluacionPrimId.equals(rubroEvaluacionProcesoData.rubroEvalProcesoId));

      for(var row in await queryRubroDetalle.get()){
    RubroEvaluacionProcesoData rubroEvaluacionProcesoData = row.readTable(SQL.rubroEvaluacionProceso);
    rubroEvaluacionDataList.add(rubroEvaluacionProcesoData);
    rubroEvaluacionIdEvaluacionList.add(rubroEvaluacionProcesoData.rubroEvalProcesoId);
    rubroFormulaDataList.add(row.readTable(SQL.rubroEvalRNPFormula));
    }
    }
    List<String> evaluacionIdList = [];
    List<EvaluacionProcesoData> evaluacionProcesoDataList = await (SQL.select(SQL.evaluacionProceso)..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdEvaluacionList))).get();
    for(var evalaucionUi in evaluacionProcesoDataList){
    if(evalaucionUi.evaluacionProcesoId!=null)evaluacionIdList.add(evalaucionUi.evaluacionProcesoId);
    }
    List<RubroCampotematicoData> rubroCampotematicoDataList = await (SQL.select(SQL.rubroCampotematico)..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdEvaluacionList))).get();
    List<RubroComentarioData> rubroComentarioList = await (SQL.select(SQL.rubroComentario)..where((tbl) => tbl.evaluacionProcesoId.isIn(evaluacionIdList))).get();
    List<ArchivoRubroData> archivoRubroDataList = await (SQL.select(SQL.archivoRubro)..where((tbl) => tbl.evaluacionProcesoId.isIn(evaluacionIdList))).get();
    bERubroEvalEnvioSimple["rubroEvaluacionProceso"] = DataConvert.converRubroEvaluacionProceso(rubroEvaluacionProcesoData);
    bERubroEvalEnvioSimple["rubroEvaluacionAsociado"] = DataConvert.converListRubroEvaluacionProceso(rubroEvaluacionDataList);
    bERubroEvalEnvioSimple["rubroEvalProcesoFormula"] = DataConvert.converListSerializeRubroEvalRNPFormula(rubroFormulaDataList);
    bERubroEvalEnvioSimple["evaluacionProceso"] = DataConvert.converListEvaluacionProceso(evaluacionProcesoDataList);
    bERubroEvalEnvioSimple["rubro_evaluacion_proceso_campotematico"] = DataConvert.converListRubroCampotematico(rubroCampotematicoDataList);
    //bERubroEvalEnvioSimple["obtenerCriterioRubroEvaluacionProceso"] = DataConvert.converListRubroCampotematico(rubroCampotematicoDataList);
    bERubroEvalEnvioSimple["rubroEvaluacionProcesoComentario"] = DataConvert.converListSerializeRubroComentario(rubroComentarioList);
    bERubroEvalEnvioSimple["archivoRubroProceso"] = DataConvert.converListSerializeArchivoRubro(archivoRubroDataList);

    return bERubroEvalEnvioSimple;
  }

  @override
  cambiarEstadoActualizado(String rubroEvaluacionId) async{
    AppDataBase SQL = AppDataBase();
    try{

      RubricaEvaluacionUi rubricaEvaluacionUi = await getRubroEvaluacion(rubroEvaluacionId);
      List<String> rubroEvaluacionIdList = [];
      List<String> evaluacionIdList = [];
      rubroEvaluacionIdList.add(rubroEvaluacionId);
      for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUi.rubrosDetalleList??[]){
        rubroEvaluacionIdList.add(rubricaEvaluacionUi.rubricaId??"");
        for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi.evaluacionUiList??[]){
          evaluacionIdList.add(evaluacionUi.evaluacionId??"");
        }
      }

      for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi.evaluacionUiList??[]){
        evaluacionIdList.add(evaluacionUi.evaluacionId??"");
      }

      await (SQL.update(SQL.rubroEvaluacionProceso)
        ..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdList)))
          .write(
          RubroEvaluacionProcesoCompanion(
            syncFlag: Value(EstadoSync.FLAG_EXPORTED),
          ));

      await (SQL.update(SQL.evaluacionProceso)
        ..where((tbl) => tbl.evaluacionProcesoId.isIn(evaluacionIdList)))
          .write(
          EvaluacionProcesoCompanion(
            syncFlag: Value(EstadoSync.FLAG_EXPORTED),
          ));

    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<Map<String,dynamic>>> getRubroEvalNoEnviadosServidorSerial(int? silaboEventoId, int? calendarioPeriodoId) async {
    AppDataBase SQL = AppDataBase();

    var query = SQL.select(SQL.rubroEvaluacionProceso)..where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
    query.where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    query.where((tbl) => tbl.tiporubroid.isIn([TIPO_RUBRO_BIMENSIONAL, TIPO_RUBRO_UNIDIMENCIONAL]));
    //query.where((tbl) => tbl.tipoFormulaId.isNull());
    query.where((tbl) => tbl.tipoFormulaId.equals(0));
    query.where((tbl) => tbl.estadoId.isNotIn([ESTADO_ELIMINADO]));
    query.where((tbl) => tbl.syncFlag.isIn([EstadoSync.FLAG_ADDED, EstadoSync.FLAG_UPDATED]));

    List<Map<String,dynamic>> listaExportar = [];
    List<RubroEvaluacionProcesoData> rubroEvalProcesoList = await query.get();
    for(RubroEvaluacionProcesoData rubroEvaluacionProcesoData in rubroEvalProcesoList){
      listaExportar.add(await transformarEvaluaciones(SQL, rubroEvaluacionProcesoData));
    }

    return listaExportar;

  }

  @override
  Future<void> updateEvaluacion(RubricaEvaluacionUi? rubricaEvaluacionUi, int? alumnoId, int? usuarioId) async{
    AppDataBase SQL = AppDataBase();

    await SQL.transaction(() async {
      List<EvaluacionUi> evaluacionesList = [];
      List<double> notas = [];
      for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi?.evaluacionUiList??[]){
        notas.add(evaluacionUi.nota??0);
        if(evaluacionUi.alumnoId == alumnoId || alumnoId == null){
          evaluacionesList.add(evaluacionUi);
        }
      }

      await (SQL.update(SQL.rubroEvaluacionProceso)
        ..where((tbl) => tbl.rubroEvalProcesoId.equals(rubricaEvaluacionUi?.rubricaId)))
          .write(
          RubroEvaluacionProcesoCompanion(
            promedio:  Value(AppTools.promedio(notas)),
            desviacionEstandar: Value(AppTools.desviacionEstandar(notas)),
            usuarioAccionId: Value(usuarioId??0,),
            fechaAccion: Value(DateTime.now()),
            syncFlag: Value(EstadoSync.FLAG_UPDATED),
          ));

      for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUi?.rubrosDetalleList??[]){
        List<double> notas = [];
        for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi.evaluacionUiList??[]){
          notas.add(evaluacionUi.nota??0);
          if(evaluacionUi.alumnoId == alumnoId || alumnoId == null){
            evaluacionesList.add(evaluacionUi);
          }
        }

        await (SQL.update(SQL.rubroEvaluacionProceso)
          ..where((tbl) => tbl.rubroEvalProcesoId.equals(rubricaEvaluacionUi.rubricaId)))
            .write(
            RubroEvaluacionProcesoCompanion(
              promedio:  Value(AppTools.promedio(notas)),
              desviacionEstandar: Value(AppTools.desviacionEstandar(notas)),
              usuarioAccionId: Value(usuarioId??0,),
              fechaAccion: Value(DateTime.now()),
              syncFlag: Value(EstadoSync.FLAG_UPDATED),
            ));
      }

      for(EvaluacionUi evaluacionUi in evaluacionesList){
        if(evaluacionUi.evaluacionId == null){
          SQL.batch((batch) async {
            EvaluacionProcesoData evaluacionProcesoData = new EvaluacionProcesoData(
                evaluacionProcesoId: IdGenerator.generateId(),
                usuarioCreacionId: usuarioId,
                fechaCreacion: DateTime.now(),
                usuarioAccionId: usuarioId,
                fechaAccion: DateTime.now(),
                rubroEvalProcesoId: evaluacionUi.rubroEvaluacionId,
                nombres: evaluacionUi.personaUi?.nombres,
                apellidoPaterno: evaluacionUi.personaUi?.apellidoPaterno,
                apellidoMaterno: evaluacionUi.personaUi?.apellidoMaterno,
                foto: evaluacionUi.personaUi?.foto,
                alumnoId: evaluacionUi.personaUi?.personaId,
                calendarioPeriodoId: rubricaEvaluacionUi?.calendarioPeriodoId,
                equipoId: evaluacionUi.equipoId,
                escala: evaluacionUi.escala,
                evaluacionResultadoId: null,
                visto: null,
                valorTipoNotaId: evaluacionUi.valorTipoNotaId,
                msje: null,//Cuando se crea los comentario
                nota: evaluacionUi.nota??0.0,
                sesionAprendizajeId: rubricaEvaluacionUi?.sesionAprendizajeId,
                publicado: evaluacionUi.publicado,
                syncFlag: EstadoSync.FLAG_UPDATED,
            );

            batch.insert(SQL.evaluacionProceso, evaluacionProcesoData, mode: InsertMode.insertOrReplace);
          });
        }else{

          await (SQL.update(SQL.evaluacionProceso)
            ..where((tbl) => tbl.evaluacionProcesoId.equals(evaluacionUi.evaluacionId)))
              .write(
              EvaluacionProcesoCompanion(
                valorTipoNotaId: Value(evaluacionUi.valorTipoNotaId),
                nota: Value(evaluacionUi.nota),
                publicado: Value(evaluacionUi.publicado),
                usuarioAccionId: Value(usuarioId??0,),
                fechaAccion: Value(DateTime.now()),
                syncFlag: Value(EstadoSync.FLAG_UPDATED),
              ));

        }
      }

    });

  }

  @override
  Future<void> eliminarEvaluacion(RubricaEvaluacionUi? rubricaEvaluacionUi, int usuarioId) async {

    AppDataBase SQL = AppDataBase();

    List<String> rubroEvaluacionIdList = [];
    rubroEvaluacionIdList.add(rubricaEvaluacionUi?.rubricaId??"");
    for(RubricaEvaluacionUi rubricaEvaluacionUi in rubricaEvaluacionUi?.rubrosDetalleList??[]){
      rubroEvaluacionIdList.add(rubricaEvaluacionUi.rubricaId??"");
    }
    await (SQL.update(SQL.rubroEvaluacionProceso)
      ..where((tbl) => tbl.rubroEvalProcesoId.isIn(rubroEvaluacionIdList)))
        .write(
        RubroEvaluacionProcesoCompanion(
          estadoId: Value(ESTADO_ELIMINADO),
          usuarioAccionId: Value(usuarioId),
          fechaAccion: Value(DateTime.now()),
          syncFlag: Value(EstadoSync.FLAG_UPDATED),
        ));

  }

}
