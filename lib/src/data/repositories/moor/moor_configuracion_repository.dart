import 'dart:collection';

import 'package:moor_flutter/moor_flutter.dart';
import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/data/helpers/serelizable/rest_api_response.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/database/app_database.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/aula.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/carga_academica.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/carga_cursos.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/contacto_docente.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/persona.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/plan_estudios.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/session_user.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/usuario.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/anio_academico_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/entidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_lista_envio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/georeferencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/login_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/programa_educativo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';

import 'database/app_database.dart';

class MoorConfiguracionRepository extends ConfiguracionRepository{

  static const int ANIO_ACADEMICO_MATRICULA = 192, ANIO_ACADEMICO_ACTIVO = 193, ANIO_ACADEMICO_CERRADO = 194, ANIO_ACADEMICO_CREADO = 195, ANIO_ACADEMICO_ELIMINADO = 196;
  static const int SILABO_ESTADO_CREADO = 243, SILABO_ESTADO_AUTORIZADO = 244, SILABO_ESTADO_PROCESO = 245, SILABO_ESTADO_PUBLICADO = 246, SILABO_ESTADO_ELIMINADO = 397;

  @override
  Future<bool> validarUsuario() async{
    AppDataBase SQL = AppDataBase();
    try{

      SessionUserData? sessionUserData = await (SQL.selectSingle(SQL.sessionUser)).getSingleOrNull();//El ORM genera error si hay dos registros

      //Solo deve haber una registro de session user data
      return sessionUserData!=null?sessionUserData.complete??false:false;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> destroyBaseDatos() async{
    AppDataBase SQL = AppDataBase();
    try{
      await SQL.transaction(() async {
        // you only need this if you've manually enabled foreign keys
        // await customStatement('PRAGMA foreign_keys = OFF');
        for (final table in SQL.allTables) {
          await SQL.delete(table).go();
        }
      });
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<int> getSessionUsuarioId() async{
    AppDataBase SQL = AppDataBase();
    try{
      SessionUserData? sessionUserData =  await SQL.selectSingle(SQL.sessionUser).getSingleOrNull();
      return sessionUserData!=null?sessionUserData.userId:0;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<int> getSessionPersonaId() async {
    AppDataBase SQL = AppDataBase();
    try{
     UsuarioData? usuarioData = await SQL.selectSingle(SQL.usuario).getSingleOrNull();
     return usuarioData?.personaId??0;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<String> getSessionUsuarioUrlServidor() async{
    AppDataBase SQL = AppDataBase();
    try{
      SessionUserData? sessionUserData =  await SQL.selectSingle(SQL.sessionUser).getSingleOrNull();
      return sessionUserData?.urlServerLocal??"";
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<int> getSessionAnioAcademicoId()async {
    AppDataBase SQL = AppDataBase();
    try{
      SessionUserData? sessionUserData =  await SQL.selectSingle(SQL.sessionUser).getSingleOrNull();
      return sessionUserData!=null?sessionUserData.anioAcademicoId??0:0;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<int> getSessionEntidadId() async{
    AppDataBase SQL = AppDataBase();
    SessionUserData? sessionUserData =  await SQL.selectSingle(SQL.sessionUser).getSingleOrNull();
    AnioAcademicoData? academicoData = await (SQL.selectSingle(SQL.anioAcademico)..where((tbl) => tbl.idAnioAcademico.equals(sessionUserData?.anioAcademicoId) )).getSingleOrNull();


    var query = await SQL.selectSingle(SQL.usuarioRolGeoreferencia)..where((tbl) => tbl.usuarioId.equals(sessionUserData?.userId));
    query.where((tbl) => tbl.geoReferenciaId.equals(academicoData?.georeferenciaId));
    UsuarioRolGeoreferenciaData? usuarioRolGeoreferenciaData = await query.getSingleOrNull();

    GeoreferenciaData? georeferenciaData =  await (SQL.selectSingle(SQL.georeferencia)..where((tbl) => tbl.georeferenciaId.equals(usuarioRolGeoreferenciaData?.geoReferenciaId))).getSingleOrNull();

    return georeferenciaData!=null?georeferenciaData.entidadId??0:0;
  }

  @override
  Future<int> getSessionGeoreferenciaId()async {
    AppDataBase SQL = AppDataBase();
    SessionUserData? sessionUserData =  await SQL.selectSingle(SQL.sessionUser).getSingleOrNull();
    AnioAcademicoData? academicoData = await (SQL.selectSingle(SQL.anioAcademico)..where((tbl) => tbl.idAnioAcademico.equals(sessionUserData?.anioAcademicoId) )).getSingleOrNull();


    var query = await SQL.selectSingle(SQL.usuarioRolGeoreferencia)..where((tbl) => tbl.usuarioId.equals(sessionUserData?.userId));
    query.where((tbl) => tbl.geoReferenciaId.equals(academicoData?.georeferenciaId));
    UsuarioRolGeoreferenciaData? usuarioRolGeoreferenciaData = await query.getSingleOrNull();
    return usuarioRolGeoreferenciaData!=null?usuarioRolGeoreferenciaData.geoReferenciaId??0:0;
  }

  @override
  Future<int> getSessionProgramaEducativoId() async{
    AppDataBase SQL = AppDataBase();
    try{
      SessionUserData? sessionUserData =  await SQL.selectSingle(SQL.sessionUser).getSingleOrNull();
      return sessionUserData!=null?sessionUserData.programaEducativoId??0:0;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<UsuarioUi> saveDatosIniciales(Map<String, dynamic> datosInicioPadre) async{
    AppDataBase SQL = AppDataBase();
    try{
      int anioAcademicoId = 0;
      int  empleadoId = 0;
       await SQL.batch((batch) async {
        // functions in a batch don't have to be awaited - just
        // await the whole batch afterwards.

        print("saveDatosGlobales");

        if(datosInicioPadre.containsKey("anioAcademicoId")){
            anioAcademicoId = datosInicioPadre["anioAcademicoId"];
        }

        if(datosInicioPadre.containsKey("empleados")){
          List<EmpleadoData> empleadoDataList = SerializableConvert.converListSerializeEmpleado(datosInicioPadre["empleados"]);
          if(empleadoDataList.isNotEmpty){
            empleadoId = empleadoDataList[0].empleadoId;
          }
          batch.deleteWhere(SQL.empleado, (row) => const Constant(true));
          batch.insertAll(SQL.empleado, empleadoDataList, mode: InsertMode.insertOrReplace );
        }

        if(datosInicioPadre.containsKey("anioAcademicos")){
          List<AnioAcademicoData> anioAcademicoLast = await SQL.select(SQL.anioAcademico).get();
          print("AnioAcademico Last: " + anioAcademicoLast.length.toString());
          // Recuperar si el anio estubo seleccionado
          List<AnioAcademicoData> anioAcademicoList = [];
          for(AnioAcademicoData academicoData in SerializableConvert.converListSerializeAnioAcademico(datosInicioPadre["anioAcademicos"])){
              AnioAcademicoData? last = anioAcademicoLast.firstWhereOrNull((element) => academicoData.idAnioAcademico == element.idAnioAcademico);
              if(last!=null){
                anioAcademicoList.add(academicoData.copyWith(toogle: last.toogle));
              }else{
                anioAcademicoList.add(academicoData);
              }

          }
          //
          batch.deleteWhere(SQL.anioAcademico, (row) => const Constant(true));
          batch.insertAll(SQL.anioAcademico, anioAcademicoList, mode: InsertMode.insertOrReplace );
        }

        if(datosInicioPadre.containsKey("parametroConfiguracion")){
          batch.deleteWhere(SQL.parametroConfiguracion, (row) => const Constant(true));
          batch.insertAll(SQL.parametroConfiguracion, SerializableConvert.converListSerializeParametroConfiguracion(datosInicioPadre["parametroConfiguracion"]), mode: InsertMode.insertOrReplace );
        }

      });

       UsuarioUi usuarioUi = new UsuarioUi();
       usuarioUi.empleadoId = empleadoId;
       usuarioUi.anioAcademicoIdSelected = anioAcademicoId;
       return usuarioUi;

    }catch(e){
      print("Error: " + e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<LoginUi> saveDatosServidor(Map<String, dynamic> datosServidor)async {
    AppDataBase SQL = AppDataBase();
    try{
      LoginUi loginUi;
      AdminServiceSerializable serviceSerializable = AdminServiceSerializable.fromJson(datosServidor);

      if(serviceSerializable.UsuarioId==-1){
        loginUi = LoginUi.INVALIDO;
      }else{
        if((serviceSerializable.UsuarioExternoId??0) > 0){
          loginUi = LoginUi.SUCCESS;
          SessionUserData sessionUserData = SessionUserData(userId: serviceSerializable.UsuarioExternoId??0, urlServerLocal: serviceSerializable.UrlServiceMovil);
          await SQL.into(SQL.sessionUser).insert(sessionUserData, mode: InsertMode.insertOrReplace);
        }else{
          loginUi = LoginUi.DUPLICADO;
        }
      }
      return loginUi;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> saveUsuario(Map<String, dynamic> datosUsuario)async {
    AppDataBase SQL = AppDataBase();
    try{
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
    }catch(e){
      print(e);
      throw Exception(e);
    }
  }

  @override
  Future<void> updateUsuarioSuccessData(int usuarioId, int anioAcademicoId) async {
    AppDataBase SQL = AppDataBase();
    try{
      SessionUserData? sessionUserData = await(SQL.selectSingle(SQL.sessionUser).getSingleOrNull());
      if(sessionUserData!=null){
        await SQL.update(SQL.sessionUser).replace(sessionUserData.copyWith(complete: true, anioAcademicoId: anioAcademicoId));
      }
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<bool> validarRol(int usuarioId) async {
    AppDataBase SQL = AppDataBase();
    try{
      var query = SQL.selectSingle(SQL.usuarioRolGeoreferencia)..where((tbl) => tbl.usuarioId.equals(usuarioId));
      query.where((tbl) => tbl.rolId.equals(4));
      UsuarioRolGeoreferenciaData? usuarioRolGeoreferenciaData = await query.getSingleOrNull();
      return usuarioRolGeoreferenciaData!=null;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> saveDatosAnioAcademico(Map<String, dynamic> datosAnioAcademico, int?  anioAcademicoId, int? empleadoId) async{
    AppDataBase SQL = AppDataBase();
    try{
      await SQL.batch((batch) async {
       List<int> cargaAcademicaIdList = [];
       for(CargaAcademicaData cargaAcademicaData in await (SQL.select(SQL.cargaAcademica)..where((tbl) => tbl.idAnioAcademico.equals(anioAcademicoId))).get()){
         cargaAcademicaIdList.add(cargaAcademicaData.cargaAcademicaId);
       }
       List<int> cargaCursoIdList = [];
       List<int> planCursoIdList = [];
       for(CargaCursoData cargaCursoData in await (SQL.select(SQL.cargaCurso)..where((tbl) => tbl.cargaAcademicaId.isIn(cargaAcademicaIdList))).get()){
         cargaCursoIdList.add(cargaCursoData.cargaCursoId);
         planCursoIdList.add(cargaCursoData.planCursoId??0);
       }
       List<int> planEstudioIdList = [];
       for(PlanCurso planCurso in await (SQL.select(SQL.planCursos)..where((tbl) => tbl.planCursoId.isIn(planCursoIdList))).get()){
         planEstudioIdList.add(planCurso.planEstudiosId??0);
       }

       List<int> programaEduIdList = [];
       for(PlanEstudioData planEstudio in await (SQL.select(SQL.planEstudio)..where((tbl) => tbl.planEstudiosId.isIn(planEstudioIdList))).get()){
         programaEduIdList.add(planEstudio.programaEduId??0);
       }

       await (SQL.delete(SQL.cargaAcademica)..where((tbl) => tbl.cargaAcademicaId.isIn(cargaAcademicaIdList))).go();
       await (SQL.delete(SQL.cargaCurso)..where((tbl) => tbl.cargaCursoId.isIn(cargaCursoIdList))).go();
       await (SQL.delete(SQL.planCursos)..where((tbl) => tbl.planCursoId.isIn(planCursoIdList))).go();
       await (SQL.delete(SQL.planEstudio)..where((tbl) => tbl.planEstudiosId.isIn(planEstudioIdList))).go();
       await (SQL.delete(SQL.programasEducativo)..where((tbl) => tbl.programaEduId.isIn(programaEduIdList))).go();
       await (SQL.delete(SQL.silaboEvento)..where((tbl) => tbl.cargaCursoId.isIn(cargaCursoIdList))).go();

        if(datosAnioAcademico.containsKey("aulas")){
          //batch.deleteWhere(SQL.aula, (row) => const Constant(true));
          batch.insertAll(SQL.aula, SerializableConvert.converListSerializeAula(datosAnioAcademico["aulas"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("cargasAcademicas")){
          //batch.deleteWhere(SQL.cargaAcademica, (row) => const Constant(true));
          batch.insertAll(SQL.cargaAcademica, SerializableConvert.converListSerializeCargaAcademica(datosAnioAcademico["cargasAcademicas"]), mode: InsertMode.insertOrReplace );
        }

        if(datosAnioAcademico.containsKey("cargaCursoDocente")){
          //batch.deleteWhere(SQL.cargaCursoDocente, (row) => const Constant(true));
          batch.insertAll(SQL.cargaCursoDocente, SerializableConvert.converListSerializeCargaCursoDocente(datosAnioAcademico["cargaCursoDocente"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("cargaCursoDocenteDet")){
          //batch.deleteWhere(SQL.cargaCursoDocenteDet, (row) => const Constant(true));
          batch.insertAll(SQL.cargaCursoDocenteDet, SerializableConvert.converListSerializeCargaCursoDocenteDet(datosAnioAcademico["cargaCursoDocenteDet"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("cargaCursos")){
          //batch.deleteWhere(SQL.cargaCurso, (row) => const Constant(true));
          batch.insertAll(SQL.cargaCurso, SerializableConvert.converListSerializeCargaCurso(datosAnioAcademico["cargaCursos"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("cursos")){
          //batch.deleteWhere(SQL.cursos, (row) => const Constant(true));
          batch.insertAll(SQL.cursos, SerializableConvert.converListSerializeCursos(datosAnioAcademico["cursos"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("parametrosDisenio")){
          //batch.deleteWhere(SQL.parametrosDisenio, (row) => const Constant(true));
          batch.insertAll(SQL.parametrosDisenio, SerializableConvert.converListSerializeParametrosDisenio(datosAnioAcademico["parametrosDisenio"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("nivelesAcademicos")){
          //batch.deleteWhere(SQL.nivelAcademico, (row) => const Constant(true));
          batch.insertAll(SQL.nivelAcademico, SerializableConvert.converListSerializeNivelAcademico(datosAnioAcademico["nivelesAcademicos"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("periodos")){
          //batch.deleteWhere(SQL.periodos, (row) => const Constant(true));
          batch.insertAll(SQL.periodos, SerializableConvert.converListSerializePeriodos(datosAnioAcademico["periodos"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("planCursos")){
          //batch.deleteWhere(SQL.planCursos, (row) => const Constant(true));
          batch.insertAll(SQL.planCursos, SerializableConvert.converListSerializePlanCurso(datosAnioAcademico["planCursos"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("planEstudios")){
          //batch.deleteWhere(SQL.planEstudio, (row) => const Constant(true));
          batch.insertAll(SQL.planEstudio, SerializableConvert.converListSerializePlanEstudio(datosAnioAcademico["planEstudios"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("programasEducativos")){
          //batch.deleteWhere(SQL.programasEducativo, (row) => const Constant(true));
          batch.insertAll(SQL.programasEducativo, SerializableConvert.converListSerializeProgramasEducativo(datosAnioAcademico["programasEducativos"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("secciones")){
          //batch.deleteWhere(SQL.seccion, (row) => const Constant(true));
          batch.insertAll(SQL.seccion, SerializableConvert.converListSerializeSeccion(datosAnioAcademico["secciones"]), mode: InsertMode.insertOrReplace);
        }


        if(datosAnioAcademico.containsKey("silaboEvento")){
          //batch.deleteWhere(SQL.silaboEvento, (row) => const Constant(true));
          batch.insertAll(SQL.silaboEvento, SerializableConvert.converListSerializeSilaboEvento(datosAnioAcademico["silaboEvento"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("calendarioPeriodos")){
          //batch.deleteWhere(SQL.calendarioPeriodo, (row) => const Constant(true));
          //batch.insertAll(SQL.calendarioPeriodo, SerializableConvert.converListSerializeCalendarioPeriodo(datosAnioAcademico["calendarioPeriodos"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("tipos")){
          batch.deleteWhere(SQL.tipos, (row) => const Constant(true));
          batch.insertAll(SQL.tipos, SerializableConvert.converListSerializeTipos(datosAnioAcademico["tipos"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("calendarioAcademico")){
          //batch.deleteWhere(SQL.calendarioAcademico, (row) => const Constant(true));
          batch.insertAll(SQL.calendarioAcademico, SerializableConvert.converListSerializeCalendarioAcademico(datosAnioAcademico["calendarioAcademico"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("hora")){
          batch.deleteWhere(SQL.hora, (row) => const Constant(true));
          batch.insertAll(SQL.hora, SerializableConvert.converListSerializeHora(datosAnioAcademico["hora"]), mode: InsertMode.insertOrReplace);
        }
        if(datosAnioAcademico.containsKey("horarioPrograma")){
          batch.deleteWhere(SQL.horarioPrograma, (row) => const Constant(true));
          batch.insertAll(SQL.horarioPrograma, SerializableConvert.converListSerializeHorarioPrograma(datosAnioAcademico["horarioPrograma"]), mode: InsertMode.insertOrReplace);
        }
        if(datosAnioAcademico.containsKey("horarioHora")){
          batch.deleteWhere(SQL.horarioHora, (row) => const Constant(true));
          batch.insertAll(SQL.horarioHora, SerializableConvert.converListSerializeHorariosHora(datosAnioAcademico["horarioHora"]), mode: InsertMode.insertOrReplace);
        }
        if(datosAnioAcademico.containsKey("dia")){
          batch.deleteWhere(SQL.dia, (row) => const Constant(true));
          batch.insertAll(SQL.dia, SerializableConvert.converListSerializeDia(datosAnioAcademico["dia"]), mode: InsertMode.insertOrReplace);
        }
        if(datosAnioAcademico.containsKey("cursosDetHorario")){
          batch.deleteWhere(SQL.cursosDetHorario, (row) => const Constant(true));
          batch.insertAll(SQL.cursosDetHorario, SerializableConvert.converListSerializeCursoDetHorario(datosAnioAcademico["horarioHora"]), mode: InsertMode.insertOrReplace);
        }
        if(datosAnioAcademico.containsKey("horario")){
          batch.deleteWhere(SQL.horario, (row) => const Constant(true));
          batch.insertAll(SQL.horario, SerializableConvert.converListSerializeHorario(datosAnioAcademico["horario"]), mode: InsertMode.insertOrReplace);
        }
        if(datosAnioAcademico.containsKey("bEWebConfigs")){
          batch.deleteWhere(SQL.webConfigs, (row) => const Constant(true));
          batch.insertAll(SQL.webConfigs, SerializableConvert.converListSerializeWebConfigs(datosAnioAcademico["bEWebConfigs"]), mode: InsertMode.insertOrReplace);
        }
      });
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<UsuarioUi> getSessionUsuario() async {

    AppDataBase SQL = AppDataBase();
    int usuarioId = await getSessionUsuarioId();
    var query =  SQL.selectSingle(SQL.persona).join([
      innerJoin(SQL.usuario, SQL.usuario.personaId.equalsExp(SQL.persona.personaId))
    ]);

    query.where(SQL.usuario.usuarioId.equals(usuarioId));
    var resultRow = await query.getSingleOrNull();
    PersonaData? personaData = resultRow?.readTable(SQL.persona);

    String fechaNacimiento = "";
    if(personaData?.fechaNac !=null && personaData!.fechaNac!.isNotEmpty){
      DateTime fecPad = DomainTools.convertDateTimePtBR(personaData.fechaNac!, null);
      fechaNacimiento = "${DomainTools.calcularEdad(fecPad)} años (${DomainTools.f_fecha_anio_mes_letras(fecPad)})";

    }

    UsuarioUi usuarioUi = UsuarioUi();
    usuarioUi.usuarioId = usuarioId;
    PersonaUi personaUi = PersonaUi();
    personaUi.personaId = personaData?.personaId;
    personaUi.nombreCompleto = '${DomainTools.capitalize(personaData?.nombres??"")} ${DomainTools.capitalize(personaData?.apellidoPaterno??"")} ${DomainTools.capitalize(personaData?.apellidoMaterno??"")}';
    personaUi.foto = '${personaData?.foto??""}';
    personaUi.correo = personaData?.correo??"";
    personaUi.telefono = personaData?.celular??personaData?.telefono??"";
    personaUi.fechaNacimiento = fechaNacimiento;
    personaUi.nombres = DomainTools.capitalize(personaData?.nombres??"");
    personaUi.fechaNacimiento2 = (personaData?.fechaNac??"").replaceAll(RegExp(' 00:00:00'), '').replaceAll(RegExp(' 12:00:00 a.m.'), '');
    usuarioUi.personaUi = personaUi;
    return usuarioUi;


  }

  @override
  Future<List<GeoreferenciaUi>> getGeoreferenciaList(int usuarioId) async {
    AppDataBase SQL = AppDataBase();
    List<GeoreferenciaUi> georeferenciaUiList =[];

    List<UsuarioRolGeoreferenciaData> usuarioRolGeoreferenciaList = await (SQL.select(SQL.usuarioRolGeoreferencia)..where((tbl) => tbl.usuarioId.equals(usuarioId))).get();

    List<int> gereferenciaIdList = [];
    for (UsuarioRolGeoreferenciaData usuarioRolGeoreferencia in usuarioRolGeoreferenciaList){
      gereferenciaIdList.add(usuarioRolGeoreferencia.geoReferenciaId??0);
    }


    List<GeoreferenciaData> georeferenciaList = await (SQL.select(SQL.georeferencia)..where((tbl) => tbl.georeferenciaId.isIn(gereferenciaIdList))).get();

    for(GeoreferenciaData georeferenciaData in georeferenciaList){

      GeoreferenciaUi georeferenciaUi = GeoreferenciaUi();
      georeferenciaUi.georeferenciaId = georeferenciaData.georeferenciaId;
      georeferenciaUi.nombre = georeferenciaData.nombre;
      georeferenciaUi.alias = georeferenciaData.geoAlias;
      georeferenciaUi.anioAcademicoUiList = [];
      EntidadData? entidadData = await (SQL.selectSingle(SQL.entidad)..where((tbl) => tbl.entidadId.equals(georeferenciaData.entidadId))).getSingleOrNull();
      EntidadUi entidadUi = EntidadUi();
      entidadUi.entidadId = georeferenciaData.entidadId;
      entidadUi.nombre = entidadData?.nombre;
      entidadUi.foto = entidadData?.foto;
      georeferenciaUi.entidadUi = entidadUi;
      List<AnioAcademicoData> anioAcademicoList = await (SQL.select(SQL.anioAcademico)..where((tbl) => tbl.georeferenciaId.equals(georeferenciaData.georeferenciaId))).get();
      print("anioAcademicoList: ${anioAcademicoList.length}");
      anioAcademicoList.sort((o2, o1) {

        int sComp =  DomainTools.convertDateTimePtBR(o2.fechaFin, null).compareTo(DomainTools.convertDateTimePtBR(o1.fechaFin, null));
        if (sComp != 0) {
          return sComp;
        }

        int x1 = o1.georeferenciaId??0;
        int x2 = o2.georeferenciaId??0;
        return x1.compareTo(x2);

      });



      for (AnioAcademicoData anioAcademico in anioAcademicoList){
        AnioAcademicoUi anioAcademicoUi = new AnioAcademicoUi();
        anioAcademicoUi.anioAcademicoId = anioAcademico.idAnioAcademico;
        anioAcademicoUi.nombre = anioAcademico.nombre;
        if(anioAcademico.estadoId== ANIO_ACADEMICO_ACTIVO){
          anioAcademicoUi.vigente = true;
        }
        anioAcademicoUi.georeferenciaUi =  georeferenciaUi;
        georeferenciaUi.anioAcademicoUiList?.add(anioAcademicoUi);
      }
      georeferenciaUiList.add(georeferenciaUi);
    }


    return georeferenciaUiList;
  }

  @override
  Future<void> updateSessionAnioAcademicoId(int anioAcademicoId) async {
    AppDataBase SQL = AppDataBase();
    try{
      SessionUserData? sessionUserData = await(SQL.selectSingle(SQL.sessionUser).getSingleOrNull());
      if(sessionUserData!=null){
        await SQL.update(SQL.sessionUser).replace(sessionUserData.copyWith(anioAcademicoId: anioAcademicoId));
      }
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<ProgramaEducativoUi>> getListProgramaEducativo(int empleadoId, int anioAcademicoId) async{

    AppDataBase SQL = AppDataBase();
    List<ProgramaEducativoUi> programaEduactivosUIs = [];
    List<CargaCursoData> cargaCursosList = [];

    var query = SQL.select(SQL.cargaCurso).join([
      innerJoin(SQL.cargaAcademica, SQL.cargaAcademica.cargaAcademicaId.equalsExp(SQL.cargaCurso.cargaAcademicaId)),
      innerJoin(SQL.anioAcademico, SQL.anioAcademico.idAnioAcademico.equalsExp(SQL.cargaAcademica.idAnioAcademico)),
    ]);

    query.where(SQL.cargaCurso.empleadoId.equals(empleadoId));
    query.where(SQL.cargaCurso.complejo.isNull());
    query.where(SQL.anioAcademico.idAnioAcademico.equals(anioAcademicoId));

    for(var row in await query.get()){
      cargaCursosList.add(row.readTable(SQL.cargaCurso));
    }

    var queryComplejo = SQL.select(SQL.cargaCurso).join([
      innerJoin(SQL.cargaCursoDocente, SQL.cargaCursoDocente.cargaCursoId.equalsExp(SQL.cargaCurso.cargaCursoId)),
      //innerJoin(SQL.cargaCursoDocenteDet, SQL.cargaCursoDocente.cargaCursoDocenteId.equalsExp(SQL.cargaCursoDocenteDet.cargaCursoDocenteId)),
      innerJoin(SQL.cargaAcademica, SQL.cargaAcademica.cargaAcademicaId.equalsExp(SQL.cargaCurso.cargaAcademicaId)),
      innerJoin(SQL.anioAcademico, SQL.anioAcademico.idAnioAcademico.equalsExp(SQL.cargaAcademica.idAnioAcademico)),
    ]);

    queryComplejo.where(SQL.cargaCursoDocente.docenteId.equals(empleadoId));
    queryComplejo.where(SQL.cargaCurso.complejo.equals(1));
    queryComplejo.where(SQL.anioAcademico.idAnioAcademico.equals(anioAcademicoId));

    for(var row in await queryComplejo.get()){
      cargaCursosList.add(row.readTable(SQL.cargaCurso));
    }

    List<int> planCursoIdList = [];
    for(CargaCursoData itemCargaCursos in cargaCursosList){
      planCursoIdList.add(itemCargaCursos.planCursoId??0);
    }

    var queryProgramaEdu = SQL.select(SQL.programasEducativo).join([
      innerJoin(SQL.planEstudio, SQL.programasEducativo.programaEduId.equalsExp(SQL.planEstudio.programaEduId)),
      innerJoin(SQL.planCursos, SQL.planEstudio.planEstudiosId.equalsExp(SQL.planCursos.planEstudiosId)),
      innerJoin(SQL.nivelAcademico, SQL.programasEducativo.nivelAcadId.equalsExp(SQL.nivelAcademico.nivelAcadId))
    ]);
    queryProgramaEdu.where(SQL.planCursos.planCursoId.isIn(planCursoIdList));
    queryProgramaEdu.where(SQL.programasEducativo.estadoId.equals(37));
    queryProgramaEdu.groupBy([SQL.programasEducativo.programaEduId]);
    for(var row in await queryProgramaEdu.get()){
      ProgramasEducativoData programasEducativo = row.readTable(SQL.programasEducativo);
      NivelAcademicoData nivelAcademicoData = row.readTable(SQL.nivelAcademico);
      ProgramaEducativoUi programaEduactivosUI = new ProgramaEducativoUi();
      programaEduactivosUI.idPrograma = programasEducativo.programaEduId;
      programaEduactivosUI.nombrePrograma = programasEducativo.nombre;
      programaEduactivosUI.seleccionado = programasEducativo.toogle;
      programaEduactivosUI.nivelAcademico = nivelAcademicoData.nombre;
      programaEduactivosUIs.add(programaEduactivosUI);
    }

     return programaEduactivosUIs;
  }

  @override
  Future<int> getSessionEmpleadoId() async {
    AppDataBase SQL = AppDataBase();
    try{
      int empleadoId = 0;
      var query = SQL.selectSingle(SQL.empleado).join([
        innerJoin(SQL.usuario, SQL.usuario.personaId.equalsExp(SQL.empleado.personaId))
      ]);
      query.where(SQL.usuario.usuarioId.equals(await getSessionUsuarioId()));
      var row = await query.getSingleOrNull();


      if(row != null){
        EmpleadoData empleado = row.readTable(SQL.empleado);
        empleadoId = empleado.empleadoId;
      }
      return empleadoId;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<CursosUi>> getListCursos(int empleadoId, int anioAcademicoId, int programaEducativoId) async{
    AppDataBase SQL = AppDataBase();
    List<CursosUi> cursosUiList = [];

    List<int> cargaCursosIdList = [];

    var query = SQL.select(SQL.cargaCurso).join([
      innerJoin(SQL.cargaAcademica, SQL.cargaAcademica.cargaAcademicaId.equalsExp(SQL.cargaCurso.cargaAcademicaId)),
      innerJoin(SQL.anioAcademico, SQL.anioAcademico.idAnioAcademico.equalsExp(SQL.cargaAcademica.idAnioAcademico)),
      innerJoin(SQL.planCursos, SQL.planCursos.planCursoId.equalsExp(SQL.cargaCurso.planCursoId)),
      innerJoin(SQL.planEstudio, SQL.planEstudio.planEstudiosId.equalsExp(SQL.planCursos.planEstudiosId)),
      innerJoin(SQL.programasEducativo, SQL.programasEducativo.programaEduId.equalsExp(SQL.planEstudio.programaEduId))
    ]);

    query.where(SQL.cargaCurso.empleadoId.equals(empleadoId));
    query.where(SQL.cargaCurso.complejo.isNull());
    query.where(SQL.anioAcademico.idAnioAcademico.equals(anioAcademicoId));
    query.where(SQL.programasEducativo.programaEduId.equals(programaEducativoId));

    for(var row in await query.get()){
      cargaCursosIdList.add(row.readTable(SQL.cargaCurso).cargaCursoId);
    }

    var queryComplejo = SQL.select(SQL.cargaCurso).join([
      innerJoin(SQL.cargaCursoDocente, SQL.cargaCursoDocente.cargaCursoId.equalsExp(SQL.cargaCurso.cargaCursoId)),
      innerJoin(SQL.cargaCursoDocenteDet, SQL.cargaCursoDocente.cargaCursoDocenteId.equalsExp(SQL.cargaCursoDocenteDet.cargaCursoDocenteId)),
      innerJoin(SQL.cargaAcademica, SQL.cargaAcademica.cargaAcademicaId.equalsExp(SQL.cargaCurso.cargaAcademicaId)),
      innerJoin(SQL.anioAcademico, SQL.anioAcademico.idAnioAcademico.equalsExp(SQL.cargaAcademica.idAnioAcademico)),
      innerJoin(SQL.planCursos, SQL.planCursos.planCursoId.equalsExp(SQL.cargaCurso.planCursoId)),
      innerJoin(SQL.planEstudio, SQL.planEstudio.planEstudiosId.equalsExp(SQL.planCursos.planEstudiosId)),
      innerJoin(SQL.programasEducativo, SQL.programasEducativo.programaEduId.equalsExp(SQL.planEstudio.programaEduId))
    ]);

    queryComplejo.where(SQL.cargaCursoDocente.docenteId.equals(empleadoId));
    queryComplejo.where(SQL.cargaCurso.complejo.equals(1));
    queryComplejo.where(SQL.anioAcademico.idAnioAcademico.equals(anioAcademicoId));
    query.where(SQL.programasEducativo.programaEduId.equals(programaEducativoId));

    for(var row in await queryComplejo.get()){
      cargaCursosIdList.add(row.readTable(SQL.cargaCurso).cargaCursoId);
    }



    return await getCurosCompletos(cargaCursosIdList, empleadoId);
  }

  Future<List<CursosUi>> getCurosCompletos(List<int> cargaCursosIdList, int empleadoId) async{
    List<CursosUi> cursosUiList = [];
    AppDataBase SQL = AppDataBase();
    var queryCursos = SQL.select(SQL.cargaCurso).join([
      innerJoin(SQL.planCursos, SQL.planCursos.planCursoId.equalsExp(SQL.cargaCurso.planCursoId)),
      innerJoin(SQL.cursos, SQL.planCursos.cursoId.equalsExp(SQL.cursos.cursoId)),
      innerJoin(SQL.planEstudio, SQL.planCursos.planEstudiosId.equalsExp(SQL.planEstudio.planEstudiosId)),
      innerJoin(SQL.cargaAcademica, SQL.cargaCurso.cargaAcademicaId.equalsExp(SQL.cargaAcademica.cargaAcademicaId)),
      innerJoin(SQL.seccion, SQL.seccion.seccionId.equalsExp(SQL.cargaAcademica.seccionId)),
      innerJoin(SQL.periodos, SQL.periodos.periodoId.equalsExp(SQL.cargaAcademica.periodoId)),
      innerJoin(SQL.aula, SQL.aula.aulaId.equalsExp(SQL.cargaAcademica.aulaId)),
      leftOuterJoin(SQL.silaboEvento, SQL.silaboEvento.cargaCursoId.equalsExp(SQL.cargaCurso.cargaCursoId)),
      leftOuterJoin(SQL.parametrosDisenio, SQL.parametrosDisenio.parametroDisenioId.equalsExp(SQL.silaboEvento.parametroDisenioId))
    ]);

    queryCursos.where(SQL.cargaCurso.cargaCursoId.isIn(cargaCursosIdList));

    ParametrosDisenioData? defaultParametrosDisenioData = await (SQL.selectSingle(SQL.parametrosDisenio)..where((tbl) => tbl.nombre.equals("default"))).getSingleOrNull();

    for(var row in await queryCursos.get()){
      CursosUi cursosUi = CursosUi();
      CargaCursoData cargaCursoData = row.readTable(SQL.cargaCurso);
      CargaAcademicaData cargaAcademicaData = row.readTable(SQL.cargaAcademica);
      Curso curso = row.readTable(SQL.cursos);
      Periodo periodo = row.readTable(SQL.periodos);
      SeccionData seccionData = row.readTable(SQL.seccion);
      AulaData aula = row.readTable(SQL.aula);
      SilaboEventoData? silaboEventoData = row.readTableOrNull(SQL.silaboEvento);
      ParametrosDisenioData? parametrosDisenioData = row.readTableOrNull(SQL.parametrosDisenio);

      cursosUi.cargaCursoId = cargaCursoData.cargaCursoId;
      cursosUi.cargaAcademicaId = cargaAcademicaData.cargaAcademicaId;
      cursosUi.nombreCurso = curso.nombre;
      cursosUi.gradoSeccion = (periodo.nombre??"") + " - " + (seccionData.nombre??"");
      cursosUi.gradoSeccion2 = (periodo.aliasPeriodo??"") + " " + (seccionData.nombre??"");
      cursosUi.nroSalon = aula.numero;
      cursosUi.silaboEventoId = silaboEventoData!=null?silaboEventoData.silaboEventoId:0;
      cursosUi.color1 = parametrosDisenioData!=null?parametrosDisenioData.color1 :
      defaultParametrosDisenioData != null?defaultParametrosDisenioData.color1 : "";
      cursosUi.color2 = parametrosDisenioData!=null?parametrosDisenioData.color2 :
      defaultParametrosDisenioData != null?defaultParametrosDisenioData.color2 : "";
      cursosUi.color3 = parametrosDisenioData!=null?parametrosDisenioData.color3 :
      defaultParametrosDisenioData != null?defaultParametrosDisenioData.color3 : "";
      cursosUi.banner = parametrosDisenioData!=null?parametrosDisenioData.path :
      defaultParametrosDisenioData != null?defaultParametrosDisenioData.path : "";

      if(silaboEventoData!=null){
        switch(silaboEventoData.estadoId){
          case SILABO_ESTADO_CREADO:
            cursosUi.estadoSilabo = EstadoSilabo.NO_AUTORIZADO;
            break;
          default:
            cursosUi.estadoSilabo = EstadoSilabo.AUTORIZADO;
            break;
        }
      }else{
        cursosUi.estadoSilabo = EstadoSilabo.SIN_SILABO;
      }
      cursosUi.cantidadPersonas = 0;
      cursosUi.tutor = cargaAcademicaData.idEmpleadoTutor == empleadoId;
      cursosUiList.add(cursosUi);
    }
    cursosUiList.sort((o1,o2)=> (o1.nombreCurso??"").compareTo((o2.nombreCurso??"")));
    return cursosUiList;

  }

  @override
  Future<CursosUi?> getCurso(int cargaCursoId)async {
    List<CursosUi> cursosList = await getCurosCompletos([cargaCursoId], 0);
    if(cursosList.isNotEmpty)return cursosList[0];
    return null;
  }

  @override
  Future<void> updateSessionProgramaEducativoId(int programaEducativoId) async {
    AppDataBase SQL = AppDataBase();
    try{
      SessionUserData? sessionUserData = await(SQL.selectSingle(SQL.sessionUser).getSingleOrNull());
      if(sessionUserData!=null){
        await SQL.update(SQL.sessionUser).replace(sessionUserData.copyWith(programaEducativoId: programaEducativoId));
      }
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<CursosUi>> getFotoAlumnos(int empleadoId, int anioAcademicoIdSelec) async {
    AppDataBase SQL = AppDataBase();

    var query = SQL.select(SQL.contactoDocente)..where((tbl) => tbl.idEmpleadoTutor.equals(empleadoId));
    query.where((tbl) => tbl.tipo.equals(ConfiguracionRepository.CONTACTO_ALUMNO));
    query.where((tbl) => tbl.anioAcademicoId.equals(anioAcademicoIdSelec));
    List<CursosUi> cursoUiList = [];

    for(ContactoDocenteData contactoData in await query.get()){
    if(!(contactoData.contratoVigente??false))continue;
    CursosUi? cursosUiTutorUi = cursoUiList.firstWhereOrNull((element) => element.cargaAcademicaId == contactoData.cargaAcademicaId);
      if(cursosUiTutorUi==null){
        cursosUiTutorUi = CursosUi();
        cursosUiTutorUi.cargaAcademicaId = contactoData.cargaAcademicaId;
        cursosUiTutorUi.tutor = true;
        cursosUiTutorUi.nombreCurso = "${contactoData.periodoNombre??""} ${contactoData.grupoNombre??""} - ${contactoData.programaNombre??""}";
        cursosUiTutorUi.alumnoUiList = [];
        cursoUiList.add(cursosUiTutorUi);
      }


    /*CursosUi? cursosUi = cursoUiList.firstWhereOrNull((element) => element.cargaAcademicaId == contactoData.cargaAcademicaId && element.cargaCursoId == contactoData.cargaCursoId);
      if(cursosUi==null){
        cursosUi = CursosUi();
        cursosUi.cargaAcademicaId = contactoData.cargaAcademicaId;
        cursosUi.cargaCursoId = contactoData.cargaCursoId;
        cursosUi.nombreCurso = "${contactoData.cursoNombre} ${contactoData.periodoNombre??""} ${contactoData.grupoNombre??""} - ${contactoData.programaNombre??""}";
        cursosUi.alumnoUiList = [];
        cursoUiList.add(cursosUi);
      }*/

      PersonaUi? personaUi = cursosUiTutorUi.alumnoUiList?.firstWhereOrNull((element) => element.personaId == contactoData.personaId);
      if(personaUi == null){
        personaUi = transformarPersona(contactoData);
        cursosUiTutorUi.alumnoUiList?.add(personaUi);
      }

    /*PersonaUi? personaUi2 = cursosUi.alumnoUiList?.firstWhereOrNull((element) => element.personaId == contactoData.personaId);
      if(personaUi2 == null){
        personaUi2 = transformarPersona(contactoData);
        cursosUi.alumnoUiList?.add(personaUi2);
      }*/
    }

    return cursoUiList;
  }


  PersonaUi transformarPersona(ContactoDocenteData contactoData){
    PersonaUi personaUi = new PersonaUi();
    personaUi.personaId = contactoData.personaId;
    personaUi.foto = contactoData.foto;
    personaUi.nombreCompleto = '${DomainTools.capitalize(contactoData.apellidoPaterno??"")} ${DomainTools.capitalize(contactoData.apellidoMaterno??"")}, ${DomainTools.capitalize(contactoData.nombres??"")}';
    personaUi.nombres = DomainTools.capitalize(contactoData.nombres??"");
    personaUi.apellidos  = '${DomainTools.capitalize(contactoData.apellidoPaterno??"")} ${DomainTools.capitalize(contactoData.apellidoMaterno??"")}';
    personaUi.contratoVigente =  contactoData.contratoVigente??false;
    personaUi.telefono = contactoData.celular!=null?contactoData.celular: contactoData.telefono??"";
    return personaUi;
  }

  @override
  Future<void> saveContactoDocente(Map<String, dynamic> contactoDocente, int empleadoId, int anioAcademicoIdSelect) async {
    print("contactosSerialList: jse");
    AppDataBase SQL = AppDataBase();
    try{
      await SQL.batch((batch) async {
        // functions in a batch don't have to be awaited - just
        // await the whole batch afterwards.
        //rubroEvalList.add(SerializableConvert.converSerializeRubroEvalDesempenio(item));
        //batch.deleteWhere(SQL.contactoDocente, (row) => const Constant(true));
        //

        await (SQL.delete(SQL.contactoDocente)..where((tbl) => tbl.anioAcademicoId.equals(anioAcademicoIdSelect))).go();

        List<ContactoDocenteData> contactoDocenteDataList = [];
        print("contactosSerialList: init");
        List<PersonasContactoSerial> personasSerialList = [];
        Iterable personas = contactoDocente["personas"];
        for(var item in personas){
          personasSerialList.add(PersonasContactoSerial.fromJson(item));
        }

        List<ContactosSerial> contactosSerialList = [];
        Iterable contactos = contactoDocente["contactos"];
        for(var item in contactos){
          contactosSerialList.add(ContactosSerial.fromJson(item));
        }

        List<CargaCursosContactoSerial> cargaCursosSerialList = [];
        Iterable cargaCursos = contactoDocente["cargaCursos"];
        for(var item in cargaCursos){
          cargaCursosSerialList.add(CargaCursosContactoSerial.fromJson(item));
        }
        print("contactosSerialList: ${contactosSerialList.length}");
        for(ContactosSerial contactosSerial in contactosSerialList){
          PersonasContactoSerial? personasContactoSerial = personasSerialList.firstWhereOrNull((element) => element.personaId == contactosSerial.personaId);
          CargaCursosContactoSerial? cargaCursosContactoSerial = cargaCursosSerialList.firstWhereOrNull((element) => element.cargaCursoId == contactosSerial.cargaCursoId);
          contactoDocenteDataList.add(ContactoDocenteData(
              anioAcademicoId: anioAcademicoIdSelect,
              personaId: contactosSerial.personaId??0,
              tipo: contactosSerial.tipo??0,
              cargaCursoId: contactosSerial.cargaCursoId??0,
              //nombreTipo: serial.nombres,
              cursoId: cargaCursosContactoSerial?.cursoId,
              cursoNombre: cargaCursosContactoSerial?.cursoNombre,
              aulaId: cargaCursosContactoSerial?.aulaId,
              aulaNombre: cargaCursosContactoSerial?.aulaNombre,
              grupoId: cargaCursosContactoSerial?.grupoId,
              grupoNombre: cargaCursosContactoSerial?.grupoNombre,
              contratoEstadoId: contactosSerial.contratoEstadoId,
              contratoVigente: contactosSerial.contratoVigente,
              periodoId: cargaCursosContactoSerial?.periodoId,
              periodoNombre: cargaCursosContactoSerial?.periodoNombre,
              //hijoRelacionId: contactosSerial.hijoRelacionId,
              //relacionId: contactosSerial.relacionId,
              relacion: contactosSerial.relacion,
              //estadoId: contactosSerial.estadoId,
              nombres: personasContactoSerial?.nombres,
              apellidoPaterno: personasContactoSerial?.apellidoPaterno,
              apellidoMaterno: personasContactoSerial?.apellidoMaterno,
              celular: personasContactoSerial?.celular,
              telefono: personasContactoSerial?.telefono,
              correo: personasContactoSerial?.correo,
              celularApoderado: personasContactoSerial?.celularApoderado,
              telefonoApoderado: personasContactoSerial?.telefonoApoderado,
              //estadoCivil: personasContactoSerial?.estadoCivil,
              //fechaNac: personasContactoSerial?.fechaNac,
              //ocupacion: personasContactoSerial?.ocupacion,
              //numDoc: personasContactoSerial?.numDoc,
              //genero: personasContactoSerial?.genero,
              foto: personasContactoSerial?.foto,
              programaId: cargaCursosContactoSerial?.programaId,
              programaNombre: cargaCursosContactoSerial?.programaNombre,
              cargaAcademicaId: cargaCursosContactoSerial?.cargaAcademicaId,
              idEmpleadoTutor: contactosSerial.idEmpleadoTutor

          ));
        }
        batch.insertAll(SQL.contactoDocente, contactoDocenteDataList, mode: InsertMode.insertOrReplace );



      });
    }catch(e){
      throw Exception(e);
    }


  }

  @override
  Future<List<ContactoUi>> getListContacto(int empleadoId, int anioAcademicoIdSelect) async{
    AppDataBase SQL = AppDataBase();
      List<ContactoUi> contactoUiList = [];

      final padre = SQL.alias(SQL.contactoDocente, 'padre');
      final apoderado = SQL.alias(SQL.contactoDocente, 'apoderado');

      var query = SQL.select(SQL.contactoDocente).join([
        leftOuterJoin(padre, padre.hijoRelacionId.equalsExp(SQL.contactoDocente.personaId)),
        leftOuterJoin(apoderado, apoderado.hijoRelacionId.equalsExp(SQL.contactoDocente.personaId))
      ]);
      query.where(SQL.contactoDocente.anioAcademicoId.equals(anioAcademicoIdSelect));

      query.groupBy([SQL.contactoDocente.personaId, SQL.contactoDocente.tipo]);
      var rows = await query.get();

      for(var row  in rows){
        ContactoDocenteData contactoData = row.readTable(SQL.contactoDocente);
        //ContactoDocenteData? padreData = row.readTableOrNull(padre);
        //ContactoDocenteData? apoderadoData = row.readTableOrNull(padre);
        //ContactoUi? contactoUi = contactoUiList.firstWhereOrNull((element) => element.personaUi?.personaId == contactoData.personaId && element.tipo == contactoData.tipo);
        ContactoUi contactoUi = new ContactoUi();
        contactoUi.personaUi = PersonaUi();
        contactoUi.personaUi?.personaId = contactoData.personaId;
        contactoUi.personaUi?.contratoVigente = contactoData.contratoVigente??false;
        contactoUi.relacionList = [];
        contactoUi.personaUi?.foto = contactoData.foto;
        if((contactoData.nombres??"").isEmpty){
          print("Desconocido");
        }

        contactoUi.personaUi?.nombreCompleto = '${DomainTools.capitalize(contactoData.apellidoPaterno??"")} ${DomainTools.capitalize(contactoData.apellidoMaterno??"")}, ${DomainTools.capitalize(contactoData.nombres??"")}';
        contactoUi.relacion = contactoData.relacion;
        contactoUi.personaUi?.telefono = contactoData.celular!=null?contactoData.celular: contactoData.telefono??"";

        /*if(padreData!=null){
          ContactoUi padreUi = new ContactoUi();
          padreUi.personaUi?.personaId = padreData.personaId;
          padreUi.relacion = padreData.relacion;
          contactoUi.relacionList?.add(padreUi);
        }*/


        contactoUi.apoderadoTelfono = contactoData.celularApoderado!=null?contactoData.celularApoderado: contactoData.telefonoApoderado??"";


        contactoUi.tipo = contactoData.tipo;
        contactoUiList.add(contactoUi);
      }

      print("getContactos: "+contactoUiList.length.toString());
      return contactoUiList;

  }

  @override
  Future<int> getGeoreferenciaId() async {
    AppDataBase SQL = AppDataBase();
    try{
      SessionUserData? sessionUserData =  await SQL.selectSingle(SQL.sessionUser).getSingleOrNull();
       int anioAcademicoId = sessionUserData!=null?sessionUserData.anioAcademicoId??0:0;
       AnioAcademicoData? academicoData = await (SQL.selectSingle(SQL.anioAcademico)..where((tbl) => tbl.idAnioAcademico.equals(anioAcademicoId))).getSingleOrNull();
       return academicoData?.georeferenciaId??0;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<PersonaUi>> getListAlumnoCurso(int cargaCursoId)async {
    AppDataBase SQL = AppDataBase();
    List<PersonaUi> contactoUiList = [];
    print("cargaCursoId: " + cargaCursoId.toString());
    var query = SQL.select(SQL.contactoDocente)..where((tbl) => SQL.contactoDocente.cargaCursoId.equals(cargaCursoId));
    query.where((tbl) => tbl.tipo.equals(ConfiguracionRepository.CONTACTO_ALUMNO));
    query.orderBy([(tbl)=> OrderingTerm.asc(tbl.apellidoPaterno)]);


    List<ContactoDocenteData> contactoDocenteList = await query.get();
    for(ContactoDocenteData contactoData  in contactoDocenteList){
        PersonaUi personaUi = new PersonaUi();
        personaUi.personaId = contactoData.personaId;
        personaUi.foto = contactoData.foto;
        personaUi.nombreCompleto = '${DomainTools.capitalize(contactoData.apellidoPaterno??"")} ${DomainTools.capitalize(contactoData.apellidoMaterno??"")}, ${DomainTools.capitalize(contactoData.nombres??"")}';
        personaUi.nombres = DomainTools.capitalize(contactoData.nombres??"");
        personaUi.apellidos  = '${DomainTools.capitalize(contactoData.apellidoPaterno??"")} ${DomainTools.capitalize(contactoData.apellidoMaterno??"")}';
        personaUi.contratoVigente =  contactoData.contratoVigente??false;
        personaUi.telefono = contactoData.celular!=null?contactoData.celular: contactoData.telefono??"";
        contactoUiList.add(personaUi);
    }
    return contactoUiList;
  }

  @override
  Future<bool> cerrrarSession() async{
    AppDataBase SQL = AppDataBase();
    try{
      for (final table in SQL.allTables) {
        await SQL.delete(table).go();
      }
      return true;
    }catch(e){
      return false;
    }
  }

  @override
  Future<String?> getServerIcono() async{
    AppDataBase SQL = AppDataBase();
    WebConfig? webConfig = await(SQL.selectSingle(SQL.webConfigs)..where((tbl) => tbl.nombre.equals("wstr_icono_padre"))).getSingleOrNull();
    print("wstr_icono_padre: ${webConfig?.content}");

    return webConfig?.content;
  }

  @override
  Future<void> updatePersona(PersonaUi? personaUi) async{
    AppDataBase SQL = AppDataBase();
    PersonaData? personaData = await (SQL.selectSingle(SQL.persona)..where((tbl) => tbl.personaId.equals(personaUi?.personaId))).getSingleOrNull();
    print("personaUi save ${personaUi?.foto}");
    if(personaData!=null)await SQL.update(SQL.persona).replace(personaData.copyWith(celular: personaUi?.telefono, correo: personaUi?.correo, foto: personaUi?.foto??personaData.foto));
  }

  @override
  PersonaUi transformarUpdatePersona(Map<String, dynamic> jsonPersona) {
    PersonaSerial personaSerial = PersonaSerial.fromJson(jsonPersona);
    PersonaUi personaUi = PersonaUi();
    personaUi.personaId = personaSerial.personaId;
    personaUi.correo = personaSerial.correo;
    personaUi.telefono = personaSerial.celular;
    personaUi.foto = personaSerial.foto;
    return personaUi;
  }

  @override
  Future<void> udpateUsuarioAnioAcademico(int usuarioId, Map<String, dynamic> usuarioJson) async{
    AppDataBase SQL = AppDataBase();
    UsuarioUi usuarioUi = UsuarioUi();
    UsuarioData usuarioData = UsuarioData.fromJson(usuarioJson);
    PersonaData? personaUpdate = null;
    if(usuarioJson.containsKey("persona")){
      personaUpdate = SerializableConvert.converSerializePersona(usuarioJson["persona"]);
    }

    await SQL.batch((batch) async {
      if(usuarioJson.containsKey("entidades")){
        //personaSerelizable.addAll(datosInicioPadre["usuariosrelacionados"]);
        //database.personaDao.insertAllTodo(SerializableConvert.converListSerializePersona(datosInicioPadre["personas"]));
        batch.deleteWhere(SQL.entidad, (row) => const Constant(true));
        batch.insertAll(SQL.entidad, SerializableConvert.converListSerializeEntidad(usuarioJson["entidades"]), mode: InsertMode.insertOrReplace);
      }

      if(usuarioJson.containsKey("georeferencias")){
        batch.deleteWhere(SQL.georeferencia, (row) => const Constant(true));
        batch.insertAll(SQL.georeferencia, SerializableConvert.converListSerializeGeoreferencia(usuarioJson["georeferencias"]), mode: InsertMode.insertOrReplace );
      }

      if(usuarioJson.containsKey("usuarioRolGeoreferencias")){
        //personaSerelizable.addAll(datosInicioPadre["usuariosrelacionados"]);
        batch.deleteWhere(SQL.usuarioRolGeoreferencia, (row) => const Constant(true));
        batch.insertAll(SQL.usuarioRolGeoreferencia, SerializableConvert.converListSerializeUsuarioRolGeoreferencia(usuarioJson["usuarioRolGeoreferencias"]), mode: InsertMode.insertOrReplace);
      }

      if(usuarioJson.containsKey("anioAcademicos")){

        List<AnioAcademicoData> anioAcademicoList = [];
        List<AnioAcademicoData> anioAcademicoLast = await SQL.select(SQL.anioAcademico).get();
        for(AnioAcademicoData academicoData in SerializableConvert.converListSerializeAnioAcademico(usuarioJson["anioAcademicos"])){

          AnioAcademicoData? last = anioAcademicoLast.firstWhereOrNull((element) => academicoData.idAnioAcademico == element.idAnioAcademico);
          if(last!=null){
            anioAcademicoList.add(academicoData.copyWith(toogle: last.toogle));
          }else{
            anioAcademicoList.add(academicoData);
          }

        }
        batch.deleteWhere(SQL.anioAcademico, (row) => const Constant(true));
        batch.insertAll(SQL.anioAcademico, anioAcademicoList, mode: InsertMode.insertOrReplace );

        print("anioAcademicos finished");
      }
    });


    if(usuarioData.usuarioId == usuarioId){
      SessionUserData? sessionUserData =  await SQL.selectSingle(SQL.sessionUser).getSingleOrNull();
      if(sessionUserData!=null){

        /*habilitarAcceso = null  se habilita el acceso
      * habilitarAcceso = true  se habilita el acceso
      * habilitarAcceso = false se desabilita el acceso*/
        bool desabilitar = false;
        if(usuarioData.habilitarAcceso==null){
          desabilitar = false;
        }else if(usuarioData.habilitarAcceso == true){
          desabilitar = false;
        }else if(usuarioData.habilitarAcceso == false){
          desabilitar = true;
        }

        SQL.update(SQL.sessionUser).replace(sessionUserData.copyWith(
            desabilitar: desabilitar
        ));
        usuarioUi.desabilitar = desabilitar;
      }

      print("personaData: ${personaUpdate?.personaId}");
      PersonaData? personaData =  await (SQL.selectSingle(SQL.persona)..where((tbl) => tbl.personaId.equals(personaUpdate?.personaId))).getSingleOrNull();
      if(personaData!=null && personaUpdate!=null){
        print("personaData: ${personaUpdate.foto}");
        SQL.update(SQL.persona).replace(personaData.copyWith(
           foto: personaUpdate.foto,
           correo:  personaUpdate.correo,
            telefono: personaUpdate.telefono,
            celular: personaData.celular,
            fechaNac: personaData.fechaNac,

        ));

      }
    }

  }

}