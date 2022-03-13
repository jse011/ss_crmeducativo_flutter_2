import 'package:ss_crmeducativo_2/src/domain/entities/anio_academico_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/georeferencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/login_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/programa_educativo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_lista_envio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';

abstract class ConfiguracionRepository{
  static const int CONTACTO_DOCENTE = 3, CONTACTO_DIRECTIVO = 4, CONTACTO_ALUMNO = 1, CONTACTO_PADRE = 2, CONTACTO_APODERADO = 5;

  Future<bool> validarUsuario();
  Future<void> destroyBaseDatos();
  Future<LoginUi> saveDatosServidor(Map<String, dynamic> datosServidor);
  Future<int> getSessionUsuarioId();
  Future<int> getGeoreferenciaId();
  Future<String> getSessionUsuarioUrlServidor();
  Future<int> getSessionAnioAcademicoId();
  Future<int> getSessionEntidadId();
  Future<int> getSessionGeoreferenciaId();
  Future<int> getSessionEmpleadoId();
  Future<int> getSessionProgramaEducativoId();
  Future<void> saveUsuario(Map<String, dynamic> datosUsuario);
  Future<bool> validarRol(int usuarioId);
  Future<UsuarioUi> saveDatosIniciales(Map<String, dynamic> datosInicio);
  Future<void> updateUsuarioSuccessData(int usuarioId, int anioAcademicoId);
  Future<void> saveDatosAnioAcademico(Map<String, dynamic> datosAnioAcademico,  int? anioAcademicoId, int? empleadoId);
  Future<UsuarioUi> getSessionUsuario();
  Future<List<GeoreferenciaUi>> getGeoreferenciaList(int usuarioId);
  Future<void> updateSessionAnioAcademicoId(int anioAcademicoId);
  Future<void> updateSessionProgramaEducativoId(int programaEducativoId);
  Future<List<ProgramaEducativoUi>> getListProgramaEducativo(int empleadoId, int anioAcademicoId);
  Future<List<CursosUi>> getListCursos(int empleadoId, int anioAcademicoId, int programaEducativoId);
  Future<CursosUi?> getCurso(int cargaCursoId);
  Future<void> saveContactoDocente(Map<String, dynamic> contactoDocente, int empleadoId, int anioAcademicoIdSelect);
  Future<List<ContactoUi>> getListContacto(int empleadoId, int anioAcademicoIdSelect);
  Future<List<PersonaUi>> getListAlumnoCurso(int cargaCursoId);
  Future<bool> cerrrarSession();
  Future<String?> getServerIcono();
  Future<void> updatePersona(PersonaUi? personaUi);
  PersonaUi transformarUpdatePersona(Map<String, dynamic> jsonPersona);
  Future<List<CursosUi>> getFotoAlumnos(int empleadoId, int anioAcademicoIdSelec);
  Future<void> udpateUsuario(int usuarioId, Map<String, dynamic> usuarioJson);
  Future<int> getSessionPersonaId();

}
