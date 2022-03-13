import 'dart:io';

import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_qr_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_firebase_sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_comentario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';

abstract class HttpDatosRepository{

  Future<Map<String, dynamic>?> getUsuarioExterno(int opcion, String usuario, String password, String correo, String dni);
  Future<Map<String, dynamic>?> getUsuario(String urlServidor, int usuarioId);
  Future<Map<String, dynamic>?> getDatosInicioDocente(String urlServidorLocal, int usuarioId);
  Future<Map<String, dynamic>?> getDatosAnioAcademico(String urlServidorLocal, int empleadoId, int anioAcademicoId);
  Future<Map<String, dynamic>?> updateDatosParaCrearRubro(String urlServidorLocal, int anioAcademicoId, int programaEducativoId, int calendarioPeriodoId, int silaboEventoId, int empleadoId, int sesionAprendizajeId);
  Future<Map<String, dynamic>?> getContactoDocente(String urlServidorLocal, int empleadoId, int anioAcademicoId);
  Future<Map<String, dynamic>?> getEventoAgenda(String urlServidorLocal, int usuarioId, int anioAcademicoId, int tipoEventoId);
  Future<Map<String, dynamic>?> getUnidadSesion(String urlServidorLocal, int usuarioId, int calendarioId, int silaboEventoId, int rolId);
  Future<List<dynamic>?> getCalendarioPeriodoCursoFlutter(String urlServidorLocal, int anioAcademicoIdSelect, int programaEducativoIdSelect, int cargaCursoId);
  Future<Map<String, dynamic>?> getDatosRubroFlutter(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int georeferenciaId, int usuarioId, int sesionAprendizajeDocenteId, int sesionAprendizajeAlumnoId, String? tareaId,List<dynamic> rubrosNoEnviados, bool contenidoExtra, int anioAcademicoId, int programaEducativoId, int empleadoId);
  Future<bool?> crearRubroEvaluacion(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int georeferenciaId, int usuarioId, Map<String, dynamic> dataSerial);
  Future<HttpStream> crearRubroEvaluacion2(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int georeferenciaId, int usuarioId, Map<String, dynamic> dataSerial, HttpSuccess httpSuccessListen);
  Future<bool?> updateEvaluacionRubroFlutter(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int georeferenciaId, int usuarioId, Map<String, dynamic> dataSerial);
  Future<HttpStream> updateEvaluacionRubroFlutter2(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int georeferenciaId, int usuarioId, Map<String, dynamic> dataSerial, HttpSuccess httpSuccessListen);
  Future<bool?> updateCompetenciaRubroFlutter(String urlServidorLocal, int georeferenciaId, int usuarioId, List<Map<String, dynamic>?> rubrosEnviados);
  Future<Map<String, dynamic>?> getUnidadTarea(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId);
  Future<Map<String, dynamic>?> getInfoTareaDocente(String urlServidorLocal, String? tareaId, int? silaboEventoId, int? unidadEventoId);
  Future<HttpStream> uploadFileArchivoDocente( String urlServidorLocal, int silaboEventoId, String nombre, File file, HttpProgressListen progressListen, HttpValueSuccess httpSuccessListen);
  Future<bool?> saveTareaDocente(String urlServidorLocal, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getSesionTarea(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int sesionAprendizajeId);
  Future<bool?> saveEstadoTareaDocente(String urlServidorLocal, String? tareaId, int? estadoId, int? usuarioId);
  Future<Map<String, dynamic>?> getMatrizResultado(String urlServidor, int? silaboEventoId, int? cargaCursoId, int? calendarioPeriodoId);
  Future<HttpStream?> uploadFileAgendaDocente(String urlServidorLocal, String nombre, File file, HttpProgressListen progressListen, HttpValueSuccess httpSuccessListen);
  Future<bool?> saveEventoDocente(String urlServidorLocal, Map<String, dynamic> data);
  Future<bool?> changeEventoEstadoDocente(String urlServidorLocal, String? eventoId, int? estadoId, bool? publicado, int? usuarioId);
  Future<bool?> saveTareaDocenteFlutter(String urlServidorLocal, Map<String, dynamic> data);
  Future<HttpStream> saveTareaEvalDocente(String urlServidorLocal, int? georeferenciaId, int? usuarioId, int? calendarioPeriodoId, int? silaboEventoId, int? unidadAprendizajeId, String? tareaId, Map<String, dynamic> dataSerial, HttpSuccess httpSuccessListen);
  Future<HttpStream> procesarEvaluacionTarea(String urlServidorLocal, int georeferenciaId, int usuarioId, int? calendarioPeriodoId, int? silaboEventoId, int? unidadEventoId, String? rubroEvalId, String? tareaId, HttpSuccess httpSuccessListen);
  Future<HttpStream> getUrlDownloadTareaEvaluacion(String urlServidorLocal, int? silaboEventoId, int? unidadAprendizajeId, String? tareaId, int? personaId, String? archivo, HttpSuccessValue2 httpSuccess);
  Future<List<dynamic>?> getSesionesHoy(String urlServidorLocal, int? anioAcademicoId, int? docenteId);
  Future<Map<String, dynamic>?> getAprendizajeSesion(String urlServidorLocal, int? sesionAprendizajeId);
  Future<HttpStream?> uploadFilePersona(String urlServidorLocal, PersonaUi? personaUi, File? foto, bool? soloCambiarFoto, bool? removeFoto, HttpProgressListen progressListen, HttpValueSuccess httpSuccessListen);
  Future<bool?> saveEstadoSesion(String urlServidorLocal, int? sesionAprendizajeId, int estado_hecho, List<EvaluacionFirebaseSesionUi> evaluacionFbSesionUiList, int usuarioId);
  Future<Map<String, dynamic>?> saveEstadoSesion2(String urlServidorLocal, int? sesionAprendizajeId, int? unidadAprendizajeId, int? silaboEventoId, int? periodoId, int? calendarioPeriodoId, List<EvaluacionFirebaseSesionUi> evaluacionFbSesionUiList, int usuarioId, int personaId);
  Future<List<dynamic>?> getActividadesSesion(String urlServidorLocal, int? sesionAprendizajeId);
  Future<Map<String, dynamic>?> updateUsuario(String urlServidorLocal, int usuarioId);
  Future<bool?> cerrarCursoDocente(String urlServidorLocal, int? cargaCursoId, int? calendarioPeriodoId, int usuarioId);
  Future<bool?> updResultadoFlutter(String urlServidorLocal, int? silaboEventoId, int? cargaCursoId, int? CalendarioPeriodoId, int usuarioId, List rubrosNoEnviados);
  Future<HttpStream?> uploadFileRubroEvidencia(String urlServidorLocal, String nombre, File file, HttpProgressListen progressListen, HttpValueSuccess httpSuccessListen);
  Future<Map<String, dynamic>?> getFirebaseGetEvaluaciones(String urlServidorLocal, int? silaboEventoId, int? tipoPeriodoId, int? unidadAprendizajeId, int? sesionAprendizajeId);
  Future<String?> getFechaActualServidor(String urlServidorLocal);
  Future<HttpStream?> uploadAsistenciaQR(String urlServidorLocal, String? codigo, int? anio, int? mes, int? dia, int? hora, int? minuto, int? segundo, HttpValueSuccess httpValueSuccess);
  Future<bool?> saveListaAsistenciaQR(String urlServidorLocal,List<AsistenciaQRUi> asistenciaQRUiList );
  Future<List<dynamic>?> getListaAsistencia(String urlServidorLocal, int anioAcademicoId, int min, int max, String search, String fechaInicio, String fechaFin);
}

abstract class HttpStream {
  void cancel();
  bool isFinished();
}
typedef HttpStreamListen = void Function(List<int> bytes, int? total);
typedef HttpProgressListen = void Function(double? progress);
typedef HttpValueSuccess = void Function(bool success, dynamic value);
typedef HttpSuccess = void Function(bool? success, bool sinConexion);
typedef HttpSuccessValue2 = void Function(dynamic? value, bool sinConexion);