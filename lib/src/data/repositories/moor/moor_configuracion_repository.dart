import 'package:moor_flutter/moor_flutter.dart';
import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/data/helpers/serelizable/rest_api_response.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/aula.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/carga_cursos.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/anio_acemico_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/login_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/programa_educativo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/app_tools.dart';

import 'database/app_database.dart';

class MoorConfiguracionRepository extends ConfiguracionRepository{

  static const int ANIO_ACADEMICO_MATRICULA = 192, ANIO_ACADEMICO_ACTIVO = 193, ANIO_ACADEMICO_CERRADO = 194, ANIO_ACADEMICO_CREADO = 195, ANIO_ACADEMICO_ELIMINADO = 196;
  static const int SILABO_ESTADO_CREADO = 243, SILABO_ESTADO_AUTORIZADO = 244, SILABO_ESTADO_PROCESO = 245, SILABO_ESTADO_PUBLICADO = 246, SILABO_ESTADO_ELIMINADO = 397;
  static const int CONTACTO_DOCENTE = 3, CONTACTO_DIRECTIVO = 4, CONTACTO_ALUMNO = 1, CONTACTO_PADRE = 2, CONTACTO_APODERADO = 5;

  @override
  Future<bool> validarUsuario() async{
    AppDataBase SQL = AppDataBase();
    try{

      SessionUserData sessionUserData = await (SQL.selectSingle(SQL.sessionUser)).getSingle();//El ORM genera error si hay dos registros

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
      SessionUserData sessionUserData =  await SQL.selectSingle(SQL.sessionUser).getSingle();
      return sessionUserData!=null?sessionUserData.userId:0;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<String> getSessionUsuarioUrlServidor() async{
    AppDataBase SQL = AppDataBase();
    try{
      SessionUserData sessionUserData =  await SQL.selectSingle(SQL.sessionUser).getSingle();
      return sessionUserData.urlServerLocal??"";
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<int> getSessionAnioAcademicoId()async {
    AppDataBase SQL = AppDataBase();
    try{
      SessionUserData sessionUserData =  await SQL.selectSingle(SQL.sessionUser).getSingle();
      return sessionUserData!=null?sessionUserData.anioAcademicoId??0:0;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<int> getSessionProgramaEducativoId() async{
    AppDataBase SQL = AppDataBase();
    try{
      SessionUserData sessionUserData =  await SQL.selectSingle(SQL.sessionUser).getSingle();
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


        int usuarioId = 0;
        int personaId = 0;
        String usuario = "";
        String password = "";
        bool estado = false;
        String numDoc = "";
        bool habilitarAcceso = false;
        String nombres = "";
        String apellidoPaterno = "";
        String apellidoMaterno = "";
        String fotoPersona = "";
        String fotoEntidad = "";

        if(datosUsuario.containsKey("usuarioId")){
            usuarioId = datosUsuario["usuarioId"];
        }
        if(datosUsuario.containsKey("personaId")){
          personaId = datosUsuario["personaId"];
        }
        if(datosUsuario.containsKey("usuario")){
          usuario = datosUsuario["usuario"];
        }
        if(datosUsuario.containsKey("password")){
          password = datosUsuario["password"];
        }
        if(datosUsuario.containsKey("estado")){
          estado = datosUsuario["estado"];
        }
        if(datosUsuario.containsKey("numDoc")){
          numDoc = datosUsuario["numDoc"];
        }
        if(datosUsuario.containsKey("habilitarAcceso")){
          habilitarAcceso = datosUsuario["habilitarAcceso"];
        }
        if(datosUsuario.containsKey("nombres")){
          nombres = datosUsuario["nombres"];
        }
        if(datosUsuario.containsKey("apellidoPaterno")){
          apellidoPaterno = datosUsuario["apellidoPaterno"];
        }
        if(datosUsuario.containsKey("apellidoMaterno")){
          apellidoMaterno = datosUsuario["apellidoMaterno"];
        }
        if(datosUsuario.containsKey("fotoPersona")){
          fotoPersona = datosUsuario["fotoPersona"];
        }
        if(datosUsuario.containsKey("fotoEntidad")){
          fotoEntidad = datosUsuario["fotoEntidad"];
        }
        batch.deleteWhere(SQL.usuario, (row) => const Constant(true));
        batch.deleteWhere(SQL.persona, (row) => const Constant(true));
        batch.insert(SQL.usuario, UsuarioData(usuarioId: usuarioId, personaId: personaId, usuario: usuario, estado: estado, habilitarAcceso: habilitarAcceso));
        batch.insert(SQL.persona, PersonaData(personaId: personaId, nombres: nombres, apellidoPaterno: apellidoPaterno, apellidoMaterno: apellidoMaterno,foto: fotoPersona));


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

        if(datosUsuario.containsKey("usuarioRolGeoreferencias")){
          //personaSerelizable.addAll(datosInicioPadre["usuariosrelacionados"]);
          batch.deleteWhere(SQL.usuarioRolGeoreferencia, (row) => const Constant(true));
          batch.insertAll(SQL.usuarioRolGeoreferencia, SerializableConvert.converListSerializeUsuarioRolGeoreferencia(datosUsuario["usuarioRolGeoreferencias"]), mode: InsertMode.insertOrReplace);
        }
      });
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> updateUsuarioSuccessData(int usuarioId, int anioAcademicoId) async {
    AppDataBase SQL = AppDataBase();
    try{
      SessionUserData sessionUserData = await(SQL.selectSingle(SQL.sessionUser).getSingle());
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
      UsuarioRolGeoreferenciaData usuarioRolGeoreferenciaData = await query.getSingle();
      return usuarioRolGeoreferenciaData!=null;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> saveDatosAnioAcademico(Map<String, dynamic> datosAnioAcademico) async{
    AppDataBase SQL = AppDataBase();
    try{
      await SQL.batch((batch) async {


        if(datosAnioAcademico.containsKey("aulas")){
          batch.deleteWhere(SQL.aula, (row) => const Constant(true));
          batch.insertAll(SQL.aula, SerializableConvert.converListSerializeAula(datosAnioAcademico["aulas"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("cargasAcademicas")){
          batch.deleteWhere(SQL.cargaAcademica, (row) => const Constant(true));
          batch.insertAll(SQL.cargaAcademica, SerializableConvert.converListSerializeCargaAcademica(datosAnioAcademico["cargasAcademicas"]), mode: InsertMode.insertOrReplace );
        }

        if(datosAnioAcademico.containsKey("cargaCursoDocente")){
          batch.deleteWhere(SQL.cargaCursoDocente, (row) => const Constant(true));
          batch.insertAll(SQL.cargaCursoDocente, SerializableConvert.converListSerializeCargaCursoDocente(datosAnioAcademico["cargaCursoDocente"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("cargaCursoDocenteDet")){
          batch.deleteWhere(SQL.cargaCursoDocenteDet, (row) => const Constant(true));
          batch.insertAll(SQL.cargaCursoDocenteDet, SerializableConvert.converListSerializeCargaCursoDocenteDet(datosAnioAcademico["cargaCursoDocenteDet"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("cargaCursos")){
          batch.deleteWhere(SQL.cargaCurso, (row) => const Constant(true));
          batch.insertAll(SQL.cargaCurso, SerializableConvert.converListSerializeCargaCurso(datosAnioAcademico["cargaCursos"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("cursos")){
          batch.deleteWhere(SQL.cursos, (row) => const Constant(true));
          batch.insertAll(SQL.cursos, SerializableConvert.converListSerializeCursos(datosAnioAcademico["cursos"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("parametrosDisenio")){
          batch.deleteWhere(SQL.parametrosDisenio, (row) => const Constant(true));
          batch.insertAll(SQL.parametrosDisenio, SerializableConvert.converListSerializeParametrosDisenio(datosAnioAcademico["parametrosDisenio"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("nivelesAcademicos")){
          batch.deleteWhere(SQL.nivelAcademico, (row) => const Constant(true));
          batch.insertAll(SQL.nivelAcademico, SerializableConvert.converListSerializeNivelAcademico(datosAnioAcademico["nivelesAcademicos"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("periodos")){
          batch.deleteWhere(SQL.periodos, (row) => const Constant(true));
          batch.insertAll(SQL.periodos, SerializableConvert.converListSerializePeriodos(datosAnioAcademico["periodos"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("planCursos")){
          batch.deleteWhere(SQL.planCursos, (row) => const Constant(true));
          batch.insertAll(SQL.planCursos, SerializableConvert.converListSerializePlanCurso(datosAnioAcademico["planCursos"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("planEstudios")){
          batch.deleteWhere(SQL.planEstudio, (row) => const Constant(true));
          batch.insertAll(SQL.planEstudio, SerializableConvert.converListSerializePlanEstudio(datosAnioAcademico["planEstudios"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("programasEducativos")){
          batch.deleteWhere(SQL.programasEducativo, (row) => const Constant(true));
          batch.insertAll(SQL.programasEducativo, SerializableConvert.converListSerializeProgramasEducativo(datosAnioAcademico["programasEducativos"]), mode: InsertMode.insertOrReplace);
        }

        if(datosAnioAcademico.containsKey("secciones")){
          batch.deleteWhere(SQL.seccion, (row) => const Constant(true));
          batch.insertAll(SQL.seccion, SerializableConvert.converListSerializeSeccion(datosAnioAcademico["secciones"]), mode: InsertMode.insertOrReplace);
        }


        if(datosAnioAcademico.containsKey("silaboEvento")){
          batch.deleteWhere(SQL.silaboEvento, (row) => const Constant(true));
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
          batch.deleteWhere(SQL.calendarioAcademico, (row) => const Constant(true));
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
    var query =  await SQL.select(SQL.persona).join([
      innerJoin(SQL.usuario, SQL.usuario.personaId.equalsExp(SQL.persona.personaId))
    ]);

    query.where(SQL.usuario.usuarioId.equals(usuarioId));
    var resultRow = await query.getSingle();
    PersonaData personaData = resultRow.readTable(SQL.persona);

    String fechaNacimiento = "";
    if(personaData.fechaNac !=null && personaData.fechaNac!.isNotEmpty){
      DateTime fecPad = AppTools.convertDateTimePtBR(personaData.fechaNac!, null);
      fechaNacimiento = "${AppTools.calcularEdad(fecPad)} años (${AppTools.f_fecha_anio_mes_letras(fecPad)})";

    }

    UsuarioUi usuarioUi = UsuarioUi();
    usuarioUi.personaId = personaData.personaId;
    usuarioUi.nombre = '${AppTools.capitalize(personaData.nombres??"")} ${AppTools.capitalize(personaData.apellidoPaterno??"")} ${AppTools.capitalize(personaData.apellidoMaterno??"")}';
    usuarioUi.foto = '${personaData.foto??""}';
    usuarioUi.correo = personaData.correo??"";
    usuarioUi.celular = personaData.celular??personaData.telefono??"";
    usuarioUi.fechaNacimiento = fechaNacimiento;
    usuarioUi.nombreSimple = AppTools.capitalize(personaData.nombres??"");
    usuarioUi.fechaNacimiento2 = personaData.fechaNac??"";

    return usuarioUi;


  }

  @override
  Future<List<AnioAcademicoUi>> getAnioAcademicoList(int usuarioId) async {
    AppDataBase SQL = AppDataBase();
    List<AnioAcademicoUi> anioAcademicoUis =[];

    List<UsuarioRolGeoreferenciaData> usuarioRolGeoreferenciaList = await (SQL.select(SQL.usuarioRolGeoreferencia)..where((tbl) => tbl.usuarioId.equals(usuarioId))).get();

    List<int> gereferenciaIdList = [];
    for (UsuarioRolGeoreferenciaData usuarioRolGeoreferencia in usuarioRolGeoreferenciaList){
      gereferenciaIdList.add(usuarioRolGeoreferencia.geoReferenciaId??0);
    }

    List<AnioAcademicoData> anioAcademicoList = await (SQL.select(SQL.anioAcademico)..where((tbl) => tbl.georeferenciaId.isIn(gereferenciaIdList))).get();
    anioAcademicoList.sort((o2, o1) {

      int sComp =  AppTools.convertDateTimePtBR(o2.fechaFin, null).compareTo(AppTools.convertDateTimePtBR(o1.fechaFin, null));
      if (sComp != 0) {
        return sComp;
      }

      int x1 = o1.georeferenciaId??0;
      int x2 = o2.georeferenciaId??0;
      return x1.compareTo(x2);

    });

    int anioAcademicoId = await getSessionAnioAcademicoId();

    for (AnioAcademicoData anioAcademico in anioAcademicoList){
      AnioAcademicoUi anioAcademicoUi = new AnioAcademicoUi();
      anioAcademicoUi.anioAcademicoId = anioAcademico.idAnioAcademico;
      anioAcademicoUi.nombre = anioAcademico.nombre;
      anioAcademicoUi.georeferenciaId = anioAcademico.georeferenciaId;
      if(anioAcademico.estadoId== ANIO_ACADEMICO_ACTIVO){
        anioAcademicoUi.vigente = true;
      }
      anioAcademicoUi.toogle = anioAcademico.idAnioAcademico == anioAcademicoId;
      anioAcademicoUis.add(anioAcademicoUi);
    }

    return anioAcademicoUis;
  }

  @override
  Future<void> updateSessionAnioAcademicoId(int anioAcademicoId) async {
    AppDataBase SQL = AppDataBase();
    try{
      SessionUserData sessionUserData = await(SQL.selectSingle(SQL.sessionUser).getSingle());
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
    query.where(SQL.cargaCurso.complejo.equals(0));
    query.where(SQL.anioAcademico.idAnioAcademico.equals(anioAcademicoId));

    for(var row in await query.get()){
      cargaCursosList.add(row.readTable(SQL.cargaCurso));
    }

    var queryComplejo = SQL.select(SQL.cargaCurso).join([
      innerJoin(SQL.cargaCursoDocente, SQL.cargaCursoDocente.cargaCursoId.equalsExp(SQL.cargaCurso.cargaCursoId)),
      innerJoin(SQL.cargaCursoDocenteDet, SQL.cargaCursoDocente.cargaCursoDocenteId.equalsExp(SQL.cargaCursoDocenteDet.cargaCursoDocenteId)),
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
      var row = await query.getSingle();


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
    query.where(SQL.cargaCurso.complejo.equals(0));
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

    ParametrosDisenioData defaultParametrosDisenioData = await (SQL.selectSingle(SQL.parametrosDisenio)..where((tbl) => tbl.nombre.equals("default"))).getSingle();

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
      cursosUi.gradoSeccion = (periodo.aliasPeriodo??"") + " " + (seccionData.nombre??"");
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
      SessionUserData sessionUserData = await(SQL.selectSingle(SQL.sessionUser).getSingle());
      if(sessionUserData!=null){
        await SQL.update(SQL.sessionUser).replace(sessionUserData.copyWith(programaEducativoId: programaEducativoId));
      }
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> saveContactoDocente(Map<String, dynamic> contactoDocente, int empleadoId, int anioAcademicoIdSelect) async {

    AppDataBase SQL = AppDataBase();
    try{
      await SQL.batch((batch) async {
        // functions in a batch don't have to be awaited - just
        // await the whole batch afterwards.
        //rubroEvalList.add(SerializableConvert.converSerializeRubroEvalDesempenio(item));
        batch.deleteWhere(SQL.contactoDocente, (row) => const Constant(true));
        batch.insertAll(SQL.contactoDocente, SerializableConvert.converListSerializeContactoDocente(contactoDocente["contactos"]), mode: InsertMode.insertOrReplace );

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

      query.groupBy([SQL.contactoDocente.personaId, SQL.contactoDocente.tipo]);
      var rows = await query.get();

      for(var row  in rows){
        ContactoDocenteData contactoData = row.readTable(SQL.contactoDocente);
        ContactoDocenteData padreData = row.readTable(padre);
        ContactoDocenteData apoderadoData = row.readTable(padre);
        ContactoUi? contactoUi = contactoUiList.firstWhereOrNull((element) => element.personaUi?.personaId == contactoData.personaId && element.tipo == contactoData.tipo);
        if(contactoUi == null){
          contactoUi = new ContactoUi();
          contactoUi.personaUi = PersonaUi();
          contactoUi.personaUi?.personaId = contactoData.personaId;
          contactoUi.relacionList = [];
          contactoUi.personaUi?.foto = contactoData.foto;
          contactoUi.personaUi?.nombreCompleto = '${AppTools.capitalize(contactoData.nombres??"")} ${AppTools.capitalize(contactoData.apellidoPaterno??"")} ${AppTools.capitalize(contactoData.apellidoMaterno??"")}';
          contactoUi.relacion = contactoData.relacion;
          contactoUi.personaUi?.telefono = contactoData.celular!=null?contactoData.celular: contactoData.telefono??"";

        }

        if(padreData!=null){
          ContactoUi padreUi = new ContactoUi();
          contactoUi.personaUi = PersonaUi();
          padreUi.personaUi?.personaId = padreData.personaId;
          padreUi.relacion = padreData.relacion;
          contactoUi.relacionList?.add(padreUi);
        }

        if(apoderadoData!=null){
          contactoUi.apoderadoTelfono = apoderadoData.celular!=null?apoderadoData.celular: apoderadoData.telefono??"";
        }

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
      SessionUserData sessionUserData =  await SQL.selectSingle(SQL.sessionUser).getSingle();
       int anioAcademicoId = sessionUserData!=null?sessionUserData.anioAcademicoId??0:0;
       AnioAcademicoData academicoData = await (SQL.selectSingle(SQL.anioAcademico)..where((tbl) => tbl.idAnioAcademico.equals(anioAcademicoId))).getSingle();
       return academicoData.georeferenciaId??0;
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
    query.where((tbl) => tbl.tipo.equals(CONTACTO_ALUMNO));
    query.orderBy([(tbl)=> OrderingTerm.asc(tbl.apellidoPaterno)]);


    List<ContactoDocenteData> contactoDocenteList = await query.get();
    for(ContactoDocenteData contactoData  in contactoDocenteList){
        PersonaUi personaUi = new PersonaUi();
        personaUi.personaId = contactoData.personaId;
        personaUi.foto = contactoData.foto;
        personaUi.nombreCompleto = '${AppTools.capitalize(contactoData.nombres??"")} ${AppTools.capitalize(contactoData.apellidoPaterno??"")} ${AppTools.capitalize(contactoData.apellidoMaterno??"")}';
        personaUi.nombres = AppTools.capitalize(contactoData.nombres??"");
        personaUi.apellidos  = '${AppTools.capitalize(contactoData.apellidoPaterno??"")} ${AppTools.capitalize(contactoData.apellidoMaterno??"")}';
        personaUi.contratoVigente =  contactoData.contratoVigente;
        personaUi.telefono = contactoData.celular!=null?contactoData.celular: contactoData.telefono??"";
        contactoUiList.add(personaUi);
    }
    return contactoUiList;
  }

}