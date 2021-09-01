import 'package:moor/src/runtime/data_class.dart';
import 'package:ss_crmeducativo_2/src/data/helpers/serelizable/rest_api_response.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/database/app_database.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/calendario_lista_usuario.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/lista_usuario_detalle.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/relaciones_persona.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/usuario_evento.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/calendario_periodo_carga_curso.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/archivo_rubro.dart';

class SerializableConvert{
  static EntidadData converSerializeEntidad(Map<String,dynamic> model){
    EntidadSerializable serial = EntidadSerializable.fromJson(model);
    return EntidadData(
        entidadId: serial.entidadId??0,
        tipoId: serial.tipoId,
        parentId: serial.parentId,
        nombre: serial.nombre,
        ruc: serial.ruc,
        site: serial.site,
        telefono: serial.telefono,
        correo: serial.correo,
        foto: serial.foto,
        estadoId: serial.entidadId
    );
  }
  static List<Insertable<EntidadData>> converListSerializeEntidad(model) {
    List<EntidadData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeEntidad(item));
    }
    return items;
  }

  static GeoreferenciaData converSerializeGeoreferencia(Map<String,dynamic> model){
    GeoreferenciaSerializable serial = GeoreferenciaSerializable.fromJson(model);
    return GeoreferenciaData(
        georeferenciaId: serial.georeferenciaId??0,
        nombre: serial.nombre,
        entidadId: serial.entidadId,
        geoAlias: serial.alias,
        estadoId: serial.estadoId
    );
  }

  static List<GeoreferenciaData> converListSerializeGeoreferencia(dynamic model){
    List<GeoreferenciaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeGeoreferencia(item));
    }
    return items;
  }

  static RolData converSerializeRol(Map<String,dynamic> model){
    RolSerializable serial = RolSerializable.fromJson(model);
    return RolData(
        rolId: serial.rolId??0,
        nombre: serial.nombre,
        parentId: serial.parentId,
        estado: serial.estado
    );
  }

  static List<RolData> converListSerializeRol(dynamic model){
    List<RolData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeRol(item));
    }
    return items;
  }

  static UsuarioRolGeoreferenciaData converSerializeUsuarioRolGeoreferencia(Map<String,dynamic> model){
    UsuarioRolGeoreferenciaSerializable serial = UsuarioRolGeoreferenciaSerializable.fromJson(model);
    return UsuarioRolGeoreferenciaData(
        usuarioRolGeoreferenciaId: serial.usuarioRolGeoreferenciaId??0,
        usuarioId: serial.usuarioId,
        rolId: serial.rolId,
        geoReferenciaId: serial.geoReferenciaId,
        entidadId: serial.entidadId
    );
  }

  static List<UsuarioRolGeoreferenciaData> converListSerializeUsuarioRolGeoreferencia(dynamic model){
    List<UsuarioRolGeoreferenciaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeUsuarioRolGeoreferencia(item));
    }
    return items;
  }

  static PersonaData converSerializePersona(Map<String,dynamic> model){
    PersonaSerial personaSerial = PersonaSerial.fromJson(model);
    return PersonaData(
        personaId: personaSerial.personaId??0,
        nombres: personaSerial.nombres,
        apellidoPaterno: personaSerial.apellidoPaterno,
        apellidoMaterno: personaSerial.apellidoMaterno,
        celular: personaSerial.celular,
        telefono: personaSerial.telefono,
        foto: personaSerial.foto,
        fechaNac: personaSerial.fechaNac,
        genero: personaSerial.genero,
        estadoCivil: personaSerial.estadoCivil,
        numDoc: personaSerial.numDoc,
        ocupacion: personaSerial.ocupacion,
        estadoId: personaSerial.estadoId,
        correo: personaSerial.correo,
        direccion: personaSerial.direccion,
        path: personaSerial.path);
    //insert.personaId = Values(1);
  }

  static List<PersonaData> converListSerializePersona(dynamic model){
    List<PersonaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializePersona(item));
    }
    return items;
  }

  static EmpleadoData converSerializeEmpleado(Map<String,dynamic> model){
    EmpleadoSerial empleadoSerial = EmpleadoSerial.fromJson(model);
    return EmpleadoData(
      empleadoId: empleadoSerial.empleadoId??0,
      personaId: empleadoSerial.personaId,
      estado: empleadoSerial.estado,
      linkURL: empleadoSerial.linkURL,
      tipoId: empleadoSerial.tipoId,
      web: empleadoSerial.web
    );
    //insert.personaId = Values(1);
  }

  static List<EmpleadoData> converListSerializeEmpleado(dynamic model){
    List<EmpleadoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeEmpleado(item));
    }
    return items;
  }

  static AnioAcademicoData converSerializeAnioAcademico(Map<String,dynamic> model){
    AnioAcademicoSerial academicoSerial = AnioAcademicoSerial.fromJson(model);
    return AnioAcademicoData(
        idAnioAcademico: academicoSerial.idAnioAcademico??0,
        nombre: academicoSerial.nombre,
        fechaInicio: academicoSerial.fechaInicio,
        fechaFin: academicoSerial.fechaFin,
        denominacion: academicoSerial.denominacion,
        tipoId: academicoSerial.tipoId,
        georeferenciaId: academicoSerial.georeferenciaId,
        organigramaId: academicoSerial.organigramaId,
        estadoId: academicoSerial.estadoId,
    );
  }

  static List<AnioAcademicoData> converListSerializeAnioAcademico(dynamic model){
    List<AnioAcademicoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeAnioAcademico(item));
    }
    return items;
  }

  static ParametroConfiguracionData converSerializeParametroConfiguracion(Map<String,dynamic> model){
    ParametroConfiguracionSerial parametroConfiguracionSerial = ParametroConfiguracionSerial.fromJson(model);
    return ParametroConfiguracionData(
        id: parametroConfiguracionSerial.id??0,
        concepto: parametroConfiguracionSerial.concepto,
         parametro: parametroConfiguracionSerial.parametro,
        entidadId: parametroConfiguracionSerial.entidadId,
        orden: parametroConfiguracionSerial.orden
    );
  }

  static List<ParametroConfiguracionData> converListSerializeParametroConfiguracion(dynamic model){
    List<ParametroConfiguracionData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeParametroConfiguracion(item));
    }
    return items;
  }
  static AulaData converSerializeAula(Map<String,dynamic> model){
    AulaSerial aulaSerial = AulaSerial.fromJson(model);
    return AulaData(
      aulaId: aulaSerial.aulaId??0,
      descripcion: aulaSerial.descripcion,
      capacidad: int.parse(aulaSerial.capacidad??"0"),
      numero: aulaSerial.numero,
      estado: aulaSerial.estado
    );
  }

  static List<AulaData> converListSerializeAula(dynamic model){
    List<AulaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeAula(item));
    }
    return items;
  }
  static CargaAcademicaData converSerializeCargaAcademica(Map<String,dynamic> model){
    CargaAcademicaSerial cargaAcademicaSerial = CargaAcademicaSerial.fromJson(model);
    return CargaAcademicaData(
        cargaAcademicaId: cargaAcademicaSerial.cargaAcademicaId??0,
      aulaId: cargaAcademicaSerial.aulaId,
      idAnioAcademico: cargaAcademicaSerial.idAnioAcademico,
      periodoId: cargaAcademicaSerial.periodoId,
      idEmpleadoTutor: cargaAcademicaSerial.idEmpleadoTutor,
      idGrupo: cargaAcademicaSerial.idGrupo,
      idPeriodoAcad: cargaAcademicaSerial.idPeriodoAcad,
      idPlanEstudio: cargaAcademicaSerial.idPlanEstudio,
      idPlanEstudioVersion: cargaAcademicaSerial.idPlanEstudioVersion,
      capacidadVacante: cargaAcademicaSerial.capacidadVacante,
      capacidadVacanteD: cargaAcademicaSerial.capacidadVacanteD,
      seccionId: cargaAcademicaSerial.seccionId
    );
  }

  static List<CargaAcademicaData> converListSerializeCargaAcademica(dynamic model){
    List<CargaAcademicaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCargaAcademica(item));
    }
    return items;
  }
  static CargaCursoDocenteData converSerializeCargaCursoDocente(Map<String,dynamic> model){
    CargaCursoDocenteSerial cursoDocenteSerial = CargaCursoDocenteSerial.fromJson(model);
    return CargaCursoDocenteData(
        cargaCursoDocenteId: cursoDocenteSerial.cargaCursoDocenteId??0,
        cargaCursoId: cursoDocenteSerial.cargaCursoId,
        docenteId: cursoDocenteSerial.docenteId,
       responsable: cursoDocenteSerial.responsable
    );
  }

  static List<CargaCursoDocenteData> converListSerializeCargaCursoDocente(dynamic model){
    List<CargaCursoDocenteData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCargaCursoDocente(item));
    }
    return items;
  }
  static CargaCursoDocenteDetData converSerializeCargaCursoDocenteDet(Map<String,dynamic> model){
    CargaCursoDocenteDetSerial cargaCursoDocenteDetSerial = CargaCursoDocenteDetSerial.fromJson(model);
    return CargaCursoDocenteDetData(
       cargaCursoDocenteId: cargaCursoDocenteDetSerial.cargaCursoDocenteId,
      alumnoId: cargaCursoDocenteDetSerial.alumnoId
    );
  }

  static List<CargaCursoDocenteDetData> converListSerializeCargaCursoDocenteDet(dynamic model){
    List<CargaCursoDocenteDetData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCargaCursoDocenteDet(item));
    }
    return items;
  }
  static CargaCursoData converSerializeCargaCurso(Map<String,dynamic> model){
    CargaCursosSerial serial = CargaCursosSerial.fromJson(model);

    return CargaCursoData(cargaCursoId: serial.cargaCursoId??0,
        planCursoId: serial.planCursoId,
        empleadoId: serial.empleadoId,
        cargaAcademicaId: serial.cargaAcademicaId,
        complejo: serial.complejo,
        evaluable: serial.evaluable,
        idempleado: serial.idempleado,
        idTipoHora: serial.idTipoHora,
        descripcion: serial.descripcion,
        fechaInicio: DateTime.fromMillisecondsSinceEpoch(serial.fechaInicio??0),
        fechafin: DateTime.fromMillisecondsSinceEpoch(serial.fechafin??0),
        modo: serial.modo,
        estado: serial.estado,
        anioAcademicoId: serial.anioAcademicoId,
        aulaId: serial.aulaId,
        grupoId: serial.grupoId,
        idPlanEstudio: serial.idPlanEstudio,
        idPlanEstudioVersion: serial.idPlanEstudioVersion,
        CapacidadVacanteP: serial.CapacidadVacanteP,
        CapacidadVacanteD: serial.CapacidadVacanteD,
        nombreDocente: serial.nombreDocente,
        personaIdDocente: serial.personaIdDocente,
        fotoDocente: serial.fotoDocente
    );
  }

  static List<CargaCursoData> converListSerializeCargaCurso(dynamic model){
    List<CargaCursoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCargaCurso(item));
    }
    return items;
  }
  static List<Curso> converListSerializeCursos(dynamic model){
    List<Curso> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCursos(item));
    }
    return items;
  }

  static Curso converSerializeCursos(Map<String,dynamic> model){
    CursosSerializable serial = CursosSerializable.fromJson(model);
    return Curso(
        cursoId: serial.cursoId??0,
        nombre: serial.nombre,
        estadoId: serial.estadoId,
        descripcion: serial.descripcion,
        cursoAlias: serial.alias,
        entidadId: serial.entidadId,
        nivelAcadId: serial.nivelAcadId,
        tipoCursoId: serial.tipoCursoId,
        tipoConceptoId: serial.tipoConceptoId,
        color: serial.color,
        creditos: serial.creditos,
        totalHP: serial.totalHP,
        totalHT: serial.totalHT,
        notaAprobatoria: serial.notaAprobatoria,
        sumilla: serial.sumilla,
        superId: serial.superId,
        idServicioLaboratorio: serial.idServicioLaboratorio,
        horasLaboratorio: serial.horasLaboratorio,
        tipoSubcurso: serial.tipoSubcurso,
        foto: serial.foto,
        codigo: serial.codigo);
    //insert.personaId = Values(1);
  }
  static List<NivelAcademicoData> converListSerializeNivelAcademico(dynamic model){
    List<NivelAcademicoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeNivelAcademico(item));
    }
    return items;
  }

  static NivelAcademicoData converSerializeNivelAcademico(Map<String,dynamic> model){
    NivelAcademicoSeraializable serial = NivelAcademicoSeraializable.fromJson(model);
    return NivelAcademicoData(
        nivelAcadId: serial.nivelAcadId??0,
        nombre: serial.nombre,
        activo: serial.activo,
        entidadId: serial.entidadId);
  }

  static ParametrosDisenioData converSerializeParametrosDisenio(Map<String,dynamic> model){
    ParametrosDisenioSerial serial = ParametrosDisenioSerial.fromJson(model);
    return ParametrosDisenioData(
        parametroDisenioId: serial.parametroDisenioId??0,
        objeto: serial.objeto,
        concepto: serial.concepto,
        nombre: serial.nombre,
        path: serial.path,
        color1: serial.color1,
        color2: serial.color2,
        color3: serial.color3,
        estado: serial.estado
    );
  }

  static List<ParametrosDisenioData> converListSerializeParametrosDisenio(dynamic model){
    List<ParametrosDisenioData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeParametrosDisenio(item));
    }
    return items;
  }
  static PlanCurso converSerializePlanCurso(Map<String,dynamic> model){
    PlanCursosSerial serial = PlanCursosSerial.fromJson(model);

    return PlanCurso(planCursoId: serial.planCursoId??0,
        cursoId: serial.cursoId,
        periodoId: serial.periodoId,
        planEstudiosId: serial.planEstudiosId);
  }

  static List<PlanCurso> converListSerializePlanCurso(dynamic model){
    List<PlanCurso> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializePlanCurso(item));
    }
    return items;
  }
  static List<Periodo> converListSerializePeriodos(dynamic model){
    List<Periodo> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializePeriodos(item));
    }
    return items;
  }

  static Periodo converSerializePeriodos(Map<String,dynamic> model){
    PeriodosSeraializable serial = PeriodosSeraializable.fromJson(model);
    return Periodo(
        periodoId: serial.periodoId??0,
        nombre: serial.nombre,
        estadoId: serial.estadoId,
        aliasPeriodo: serial.alias,
        fecComienzo: serial.fecComienzo,
        fecTermino: serial.fecTermino,
        tipoId: serial.tipoId,
        superId: serial.superId,
        geoReferenciaId: serial.geoReferenciaId,
        organigramaId: serial.organigramaId,
        entidadId: serial.entidadId,
        activo: serial.activo,
        cicloId: serial.cicloId,
        docenteId: serial.docenteId,
        gruponombre: serial.gruponombre,
        grupoId: serial.grupoId,
        nivelAcademico: serial.nivelAcademico,
        nivelAcademicoId: serial.nivelAcademicoId,
        tutorId: serial.tutorId);
  }
  static ProgramasEducativoData converSerializeProgramasEducativo(Map<String,dynamic> model){
    ProgramasEducativoSerial serial = ProgramasEducativoSerial.fromJson(model);

    return ProgramasEducativoData( programaEduId: serial.programaEduId??0,
        nombre: serial.nombre,
        nroCiclos: serial.nroCiclos,
        nivelAcadId: serial.nivelAcadId,
        tipoEvaluacionId: serial.tipoEvaluacionId,
        estadoId: serial.estadoId,
        entidadId: serial.entidadId,
        tipoInformeSiagieId: serial.tipoInformeSiagieId,
        /*toogle: serial.,*/
        tipoProgramaId: serial.tipoProgramaId,
        tipoMatriculaId: serial.tipoMatriculaId);
  }

  static List<ProgramasEducativoData> converListSerializeProgramasEducativo(dynamic model){
    List<ProgramasEducativoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeProgramasEducativo(item));
    }
    return items;
  }
  static PlanEstudioData converSerializePlanEstudio(Map<String,dynamic> model){
    PlanEstudiosSerial serial = PlanEstudiosSerial.fromJson(model);

    return PlanEstudioData( planEstudiosId: serial.planEstudiosId??0,
        programaEduId: serial.programaEduId,
        nombrePlan: serial.nombrePlan,
        aliasPlan: serial.alias,
        estadoId: serial.estadoId,
        nroResolucion: serial.nroResolucion,
        fechaResolucion: serial.fechaResolucion);
  }

  static List<PlanEstudioData> converListSerializePlanEstudio(dynamic model){
    List<PlanEstudioData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializePlanEstudio(item));
    }
    return items;
  }
  static List<SeccionData> converListSerializeSeccion(dynamic model){
    List<SeccionData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeSeccion(item));
    }
    return items;
  }

  static SeccionData converSerializeSeccion(Map<String,dynamic> model){
    SeccionSeraializable serial = SeccionSeraializable.fromJson(model);
    return SeccionData(
        seccionId: serial.seccionId??0,
        nombre: serial.nombre,
        descripcion: serial.descripcion,
        estado: serial.estado,
        georeferenciaId: serial.georeferenciaId);
  }
  static SilaboEventoData converSerializeSilaboEvento(Map<String,dynamic> model){
    SilaboEventoSerial serial = SilaboEventoSerial.fromJson(model);
    return SilaboEventoData(
        silaboEventoId: serial.silaboEventoId??0,
        titulo: serial.titulo,
        descripcionGeneral: serial.descripcionGeneral,
        planCursoId: serial.planCursoId,
        entidadId: serial.entidadId,
        docenteId: serial.docenteId,
        seccionId: serial.seccionId,
        estadoId: serial.estadoId,
        anioAcademicoId: serial.anioAcademicoId,
        georeferenciaId: serial.georeferenciaId,
        silaboBaseId: serial.silaboBaseId,
        cargaCursoId: serial.cargaCursoId,
        parametroDisenioId: serial.parametroDisenioId,
        fechaInicio: serial.fechaFin,
        fechaFin: serial.fechaFin
    );
  }

  static List<SilaboEventoData> converListSerializeSilaboEvento(dynamic model){
    List<SilaboEventoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeSilaboEvento(item));
    }
    return items;
  }

  static CalendarioPeriodoData converSerializeCalendarioPeriodo(Map<String,dynamic> model){
    CalendarioPeriodoSerial serial = CalendarioPeriodoSerial.fromJson(model);

    return CalendarioPeriodoData(
        calendarioPeriodoId: serial.calendarioPeriodoId??0,
        fechaInicio:  DateTime.fromMillisecondsSinceEpoch(serial.fechaInicio??0),
        fechaFin:  DateTime.fromMillisecondsSinceEpoch(serial.fechaFin??0),
        calendarioAcademicoId: serial.calendarioAcademicoId,
        tipoId: serial.tipoId,
        estadoId: serial.estadoId,
        diazPlazo: serial.diazPlazo,
        habilitado: serial.habilitado);
  }

  static List<CalendarioPeriodoData> converListSerializeCalendarioPeriodo(dynamic model){
    List<CalendarioPeriodoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCalendarioPeriodo(item));
    }
    return items;
  }

  static CalendarioPeriodoCargaCursoData converSerializeCalendarioPeriodoCargaCursos(Map<String,dynamic> model){
    CalendarioCargaCursoSerial serial = CalendarioCargaCursoSerial.fromJson(model);

    return CalendarioPeriodoCargaCursoData(
        calendarioPeriodoId: serial.calendarioPeriodoId??0,
        cargaCursoId: serial.cargaCursoId??0,
        fechaInicio:  DateTime.fromMillisecondsSinceEpoch(serial.fechaInicio??0),
        fechaFin:  DateTime.fromMillisecondsSinceEpoch(serial.fechaFin??0),
        nombre: serial.nombre,
        calendarioAcademicoId: serial.calendarioAcademicoId,
        tipoId: serial.tipoId,
        estadoId: serial.estadoId,
        diazPlazo: serial.diazPlazo,
        habilitado: serial.habilitado);
  }

  static List<CalendarioPeriodoCargaCursoData> converListSerializeCalendarioPeriodoCargaCurso(dynamic model){
    List<CalendarioPeriodoCargaCursoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCalendarioPeriodoCargaCursos(item));
    }
    return items;
  }
  static Tipo converSerializeTipos(Map<String,dynamic> model){
    TiposSerial serial = TiposSerial.fromJson(model);

    return Tipo(
        tipoId: serial.tipoId??0,
        objeto: serial.objeto,
        concepto: serial.concepto,
        nombre: serial.nombre,
        codigo: serial.codigo,
        parentId: serial.parentId);
  }

  static List<Tipo> converListSerializeTipos(dynamic model){
    List<Tipo> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeTipos(item));
    }
    return items;
  }
  static TiposRubroData converSerializeTiposRubro(Map<String,dynamic> model){
    TiposSerial serial = TiposSerial.fromJson(model);

    return TiposRubroData(
        tipoId: serial.tipoId??0,
        objeto: serial.objeto,
        concepto: serial.concepto,
        nombre: serial.nombre,
        codigo: serial.codigo,
        parentId: serial.parentId);
  }

  static List<TiposRubroData> converListSerializeTiposRubro(dynamic model){
    List<TiposRubroData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeTiposRubro(item));
    }
    return items;
  }
  static TipoEvaluacionRubroData converSerializeTipoEvaluacionRubro(Map<String,dynamic> model){
    TipoEvaluacionRubroSerial serial = TipoEvaluacionRubroSerial.fromJson(model);

    return TipoEvaluacionRubroData(
      tipoEvaluacionId: serial.tipoEvaluacionId??0,
      nombre: serial.nombre,
      estado: serial.estado
    );

  }

  static List<TipoEvaluacionRubroData> converListSerializeTipoEvaluacionRubro(dynamic model){
    List<TipoEvaluacionRubroData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeTipoEvaluacionRubro(item));
    }
    return items;
  }

  static CalendarioAcademicoData converSerializeCalendarioAcademico(Map<String,dynamic> model){
    CalendarioAcademicoSerial serial = CalendarioAcademicoSerial.fromJson(model);

    return CalendarioAcademicoData(
        calendarioAcademicoId: serial.calendarioAcademicoId??0,
        idAnioAcademico: serial.idAnioAcademico,
        estadoId: serial.estadoId,
        programaEduId: serial.programaEduId
    );
  }

  static List<CalendarioAcademicoData> converListSerializeCalendarioAcademico(dynamic model){
    List<CalendarioAcademicoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCalendarioAcademico(item));
    }
    return items;
  }

  static HorarioData converSerializeHorario(Map<String,dynamic> model){
    HorarioSerial serial = HorarioSerial.fromJson(model);

    return HorarioData(
        idHorario: serial.idHorario??0,
        descripcion: serial.descripcion,
        nombre: serial.nombre,
        idUsuario: serial.idUsuario,
        entidadId: serial.entidadId,
        estado: serial.estado,
        organigramaId: serial.organigramaId,
        georeferenciaId: serial.georeferenciaId,
        fecActualizacion: serial.fecActualizacion,
        fecCreacion: serial.fecCreacion
    );
  }

  static List<HorarioData> converListSerializeHorario(dynamic model){
    List<HorarioData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeHorario(item));
    }
    return items;
  }

  static HoraData converSerializeHora(Map<String,dynamic> model){
    HoraSerial serial = HoraSerial.fromJson(model);

    return HoraData(
        idHora: serial.idHora??0,
        horaFin: serial.horaFin,
        horaInicio: serial.horaInicio
    );
  }

  static List<HoraData> converListSerializeHora(dynamic model){
    List<HoraData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeHora(item));
    }
    return items;
  }
  static HorarioProgramaData converSerializeHorarioPrograma(Map<String,dynamic> model){
    HorarioProgramaSerial serial = HorarioProgramaSerial.fromJson(model);

    return HorarioProgramaData(
       idHorarioPrograma: serial.idHorarioPrograma??0,
       idHorario: serial.idHorario,
       idAnioAcademico: serial.idAnioAcademico,
       activo: serial.activo,
        fechaActualizacion: serial.fechaActualizacion,
      fechaCreacion: serial.fechaCreacion,
      idProgramaEducativo: serial.idProgramaEducativo,
      idUsuarioActualizacion: serial.idUsuarioActualizacion,
      idUsuarioCreacion: serial.idUsuarioCreacion
    );
  }

  static List<HorarioProgramaData> converListSerializeHorarioPrograma(dynamic model){
    List<HorarioProgramaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeHorarioPrograma(item));
    }
    return items;
  }
  static HorarioHoraData converSerializeHoariosHora(Map<String,dynamic> model){
    HorarioHoraSerial serial = HorarioHoraSerial.fromJson(model);

    return HorarioHoraData(
      idHorarioHora: serial.idHorarioHora??0,
      detalleHoraId: serial.detalleHoraId,
      horaId: serial.horaId
    );
  }

  static List<HorarioHoraData> converListSerializeHorariosHora(dynamic model){
    List<HorarioHoraData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeHoariosHora(item));
    }
    return items;
  }
  static DiaData converSerializeDia(Map<String,dynamic> model){
    DiaSerial serial = DiaSerial.fromJson(model);

    return DiaData(
        diaId: serial.diaId??0,
        nombre: serial.nombre,
        estado: serial.estado,
        alias_: serial.alias
    );
  }

  static List<DiaData> converListSerializeDia(dynamic model){
    List<DiaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeDia(item));
    }
    return items;
  }
  static HorarioDiaData converSerializeHorarioDia(Map<String,dynamic> model){
    HorarioDiaSerial serial = HorarioDiaSerial.fromJson(model);

    return HorarioDiaData(
        idHorarioDia: serial.idHorarioDia??0,
        idHorario: serial.idHorario,
        idDia: serial.idDia
    );
  }

  static List<HorarioDiaData> converListSerializeHorarioDia(dynamic model){
    List<HorarioDiaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeHorarioDia(item));
    }
    return items;
  }
  static CursosDetHorarioData converSerializeCursoDetHorario(Map<String,dynamic> model){
    CursosDetHorarioSerial serial = CursosDetHorarioSerial.fromJson(model);

    return CursosDetHorarioData(
        idCursosDetHorario: serial.idCursosDetHorario??0,
        idCargaCurso: serial.idCargaCurso,
        idDetHorario: serial.idDetHorario
    );
  }

  static List<CursosDetHorarioData> converListSerializeCursoDetHorario(dynamic model){
    List<CursosDetHorarioData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCursoDetHorario(item));
    }
    return items;
  }

  static WebConfig converSerializeWebConfigs(Map<String,dynamic> model){
    WebConfigsSerial serial = WebConfigsSerial.fromJson(model);
    return WebConfig(
        nombre: serial.nombre,
        content: serial.content
    );
  }

  static List<WebConfig> converListSerializeWebConfigs(dynamic model){
    List<WebConfig> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeWebConfigs(item));
    }
    return items;
  }
  static CriterioData converSerializeCriterio(Map<String,dynamic> model){
    CriteriosSerial serial = CriteriosSerial.fromJson(model);
    return CriterioData(
        sesionAprendizajeId: serial.sesionAprendizajeId??0,
        unidadAprendiajeId: serial.unidadAprendiajeId??0,
        silaboEventoId: serial.silaboEventoId??0,
        sesionAprendizajePadreId: serial.sesionAprendizajePadreId,
        competenciaId: serial.competenciaId??0,
        competenciaNombre: serial.competenciaNombre,
        competenciaDescripcion: serial.competenciaDescripcion,
        competenciaTipoId: serial.competenciaTipoId,
        superCompetenciaId: serial.superCompetenciaId,
        superCompetenciaNombre: serial.superCompetenciaNombre,
        superCompetenciaDescripcion: serial.superCompetenciaDescripcion,
        superCompetenciaTipoId: serial.superCompetenciaTipoId,
        desempenioIcdId: serial.desempenioIcdId??0,
        DesempenioDescripcion: serial.desempenioIcdDescripcion,
        peso: serial.peso,
        codigo: serial.codigo,
        tipoId: serial.tipoId,
        nroSesion: serial.nroSesion,
        nroUnidad: serial.nroUnidad,
        propositoSesion: serial.propositoSesion,
        rolIdSesion: serial.rolIdSesion,
        tituloSesion: serial.tituloSesion,
        tituloUnidad: serial.tituloUnidad,
        url: serial.url,
        desempenioId: serial.desempenioId,
        desempenioIcdDescripcion: serial.desempenioIcdDescripcion,
        icdId: serial.icdId,
        icdTitulo: serial.icdTitulo,
        icdDescripcion: serial.icdDescripcion,
        icdAlias: serial.icdAlias,
        campoTematicoId: serial.campoTematicoId??0,
        campoTematicoTitulo: serial.campoTematicoTitulo,
        campoTematicoDescripcion: serial.campoTematicoDescripcion,
        campoTematicoEstado: serial.campoTematicoEstado,
        campoTematicoParentId: serial.campoTematicoParentId,
        campoTematicoParentTitulo: serial.campoTematicoParentTitulo,
        campoTematicoParentDescripcion: serial.campoTematicoParentDescripcion,
        campoTematicoParentEstado: serial.campoTematicoParentEstado,
        campoTematicoParentParentId: serial.campoTematicoParentParentId,
        calendarioPeriodoId: serial.calendarioPeriodoId
    );
  }

  static List<CriterioData> converListSerializeCriterio(dynamic model){
    List<CriterioData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCriterio(item));
    }
    return items;
  }


  static TipoNotaRubroData converSerializeTipoNotaRubro(Map<String,dynamic> model){
    TipoNotaRubroSerial serial = TipoNotaRubroSerial.fromJson(model);
    return TipoNotaRubroData(
        tipoNotaId: serial.tipoNotaId??"",
        nombre: serial.nombre,
        tipoId: serial.tipoId,
        tiponombre: serial.tiponombre,
        valorDefecto: serial.valorDefecto,
        longitudPaso: serial.longitudPaso,
        intervalo: serial.intervalo,
        estatico: serial.estatico,
        entidadId: serial.entidadId,
        georeferenciaId: serial.georeferenciaId,
        organigramaId: serial.organigramaId,
        estadoId: serial.estadoId,
        tipoFuenteId: serial.tipoFuenteId,
        valorMinimo: serial.valorMinimo,
        valorMaximo: serial.valorMaximo,
        escalaEvaluacionId: serial.escalaEvaluacionId,
        escalanombre: serial.escalanombre,
        escalavalorMinimo: serial.escalavalorMinimo,
        escalavalorMaximo: serial.escalavalorMaximo,
        escalaestado: serial.escalaestado,
        escaladefecto: serial.escaladefecto,
        escalaentidadId: serial.escalaentidadId,
        programaEducativoId: serial.programaEducativoId
    );
  }

  static List<TipoNotaRubroData> converListSerializeTipoNotaRubro(dynamic model){
    List<TipoNotaRubroData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeTipoNotaRubro(item));
    }
    return items;
  }

  static ValorTipoNotaRubroData converSerializeValorTipoNotaRubro(Map<String,dynamic> model){
    ValorTipoNotaRubroSerial serial = ValorTipoNotaRubroSerial.fromJson(model);
    return ValorTipoNotaRubroData(
        valorTipoNotaId: serial.valorTipoNotaId??"",
        tipoNotaId: serial.tipoNotaId,
        titulo: serial.titulo,
        alias: serial.alias,
        limiteInferior: serial.limiteInferior,
        limiteSuperior: serial.limiteSuperior,
        valorNumerico: serial.valorNumerico,
        icono: serial.icono,
        estadoId: serial.estadoId,
        incluidoLInferior: serial.incluidoLInferior,
        incluidoLSuperior: serial.incluidoLSuperior,
        tipoId: serial.tipoId,
        usuarioCreacionId: serial.usuarioCreacionId,
        usuarioCreadorId: serial.usuarioCreadorId,
        fechaCreacion: serial.fechaCreacion,
        usuarioAccionId: serial.usuarioAccionId,
        fechaAccion: serial.fechaAccion,
        fechaEnvio: serial.fechaEnvio,
        fechaEntrega: serial.fechaEntrega,
        fechaRecibido: serial.fechaRecibido,
        fechaVisto: serial.fechaVisto,
        fechaRespuesta: serial.fechaRespuesta,
        getSTime: serial.getSTime
    );
  }

  static List<ValorTipoNotaRubroData> converListSerializeValorTipoNotaRubro(dynamic model){
    List<ValorTipoNotaRubroData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeValorTipoNotaRubro(item));
    }
    return items;
  }

  static TipoNotaResultadoData converSerializeTipoNotaResultado(Map<String,dynamic> model){
    TipoNotaRubroSerial serial = TipoNotaRubroSerial.fromJson(model);
    return TipoNotaResultadoData(
        silaboEventoId: serial.silaboEventoId??0,
        tipoNotaId: serial.tipoNotaId??"",
        nombre: serial.nombre,
        tipoId: serial.tipoId,
        tiponombre: serial.tiponombre,
        valorDefecto: serial.valorDefecto,
        longitudPaso: serial.longitudPaso,
        intervalo: serial.intervalo,
        estatico: serial.estatico,
        entidadId: serial.entidadId,
        georeferenciaId: serial.georeferenciaId,
        organigramaId: serial.organigramaId,
        estadoId: serial.estadoId,
        tipoFuenteId: serial.tipoFuenteId,
        valorMinimo: serial.valorMinimo,
        valorMaximo: serial.valorMaximo,
        escalaEvaluacionId: serial.escalaEvaluacionId,
        escalanombre: serial.escalanombre,
        escalavalorMinimo: serial.escalavalorMinimo,
        escalavalorMaximo: serial.escalavalorMaximo,
        escalaestado: serial.escalaestado,
        escaladefecto: serial.escaladefecto,
        escalaentidadId: serial.escalaentidadId,
        programaEducativoId: serial.programaEducativoId
    );
  }

  static List<TipoNotaResultadoData> converListSerializeTipoNotaResultado(dynamic model){
    List<TipoNotaResultadoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeTipoNotaResultado(item));
    }
    return items;
  }

  static ValorTipoNotaResultadoData converSerializeValorTipoNotaResultado(Map<String,dynamic> model){
    ValorTipoNotaRubroSerial serial = ValorTipoNotaRubroSerial.fromJson(model);
    return ValorTipoNotaResultadoData(
        silaboEventoId: serial.silaboEventoId??0,
        valorTipoNotaId: serial.valorTipoNotaId??"",
        tipoNotaId: serial.tipoNotaId,
        titulo: serial.titulo,
        alias: serial.alias,
        limiteInferior: serial.limiteInferior,
        limiteSuperior: serial.limiteSuperior,
        valorNumerico: serial.valorNumerico,
        icono: serial.icono,
        estadoId: serial.estadoId,
        incluidoLInferior: serial.incluidoLInferior,
        incluidoLSuperior: serial.incluidoLSuperior,
        tipoId: serial.tipoId,
        usuarioCreacionId: serial.usuarioCreacionId,
        usuarioCreadorId: serial.usuarioCreadorId,
        fechaCreacion: serial.fechaCreacion,
        usuarioAccionId: serial.usuarioAccionId,
        fechaAccion: serial.fechaAccion,
        fechaEnvio: serial.fechaEnvio,
        fechaEntrega: serial.fechaEntrega,
        fechaRecibido: serial.fechaRecibido,
        fechaVisto: serial.fechaVisto,
        fechaRespuesta: serial.fechaRespuesta,
        getSTime: serial.getSTime
    );
  }

  static List<ValorTipoNotaResultadoData> converListSerializeValorTipoNotaResultado(dynamic model){
    List<ValorTipoNotaResultadoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeValorTipoNotaResultado(item));
    }
    return items;
  }

  static ContactoDocenteData converSerializeContactoDocente(Map<String,dynamic> model){
    ContactoDocenteSerial serial = ContactoDocenteSerial.fromJson(model);
    return ContactoDocenteData(
        personaId: serial.personaId??0,
       tipo: serial.tipo??0,
       cargaCursoId: serial.cargaCursoId??0,
       nombreTipo: serial.nombres,
       cursoId: serial.cursoId,
       cursoNombre: serial.cursoNombre,
       aulaId: serial.aulaId,
       aulaNombre: serial.aulaNombre,
       grupoId: serial.grupoId,
       grupoNombre: serial.grupoNombre,
       contratoEstadoId: serial.contratoEstadoId,
       contratoVigente: serial.contratoVigente,
       periodoId: serial.periodoId,
       periodoNombre: serial.periodoNombre,
       hijoRelacionId: serial.hijoRelacionId,
       relacionId: serial.relacionId,
       relacion: serial.relacion,
       estadoId: serial.estadoId,
       nombres: serial.nombres,
       apellidoPaterno: serial.apellidoPaterno,
       apellidoMaterno: serial.apellidoMaterno,
      celular: serial.celular,
      telefono: serial.telefono,
      correo: serial.correo,
      estadoCivil: serial.estadoCivil,
      fechaNac: serial.fechaNac,
      ocupacion: serial.ocupacion,
      numDoc: serial.numDoc,
      genero: serial.genero,
      foto: serial.foto
    );
  }

  static List<ContactoDocenteData> converListSerializeContactoDocente(dynamic model){
    List<ContactoDocenteData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeContactoDocente(item));
    }
    return items;
  }


  static CalendarioData converSerializeCalendario(Map<String,dynamic> model){
    CalendarioSerial serial = CalendarioSerial.fromJson(model);
    return CalendarioData(
        calendarioId: serial.calendarioId??"",
        cargaAcademicaId: serial.cargaAcademicaId,
        cargaCursoId: serial.cargaCursoId,
        cargo: serial.cargo,
        descripcion: serial.descripcion,
        entidadId: serial.entidadId,
        estado: serial.estado,
        estadoPublicaciN: serial.estadoPublicaciN,
        estadoPublicacion: serial.estadoPublicacion,
        fechaAccion: serial.fechaAccion,
        fechaCreacion: serial.fechaCreacion,
        fechaEntrega: serial.fechaEntrega,
        fechaEnvio: serial.fechaEnvio,
        fechaRecibido: serial.fechaRecibido,
        fechaRespuesta: serial.fechaRespuesta,
        fechaVisto: serial.fechaVisto,
        georeferenciaId: serial.georeferenciaId,
        nombre: serial.nombre,
        rolId: serial.rolId,
        nUsuario: serial.nUsuario,
        usuarioId: serial.usuarioId,
        getSTime: serial.getSTime,
        usuarioAccionId: serial.usuarioAccionId,
        usuarioCreacionId: serial.usuarioCreacionId,
        usuarioCreadorId: serial.usuarioCreadorId
    );
  }

  static List<CalendarioData> converListSerializeCalendario(dynamic model){
    List<CalendarioData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCalendario(item));
    }
    return items;
  }

  static CalendarioListaUsuarioData converSerializeCalendarioListaUsuario(Map<String,dynamic> model){
    CalendarioListaUsuarioSerial serial = CalendarioListaUsuarioSerial.fromJson(model);
    return CalendarioListaUsuarioData(
        listaUsuarioId: serial.listaUsuarioId??0, 
        calendarioId: serial.calendarioId??""
      
    );
  }

  static List<CalendarioListaUsuarioData> converListSerializeCalendarioListaUsuario(dynamic model){
    List<CalendarioListaUsuarioData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCalendarioListaUsuario(item));
    }
    return items;
  }
  
  static EventoData converSerializeEvento(Map<String,dynamic> model){
    EventoSerial serial = EventoSerial.fromJson(model);
    return EventoData(
        eventoId: serial.eventoId??"",
        titulo: serial.titulo,
        descripcion: serial.descripcion,
        horaEvento: serial.horaEvento,
        fechaEvento: serial.fechaEvento,
        calendarioId: serial.calendarioId,
        entidadId: serial.entidadId,
        envioPersonalizado: serial.envioPersonalizado,
        estadoId: serial.estadoId,
        estadoPublicacion: serial.estadoPublicacion,
        eventoHijoId: serial.eventoHijoId,
        georeferenciaId: serial.georeferenciaId,
        tipoEventoId: serial.tipoEventoId,
        key: serial.key,
        fechaAccion: serial.fechaAccion,
        fechaCreacion: serial.fechaCreacion,
        fechaEntrega: serial.fechaEntrega,
        fechaEnvio: serial.fechaEnvio,
        fechaRecibido: serial.fechaRecibido,
        fechaRespuesta: serial.fechaRespuesta,
        fechaVisto: serial.fechaVisto,
        pathImagen: serial.pathImagen,
        usuarioReceptorId: serial.usuarioReceptorId,
        usuarioAccionId: serial.usuarioAccionId,
        usuarioCreadorId: serial.usuarioCreadorId,
        usuarioCreacionId: serial.usuarioCreacionId,
        nombreEntidad: serial.nombreEntidad,
        fotoEntidad: serial.fotoEntidad
    );
  }

  static List<EventoData> converListSerializeEvento(dynamic model){
    List<EventoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeEvento(item));
    }
    return items;
  }

  static EventoPersonaData converSerializeEventoPersona(Map<String,dynamic> model){
    EventoPersonaSerial serial = EventoPersonaSerial.fromJson(model);
    return EventoPersonaData(
        eventoPersonaId: serial.eventoPersonaId??"",
        eventoId: serial.eventoId,
        personaId: serial.personaId,
        estado: serial.estado,
        rolId: serial.rolId,
        apoderadoId: serial.apoderadoId,
        key: serial.key,
        usuarioCreacionId: serial.usuarioCreacionId,
        usuarioCreadorId: serial.usuarioCreadorId,
        fechaCreacion: serial.fechaCreacion,
        usuarioAccionId: serial.usuarioAccionId,
        fechaAccion: serial.fechaAccion,
        fechaEnvio: serial.fechaEnvio,
        fechaEntrega: serial.fechaEntrega,
        fechaRecibido: serial.fechaRecibido,
        fechaVisto: serial.fechaVisto,
        fechaRespuesta: serial.fechaRespuesta,
    );
  }

  static List<EventoPersonaData> converListSerializeEventoPersona(dynamic model){
    List<EventoPersonaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeEventoPersona(item));
    }
    return items;
  }

  static ListaUsuario converSerializeCalendarioListaUsuarios(Map<String,dynamic> model){
    ListaUsuariosSerial serial = ListaUsuariosSerial.fromJson(model);
    return ListaUsuario(
        listaUsuarioId: serial.listaUsuarioId??0,
        nombre: serial.nombre,
        descripcion: serial.descripcion,
        entidadId: serial.entidadId,
        georeferenciaId: serial.georeferenciaId,
        organigramaId: serial.organigramaId,
        estado: serial.estado,
        usuarioCreacionId: serial.usuarioCreacionId,
        usuarioCreadorId: serial.usuarioCreadorId,
        fechaCreacion: serial.fechaCreacion,
        usuarioAccionId: serial.usuarioAccionId,
        fechaAccion: serial.fechaAccion,
        fechaEnvio: serial.fechaEnvio,
        fechaEntrega: serial.fechaEntrega,
        fechaRecibido: serial.fechaRecibido,
        fechaVisto: serial.fechaVisto,
        fechaRespuesta: serial.fechaRespuesta

    );
  }

  static List<ListaUsuario> converListSerializeCalendarioListaUsuarios(dynamic model){
    List<ListaUsuario> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCalendarioListaUsuarios(item));
    }
    return items;
  }

  static PersonaEventoData converSerializePersonaEvento(Map<String,dynamic> model){
    PersonaEventoSerial serial = PersonaEventoSerial.fromJson(model);
    return PersonaEventoData(
        personaId: serial.personaId??0,
        nombres: serial.nombres,
        apellidoPaterno: serial.apellidoPaterno,
        apellidoMaterno: serial.apellidoMaterno,
        celular: serial.celular,
        telefono: serial.telefono,
        foto: serial.foto,
        fechaNac: serial.fechaNac,
        genero: serial.genero,
        estadoCivil: serial.estadoCivil,
        numDoc: serial.numDoc,
        ocupacion: serial.ocupacion,
        estadoId: serial.estadoId,
        correo: serial.correo,
        empleadoId: serial.empleadoId
    );
  }

  static List<PersonaEventoData> converListSerializePersonaEvento(dynamic model){
    List<PersonaEventoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializePersonaEvento(item));
    }
    return items;
  }

  static RelacionesEventoData converSerializeRelacionesEvento(Map<String,dynamic> model){
    RelacionesEventoSerial serial = RelacionesEventoSerial.fromJson(model);
    return RelacionesEventoData(
        idRelacion: serial.idRelacion??0,
        personaPrincipalId: serial.personaPrincipalId,
        personaVinculadaId: serial.personaVinculadaId,
        tipoId: serial.tipoId,
        activo: serial.activo
    );
  }

  static List<RelacionesEventoData> converListSerializeRelacionesEvento(dynamic model){
    List<RelacionesEventoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeRelacionesEvento(item));
    }
    return items;
  }
  static TipoEventoData converSerializeTipoEvento(Map<String,dynamic> model){
    TiposEventoSerial serial = TiposEventoSerial.fromJson(model);
    return TipoEventoData(
        tipoId: serial.tipoId??0,
        objeto: serial.objeto,
        concepto: serial.concepto,
        nombre: serial.nombre,
        codigo: serial.codigo,
        estado: serial.estado,
        parentId: serial.parentId
    );
  }

  static List<TipoEventoData> converListSerializeTipoEvento(dynamic model){
    List<TipoEventoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeTipoEvento(item));
    }
    return items;
  }
  static UsuarioEventoData converSerializeUsuarioEvento(Map<String,dynamic> model){
    UsuarioEventoSerial serial = UsuarioEventoSerial.fromJson(model);
    return UsuarioEventoData(
       usuarioId: serial.usuarioId??0,
       personaId: serial.personaId,
       estado: serial.estado,
       entidadId: serial.entidadId,
       georeferenciaId: serial.georeferenciaId
    );
  }

  static List<UsuarioEventoData> converListSerializeUsuarioEvento(dynamic model){
    List<UsuarioEventoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeUsuarioEvento(item));
    }
    return items;
  }

  static ListaUsuarioDetalleData converSerializeListaUsuarioDetalle(Map<String,dynamic> model){
    ListUsuarioDetalleSerial serial = ListUsuarioDetalleSerial.fromJson(model);
    return ListaUsuarioDetalleData(
        listaUsuarioId: serial.listaUsuarioId??0,
        usuarioId: serial.usuarioId??0
    );
  }

  static List<ListaUsuarioDetalleData> converListSerializeListaUsuarioDetalle(dynamic model){
    List<ListaUsuarioDetalleData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeListaUsuarioDetalle(item));
    }
    return items;
  }

  static RubroEvaluacionProcesoData converSerializeListaRubroEvaluacionProceso(Map<String,dynamic> model){
    RubroEvaluacionProcesoSerial serial = RubroEvaluacionProcesoSerial.fromJson(model);
    return RubroEvaluacionProcesoData(
        usuarioCreacionId: serial.usuarioCreacionId,
        fechaCreacion: DateTime.fromMillisecondsSinceEpoch(serial.fechaCreacion??0),
        usuarioAccionId: serial.usuarioAccionId,
        fechaAccion: DateTime.fromMillisecondsSinceEpoch(serial.fechaAccion??0),
        rubroEvalProcesoId: serial.rubroEvalProcesoId??"",
        titulo: serial.titulo,
        subtitulo: serial.subtitulo,
        colorFondo: serial.colorFondo,
        mColorFondo: serial.mColorFondo,
        valorDefecto: serial.valorDefecto,
        competenciaId: serial.competenciaId,
        calendarioPeriodoId: serial.calendarioPeriodoId,
        anchoColumna: serial.anchoColumna,
        ocultarColumna: serial.ocultarColumna,
        tipoFormulaId: serial.tipoFormulaId,
        silaboEventoId: serial.silaboEventoId,
        tipoRedondeoId: serial.tipoRedondeoId,
        valorRedondeoId: serial.valorRedondeoId,
        rubroEvalResultadoId: serial.rubroEvalResultadoId,
        tipoNotaId: serial.tipoNotaId,
        sesionAprendizajeId: serial.sesionAprendizajeId,
        desempenioIcdId: serial.desempenioIcdId,
        campoTematicoId: serial.campoTematicoId,
        tipoEvaluacionId: serial.tipoEvaluacionId,
        estadoId: serial.estadoId,
        tipoEscalaEvaluacionId: serial.tipoEscalaEvaluacionId,
        tipoColorRubroProceso: serial.tipoColorRubroProceso,
        tiporubroid: serial.tiporubroid,
        formaEvaluacionId: serial.formaEvaluacionId,
        countIndicador: serial.countIndicador,
        rubroFormal: serial.rubroFormal,
        msje: serial.msje,
        promedio: serial.promedio,
        desviacionEstandar: serial.desviacionEstandar,
        unidadAprendizajeId: serial.unidadAprendizajeId,
        estrategiaEvaluacionId: serial.estrategiaEvaluacionId,
        tareaId: serial.tareaId,
        resultadoTipoNotaId: serial.resultadoTipoNotaId,
        instrumentoEvalId: serial.instrumentoEvalId,
        preguntaEvalId: serial.preguntaEvalId,
        error_guardar:serial.error_guardar
    );
  }

  static List<RubroEvaluacionProcesoData> converListSerializeRubroEvaluacionProceso(dynamic model){
    List<RubroEvaluacionProcesoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeListaRubroEvaluacionProceso(item));
    }
    return items;
  }
  static EvaluacionProcesoData converSerializeListaEvaluacionProceso(Map<String,dynamic> model){
    EvaluacionProcesoSerial serial = EvaluacionProcesoSerial.fromJson(model);
    return EvaluacionProcesoData(
        usuarioCreacionId: serial.usuarioCreacionId,
        fechaCreacion: DateTime.fromMillisecondsSinceEpoch(serial.fechaCreacion??0),
        usuarioAccionId: serial.usuarioAccionId,
        fechaAccion: DateTime.fromMillisecondsSinceEpoch(serial.fechaAccion??0),
        evaluacionProcesoId: serial.evaluacionProcesoId??"",
        rubroEvalProcesoId: serial.rubroEvalProcesoId??"",
        nombres: serial.nombres,
        apellidoPaterno: serial.apellidoPaterno,
        apellidoMaterno: serial.apellidoMaterno,
        foto: serial.foto,
        alumnoId: serial.alumnoId,
        calendarioPeriodoId: serial.calendarioPeriodoId,
        equipoId: serial.equipoId,
        escala: serial.escala,
        evaluacionResultadoId: serial.evaluacionResultadoId,
        visto: serial.visto,
        valorTipoNotaId: serial.valorTipoNotaId,
        msje: serial.msje,
        nota: serial.nota,
        sesionAprendizajeId: serial.sesionAprendizajeId,
        publicado: serial.publicado,
        syncFlag: serial.syncFlag

    );
  }

  static List<EvaluacionProcesoData> converListSerializeEvaluacionProceso(dynamic model){
    List<EvaluacionProcesoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeListaEvaluacionProceso(item));
    }
    return items;
  }

  static RubroComentarioData converSerializeListaRubroComentario(Map<String,dynamic> model){
    RubroEvaluacionProcesoComentarioSerial serial = RubroEvaluacionProcesoComentarioSerial.fromJson(model);
    return RubroComentarioData(
      usuarioCreacionId: serial.usuarioCreacionId,
      fechaCreacion: DateTime.fromMillisecondsSinceEpoch(serial.fechaCreacion??0),
      usuarioAccionId: serial.usuarioAccionId,
      fechaAccion: DateTime.fromMillisecondsSinceEpoch(serial.fechaAccion??0),
      evaluacionProcesoId: serial.evaluacionProcesoId,
      comentarioId: serial.comentarioId,
      descripcion: serial.descripcion,
      evaluacionProcesoComentarioId: serial.evaluacionProcesoComentarioId??"",
      delete: serial.delete,
    );
  }

  static List<RubroComentarioData> converListSerializeRubroComentario(dynamic model){
    List<RubroComentarioData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeListaRubroComentario(item));
    }
    return items;
  }

  static ArchivoRubroData converSerializeListaArchivoRubro(Map<String,dynamic> model){
    ArchivosRubroProcesoSerial serial = ArchivosRubroProcesoSerial.fromJson(model);
    return ArchivoRubroData(
      usuarioCreacionId: serial.usuarioCreacionId,
      fechaCreacion: DateTime.fromMillisecondsSinceEpoch(serial.fechaCreacion??0),
      usuarioAccionId: serial.usuarioAccionId,
      fechaAccion: DateTime.fromMillisecondsSinceEpoch(serial.fechaAccion??0),
      evaluacionProcesoId: serial.evaluacionProcesoId,
      archivoRubroId: serial.archivoRubroId??"",
      tipoArchivoId: serial.tipoArchivoId,
      url: serial.url,
      delete: serial.delete,
    );
  }

  static List<ArchivoRubroData> converListSerializeArchivoRubro(dynamic model){
    List<ArchivoRubroData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeListaArchivoRubro(item));
    }
    return items;
  }

  static RubroCampotematicoData converSerializeListaRubroCampotematico(Map<String,dynamic> model){
    RubroEvaluacionProcesoCampotematicoSerial serial = RubroEvaluacionProcesoCampotematicoSerial.fromJson(model);
    return RubroCampotematicoData(
      usuarioCreacionId: serial.usuarioCreacionId,
      fechaCreacion: DateTime.fromMillisecondsSinceEpoch(serial.fechaCreacion??0),
      usuarioAccionId: serial.usuarioAccionId,
      fechaAccion: DateTime.fromMillisecondsSinceEpoch(serial.fechaAccion??0),
      campoTematicoId: serial.campoTematicoId??0,
      rubroEvalProcesoId: serial.rubroEvalProcesoId??"",
    );
  }

  static List<RubroCampotematicoData> converListSerializeRubroCampotematico(dynamic model){
    List<RubroCampotematicoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeListaRubroCampotematico(item));
    }
    return items;
  }

  static RubroEvalRNPFormulaData converSerializeListaRubroEvalRNPFormula(Map<String,dynamic> model){
    RubroEvalRNPFormulaSerial serial = RubroEvalRNPFormulaSerial.fromJson(model);
    return RubroEvalRNPFormulaData(
      usuarioCreacionId: serial.usuarioCreacionId,
      fechaCreacion: DateTime.fromMillisecondsSinceEpoch(serial.fechaCreacion??0),
      usuarioAccionId: serial.usuarioAccionId,
      fechaAccion: DateTime.fromMillisecondsSinceEpoch(serial.fechaAccion??0),
      rubroFormulaId: serial.rubroFormulaId??"",
      rubroEvaluacionPrimId: serial.rubroEvaluacionPrimId,
      rubroEvaluacionSecId: serial.rubroEvaluacionSecId,
      peso: serial.peso
    );
  }

  static List<RubroEvalRNPFormulaData> converListSerializeRubroEvalRNPFormula(dynamic model){
    List<RubroEvalRNPFormulaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeListaRubroEvalRNPFormula(item));
    }
    return items;
  }


  static UnidadEventoData converSerializeUnidadEvento(Map<String,dynamic> model){
    UnidadEventoSerial serial = UnidadEventoSerial.fromJson(model);
    return UnidadEventoData(
        unidadAprendizajeId: serial.unidadAprendizajeId??0,
        titulo: serial.titulo,
        reto: serial.reto,
        desafio: serial.desafio,
        nroHoras: serial.nroHoras,
        nroSemanas: serial.nroSemanas,
        nroSesiones: serial.nroSesiones,
        nroUnidad: serial.nroUnidad,
        situacionSignificativaComplementaria: serial.situacionSignificativaComplementaria,
        situacionSignificativa: serial.situacionSignificativa,
        silaboEventoId: serial.silaboEventoId,
        estadoId: serial.estadoId,
    );
  }

  static List<UnidadEventoData> converListSerializeUnidadEvento(dynamic model){
    List<UnidadEventoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeUnidadEvento(item));
    }
    return items;
  }


  static RelUnidadEventoData converSerializeRelUnidadEvento(Map<String,dynamic> model){
    RelUnidadEventoSerial serial = RelUnidadEventoSerial.fromJson(model);
    return RelUnidadEventoData(
      unidadaprendizajeId: serial.unidadaprendizajeId??0,
      tipoid: serial.tipoid??0,
    );
  }

  static List<RelUnidadEventoData> converListSerializeRelUnidadEvento(dynamic model){
    List<RelUnidadEventoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeRelUnidadEvento(item));
    }
    return items;
  }

  static SesionEventoData converSerializeSesionEvento(Map<String,dynamic> model){
    SesionEventoSerial serial = SesionEventoSerial.fromJson(model);
    return SesionEventoData(
      sesionAprendizajeId: serial.sesionAprendizajeId??0,
      titulo: serial.titulo,
      contenido: serial.contenido,
      docenteid: serial.docenteid,
      evaluados: serial.evaluados,
      proposito: serial.proposito,
      horas: serial.horas,
      nroSesion: serial.nroSesion,
       rolId: serial.rolId,
      estadoEjecucionId: serial.estadoEjecucionId,
      estadoEvaluacion: serial.estadoEvaluacion,
      estadoId: serial.estadoId,
      fechaEjecucion: serial.fechaEjecucion,
      fechaEjecucionFin: serial.fechaEjecucionFin,
      fechaRealizada: serial.fechaRealizada,
      fechaReprogramacion: serial.fechaReprogramacion,
      fechaPublicacion: serial.fechaPublicacion,
      unidadAprendizajeId: serial.unidadAprendizajeId,
      usuarioAccionId: serial.usuarioAccionId,
      fechaAccion: serial.fechaAccion,
      usuarioCreacionId: serial.usuarioCreacionId,
      fechaCreacion: serial.fechaCreacion,
      parentSesionId: serial.parentSesionId
    );
  }

  static List<SesionEventoData> converListSerializeSesionEvento(dynamic model){
    List<SesionEventoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeSesionEvento(item));
    }
    return items;
  }

}

