import 'package:flutter/cupertino.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/helpers/serelizable/rest_api_response.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/evento.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/evento_persona.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/relaciones_persona.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/estado_sync.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_adjunto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_lista_envio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_youtube_tools.dart';
import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/id_generator.dart';
import 'database/app_database.dart';

class MoorAgendaEventoRepository extends AgendaEventoRepository {
   static const int TIPO_VIDEO = 379, TIPO_VINCULO = 380, TIPO_DOCUMENTO = 397, TIPO_IMAGEN = 398, TIPO_AUDIO = 399, TIPO_HOJA_CALCULO = 400, TIPO_DIAPOSITIVA = 401, TIPO_PDF = 402,  TIPO_YOUTUBE = 581,TIPO_ENCUESTA = 630;
   static const int CONTACTO_DOCENTE = 3, CONTACTO_DIRECTIVO = 4, CONTACTO_ALUMNO = 1, CONTACTO_PADRE = 2, CONTACTO_APODERADO = 5;
  @override
  Future<List<EventoUi>> getEventosAgenda(int usuarioId, int georeferenciaId, int tipoEventoId, int? cargaCursoId) async{
    AppDataBase SQL = AppDataBase();




    var eventoWhere = SQL.select(SQL.evento).join([
      innerJoin(SQL.calendario, SQL.evento.calendarioId.equalsExp(SQL.calendario.calendarioId)),
      leftOuterJoin(SQL.tipoEvento, SQL.evento.tipoEventoId.equalsExp(SQL.tipoEvento.tipoId))
    ]);
    eventoWhere.where(SQL.calendario.usuarioId.equals(usuarioId));
    if(cargaCursoId != null && cargaCursoId > 0){
      eventoWhere.where(SQL.calendario.cargaCursoId.equals(cargaCursoId));
    }
    //eventoWhere.where(SQL.calendario.usuarioId.equals(19));
    eventoWhere.where(SQL.calendario.georeferenciaId.equals(georeferenciaId));
    //eventoWhere.orderBy([ OrderingTerm(expression: SQL.evento.fechaEvento, mode: OrderingMode.desc)]);


    var eventoWhereExterno = SQL.select(SQL.evento).join([
      innerJoin(SQL.calendario, SQL.evento.calendarioId.equalsExp(SQL.calendario.calendarioId)),
      leftOuterJoin(SQL.tipoEvento, SQL.evento.tipoEventoId.equalsExp(SQL.tipoEvento.tipoId)),
      innerJoin(SQL.calendarioListaUsuario, SQL.calendarioListaUsuario.calendarioId.equalsExp(SQL.calendario.calendarioId)),
      innerJoin(SQL.listaUsuarios, SQL.calendarioListaUsuario.listaUsuarioId.equalsExp(SQL.listaUsuarios.listaUsuarioId)),
      innerJoin(SQL.listaUsuarioDetalle, SQL.listaUsuarioDetalle.listaUsuarioId.equalsExp(SQL.listaUsuarios.listaUsuarioId)),
      ]);
    eventoWhereExterno.where(SQL.listaUsuarioDetalle.usuarioId.equals(usuarioId));
    //eventoWhereExterno.where(SQL.listaUsuarioDetalle.usuarioId.equals(19));
    //eventoWhereExterno.orderBy([OrderingTerm(expression: SQL.evento.fechaEvento, mode: OrderingMode.desc)]);
    if(cargaCursoId != null&& cargaCursoId > 0){
      eventoWhereExterno.where(SQL.calendario.cargaCursoId.equals(cargaCursoId));
    }
    if(tipoEventoId>0){
      eventoWhere.where(SQL.evento.tipoEventoId.equals(tipoEventoId));
      eventoWhereExterno.where(SQL.evento.tipoEventoId.equals(tipoEventoId));
    }

    List<EventoUi> eventoUiList = [];
    for(var row in await eventoWhere.get()){
      EventoData eventoData = row.readTable(SQL.evento);
      CalendarioData calendarioData = row.readTable(SQL.calendario);
      TipoEventoData? tipoEventoData = row.readTableOrNull(SQL.tipoEvento);
      EventoUi eventoUi = getAgendaEvento(eventoData, calendarioData, tipoEventoData);
      eventoUi.externo = false;
      await getEventoAdjunto(eventoUi);

      eventoUiList.add(eventoUi);
      print("${eventoUi.id} ${eventoUi.titulo}");
    }
    print("eventoUiListGeneral size: " + eventoUiList.length.toString());
    for(var row in await eventoWhereExterno.get()){
      EventoData eventoData = row.readTable(SQL.evento);
      CalendarioData calendarioData = row.readTable(SQL.calendario);
      TipoEventoData? tipoEventoData = row.readTableOrNull(SQL.tipoEvento);
      EventoUi eventoUiExterno = getAgendaEvento(eventoData, calendarioData, tipoEventoData);
      await getEventoAdjunto(eventoUiExterno);
      eventoUiExterno.externo = true;
      eventoUiList.removeWhere((element) => element.id == eventoData.eventoId);
      eventoUiList.add(eventoUiExterno);
      print("${eventoUiExterno.id} ${eventoUiExterno.titulo}");
    }

    print("eventoUiListDocente size: " + eventoUiList.length.toString());
    return eventoUiList;
  }

  EventoUi getAgendaEvento(EventoData eventoData, CalendarioData calendarioData, TipoEventoData? tipoEventoData){
    EventoUi eventoUi = new EventoUi();
    eventoUi.id = eventoData.eventoId;
    eventoUi.nombreEntidad = eventoData.nombreEntidad;
    eventoUi.fotoEntidad = calendarioData.nFoto;
    eventoUi.nombreCalendario = calendarioData.nombre;
    eventoUi.cargaCursoId = calendarioData.cargaCursoId;
    eventoUi.cargaAcademicaId = calendarioData.cargaAcademicaId;
    eventoUi.cantLike =  eventoData.likeCount;
    eventoUi.titulo = eventoData.titulo;
    eventoUi.descripcion = eventoData.descripcion;
    eventoUi.fecha =  DomainTools.convertDateTimePtBR2(eventoData.fechaEvento, eventoData.horaEvento);
    eventoUi.fechaEvento =  DateTime.fromMillisecondsSinceEpoch(eventoData.fechaEvento??0);

    eventoUi.horaEvento = eventoData.horaEvento;
    eventoUi.foto = eventoData.pathImagen;
    eventoUi.tipoEventoUi = TipoEventoUi();
    eventoUi.tipoEventoUi?.id = eventoData.tipoEventoId;
    eventoUi.tipoEventoUi?.nombre = tipoEventoData?.nombre;
    eventoUi.rolEmisor = calendarioData.cargo;
    eventoUi.nombreEmisor = calendarioData.nUsuario;
    eventoUi.fechaPublicacion = DateTime.fromMillisecondsSinceEpoch(eventoData.fechaPublicacion??0);
    eventoUi.fecaCreacion = DateTime.fromMillisecondsSinceEpoch(eventoData.fechaCreacion??0);
    eventoUi.publicado = eventoData.estadoPublicacion;
    switch(eventoUi.tipoEventoUi?.id??0){
      case 526:
        eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.EVENTO;
        break;
      case 528:
        eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.ACTIVIDAD;
        break;
      case 530:
        eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.CITA;
        break;
      case 529:
        eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.TAREA;
        break;
      case 527:
        eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.NOTICIA;
        break;
      case 620:
        eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.AGENDA;
        break;
      default:
        eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.DEFAULT;
        break;
    }

    return eventoUi;
  }

  @override
  Future<List<TipoEventoUi>> getTiposEvento() async{
    AppDataBase SQL = AppDataBase();
    List<TipoEventoUi> tipoEventoUiList = [];
    var query = SQL.select(SQL.tipoEvento)..where((tbl) => tbl.concepto.equals("TipoEvento"));
    query.where((tbl) => tbl.objeto.equals("T_CE_MOV_EVENTOS"));
    /*EVENTO=526, ACTIVIDAD=528, CITA=530, TAREA=529, NOTICIA=527, AGENDA = 620;
        * */
    List<TipoEventoData> tipos =  await query.get();
    for(TipoEventoData item in tipos){
      TipoEventoUi tipoEventoUi = TipoEventoUi();
      tipoEventoUi.id = item.tipoId;
      tipoEventoUi.nombre = item.nombre;
      switch(item.tipoId){
        case 526:
          tipoEventoUi.tipo = EventoIconoEnumUI.EVENTO;
          break;
        case 528:
          tipoEventoUi.tipo = EventoIconoEnumUI.ACTIVIDAD;
          break;
        case 530:
          tipoEventoUi.tipo = EventoIconoEnumUI.CITA;
          break;
        case 529:
          tipoEventoUi.tipo = EventoIconoEnumUI.TAREA;
          break;
        case 527:
          tipoEventoUi.tipo = EventoIconoEnumUI.NOTICIA;
          break;
        case 620:
          tipoEventoUi.tipo = EventoIconoEnumUI.AGENDA;
          break;
        default:
          tipoEventoUi.tipo = EventoIconoEnumUI.DEFAULT;
          break;
      }

      tipoEventoUiList.add(tipoEventoUi);
    }

    TipoEventoUi tipoEventoUi = TipoEventoUi();
    tipoEventoUi.id = 0;
    tipoEventoUi.nombre = "Todos";
    tipoEventoUi.tipo = EventoIconoEnumUI.TODOS;
    tipoEventoUiList.add(tipoEventoUi);
    print("tipoEventoUiList size: " + tipoEventoUiList.length.toString());
    return tipoEventoUiList;
  }

  @override
  Future<void> saveEventoAgenda(Map<String, dynamic> eventoAgenda, int usuarioId, int anioAcademicoId, int tipoEventoId)async {
    AppDataBase SQL = AppDataBase();
    await SQL.batch((batch) async {

      if(eventoAgenda.containsKey("tipos")){
        batch.deleteWhere(SQL.tipoEvento, (row) => const Constant(true));
        batch.insertAll(SQL.tipoEvento, SerializableConvert.converListSerializeTipoEvento(eventoAgenda["tipos"]), mode: InsertMode.insertOrReplace );
      }

      if(eventoAgenda.containsKey("calendario")){
        batch.deleteWhere(SQL.calendario, (row) => const Constant(true));
        batch.insertAll(SQL.calendario, SerializableConvert.converListSerializeCalendario(eventoAgenda["calendario"])  , mode: InsertMode.insertOrReplace );
      }

      if(eventoAgenda.containsKey("calendarioListaUsuario")){
        batch.deleteWhere(SQL.calendarioListaUsuario, (row) => const Constant(true));
        batch.insertAll(SQL.calendarioListaUsuario, SerializableConvert.converListSerializeCalendarioListaUsuario(eventoAgenda["calendarioListaUsuario"])  , mode: InsertMode.insertOrReplace );
      }

      if(eventoAgenda.containsKey("listaUsuarios")){
        batch.deleteWhere(SQL.listaUsuarios, (row) => const Constant(true));
        batch.insertAll(SQL.listaUsuarios, SerializableConvert.converListSerializeCalendarioListaUsuarios(eventoAgenda["listaUsuarios"])  , mode: InsertMode.insertOrReplace );
      }
      List<String> eventoIdList = [];
      var query = SQL.select(SQL.evento);
      if(tipoEventoId>0){
        query..where((tbl) => tbl.tipoEventoId.equals(tipoEventoId));
      }
      print("Suscesss evetoagenda1");
      for(var eventoData in await query.get()){
        eventoIdList.add(eventoData.eventoId);
      }
      print("Suscesss evetoagenda2");
      if(eventoAgenda.containsKey("eventoPersona")){
        await (SQL.delete(SQL.eventoPersona)..where((tbl) => tbl.eventoId.isIn(eventoIdList))).go();
        batch.insertAll(SQL.eventoPersona, SerializableConvert.converListSerializeEventoPersona(eventoAgenda["eventoPersona"]), mode: InsertMode.insertOrReplace );
      }
      print("Suscesss evetoagenda3");
      if(eventoAgenda.containsKey("eventoAdjuntos")){
        await (SQL.delete(SQL.eventoAdjunto)..where((tbl) => tbl.eventoId.isIn(eventoIdList))).go();
        batch.insertAll(SQL.eventoAdjunto, SerializableConvert.converListSerializeEventoAjunto(eventoAgenda["eventoAdjuntos"]), mode: InsertMode.insertOrReplace );
      }
      print("Suscesss evetoagenda4");
      if(eventoAgenda.containsKey("relaciones")){

        batch.insertAll(SQL.relacionesEvento, SerializableConvert.converListSerializeRelacionesEvento(eventoAgenda["relaciones"]), mode: InsertMode.insertOrReplace );
      }
      print("Suscesss evetoagenda5");
      if(eventoAgenda.containsKey("evento")){

        await (SQL.delete(SQL.evento)..where((tbl) => tbl.eventoId.isIn(eventoIdList))).go();
        batch.insertAll(SQL.evento, SerializableConvert.converListSerializeEvento(eventoAgenda["evento"])  , mode: InsertMode.insertOrReplace );
      }

      print("Suscesss evetoagenda");
      if(eventoAgenda.containsKey("listUsuarioDetalle")){
        batch.deleteWhere(SQL.listaUsuarioDetalle, (row) => const Constant(true));
        batch.insertAll(SQL.listaUsuarioDetalle, SerializableConvert.converListSerializeListaUsuarioDetalle(eventoAgenda["listUsuarioDetalle"]), mode: InsertMode.insertOrReplace );
      }


      if(eventoAgenda.containsKey("usuario")){
        batch.deleteWhere(SQL.usuarioEvento, (row) => const Constant(true));
        batch.insertAll(SQL.usuarioEvento, SerializableConvert.converListSerializeUsuarioEvento(eventoAgenda["usuario"]), mode: InsertMode.insertOrReplace );
      }


      if(eventoAgenda.containsKey("persona")){
        batch.deleteWhere(SQL.personaEvento, (row) => const Constant(true));
        batch.insertAll(SQL.personaEvento, SerializableConvert.converListSerializePersonaEvento(eventoAgenda["persona"]), mode: InsertMode.insertOrReplace );
      }



    });
  }

  Future<void> getEventoAdjunto(EventoUi? eventoUi) async{
    AppDataBase SQL = AppDataBase();
    List<EventoAdjuntoData> eventoAdjuntoDataList = await (SQL.select(SQL.eventoAdjunto)..where((tbl) => tbl.eventoId.equals(eventoUi?.id))).get();
    List<EventoAdjuntoUi> eventoAdjuntoUiEncuestaList = [];
    List<EventoAdjuntoUi> eventoAdjuntoUiDownloadList = [];
    List<EventoAdjuntoUi> eventoAdjuntoUiPreviewList = [];
    List<EventoAdjuntoUi> eventoAdjuntoUiList = [];

/*
    eventoAdjuntoDataList.add(EventoAdjuntoData(
      eventoAdjuntoId: "121",
      titulo: "Mi documento pptx",
      driveId: "19folRaCmWHXfTTY_O46R4xSBSTkx8pKM",
      tipoId: TIPO_DIAPOSITIVA,
      eventoId: eventoUi?.id
    ));
    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "Mi documento pptx",
        driveId: "19folRaCmWHXfTTY_O46R4xSBSTkx8pKM",
        tipoId: TIPO_DIAPOSITIVA,
        eventoId: eventoUi?.id
    ));
    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "Mi documento pptx",
        driveId: "19folRaCmWHXfTTY_O46R4xSBSTkx8pKM",
        tipoId: TIPO_DIAPOSITIVA,
        eventoId: eventoUi?.id
    ));
    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "Mi documento pptx",
        driveId: "19folRaCmWHXfTTY_O46R4xSBSTkx8pKM",
        tipoId: TIPO_DIAPOSITIVA,
        eventoId: eventoUi?.id
    ));
    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "Mi documento pptx",
        driveId: "19folRaCmWHXfTTY_O46R4xSBSTkx8pKM",
        tipoId: TIPO_DIAPOSITIVA,
        eventoId: eventoUi?.id
    ));

    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "Mi documento pptx",
        driveId: "1eBerHlMdqBxSkK-QGWVnjTzLUffZAvx4",
        tipoId: TIPO_IMAGEN,
        eventoId: eventoUi?.id
    ));
    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "Mi documento pptx",
        driveId: "1LIICPqNx3UDquTB-ew0sZ4eRmrWCizJ1",
        tipoId: TIPO_IMAGEN,
        eventoId: eventoUi?.id
    ));
    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "Mi documento.mp4",
        driveId: "16AgweRtjkBvqEu2e8zhnMVSbycyNDW2Y",
        tipoId: TIPO_VIDEO,
        eventoId: eventoUi?.id
    ));
    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "https://www.youtube.com/watch?v=tIDqVU15EBU&ab_channel=POCOY%C3%93enESPA%C3%91OL-CanalOficial",
        driveId: "1LIICPqNx3UDquTB-ew0sZ4eRmrWCizJ1",
        tipoId: TIPO_YOUTUBE,
        eventoId: eventoUi?.id
    ));
    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "Mi documento.mp4",
        driveId: "16AgweRtjkBvqEu2e8zhnMVSbycyNDW2Y",
        tipoId: TIPO_VIDEO,
        eventoId: eventoUi?.id
    ));*/

    for(EventoAdjuntoData eventoAdjuntoData in eventoAdjuntoDataList){
      EventoAdjuntoUi eventoAdjuntoUi = EventoAdjuntoUi();
      eventoAdjuntoUi.eventoAdjuntoId = eventoAdjuntoData.eventoAdjuntoId;
      eventoAdjuntoUi.eventoId = eventoAdjuntoData.eventoId;
      eventoAdjuntoUi.driveId = eventoAdjuntoData.driveId;
      eventoAdjuntoUi.tipoId = eventoAdjuntoData.tipoId;
      eventoAdjuntoUi.titulo = eventoAdjuntoData.titulo;
      switch (eventoAdjuntoUi.tipoId){
        case TIPO_VIDEO:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_VIDEO;
          break;
        case TIPO_VINCULO:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_VINCULO;
          break;
        case TIPO_DOCUMENTO:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_DOCUMENTO;
          break;
        case TIPO_IMAGEN:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_IMAGEN;
          break;
        case TIPO_AUDIO:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_AUDIO;
          break;
        case TIPO_HOJA_CALCULO:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_HOJA_CALCULO;
          break;
        case TIPO_DIAPOSITIVA:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_DIAPOSITIVA;
          break;
        case TIPO_PDF:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_PDF;
          break;
        case TIPO_YOUTUBE:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_VINCULO_YOUTUBE;
          break;
        case TIPO_ENCUESTA:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_ENCUESTA;
          break;
        default:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_VINCULO;//
          break;
      }

      if(eventoAdjuntoUi.tipoRecursosUi==TipoRecursosUi.TIPO_VIDEO){
        String? idYoutube = YouTubeUrlParser.getYoutubeVideoId(eventoAdjuntoUi.titulo);
        if((idYoutube??"").isEmpty){
          eventoAdjuntoUi.imagePreview = "https://drive.google.com/thumbnail?id=${eventoAdjuntoUi.driveId}";
        }else {
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_VINCULO_YOUTUBE;
          eventoAdjuntoUi.imagePreview = YouTubeThumbnail.getUrlFromVideoId(idYoutube,Quality.MEDIUM);
          eventoAdjuntoUi.yotubeId = idYoutube;
        }
      }else if(eventoAdjuntoUi.tipoRecursosUi == TipoRecursosUi.TIPO_VINCULO_YOUTUBE){
        String? idYoutube = YouTubeUrlParser.getYoutubeVideoId(eventoAdjuntoUi.titulo);
        print("idYoutube: ${idYoutube}");
        eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_VINCULO_YOUTUBE;
        eventoAdjuntoUi.imagePreview = YouTubeThumbnail.getUrlFromVideoId(idYoutube,Quality.MEDIUM);
        print("idYoutube: ${eventoAdjuntoUi.imagePreview}");
        eventoAdjuntoUi.yotubeId = idYoutube;
      }else if(eventoAdjuntoUi.tipoRecursosUi == TipoRecursosUi.TIPO_IMAGEN){
        eventoAdjuntoUi.imagePreview = "https://drive.google.com/uc?id=${eventoAdjuntoUi.driveId}";
      }

      if(eventoAdjuntoUi.tipoRecursosUi == TipoRecursosUi.TIPO_IMAGEN ||
          eventoAdjuntoUi.tipoRecursosUi == TipoRecursosUi.TIPO_VIDEO ||
          eventoAdjuntoUi.tipoRecursosUi == TipoRecursosUi.TIPO_VINCULO_YOUTUBE){
        eventoAdjuntoUiPreviewList.add(eventoAdjuntoUi);
      }else if(eventoAdjuntoUi.tipoRecursosUi == TipoRecursosUi.TIPO_ENCUESTA){
        eventoAdjuntoUiEncuestaList.add(eventoAdjuntoUi);
      }else{
        eventoAdjuntoUiDownloadList.add(eventoAdjuntoUi);
      }
      eventoAdjuntoUiList.add(eventoAdjuntoUi);
    }
    eventoUi?.eventoAdjuntoUiList = eventoAdjuntoUiList;
    eventoUi?.eventoAdjuntoUiEncuestaList = eventoAdjuntoUiEncuestaList;
    eventoUi?.eventoAdjuntoUiDownloadList = eventoAdjuntoUiDownloadList;
    eventoUi?.eventoAdjuntoUiPreviewList = eventoAdjuntoUiPreviewList;

    if(eventoUi?.tipoEventoUi == EventoIconoEnumUI.NOTICIA||
        eventoUi?.tipoEventoUi == EventoIconoEnumUI.EVENTO||
        (eventoUi?.tipoEventoUi == EventoIconoEnumUI.AGENDA &&
            (eventoUi?.foto??"").isNotEmpty)){

      if((eventoUi?.foto??"").isNotEmpty){
        EventoAdjuntoUi eventoAdjuntoUi = EventoAdjuntoUi();
        eventoAdjuntoUi.imagePreview = eventoUi?.foto;
        eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_IMAGEN;
        eventoAdjuntoUi.titulo = eventoUi?.titulo;
        eventoUi?.eventoAdjuntoUiPreviewList?.add(eventoAdjuntoUi);
      }

      if((eventoUi?.foto??"").isNotEmpty && (eventoUi?.eventoAdjuntoUiPreviewList?.isNotEmpty??false)){
        eventoUi?.foto = eventoUi.eventoAdjuntoUiPreviewList?[0].imagePreview;
      }
    }



  }

  @override
  Future<List<EventosListaEnvioUi>> getListaAlumnos(int empleadoId) async{
    AppDataBase appSQL = AppDataBase();
    List<EventosListaEnvioUi> eventosListaEnvioUiListTutoria = [];
    List<EventosListaEnvioUi> eventosListaEnvioUiList = [];
    var queryTutor = appSQL.select(appSQL.contactoDocente)..where((tbl) => appSQL.contactoDocente.contratoVigente.equals(true));
    //query..where((tbl) => tbl.a.equals(CONTACTO_ALUMNO));
    queryTutor.where((tbl) => tbl.idEmpleadoTutor.equals(empleadoId));
    //queryTutor.where((tbl) => tbl.cargaCursoId.equals(0));
    queryTutor..where((tbl) => tbl.tipo.equals(CONTACTO_ALUMNO));
    queryTutor.orderBy([(tbl)=> OrderingTerm.asc(tbl.apellidoPaterno), (tbl)=> OrderingTerm.asc(tbl.cursoNombre), (tbl)=> OrderingTerm.asc(tbl.grupoNombre), (tbl)=> OrderingTerm.asc(tbl.programaNombre)]);


    var query = appSQL.select(appSQL.contactoDocente)..where((tbl) => appSQL.contactoDocente.contratoVigente.equals(true));
    //query..where((tbl) => tbl.a.equals(CONTACTO_ALUMNO));
    //queryTutor.where((tbl) => tbl.idEmpleadoTutor.equals(empleadoId));
    query..where((tbl) => tbl.tipo.equals(CONTACTO_ALUMNO));
    query.orderBy([(tbl)=> OrderingTerm.asc(tbl.apellidoPaterno), (tbl)=> OrderingTerm.asc(tbl.cursoNombre), (tbl)=> OrderingTerm.asc(tbl.grupoNombre), (tbl)=> OrderingTerm.asc(tbl.programaNombre)]);


    for(ContactoDocenteData contactoData  in await queryTutor.get()){

      EventosListaEnvioUi? eventosListaTutorUi = eventosListaEnvioUiListTutoria.firstWhereOrNull((element) => element.cargaAdemicaId == contactoData.cargaAcademicaId);
      if(eventosListaTutorUi==null){
        eventosListaTutorUi = EventosListaEnvioUi();
        eventosListaTutorUi.cargaAdemicaId = contactoData.cargaAcademicaId;
        eventosListaTutorUi.empleadoTutorId = contactoData.idEmpleadoTutor;
        eventosListaTutorUi.nombre = "${contactoData.periodoNombre??""} ${contactoData.grupoNombre??""} - ${contactoData.programaNombre??""}";
        eventosListaTutorUi.personasUiList = [];
        eventosListaEnvioUiListTutoria.add(eventosListaTutorUi);
      }

      EventoPersonaUi? eventoPersonaUi = eventosListaTutorUi.personasUiList?.firstWhereOrNull((element) => element.personaId == contactoData.personaId);
      if(eventoPersonaUi == null){
        eventoPersonaUi = EventoPersonaUi();
        eventoPersonaUi.personaUi = PersonaUi();
        eventoPersonaUi.personaUi?.personaId = contactoData.personaId;
        eventoPersonaUi.personaUi?.foto = contactoData.foto;
        eventoPersonaUi.personaUi?.nombreCompleto = '${DomainTools.capitalize(contactoData.apellidoPaterno??"")} ${DomainTools.capitalize(contactoData.apellidoMaterno??"")}, ${DomainTools.capitalize(contactoData.nombres??"")}';
        eventoPersonaUi.personaUi?.nombres = DomainTools.capitalize(contactoData.nombres??"");
        eventoPersonaUi.personaUi?.apellidos  = '${DomainTools.capitalize(contactoData.apellidoPaterno??"")} ${DomainTools.capitalize(contactoData.apellidoMaterno??"")}';
        eventoPersonaUi.personaUi?.apellidoPaterno = DomainTools.capitalize(contactoData.apellidoPaterno??"");
        eventoPersonaUi.personaUi?.apellidoMaterno = DomainTools.capitalize(contactoData.apellidoMaterno??"");
        eventoPersonaUi.personaUi?.telefono = contactoData.celular!=null?contactoData.celular: contactoData.telefono??"";
        eventoPersonaUi.personaUi?.apoderadoUi = await getApoderado(contactoData.personaId);
        eventosListaTutorUi.personasUiList?.add(eventoPersonaUi);
      }

    }

    for(ContactoDocenteData contactoData  in await query.get()){

      EventosListaEnvioUi? eventosListaEnvioUi = eventosListaEnvioUiList.firstWhereOrNull((element) => element.cargaAdemicaId == contactoData.cargaAcademicaId && element.cargaCursoId == contactoData.cargaCursoId);
      if(eventosListaEnvioUi==null){
        eventosListaEnvioUi = EventosListaEnvioUi();
        eventosListaEnvioUi.cargaAdemicaId = contactoData.cargaAcademicaId;
        eventosListaEnvioUi.cargaCursoId = contactoData.cargaCursoId;
        eventosListaEnvioUi.nombre = "${contactoData.cursoNombre} ${contactoData.periodoNombre??""} ${contactoData.grupoNombre??""} - ${contactoData.programaNombre??""}";
        eventosListaEnvioUi.personasUiList = [];
        eventosListaEnvioUiList.add(eventosListaEnvioUi);
      }

      EventoPersonaUi? eventoPersonaUi2 = eventosListaEnvioUi.personasUiList?.firstWhereOrNull((element) => element.personaId == contactoData.personaId);
      if(eventoPersonaUi2 == null){
        eventoPersonaUi2 = EventoPersonaUi();
        eventoPersonaUi2.personaUi = PersonaUi();
        eventoPersonaUi2.personaUi?.personaId = contactoData.personaId;
        eventoPersonaUi2.personaUi?.foto = contactoData.foto;
        eventoPersonaUi2.personaUi?.nombreCompleto = '${DomainTools.capitalize(contactoData.apellidoPaterno??"")} ${DomainTools.capitalize(contactoData.apellidoMaterno??"")}, ${DomainTools.capitalize(contactoData.nombres??"")}';
        eventoPersonaUi2.personaUi?.nombres = DomainTools.capitalize(contactoData.nombres??"");
        eventoPersonaUi2.personaUi?.apellidos  = '${DomainTools.capitalize(contactoData.apellidoPaterno??"")} ${DomainTools.capitalize(contactoData.apellidoMaterno??"")}';
        eventoPersonaUi2.personaUi?.apellidoPaterno = DomainTools.capitalize(contactoData.apellidoPaterno??"");
        eventoPersonaUi2.personaUi?.apellidoMaterno = DomainTools.capitalize(contactoData.apellidoMaterno??"");
        eventoPersonaUi2.personaUi?.telefono = contactoData.celular!=null?contactoData.celular: contactoData.telefono??"";
        eventoPersonaUi2.personaUi?.apoderadoUi = await getApoderado(contactoData.personaId);
        eventosListaEnvioUi.personasUiList?.add(eventoPersonaUi2);
      }

    }


    eventosListaEnvioUiList.sort((o1, o2)=> (o1.nombre??"").compareTo((o2.nombre??"")));
    eventosListaEnvioUiListTutoria.addAll(eventosListaEnvioUiList);

    return eventosListaEnvioUiListTutoria;
  }

  Future<PersonaUi> getApoderado(int personaId)async{
    AppDataBase SQL = AppDataBase();
    List<EventosListaEnvioUi> eventosListaEnvioUiList = [];
    var query = SQL.selectSingle(SQL.contactoDocente)..where((tbl) => SQL.contactoDocente.contratoVigente.equals(true));
    //query..where((tbl) => tbl.a.equals(CONTACTO_ALUMNO));
    query.where((tbl) => tbl.tipo.isIn([CONTACTO_APODERADO]));
    query.where((tbl) => tbl.relacionId.equals(personaId));
    ContactoDocenteData? contactoData = await query.getSingleOrNull();

    PersonaUi personaUi = new PersonaUi();
    personaUi.personaId = contactoData?.personaId;
    personaUi.foto = contactoData?.foto;
    personaUi.nombreCompleto = '${DomainTools.capitalize(contactoData?.apellidoPaterno??"")} ${DomainTools.capitalize(contactoData?.apellidoMaterno??"")}, ${DomainTools.capitalize(contactoData?.nombres??"")}';
    personaUi.nombres = DomainTools.capitalize(contactoData?.nombres??"");
    personaUi.apellidos  = '${DomainTools.capitalize(contactoData?.apellidoPaterno??"")} ${DomainTools.capitalize(contactoData?.apellidoMaterno??"")}';
    personaUi.apellidoPaterno = DomainTools.capitalize(contactoData?.apellidoPaterno??"");
    personaUi.apellidoMaterno = DomainTools.capitalize(contactoData?.apellidoMaterno??"");
    personaUi.contratoVigente =  contactoData?.contratoVigente;
    personaUi.telefono = contactoData?.celular!=null?contactoData?.celular: contactoData?.telefono??"";
    return personaUi;
  }

  @override
  Map<String, dynamic> getEventoDocenteSerial(EventoUi? eventoUi, int usuarioId, int entidadId, int georeferenciaId, bool update) {
    print("update: ${update}");
   Map<String, dynamic> requestMap = Map();
    int countEnvioPadres = 0;
    int countEnvioAlumnos = 0;
    int countEnvioAmbos = 0;
    List<Map<String, dynamic>> eventoPersonas = [];
   List<Map<String, dynamic>> eventoAdjuntos = [];
    for(EventoPersonaUi eventoPersonaUi in eventoUi?.listaEnvioUi?.personasUiList??[]){
      int rolId = 0;
      if((eventoPersonaUi.selectedAlumno??false) || (eventoPersonaUi.selectedPadre??false)){
        if((eventoPersonaUi.selectedAlumno??false) &&  (eventoPersonaUi.selectedPadre??false)){
          rolId = 0;//se envia ambos
          countEnvioAmbos ++;
        }else if(eventoPersonaUi.selectedAlumno??false){
          rolId = 6;
          countEnvioAlumnos ++;
        }else {
          rolId = 5;
          countEnvioPadres ++;
        }
        eventoPersonas.add(DomainTools.removeNull(EventoPersonaSerial(
          eventoPersonaId: null,
          personaId: eventoPersonaUi.personaId,
          eventoId: eventoUi?.id,
          rolId: rolId,
          apoderadoId: eventoPersonaUi.personaUi?.apoderadoUi?.personaId,
        ).toJson()));
      }
    }

    int rolId = 0;
    String nombreCalendario = "";
    bool envioPersonalizado = false;
    if(countEnvioAmbos > 0){
      rolId = 0;
      nombreCalendario = eventoUi?.listaEnvioUi?.nombre??"";
      envioPersonalizado = true;
    }else if(countEnvioAlumnos>0){
      rolId = 6;
      nombreCalendario = "${eventoUi?.listaEnvioUi?.nombre??""} - Alumnos";
      envioPersonalizado = countEnvioAlumnos!=eventoUi?.listaEnvioUi?.personasUiList?.length;
    }else {
      rolId = 5;
      nombreCalendario = "${eventoUi?.listaEnvioUi?.nombre??""} - Padres";
      envioPersonalizado = countEnvioPadres!=eventoUi?.listaEnvioUi?.personasUiList?.length;
    }

    print("envioPersonalizado ${envioPersonalizado} rolId: ${rolId}");
    if(!envioPersonalizado){
      eventoPersonas.clear();
    }

    Map<String, dynamic> evento = DomainTools.removeNull(EventoSerial(
      syncFlag: update? EstadoSync.FLAG_UPDATED: EstadoSync.FLAG_ADDED,
      eventoId: eventoUi?.id,
      titulo: eventoUi?.titulo,
      descripcion: eventoUi?.descripcion,
      fechaEvento: eventoUi?.fechaEvento?.millisecondsSinceEpoch,
      horaEvento: eventoUi?.horaEvento,
      entidadId: entidadId,
      georeferenciaId: georeferenciaId,
      estadoId: update?AgendaEventoRepository.ESTADO_ACTUALIZADO:AgendaEventoRepository.ESTADO_CREADO,
      estadoPublicacion: eventoUi?.publicado??false,
      envioPersonalizado: envioPersonalizado,
      fechaAccion: DateTime.now().millisecondsSinceEpoch,
      fechaCreacion: DateTime.now().millisecondsSinceEpoch,
      usuarioAccionId: usuarioId,
      usuarioCreacionId: usuarioId,
    ).toJson());

    print("salon q: ${eventoUi?.listaEnvioUi?.cargaCursoId}");
    Map<String, dynamic> calendario = DomainTools.removeNull(CalendarioSerial(
      cargaAcademicaId: eventoUi?.listaEnvioUi?.cargaAdemicaId,
      cargaCursoId: eventoUi?.listaEnvioUi?.cargaCursoId,
      rolId: rolId,
      nombre: nombreCalendario,
      nUsuario: null,
      fechaAccion: DateTime.now().millisecondsSinceEpoch,
      fechaCreacion: DateTime.now().millisecondsSinceEpoch,
      usuarioAccionId: usuarioId,
      usuarioCreacionId: usuarioId,

    ).toJson());


   for(EventoAdjuntoUi eventoAdjuntoUi in eventoUi?.eventoAdjuntoUiList??[]){
     int tipoId = 0;
     switch (eventoAdjuntoUi.tipoRecursosUi){
       case TipoRecursosUi.TIPO_VIDEO:
         tipoId = TIPO_VIDEO;
         break;
       case TipoRecursosUi.TIPO_VINCULO:
        tipoId = TIPO_VINCULO;
         break;
       case TipoRecursosUi.TIPO_DOCUMENTO:
         tipoId = TIPO_DOCUMENTO;
         break;
       case TipoRecursosUi.TIPO_IMAGEN:
         tipoId = TIPO_IMAGEN;
         break;
       case TipoRecursosUi.TIPO_AUDIO:
         tipoId = TIPO_AUDIO;
         break;
       case TipoRecursosUi.TIPO_HOJA_CALCULO:
         tipoId = TIPO_HOJA_CALCULO;
         break;
       case TipoRecursosUi.TIPO_DIAPOSITIVA:
         tipoId = TIPO_DIAPOSITIVA;
         break;
       case TipoRecursosUi.TIPO_PDF:
         tipoId = TIPO_PDF;
         break;
       case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
         tipoId = TIPO_YOUTUBE;
         break;
       case TipoRecursosUi.TIPO_ENCUESTA:
         tipoId = TIPO_ENCUESTA;
         break;
       default:
         tipoId = TIPO_VINCULO;
         break;
     }
     
     eventoAdjuntos.add(DomainTools.removeNull(EventoAdjuntoSerial(
         eventoAdjuntoId: eventoAdjuntoUi.eventoAdjuntoId,
         eventoId: eventoUi?.id,
         driveId: eventoAdjuntoUi.driveId,
         tipoId: tipoId,
         titulo: eventoAdjuntoUi.titulo
     ).toJson()));
   }

   requestMap["evento"] = evento;
   requestMap["calendario"] = calendario;
   requestMap["eventoPersonas"] = eventoPersonas;
   requestMap["eventoAdjuntos"] = eventoAdjuntos;
    return requestMap;
  }

  @override
  Future<List<EventosListaEnvioUi>> getListaAlumnosSelecionado(int empleadoId, String enventoId) async{
    List<EventosListaEnvioUi> listEventosListaEventoUi = await getListaAlumnos(empleadoId);
    AppDataBase SQL = AppDataBase();
    var queryCalendario = SQL.selectSingle(SQL.calendario).join([innerJoin(SQL.evento, SQL.evento.calendarioId.equalsExp(SQL.calendario.calendarioId))]);
    queryCalendario.where(SQL.evento.eventoId.equals(enventoId));
    var row = await queryCalendario.getSingleOrNull();

    EventoData? eventoData = row?.readTableOrNull(SQL.evento);
    CalendarioData? calendarioData = row?.readTableOrNull(SQL.calendario);
    int? cargaCursoId = calendarioData?.cargaCursoId;
    int? cargaAcademicaId = calendarioData?.cargaAcademicaId;
    print("cargaCursoId: ${cargaCursoId}");
    print("cargaAcademicaId: ${cargaAcademicaId}");
    var query = SQL.select(SQL.eventoPersona).join([
      innerJoin(SQL.personaEvento, SQL.personaEvento.personaId.equalsExp(SQL.eventoPersona.personaId))
    ]);
    //query.where(SQL.eventoPersona.estado.equals(true));
    //query.where(SQL.eventoPersona.eventoId.equals(enventoId));

    List<EventoPersonaUi>  personasUiSelectedList = [];
    for(var row in await query.get()){
      PersonaEventoData personaData = row.readTable(SQL.personaEvento);
      EventoPersonaData eventoPersonaData = row.readTable(SQL.eventoPersona);
      EventoPersonaUi eventoPersonaUi = EventoPersonaUi();
      eventoPersonaUi.personaUi = PersonaUi();
      eventoPersonaUi.personaUi?.personaId = personaData.personaId;
      eventoPersonaUi.personaUi?.foto = personaData.foto;
      eventoPersonaUi.personaUi?.nombreCompleto = '${DomainTools.capitalize(personaData.apellidoPaterno??"")} ${DomainTools.capitalize(personaData.apellidoMaterno??"")}, ${DomainTools.capitalize(personaData.nombres??"")}';
      eventoPersonaUi.personaUi?.nombres = DomainTools.capitalize(personaData.nombres??"");
      eventoPersonaUi.personaUi?.apellidos  = '${DomainTools.capitalize(personaData.apellidoPaterno??"")} ${DomainTools.capitalize(personaData.apellidoMaterno??"")}';
      eventoPersonaUi.personaUi?.apellidoPaterno = DomainTools.capitalize(personaData.apellidoPaterno??"");
      eventoPersonaUi.personaUi?.apellidoMaterno = DomainTools.capitalize(personaData.apellidoMaterno??"");
      eventoPersonaUi.personaUi?.telefono = personaData.celular!=null?personaData.celular: personaData.telefono??"";
      eventoPersonaUi.personaUi?.apoderadoUi = await getApoderado(personaData.personaId);
      eventoPersonaUi.apoderadoId = eventoPersonaData.apoderadoId;
      print("eventoPersonaUi: ${eventoPersonaUi.personaId}");
      personasUiSelectedList.add(eventoPersonaUi);

    }

    EventosListaEnvioUi? eventosListaEnvioUi = listEventosListaEventoUi.firstWhereOrNull((element) => (element.cargaCursoId??0) == (cargaCursoId??0) && element.cargaAdemicaId == cargaAcademicaId);

    if(eventosListaEnvioUi != null){
      List<EventoPersonaUi>  eventoPersonasUiList = eventosListaEnvioUi.personasUiList??[];

      if(eventoData?.envioPersonalizado??false){

        List<int> personaIdEventoList = [];
        for(EventoPersonaUi eventoPersonaUi in eventoPersonasUiList){
          EventoPersonaUi? eventoPersonaSelectedUi = personasUiSelectedList.firstWhereOrNull((element) => element.personaId == eventoPersonaUi.personaId);
          eventoPersonaUi.selectedAlumno =  eventoPersonaSelectedUi!=null;

          EventoPersonaUi? eventoApoderadoSelectedUi = personasUiSelectedList.firstWhereOrNull((element) => element.apoderadoId == eventoPersonaUi.apoderadoId);
          eventoPersonaUi.selectedPadre =  eventoApoderadoSelectedUi!=null;
          personaIdEventoList.add(eventoPersonaUi.personaId??0);
        }

        var queryRelaciones = SQL.select(SQL.relacionesEvento).join([
          innerJoin(SQL.eventoPersona, SQL.relacionesEvento.personaVinculadaId.equalsExp(SQL.eventoPersona.personaId)),
        ]);
        queryRelaciones.where(SQL.eventoPersona.eventoId.equals(enventoId));
        queryRelaciones.where(SQL.relacionesEvento.personaPrincipalId.isIn(personaIdEventoList));
        for (var row in await queryRelaciones.get()){
          RelacionesEventoData relacionesEventoData = row.readTable(SQL.relacionesEvento);
          for(EventoPersonaUi eventoPersonaUi in eventoPersonasUiList){
            print("relacionesEventoData: ${relacionesEventoData.personaPrincipalId}");
            if(eventoPersonaUi.personaId == relacionesEventoData.personaPrincipalId){
              eventoPersonaUi.selectedPadre = true;
            }
          }
        }

      }else{
        bool seleccionarAllAlumno = calendarioData?.rolId == 6;
        bool seleccionarAllPadres = calendarioData?.rolId == 5;

        for(EventoPersonaUi eventoPersonaUi in eventoPersonasUiList){
          eventoPersonaUi.selectedAlumno = seleccionarAllAlumno;
          eventoPersonaUi.selectedPadre = seleccionarAllPadres;
        }

        //print("seleccionarAllPadres: ${seleccionarAllAlumno.toString()}");
      }



    }else{

      eventosListaEnvioUi = EventosListaEnvioUi();
      eventosListaEnvioUi.nombre = "Desconocido";
      eventosListaEnvioUi.personasUiList = personasUiSelectedList;
      listEventosListaEventoUi.insert(0, eventosListaEnvioUi);
    }

    return listEventosListaEventoUi;
  }


}