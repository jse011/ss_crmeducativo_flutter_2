

import 'dart:io';

abstract class HttpDatosRepository{

  Future<Map<String, dynamic>?> getUsuarioExterno(int opcion, String usuario, String password, String correo, String dni);
  Future<Map<String, dynamic>?> getUsuario(String urlServidor, int usuarioId);
  Future<Map<String, dynamic>?> getDatosInicioDocente(String urlServidorLocal, int usuarioId);
  Future<Map<String, dynamic>?> getDatosAnioAcademico(String urlServidorLocal, int empleadoId, int anioAcademicoId);
  Future<Map<String, dynamic>?> updateDatosParaCrearRubro(String urlServidorLocal, int anioAcademicoId, int programaEducativoId, int calendarioPeriodoId, int silaboEventoId, int empleadoId);
  Future<Map<String, dynamic>?> getContactoDocente(String urlServidorLocal, int empleadoId, int anioAcademicoId);
  Future<Map<String, dynamic>?> getEventoAgenda(String urlServidorLocal, int usuarioId, int anioAcademicoId, int tipoEventoId);
  Future<Map<String, dynamic>?> getUnidadSesion(String urlServidorLocal, int usuarioId, int calendarioId, int silaboEventoId, int rolId);
  Future<List<dynamic>?> getCalendarioPeriodoCursoFlutter(String urlServidorLocal, int anioAcademicoIdSelect, int programaEducativoIdSelect, int cargaCursoId);
  Future<Map<String, dynamic>?> getDatosRubroFlutter(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int georeferenciaId, int usuarioId, List<dynamic> rubrosNoEnviados);
  Future<bool?> crearRubroEvaluacion(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int georeferenciaId, int usuarioId, Map<String, dynamic> data);
  Future<bool?> updateEvaluacionRubroFlutter(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int georeferenciaId, int usuarioId, Map<String, dynamic> data);
  Future<bool?> updateCompetenciaRubroFlutter(String urlServidorLocal, int georeferenciaId, int usuarioId, List<Map<String, dynamic>?> rubrosEnviados);
  Future<Map<String, dynamic>?> getUnidadTarea(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId);
  Future<Map<String, dynamic>?> getInfoTareaDocente(String urlServidorLocal, String? tareaId, String? rubroEvaluacionId, int? silaboEventoId, int? unidadEventoId);
  Future<HttpStream> uploadFileArchivoDocente( String urlServidorLocal, int silaboEventoId, String nombre, File file, HttpProgressListen progressListen, HttpSuccess httpSuccessListen);
  Future<bool?> saveTareaDocente(String urlServidorLocal, Map<String, dynamic> data);
}

abstract class HttpStream {

  void cancel();

  bool isFinished();
}
typedef HttpStreamListen = void Function(List<int> bytes, int? total);
typedef HttpProgressListen = void Function(double? progress);
typedef HttpSuccess = void Function(bool success, dynamic value);