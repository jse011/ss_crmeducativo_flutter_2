import 'package:json_annotation/json_annotation.dart';

part 'rest_api_response.g.dart';
/*
Mac OS important
export PATH="$PATH:/Users/edwinrubenpuente/SDKFlutter/flutter/bin"
export PATH="$PATH:/Users/jose/flutter/bin"

* One-time code generation
By running flutter pub run build_runner build in the project root, you generate JSON serialization code for your models whenever they are needed. This triggers a one-time build that goes through the source files, picks the relevant ones, and generates the necessary serialization code for them.

While this is convenient, it would be nice if you did not have to run the build manually every time you make changes in your model classes.

Generating code continuously
A watcher makes our source code generation process more convenient. It watches changes in our project files and automatically builds the necessary files when needed. Start the watcher by running flutter pub run build_runner watch in the project root.

It is safe to start the watcher once and leave it running in the background.
* */
@JsonSerializable()
class AdminServiceSerializable {
  int? UsuarioId;
  bool? Estado;
  int? EntidadId;
  int? UsuarioExternoId;
  int? UsuarioCreadorId;
  int? UsuarioAccionId;
  int? Opcion;
  int? Cantidad;
  String? UrlServiceMovil;

  AdminServiceSerializable(
      {this.UsuarioId,
        this.Estado,
        this.EntidadId,
        this.UsuarioExternoId,
        this.UsuarioCreadorId,
        this.UsuarioAccionId,
        this.Opcion,
        this.Cantidad,
        this.UrlServiceMovil});

  factory AdminServiceSerializable.fromJson(Map<String, dynamic> json) => _$AdminServiceSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$AdminServiceSerializableToJson(this);
}
@JsonSerializable()
class EntidadSerializable {

  int? entidadId;
  int? tipoId;
  int? parentId;
  String? nombre;
  String? ruc;
  String? site;
  String? telefono;
  String? correo;
  String? foto;
  int? estadoId;

  EntidadSerializable(
      {this.entidadId,
        this.tipoId,
        this.parentId,
        this.nombre,
        this.ruc,
        this.site,
        this.telefono,
        this.correo,
        this.foto,
        this.estadoId});

  factory EntidadSerializable.fromJson(Map<String, dynamic> json) => _$EntidadSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$EntidadSerializableToJson(this);
}

@JsonSerializable()
class GeoreferenciaSerializable {

  int? georeferenciaId ;
  String? nombre ;
  int? entidadId ;
  String? alias;
  int? estadoId;

  GeoreferenciaSerializable({this.georeferenciaId, this.nombre, this.entidadId, this.alias,
    this.estadoId});

  factory GeoreferenciaSerializable.fromJson(Map<String, dynamic> json) => _$GeoreferenciaSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$GeoreferenciaSerializableToJson(this);
}

@JsonSerializable()
class RolSerializable{
  int? rolId;
  String? nombre;
  int? parentId;
  bool? estado;

  RolSerializable({this.rolId, this.nombre, this.parentId, this.estado});


  factory RolSerializable.fromJson(Map<String, dynamic> json) => _$RolSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$RolSerializableToJson(this);
}

@JsonSerializable()
class UsuarioRolGeoreferenciaSerializable{
  int? usuarioRolGeoreferenciaId;
  int? usuarioId;
  int? rolId;
  int? geoReferenciaId;
  int? entidadId;


  UsuarioRolGeoreferenciaSerializable({this.usuarioRolGeoreferenciaId,
    this.usuarioId, this.rolId, this.geoReferenciaId, this.entidadId});

  factory UsuarioRolGeoreferenciaSerializable.fromJson(Map<String, dynamic> json) => _$UsuarioRolGeoreferenciaSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioRolGeoreferenciaSerializableToJson(this);
}

@JsonSerializable()
class PersonaSerial{
  int? personaId;
  String? nombres;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? celular;
  String? telefono;
  String? foto;
  String? fechaNac;
  String? genero;
  String? estadoCivil;
  String? numDoc;
  String? ocupacion;
  int? estadoId;
  String? correo;
  String? direccion;
  String? path;
  String? image64; //Solo sirve para guardar un imagen

  PersonaSerial(
      {this.personaId,
        this.nombres,
        this.apellidoPaterno,
        this.apellidoMaterno,
        this.celular,
        this.telefono,
        this.foto,
        this.fechaNac,
        this.genero,
        this.estadoCivil,
        this.numDoc,
        this.ocupacion,
        this.estadoId = 0,
        this.correo,
        this.direccion,
        this.path,
        this.image64});

  factory PersonaSerial.fromJson(Map<String, dynamic> json) => _$PersonaSerialFromJson(json);

  Map<String, dynamic> toJson() => _$PersonaSerialToJson(this);
}
@JsonSerializable()
class EmpleadoSerial{
    int? empleadoId;
    int? personaId;
    String? linkURL;
    bool? estado;
    int? tipoId;
    String? web;


    EmpleadoSerial({this.empleadoId, this.personaId, this.linkURL, this.estado,
      this.tipoId, this.web});

    factory EmpleadoSerial.fromJson(Map<String, dynamic> json) => _$EmpleadoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$EmpleadoSerialToJson(this);
}
@JsonSerializable()
class AnioAcademicoSerial{
  int? idAnioAcademico;
  String? nombre;
  String? fechaInicio;
  String? fechaFin;
  String? denominacion;
  int? georeferenciaId;
  int? organigramaId;
  int? estadoId;
  int? tipoId;

  AnioAcademicoSerial(
  {this.idAnioAcademico,
      this.nombre,
      this.fechaInicio,
      this.fechaFin,
      this.denominacion,
      this.georeferenciaId,
      this.organigramaId,
      this.estadoId,
       this.tipoId});

  factory AnioAcademicoSerial.fromJson(Map<String, dynamic> json) => _$AnioAcademicoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$AnioAcademicoSerialToJson(this);
}
@JsonSerializable()
class ParametroConfiguracionSerial{

  int? id;
  String? concepto;
  String? parametro;
  int? entidadId;
  int? orden;


  ParametroConfiguracionSerial(
      this.id, this.concepto, this.parametro, this.entidadId, this.orden);

  factory ParametroConfiguracionSerial.fromJson(Map<String, dynamic> json) => _$ParametroConfiguracionSerialFromJson(json);

  Map<String, dynamic> toJson() => _$ParametroConfiguracionSerialToJson(this);
}
@JsonSerializable()
class AulaSerial
{
  int? aulaId;
  String? descripcion;
  String? numero;
  String? capacidad;
  int? estado;

  AulaSerial(
      {this.aulaId,
      this.descripcion,
      this.numero,
      this.capacidad,
      this.estado});
  factory AulaSerial.fromJson(Map<String, dynamic> json) => _$AulaSerialFromJson(json);

  Map<String, dynamic> toJson() => _$AulaSerialToJson(this);
}
@JsonSerializable()
class CargaAcademicaSerial
{
  int? cargaAcademicaId;
  int? seccionId;
  int? periodoId;
  int? aulaId;
  int? idPlanEstudio;
  int? idPlanEstudioVersion;
  int? idAnioAcademico;
  int? idEmpleadoTutor;
  int? estadoId;
  int? idPeriodoAcad;
  int? idGrupo;
  int? capacidadVacante;
  int? capacidadVacanteD;

  CargaAcademicaSerial(
      {this.cargaAcademicaId,
      this.seccionId,
      this.periodoId,
      this.aulaId,
      this.idPlanEstudio,
      this.idPlanEstudioVersion,
      this.idAnioAcademico,
      this.idEmpleadoTutor,
      this.estadoId,
      this.idPeriodoAcad,
      this.idGrupo,
      this.capacidadVacante,
      this.capacidadVacanteD});

  factory CargaAcademicaSerial.fromJson(Map<String, dynamic> json) => _$CargaAcademicaSerialFromJson(json);

  Map<String, dynamic> toJson() => _$CargaAcademicaSerialToJson(this);
}
@JsonSerializable()
class CargaCursoDocenteSerial {
  int? cargaCursoDocenteId;
  int? cargaCursoId;
  int? docenteId;
  bool? responsable;

  CargaCursoDocenteSerial(
      {this.cargaCursoDocenteId,
      this.cargaCursoId,
      this.docenteId,
      this.responsable});

  factory CargaCursoDocenteSerial.fromJson(Map<String, dynamic> json) => _$CargaCursoDocenteSerialFromJson(json);

  Map<String, dynamic> toJson() => _$CargaCursoDocenteSerialToJson(this);
}
@JsonSerializable()
class CargaCursoDocenteDetSerial
{
  int? cargaCursoDocenteId;
  int? alumnoId;

  CargaCursoDocenteDetSerial({this.cargaCursoDocenteId, this.alumnoId});

  factory CargaCursoDocenteDetSerial.fromJson(Map<String, dynamic> json) => _$CargaCursoDocenteDetSerialFromJson(json);

  Map<String, dynamic> toJson() => _$CargaCursoDocenteDetSerialToJson(this);
}
@JsonSerializable()
class CursosSerializable {

  int? cursoId;
  String? nombre;
  int? estadoId;
  String? descripcion;
  String? alias;
  int? entidadId;
  int? nivelAcadId;
  int? tipoCursoId;
  int? tipoConceptoId;
  String? color;
  String? creditos;
  String? totalHP;
  String? totalHT;
  String? notaAprobatoria;
  String? sumilla;
  int? superId;
  int? idServicioLaboratorio;
  int? horasLaboratorio;
  bool? tipoSubcurso;
  String? foto;
  String? codigo;

  CursosSerializable(
      {this.cursoId,
        this.nombre,
        this.estadoId,
        this.descripcion,
        this.alias,
        this.entidadId,
        this.nivelAcadId,
        this.tipoCursoId,
        this.tipoConceptoId,
        this.color,
        this.creditos,
        this.totalHP,
        this.totalHT,
        this.notaAprobatoria,
        this.sumilla,
        this.superId,
        this.idServicioLaboratorio,
        this.horasLaboratorio,
        this.tipoSubcurso,
        this.foto,
        this.codigo});

  factory CursosSerializable.fromJson(Map<String, dynamic> json) => _$CursosSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$CursosSerializableToJson(this);
}
@JsonSerializable()
class CargaCursosSerial{

  int? cargaCursoId;
  int? planCursoId;
  int? empleadoId;
  int? cargaAcademicaId;
  int? complejo;
  int? evaluable;
  int? idempleado;
  int? idTipoHora;
  String? descripcion;
  int? fechaInicio;//Long
  int? fechafin;//Long
  String? modo;
  int? estado;
  int? anioAcademicoId;
  int? aulaId;
  int? grupoId;
  int? idPlanEstudio;
  int? idPlanEstudioVersion;
  int? CapacidadVacanteP;
  int? CapacidadVacanteD;
  String? nombreDocente;
  int? personaIdDocente;
  String? fotoDocente;

  CargaCursosSerial(
      {this.cargaCursoId,
        this.planCursoId,
        this.empleadoId,
        this.cargaAcademicaId,
        this.complejo,
        this.evaluable,
        this.idempleado,
        this.idTipoHora,
        this.descripcion,
        this.fechaInicio,
        this.fechafin,
        this.modo,
        this.estado,
        this.anioAcademicoId,
        this.aulaId,
        this.grupoId,
        this.idPlanEstudio,
        this.idPlanEstudioVersion,
        this.CapacidadVacanteP,
        this.CapacidadVacanteD});

  factory CargaCursosSerial.fromJson(Map<String, dynamic> json) => _$CargaCursosSerialFromJson(json);

  Map<String, dynamic> toJson() => _$CargaCursosSerialToJson(this);
}

@JsonSerializable()
class ParametrosDisenioSerial{

  int? parametroDisenioId;
  String? objeto;
  String? concepto;
  String? nombre;
  String? path;
  String? color1;
  String? color2;
  String? color3;
  bool? estado;

  ParametrosDisenioSerial(
      {this.parametroDisenioId,
        this.objeto,
        this.concepto,
        this.nombre,
        this.path,
        this.color1,
        this.color2,
        this.color3,
        this.estado});

  factory ParametrosDisenioSerial.fromJson(Map<String, dynamic> json) => _$ParametrosDisenioSerialFromJson(json);

  Map<String, dynamic> toJson() => _$ParametrosDisenioSerialToJson(this);
}
@JsonSerializable()
class NivelAcademicoSeraializable{
  int? nivelAcadId;
  String? nombre;
  bool? activo;
  int? entidadId;

  NivelAcademicoSeraializable(
      {this.nivelAcadId, this.nombre, this.activo, this.entidadId});

  factory NivelAcademicoSeraializable.fromJson(Map<String, dynamic> json) => _$NivelAcademicoSeraializableFromJson(json);

  Map<String, dynamic> toJson() => _$NivelAcademicoSeraializableToJson(this);
}
@JsonSerializable()
class PeriodosSeraializable {

  int? periodoId;
  String? nombre;
  int? estadoId;
  String? alias;
  String? fecComienzo;
  String? fecTermino;
  int? tipoId;
  int? superId;
  int? geoReferenciaId;
  int? organigramaId;
  int? entidadId;
  bool? activo;
  int? cicloId;
  int? docenteId;
  String? gruponombre;
  int? grupoId;
  String? nivelAcademico;
  int? nivelAcademicoId;
  int? tutorId;

  PeriodosSeraializable(
      {this.periodoId,
        this.nombre,
        this.estadoId,
        this.alias,
        this.fecComienzo,
        this.fecTermino,
        this.tipoId,
        this.superId,
        this.geoReferenciaId,
        this.organigramaId,
        this.entidadId,
        this.activo,
        this.cicloId,
        this.docenteId,
        this.gruponombre,
        this.grupoId,
        this.nivelAcademico,
        this.nivelAcademicoId,
        this.tutorId});

  factory PeriodosSeraializable.fromJson(Map<String, dynamic> json) => _$PeriodosSeraializableFromJson(json);

  Map<String, dynamic> toJson() => _$PeriodosSeraializableToJson(this);
}
@JsonSerializable()
class PlanCursosSerial {

  int? planCursoId;
  int? cursoId;
  int? periodoId;
  int? planEstudiosId;

  PlanCursosSerial(
      {this.planCursoId, this.cursoId, this.periodoId, this.planEstudiosId});

  factory PlanCursosSerial.fromJson(Map<String, dynamic> json) => _$PlanCursosSerialFromJson(json);

  Map<String, dynamic> toJson() => _$PlanCursosSerialToJson(this);
}
@JsonSerializable()
class PlanEstudiosSerial {

  int? planEstudiosId;
  int? programaEduId;
  String? nombrePlan;
  String? alias;
  int? estadoId;
  String? nroResolucion;
  String? fechaResolucion;

  PlanEstudiosSerial({this.planEstudiosId, this.programaEduId, this.nombrePlan,
    this.alias, this.estadoId, this.nroResolucion, this.fechaResolucion});

  factory PlanEstudiosSerial.fromJson(Map<String, dynamic> json) => _$PlanEstudiosSerialFromJson(json);

  Map<String, dynamic> toJson() => _$PlanEstudiosSerialToJson(this);
}
@JsonSerializable()
class ProgramasEducativoSerial {

  int? programaEduId;
  String? nombre;
  String? nroCiclos;
  int? nivelAcadId;
  int? tipoEvaluacionId;
  int? estadoId;
  int? entidadId;
  int? tipoInformeSiagieId;
  int? tipoProgramaId;
  int? tipoMatriculaId;

  ProgramasEducativoSerial(
      {this.programaEduId,
        this.nombre,
        this.nroCiclos,
        this.nivelAcadId,
        this.tipoEvaluacionId,
        this.estadoId,
        this.entidadId,
        this.tipoInformeSiagieId,
        this.tipoProgramaId,
        this.tipoMatriculaId});

  factory ProgramasEducativoSerial.fromJson(Map<String, dynamic> json) => _$ProgramasEducativoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$ProgramasEducativoSerialToJson(this);
}
@JsonSerializable()
class SeccionSeraializable {
  int? seccionId;
  String? nombre;
  String? descripcion;
  bool? estado;
  int? georeferenciaId;

  SeccionSeraializable(this.seccionId, this.nombre, this.descripcion,
      this.estado, this.georeferenciaId);

  factory SeccionSeraializable.fromJson(Map<String, dynamic> json) => _$SeccionSeraializableFromJson(json);

  Map<String, dynamic> toJson() => _$SeccionSeraializableToJson(this);
}
@JsonSerializable()
class SilaboEventoSerial {

  int? silaboEventoId;
  String? titulo;
  String? descripcionGeneral;
  int? planCursoId;
  int? entidadId;
  int? docenteId;
  int? seccionId;
  String? fechaInicio;
  String? fechaFin;
  int? estadoId;
  int? anioAcademicoId;
  int? georeferenciaId;
  int? silaboBaseId;
  int? cargaCursoId;
  int? parametroDisenioId;

  SilaboEventoSerial(
      {this.silaboEventoId,
        this.titulo,
        this.descripcionGeneral,
        this.planCursoId,
        this.entidadId,
        this.docenteId,
        this.seccionId,
        this.fechaInicio,
        this.fechaFin,
        this.estadoId,
        this.anioAcademicoId,
        this.georeferenciaId,
        this.silaboBaseId,
        this.cargaCursoId,
        this.parametroDisenioId});

  factory SilaboEventoSerial.fromJson(Map<String, dynamic> json) => _$SilaboEventoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$SilaboEventoSerialToJson(this);
}
@JsonSerializable()
class CalendarioPeriodoSerial {

  int? calendarioPeriodoId;
  int? fechaInicio;//long
  int? fechaFin;//long
  int? calendarioAcademicoId;
  int? tipoId;
  int? estadoId;
  int? diazPlazo;
  bool? habilitado;

  CalendarioPeriodoSerial(
      {this.calendarioPeriodoId,
        this.fechaInicio,
        this.fechaFin,
        this.calendarioAcademicoId,
        this.tipoId,
        this.estadoId,
        this.diazPlazo,
        this.habilitado});

  factory CalendarioPeriodoSerial.fromJson(Map<String, dynamic> json) => _$CalendarioPeriodoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarioPeriodoSerialToJson(this);
}

@JsonSerializable()
class CalendarioCargaCursoSerial {

  int? calendarioPeriodoId;
  int? fechaInicio;//long
  int? fechaFin;//long
  int? calendarioAcademicoId;
  int? tipoId;
  int? estadoId;
  int? diazPlazo;
  String? nombre;
  int? habilitado;
  int? cargaCursoId;

  CalendarioCargaCursoSerial(
      {this.calendarioPeriodoId,
        this.fechaInicio,
        this.fechaFin,
        this.calendarioAcademicoId,
        this.tipoId,
        this.estadoId,
        this.diazPlazo,
        this.habilitado,
        this.nombre,
        this.cargaCursoId});

  factory CalendarioCargaCursoSerial.fromJson(Map<String, dynamic> json) => _$CalendarioCargaCursoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarioCargaCursoSerialToJson(this);
}

@JsonSerializable()
class TiposSerial {

  int? tipoId;
  String? objeto;
  String? concepto;
  String? nombre;
  String? codigo;
  int? parentId;

  TiposSerial({this.tipoId, this.objeto, this.concepto, this.nombre, this.codigo,
    this.parentId});

  factory TiposSerial.fromJson(Map<String, dynamic> json) => _$TiposSerialFromJson(json);

  Map<String, dynamic> toJson() => _$TiposSerialToJson(this);
}
@JsonSerializable()
class CalendarioAcademicoSerial
{
  int? calendarioAcademicoId;
  int? programaEduId;
  int? idAnioAcademico;
  int? estadoId;

  CalendarioAcademicoSerial(
      {this.calendarioAcademicoId,
      this.programaEduId,
      this.idAnioAcademico,
      this.estadoId});


  factory CalendarioAcademicoSerial.fromJson(Map<String, dynamic> json) => _$CalendarioAcademicoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarioAcademicoSerialToJson(this);
}

@JsonSerializable()
class HoraSerial
{
  int? idHora;
  String? horaInicio;
  String? horaFin;

  HoraSerial({this.idHora, this.horaInicio, this.horaFin});

  factory HoraSerial.fromJson(Map<String, dynamic> json) => _$HoraSerialFromJson(json);

  Map<String, dynamic> toJson() => _$HoraSerialToJson(this);
}
@JsonSerializable()
class HorarioProgramaSerial
{
  int? idHorarioPrograma;
  int? idHorario;
  int? activo;
  int? idProgramaEducativo;
  int? idAnioAcademico;
  int? idUsuarioActualizacion;
  int? idUsuarioCreacion;
  String? fechaCreacion;
  String? fechaActualizacion;

  HorarioProgramaSerial(
      {this.idHorarioPrograma,
      this.idHorario,
      this.activo,
      this.idProgramaEducativo,
      this.idAnioAcademico,
      this.idUsuarioActualizacion,
      this.idUsuarioCreacion,
      this.fechaCreacion,
      this.fechaActualizacion});

  factory HorarioProgramaSerial.fromJson(Map<String, dynamic> json) => _$HorarioProgramaSerialFromJson(json);

  Map<String, dynamic> toJson() => _$HorarioProgramaSerialToJson(this);
}
@JsonSerializable()
class HorarioHoraSerial
{
  int? idHorarioHora;
  int? horaId;
  int? detalleHoraId;

  HorarioHoraSerial({this.idHorarioHora, this.horaId, this.detalleHoraId});
  factory HorarioHoraSerial.fromJson(Map<String, dynamic> json) => _$HorarioHoraSerialFromJson(json);

  Map<String, dynamic> toJson() => _$HorarioHoraSerialToJson(this);
}
@JsonSerializable()
class DetalleHorarioSerial
{
  int? idDetalleHorario;
  int? idTipoHora;
  int? idTipoTurno;
  String? horaInicio;
  String? horaFin;
  int? idHorarioDia;
  int? timeChange;

  DetalleHorarioSerial(
      {this.idDetalleHorario,
      this.idTipoHora,
      this.idTipoTurno,
      this.horaInicio,
      this.horaFin,
      this.idHorarioDia,
      this.timeChange});
  factory DetalleHorarioSerial.fromJson(Map<String, dynamic> json) => _$DetalleHorarioSerialFromJson(json);

  Map<String, dynamic> toJson() => _$DetalleHorarioSerialToJson(this);
}
@JsonSerializable()
class DiaSerial
{
  int? diaId;
  String? nombre;
  bool? estado;
  String? alias;

  DiaSerial({this.diaId, this.nombre, this.estado, this.alias});

  factory DiaSerial.fromJson(Map<String, dynamic> json) => _$DiaSerialFromJson(json);

  Map<String, dynamic> toJson() => _$DiaSerialToJson(this);
}
@JsonSerializable()
class HorarioDiaSerial
{
  int? idHorarioDia;
  int? idHorario;
  int? idDia;

  HorarioDiaSerial({this.idHorarioDia, this.idHorario, this.idDia});

  factory HorarioDiaSerial.fromJson(Map<String, dynamic> json) => _$HorarioDiaSerialFromJson(json);

  Map<String, dynamic> toJson() => _$HorarioDiaSerialToJson(this);
}
@JsonSerializable()
class CursosDetHorarioSerial
{
  int? idCursosDetHorario;
  int? idDetHorario;
  int? idCargaCurso;

  CursosDetHorarioSerial(
      {this.idCursosDetHorario, this.idDetHorario, this.idCargaCurso});

  factory CursosDetHorarioSerial.fromJson(Map<String, dynamic> json) => _$CursosDetHorarioSerialFromJson(json);

  Map<String, dynamic> toJson() => _$CursosDetHorarioSerialToJson(this);
}
@JsonSerializable()
class HorarioSerial
{
  int? idHorario;
  String? nombre;
  @JsonKey(name: 'descripción')
  final String? descripcion;
  String? fecCreacion;
  String? fecActualizacion;
  bool? estado;
  int? idUsuario;
  int? entidadId;
  int? georeferenciaId;
  int? organigramaId;

  HorarioSerial(
      {this.idHorario,
      this.nombre,
      this.descripcion,
      this.fecCreacion,
      this.fecActualizacion,
      this.estado,
      this.idUsuario,
      this.entidadId,
      this.georeferenciaId,
      this.organigramaId});

  factory HorarioSerial.fromJson(Map<String, dynamic> json) => _$HorarioSerialFromJson(json);

  Map<String, dynamic> toJson() => _$HorarioSerialToJson(this);
}
@JsonSerializable()
class WebConfigsSerial {
  String? nombre;
  String? content;

  WebConfigsSerial(this.nombre, this.content);

  factory WebConfigsSerial.fromJson(Map<String, dynamic> json) => _$WebConfigsSerialFromJson(json);

  Map<String, dynamic> toJson() => _$WebConfigsSerialToJson(this);
}

//#region Rubro Evaluacion
@JsonSerializable()
class CriteriosSerial {
  int? sesionAprendizajeId;
  int? unidadAprendiajeId;
  int? silaboEventoId;
  int? sesionAprendizajePadreId;

  String? tituloSesion;
  int? rolIdSesion;
  int? nroSesion;
  String? propositoSesion;
  String? tituloUnidad;
  int? nroUnidad;
  /// <summary>
  /// Tabla Competencias
  /// </summary>
  int? competenciaId;
  String? competenciaNombre;
  String? competenciaDescripcion;
  int? competenciaTipoId;
  int? superCompetenciaId;
  String? superCompetenciaNombre;
  String? superCompetenciaDescripcion;
  int? superCompetenciaTipoId;


  /// <summary>
  /// Tabla DesempenioIcd Desempenio Icd
  /// </summary>
  int? desempenioIcdId;
  String? DesempenioDescripcion;
  int? peso;
  String? codigo;
  int? tipoId;
  String? url;
  int? desempenioId;
  String? desempenioIcdDescripcion;
  int? icdId;
  String? icdTitulo;
  String? icdDescripcion;
  String? icdAlias;

  /// <summary>
  /// Tabla CampoTematico
  /// </summary>
  ///

  int? campoTematicoId;
  String? campoTematicoTitulo;
  String? campoTematicoDescripcion;
  int? campoTematicoEstado;
  int? campoTematicoParentId;
  String? campoTematicoParentTitulo;
  String? campoTematicoParentDescripcion;
  int? campoTematicoParentEstado;
  int? campoTematicoParentParentId;

  int? calendarioPeriodoId;


  CriteriosSerial(
      this.sesionAprendizajeId,
      this.unidadAprendiajeId,
      this.silaboEventoId,
      this.sesionAprendizajePadreId,
      this.tituloSesion,
      this.rolIdSesion,
      this.nroSesion,
      this.propositoSesion,
      this.tituloUnidad,
      this.nroUnidad,
      this.competenciaId,
      this.competenciaNombre,
      this.competenciaDescripcion,
      this.competenciaTipoId,
      this.superCompetenciaId,
      this.superCompetenciaNombre,
      this.superCompetenciaDescripcion,
      this.superCompetenciaTipoId,
      this.desempenioIcdId,
      this.DesempenioDescripcion,
      this.peso,
      this.codigo,
      this.tipoId,
      this.url,
      this.desempenioId,
      this.desempenioIcdDescripcion,
      this.icdId,
      this.icdTitulo,
      this.icdDescripcion,
      this.icdAlias,
      this.campoTematicoId,
      this.campoTematicoTitulo,
      this.campoTematicoDescripcion,
      this.campoTematicoEstado,
      this.campoTematicoParentId,
      this.campoTematicoParentTitulo,
      this.campoTematicoParentDescripcion,
      this.campoTematicoParentEstado,
      this.campoTematicoParentParentId,
      this.calendarioPeriodoId);

  factory CriteriosSerial.fromJson(Map<String, dynamic> json) => _$CriteriosSerialFromJson(json);

  Map<String, dynamic> toJson() => _$CriteriosSerialToJson(this);
}
@JsonSerializable()
class TipoEvaluacionRubroSerial {
  int? tipoEvaluacionId;
  String? nombre;
  bool? estado;

  TipoEvaluacionRubroSerial(this.tipoEvaluacionId, this.nombre, this.estado);
  factory TipoEvaluacionRubroSerial.fromJson(Map<String, dynamic> json) => _$TipoEvaluacionRubroSerialFromJson(json);

  Map<String, dynamic> toJson() => _$TipoEvaluacionRubroSerialToJson(this);

}

@JsonSerializable()
class TipoNotaRubroSerial {
  String? key;
  String? tipoNotaId;
  int? silaboEventoId;
  String? nombre;
  int? tipoId;
  String? tiponombre;
  String? valorDefecto;
  double? longitudPaso;
  bool? intervalo;
  bool? estatico;
  int? entidadId;
  int? georeferenciaId;
  int? organigramaId;
  int? estadoId;
  int? tipoFuenteId;
  int? valorMinimo;
  int? valorMaximo;
  int? escalaEvaluacionId;
  String? escalanombre;
  int? escalavalorMinimo;
  int? escalavalorMaximo;
  int? escalaestado;
  bool? escaladefecto;
  int? escalaentidadId;
  int? programaEducativoId;

  TipoNotaRubroSerial(
      {this.key,
        this.tipoNotaId,
        this.silaboEventoId,
        this.nombre,
        this.tipoId,
        this.tiponombre,
        this.valorDefecto,
        this.longitudPaso,
        this.intervalo,
        this.estatico,
        this.entidadId,
        this.georeferenciaId,
        this.organigramaId,
        this.estadoId,
        this.tipoFuenteId,
        this.valorMinimo,
        this.valorMaximo,
        this.escalaEvaluacionId,
        this.escalanombre,
        this.escalavalorMinimo,
        this.escalavalorMaximo,
        this.escalaestado,
        this.escaladefecto,
        this.escalaentidadId,
        this.programaEducativoId});

  factory TipoNotaRubroSerial.fromJson(Map<String, dynamic> json) => _$TipoNotaRubroSerialFromJson(json);

  Map<String, dynamic> toJson() => _$TipoNotaRubroSerialToJson(this);
}

@JsonSerializable()
class ValorTipoNotaRubroSerial {
  String? key;
  String? valorTipoNotaId;
  int? silaboEventoId;
  String? tipoNotaId;
  String? titulo;
  String? alias;
  double? limiteInferior;
  double? limiteSuperior;
  double? valorNumerico;
  String? icono;
  int? estadoId;
  bool? incluidoLInferior;
  bool? incluidoLSuperior;
  int? tipoId;
  int? usuarioCreacionId;
  int? usuarioCreadorId;
  int? fechaCreacion;
  int? usuarioAccionId;
  int? fechaAccion;
  int? fechaEnvio;
  int? fechaEntrega;
  int? fechaRecibido;
  int? fechaVisto;
  int? fechaRespuesta;
  String? getSTime;

  ValorTipoNotaRubroSerial(
      {this.valorTipoNotaId,
        this.tipoNotaId,
        this.silaboEventoId,
        this.titulo,
        this.alias,
        this.limiteInferior,
        this.limiteSuperior,
        this.valorNumerico,
        this.icono,
        this.estadoId,
        this.incluidoLInferior,
        this.incluidoLSuperior,
        this.tipoId,
        this.key,
        this.usuarioCreacionId,
        this.usuarioCreadorId,
        this.fechaCreacion,
        this.usuarioAccionId,
        this.fechaAccion,
        this.fechaEnvio,
        this.fechaEntrega,
        this.fechaRecibido,
        this.fechaVisto,
        this.fechaRespuesta,
        this.getSTime});
  factory ValorTipoNotaRubroSerial.fromJson(Map<String, dynamic> json) => _$ValorTipoNotaRubroSerialFromJson(json);

  Map<String, dynamic> toJson() => _$ValorTipoNotaRubroSerialToJson(this);
}
@JsonSerializable()
class RubroEvaluacionProcesoSerial {
  String? rubroEvalProcesoId;
  String? titulo;
  String? subtitulo;
  String? colorFondo;
  bool? mColorFondo;
  String? valorDefecto;
  int? competenciaId;
  int? calendarioPeriodoId;
  String?anchoColumna;
  bool? ocultarColumna;
  int? tipoFormulaId;
  int? silaboEventoId;
  int? tipoRedondeoId;
  int? valorRedondeoId;
  int? rubroEvalResultadoId;
  String? tipoNotaId;
  int? sesionAprendizajeId;
  int? desempenioIcdId;
  int? campoTematicoId;
  int? tipoEvaluacionId;
  int? estadoId;
  int? tipoEscalaEvaluacionId;

  int? tipoColorRubroProceso;
  int? tiporubroid;
  int? formaEvaluacionId;
  int? countIndicador;
  int? rubroFormal;
  int? msje;
  double?promedio;
  double?desviacionEstandar;
  int? unidadAprendizajeId;

  int? estrategiaEvaluacionId;
  String?tareaId;
  String?resultadoTipoNotaId;


  int? usuarioCreacionId;
  int?fechaCreacion;
  int? usuarioAccionId;
  int?fechaAccion;
  String? key;

  String? instrumentoEvalId;
  String? preguntaEvalId;

  int? error_guardar;

  RubroEvaluacionProcesoSerial({
      this.rubroEvalProcesoId,
      this.titulo,
      this.subtitulo,
      this.colorFondo,
      this.mColorFondo,
      this.valorDefecto,
      this.competenciaId,
      this.calendarioPeriodoId,
      this.anchoColumna,
      this.ocultarColumna,
      this.tipoFormulaId,
      this.silaboEventoId,
      this.tipoRedondeoId,
      this.valorRedondeoId,
      this.rubroEvalResultadoId,
      this.tipoNotaId,
      this.sesionAprendizajeId,
      this.desempenioIcdId,
      this.campoTematicoId,
      this.tipoEvaluacionId,
      this.estadoId,
      this.tipoEscalaEvaluacionId,
      this.tipoColorRubroProceso,
      this.tiporubroid,
      this.formaEvaluacionId,
      this.countIndicador,
      this.rubroFormal,
      this.msje,
      this.promedio,
      this.desviacionEstandar,
      this.unidadAprendizajeId,
      this.estrategiaEvaluacionId,
      this.tareaId,
      this.resultadoTipoNotaId,
      this.usuarioCreacionId,
      this.fechaCreacion,
      this.usuarioAccionId,
      this.fechaAccion,
      this.key,
      this.instrumentoEvalId,
      this.preguntaEvalId,
      this.error_guardar});

  factory RubroEvaluacionProcesoSerial.fromJson(Map<String, dynamic> json) => _$RubroEvaluacionProcesoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$RubroEvaluacionProcesoSerialToJson(this);

}
@JsonSerializable()
class EvaluacionProcesoSerial {
  String? evaluacionProcesoId;
  int? evaluacionResultadoId;
  double? nota;
  String? escala;
  String? rubroEvalProcesoId;
  int? sesionAprendizajeId;
  String? valorTipoNotaId;
  String? equipoId;
  int? alumnoId;
  int? calendarioPeriodoId;
  bool? formulaSinc;
  int? msje;
  int? publicado;
  int? visto;

  String? nombres;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? foto;

  int? usuarioCreacionId;
  int?fechaCreacion;
  int? usuarioAccionId;
  int?fechaAccion;
  String? key;
  int? syncFlag;

  EvaluacionProcesoSerial({
    this.evaluacionProcesoId,
    this.evaluacionResultadoId,
    this.nota,
    this.escala,
    this.rubroEvalProcesoId,
    this.sesionAprendizajeId,
    this.valorTipoNotaId,
    this.equipoId,
    this.alumnoId,
    this.calendarioPeriodoId,
    this.formulaSinc,
    this.msje,
    this.publicado,
    this.visto,
    this.nombres,
    this.apellidoPaterno,
    this.apellidoMaterno,
    this.foto,
    this.usuarioCreacionId,
    this.fechaCreacion,
    this.usuarioAccionId,
    this.fechaAccion,
    this.key,
    this.syncFlag
});

  factory EvaluacionProcesoSerial.fromJson(Map<String, dynamic> json) => _$EvaluacionProcesoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$EvaluacionProcesoSerialToJson(this);
}
@JsonSerializable()
class RubroEvaluacionProcesoCampotematicoSerial{
  String? rubroEvalProcesoId;
  int? campoTematicoId;

  int? usuarioCreacionId;
  int?fechaCreacion;
  int? usuarioAccionId;
  int?fechaAccion;
  String? key;


  RubroEvaluacionProcesoCampotematicoSerial(
  {
    this.rubroEvalProcesoId,
    this.campoTematicoId,
    this.usuarioCreacionId,
    this.fechaCreacion,
    this.usuarioAccionId,
    this.fechaAccion,
    this.key
});

  factory RubroEvaluacionProcesoCampotematicoSerial.fromJson(Map<String, dynamic> json) => _$RubroEvaluacionProcesoCampotematicoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$RubroEvaluacionProcesoCampotematicoSerialToJson(this);
  
}
@JsonSerializable()
class RubroEvaluacionProcesoComentarioSerial {
  String? evaluacionProcesoComentarioId;
  String? evaluacionProcesoId;
  String? comentarioId;
  String? descripcion;
  int? delete;

  int? usuarioCreacionId;
  int?fechaCreacion;
  int? usuarioAccionId;
  int?fechaAccion;
  String? key;


  RubroEvaluacionProcesoComentarioSerial({
    this.evaluacionProcesoComentarioId,
    this.evaluacionProcesoId,
    this.comentarioId,
    this.descripcion,
    this.delete,
    this.usuarioCreacionId,
    this.fechaCreacion,
    this.usuarioAccionId,
    this.fechaAccion,
    this.key
});

  factory RubroEvaluacionProcesoComentarioSerial.fromJson(Map<String, dynamic> json) => _$RubroEvaluacionProcesoComentarioSerialFromJson(json);

  Map<String, dynamic> toJson() => _$RubroEvaluacionProcesoComentarioSerialToJson(this);
}
@JsonSerializable()
class ArchivosRubroProcesoSerial {
  String? archivoRubroId;
  String? url;
  int? tipoArchivoId;
  String? evaluacionProcesoId;
  String? localpath;
  int? delete;

  int? usuarioCreacionId;
  int?fechaCreacion;
  int? usuarioAccionId;
  int?fechaAccion;
  String? key;

  ArchivosRubroProcesoSerial({
    this.archivoRubroId,
    this.url,
    this.tipoArchivoId,
    this.evaluacionProcesoId,
    this.localpath,
    this.delete,
    this.usuarioCreacionId,
    this.fechaCreacion,
    this.usuarioAccionId,
    this.fechaAccion,
    this.key
});

  factory ArchivosRubroProcesoSerial.fromJson(Map<String, dynamic> json) => _$ArchivosRubroProcesoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$ArchivosRubroProcesoSerialToJson(this);
}
@JsonSerializable()
class RubroEvalRNPFormulaSerial {

  String? rubroFormulaId;
  String? rubroEvaluacionPrimId;
  String? rubroEvaluacionSecId;
  double? peso;

  int? usuarioCreacionId;
  int?fechaCreacion;
  int? usuarioAccionId;
  int?fechaAccion;
  String? key;

  RubroEvalRNPFormulaSerial(
      {
        this.rubroFormulaId,
        this.rubroEvaluacionPrimId,
        this.rubroEvaluacionSecId,
        this.peso,
        this.usuarioCreacionId,
        this.fechaCreacion,
        this.usuarioAccionId,
        this.fechaAccion,
        this.key
      });

  factory RubroEvalRNPFormulaSerial.fromJson(Map<String, dynamic> json) => _$RubroEvalRNPFormulaSerialFromJson(json);

  Map<String, dynamic> toJson() => _$RubroEvalRNPFormulaSerialToJson(this);
}
@JsonSerializable()
class CriterioRubroEvaluacionSerial {

  String? criteriosEvaluacionId;
  String? rubroEvalProcesoId;
  String? valorTipoNotaId;
  String? descripcion;

  int? usuarioCreacionId;
  int?fechaCreacion;
  int? usuarioAccionId;
  int?fechaAccion;
  String? key;

  CriterioRubroEvaluacionSerial(
      this.criteriosEvaluacionId,
      this.rubroEvalProcesoId,
      this.valorTipoNotaId,
      this.descripcion,
      this.usuarioCreacionId,
      this.fechaCreacion,
      this.usuarioAccionId,
      this.fechaAccion,
      this.key);

  factory CriterioRubroEvaluacionSerial.fromJson(Map<String, dynamic> json) => _$CriterioRubroEvaluacionSerialFromJson(json);

  Map<String, dynamic> toJson() => _$CriterioRubroEvaluacionSerialToJson(this);
}
@JsonSerializable()
class EquipoEvaluacionProcesoSerial {

  String? equipoEvaluacionProcesoId;
  String? rubroEvalProcesoId;
  int? sesionAprendizajeId;
  String? equipoId;
  double? nota;
  String? escala;
  String? valorTipoNotaId;

  int? usuarioCreacionId;
  int?fechaCreacion;
  int? usuarioAccionId;
  int?fechaAccion;
  String? key;

  EquipoEvaluacionProcesoSerial(
      this.equipoEvaluacionProcesoId,
      this.rubroEvalProcesoId,
      this.sesionAprendizajeId,
      this.equipoId,
      this.nota,
      this.escala,
      this.valorTipoNotaId,
      this.usuarioCreacionId,
      this.fechaCreacion,
      this.usuarioAccionId,
      this.fechaAccion,
      this.key);

  factory EquipoEvaluacionProcesoSerial.fromJson(Map<String, dynamic> json) => _$EquipoEvaluacionProcesoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$EquipoEvaluacionProcesoSerialToJson(this);
}
@JsonSerializable()
class RubroEvaluacionProcesoIntegranteSerial {

  String? rubroEvaluacionEquipoId;
  int? personaId;

  RubroEvaluacionProcesoIntegranteSerial(
      this.rubroEvaluacionEquipoId, this.personaId);

  factory RubroEvaluacionProcesoIntegranteSerial.fromJson(Map<String, dynamic> json) => _$RubroEvaluacionProcesoIntegranteSerialFromJson(json);

  Map<String, dynamic> toJson() => _$RubroEvaluacionProcesoIntegranteSerialToJson(this);
}
@JsonSerializable()
class RubroEvaluacionProcesoEquipoSerial {
  String? rubroEvaluacionEquipoId;
  String? equipoId;
  String? nombreEquipo;
  String? rubroEvalProcesoId;

  int? usuarioCreacionId;
  int?fechaCreacion;
  int? usuarioAccionId;
  int?fechaAccion;
  String? key;

  RubroEvaluacionProcesoEquipoSerial(
      this.rubroEvaluacionEquipoId,
      this.equipoId,
      this.nombreEquipo,
      this.rubroEvalProcesoId,
      this.usuarioCreacionId,
      this.fechaCreacion,
      this.usuarioAccionId,
      this.fechaAccion,
      this.key);

  factory RubroEvaluacionProcesoEquipoSerial.fromJson(Map<String, dynamic> json) => _$RubroEvaluacionProcesoEquipoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$RubroEvaluacionProcesoEquipoSerialToJson(this);
}
//#endregrion
@JsonSerializable()
class ContactoDocenteSerial{
  int? personaId;
  String? nombres;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? ocupacion;
  int? estadoId;
  String? telefono;
  String? celular;
  String? fechaNac;
  String? correo;
  String? genero;
  String? estadoCivil;
  String? numDoc;
  String? foto;
  String? nombreTipo;
  int? tipo;
  int? hijoRelacionId;
  String? relacion;
  int? cargaCursoId;
  int? cursoId;
  String? cursoNombre;
  int? periodoId;
  String? periodoNombre;
  int? grupoId;
  String? grupoNombre;
  int? aulaId;
  String? aulaNombre;
  int? contratoEstadoId;
  bool? contratoVigente;
  int? relacionId;

  ContactoDocenteSerial(
      this.personaId,
      this.nombres,
      this.apellidoPaterno,
      this.apellidoMaterno,
      this.ocupacion,
      this.estadoId,
      this.telefono,
      this.celular,
      this.fechaNac,
      this.correo,
      this.genero,
      this.estadoCivil,
      this.numDoc,
      this.foto,
      this.nombreTipo,
      this.tipo,
      this.hijoRelacionId,
      this.relacion,
      this.cargaCursoId,
      this.cursoId,
      this.cursoNombre,
      this.periodoId,
      this.periodoNombre,
      this.grupoId,
      this.grupoNombre,
      this.aulaId,
      this.aulaNombre,
      this.contratoEstadoId,
      this.contratoVigente,
      this.relacionId);

  factory ContactoDocenteSerial.fromJson(Map<String, dynamic> json) => _$ContactoDocenteSerialFromJson(json);

  Map<String, dynamic> toJson() => _$ContactoDocenteSerialToJson(this);
}


//#region  AgendaCalendario
@JsonSerializable()
class CalendarioSerial {
  String? calendarioId;
  String? nombre;
  String? descripcion;
  int?  estado;
  int?  entidadId;
  int?  georeferenciaId;
  String? nUsuario;
  String? cargo;
  int?  usuarioId;
  int?  cargaAcademicaId;
  int?  cargaCursoId;
  int?  estadoPublicaciN;
  int?  estadoPublicacion;
  int?  rolId;
  String? key;
  int?  usuarioCreacionId;
  int?  usuarioCreadorId;
  int?  fechaCreacion;
  int?  usuarioAccionId;
  int?  fechaAccion;
  int?  fechaEnvio;
  int?  fechaEntrega;
  int?  fechaRecibido;
  int?  fechaVisto;
  int?  fechaRespuesta;
  String? getSTime;

  CalendarioSerial(
      {this.calendarioId,
        this.nombre,
        this.descripcion,
        this.estado,
        this.entidadId,
        this.georeferenciaId,
        this.nUsuario,
        this.cargo,
        this.usuarioId,
        this.cargaAcademicaId,
        this.cargaCursoId,
        this.estadoPublicaciN,
        this.estadoPublicacion,
        this.rolId,
        this.key,
        this.usuarioCreacionId,
        this.usuarioCreadorId,
        this.fechaCreacion,
        this.usuarioAccionId,
        this.fechaAccion,
        this.fechaEnvio,
        this.fechaEntrega,
        this.fechaRecibido,
        this.fechaVisto,
        this.fechaRespuesta,
        this.getSTime});

  factory CalendarioSerial.fromJson(Map<String, dynamic> json) => _$CalendarioSerialFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarioSerialToJson(this);
}
@JsonSerializable()
class CalendarioListaUsuarioSerial {
  String? calendarioId;
  int?  listaUsuarioId;

  CalendarioListaUsuarioSerial(this.calendarioId, this.listaUsuarioId);

  factory CalendarioListaUsuarioSerial.fromJson(Map<String, dynamic> json) => _$CalendarioListaUsuarioSerialFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarioListaUsuarioSerialToJson(this);
}
@JsonSerializable()
class ListaUsuariosSerial {
  int?  listaUsuarioId;
  String? nombre;
  String? descripcion;
  int?  entidadId;
  int?  georeferenciaId;
  int?  organigramaId;
  bool? estado;
  int?  usuarioCreacionId;
  int?  usuarioCreadorId;
  int?  fechaCreacion;
  int?  usuarioAccionId;
  int?  fechaAccion;
  int?  fechaEnvio;
  int?  fechaEntrega;
  int?  fechaRecibido;
  int?  fechaVisto;
  int?  fechaRespuesta;
  String? getSTime;

  ListaUsuariosSerial(
      {this.listaUsuarioId,
        this.nombre,
        this.descripcion,
        this.entidadId,
        this.georeferenciaId,
        this.organigramaId,
        this.estado,
        this.usuarioCreacionId,
        this.usuarioCreadorId,
        this.fechaCreacion,
        this.usuarioAccionId,
        this.fechaAccion,
        this.fechaEnvio,
        this.fechaEntrega,
        this.fechaRecibido,
        this.fechaVisto,
        this.fechaRespuesta,
        this.getSTime});

  factory ListaUsuariosSerial.fromJson(Map<String, dynamic> json) => _$ListaUsuariosSerialFromJson(json);

  Map<String, dynamic> toJson() => _$ListaUsuariosSerialToJson(this);
}
@JsonSerializable()
class EventoSerial {
  String? eventoId;
  String? titulo;
  String? descripcion;
  String? calendarioId;
  int?  tipoEventoId;
  int?  estadoId;
  bool? estadoPublicacion;
  int?  entidadId;
  int?  georeferenciaId;
  int?  fechaEvento;
  String? horaEvento;
  bool? envioPersonalizado;
  String? getSTime;
  int?  syncFlag;
  int?  usuarioReceptorId;
  int?  eventoHijoId;
  String? key;
  int?  usuarioCreacionId;
  int?  usuarioCreadorId;
  int?  fechaCreacion;
  int?  usuarioAccionId;
  int?  fechaAccion;
  int?  fechaEnvio;
  int?  fechaEntrega;
  int?  fechaRecibido;
  int?  fechaVisto;
  int?  fechaRespuesta;
  String? pathImagen;
  String? nombreEntidad;
  String? fotoEntidad;


  EventoSerial(
      this.eventoId,
      this.titulo,
      this.descripcion,
      this.calendarioId,
      this.tipoEventoId,
      this.estadoId,
      this.estadoPublicacion,
      this.entidadId,
      this.georeferenciaId,
      this.fechaEvento,
      this.horaEvento,
      this.envioPersonalizado,
      this.getSTime,
      this.syncFlag,
      this.usuarioReceptorId,
      this.eventoHijoId,
      this.key,
      this.usuarioCreacionId,
      this.usuarioCreadorId,
      this.fechaCreacion,
      this.usuarioAccionId,
      this.fechaAccion,
      this.fechaEnvio,
      this.fechaEntrega,
      this.fechaRecibido,
      this.fechaVisto,
      this.fechaRespuesta,
      this.pathImagen,
      this.nombreEntidad,
      this.fotoEntidad);

  factory EventoSerial.fromJson(Map<String, dynamic> json) => _$EventoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$EventoSerialToJson(this);
}
@JsonSerializable()
class TiposEventoSerial {
  int?  tipoId;
  String? objeto;
  String? concepto;
  String? nombre;
  String? codigo;
  int?  estado;
  int?  parentId;

  TiposEventoSerial(
      {this.tipoId,
        this.objeto,
        this.concepto,
        this.nombre,
        this.codigo,
        this.estado,
        this.parentId});

  factory TiposEventoSerial.fromJson(Map<String, dynamic> json) => _$TiposEventoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$TiposEventoSerialToJson(this);
}
@JsonSerializable()
class ListUsuarioDetalleSerial {
  int?  listaUsuarioId;
  int?  usuarioId;

  ListUsuarioDetalleSerial(this.listaUsuarioId, this.usuarioId);

  factory ListUsuarioDetalleSerial.fromJson(Map<String, dynamic> json) => _$ListUsuarioDetalleSerialFromJson(json);

  Map<String, dynamic> toJson() => _$ListUsuarioDetalleSerialToJson(this);

}
@JsonSerializable()
class UsuarioEventoSerial {
  bool? habilitarAcceso;
  int?  usuarioId;
  int?  personaId;
  bool? estado;
  int?  entidadId;
  int?  georeferenciaId;
  int?  organigramaId;

  UsuarioEventoSerial(this.habilitarAcceso, this.usuarioId, this.personaId,
      this.estado, this.entidadId, this.georeferenciaId, this.organigramaId);

  factory UsuarioEventoSerial.fromJson(Map<String, dynamic> json) => _$UsuarioEventoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioEventoSerialToJson(this);

}
@JsonSerializable()
class PersonaEventoSerial {
  int?  personaId;
  String? nombres;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? celular;
  String? telefono;
  String? foto;
  String? fechaNac;
  String? genero;
  String? estadoCivil;
  String? numDoc;
  String? ocupacion;
  int?  estadoId;
  String? correo;
  int?  empleadoId;

  PersonaEventoSerial(this.personaId, this.nombres, this.apellidoPaterno,
      this.apellidoMaterno, this.celular, this.telefono, this.foto,
      this.fechaNac, this.genero, this.estadoCivil, this.numDoc, this.ocupacion,
      this.estadoId, this.correo, this.empleadoId);

  factory PersonaEventoSerial.fromJson(Map<String, dynamic> json) => _$PersonaEventoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$PersonaEventoSerialToJson(this);

}
@JsonSerializable()
class EventoPersonaSerial {
  String? eventoPersonaId;
  String? eventoId;
  int?  personaId;
  bool? estado;
  int?  rolId;
  int?  apoderadoId;
  String? key;
  int?  usuarioCreacionId;
  int?  usuarioCreadorId;
  int?  fechaCreacion;
  int?  usuarioAccionId;
  int?  fechaAccion;
  int?  fechaEnvio;
  int?  fechaEntrega;
  int?  fechaRecibido;
  int?  fechaVisto;
  int?  fechaRespuesta;
  String? getSTime;


  EventoPersonaSerial(
      this.eventoPersonaId,
      this.eventoId,
      this.personaId,
      this.estado,
      this.rolId,
      this.apoderadoId,
      this.key,
      this.usuarioCreacionId,
      this.usuarioCreadorId,
      this.fechaCreacion,
      this.usuarioAccionId,
      this.fechaAccion,
      this.fechaEnvio,
      this.fechaEntrega,
      this.fechaRecibido,
      this.fechaVisto,
      this.fechaRespuesta,
      this.getSTime,);

  factory EventoPersonaSerial.fromJson(Map<String, dynamic> json) => _$EventoPersonaSerialFromJson(json);

  Map<String, dynamic> toJson() => _$EventoPersonaSerialToJson(this);


}
@JsonSerializable()
class RelacionesEventoSerial {
  int?  idRelacion;
  int?  personaPrincipalId;
  int?  personaVinculadaId;
  int?  tipoId;
  bool? activo;

  RelacionesEventoSerial(
      {this.idRelacion,
        this.personaPrincipalId,
        this.personaVinculadaId,
        this.tipoId,
        this.activo});
  factory RelacionesEventoSerial.fromJson(Map<String, dynamic> json) => _$RelacionesEventoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$RelacionesEventoSerialToJson(this);

}

@JsonSerializable()
class UnidadEventoSerial {
  int? unidadAprendizajeId;
  int? nroUnidad;
  String? titulo;
  String? situacionSignificativa;
  int? nroSemanas;
  int? nroHoras;
  int? nroSesiones;
  int? estadoId;
  int? silaboEventoId;
  String? situacionSignificativaComplementaria;
  String? desafio;
  String? reto;

  UnidadEventoSerial(
  {this.unidadAprendizajeId,
      this.nroUnidad,
      this.titulo,
      this.situacionSignificativa,
      this.nroSemanas,
      this.nroHoras,
      this.nroSesiones,
      this.estadoId,
      this.silaboEventoId,
      this.situacionSignificativaComplementaria,
      this.desafio,
      this.reto});

  factory UnidadEventoSerial.fromJson(Map<String, dynamic> json) => _$UnidadEventoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$UnidadEventoSerialToJson(this);
}

@JsonSerializable()
class SesionEventoSerial {
  int? sesionAprendizajeId;
  int? unidadAprendizajeId;
  String? titulo;
  String? proposito;
  int? horas;
  String? contenido;

  int? usuarioCreacionId;
  int? fechaCreacion;
  int? usuarioAccionId;
  int? fechaAccion;

  int? estadoId;
  int? fechaEjecucion;

  String? fechaReprogramacion;
  String? fechaPublicacion;
  int? nroSesion;
  int? rolId;
  int? estadoEjecucionId;
  int? fechaRealizada;
  int? fechaEjecucionFin;

  bool? estadoEvaluacion;
  int? evaluados;
  int? docenteid;
  int? parentSesionId;

  SesionEventoSerial({
      this.sesionAprendizajeId,
      this.unidadAprendizajeId,
      this.titulo,
      this.proposito,
      this.horas,
      this.contenido,
      this.usuarioCreacionId,
      this.fechaCreacion,
      this.usuarioAccionId,
      this.fechaAccion,
      this.estadoId,
      this.fechaEjecucion,
      this.fechaReprogramacion,
      this.fechaPublicacion,
      this.nroSesion,
      this.rolId,
      this.estadoEjecucionId,
      this.fechaRealizada,
      this.fechaEjecucionFin,
      this.estadoEvaluacion,
      this.evaluados,
      this.docenteid,
      this.parentSesionId});

  factory SesionEventoSerial.fromJson(Map<String, dynamic> json) => _$SesionEventoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$SesionEventoSerialToJson(this);

}
@JsonSerializable()
class RelUnidadEventoSerial {
  int? unidadaprendizajeId;
  int? tipoid;

  RelUnidadEventoSerial({this.unidadaprendizajeId, this.tipoid});

  factory RelUnidadEventoSerial.fromJson(Map<String, dynamic> json) => _$RelUnidadEventoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$RelUnidadEventoSerialToJson(this);

}



//#endregion


