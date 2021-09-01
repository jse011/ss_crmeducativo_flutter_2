import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/app_tools.dart';

import 'database/app_database.dart';

class MoorAgendaEventoRepository extends AgendaEventoRepository {
  @override
  Future<List<EventoUi>> getEventosAgenda(int usuarioId, int georeferenciaId, int tipoEventoId) async{
    AppDataBase SQL = AppDataBase();




    var eventoWhere = SQL.select(SQL.evento).join([
      innerJoin(SQL.calendario, SQL.evento.calendarioId.equalsExp(SQL.calendario.calendarioId)),
      leftOuterJoin(SQL.tipoEvento, SQL.evento.tipoEventoId.equalsExp(SQL.tipoEvento.tipoId))
    ]);
    eventoWhere.where(SQL.calendario.usuarioId.equals(usuarioId));
    eventoWhere.where(SQL.calendario.georeferenciaId.equals(georeferenciaId));
    eventoWhere.orderBy([ OrderingTerm(expression: SQL.evento.fechaEvento, mode: OrderingMode.desc)]);


    var eventoWhereExterno = SQL.select(SQL.evento).join([
      innerJoin(SQL.calendario, SQL.evento.calendarioId.equalsExp(SQL.calendario.calendarioId)),
      leftOuterJoin(SQL.tipoEvento, SQL.evento.tipoEventoId.equalsExp(SQL.tipoEvento.tipoId)),
      innerJoin(SQL.calendarioListaUsuario, SQL.calendarioListaUsuario.calendarioId.equalsExp(SQL.calendario.calendarioId)),
      innerJoin(SQL.listaUsuarios, SQL.calendarioListaUsuario.listaUsuarioId.equalsExp(SQL.listaUsuarios.listaUsuarioId)),
      innerJoin(SQL.listaUsuarioDetalle, SQL.listaUsuarioDetalle.listaUsuarioId.equalsExp(SQL.listaUsuarios.listaUsuarioId)),
      ]);
    eventoWhereExterno.where(SQL.listaUsuarioDetalle.usuarioId.equals(usuarioId));
    eventoWhereExterno.orderBy([ OrderingTerm(expression: SQL.evento.fechaEvento, mode: OrderingMode.desc)]);

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
      eventoUiList.add(eventoUi);
    }
    print("eventoUiList size: " + eventoUiList.length.toString());
    for(var row in await eventoWhereExterno.get()){
      EventoData eventoData = row.readTable(SQL.evento);
      CalendarioData calendarioData = row.readTable(SQL.calendario);
      TipoEventoData? tipoEventoData = row.readTableOrNull(SQL.tipoEvento);
      EventoUi eventoUi = getAgendaEvento(eventoData, calendarioData, tipoEventoData);
      eventoUi.externo = true;
      eventoUiList.add(eventoUi);
    }
    print("eventoUiList size: " + eventoUiList.length.toString());
    return eventoUiList;
  }

  EventoUi getAgendaEvento(EventoData eventoData, CalendarioData calendarioData, TipoEventoData? tipoEventoData){
    EventoUi eventoUi = new EventoUi();
    eventoUi.id = eventoData.eventoId;
    eventoUi.nombreEntidad = eventoData.nombreEntidad;
    eventoUi.fotoEntidad = eventoData.fotoEntidad;
    eventoUi.cantLike =  eventoData.likeCount;
    eventoUi.titulo = eventoData.titulo;
    eventoUi.descripcion = eventoData.descripcion;
    eventoUi.fecha =  eventoData.fechaEvento!=null?AppTools.convertDateTimePtBR2(eventoData.fechaEvento, eventoData.horaEvento):null;
    eventoUi.foto = eventoData.pathImagen;
    eventoUi.tipoEventoUi = TipoEventoUi();
    eventoUi.tipoEventoUi?.id = eventoData.tipoEventoId;
    eventoUi.tipoEventoUi?.nombre = tipoEventoData?.nombre;
    eventoUi.rolEmisor = calendarioData.cargo;
    eventoUi.nombreEmisor = calendarioData.nUsuario;

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

      if(eventoAgenda.containsKey("evento")){
        if(tipoEventoId>0){
          var query = SQL.delete(SQL.evento)..where((tbl) => tbl.tipoEventoId.equals(tipoEventoId));
          query.go();
        }else{
          batch.deleteWhere(SQL.evento, (row) => const Constant(true));
        }

        batch.insertAll(SQL.evento, SerializableConvert.converListSerializeEvento(eventoAgenda["evento"])  , mode: InsertMode.insertOrReplace );
      }



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

      if(eventoAgenda.containsKey("eventoPersona")){
        batch.deleteWhere(SQL.eventoPersona, (row) => const Constant(true));
        batch.insertAll(SQL.eventoPersona, SerializableConvert.converListSerializeEventoPersona(eventoAgenda["eventoPersona"]), mode: InsertMode.insertOrReplace );
      }

    });
  }
}