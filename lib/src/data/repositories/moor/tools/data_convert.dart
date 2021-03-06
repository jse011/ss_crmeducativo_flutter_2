import 'package:ss_crmeducativo_2/src/data/helpers/serelizable/rest_api_response.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/database/app_database.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/rubro_evaluacion_proceso_equipo.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';

class DataConvert{
  static Map<String,dynamic> converRubroEvaluacionProceso(RubroEvaluacionProcesoData data){

    return DomainTools.removeNull(RubroEvaluacionProcesoSerial(
        key: data.rubroEvalProcesoId,
        usuarioCreacionId: data.usuarioCreacionId??0,
        fechaCreacion: data.fechaCreacion?.millisecondsSinceEpoch,
        usuarioAccionId: data.usuarioAccionId??0,
        fechaAccion: data.fechaAccion?.millisecondsSinceEpoch,
        rubroEvalProcesoId: data.rubroEvalProcesoId,
        titulo: data.titulo,
        subtitulo: data.subtitulo,
        colorFondo: data.colorFondo,
        mColorFondo: data.mColorFondo??false,
        valorDefecto: data.valorDefecto,
        competenciaId: data.competenciaId??0,
        calendarioPeriodoId: data.calendarioPeriodoId??0,
        anchoColumna: data.anchoColumna,
        ocultarColumna: data.ocultarColumna??false,
        tipoFormulaId: data.tipoFormulaId??0,
        silaboEventoId: data.silaboEventoId??0,
        tipoRedondeoId: data.tipoRedondeoId??0,
        valorRedondeoId: data.valorRedondeoId??0,
        rubroEvalResultadoId: data.rubroEvalResultadoId??0,
        tipoNotaId: data.tipoNotaId,
        sesionAprendizajeId: data.sesionAprendizajeId??0,
        desempenioIcdId: data.desempenioIcdId??0,
        campoTematicoId: data.campoTematicoId??0,
        tipoEvaluacionId: data.tipoEvaluacionId??0,
        estadoId: data.estadoId??0,
        tipoEscalaEvaluacionId: data.tipoEscalaEvaluacionId??0,
        tipoColorRubroProceso: data.tipoColorRubroProceso??0,
        tiporubroid: data.tiporubroid??0,
        formaEvaluacionId: data.formaEvaluacionId??0,
        countIndicador: data.countIndicador??0,
        rubroFormal: data.rubroFormal??0,
        msje: data.msje??0,
        promedio: data.promedio??0.0,
        desviacionEstandar: data.desviacionEstandar??0.0,
        unidadAprendizajeId: data.unidadAprendizajeId??0,
        estrategiaEvaluacionId: data.estrategiaEvaluacionId??0,
        tareaId: data.tareaId,
        resultadoTipoNotaId: data.resultadoTipoNotaId,
        instrumentoEvalId: data.instrumentoEvalId,
        preguntaId: data.preguntaId,
        peso: data.peso,
        syncFlag: data.syncFlag,
        
        error_guardar: data.error_guardar
    ).toJson());

  }

  static List<dynamic> converListRubroEvaluacionProceso(List<dynamic> dataList){
    List<dynamic> items = [];
    for(var item in dataList){
      items.add(converRubroEvaluacionProceso(item));
    }
    return items;
  }

  static Map<String,dynamic> converRubroEvalRNPFormula(RubroEvalRNPFormulaData data){

    return  DomainTools.removeNull(RubroEvalRNPFormulaSerial(
        usuarioCreacionId: data.usuarioCreacionId,
        fechaCreacion: data.fechaCreacion?.millisecondsSinceEpoch,
        usuarioAccionId: data.usuarioAccionId,
        fechaAccion:data.fechaAccion?.millisecondsSinceEpoch,
        rubroFormulaId: data.rubroFormulaId,
        rubroEvaluacionPrimId: data.rubroEvaluacionPrimId,
        rubroEvaluacionSecId: data.rubroEvaluacionSecId,
        peso: data.peso
    ).toJson());
  }

  static List<dynamic> converListSerializeRubroEvalRNPFormula(List<dynamic> dataList){
    List<Map<String,dynamic>> items = [];
    for(var item in dataList){
      items.add(converRubroEvalRNPFormula(item));
    }
    return items;
  }

  static Map<String,dynamic> converEvaluacionProceso(EvaluacionProcesoData data){

    return  DomainTools.removeNull(EvaluacionProcesoSerial(
      usuarioCreacionId: data.usuarioCreacionId,
      fechaCreacion: data.fechaCreacion?.millisecondsSinceEpoch,
      usuarioAccionId: data.usuarioAccionId,
      fechaAccion: data.fechaAccion?.millisecondsSinceEpoch,
      evaluacionProcesoId: data.evaluacionProcesoId,
      rubroEvalProcesoId: data.rubroEvalProcesoId,
      nombres: data.nombres,
      apellidoPaterno: data.apellidoPaterno,
      apellidoMaterno: data.apellidoMaterno,
      foto: data.foto,
      alumnoId: data.alumnoId,
      calendarioPeriodoId: data.calendarioPeriodoId,
      equipoId: data.equipoId,
      escala: data.escala,
      evaluacionResultadoId: data.evaluacionResultadoId,
      visto: data.visto,
      valorTipoNotaId: data.valorTipoNotaId,
      msje: data.msje,
      nota: data.nota??0.0,
      sesionAprendizajeId: data.sesionAprendizajeId,
      publicado: data.publicado,
      syncFlag: data.syncFlag
    ).toJson());
  }

  static List<dynamic> converListEvaluacionProceso(List<dynamic> dataList){
    List<dynamic> items = [];
    for(var item in dataList){
      items.add(converEvaluacionProceso(item));
    }
    return items;
  }

  static Map<String,dynamic> converRubroCampotematico(RubroCampotematicoData data){
    return  DomainTools.removeNull(RubroEvaluacionProcesoCampotematicoSerial(
      usuarioCreacionId: data.usuarioCreacionId,
      fechaCreacion: data.fechaCreacion?.millisecondsSinceEpoch,
      usuarioAccionId: data.usuarioAccionId,
      fechaAccion: data.fechaAccion?.millisecondsSinceEpoch,
      campoTematicoId: data.campoTematicoId,
      rubroEvalProcesoId: data.rubroEvalProcesoId,
    ).toJson());
  }

  static List<dynamic> converListRubroCampotematico( List<dynamic> dataList){
    List<dynamic> items = [];
    for(var item in dataList){
      items.add(converRubroCampotematico(item));
    }
    return items;
  }

  static Map<String,dynamic> converRubroComentario(RubroComentarioData data){
    return  DomainTools.removeNull(RubroEvaluacionProcesoComentarioSerial(
      usuarioCreacionId: data.usuarioCreacionId,
      fechaCreacion: data.fechaCreacion?.millisecondsSinceEpoch,
      usuarioAccionId: data.usuarioAccionId,
      fechaAccion: data.fechaAccion?.millisecondsSinceEpoch,
      evaluacionProcesoId: data.evaluacionProcesoId,
      comentarioId: data.comentarioId,
      descripcion: data.descripcion,
      key: data.evaluacionProcesoComentarioId,
      evaluacionProcesoComentarioId: data.evaluacionProcesoComentarioId,
      delete: data.delete,
    ).toJson());
  }

  static List<dynamic> converListSerializeRubroComentario(List<dynamic> dataList){
    List<dynamic> items = [];
    for(var item in dataList){
      items.add(converRubroComentario(item));
    }
    return items;
  }


  static Map<String,dynamic> converArchivoRubro(ArchivoRubroData data){
    return  DomainTools.removeNull(ArchivosRubroProcesoSerial(
      usuarioCreacionId: data.usuarioCreacionId,
      fechaCreacion:data.fechaCreacion?.millisecondsSinceEpoch,
      usuarioAccionId: data.usuarioAccionId,
      fechaAccion: data.fechaAccion?.millisecondsSinceEpoch,
      evaluacionProcesoId: data.evaluacionProcesoId,
      archivoRubroId: data.archivoRubroId,
      tipoArchivoId: data.tipoArchivoId,
      url: data.url,
      delete: data.delete,
    ).toJson());
  }

  static List<dynamic> converListSerializeArchivoRubro( List<dynamic> dataList){
    List<dynamic> items = [];
    for(var item in dataList){
      items.add(converArchivoRubro(item));
    }
    return items;
  }

  static Map<String,dynamic> converEquipo(Equipo2Data data){
    return  DomainTools.removeNull(EquipoSerial(
      usuarioCreacionId: data.usuarioCreacionId,
      fechaCreacion:data.fechaCreacion?.millisecondsSinceEpoch,
      usuarioAccionId: data.usuarioAccionId,
      fechaAccion: data.fechaAccion?.millisecondsSinceEpoch,
      key: data.equipoId,
      equipoId: data.equipoId,
      grupoEquipoId: data.grupoEquipoId,
      estado: data.estado,
      foto: data.foto,
      orden: data.orden,
      syncFlag: data.syncFlag
    ).toJson());
  }

  static List<dynamic> converListSerializeEquipo( List<dynamic> dataList){
    List<dynamic> items = [];
    for(var item in dataList){
      items.add(converEquipo(item));
    }
    return items;
  }

  static  List<dynamic> converListSerializeEvaluacionProcesoEquipo(List<dynamic> dataList) {
    List<dynamic> items = [];
    for(var item in dataList){
      items.add(converEvaluacionProcesoEquipo(item));
    }
    return items;
  }
  static  Map<String,dynamic> converEvaluacionProcesoEquipo(RubroEvaluacionProcesoEquipoData data) {
    return  DomainTools.removeNull(RubroEvaluacionProcesoEquipoSerial(
      key: data.rubroEvaluacionEquipoId,
      rubroEvaluacionEquipoId: data.rubroEvaluacionEquipoId,
      rubroEvalProcesoId: data.rubroEvalProcesoId,
      equipoId: data.equipoId,
      orden: data.orden,
      nombreEquipo: data.nombreEquipo,
      usuarioCreacionId: data.usuarioCreacionId,
      fechaCreacion: data.fechaCreacion?.millisecondsSinceEpoch,
      usuarioAccionId: data.usuarioAccionId,
      fechaAccion: data.fechaAccion?.millisecondsSinceEpoch,
    ).toJson());
  }

  static  List<dynamic> converListSerializeEvaluacionProcesoIntegrante(List<dynamic> dataList) {
    List<dynamic> items = [];
    for(var item in dataList){
      items.add(converEvaluacionProcesoIntegrante(item));
    }
    return items;
  }

  static Map<String,dynamic> converEvaluacionProcesoIntegrante(RubroEvaluacionProcesoIntegranteData data) {
    return  DomainTools.removeNull(RubroEvaluacionProcesoIntegranteSerial(
      personaId: data.personaId,
      rubroEvaluacionEquipoId: data.rubroEvaluacionEquipoId
    ).toJson());
  }


  static Map<String,dynamic> converEquipoEvaluacion(EquipoEvaluacionData data) {
    return  DomainTools.removeNull(EquipoEvaluacionProcesoSerial(
      key: data.equipoEvaluacionProcesoId,
      equipoEvalProcesoId: data.equipoEvaluacionProcesoId,
      equipoId: data.equipoId,
      rubroEvalProcesoId: data.rubroEvalProcesoId,
      escala: data.escala,
      nota: data.nota,
      sesionAprendizajeId: data.sesionAprendizajeId,
      valorTipoNotaId: data.valorTipoNotaId,
      usuarioCreacionId: data.usuarioCreacionId,
      fechaCreacion: data.fechaCreacion?.millisecondsSinceEpoch,
      usuarioAccionId: data.usuarioAccionId,
      fechaAccion: data.fechaAccion?.millisecondsSinceEpoch,
    ).toJson());
  }

  static  List<dynamic> converListSerializeEquipoEvaluacion(List<dynamic> dataList) {
    List<dynamic> items = [];
    for(var item in dataList){
      items.add(converEquipoEvaluacion(item));
    }
    return items;
  }




}