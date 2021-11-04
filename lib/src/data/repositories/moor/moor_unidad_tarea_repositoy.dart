import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/helpers/serelizable/rest_api_response.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tarea/tarea_unidad.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_archivo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_drive_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_youtube_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/id_generator.dart';


import 'database/app_database.dart';

class MoorUnidadTareaRepository extends UnidadTareaRepository{

  @override
  Future<List<UnidadUi>> getUnidadTarea(int calendarioPeriodoId, int silaboEventoId) async{
    AppDataBase SQL = AppDataBase();

    var queryUnidad = SQL.select(SQL.tareaUnidad)..where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    queryUnidad.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
    queryUnidad.orderBy([
          (u) =>
              OrderingTerm(expression: u.nroUnidad, mode: OrderingMode.desc),
    ]);

    var queryTarea = SQL.select(SQL.tarea)..where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
    queryTarea.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
    queryTarea.where((tbl) => tbl.estadoId.isNotIn([UnidadTareaRepository.ESTADO_ELIMINADO]));
    queryTarea.orderBy([
          (u) =>
          OrderingTerm(expression: u.fechaCreacion, mode: OrderingMode.desc),
    ]);
    List<UnidadUi> unidadUiList = [];
    for(TareaUnidadData tareaUnidadData in await queryUnidad.get()){
      UnidadUi unidadUi = UnidadUi();
      unidadUi.unidadAprendizajeId = tareaUnidadData.unidadAprendizajeId;
      unidadUi.titulo = tareaUnidadData.titulo;
      unidadUi.nroUnidad = tareaUnidadData.nroUnidad;
      unidadUi.silaboEventoId = tareaUnidadData.silaboEventoId;

      unidadUiList.add(unidadUi);
    }
    List<TareaUi> tareaUiList = [];
    for(TareaData tareaData in await queryTarea.get()){
      TareaUi tareaUi = TareaUi();
      tareaUi.tareaId = tareaData.tareaId;
      tareaUi.titulo = tareaData.titulo;
      tareaUi.instrucciones = tareaData.instrucciones;
      tareaUi.rubroEvalProcesoId = tareaData.rubroEvalProcesoId;
      tareaUi.unidadAprendizajeId = tareaData.unidadAprendizajeId;
      if((tareaData.fechaEntrega??"").isNotEmpty){
        tareaUi.fechaEntrega = DomainTools.tiempoFechaCreacionTarea(DomainTools.convertDateTimePtBR(tareaData.fechaEntrega, tareaData.horaEntrega));
        tareaUi.fechaEntregaTime = DomainTools.convertDateTimePtBR(tareaData.fechaEntrega, tareaData.horaEntrega);
      }

      if((tareaUi.fechaEntregaTime?.year??0) <= 2000){
        tareaUi.fechaEntrega = null;
        tareaUi.fechaEntregaTime = null;
      }
      tareaUi.horaTarea = tareaData.horaEntrega;

      print("estadoId 1: ${tareaUi.titulo} ${tareaUi.fechaEntrega}");
      tareaUi.publicado = tareaData.estadoId == UnidadTareaRepository.ESTADO_PUBLICADO;

      tareaUiList.add(tareaUi);
    }


    for(UnidadUi unidadUi in unidadUiList){
      List<TareaUi> tareaUiUnidadList = [];
      for(TareaUi tareaUi in tareaUiList){
        if(tareaUi.unidadAprendizajeId == unidadUi.unidadAprendizajeId){
          tareaUiUnidadList.add(tareaUi);
        }
      }
      unidadUi.tareaUiList = tareaUiUnidadList;
    }

    return unidadUiList;
  }

  @override
  Future<void> saveUnidadTarea(Map<String, dynamic> unidadSesion, int calendarioPeriodoId, int silaboEventoId) async {
    AppDataBase SQL = AppDataBase();
    await SQL.batch((batch) async {
      // functions in a batch don't have to be awaited - just
      // await the whole batch afterwards.

      var query = SQL.delete(SQL.tareaUnidad)..where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
      query.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
      query.go();

      var queryTarea = SQL.delete(SQL.tarea)..where((tbl) => tbl.silaboEventoId.equals(silaboEventoId));
      queryTarea.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeriodoId));
      queryTarea.go();

      if(unidadSesion.containsKey("tarea")){
        print("unidadAprendizaje tarea");
        batch.insertAll(SQL.tarea, SerializableConvert.converListSerializeTarea(unidadSesion["tarea"])  , mode: InsertMode.insertOrReplace );
      }

      print("unidadAprendizaje 1");
      if(unidadSesion.containsKey("unidadAprendizaje")){
        print("unidadAprendizaje 2");
        batch.insertAll(SQL.tareaUnidad, SerializableConvert.converListSerializeTareaUnidad(unidadSesion["unidadAprendizaje"])  , mode: InsertMode.insertOrReplace );
      }



    });

  }

  @override
  Future<void> saveInformacionTarea(String? tareaId, Map<String, dynamic> unidadTarea) async{
    // ignore: non_constant_identifier_names
    AppDataBase SQL = AppDataBase();
    await SQL.batch((batch) async {
      // functions in a batch don't have to be awaited - just
      // await the whole batch afterwards.

      var queryTareaRecurso = SQL.delete(SQL.tareaRecursoDidactico)..where((tbl) => tbl.tareaId.equals(tareaId));
      queryTareaRecurso.go();

      var queryTareaAlumno = SQL.delete(SQL.tareaAlumno)..where((tbl) => tbl.tareaId.equals(tareaId));
      queryTareaAlumno.go();

      var queryTareaAlumnoArchivo = SQL.delete(SQL.tareaAlumnoArchivo)..where((tbl) => tbl.tareaId.equals(tareaId));
      queryTareaAlumnoArchivo.go();

      if(unidadTarea.containsKey("bETareaAlumnos")){
        print("bETareaAlumnos");
        var unidadTareaAlumnos = unidadTarea["bETareaAlumnos"];
        batch.insertAll(SQL.tareaAlumno, SerializableConvert.converListSerializeTareaAlumno(unidadTareaAlumnos)  , mode: InsertMode.insertOrReplace );
        Iterable l = unidadTareaAlumnos;
        for(Map<String, dynamic> item in l){
          if(item.containsKey("archivos")){
            batch.insertAll(SQL.tareaAlumnoArchivo, SerializableConvert.converListSerializeTareaAlumnoArchivo(item["archivos"])  , mode: InsertMode.insertOrReplace );
          }
        }

      }

      if(unidadTarea.containsKey("recursoDidacticos")){
        print("recursoDidacticos");
        batch.insertAll(SQL.tareaRecursoDidactico, SerializableConvert.converListSerializeTareaRecursoDidactico(unidadTarea["recursoDidacticos"])  , mode: InsertMode.insertOrReplace );
      }



    });
  }

  @override
  Future<List<TareaRecusoUi>> getRecursosTarea(String? tareaId) async {
    AppDataBase SQL = AppDataBase();
    List<TareaRecusoUi> tareaRecursosUiList = [];

    var query= SQL.select(SQL.tareaRecursoDidactico)..where((tbl) => tbl.tareaId.equals(tareaId));
    query.where((tbl) => tbl.estado.equals(1));
    query.orderBy([
          (u) =>
          OrderingTerm(expression: u.fechaCreacion, mode: OrderingMode.desc),
    ]);

    for(TareaRecursoDidacticoData item in await query.get()){
      String? url = (item.url??"").isEmpty? item.descripcion:  item.url;

      TareaRecusoUi tareaRecusoUi = TareaRecusoUi();
      tareaRecusoUi.recursoDidacticoId = item.recursoDidacticoId;
      switch(item.tipoId) {
        case UnidadTareaRepository.TIPO_RECURSO_AUDIO:
          tareaRecusoUi.tipoRecurso = TipoRecursosUi.TIPO_AUDIO;
          break;
        case UnidadTareaRepository.TIPO_RECURSO_DIAPOSITIVA:
          tareaRecusoUi.tipoRecurso = TipoRecursosUi.TIPO_DIAPOSITIVA;
          break;
        case UnidadTareaRepository.TIPO_RECURSO_DOCUMENTO:
          tareaRecusoUi.tipoRecurso = TipoRecursosUi.TIPO_DOCUMENTO;
          break;
        case UnidadTareaRepository.TIPO_RECURSO_HOJA_CALUCLO:
          tareaRecusoUi.tipoRecurso = TipoRecursosUi.TIPO_HOJA_CALCULO;
          break;
        case UnidadTareaRepository.TIPO_RECURSO_IMAGEN:
          tareaRecusoUi.tipoRecurso = TipoRecursosUi.TIPO_IMAGEN;
          break;
        case UnidadTareaRepository.TIPO_RECURSO_PDF:
          tareaRecusoUi.tipoRecurso = TipoRecursosUi.TIPO_PDF;
          break;
        case UnidadTareaRepository.TIPO_RECURSO_VIDEO:
          tareaRecusoUi.tipoRecurso = TipoRecursosUi.TIPO_VIDEO;
          break;
        case UnidadTareaRepository.TIPO_RECURSO_VINCULO:
          tareaRecusoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO;
          String? idYoutube = YouTubeUrlParser.getYoutubeVideoId(url);
          String? idDrive = DriveUrlParser.getDocumentId(url);
          if((idYoutube??"").isNotEmpty){
            tareaRecusoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO_YOUTUBE;
          }else if((idDrive??"").isNotEmpty){
            tareaRecusoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO_DRIVE;
          }else{
            tareaRecusoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO;
          }
          break;
        case UnidadTareaRepository.TIPO_RECURSO_YOUTUBE:
          tareaRecusoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO_YOUTUBE;
          break;
        case UnidadTareaRepository.TIPO_RECURSO_MATERIALES:
          tareaRecusoUi.tipoRecurso = TipoRecursosUi.TIPO_RECURSO;
          break;
        default:
          tareaRecusoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO;
          break;
      }
      tareaRecusoUi.descripcion = item.descripcion;
      tareaRecusoUi.driveId = item.driveId;
      tareaRecusoUi.titulo = item.titulo;
      tareaRecusoUi.url = item.url;
      tareaRecusoUi.silaboEventoId = item.silaboEventoId;
      tareaRecursosUiList.add(tareaRecusoUi);
    }

    return tareaRecursosUiList;
  }

  @override
  Future<List<TareaAlumnoUi>> getTareaAlumnos(String? tareaId) async {
    List<TareaAlumnoUi> tareaAlumnoUiList = [];
    AppDataBase SQL = AppDataBase();
    var query= SQL.select(SQL.tareaAlumno)..where((tbl) => tbl.tareaId.equals(tareaId));

    List<TareaAlumnoArchivoData> tareaAlumnoArchivoList = await (SQL.select(SQL.tareaAlumnoArchivo)
            ..where((tbl) => tbl.tareaId.equals(tareaId))).get();

    for(TareaAlumnoData tareaAlumnoData in await query.get()){
      TareaAlumnoUi tareaAlumnoUi = TareaAlumnoUi();
      tareaAlumnoUi.entregado = tareaAlumnoData.entregado;
      tareaAlumnoUi.fechaServidor = tareaAlumnoData.fechaServidor;
      tareaAlumnoUi.fechaEntrega = tareaAlumnoData.fechaEntrega;
      tareaAlumnoUi.alumnoId = tareaAlumnoData.alumnoId;
      tareaAlumnoUi.tareaId = tareaAlumnoData.tareaId;
      tareaAlumnoUi.valorTipoNotaId = tareaAlumnoData.valorTipoNotaId;
      List<TareaAlumnoArchivoUi> tareaAlumnoArchivoUiList = [];
      for(TareaAlumnoArchivoData tareaAlumnoArchivoData in tareaAlumnoArchivoList){
        if(tareaAlumnoArchivoData.tareaId == tareaAlumnoData.tareaId && tareaAlumnoArchivoData.alumnoId == tareaAlumnoData.alumnoId){
          TareaAlumnoArchivoUi tareaAlumnoArchivoUi = TareaAlumnoArchivoUi();
          tareaAlumnoArchivoUi.tareaAlumnoArchivoId = tareaAlumnoArchivoData.tareaAlumnoArchivoId;
          tareaAlumnoArchivoUi.alumnoId = tareaAlumnoArchivoData.alumnoId;
          tareaAlumnoArchivoUi.tareaId = tareaAlumnoArchivoData.tareaId;
          tareaAlumnoArchivoUi.nombre = tareaAlumnoArchivoData.nombre;
          tareaAlumnoArchivoUi.url = tareaAlumnoArchivoData.path;
          tareaAlumnoArchivoUi.repositorio = tareaAlumnoArchivoData.repositorio;
          if(tareaAlumnoArchivoUi.repositorio??false){
            tareaAlumnoArchivoUi.tipoRecurso = DomainTools.getType(tareaAlumnoArchivoData.path);

          }else{
            String? idYoutube = YouTubeUrlParser.getYoutubeVideoId(tareaAlumnoArchivoData.path);
            String? idDrive = DriveUrlParser.getDocumentId(tareaAlumnoArchivoData.path);
            if((idYoutube??"").isNotEmpty){
              tareaAlumnoArchivoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO_YOUTUBE;
            }else if((idDrive??"").isNotEmpty){
              tareaAlumnoArchivoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO_DRIVE;
            }else{
              tareaAlumnoArchivoUi.tipoRecurso = TipoRecursosUi.TIPO_VINCULO;
            }
          }
          tareaAlumnoArchivoUiList.add(tareaAlumnoArchivoUi);
        }
      }
      tareaAlumnoUi.archivos = tareaAlumnoArchivoUiList;
      print("tareaAlumnoUi.archivos: ${tareaAlumnoUi.archivos?.length}");
      tareaAlumnoUiList.add(tareaAlumnoUi);
    }
    return tareaAlumnoUiList;
  }

  @override
  Map<String, dynamic> getTareaDosenteSerial(TareaUi tareaUi, int usuarioId) {

    Map<String, dynamic> tarea = DomainTools.removeNull(TareaSerial(
      tareaId: tareaUi.tareaId,
      titulo: tareaUi.titulo,
      instrucciones: tareaUi.instrucciones,
      unidadAprendizajeId: tareaUi.unidadAprendizajeId,
      sesionAprendizajeId: tareaUi.sesionAprendizajeId,
      fechaEntrega: tareaUi.fechaEntregaTime?.millisecondsSinceEpoch,
      horaEntrega: tareaUi.horaTarea,
      estadoId: (tareaUi.publicado??false)?UnidadTareaRepository.ESTADO_PUBLICADO : UnidadTareaRepository.ESTADO_CREADO,

      fechaAccion: DateTime.now().millisecondsSinceEpoch,
      fechaCreacion: DateTime.now().millisecondsSinceEpoch,
      usuarioAccionId: usuarioId,
      usuarioCreacionId: usuarioId,

    ).toJson());

    List<Map<String, dynamic>> recursoDidactico = [];
    for(TareaRecusoUi tareaRecusoUi in tareaUi.recursos??[]){
      recursoDidactico.add(DomainTools.removeNull(TareaRecursoDidacticoSerial(
          recursoDidacticoId: (tareaRecusoUi.recursoDidacticoId??"").isNotEmpty ? tareaRecusoUi.recursoDidacticoId : IdGenerator.generateId(),
          titulo: tareaRecusoUi.titulo,
          descripcion: tareaRecusoUi.descripcion,
          tareaId: tareaUi.tareaId,
          url: tareaRecusoUi.url,
          tipoId: getTipoId(tareaRecusoUi.tipoRecurso??TipoRecursosUi.TIPO_RECURSO),
          driveId: tareaRecusoUi.driveId,
          silaboEventoId: tareaRecusoUi.silaboEventoId,

        fechaAccion: DateTime.now().millisecondsSinceEpoch,
        fechaCreacion: DateTime.now().millisecondsSinceEpoch,
        usuarioAccionId: usuarioId,
        usuarioCreacionId: usuarioId,
      ).toJson()));
    }


    tarea["tareasRecursosList"] = recursoDidactico;

    return tarea;

  }

  int getTipoId(TipoRecursosUi tipoRecursosUi){

    switch(tipoRecursosUi){

      case TipoRecursosUi.TIPO_VIDEO:
        return UnidadTareaRepository.TIPO_RECURSO_VIDEO;
      case TipoRecursosUi.TIPO_VINCULO:
        return UnidadTareaRepository.TIPO_RECURSO_VINCULO;
      case TipoRecursosUi.TIPO_DOCUMENTO:
        return UnidadTareaRepository.TIPO_RECURSO_DOCUMENTO;
      case TipoRecursosUi.TIPO_IMAGEN:
        return UnidadTareaRepository.TIPO_RECURSO_IMAGEN;
      case TipoRecursosUi.TIPO_AUDIO:
        return UnidadTareaRepository.TIPO_RECURSO_AUDIO;
      case TipoRecursosUi.TIPO_HOJA_CALCULO:
        return UnidadTareaRepository.TIPO_RECURSO_HOJA_CALUCLO;
      case TipoRecursosUi.TIPO_DIAPOSITIVA:
        return UnidadTareaRepository.TIPO_RECURSO_DIAPOSITIVA;
      case TipoRecursosUi.TIPO_PDF:
        return UnidadTareaRepository.TIPO_RECURSO_PDF;
      case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
        return UnidadTareaRepository.TIPO_RECURSO_YOUTUBE;
      case TipoRecursosUi.TIPO_VINCULO_DRIVE:
        return UnidadTareaRepository.TIPO_RECURSO_VINCULO;
      case TipoRecursosUi.TIPO_RECURSO:
        return UnidadTareaRepository.TIPO_RECURSO_MATERIALES;
      case TipoRecursosUi.TIPO_ENCUESTA:
        return UnidadTareaRepository.TIPO_RECURSO_MATERIALES;
        break;
    }
  }

  @override
  Future<void> saveSesionTarea(Map<String, dynamic> unidadTareaSesion, int calendarioPeriodoId, int silaboEventoId, int sesionAprendizajeId) async{
    AppDataBase SQL = AppDataBase();
    await SQL.batch((batch) async {
      // functions in a batch don't have to be awaited - just
      // await the whole batch afterwards.

      var queryTarea = SQL.delete(SQL.tarea)..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId));
      queryTarea.go();

      if(unidadTareaSesion.containsKey("tarea")){
        batch.insertAll(SQL.tarea, SerializableConvert.converListSerializeTarea(unidadTareaSesion["tarea"])  , mode: InsertMode.insertOrReplace );
      }

      /*if(unidadTareaSesion.containsKey("unidadAprendizaje")){
        batch.insertAll(SQL.tareaUnidad, SerializableConvert.converListSerializeTareaUnidad(unidadTareaSesion["unidadAprendizaje"])  , mode: InsertMode.insertOrReplace );
      }*/



    });
  }

  @override
  Future<List<TareaUi>> getSesionTarea(int calendarioPeriodoId, int silaboEventoId, int sesionAprendizajeId) async{
    AppDataBase SQL = AppDataBase();

    var queryTarea = SQL.select(SQL.tarea)..where((tbl) => tbl.sesionAprendizajeId.equals(sesionAprendizajeId));
    queryTarea.where((tbl) => tbl.estadoId.isNotIn([UnidadTareaRepository.ESTADO_ELIMINADO]));
    queryTarea.orderBy([
          (u) =>
          OrderingTerm(expression: u.fechaCreacion, mode: OrderingMode.desc),
    ]);

    List<TareaUi> tareaUiList = [];
    for(TareaData tareaData in await queryTarea.get()){
      TareaUi tareaUi = TareaUi();
      tareaUi.tareaId = tareaData.tareaId;
      tareaUi.titulo = tareaData.titulo;
      tareaUi.instrucciones = tareaData.instrucciones;
      tareaUi.rubroEvalProcesoId = tareaData.rubroEvalProcesoId;
      tareaUi.unidadAprendizajeId = tareaData.unidadAprendizajeId;
      if((tareaData.fechaEntrega??"").isNotEmpty){
        print("fechaEntrega: ${tareaData.fechaEntrega}");
        tareaUi.fechaEntrega = DomainTools.tiempoFechaCreacionTarea(DomainTools.convertDateTimePtBR(tareaData.fechaEntrega, tareaData.horaEntrega));
        tareaUi.fechaEntregaTime = DomainTools.convertDateTimePtBR(tareaData.fechaEntrega, tareaData.horaEntrega);
      }
      if((tareaUi.fechaEntregaTime?.year??0) <= 2000){
        tareaUi.fechaEntrega = null;
        tareaUi.fechaEntregaTime = null;
      }
      tareaUi.horaTarea = tareaData.horaEntrega;

      print("estadoId 1: ${tareaData.titulo} ${tareaData.estadoId}");

      tareaUi.publicado = tareaData.estadoId == UnidadTareaRepository.ESTADO_PUBLICADO;

      tareaUiList.add(tareaUi);
    }

    return tareaUiList;
  }

  @override
  Future<void> saveEstadoTareaDocente(TareaUi? tareaUi, int estadoId) async{
    AppDataBase SQL = AppDataBase();

    await (SQL.update(SQL.tarea)
      ..where((tbl) => tbl.tareaId.equals(tareaUi?.tareaId)))
        .write(
        TareaCompanion(
          estadoId: Value(estadoId)
        ));
  }


}