import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/calendario.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/calendario_lista_usuario.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/evento.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/evento_adjunto.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/evento_persona.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/lista_usuario_detalle.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/lista_usuarios.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/persona_evento.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/relaciones_persona.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/tipo_evento.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/agenda_evento/usuario_evento.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/anio_academico.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/asistencia_qr/asistencia_qr.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/aula.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/calendario_academico.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/calendario_periodo.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/calendario_periodo_carga_curso.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/carga_academica.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/carga_curso_docente.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/carga_curso_docente_det.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/carga_cursos.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/contacto_docente.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/criterios.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/cursos.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/cursos_det_horario.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/detalle_horario.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/dia.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/empleado.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/entidad.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/georeferencia.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/grupo/equipo_2.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/grupo/grupo_equipo_2.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/grupo/integrante_equipo_2.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/hora.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/horario.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/horario_dia.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/horario_hora.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/horario_programa.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/nivel_academico.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/parametro_configuracion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/parametros_disenio.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/periodos.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/persona.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/plan_cursos.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/plan_estudios.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/programas_educativo.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rol.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/archivo_rubro.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/criterio_rubro_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/equipo_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/evaluacion_proceso.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/rubro_campotematico.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/rubro_comentario.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/rubro_eval_rnpformula.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/rubro_evaluacion_proceso.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/rubro_evaluacion_proceso_equipo.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/rubro_evaluacion_proceso_integrante.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/rubro_update_servidor.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/tipo_nota_resultado.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/tipo_nota_rubro.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/valor_tipo_nota_resultado.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/rubro/valor_tipo_nota_rubro.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/seccion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/session_user.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/silabo_evento.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tarea/tarea.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tarea/tarea_alumno.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tarea/tarea_alumno_archivo.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tarea/tarea_eval_detalle.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tarea/tarea_recurso_didactico.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tarea/tarea_unidad.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tipo_evaluacion_rubro.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tipos.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/tipos_rubro.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/actividad_sesion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/campotematico_sesion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/competencia_sesion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/desempenio_icd_sesion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/instrumento_evaluacion_sesion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/recursos_actividad_sesion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/recursos_sesion.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/rel_unidad_evento_tipo.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/sesion_evento.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/unidad_sesion/unidad_evento.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/usuario.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/usuario_rol_georeferencia.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/web_configs.dart';

part 'app_database.g.dart';

@UseMoor(tables:[SessionUser, UsuarioRolGeoreferencia, Rol, Georeferencia, Entidad, Persona, Empleado, AnioAcademico, ParametroConfiguracion, Aula, CargaAcademica,
  CargaCursoDocente, CargaCursoDocenteDet, CargaCurso, Cursos, ParametrosDisenio, NivelAcademico, Periodos, PlanCursos, PlanEstudio, ProgramasEducativo, Seccion, SilaboEvento,
  CalendarioPeriodo, Tipos, Hora, HorarioPrograma, HorarioHora, DetalleHorario, Dia, HorarioDia, CursosDetHorario, Horario,
  CalendarioAcademico, Usuario, WebConfigs, Criterio, TipoEvaluacionRubro, TiposRubro, TipoNotaRubro, ValorTipoNotaRubro, RubroEvaluacionProceso, ArchivoRubro, EquipoEvaluacion,
  EvaluacionProceso, RubroCampotematico, RubroComentario, RubroEvalRNPFormula, ContactoDocente, CriterioRubroEvaluacion, Calendario, CalendarioListaUsuario, Evento, EventoPersona,
  ListaUsuarioDetalle, ListaUsuarios, PersonaEvento, RelacionesEvento, TipoEvento, UsuarioEvento, UnidadEvento, SesionEvento, RelUnidadEvento, RubroUpdateServidor, CalendarioPeriodoCargaCurso,
  TipoNotaResultado, ValorTipoNotaResultado, Tarea, TareaUnidad, TareaAlumno, TareaAlumnoArchivo, TareaRecursoDidactico, EventoAdjunto, TareaEvalDetalle, CompetenciaSesion, DesempenioIcdSesion, CampotematicoSesion,
  ActividadSesion, InstrumentoEvaluacionSesion, RecursosActividadSesion, RecursoSesion, AsistenciaQR, Equipo2, GrupoEquipo2, IntegranteEquipo2, RubroEvaluacionProcesoEquipo, RubroEvaluacionProcesoIntegrante])
class AppDataBase extends _$AppDataBase {
  @override
  int get schemaVersion => 11;

  static final AppDataBase _singleton = AppDataBase._internal();

  factory AppDataBase() {
    return _singleton;
  }

  AppDataBase._internal(): super(FlutterQueryExecutor.inDatabaseFolder(
      path: "db.sqlite", logStatements: false));

  SimpleSelectStatement<T, R> selectSingle<T extends Table, R extends DataClass>(TableInfo<T, R> table, {bool distinct = false}){
    var query = select(table, distinct: distinct);
    query.limit(1);
    return query;
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        // create missing tables that were missing in version 1
        if (from == 1) {
          await m.createTable(tareaAlumno);
          // you also need this line for every other table not created in the first version
        }
        print("AppDataBase from ${from}");
        print("AppDataBase to ${to}");
        if (from == 1) {
          await m.createTable(asistenciaQR);
          // you also need this line for every other table not created in the first version
        }


        //if (to <= 11) {
          await m.createTable(equipo2);
          await m.createTable(integranteEquipo2);
          await m.createTable(grupoEquipo2);
          // you also need this line for every other table not created in the first version
          await m.createTable(rubroEvaluacionProcesoEquipo);
          await m.createTable(rubroEvaluacionProcesoIntegrante);
          // you also need this line for every other table not created in the first version
        //}
      },
    );
  }
}

/*
* Moor integrates with Dart’s build system, so you can generate all the code needed with |.
* If you want to continuously rebuild the generated code where you change your code, run flutter packages pub run build_runner watch instead.
* After running either command once, the moor generator will have created a class for your database and data classes for your entities.
* To use it, change the MyDatabase class as follows:
* */

