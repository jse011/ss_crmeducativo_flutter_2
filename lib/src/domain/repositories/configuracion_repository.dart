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

abstract class ConfiguracionRepository{
  Future<bool> validarUsuario();
  Future<void> destroyBaseDatos();
  Future<LoginUi> saveDatosServidor(Map<String, dynamic> datosServidor);
  Future<int> getSessionUsuarioId();
  Future<int> getGeoreferenciaId();
  Future<String> getSessionUsuarioUrlServidor();
  Future<int> getSessionAnioAcademicoId();
  Future<int> getSessionEmpleadoId();
  Future<int> getSessionProgramaEducativoId();
  Future<void> saveUsuario(Map<String, dynamic> datosUsuario);
  Future<bool> validarRol(int usuarioId);
  Future<UsuarioUi> saveDatosIniciales(Map<String, dynamic> datosInicio);
  Future<void> updateUsuarioSuccessData(int usuarioId, int anioAcademicoId);
  Future<void> saveDatosAnioAcademico(Map<String, dynamic> datosAnioAcademico);
  Future<UsuarioUi> getSessionUsuario();
  Future<List<AnioAcademicoUi>> getAnioAcademicoList(int usuarioId);
  Future<void> updateSessionAnioAcademicoId(int anioAcademicoId);
  Future<void> updateSessionProgramaEducativoId(int programaEducativoId);
  Future<List<ProgramaEducativoUi>> getListProgramaEducativo(int empleadoId, int anioAcademicoId);
  Future<List<CursosUi>> getListCursos(int empleadoId, int anioAcademicoId, int programaEducativoId);
  Future<CursosUi?> getCurso(int cargaCursoId);
  Future<void> saveContactoDocente(Map<String, dynamic> contactoDocente, int empleadoId, int anioAcademicoIdSelect);
  Future<List<ContactoUi>> getListContacto(int empleadoId, int anioAcademicoIdSelect);
  Future<List<PersonaUi>> getListAlumnoCurso(int cargaCursoId);

}
