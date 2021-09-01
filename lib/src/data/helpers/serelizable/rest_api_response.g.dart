// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminServiceSerializable _$AdminServiceSerializableFromJson(
    Map<String, dynamic> json) {
  return AdminServiceSerializable(
    UsuarioId: json['UsuarioId'] as int?,
    Estado: json['Estado'] as bool?,
    EntidadId: json['EntidadId'] as int?,
    UsuarioExternoId: json['UsuarioExternoId'] as int?,
    UsuarioCreadorId: json['UsuarioCreadorId'] as int?,
    UsuarioAccionId: json['UsuarioAccionId'] as int?,
    Opcion: json['Opcion'] as int?,
    Cantidad: json['Cantidad'] as int?,
    UrlServiceMovil: json['UrlServiceMovil'] as String?,
  );
}

Map<String, dynamic> _$AdminServiceSerializableToJson(
        AdminServiceSerializable instance) =>
    <String, dynamic>{
      'UsuarioId': instance.UsuarioId,
      'Estado': instance.Estado,
      'EntidadId': instance.EntidadId,
      'UsuarioExternoId': instance.UsuarioExternoId,
      'UsuarioCreadorId': instance.UsuarioCreadorId,
      'UsuarioAccionId': instance.UsuarioAccionId,
      'Opcion': instance.Opcion,
      'Cantidad': instance.Cantidad,
      'UrlServiceMovil': instance.UrlServiceMovil,
    };

EntidadSerializable _$EntidadSerializableFromJson(Map<String, dynamic> json) {
  return EntidadSerializable(
    entidadId: json['entidadId'] as int?,
    tipoId: json['tipoId'] as int?,
    parentId: json['parentId'] as int?,
    nombre: json['nombre'] as String?,
    ruc: json['ruc'] as String?,
    site: json['site'] as String?,
    telefono: json['telefono'] as String?,
    correo: json['correo'] as String?,
    foto: json['foto'] as String?,
    estadoId: json['estadoId'] as int?,
  );
}

Map<String, dynamic> _$EntidadSerializableToJson(
        EntidadSerializable instance) =>
    <String, dynamic>{
      'entidadId': instance.entidadId,
      'tipoId': instance.tipoId,
      'parentId': instance.parentId,
      'nombre': instance.nombre,
      'ruc': instance.ruc,
      'site': instance.site,
      'telefono': instance.telefono,
      'correo': instance.correo,
      'foto': instance.foto,
      'estadoId': instance.estadoId,
    };

GeoreferenciaSerializable _$GeoreferenciaSerializableFromJson(
    Map<String, dynamic> json) {
  return GeoreferenciaSerializable(
    georeferenciaId: json['georeferenciaId'] as int?,
    nombre: json['nombre'] as String?,
    entidadId: json['entidadId'] as int?,
    alias: json['alias'] as String?,
    estadoId: json['estadoId'] as int?,
  );
}

Map<String, dynamic> _$GeoreferenciaSerializableToJson(
        GeoreferenciaSerializable instance) =>
    <String, dynamic>{
      'georeferenciaId': instance.georeferenciaId,
      'nombre': instance.nombre,
      'entidadId': instance.entidadId,
      'alias': instance.alias,
      'estadoId': instance.estadoId,
    };

RolSerializable _$RolSerializableFromJson(Map<String, dynamic> json) {
  return RolSerializable(
    rolId: json['rolId'] as int?,
    nombre: json['nombre'] as String?,
    parentId: json['parentId'] as int?,
    estado: json['estado'] as bool?,
  );
}

Map<String, dynamic> _$RolSerializableToJson(RolSerializable instance) =>
    <String, dynamic>{
      'rolId': instance.rolId,
      'nombre': instance.nombre,
      'parentId': instance.parentId,
      'estado': instance.estado,
    };

UsuarioRolGeoreferenciaSerializable
    _$UsuarioRolGeoreferenciaSerializableFromJson(Map<String, dynamic> json) {
  return UsuarioRolGeoreferenciaSerializable(
    usuarioRolGeoreferenciaId: json['usuarioRolGeoreferenciaId'] as int?,
    usuarioId: json['usuarioId'] as int?,
    rolId: json['rolId'] as int?,
    geoReferenciaId: json['geoReferenciaId'] as int?,
    entidadId: json['entidadId'] as int?,
  );
}

Map<String, dynamic> _$UsuarioRolGeoreferenciaSerializableToJson(
        UsuarioRolGeoreferenciaSerializable instance) =>
    <String, dynamic>{
      'usuarioRolGeoreferenciaId': instance.usuarioRolGeoreferenciaId,
      'usuarioId': instance.usuarioId,
      'rolId': instance.rolId,
      'geoReferenciaId': instance.geoReferenciaId,
      'entidadId': instance.entidadId,
    };

PersonaSerial _$PersonaSerialFromJson(Map<String, dynamic> json) {
  return PersonaSerial(
    personaId: json['personaId'] as int?,
    nombres: json['nombres'] as String?,
    apellidoPaterno: json['apellidoPaterno'] as String?,
    apellidoMaterno: json['apellidoMaterno'] as String?,
    celular: json['celular'] as String?,
    telefono: json['telefono'] as String?,
    foto: json['foto'] as String?,
    fechaNac: json['fechaNac'] as String?,
    genero: json['genero'] as String?,
    estadoCivil: json['estadoCivil'] as String?,
    numDoc: json['numDoc'] as String?,
    ocupacion: json['ocupacion'] as String?,
    estadoId: json['estadoId'] as int?,
    correo: json['correo'] as String?,
    direccion: json['direccion'] as String?,
    path: json['path'] as String?,
    image64: json['image64'] as String?,
  );
}

Map<String, dynamic> _$PersonaSerialToJson(PersonaSerial instance) =>
    <String, dynamic>{
      'personaId': instance.personaId,
      'nombres': instance.nombres,
      'apellidoPaterno': instance.apellidoPaterno,
      'apellidoMaterno': instance.apellidoMaterno,
      'celular': instance.celular,
      'telefono': instance.telefono,
      'foto': instance.foto,
      'fechaNac': instance.fechaNac,
      'genero': instance.genero,
      'estadoCivil': instance.estadoCivil,
      'numDoc': instance.numDoc,
      'ocupacion': instance.ocupacion,
      'estadoId': instance.estadoId,
      'correo': instance.correo,
      'direccion': instance.direccion,
      'path': instance.path,
      'image64': instance.image64,
    };

EmpleadoSerial _$EmpleadoSerialFromJson(Map<String, dynamic> json) {
  return EmpleadoSerial(
    empleadoId: json['empleadoId'] as int?,
    personaId: json['personaId'] as int?,
    linkURL: json['linkURL'] as String?,
    estado: json['estado'] as bool?,
    tipoId: json['tipoId'] as int?,
    web: json['web'] as String?,
  );
}

Map<String, dynamic> _$EmpleadoSerialToJson(EmpleadoSerial instance) =>
    <String, dynamic>{
      'empleadoId': instance.empleadoId,
      'personaId': instance.personaId,
      'linkURL': instance.linkURL,
      'estado': instance.estado,
      'tipoId': instance.tipoId,
      'web': instance.web,
    };

AnioAcademicoSerial _$AnioAcademicoSerialFromJson(Map<String, dynamic> json) {
  return AnioAcademicoSerial(
    idAnioAcademico: json['idAnioAcademico'] as int?,
    nombre: json['nombre'] as String?,
    fechaInicio: json['fechaInicio'] as String?,
    fechaFin: json['fechaFin'] as String?,
    denominacion: json['denominacion'] as String?,
    georeferenciaId: json['georeferenciaId'] as int?,
    organigramaId: json['organigramaId'] as int?,
    estadoId: json['estadoId'] as int?,
    tipoId: json['tipoId'] as int?,
  );
}

Map<String, dynamic> _$AnioAcademicoSerialToJson(
        AnioAcademicoSerial instance) =>
    <String, dynamic>{
      'idAnioAcademico': instance.idAnioAcademico,
      'nombre': instance.nombre,
      'fechaInicio': instance.fechaInicio,
      'fechaFin': instance.fechaFin,
      'denominacion': instance.denominacion,
      'georeferenciaId': instance.georeferenciaId,
      'organigramaId': instance.organigramaId,
      'estadoId': instance.estadoId,
      'tipoId': instance.tipoId,
    };

ParametroConfiguracionSerial _$ParametroConfiguracionSerialFromJson(
    Map<String, dynamic> json) {
  return ParametroConfiguracionSerial(
    json['id'] as int?,
    json['concepto'] as String?,
    json['parametro'] as String?,
    json['entidadId'] as int?,
    json['orden'] as int?,
  );
}

Map<String, dynamic> _$ParametroConfiguracionSerialToJson(
        ParametroConfiguracionSerial instance) =>
    <String, dynamic>{
      'id': instance.id,
      'concepto': instance.concepto,
      'parametro': instance.parametro,
      'entidadId': instance.entidadId,
      'orden': instance.orden,
    };

AulaSerial _$AulaSerialFromJson(Map<String, dynamic> json) {
  return AulaSerial(
    aulaId: json['aulaId'] as int?,
    descripcion: json['descripcion'] as String?,
    numero: json['numero'] as String?,
    capacidad: json['capacidad'] as String?,
    estado: json['estado'] as int?,
  );
}

Map<String, dynamic> _$AulaSerialToJson(AulaSerial instance) =>
    <String, dynamic>{
      'aulaId': instance.aulaId,
      'descripcion': instance.descripcion,
      'numero': instance.numero,
      'capacidad': instance.capacidad,
      'estado': instance.estado,
    };

CargaAcademicaSerial _$CargaAcademicaSerialFromJson(Map<String, dynamic> json) {
  return CargaAcademicaSerial(
    cargaAcademicaId: json['cargaAcademicaId'] as int?,
    seccionId: json['seccionId'] as int?,
    periodoId: json['periodoId'] as int?,
    aulaId: json['aulaId'] as int?,
    idPlanEstudio: json['idPlanEstudio'] as int?,
    idPlanEstudioVersion: json['idPlanEstudioVersion'] as int?,
    idAnioAcademico: json['idAnioAcademico'] as int?,
    idEmpleadoTutor: json['idEmpleadoTutor'] as int?,
    estadoId: json['estadoId'] as int?,
    idPeriodoAcad: json['idPeriodoAcad'] as int?,
    idGrupo: json['idGrupo'] as int?,
    capacidadVacante: json['capacidadVacante'] as int?,
    capacidadVacanteD: json['capacidadVacanteD'] as int?,
  );
}

Map<String, dynamic> _$CargaAcademicaSerialToJson(
        CargaAcademicaSerial instance) =>
    <String, dynamic>{
      'cargaAcademicaId': instance.cargaAcademicaId,
      'seccionId': instance.seccionId,
      'periodoId': instance.periodoId,
      'aulaId': instance.aulaId,
      'idPlanEstudio': instance.idPlanEstudio,
      'idPlanEstudioVersion': instance.idPlanEstudioVersion,
      'idAnioAcademico': instance.idAnioAcademico,
      'idEmpleadoTutor': instance.idEmpleadoTutor,
      'estadoId': instance.estadoId,
      'idPeriodoAcad': instance.idPeriodoAcad,
      'idGrupo': instance.idGrupo,
      'capacidadVacante': instance.capacidadVacante,
      'capacidadVacanteD': instance.capacidadVacanteD,
    };

CargaCursoDocenteSerial _$CargaCursoDocenteSerialFromJson(
    Map<String, dynamic> json) {
  return CargaCursoDocenteSerial(
    cargaCursoDocenteId: json['cargaCursoDocenteId'] as int?,
    cargaCursoId: json['cargaCursoId'] as int?,
    docenteId: json['docenteId'] as int?,
    responsable: json['responsable'] as bool?,
  );
}

Map<String, dynamic> _$CargaCursoDocenteSerialToJson(
        CargaCursoDocenteSerial instance) =>
    <String, dynamic>{
      'cargaCursoDocenteId': instance.cargaCursoDocenteId,
      'cargaCursoId': instance.cargaCursoId,
      'docenteId': instance.docenteId,
      'responsable': instance.responsable,
    };

CargaCursoDocenteDetSerial _$CargaCursoDocenteDetSerialFromJson(
    Map<String, dynamic> json) {
  return CargaCursoDocenteDetSerial(
    cargaCursoDocenteId: json['cargaCursoDocenteId'] as int?,
    alumnoId: json['alumnoId'] as int?,
  );
}

Map<String, dynamic> _$CargaCursoDocenteDetSerialToJson(
        CargaCursoDocenteDetSerial instance) =>
    <String, dynamic>{
      'cargaCursoDocenteId': instance.cargaCursoDocenteId,
      'alumnoId': instance.alumnoId,
    };

CursosSerializable _$CursosSerializableFromJson(Map<String, dynamic> json) {
  return CursosSerializable(
    cursoId: json['cursoId'] as int?,
    nombre: json['nombre'] as String?,
    estadoId: json['estadoId'] as int?,
    descripcion: json['descripcion'] as String?,
    alias: json['alias'] as String?,
    entidadId: json['entidadId'] as int?,
    nivelAcadId: json['nivelAcadId'] as int?,
    tipoCursoId: json['tipoCursoId'] as int?,
    tipoConceptoId: json['tipoConceptoId'] as int?,
    color: json['color'] as String?,
    creditos: json['creditos'] as String?,
    totalHP: json['totalHP'] as String?,
    totalHT: json['totalHT'] as String?,
    notaAprobatoria: json['notaAprobatoria'] as String?,
    sumilla: json['sumilla'] as String?,
    superId: json['superId'] as int?,
    idServicioLaboratorio: json['idServicioLaboratorio'] as int?,
    horasLaboratorio: json['horasLaboratorio'] as int?,
    tipoSubcurso: json['tipoSubcurso'] as bool?,
    foto: json['foto'] as String?,
    codigo: json['codigo'] as String?,
  );
}

Map<String, dynamic> _$CursosSerializableToJson(CursosSerializable instance) =>
    <String, dynamic>{
      'cursoId': instance.cursoId,
      'nombre': instance.nombre,
      'estadoId': instance.estadoId,
      'descripcion': instance.descripcion,
      'alias': instance.alias,
      'entidadId': instance.entidadId,
      'nivelAcadId': instance.nivelAcadId,
      'tipoCursoId': instance.tipoCursoId,
      'tipoConceptoId': instance.tipoConceptoId,
      'color': instance.color,
      'creditos': instance.creditos,
      'totalHP': instance.totalHP,
      'totalHT': instance.totalHT,
      'notaAprobatoria': instance.notaAprobatoria,
      'sumilla': instance.sumilla,
      'superId': instance.superId,
      'idServicioLaboratorio': instance.idServicioLaboratorio,
      'horasLaboratorio': instance.horasLaboratorio,
      'tipoSubcurso': instance.tipoSubcurso,
      'foto': instance.foto,
      'codigo': instance.codigo,
    };

CargaCursosSerial _$CargaCursosSerialFromJson(Map<String, dynamic> json) {
  return CargaCursosSerial(
    cargaCursoId: json['cargaCursoId'] as int?,
    planCursoId: json['planCursoId'] as int?,
    empleadoId: json['empleadoId'] as int?,
    cargaAcademicaId: json['cargaAcademicaId'] as int?,
    complejo: json['complejo'] as int?,
    evaluable: json['evaluable'] as int?,
    idempleado: json['idempleado'] as int?,
    idTipoHora: json['idTipoHora'] as int?,
    descripcion: json['descripcion'] as String?,
    fechaInicio: json['fechaInicio'] as int?,
    fechafin: json['fechafin'] as int?,
    modo: json['modo'] as String?,
    estado: json['estado'] as int?,
    anioAcademicoId: json['anioAcademicoId'] as int?,
    aulaId: json['aulaId'] as int?,
    grupoId: json['grupoId'] as int?,
    idPlanEstudio: json['idPlanEstudio'] as int?,
    idPlanEstudioVersion: json['idPlanEstudioVersion'] as int?,
    CapacidadVacanteP: json['CapacidadVacanteP'] as int?,
    CapacidadVacanteD: json['CapacidadVacanteD'] as int?,
  )
    ..nombreDocente = json['nombreDocente'] as String?
    ..personaIdDocente = json['personaIdDocente'] as int?
    ..fotoDocente = json['fotoDocente'] as String?;
}

Map<String, dynamic> _$CargaCursosSerialToJson(CargaCursosSerial instance) =>
    <String, dynamic>{
      'cargaCursoId': instance.cargaCursoId,
      'planCursoId': instance.planCursoId,
      'empleadoId': instance.empleadoId,
      'cargaAcademicaId': instance.cargaAcademicaId,
      'complejo': instance.complejo,
      'evaluable': instance.evaluable,
      'idempleado': instance.idempleado,
      'idTipoHora': instance.idTipoHora,
      'descripcion': instance.descripcion,
      'fechaInicio': instance.fechaInicio,
      'fechafin': instance.fechafin,
      'modo': instance.modo,
      'estado': instance.estado,
      'anioAcademicoId': instance.anioAcademicoId,
      'aulaId': instance.aulaId,
      'grupoId': instance.grupoId,
      'idPlanEstudio': instance.idPlanEstudio,
      'idPlanEstudioVersion': instance.idPlanEstudioVersion,
      'CapacidadVacanteP': instance.CapacidadVacanteP,
      'CapacidadVacanteD': instance.CapacidadVacanteD,
      'nombreDocente': instance.nombreDocente,
      'personaIdDocente': instance.personaIdDocente,
      'fotoDocente': instance.fotoDocente,
    };

ParametrosDisenioSerial _$ParametrosDisenioSerialFromJson(
    Map<String, dynamic> json) {
  return ParametrosDisenioSerial(
    parametroDisenioId: json['parametroDisenioId'] as int?,
    objeto: json['objeto'] as String?,
    concepto: json['concepto'] as String?,
    nombre: json['nombre'] as String?,
    path: json['path'] as String?,
    color1: json['color1'] as String?,
    color2: json['color2'] as String?,
    color3: json['color3'] as String?,
    estado: json['estado'] as bool?,
  );
}

Map<String, dynamic> _$ParametrosDisenioSerialToJson(
        ParametrosDisenioSerial instance) =>
    <String, dynamic>{
      'parametroDisenioId': instance.parametroDisenioId,
      'objeto': instance.objeto,
      'concepto': instance.concepto,
      'nombre': instance.nombre,
      'path': instance.path,
      'color1': instance.color1,
      'color2': instance.color2,
      'color3': instance.color3,
      'estado': instance.estado,
    };

NivelAcademicoSeraializable _$NivelAcademicoSeraializableFromJson(
    Map<String, dynamic> json) {
  return NivelAcademicoSeraializable(
    nivelAcadId: json['nivelAcadId'] as int?,
    nombre: json['nombre'] as String?,
    activo: json['activo'] as bool?,
    entidadId: json['entidadId'] as int?,
  );
}

Map<String, dynamic> _$NivelAcademicoSeraializableToJson(
        NivelAcademicoSeraializable instance) =>
    <String, dynamic>{
      'nivelAcadId': instance.nivelAcadId,
      'nombre': instance.nombre,
      'activo': instance.activo,
      'entidadId': instance.entidadId,
    };

PeriodosSeraializable _$PeriodosSeraializableFromJson(
    Map<String, dynamic> json) {
  return PeriodosSeraializable(
    periodoId: json['periodoId'] as int?,
    nombre: json['nombre'] as String?,
    estadoId: json['estadoId'] as int?,
    alias: json['alias'] as String?,
    fecComienzo: json['fecComienzo'] as String?,
    fecTermino: json['fecTermino'] as String?,
    tipoId: json['tipoId'] as int?,
    superId: json['superId'] as int?,
    geoReferenciaId: json['geoReferenciaId'] as int?,
    organigramaId: json['organigramaId'] as int?,
    entidadId: json['entidadId'] as int?,
    activo: json['activo'] as bool?,
    cicloId: json['cicloId'] as int?,
    docenteId: json['docenteId'] as int?,
    gruponombre: json['gruponombre'] as String?,
    grupoId: json['grupoId'] as int?,
    nivelAcademico: json['nivelAcademico'] as String?,
    nivelAcademicoId: json['nivelAcademicoId'] as int?,
    tutorId: json['tutorId'] as int?,
  );
}

Map<String, dynamic> _$PeriodosSeraializableToJson(
        PeriodosSeraializable instance) =>
    <String, dynamic>{
      'periodoId': instance.periodoId,
      'nombre': instance.nombre,
      'estadoId': instance.estadoId,
      'alias': instance.alias,
      'fecComienzo': instance.fecComienzo,
      'fecTermino': instance.fecTermino,
      'tipoId': instance.tipoId,
      'superId': instance.superId,
      'geoReferenciaId': instance.geoReferenciaId,
      'organigramaId': instance.organigramaId,
      'entidadId': instance.entidadId,
      'activo': instance.activo,
      'cicloId': instance.cicloId,
      'docenteId': instance.docenteId,
      'gruponombre': instance.gruponombre,
      'grupoId': instance.grupoId,
      'nivelAcademico': instance.nivelAcademico,
      'nivelAcademicoId': instance.nivelAcademicoId,
      'tutorId': instance.tutorId,
    };

PlanCursosSerial _$PlanCursosSerialFromJson(Map<String, dynamic> json) {
  return PlanCursosSerial(
    planCursoId: json['planCursoId'] as int?,
    cursoId: json['cursoId'] as int?,
    periodoId: json['periodoId'] as int?,
    planEstudiosId: json['planEstudiosId'] as int?,
  );
}

Map<String, dynamic> _$PlanCursosSerialToJson(PlanCursosSerial instance) =>
    <String, dynamic>{
      'planCursoId': instance.planCursoId,
      'cursoId': instance.cursoId,
      'periodoId': instance.periodoId,
      'planEstudiosId': instance.planEstudiosId,
    };

PlanEstudiosSerial _$PlanEstudiosSerialFromJson(Map<String, dynamic> json) {
  return PlanEstudiosSerial(
    planEstudiosId: json['planEstudiosId'] as int?,
    programaEduId: json['programaEduId'] as int?,
    nombrePlan: json['nombrePlan'] as String?,
    alias: json['alias'] as String?,
    estadoId: json['estadoId'] as int?,
    nroResolucion: json['nroResolucion'] as String?,
    fechaResolucion: json['fechaResolucion'] as String?,
  );
}

Map<String, dynamic> _$PlanEstudiosSerialToJson(PlanEstudiosSerial instance) =>
    <String, dynamic>{
      'planEstudiosId': instance.planEstudiosId,
      'programaEduId': instance.programaEduId,
      'nombrePlan': instance.nombrePlan,
      'alias': instance.alias,
      'estadoId': instance.estadoId,
      'nroResolucion': instance.nroResolucion,
      'fechaResolucion': instance.fechaResolucion,
    };

ProgramasEducativoSerial _$ProgramasEducativoSerialFromJson(
    Map<String, dynamic> json) {
  return ProgramasEducativoSerial(
    programaEduId: json['programaEduId'] as int?,
    nombre: json['nombre'] as String?,
    nroCiclos: json['nroCiclos'] as String?,
    nivelAcadId: json['nivelAcadId'] as int?,
    tipoEvaluacionId: json['tipoEvaluacionId'] as int?,
    estadoId: json['estadoId'] as int?,
    entidadId: json['entidadId'] as int?,
    tipoInformeSiagieId: json['tipoInformeSiagieId'] as int?,
    tipoProgramaId: json['tipoProgramaId'] as int?,
    tipoMatriculaId: json['tipoMatriculaId'] as int?,
  );
}

Map<String, dynamic> _$ProgramasEducativoSerialToJson(
        ProgramasEducativoSerial instance) =>
    <String, dynamic>{
      'programaEduId': instance.programaEduId,
      'nombre': instance.nombre,
      'nroCiclos': instance.nroCiclos,
      'nivelAcadId': instance.nivelAcadId,
      'tipoEvaluacionId': instance.tipoEvaluacionId,
      'estadoId': instance.estadoId,
      'entidadId': instance.entidadId,
      'tipoInformeSiagieId': instance.tipoInformeSiagieId,
      'tipoProgramaId': instance.tipoProgramaId,
      'tipoMatriculaId': instance.tipoMatriculaId,
    };

SeccionSeraializable _$SeccionSeraializableFromJson(Map<String, dynamic> json) {
  return SeccionSeraializable(
    json['seccionId'] as int?,
    json['nombre'] as String?,
    json['descripcion'] as String?,
    json['estado'] as bool?,
    json['georeferenciaId'] as int?,
  );
}

Map<String, dynamic> _$SeccionSeraializableToJson(
        SeccionSeraializable instance) =>
    <String, dynamic>{
      'seccionId': instance.seccionId,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'estado': instance.estado,
      'georeferenciaId': instance.georeferenciaId,
    };

SilaboEventoSerial _$SilaboEventoSerialFromJson(Map<String, dynamic> json) {
  return SilaboEventoSerial(
    silaboEventoId: json['silaboEventoId'] as int?,
    titulo: json['titulo'] as String?,
    descripcionGeneral: json['descripcionGeneral'] as String?,
    planCursoId: json['planCursoId'] as int?,
    entidadId: json['entidadId'] as int?,
    docenteId: json['docenteId'] as int?,
    seccionId: json['seccionId'] as int?,
    fechaInicio: json['fechaInicio'] as String?,
    fechaFin: json['fechaFin'] as String?,
    estadoId: json['estadoId'] as int?,
    anioAcademicoId: json['anioAcademicoId'] as int?,
    georeferenciaId: json['georeferenciaId'] as int?,
    silaboBaseId: json['silaboBaseId'] as int?,
    cargaCursoId: json['cargaCursoId'] as int?,
    parametroDisenioId: json['parametroDisenioId'] as int?,
  );
}

Map<String, dynamic> _$SilaboEventoSerialToJson(SilaboEventoSerial instance) =>
    <String, dynamic>{
      'silaboEventoId': instance.silaboEventoId,
      'titulo': instance.titulo,
      'descripcionGeneral': instance.descripcionGeneral,
      'planCursoId': instance.planCursoId,
      'entidadId': instance.entidadId,
      'docenteId': instance.docenteId,
      'seccionId': instance.seccionId,
      'fechaInicio': instance.fechaInicio,
      'fechaFin': instance.fechaFin,
      'estadoId': instance.estadoId,
      'anioAcademicoId': instance.anioAcademicoId,
      'georeferenciaId': instance.georeferenciaId,
      'silaboBaseId': instance.silaboBaseId,
      'cargaCursoId': instance.cargaCursoId,
      'parametroDisenioId': instance.parametroDisenioId,
    };

CalendarioPeriodoSerial _$CalendarioPeriodoSerialFromJson(
    Map<String, dynamic> json) {
  return CalendarioPeriodoSerial(
    calendarioPeriodoId: json['calendarioPeriodoId'] as int?,
    fechaInicio: json['fechaInicio'] as int?,
    fechaFin: json['fechaFin'] as int?,
    calendarioAcademicoId: json['calendarioAcademicoId'] as int?,
    tipoId: json['tipoId'] as int?,
    estadoId: json['estadoId'] as int?,
    diazPlazo: json['diazPlazo'] as int?,
    habilitado: json['habilitado'] as bool?,
  );
}

Map<String, dynamic> _$CalendarioPeriodoSerialToJson(
        CalendarioPeriodoSerial instance) =>
    <String, dynamic>{
      'calendarioPeriodoId': instance.calendarioPeriodoId,
      'fechaInicio': instance.fechaInicio,
      'fechaFin': instance.fechaFin,
      'calendarioAcademicoId': instance.calendarioAcademicoId,
      'tipoId': instance.tipoId,
      'estadoId': instance.estadoId,
      'diazPlazo': instance.diazPlazo,
      'habilitado': instance.habilitado,
    };

CalendarioCargaCursoSerial _$CalendarioCargaCursoSerialFromJson(
    Map<String, dynamic> json) {
  return CalendarioCargaCursoSerial(
    calendarioPeriodoId: json['calendarioPeriodoId'] as int?,
    fechaInicio: json['fechaInicio'] as int?,
    fechaFin: json['fechaFin'] as int?,
    calendarioAcademicoId: json['calendarioAcademicoId'] as int?,
    tipoId: json['tipoId'] as int?,
    estadoId: json['estadoId'] as int?,
    diazPlazo: json['diazPlazo'] as int?,
    habilitado: json['habilitado'] as int?,
    nombre: json['nombre'] as String?,
    cargaCursoId: json['cargaCursoId'] as int?,
  );
}

Map<String, dynamic> _$CalendarioCargaCursoSerialToJson(
        CalendarioCargaCursoSerial instance) =>
    <String, dynamic>{
      'calendarioPeriodoId': instance.calendarioPeriodoId,
      'fechaInicio': instance.fechaInicio,
      'fechaFin': instance.fechaFin,
      'calendarioAcademicoId': instance.calendarioAcademicoId,
      'tipoId': instance.tipoId,
      'estadoId': instance.estadoId,
      'diazPlazo': instance.diazPlazo,
      'nombre': instance.nombre,
      'habilitado': instance.habilitado,
      'cargaCursoId': instance.cargaCursoId,
    };

TiposSerial _$TiposSerialFromJson(Map<String, dynamic> json) {
  return TiposSerial(
    tipoId: json['tipoId'] as int?,
    objeto: json['objeto'] as String?,
    concepto: json['concepto'] as String?,
    nombre: json['nombre'] as String?,
    codigo: json['codigo'] as String?,
    parentId: json['parentId'] as int?,
  );
}

Map<String, dynamic> _$TiposSerialToJson(TiposSerial instance) =>
    <String, dynamic>{
      'tipoId': instance.tipoId,
      'objeto': instance.objeto,
      'concepto': instance.concepto,
      'nombre': instance.nombre,
      'codigo': instance.codigo,
      'parentId': instance.parentId,
    };

CalendarioAcademicoSerial _$CalendarioAcademicoSerialFromJson(
    Map<String, dynamic> json) {
  return CalendarioAcademicoSerial(
    calendarioAcademicoId: json['calendarioAcademicoId'] as int?,
    programaEduId: json['programaEduId'] as int?,
    idAnioAcademico: json['idAnioAcademico'] as int?,
    estadoId: json['estadoId'] as int?,
  );
}

Map<String, dynamic> _$CalendarioAcademicoSerialToJson(
        CalendarioAcademicoSerial instance) =>
    <String, dynamic>{
      'calendarioAcademicoId': instance.calendarioAcademicoId,
      'programaEduId': instance.programaEduId,
      'idAnioAcademico': instance.idAnioAcademico,
      'estadoId': instance.estadoId,
    };

HoraSerial _$HoraSerialFromJson(Map<String, dynamic> json) {
  return HoraSerial(
    idHora: json['idHora'] as int?,
    horaInicio: json['horaInicio'] as String?,
    horaFin: json['horaFin'] as String?,
  );
}

Map<String, dynamic> _$HoraSerialToJson(HoraSerial instance) =>
    <String, dynamic>{
      'idHora': instance.idHora,
      'horaInicio': instance.horaInicio,
      'horaFin': instance.horaFin,
    };

HorarioProgramaSerial _$HorarioProgramaSerialFromJson(
    Map<String, dynamic> json) {
  return HorarioProgramaSerial(
    idHorarioPrograma: json['idHorarioPrograma'] as int?,
    idHorario: json['idHorario'] as int?,
    activo: json['activo'] as int?,
    idProgramaEducativo: json['idProgramaEducativo'] as int?,
    idAnioAcademico: json['idAnioAcademico'] as int?,
    idUsuarioActualizacion: json['idUsuarioActualizacion'] as int?,
    idUsuarioCreacion: json['idUsuarioCreacion'] as int?,
    fechaCreacion: json['fechaCreacion'] as String?,
    fechaActualizacion: json['fechaActualizacion'] as String?,
  );
}

Map<String, dynamic> _$HorarioProgramaSerialToJson(
        HorarioProgramaSerial instance) =>
    <String, dynamic>{
      'idHorarioPrograma': instance.idHorarioPrograma,
      'idHorario': instance.idHorario,
      'activo': instance.activo,
      'idProgramaEducativo': instance.idProgramaEducativo,
      'idAnioAcademico': instance.idAnioAcademico,
      'idUsuarioActualizacion': instance.idUsuarioActualizacion,
      'idUsuarioCreacion': instance.idUsuarioCreacion,
      'fechaCreacion': instance.fechaCreacion,
      'fechaActualizacion': instance.fechaActualizacion,
    };

HorarioHoraSerial _$HorarioHoraSerialFromJson(Map<String, dynamic> json) {
  return HorarioHoraSerial(
    idHorarioHora: json['idHorarioHora'] as int?,
    horaId: json['horaId'] as int?,
    detalleHoraId: json['detalleHoraId'] as int?,
  );
}

Map<String, dynamic> _$HorarioHoraSerialToJson(HorarioHoraSerial instance) =>
    <String, dynamic>{
      'idHorarioHora': instance.idHorarioHora,
      'horaId': instance.horaId,
      'detalleHoraId': instance.detalleHoraId,
    };

DetalleHorarioSerial _$DetalleHorarioSerialFromJson(Map<String, dynamic> json) {
  return DetalleHorarioSerial(
    idDetalleHorario: json['idDetalleHorario'] as int?,
    idTipoHora: json['idTipoHora'] as int?,
    idTipoTurno: json['idTipoTurno'] as int?,
    horaInicio: json['horaInicio'] as String?,
    horaFin: json['horaFin'] as String?,
    idHorarioDia: json['idHorarioDia'] as int?,
    timeChange: json['timeChange'] as int?,
  );
}

Map<String, dynamic> _$DetalleHorarioSerialToJson(
        DetalleHorarioSerial instance) =>
    <String, dynamic>{
      'idDetalleHorario': instance.idDetalleHorario,
      'idTipoHora': instance.idTipoHora,
      'idTipoTurno': instance.idTipoTurno,
      'horaInicio': instance.horaInicio,
      'horaFin': instance.horaFin,
      'idHorarioDia': instance.idHorarioDia,
      'timeChange': instance.timeChange,
    };

DiaSerial _$DiaSerialFromJson(Map<String, dynamic> json) {
  return DiaSerial(
    diaId: json['diaId'] as int?,
    nombre: json['nombre'] as String?,
    estado: json['estado'] as bool?,
    alias: json['alias'] as String?,
  );
}

Map<String, dynamic> _$DiaSerialToJson(DiaSerial instance) => <String, dynamic>{
      'diaId': instance.diaId,
      'nombre': instance.nombre,
      'estado': instance.estado,
      'alias': instance.alias,
    };

HorarioDiaSerial _$HorarioDiaSerialFromJson(Map<String, dynamic> json) {
  return HorarioDiaSerial(
    idHorarioDia: json['idHorarioDia'] as int?,
    idHorario: json['idHorario'] as int?,
    idDia: json['idDia'] as int?,
  );
}

Map<String, dynamic> _$HorarioDiaSerialToJson(HorarioDiaSerial instance) =>
    <String, dynamic>{
      'idHorarioDia': instance.idHorarioDia,
      'idHorario': instance.idHorario,
      'idDia': instance.idDia,
    };

CursosDetHorarioSerial _$CursosDetHorarioSerialFromJson(
    Map<String, dynamic> json) {
  return CursosDetHorarioSerial(
    idCursosDetHorario: json['idCursosDetHorario'] as int?,
    idDetHorario: json['idDetHorario'] as int?,
    idCargaCurso: json['idCargaCurso'] as int?,
  );
}

Map<String, dynamic> _$CursosDetHorarioSerialToJson(
        CursosDetHorarioSerial instance) =>
    <String, dynamic>{
      'idCursosDetHorario': instance.idCursosDetHorario,
      'idDetHorario': instance.idDetHorario,
      'idCargaCurso': instance.idCargaCurso,
    };

HorarioSerial _$HorarioSerialFromJson(Map<String, dynamic> json) {
  return HorarioSerial(
    idHorario: json['idHorario'] as int?,
    nombre: json['nombre'] as String?,
    descripcion: json['descripción'] as String?,
    fecCreacion: json['fecCreacion'] as String?,
    fecActualizacion: json['fecActualizacion'] as String?,
    estado: json['estado'] as bool?,
    idUsuario: json['idUsuario'] as int?,
    entidadId: json['entidadId'] as int?,
    georeferenciaId: json['georeferenciaId'] as int?,
    organigramaId: json['organigramaId'] as int?,
  );
}

Map<String, dynamic> _$HorarioSerialToJson(HorarioSerial instance) =>
    <String, dynamic>{
      'idHorario': instance.idHorario,
      'nombre': instance.nombre,
      'descripción': instance.descripcion,
      'fecCreacion': instance.fecCreacion,
      'fecActualizacion': instance.fecActualizacion,
      'estado': instance.estado,
      'idUsuario': instance.idUsuario,
      'entidadId': instance.entidadId,
      'georeferenciaId': instance.georeferenciaId,
      'organigramaId': instance.organigramaId,
    };

WebConfigsSerial _$WebConfigsSerialFromJson(Map<String, dynamic> json) {
  return WebConfigsSerial(
    json['nombre'] as String?,
    json['content'] as String?,
  );
}

Map<String, dynamic> _$WebConfigsSerialToJson(WebConfigsSerial instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'content': instance.content,
    };

CriteriosSerial _$CriteriosSerialFromJson(Map<String, dynamic> json) {
  return CriteriosSerial(
    json['sesionAprendizajeId'] as int?,
    json['unidadAprendiajeId'] as int?,
    json['silaboEventoId'] as int?,
    json['sesionAprendizajePadreId'] as int?,
    json['tituloSesion'] as String?,
    json['rolIdSesion'] as int?,
    json['nroSesion'] as int?,
    json['propositoSesion'] as String?,
    json['tituloUnidad'] as String?,
    json['nroUnidad'] as int?,
    json['competenciaId'] as int?,
    json['competenciaNombre'] as String?,
    json['competenciaDescripcion'] as String?,
    json['competenciaTipoId'] as int?,
    json['superCompetenciaId'] as int?,
    json['superCompetenciaNombre'] as String?,
    json['superCompetenciaDescripcion'] as String?,
    json['superCompetenciaTipoId'] as int?,
    json['desempenioIcdId'] as int?,
    json['DesempenioDescripcion'] as String?,
    json['peso'] as int?,
    json['codigo'] as String?,
    json['tipoId'] as int?,
    json['url'] as String?,
    json['desempenioId'] as int?,
    json['desempenioIcdDescripcion'] as String?,
    json['icdId'] as int?,
    json['icdTitulo'] as String?,
    json['icdDescripcion'] as String?,
    json['icdAlias'] as String?,
    json['campoTematicoId'] as int?,
    json['campoTematicoTitulo'] as String?,
    json['campoTematicoDescripcion'] as String?,
    json['campoTematicoEstado'] as int?,
    json['campoTematicoParentId'] as int?,
    json['campoTematicoParentTitulo'] as String?,
    json['campoTematicoParentDescripcion'] as String?,
    json['campoTematicoParentEstado'] as int?,
    json['campoTematicoParentParentId'] as int?,
    json['calendarioPeriodoId'] as int?,
  );
}

Map<String, dynamic> _$CriteriosSerialToJson(CriteriosSerial instance) =>
    <String, dynamic>{
      'sesionAprendizajeId': instance.sesionAprendizajeId,
      'unidadAprendiajeId': instance.unidadAprendiajeId,
      'silaboEventoId': instance.silaboEventoId,
      'sesionAprendizajePadreId': instance.sesionAprendizajePadreId,
      'tituloSesion': instance.tituloSesion,
      'rolIdSesion': instance.rolIdSesion,
      'nroSesion': instance.nroSesion,
      'propositoSesion': instance.propositoSesion,
      'tituloUnidad': instance.tituloUnidad,
      'nroUnidad': instance.nroUnidad,
      'competenciaId': instance.competenciaId,
      'competenciaNombre': instance.competenciaNombre,
      'competenciaDescripcion': instance.competenciaDescripcion,
      'competenciaTipoId': instance.competenciaTipoId,
      'superCompetenciaId': instance.superCompetenciaId,
      'superCompetenciaNombre': instance.superCompetenciaNombre,
      'superCompetenciaDescripcion': instance.superCompetenciaDescripcion,
      'superCompetenciaTipoId': instance.superCompetenciaTipoId,
      'desempenioIcdId': instance.desempenioIcdId,
      'DesempenioDescripcion': instance.DesempenioDescripcion,
      'peso': instance.peso,
      'codigo': instance.codigo,
      'tipoId': instance.tipoId,
      'url': instance.url,
      'desempenioId': instance.desempenioId,
      'desempenioIcdDescripcion': instance.desempenioIcdDescripcion,
      'icdId': instance.icdId,
      'icdTitulo': instance.icdTitulo,
      'icdDescripcion': instance.icdDescripcion,
      'icdAlias': instance.icdAlias,
      'campoTematicoId': instance.campoTematicoId,
      'campoTematicoTitulo': instance.campoTematicoTitulo,
      'campoTematicoDescripcion': instance.campoTematicoDescripcion,
      'campoTematicoEstado': instance.campoTematicoEstado,
      'campoTematicoParentId': instance.campoTematicoParentId,
      'campoTematicoParentTitulo': instance.campoTematicoParentTitulo,
      'campoTematicoParentDescripcion': instance.campoTematicoParentDescripcion,
      'campoTematicoParentEstado': instance.campoTematicoParentEstado,
      'campoTematicoParentParentId': instance.campoTematicoParentParentId,
      'calendarioPeriodoId': instance.calendarioPeriodoId,
    };

TipoEvaluacionRubroSerial _$TipoEvaluacionRubroSerialFromJson(
    Map<String, dynamic> json) {
  return TipoEvaluacionRubroSerial(
    json['tipoEvaluacionId'] as int?,
    json['nombre'] as String?,
    json['estado'] as bool?,
  );
}

Map<String, dynamic> _$TipoEvaluacionRubroSerialToJson(
        TipoEvaluacionRubroSerial instance) =>
    <String, dynamic>{
      'tipoEvaluacionId': instance.tipoEvaluacionId,
      'nombre': instance.nombre,
      'estado': instance.estado,
    };

TipoNotaRubroSerial _$TipoNotaRubroSerialFromJson(Map<String, dynamic> json) {
  return TipoNotaRubroSerial(
    key: json['key'] as String?,
    tipoNotaId: json['tipoNotaId'] as String?,
    silaboEventoId: json['silaboEventoId'] as int?,
    nombre: json['nombre'] as String?,
    tipoId: json['tipoId'] as int?,
    tiponombre: json['tiponombre'] as String?,
    valorDefecto: json['valorDefecto'] as String?,
    longitudPaso: (json['longitudPaso'] as num?)?.toDouble(),
    intervalo: json['intervalo'] as bool?,
    estatico: json['estatico'] as bool?,
    entidadId: json['entidadId'] as int?,
    georeferenciaId: json['georeferenciaId'] as int?,
    organigramaId: json['organigramaId'] as int?,
    estadoId: json['estadoId'] as int?,
    tipoFuenteId: json['tipoFuenteId'] as int?,
    valorMinimo: json['valorMinimo'] as int?,
    valorMaximo: json['valorMaximo'] as int?,
    escalaEvaluacionId: json['escalaEvaluacionId'] as int?,
    escalanombre: json['escalanombre'] as String?,
    escalavalorMinimo: json['escalavalorMinimo'] as int?,
    escalavalorMaximo: json['escalavalorMaximo'] as int?,
    escalaestado: json['escalaestado'] as int?,
    escaladefecto: json['escaladefecto'] as bool?,
    escalaentidadId: json['escalaentidadId'] as int?,
    programaEducativoId: json['programaEducativoId'] as int?,
  );
}

Map<String, dynamic> _$TipoNotaRubroSerialToJson(
        TipoNotaRubroSerial instance) =>
    <String, dynamic>{
      'key': instance.key,
      'tipoNotaId': instance.tipoNotaId,
      'silaboEventoId': instance.silaboEventoId,
      'nombre': instance.nombre,
      'tipoId': instance.tipoId,
      'tiponombre': instance.tiponombre,
      'valorDefecto': instance.valorDefecto,
      'longitudPaso': instance.longitudPaso,
      'intervalo': instance.intervalo,
      'estatico': instance.estatico,
      'entidadId': instance.entidadId,
      'georeferenciaId': instance.georeferenciaId,
      'organigramaId': instance.organigramaId,
      'estadoId': instance.estadoId,
      'tipoFuenteId': instance.tipoFuenteId,
      'valorMinimo': instance.valorMinimo,
      'valorMaximo': instance.valorMaximo,
      'escalaEvaluacionId': instance.escalaEvaluacionId,
      'escalanombre': instance.escalanombre,
      'escalavalorMinimo': instance.escalavalorMinimo,
      'escalavalorMaximo': instance.escalavalorMaximo,
      'escalaestado': instance.escalaestado,
      'escaladefecto': instance.escaladefecto,
      'escalaentidadId': instance.escalaentidadId,
      'programaEducativoId': instance.programaEducativoId,
    };

ValorTipoNotaRubroSerial _$ValorTipoNotaRubroSerialFromJson(
    Map<String, dynamic> json) {
  return ValorTipoNotaRubroSerial(
    valorTipoNotaId: json['valorTipoNotaId'] as String?,
    tipoNotaId: json['tipoNotaId'] as String?,
    silaboEventoId: json['silaboEventoId'] as int?,
    titulo: json['titulo'] as String?,
    alias: json['alias'] as String?,
    limiteInferior: (json['limiteInferior'] as num?)?.toDouble(),
    limiteSuperior: (json['limiteSuperior'] as num?)?.toDouble(),
    valorNumerico: (json['valorNumerico'] as num?)?.toDouble(),
    icono: json['icono'] as String?,
    estadoId: json['estadoId'] as int?,
    incluidoLInferior: json['incluidoLInferior'] as bool?,
    incluidoLSuperior: json['incluidoLSuperior'] as bool?,
    tipoId: json['tipoId'] as int?,
    key: json['key'] as String?,
    usuarioCreacionId: json['usuarioCreacionId'] as int?,
    usuarioCreadorId: json['usuarioCreadorId'] as int?,
    fechaCreacion: json['fechaCreacion'] as int?,
    usuarioAccionId: json['usuarioAccionId'] as int?,
    fechaAccion: json['fechaAccion'] as int?,
    fechaEnvio: json['fechaEnvio'] as int?,
    fechaEntrega: json['fechaEntrega'] as int?,
    fechaRecibido: json['fechaRecibido'] as int?,
    fechaVisto: json['fechaVisto'] as int?,
    fechaRespuesta: json['fechaRespuesta'] as int?,
    getSTime: json['getSTime'] as String?,
  );
}

Map<String, dynamic> _$ValorTipoNotaRubroSerialToJson(
        ValorTipoNotaRubroSerial instance) =>
    <String, dynamic>{
      'key': instance.key,
      'valorTipoNotaId': instance.valorTipoNotaId,
      'silaboEventoId': instance.silaboEventoId,
      'tipoNotaId': instance.tipoNotaId,
      'titulo': instance.titulo,
      'alias': instance.alias,
      'limiteInferior': instance.limiteInferior,
      'limiteSuperior': instance.limiteSuperior,
      'valorNumerico': instance.valorNumerico,
      'icono': instance.icono,
      'estadoId': instance.estadoId,
      'incluidoLInferior': instance.incluidoLInferior,
      'incluidoLSuperior': instance.incluidoLSuperior,
      'tipoId': instance.tipoId,
      'usuarioCreacionId': instance.usuarioCreacionId,
      'usuarioCreadorId': instance.usuarioCreadorId,
      'fechaCreacion': instance.fechaCreacion,
      'usuarioAccionId': instance.usuarioAccionId,
      'fechaAccion': instance.fechaAccion,
      'fechaEnvio': instance.fechaEnvio,
      'fechaEntrega': instance.fechaEntrega,
      'fechaRecibido': instance.fechaRecibido,
      'fechaVisto': instance.fechaVisto,
      'fechaRespuesta': instance.fechaRespuesta,
      'getSTime': instance.getSTime,
    };

RubroEvaluacionProcesoSerial _$RubroEvaluacionProcesoSerialFromJson(
    Map<String, dynamic> json) {
  return RubroEvaluacionProcesoSerial(
    rubroEvalProcesoId: json['rubroEvalProcesoId'] as String?,
    titulo: json['titulo'] as String?,
    subtitulo: json['subtitulo'] as String?,
    colorFondo: json['colorFondo'] as String?,
    mColorFondo: json['mColorFondo'] as bool?,
    valorDefecto: json['valorDefecto'] as String?,
    competenciaId: json['competenciaId'] as int?,
    calendarioPeriodoId: json['calendarioPeriodoId'] as int?,
    anchoColumna: json['anchoColumna'] as String?,
    ocultarColumna: json['ocultarColumna'] as bool?,
    tipoFormulaId: json['tipoFormulaId'] as int?,
    silaboEventoId: json['silaboEventoId'] as int?,
    tipoRedondeoId: json['tipoRedondeoId'] as int?,
    valorRedondeoId: json['valorRedondeoId'] as int?,
    rubroEvalResultadoId: json['rubroEvalResultadoId'] as int?,
    tipoNotaId: json['tipoNotaId'] as String?,
    sesionAprendizajeId: json['sesionAprendizajeId'] as int?,
    desempenioIcdId: json['desempenioIcdId'] as int?,
    campoTematicoId: json['campoTematicoId'] as int?,
    tipoEvaluacionId: json['tipoEvaluacionId'] as int?,
    estadoId: json['estadoId'] as int?,
    tipoEscalaEvaluacionId: json['tipoEscalaEvaluacionId'] as int?,
    tipoColorRubroProceso: json['tipoColorRubroProceso'] as int?,
    tiporubroid: json['tiporubroid'] as int?,
    formaEvaluacionId: json['formaEvaluacionId'] as int?,
    countIndicador: json['countIndicador'] as int?,
    rubroFormal: json['rubroFormal'] as int?,
    msje: json['msje'] as int?,
    promedio: (json['promedio'] as num?)?.toDouble(),
    desviacionEstandar: (json['desviacionEstandar'] as num?)?.toDouble(),
    unidadAprendizajeId: json['unidadAprendizajeId'] as int?,
    estrategiaEvaluacionId: json['estrategiaEvaluacionId'] as int?,
    tareaId: json['tareaId'] as String?,
    resultadoTipoNotaId: json['resultadoTipoNotaId'] as String?,
    usuarioCreacionId: json['usuarioCreacionId'] as int?,
    fechaCreacion: json['fechaCreacion'] as int?,
    usuarioAccionId: json['usuarioAccionId'] as int?,
    fechaAccion: json['fechaAccion'] as int?,
    key: json['key'] as String?,
    instrumentoEvalId: json['instrumentoEvalId'] as String?,
    preguntaEvalId: json['preguntaEvalId'] as String?,
    error_guardar: json['error_guardar'] as int?,
  );
}

Map<String, dynamic> _$RubroEvaluacionProcesoSerialToJson(
        RubroEvaluacionProcesoSerial instance) =>
    <String, dynamic>{
      'rubroEvalProcesoId': instance.rubroEvalProcesoId,
      'titulo': instance.titulo,
      'subtitulo': instance.subtitulo,
      'colorFondo': instance.colorFondo,
      'mColorFondo': instance.mColorFondo,
      'valorDefecto': instance.valorDefecto,
      'competenciaId': instance.competenciaId,
      'calendarioPeriodoId': instance.calendarioPeriodoId,
      'anchoColumna': instance.anchoColumna,
      'ocultarColumna': instance.ocultarColumna,
      'tipoFormulaId': instance.tipoFormulaId,
      'silaboEventoId': instance.silaboEventoId,
      'tipoRedondeoId': instance.tipoRedondeoId,
      'valorRedondeoId': instance.valorRedondeoId,
      'rubroEvalResultadoId': instance.rubroEvalResultadoId,
      'tipoNotaId': instance.tipoNotaId,
      'sesionAprendizajeId': instance.sesionAprendizajeId,
      'desempenioIcdId': instance.desempenioIcdId,
      'campoTematicoId': instance.campoTematicoId,
      'tipoEvaluacionId': instance.tipoEvaluacionId,
      'estadoId': instance.estadoId,
      'tipoEscalaEvaluacionId': instance.tipoEscalaEvaluacionId,
      'tipoColorRubroProceso': instance.tipoColorRubroProceso,
      'tiporubroid': instance.tiporubroid,
      'formaEvaluacionId': instance.formaEvaluacionId,
      'countIndicador': instance.countIndicador,
      'rubroFormal': instance.rubroFormal,
      'msje': instance.msje,
      'promedio': instance.promedio,
      'desviacionEstandar': instance.desviacionEstandar,
      'unidadAprendizajeId': instance.unidadAprendizajeId,
      'estrategiaEvaluacionId': instance.estrategiaEvaluacionId,
      'tareaId': instance.tareaId,
      'resultadoTipoNotaId': instance.resultadoTipoNotaId,
      'usuarioCreacionId': instance.usuarioCreacionId,
      'fechaCreacion': instance.fechaCreacion,
      'usuarioAccionId': instance.usuarioAccionId,
      'fechaAccion': instance.fechaAccion,
      'key': instance.key,
      'instrumentoEvalId': instance.instrumentoEvalId,
      'preguntaEvalId': instance.preguntaEvalId,
      'error_guardar': instance.error_guardar,
    };

EvaluacionProcesoSerial _$EvaluacionProcesoSerialFromJson(
    Map<String, dynamic> json) {
  return EvaluacionProcesoSerial(
    evaluacionProcesoId: json['evaluacionProcesoId'] as String?,
    evaluacionResultadoId: json['evaluacionResultadoId'] as int?,
    nota: (json['nota'] as num?)?.toDouble(),
    escala: json['escala'] as String?,
    rubroEvalProcesoId: json['rubroEvalProcesoId'] as String?,
    sesionAprendizajeId: json['sesionAprendizajeId'] as int?,
    valorTipoNotaId: json['valorTipoNotaId'] as String?,
    equipoId: json['equipoId'] as String?,
    alumnoId: json['alumnoId'] as int?,
    calendarioPeriodoId: json['calendarioPeriodoId'] as int?,
    formulaSinc: json['formulaSinc'] as bool?,
    msje: json['msje'] as int?,
    publicado: json['publicado'] as int?,
    visto: json['visto'] as int?,
    nombres: json['nombres'] as String?,
    apellidoPaterno: json['apellidoPaterno'] as String?,
    apellidoMaterno: json['apellidoMaterno'] as String?,
    foto: json['foto'] as String?,
    usuarioCreacionId: json['usuarioCreacionId'] as int?,
    fechaCreacion: json['fechaCreacion'] as int?,
    usuarioAccionId: json['usuarioAccionId'] as int?,
    fechaAccion: json['fechaAccion'] as int?,
    key: json['key'] as String?,
    syncFlag: json['syncFlag'] as int?,
  );
}

Map<String, dynamic> _$EvaluacionProcesoSerialToJson(
        EvaluacionProcesoSerial instance) =>
    <String, dynamic>{
      'evaluacionProcesoId': instance.evaluacionProcesoId,
      'evaluacionResultadoId': instance.evaluacionResultadoId,
      'nota': instance.nota,
      'escala': instance.escala,
      'rubroEvalProcesoId': instance.rubroEvalProcesoId,
      'sesionAprendizajeId': instance.sesionAprendizajeId,
      'valorTipoNotaId': instance.valorTipoNotaId,
      'equipoId': instance.equipoId,
      'alumnoId': instance.alumnoId,
      'calendarioPeriodoId': instance.calendarioPeriodoId,
      'formulaSinc': instance.formulaSinc,
      'msje': instance.msje,
      'publicado': instance.publicado,
      'visto': instance.visto,
      'nombres': instance.nombres,
      'apellidoPaterno': instance.apellidoPaterno,
      'apellidoMaterno': instance.apellidoMaterno,
      'foto': instance.foto,
      'usuarioCreacionId': instance.usuarioCreacionId,
      'fechaCreacion': instance.fechaCreacion,
      'usuarioAccionId': instance.usuarioAccionId,
      'fechaAccion': instance.fechaAccion,
      'key': instance.key,
      'syncFlag': instance.syncFlag,
    };

RubroEvaluacionProcesoCampotematicoSerial
    _$RubroEvaluacionProcesoCampotematicoSerialFromJson(
        Map<String, dynamic> json) {
  return RubroEvaluacionProcesoCampotematicoSerial(
    rubroEvalProcesoId: json['rubroEvalProcesoId'] as String?,
    campoTematicoId: json['campoTematicoId'] as int?,
    usuarioCreacionId: json['usuarioCreacionId'] as int?,
    fechaCreacion: json['fechaCreacion'] as int?,
    usuarioAccionId: json['usuarioAccionId'] as int?,
    fechaAccion: json['fechaAccion'] as int?,
    key: json['key'] as String?,
  );
}

Map<String, dynamic> _$RubroEvaluacionProcesoCampotematicoSerialToJson(
        RubroEvaluacionProcesoCampotematicoSerial instance) =>
    <String, dynamic>{
      'rubroEvalProcesoId': instance.rubroEvalProcesoId,
      'campoTematicoId': instance.campoTematicoId,
      'usuarioCreacionId': instance.usuarioCreacionId,
      'fechaCreacion': instance.fechaCreacion,
      'usuarioAccionId': instance.usuarioAccionId,
      'fechaAccion': instance.fechaAccion,
      'key': instance.key,
    };

RubroEvaluacionProcesoComentarioSerial
    _$RubroEvaluacionProcesoComentarioSerialFromJson(
        Map<String, dynamic> json) {
  return RubroEvaluacionProcesoComentarioSerial(
    evaluacionProcesoComentarioId:
        json['evaluacionProcesoComentarioId'] as String?,
    evaluacionProcesoId: json['evaluacionProcesoId'] as String?,
    comentarioId: json['comentarioId'] as String?,
    descripcion: json['descripcion'] as String?,
    delete: json['delete'] as int?,
    usuarioCreacionId: json['usuarioCreacionId'] as int?,
    fechaCreacion: json['fechaCreacion'] as int?,
    usuarioAccionId: json['usuarioAccionId'] as int?,
    fechaAccion: json['fechaAccion'] as int?,
    key: json['key'] as String?,
  );
}

Map<String, dynamic> _$RubroEvaluacionProcesoComentarioSerialToJson(
        RubroEvaluacionProcesoComentarioSerial instance) =>
    <String, dynamic>{
      'evaluacionProcesoComentarioId': instance.evaluacionProcesoComentarioId,
      'evaluacionProcesoId': instance.evaluacionProcesoId,
      'comentarioId': instance.comentarioId,
      'descripcion': instance.descripcion,
      'delete': instance.delete,
      'usuarioCreacionId': instance.usuarioCreacionId,
      'fechaCreacion': instance.fechaCreacion,
      'usuarioAccionId': instance.usuarioAccionId,
      'fechaAccion': instance.fechaAccion,
      'key': instance.key,
    };

ArchivosRubroProcesoSerial _$ArchivosRubroProcesoSerialFromJson(
    Map<String, dynamic> json) {
  return ArchivosRubroProcesoSerial(
    archivoRubroId: json['archivoRubroId'] as String?,
    url: json['url'] as String?,
    tipoArchivoId: json['tipoArchivoId'] as int?,
    evaluacionProcesoId: json['evaluacionProcesoId'] as String?,
    localpath: json['localpath'] as String?,
    delete: json['delete'] as int?,
    usuarioCreacionId: json['usuarioCreacionId'] as int?,
    fechaCreacion: json['fechaCreacion'] as int?,
    usuarioAccionId: json['usuarioAccionId'] as int?,
    fechaAccion: json['fechaAccion'] as int?,
    key: json['key'] as String?,
  );
}

Map<String, dynamic> _$ArchivosRubroProcesoSerialToJson(
        ArchivosRubroProcesoSerial instance) =>
    <String, dynamic>{
      'archivoRubroId': instance.archivoRubroId,
      'url': instance.url,
      'tipoArchivoId': instance.tipoArchivoId,
      'evaluacionProcesoId': instance.evaluacionProcesoId,
      'localpath': instance.localpath,
      'delete': instance.delete,
      'usuarioCreacionId': instance.usuarioCreacionId,
      'fechaCreacion': instance.fechaCreacion,
      'usuarioAccionId': instance.usuarioAccionId,
      'fechaAccion': instance.fechaAccion,
      'key': instance.key,
    };

RubroEvalRNPFormulaSerial _$RubroEvalRNPFormulaSerialFromJson(
    Map<String, dynamic> json) {
  return RubroEvalRNPFormulaSerial(
    rubroFormulaId: json['rubroFormulaId'] as String?,
    rubroEvaluacionPrimId: json['rubroEvaluacionPrimId'] as String?,
    rubroEvaluacionSecId: json['rubroEvaluacionSecId'] as String?,
    peso: (json['peso'] as num?)?.toDouble(),
    usuarioCreacionId: json['usuarioCreacionId'] as int?,
    fechaCreacion: json['fechaCreacion'] as int?,
    usuarioAccionId: json['usuarioAccionId'] as int?,
    fechaAccion: json['fechaAccion'] as int?,
    key: json['key'] as String?,
  );
}

Map<String, dynamic> _$RubroEvalRNPFormulaSerialToJson(
        RubroEvalRNPFormulaSerial instance) =>
    <String, dynamic>{
      'rubroFormulaId': instance.rubroFormulaId,
      'rubroEvaluacionPrimId': instance.rubroEvaluacionPrimId,
      'rubroEvaluacionSecId': instance.rubroEvaluacionSecId,
      'peso': instance.peso,
      'usuarioCreacionId': instance.usuarioCreacionId,
      'fechaCreacion': instance.fechaCreacion,
      'usuarioAccionId': instance.usuarioAccionId,
      'fechaAccion': instance.fechaAccion,
      'key': instance.key,
    };

CriterioRubroEvaluacionSerial _$CriterioRubroEvaluacionSerialFromJson(
    Map<String, dynamic> json) {
  return CriterioRubroEvaluacionSerial(
    json['criteriosEvaluacionId'] as String?,
    json['rubroEvalProcesoId'] as String?,
    json['valorTipoNotaId'] as String?,
    json['descripcion'] as String?,
    json['usuarioCreacionId'] as int?,
    json['fechaCreacion'] as int?,
    json['usuarioAccionId'] as int?,
    json['fechaAccion'] as int?,
    json['key'] as String?,
  );
}

Map<String, dynamic> _$CriterioRubroEvaluacionSerialToJson(
        CriterioRubroEvaluacionSerial instance) =>
    <String, dynamic>{
      'criteriosEvaluacionId': instance.criteriosEvaluacionId,
      'rubroEvalProcesoId': instance.rubroEvalProcesoId,
      'valorTipoNotaId': instance.valorTipoNotaId,
      'descripcion': instance.descripcion,
      'usuarioCreacionId': instance.usuarioCreacionId,
      'fechaCreacion': instance.fechaCreacion,
      'usuarioAccionId': instance.usuarioAccionId,
      'fechaAccion': instance.fechaAccion,
      'key': instance.key,
    };

EquipoEvaluacionProcesoSerial _$EquipoEvaluacionProcesoSerialFromJson(
    Map<String, dynamic> json) {
  return EquipoEvaluacionProcesoSerial(
    json['equipoEvaluacionProcesoId'] as String?,
    json['rubroEvalProcesoId'] as String?,
    json['sesionAprendizajeId'] as int?,
    json['equipoId'] as String?,
    (json['nota'] as num?)?.toDouble(),
    json['escala'] as String?,
    json['valorTipoNotaId'] as String?,
    json['usuarioCreacionId'] as int?,
    json['fechaCreacion'] as int?,
    json['usuarioAccionId'] as int?,
    json['fechaAccion'] as int?,
    json['key'] as String?,
  );
}

Map<String, dynamic> _$EquipoEvaluacionProcesoSerialToJson(
        EquipoEvaluacionProcesoSerial instance) =>
    <String, dynamic>{
      'equipoEvaluacionProcesoId': instance.equipoEvaluacionProcesoId,
      'rubroEvalProcesoId': instance.rubroEvalProcesoId,
      'sesionAprendizajeId': instance.sesionAprendizajeId,
      'equipoId': instance.equipoId,
      'nota': instance.nota,
      'escala': instance.escala,
      'valorTipoNotaId': instance.valorTipoNotaId,
      'usuarioCreacionId': instance.usuarioCreacionId,
      'fechaCreacion': instance.fechaCreacion,
      'usuarioAccionId': instance.usuarioAccionId,
      'fechaAccion': instance.fechaAccion,
      'key': instance.key,
    };

RubroEvaluacionProcesoIntegranteSerial
    _$RubroEvaluacionProcesoIntegranteSerialFromJson(
        Map<String, dynamic> json) {
  return RubroEvaluacionProcesoIntegranteSerial(
    json['rubroEvaluacionEquipoId'] as String?,
    json['personaId'] as int?,
  );
}

Map<String, dynamic> _$RubroEvaluacionProcesoIntegranteSerialToJson(
        RubroEvaluacionProcesoIntegranteSerial instance) =>
    <String, dynamic>{
      'rubroEvaluacionEquipoId': instance.rubroEvaluacionEquipoId,
      'personaId': instance.personaId,
    };

RubroEvaluacionProcesoEquipoSerial _$RubroEvaluacionProcesoEquipoSerialFromJson(
    Map<String, dynamic> json) {
  return RubroEvaluacionProcesoEquipoSerial(
    json['rubroEvaluacionEquipoId'] as String?,
    json['equipoId'] as String?,
    json['nombreEquipo'] as String?,
    json['rubroEvalProcesoId'] as String?,
    json['usuarioCreacionId'] as int?,
    json['fechaCreacion'] as int?,
    json['usuarioAccionId'] as int?,
    json['fechaAccion'] as int?,
    json['key'] as String?,
  );
}

Map<String, dynamic> _$RubroEvaluacionProcesoEquipoSerialToJson(
        RubroEvaluacionProcesoEquipoSerial instance) =>
    <String, dynamic>{
      'rubroEvaluacionEquipoId': instance.rubroEvaluacionEquipoId,
      'equipoId': instance.equipoId,
      'nombreEquipo': instance.nombreEquipo,
      'rubroEvalProcesoId': instance.rubroEvalProcesoId,
      'usuarioCreacionId': instance.usuarioCreacionId,
      'fechaCreacion': instance.fechaCreacion,
      'usuarioAccionId': instance.usuarioAccionId,
      'fechaAccion': instance.fechaAccion,
      'key': instance.key,
    };

ContactoDocenteSerial _$ContactoDocenteSerialFromJson(
    Map<String, dynamic> json) {
  return ContactoDocenteSerial(
    json['personaId'] as int?,
    json['nombres'] as String?,
    json['apellidoPaterno'] as String?,
    json['apellidoMaterno'] as String?,
    json['ocupacion'] as String?,
    json['estadoId'] as int?,
    json['telefono'] as String?,
    json['celular'] as String?,
    json['fechaNac'] as String?,
    json['correo'] as String?,
    json['genero'] as String?,
    json['estadoCivil'] as String?,
    json['numDoc'] as String?,
    json['foto'] as String?,
    json['nombreTipo'] as String?,
    json['tipo'] as int?,
    json['hijoRelacionId'] as int?,
    json['relacion'] as String?,
    json['cargaCursoId'] as int?,
    json['cursoId'] as int?,
    json['cursoNombre'] as String?,
    json['periodoId'] as int?,
    json['periodoNombre'] as String?,
    json['grupoId'] as int?,
    json['grupoNombre'] as String?,
    json['aulaId'] as int?,
    json['aulaNombre'] as String?,
    json['contratoEstadoId'] as int?,
    json['contratoVigente'] as bool?,
    json['relacionId'] as int?,
  );
}

Map<String, dynamic> _$ContactoDocenteSerialToJson(
        ContactoDocenteSerial instance) =>
    <String, dynamic>{
      'personaId': instance.personaId,
      'nombres': instance.nombres,
      'apellidoPaterno': instance.apellidoPaterno,
      'apellidoMaterno': instance.apellidoMaterno,
      'ocupacion': instance.ocupacion,
      'estadoId': instance.estadoId,
      'telefono': instance.telefono,
      'celular': instance.celular,
      'fechaNac': instance.fechaNac,
      'correo': instance.correo,
      'genero': instance.genero,
      'estadoCivil': instance.estadoCivil,
      'numDoc': instance.numDoc,
      'foto': instance.foto,
      'nombreTipo': instance.nombreTipo,
      'tipo': instance.tipo,
      'hijoRelacionId': instance.hijoRelacionId,
      'relacion': instance.relacion,
      'cargaCursoId': instance.cargaCursoId,
      'cursoId': instance.cursoId,
      'cursoNombre': instance.cursoNombre,
      'periodoId': instance.periodoId,
      'periodoNombre': instance.periodoNombre,
      'grupoId': instance.grupoId,
      'grupoNombre': instance.grupoNombre,
      'aulaId': instance.aulaId,
      'aulaNombre': instance.aulaNombre,
      'contratoEstadoId': instance.contratoEstadoId,
      'contratoVigente': instance.contratoVigente,
      'relacionId': instance.relacionId,
    };

CalendarioSerial _$CalendarioSerialFromJson(Map<String, dynamic> json) {
  return CalendarioSerial(
    calendarioId: json['calendarioId'] as String?,
    nombre: json['nombre'] as String?,
    descripcion: json['descripcion'] as String?,
    estado: json['estado'] as int?,
    entidadId: json['entidadId'] as int?,
    georeferenciaId: json['georeferenciaId'] as int?,
    nUsuario: json['nUsuario'] as String?,
    cargo: json['cargo'] as String?,
    usuarioId: json['usuarioId'] as int?,
    cargaAcademicaId: json['cargaAcademicaId'] as int?,
    cargaCursoId: json['cargaCursoId'] as int?,
    estadoPublicaciN: json['estadoPublicaciN'] as int?,
    estadoPublicacion: json['estadoPublicacion'] as int?,
    rolId: json['rolId'] as int?,
    key: json['key'] as String?,
    usuarioCreacionId: json['usuarioCreacionId'] as int?,
    usuarioCreadorId: json['usuarioCreadorId'] as int?,
    fechaCreacion: json['fechaCreacion'] as int?,
    usuarioAccionId: json['usuarioAccionId'] as int?,
    fechaAccion: json['fechaAccion'] as int?,
    fechaEnvio: json['fechaEnvio'] as int?,
    fechaEntrega: json['fechaEntrega'] as int?,
    fechaRecibido: json['fechaRecibido'] as int?,
    fechaVisto: json['fechaVisto'] as int?,
    fechaRespuesta: json['fechaRespuesta'] as int?,
    getSTime: json['getSTime'] as String?,
  );
}

Map<String, dynamic> _$CalendarioSerialToJson(CalendarioSerial instance) =>
    <String, dynamic>{
      'calendarioId': instance.calendarioId,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'estado': instance.estado,
      'entidadId': instance.entidadId,
      'georeferenciaId': instance.georeferenciaId,
      'nUsuario': instance.nUsuario,
      'cargo': instance.cargo,
      'usuarioId': instance.usuarioId,
      'cargaAcademicaId': instance.cargaAcademicaId,
      'cargaCursoId': instance.cargaCursoId,
      'estadoPublicaciN': instance.estadoPublicaciN,
      'estadoPublicacion': instance.estadoPublicacion,
      'rolId': instance.rolId,
      'key': instance.key,
      'usuarioCreacionId': instance.usuarioCreacionId,
      'usuarioCreadorId': instance.usuarioCreadorId,
      'fechaCreacion': instance.fechaCreacion,
      'usuarioAccionId': instance.usuarioAccionId,
      'fechaAccion': instance.fechaAccion,
      'fechaEnvio': instance.fechaEnvio,
      'fechaEntrega': instance.fechaEntrega,
      'fechaRecibido': instance.fechaRecibido,
      'fechaVisto': instance.fechaVisto,
      'fechaRespuesta': instance.fechaRespuesta,
      'getSTime': instance.getSTime,
    };

CalendarioListaUsuarioSerial _$CalendarioListaUsuarioSerialFromJson(
    Map<String, dynamic> json) {
  return CalendarioListaUsuarioSerial(
    json['calendarioId'] as String?,
    json['listaUsuarioId'] as int?,
  );
}

Map<String, dynamic> _$CalendarioListaUsuarioSerialToJson(
        CalendarioListaUsuarioSerial instance) =>
    <String, dynamic>{
      'calendarioId': instance.calendarioId,
      'listaUsuarioId': instance.listaUsuarioId,
    };

ListaUsuariosSerial _$ListaUsuariosSerialFromJson(Map<String, dynamic> json) {
  return ListaUsuariosSerial(
    listaUsuarioId: json['listaUsuarioId'] as int?,
    nombre: json['nombre'] as String?,
    descripcion: json['descripcion'] as String?,
    entidadId: json['entidadId'] as int?,
    georeferenciaId: json['georeferenciaId'] as int?,
    organigramaId: json['organigramaId'] as int?,
    estado: json['estado'] as bool?,
    usuarioCreacionId: json['usuarioCreacionId'] as int?,
    usuarioCreadorId: json['usuarioCreadorId'] as int?,
    fechaCreacion: json['fechaCreacion'] as int?,
    usuarioAccionId: json['usuarioAccionId'] as int?,
    fechaAccion: json['fechaAccion'] as int?,
    fechaEnvio: json['fechaEnvio'] as int?,
    fechaEntrega: json['fechaEntrega'] as int?,
    fechaRecibido: json['fechaRecibido'] as int?,
    fechaVisto: json['fechaVisto'] as int?,
    fechaRespuesta: json['fechaRespuesta'] as int?,
    getSTime: json['getSTime'] as String?,
  );
}

Map<String, dynamic> _$ListaUsuariosSerialToJson(
        ListaUsuariosSerial instance) =>
    <String, dynamic>{
      'listaUsuarioId': instance.listaUsuarioId,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'entidadId': instance.entidadId,
      'georeferenciaId': instance.georeferenciaId,
      'organigramaId': instance.organigramaId,
      'estado': instance.estado,
      'usuarioCreacionId': instance.usuarioCreacionId,
      'usuarioCreadorId': instance.usuarioCreadorId,
      'fechaCreacion': instance.fechaCreacion,
      'usuarioAccionId': instance.usuarioAccionId,
      'fechaAccion': instance.fechaAccion,
      'fechaEnvio': instance.fechaEnvio,
      'fechaEntrega': instance.fechaEntrega,
      'fechaRecibido': instance.fechaRecibido,
      'fechaVisto': instance.fechaVisto,
      'fechaRespuesta': instance.fechaRespuesta,
      'getSTime': instance.getSTime,
    };

EventoSerial _$EventoSerialFromJson(Map<String, dynamic> json) {
  return EventoSerial(
    json['eventoId'] as String?,
    json['titulo'] as String?,
    json['descripcion'] as String?,
    json['calendarioId'] as String?,
    json['tipoEventoId'] as int?,
    json['estadoId'] as int?,
    json['estadoPublicacion'] as bool?,
    json['entidadId'] as int?,
    json['georeferenciaId'] as int?,
    json['fechaEvento'] as int?,
    json['horaEvento'] as String?,
    json['envioPersonalizado'] as bool?,
    json['getSTime'] as String?,
    json['syncFlag'] as int?,
    json['usuarioReceptorId'] as int?,
    json['eventoHijoId'] as int?,
    json['key'] as String?,
    json['usuarioCreacionId'] as int?,
    json['usuarioCreadorId'] as int?,
    json['fechaCreacion'] as int?,
    json['usuarioAccionId'] as int?,
    json['fechaAccion'] as int?,
    json['fechaEnvio'] as int?,
    json['fechaEntrega'] as int?,
    json['fechaRecibido'] as int?,
    json['fechaVisto'] as int?,
    json['fechaRespuesta'] as int?,
    json['pathImagen'] as String?,
    json['nombreEntidad'] as String?,
    json['fotoEntidad'] as String?,
  );
}

Map<String, dynamic> _$EventoSerialToJson(EventoSerial instance) =>
    <String, dynamic>{
      'eventoId': instance.eventoId,
      'titulo': instance.titulo,
      'descripcion': instance.descripcion,
      'calendarioId': instance.calendarioId,
      'tipoEventoId': instance.tipoEventoId,
      'estadoId': instance.estadoId,
      'estadoPublicacion': instance.estadoPublicacion,
      'entidadId': instance.entidadId,
      'georeferenciaId': instance.georeferenciaId,
      'fechaEvento': instance.fechaEvento,
      'horaEvento': instance.horaEvento,
      'envioPersonalizado': instance.envioPersonalizado,
      'getSTime': instance.getSTime,
      'syncFlag': instance.syncFlag,
      'usuarioReceptorId': instance.usuarioReceptorId,
      'eventoHijoId': instance.eventoHijoId,
      'key': instance.key,
      'usuarioCreacionId': instance.usuarioCreacionId,
      'usuarioCreadorId': instance.usuarioCreadorId,
      'fechaCreacion': instance.fechaCreacion,
      'usuarioAccionId': instance.usuarioAccionId,
      'fechaAccion': instance.fechaAccion,
      'fechaEnvio': instance.fechaEnvio,
      'fechaEntrega': instance.fechaEntrega,
      'fechaRecibido': instance.fechaRecibido,
      'fechaVisto': instance.fechaVisto,
      'fechaRespuesta': instance.fechaRespuesta,
      'pathImagen': instance.pathImagen,
      'nombreEntidad': instance.nombreEntidad,
      'fotoEntidad': instance.fotoEntidad,
    };

TiposEventoSerial _$TiposEventoSerialFromJson(Map<String, dynamic> json) {
  return TiposEventoSerial(
    tipoId: json['tipoId'] as int?,
    objeto: json['objeto'] as String?,
    concepto: json['concepto'] as String?,
    nombre: json['nombre'] as String?,
    codigo: json['codigo'] as String?,
    estado: json['estado'] as int?,
    parentId: json['parentId'] as int?,
  );
}

Map<String, dynamic> _$TiposEventoSerialToJson(TiposEventoSerial instance) =>
    <String, dynamic>{
      'tipoId': instance.tipoId,
      'objeto': instance.objeto,
      'concepto': instance.concepto,
      'nombre': instance.nombre,
      'codigo': instance.codigo,
      'estado': instance.estado,
      'parentId': instance.parentId,
    };

ListUsuarioDetalleSerial _$ListUsuarioDetalleSerialFromJson(
    Map<String, dynamic> json) {
  return ListUsuarioDetalleSerial(
    json['listaUsuarioId'] as int?,
    json['usuarioId'] as int?,
  );
}

Map<String, dynamic> _$ListUsuarioDetalleSerialToJson(
        ListUsuarioDetalleSerial instance) =>
    <String, dynamic>{
      'listaUsuarioId': instance.listaUsuarioId,
      'usuarioId': instance.usuarioId,
    };

UsuarioEventoSerial _$UsuarioEventoSerialFromJson(Map<String, dynamic> json) {
  return UsuarioEventoSerial(
    json['habilitarAcceso'] as bool?,
    json['usuarioId'] as int?,
    json['personaId'] as int?,
    json['estado'] as bool?,
    json['entidadId'] as int?,
    json['georeferenciaId'] as int?,
    json['organigramaId'] as int?,
  );
}

Map<String, dynamic> _$UsuarioEventoSerialToJson(
        UsuarioEventoSerial instance) =>
    <String, dynamic>{
      'habilitarAcceso': instance.habilitarAcceso,
      'usuarioId': instance.usuarioId,
      'personaId': instance.personaId,
      'estado': instance.estado,
      'entidadId': instance.entidadId,
      'georeferenciaId': instance.georeferenciaId,
      'organigramaId': instance.organigramaId,
    };

PersonaEventoSerial _$PersonaEventoSerialFromJson(Map<String, dynamic> json) {
  return PersonaEventoSerial(
    json['personaId'] as int?,
    json['nombres'] as String?,
    json['apellidoPaterno'] as String?,
    json['apellidoMaterno'] as String?,
    json['celular'] as String?,
    json['telefono'] as String?,
    json['foto'] as String?,
    json['fechaNac'] as String?,
    json['genero'] as String?,
    json['estadoCivil'] as String?,
    json['numDoc'] as String?,
    json['ocupacion'] as String?,
    json['estadoId'] as int?,
    json['correo'] as String?,
    json['empleadoId'] as int?,
  );
}

Map<String, dynamic> _$PersonaEventoSerialToJson(
        PersonaEventoSerial instance) =>
    <String, dynamic>{
      'personaId': instance.personaId,
      'nombres': instance.nombres,
      'apellidoPaterno': instance.apellidoPaterno,
      'apellidoMaterno': instance.apellidoMaterno,
      'celular': instance.celular,
      'telefono': instance.telefono,
      'foto': instance.foto,
      'fechaNac': instance.fechaNac,
      'genero': instance.genero,
      'estadoCivil': instance.estadoCivil,
      'numDoc': instance.numDoc,
      'ocupacion': instance.ocupacion,
      'estadoId': instance.estadoId,
      'correo': instance.correo,
      'empleadoId': instance.empleadoId,
    };

EventoPersonaSerial _$EventoPersonaSerialFromJson(Map<String, dynamic> json) {
  return EventoPersonaSerial(
    json['eventoPersonaId'] as String?,
    json['eventoId'] as String?,
    json['personaId'] as int?,
    json['estado'] as bool?,
    json['rolId'] as int?,
    json['apoderadoId'] as int?,
    json['key'] as String?,
    json['usuarioCreacionId'] as int?,
    json['usuarioCreadorId'] as int?,
    json['fechaCreacion'] as int?,
    json['usuarioAccionId'] as int?,
    json['fechaAccion'] as int?,
    json['fechaEnvio'] as int?,
    json['fechaEntrega'] as int?,
    json['fechaRecibido'] as int?,
    json['fechaVisto'] as int?,
    json['fechaRespuesta'] as int?,
    json['getSTime'] as String?,
  );
}

Map<String, dynamic> _$EventoPersonaSerialToJson(
        EventoPersonaSerial instance) =>
    <String, dynamic>{
      'eventoPersonaId': instance.eventoPersonaId,
      'eventoId': instance.eventoId,
      'personaId': instance.personaId,
      'estado': instance.estado,
      'rolId': instance.rolId,
      'apoderadoId': instance.apoderadoId,
      'key': instance.key,
      'usuarioCreacionId': instance.usuarioCreacionId,
      'usuarioCreadorId': instance.usuarioCreadorId,
      'fechaCreacion': instance.fechaCreacion,
      'usuarioAccionId': instance.usuarioAccionId,
      'fechaAccion': instance.fechaAccion,
      'fechaEnvio': instance.fechaEnvio,
      'fechaEntrega': instance.fechaEntrega,
      'fechaRecibido': instance.fechaRecibido,
      'fechaVisto': instance.fechaVisto,
      'fechaRespuesta': instance.fechaRespuesta,
      'getSTime': instance.getSTime,
    };

RelacionesEventoSerial _$RelacionesEventoSerialFromJson(
    Map<String, dynamic> json) {
  return RelacionesEventoSerial(
    idRelacion: json['idRelacion'] as int?,
    personaPrincipalId: json['personaPrincipalId'] as int?,
    personaVinculadaId: json['personaVinculadaId'] as int?,
    tipoId: json['tipoId'] as int?,
    activo: json['activo'] as bool?,
  );
}

Map<String, dynamic> _$RelacionesEventoSerialToJson(
        RelacionesEventoSerial instance) =>
    <String, dynamic>{
      'idRelacion': instance.idRelacion,
      'personaPrincipalId': instance.personaPrincipalId,
      'personaVinculadaId': instance.personaVinculadaId,
      'tipoId': instance.tipoId,
      'activo': instance.activo,
    };

UnidadEventoSerial _$UnidadEventoSerialFromJson(Map<String, dynamic> json) {
  return UnidadEventoSerial(
    unidadAprendizajeId: json['unidadAprendizajeId'] as int?,
    nroUnidad: json['nroUnidad'] as int?,
    titulo: json['titulo'] as String?,
    situacionSignificativa: json['situacionSignificativa'] as String?,
    nroSemanas: json['nroSemanas'] as int?,
    nroHoras: json['nroHoras'] as int?,
    nroSesiones: json['nroSesiones'] as int?,
    estadoId: json['estadoId'] as int?,
    silaboEventoId: json['silaboEventoId'] as int?,
    situacionSignificativaComplementaria:
        json['situacionSignificativaComplementaria'] as String?,
    desafio: json['desafio'] as String?,
    reto: json['reto'] as String?,
  );
}

Map<String, dynamic> _$UnidadEventoSerialToJson(UnidadEventoSerial instance) =>
    <String, dynamic>{
      'unidadAprendizajeId': instance.unidadAprendizajeId,
      'nroUnidad': instance.nroUnidad,
      'titulo': instance.titulo,
      'situacionSignificativa': instance.situacionSignificativa,
      'nroSemanas': instance.nroSemanas,
      'nroHoras': instance.nroHoras,
      'nroSesiones': instance.nroSesiones,
      'estadoId': instance.estadoId,
      'silaboEventoId': instance.silaboEventoId,
      'situacionSignificativaComplementaria':
          instance.situacionSignificativaComplementaria,
      'desafio': instance.desafio,
      'reto': instance.reto,
    };

SesionEventoSerial _$SesionEventoSerialFromJson(Map<String, dynamic> json) {
  return SesionEventoSerial(
    sesionAprendizajeId: json['sesionAprendizajeId'] as int?,
    unidadAprendizajeId: json['unidadAprendizajeId'] as int?,
    titulo: json['titulo'] as String?,
    proposito: json['proposito'] as String?,
    horas: json['horas'] as int?,
    contenido: json['contenido'] as String?,
    usuarioCreacionId: json['usuarioCreacionId'] as int?,
    fechaCreacion: json['fechaCreacion'] as int?,
    usuarioAccionId: json['usuarioAccionId'] as int?,
    fechaAccion: json['fechaAccion'] as int?,
    estadoId: json['estadoId'] as int?,
    fechaEjecucion: json['fechaEjecucion'] as int?,
    fechaReprogramacion: json['fechaReprogramacion'] as String?,
    fechaPublicacion: json['fechaPublicacion'] as String?,
    nroSesion: json['nroSesion'] as int?,
    rolId: json['rolId'] as int?,
    estadoEjecucionId: json['estadoEjecucionId'] as int?,
    fechaRealizada: json['fechaRealizada'] as int?,
    fechaEjecucionFin: json['fechaEjecucionFin'] as int?,
    estadoEvaluacion: json['estadoEvaluacion'] as bool?,
    evaluados: json['evaluados'] as int?,
    docenteid: json['docenteid'] as int?,
    parentSesionId: json['parentSesionId'] as int?,
  );
}

Map<String, dynamic> _$SesionEventoSerialToJson(SesionEventoSerial instance) =>
    <String, dynamic>{
      'sesionAprendizajeId': instance.sesionAprendizajeId,
      'unidadAprendizajeId': instance.unidadAprendizajeId,
      'titulo': instance.titulo,
      'proposito': instance.proposito,
      'horas': instance.horas,
      'contenido': instance.contenido,
      'usuarioCreacionId': instance.usuarioCreacionId,
      'fechaCreacion': instance.fechaCreacion,
      'usuarioAccionId': instance.usuarioAccionId,
      'fechaAccion': instance.fechaAccion,
      'estadoId': instance.estadoId,
      'fechaEjecucion': instance.fechaEjecucion,
      'fechaReprogramacion': instance.fechaReprogramacion,
      'fechaPublicacion': instance.fechaPublicacion,
      'nroSesion': instance.nroSesion,
      'rolId': instance.rolId,
      'estadoEjecucionId': instance.estadoEjecucionId,
      'fechaRealizada': instance.fechaRealizada,
      'fechaEjecucionFin': instance.fechaEjecucionFin,
      'estadoEvaluacion': instance.estadoEvaluacion,
      'evaluados': instance.evaluados,
      'docenteid': instance.docenteid,
      'parentSesionId': instance.parentSesionId,
    };

RelUnidadEventoSerial _$RelUnidadEventoSerialFromJson(
    Map<String, dynamic> json) {
  return RelUnidadEventoSerial(
    unidadaprendizajeId: json['unidadaprendizajeId'] as int?,
    tipoid: json['tipoid'] as int?,
  );
}

Map<String, dynamic> _$RelUnidadEventoSerialToJson(
        RelUnidadEventoSerial instance) =>
    <String, dynamic>{
      'unidadaprendizajeId': instance.unidadaprendizajeId,
      'tipoid': instance.tipoid,
    };
