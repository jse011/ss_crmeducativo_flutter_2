import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/helpers/serelizable/rest_api_response.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/database/app_database.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/grupo/grupo_equipo_2.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/grupo/integrante_equipo_2.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/estado_sync.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/integrante_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/lista_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/grupo_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/id_generator.dart';
import 'package:collection/collection.dart';

class MoorGrupoRepository extends GrupoRepository{
   static int GRUPOEQUIPO_CREADO = 319, GRUPOEQUIPO_ACTUALIZADO = 320, GRUPOEQUIPO_ELIMINADO = 321;
   static int TIPO_DINAMICO = 449, TIPO_ESTATICO = 446;
   static int EQUIPO_CREADO = 322, EQUIPO_ACTUALIZADO = 323, EQUIPO_ELIMINADO = 324;

  @override
  Future<Map<String, dynamic>> transformarListaGrupos(ListaGrupoUi? listaGrupoUi, int usuarioId, int empleadoId) async{
    Map<String, dynamic> bEDatosEnvioGrupo = Map();

    List<dynamic> grupoEquipoListSerial = [];
    List<dynamic> equipoListSerial = [];
    List<dynamic> equipoIntegranteSerial = [];

    AppDataBase SQL = AppDataBase();
    GrupoEquipo2Data? grupoEquipoData = await (SQL.selectSingle(SQL.grupoEquipo2)..where((tbl) => tbl.grupoEquipoId.equals(listaGrupoUi?.grupoEquipoId))).getSingleOrNull();
    if(grupoEquipoData==null){
      grupoEquipoListSerial.add(DomainTools.removeNull(GrupoEquipoSerial(
          grupoEquipoId: listaGrupoUi?.grupoEquipoId,
          key: listaGrupoUi?.grupoEquipoId,
          cargaAcademicaId: listaGrupoUi?.cargaAcademicaId,
          cargaCursoId: listaGrupoUi?.cargaCursoId,
          docenteId: empleadoId,
          color1: listaGrupoUi?.color1,
          color2: listaGrupoUi?.color2,
          color3: listaGrupoUi?.color3,
          estado: MoorGrupoRepository.GRUPOEQUIPO_CREADO,
          cursoNombre: listaGrupoUi?.nombreCurso,
          nombre: listaGrupoUi?.nombre,
          tipoId: (listaGrupoUi?.modoAletorio??false)?TIPO_DINAMICO: TIPO_ESTATICO,
          fechaAccion: DateTime.now().millisecondsSinceEpoch,
          fechaCreacion: DateTime.now().millisecondsSinceEpoch,
          usuarioCreacionId: usuarioId,
          usuarioAccionId: usuarioId,
          syncFlag: EstadoSync.FLAG_ADDED
      ).toJson()));
    }else{

      grupoEquipoListSerial.add(DomainTools.removeNull(GrupoEquipoSerial(
          grupoEquipoId: grupoEquipoData.grupoEquipoId,
          key: grupoEquipoData.grupoEquipoId,
          cargaAcademicaId: grupoEquipoData.cargaAcademicaId,
          cargaCursoId: grupoEquipoData.cargaCursoId,
          docenteId: empleadoId,
          color1: listaGrupoUi?.color1,
          color2: listaGrupoUi?.color2,
          color3: listaGrupoUi?.color3,
          estado:( listaGrupoUi?.remover??false)?MoorGrupoRepository.GRUPOEQUIPO_ELIMINADO:MoorGrupoRepository.GRUPOEQUIPO_ACTUALIZADO,
          cursoNombre: listaGrupoUi?.nombreCurso,
          nombre: listaGrupoUi?.nombre,
          tipoId: (listaGrupoUi?.modoAletorio??false)?TIPO_DINAMICO: TIPO_ESTATICO,
          fechaAccion: DateTime.now().millisecondsSinceEpoch,
          fechaCreacion: grupoEquipoData.fechaCreacion?.millisecondsSinceEpoch,
          usuarioCreacionId: grupoEquipoData.usuarioCreacionId,
          usuarioAccionId: usuarioId,
          syncFlag: EstadoSync.FLAG_UPDATED
      ).toJson()));
    }

    List<Equipo2Data> equipoDataList = await (SQL.selectSingle(SQL.equipo2)..where((tbl) => tbl.grupoEquipoId.equals(listaGrupoUi?.grupoEquipoId))).get();
    print("equipoDataList: ${equipoDataList.length}");
    for(GrupoUi grupoUi in listaGrupoUi?.grupoUiList??[]){
      Equipo2Data? equipoData = equipoDataList.firstWhereOrNull((element) => element.equipoId == grupoUi.equipoId);
      if(equipoData==null){
        equipoListSerial.add(DomainTools.removeNull(EquipoSerial(
            key: grupoUi.equipoId,
            equipoId: grupoUi.equipoId,
            grupoEquipoId: listaGrupoUi?.grupoEquipoId,
            nombre: grupoUi.nombre,
            foto: "",
            orden: grupoUi.posicion,
            estado: MoorGrupoRepository.EQUIPO_CREADO,
            fechaAccion: DateTime.now().millisecondsSinceEpoch,
            fechaCreacion: DateTime.now().millisecondsSinceEpoch,
            usuarioCreacionId: usuarioId,
            usuarioAccionId: usuarioId,
            syncFlag: EstadoSync.FLAG_ADDED
        ).toJson()));
      }else{
        equipoDataList.remove(equipoData);
        equipoListSerial.add(DomainTools.removeNull(EquipoSerial(
            key: equipoData.equipoId,
            equipoId: equipoData.equipoId,
            grupoEquipoId: equipoData.grupoEquipoId,
            nombre: grupoUi.nombre,
            foto: "",
            orden: grupoUi.posicion,
            estado: MoorGrupoRepository.EQUIPO_ACTUALIZADO,
            fechaAccion: DateTime.now().millisecondsSinceEpoch,
            fechaCreacion: equipoData.fechaCreacion?.millisecondsSinceEpoch,
            usuarioCreacionId: equipoData.usuarioCreacionId,
            usuarioAccionId: usuarioId,
            syncFlag: EstadoSync.FLAG_ADDED
        ).toJson()));
      }

      List<IntegranteEquipo2Data> integranteDataList = await (SQL.selectSingle(SQL.integranteEquipo2)..where((tbl) => tbl.equipoId.equals(grupoUi.equipoId))).get();

      for(IntegranteGrupoUi integranteUi in grupoUi.integranteUiList??[]){

        IntegranteEquipo2Data? integranteData = integranteDataList.firstWhereOrNull((element) => element.equipoIntegranteId == integranteUi.equipoIntegranteId);
        if(integranteData==null){

          equipoIntegranteSerial.add(DomainTools.removeNull(IntegranteEquipoSerial(
              key: integranteUi.equipoIntegranteId,
              equipoIntegranteId: integranteUi.equipoIntegranteId,
              equipoId: grupoUi.equipoId,
              foto: integranteUi.personaUi?.foto,
              alumnoId: integranteUi.personaUi?.personaId,
              nombre: integranteUi.personaUi?.nombreCompleto,
              fechaAccion: DateTime.now().millisecondsSinceEpoch,
              fechaCreacion: DateTime.now().millisecondsSinceEpoch,
              usuarioCreacionId: usuarioId,
              usuarioAccionId: usuarioId,
              syncFlag: EstadoSync.FLAG_ADDED
          ).toJson()));
        }else{

          equipoIntegranteSerial.add(DomainTools.removeNull(IntegranteEquipoSerial(
              key: integranteData.equipoIntegranteId,
              equipoIntegranteId: integranteData.equipoIntegranteId,
              equipoId: grupoUi.equipoId,
              foto: integranteUi.personaUi?.foto,
              alumnoId: integranteUi.personaUi?.personaId,
              nombre: integranteUi.personaUi?.nombreCompleto,
              fechaAccion: DateTime.now().millisecondsSinceEpoch,
              fechaCreacion: integranteData.fechaCreacion?.millisecondsSinceEpoch,
              usuarioCreacionId: integranteData.usuarioCreacionId,
              usuarioAccionId: usuarioId,
              syncFlag: EstadoSync.FLAG_UPDATED
          ).toJson()));
        }

      }

    }
    print("equipoDataList2: ${equipoDataList.length}");
    for(Equipo2Data equipodata in equipoDataList){
      equipoListSerial.add(DomainTools.removeNull(EquipoSerial(
          key: equipodata.equipoId,
          equipoId: equipodata.equipoId,
          grupoEquipoId: equipodata.grupoEquipoId,
          nombre: equipodata.nombre,
          foto: "",
          orden: equipodata.orden,
          estado: MoorGrupoRepository.EQUIPO_ELIMINADO,
          fechaAccion: DateTime.now().millisecondsSinceEpoch,
          fechaCreacion: equipodata.fechaCreacion?.millisecondsSinceEpoch,
          usuarioCreacionId: equipodata.usuarioCreacionId,
          usuarioAccionId: usuarioId,
          syncFlag: EstadoSync.FLAG_UPDATED
      ).toJson()));
    }



    bEDatosEnvioGrupo["grupo_equipo"] = grupoEquipoListSerial;
    bEDatosEnvioGrupo["equipo"] = equipoListSerial;
    bEDatosEnvioGrupo["equipo_integrante"] = equipoIntegranteSerial;

    return bEDatosEnvioGrupo;
    /*
    //mapGrupoEvaluacion.
    //mapGrupoEvaluacion.
    AppDataBase SQL = AppDataBase();
    await SQL.batch((batch) async {


      batch.deleteWhere(SQL.usuario, (row) => const Constant(true));
      batch.deleteWhere(SQL.persona, (row) => const Constant(true));

      UsuarioData usuarioData = UsuarioData.fromJson(datosUsuario);
      batch.insert(SQL.usuario, usuarioData);
      print("usuariojse: ${usuarioData}");
      if(datosUsuario.containsKey("persona")){
        PersonaData personaUpdate = SerializableConvert.converSerializePersona(datosUsuario["persona"]);
        print("usuariojse2: ${personaUpdate}");
        batch.insert(SQL.persona, personaUpdate);
      }



      if(datosUsuario.containsKey("entidades")){
        //personaSerelizable.addAll(datosInicioPadre["usuariosrelacionados"]);
        //database.personaDao.insertAllTodo(SerializableConvert.converListSerializePersona(datosInicioPadre["personas"]));
        batch.deleteWhere(SQL.entidad, (row) => const Constant(true));
        batch.insertAll(SQL.entidad, SerializableConvert.converListSerializeEntidad(datosUsuario["entidades"]), mode: InsertMode.insertOrReplace);
      }

      if(datosUsuario.containsKey("georeferencias")){
        batch.deleteWhere(SQL.georeferencia, (row) => const Constant(true));
        batch.insertAll(SQL.georeferencia, SerializableConvert.converListSerializeGeoreferencia(datosUsuario["georeferencias"]), mode: InsertMode.insertOrReplace );
      }

      if(datosUsuario.containsKey("roles")){
        //personaSerelizable.addAll(datosInicioPadre["usuariosrelacionados"]);
        batch.deleteWhere(SQL.rol, (row) => const Constant(true));
        batch.insertAll(SQL.rol, SerializableConvert.converListSerializeRol(datosUsuario["roles"]), mode: InsertMode.insertOrReplace);
      }
      print("usuariojse usuarioRolGeoreferencias");
      if(datosUsuario.containsKey("usuarioRolGeoreferencias")){
        //personaSerelizable.addAll(datosInicioPadre["usuariosrelacionados"]);
        batch.deleteWhere(SQL.usuarioRolGeoreferencia, (row) => const Constant(true));
        batch.insertAll(SQL.usuarioRolGeoreferencia, SerializableConvert.converListSerializeUsuarioRolGeoreferencia(datosUsuario["usuarioRolGeoreferencias"]), mode: InsertMode.insertOrReplace);
      }
      print("usuariojse usuarioRolGeoreferencias 2");
    });
    GrupoEquipoData grupoEquipoData = GrupoEquipoData(
      grupoEquipoId: IdGenerator.generateId(),
      cargaAcademicaId: listaGrupoUi.cursosUi?.cargaAcademicaId,
      cargaCursoId: listaGrupoUi.cursosUi?.cargaCursoId,
      docenteId: empleadoId,
      estado: MoorGrupoRepository.CREADO,
      nombre: listaGrupoUi.nombre,
      tipoId: (listaGrupoUi.modoAletorio??false)?TIPO_DINAMICO: TIPO_ESTATICO,
      fechaAccion: DateTime.now(),
      fechaCreacion: DateTime.now(),
      usuarioCreacionId: usuarioId,
      usuarioAccionId: usuarioId,
      timestampFlag: DateTime.now(),
      syncFlag: EstadoSync.FLAG_ADDED
    );

    SQL.into(SQL.grupoEquipo)
      .where((tbl) => tbl.)

    for(GrupoUi grupoUi in listaGrupoUi.grupoUiList??[]){

    }*/


    //return
  }

  @override
  Future<void> saveGrupoDocente(Map<String, dynamic> dataJson, String? grupoEquipoId) async{
    AppDataBase SQL = AppDataBase();
    await SQL.batch((batch) async {

      var querySelect = await SQL.select(SQL.grupoEquipo2).join([
        innerJoin(SQL.equipo2, SQL.grupoEquipo2.grupoEquipoId.equalsExp(SQL.equipo2.grupoEquipoId))
      ]);

      querySelect.where(SQL.grupoEquipo2.grupoEquipoId.equals(grupoEquipoId));

      for(var row in await querySelect.get()){
        Equipo2Data equipoData = row.readTable(SQL.equipo2);
        var query = SQL.delete(SQL.integranteEquipo2)..where((tbl) => tbl.equipoId.equals(equipoData.equipoId));
        await query.go();
        var query1 = SQL.delete(SQL.equipo2)..where((tbl) => tbl.equipoId.equals(equipoData.equipoId));
        await query1.go();
      }

      var query2 = SQL.delete(SQL.grupoEquipo2)..where((tbl) => tbl.grupoEquipoId.equals(grupoEquipoId));
      await query2.go();

      if(dataJson.containsKey("grupo_equipo")){
        List<GrupoEquipo2Data> grupoEquipoDataList = SerializableConvert.converListSerializeGrupoEquipo(dataJson["grupo_equipo"]);
        batch.insertAll(SQL.grupoEquipo2, grupoEquipoDataList, mode: InsertMode.insertOrReplace);
      }

      if(dataJson.containsKey("equipo")){
        List<Equipo2Data> equipoDataList = SerializableConvert.converListSerializeEquipo(dataJson["equipo"]);
        batch.insertAll(SQL.equipo2, equipoDataList, mode: InsertMode.insertOrReplace);
      }

      if(dataJson.containsKey("equipo_integrante")){
        List<IntegranteEquipo2Data> equipoDataList = SerializableConvert.converListSerializeIntegranteEquipo(dataJson["equipo_integrante"]);
        batch.insertAll(SQL.integranteEquipo2, equipoDataList, mode: InsertMode.insertOrReplace);
      }

    });
  }

  @override
  Future<void> saveGrupoDocenteCargaAcademicaList(Map<String, dynamic> dataJson, int? cargaAcademicaId)async {
    AppDataBase SQL = AppDataBase();
    await SQL.batch((batch) async {

      var querySelect = await SQL.select(SQL.grupoEquipo2).join([
        innerJoin(SQL.equipo2, SQL.grupoEquipo2.grupoEquipoId.equalsExp(SQL.equipo2.grupoEquipoId))
      ]);

      querySelect.where(SQL.grupoEquipo2.cargaAcademicaId.equals(cargaAcademicaId));

      for(var row in await querySelect.get()){
        Equipo2Data equipoData = row.readTable(SQL.equipo2);
        var query = SQL.delete(SQL.integranteEquipo2)..where((tbl) => tbl.equipoId.equals(equipoData.equipoId));
        await query.go();
        var query1 = SQL.delete(SQL.equipo2)..where((tbl) => tbl.equipoId.equals(equipoData.equipoId));
        await query1.go();
      }

      var query2 = SQL.delete(SQL.grupoEquipo2)..where((tbl) => tbl.cargaAcademicaId.equals(cargaAcademicaId));
      await query2.go();


      if(dataJson.containsKey("grupoEquipo")){
        List<GrupoEquipo2Data> grupoEquipoDataList = SerializableConvert.converListSerializeGrupoEquipo(dataJson["grupoEquipo"]);
        batch.insertAll(SQL.grupoEquipo2, grupoEquipoDataList, mode: InsertMode.insertOrReplace);
      }

      if(dataJson.containsKey("equipo")){
        List<Equipo2Data> equipoDataList = SerializableConvert.converListSerializeEquipo(dataJson["equipo"]);
        batch.insertAll(SQL.equipo2, equipoDataList, mode: InsertMode.insertOrReplace);
      }

      if(dataJson.containsKey("equipoIntegrante")){
        List<IntegranteEquipo2Data> integranteDataList = SerializableConvert.converListSerializeIntegranteEquipo(dataJson["equipoIntegrante"]);

        if(dataJson.containsKey("personas")){
          List<PersonaSerial> items = [];
          Iterable l = dataJson["personas"];
          for(var item in l){
            items.add(PersonaSerial.fromJson(item));
          }

          List<IntegranteEquipo2Data> integranteDataList2 = [];
          for(var integranteData in integranteDataList){
            PersonaSerial? personaSerial = items.firstWhereOrNull((element) => element.personaId == integranteData.alumnoId);
            IntegranteEquipo2Data integranteEquipo2Data = integranteData.copyWith(
              nombre:  personaSerial?.nombres,
              foto: personaSerial?.foto,
            );
            integranteDataList2.add(integranteEquipo2Data);
          }
          integranteDataList = integranteDataList2;
        }


        batch.insertAll(SQL.integranteEquipo2, integranteDataList, mode: InsertMode.insertOrReplace);
      }

    });
  }

  @override
  Future<List<ListaGrupoUi>> getListaGrupos(int? cargaAcademicaId)async {
    AppDataBase SQL = AppDataBase();

    var querySelect = await SQL.select(SQL.grupoEquipo2).join([
      leftOuterJoin(SQL.equipo2, SQL.grupoEquipo2.grupoEquipoId.equalsExp(SQL.equipo2.grupoEquipoId)),
      leftOuterJoin(SQL.integranteEquipo2, SQL.integranteEquipo2.equipoId.equalsExp(SQL.equipo2.equipoId))
    ]);

    querySelect.where(SQL.grupoEquipo2.cargaAcademicaId.equals(cargaAcademicaId));
    querySelect.orderBy([OrderingTerm.desc(SQL.grupoEquipo2.fechaCreacion), OrderingTerm.asc(SQL.equipo2.orden), OrderingTerm.asc(SQL.integranteEquipo2.nombre)]);
    List<ListaGrupoUi> listaGrupoUiList = [];
    ParametrosDisenioData? defaultParametrosDisenioData = await (SQL.selectSingle(SQL.parametrosDisenio)..where((tbl) => tbl.nombre.equals("default"))).getSingleOrNull();


    for(var row in await querySelect.get()){
      GrupoEquipo2Data grupoEquipoData = row.readTable(SQL.grupoEquipo2);
      Equipo2Data? equipoData = row.readTableOrNull(SQL.equipo2);
      IntegranteEquipo2Data? integranteEquipo = row.readTableOrNull(SQL.integranteEquipo2);

      if(grupoEquipoData.estado == GRUPOEQUIPO_ELIMINADO || equipoData?.estado == EQUIPO_ELIMINADO) continue;

      ListaGrupoUi? listaGrupoUi = listaGrupoUiList.firstWhereOrNull((element) => element.grupoEquipoId == grupoEquipoData.grupoEquipoId);
      if(listaGrupoUi==null){
        listaGrupoUi = ListaGrupoUi();
        listaGrupoUi.grupoEquipoId = grupoEquipoData.grupoEquipoId;
        listaGrupoUi.cargaCursoId = grupoEquipoData.cargaCursoId;
        listaGrupoUi.modoAletorio = (grupoEquipoData.tipoId == TIPO_DINAMICO);
        listaGrupoUi.grupoUiList = [];
        listaGrupoUi.nombre = DomainTools.capitalize(grupoEquipoData.nombre??"");
        listaGrupoUi.nombreCurso = grupoEquipoData.cursoNombre;
        listaGrupoUi.docenteId = grupoEquipoData.docenteId;

        if((grupoEquipoData.color1??"").isNotEmpty){
          listaGrupoUi.color1=grupoEquipoData.color1;
          listaGrupoUi.color2=grupoEquipoData.color2;
          listaGrupoUi.color3=grupoEquipoData.color3;
          listaGrupoUi.imagen=grupoEquipoData.path;
        }else{
          listaGrupoUi.color1=defaultParametrosDisenioData?.color1;
          listaGrupoUi.color2=defaultParametrosDisenioData?.color2;
          listaGrupoUi.color3=defaultParametrosDisenioData?.color3;
          listaGrupoUi.imagen=defaultParametrosDisenioData?.path;
        }

        listaGrupoUiList.add(listaGrupoUi);
      }


      GrupoUi? grupoUi = listaGrupoUi.grupoUiList?.firstWhereOrNull((element) => element.equipoId == equipoData?.equipoId);
      if(grupoUi==null){
        grupoUi = GrupoUi();
        grupoUi.equipoId = equipoData?.equipoId;
        grupoUi.nombre = equipoData?.nombre;
        grupoUi.posicion = equipoData?.orden;
        grupoUi.integranteUiList = [];
        listaGrupoUi.grupoUiList?.add(grupoUi);
      }

      IntegranteGrupoUi integranteGrupoUi = IntegranteGrupoUi();
      integranteGrupoUi.equipoIntegranteId = integranteEquipo?.equipoIntegranteId;
      integranteGrupoUi.personaUi = PersonaUi();
      integranteGrupoUi.personaUi?.personaId = integranteEquipo?.alumnoId;
      integranteGrupoUi.personaUi?.foto = integranteEquipo?.foto;
      integranteGrupoUi.personaUi?.nombreCompleto = DomainTools.capitalize(integranteEquipo?.nombre??"");
      grupoUi.integranteUiList?.add(integranteGrupoUi);
    }
    return listaGrupoUiList;
  }

}