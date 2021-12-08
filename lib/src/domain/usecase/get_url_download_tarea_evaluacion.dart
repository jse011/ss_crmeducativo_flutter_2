import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/drive_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_archivo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class GetUrlDownloadTareaEvaluacion {

  ConfiguracionRepository _configuracionRepository;
  HttpDatosRepository _httpDatosRepository;
  UnidadTareaRepository _unidadTareaRepository;

  GetUrlDownloadTareaEvaluacion(this._configuracionRepository,
      this._httpDatosRepository, this._unidadTareaRepository);

  Future<HttpStream?> execute(GetUrlDownloadTareaEvalParams params, UploadSuccessListen successListen) async{
    String urlServidorLocal = await _configuracionRepository.getSessionUsuarioUrlServidor();
    return _httpDatosRepository.getUrlDownloadTareaEvaluacion(urlServidorLocal, params.tareaUi?.silaboEventoId, params.tareaUi?.unidadAprendizajeId, params.tareaUi?.tareaId, params.tareaAlumnoArchivoUi?.alumnoId, params.tareaAlumnoArchivoUi?.nombre,
            (value, sinConexion)async {
              if(value==null){
                params.tareaAlumnoArchivoUi?.driveId = await _unidadTareaRepository.getDriveIdTareaAlumno(params.tareaAlumnoArchivoUi?.tareaAlumnoArchivoId);
                successListen.call(GetUrlDownloadTareaEvalResponse(false, sinConexion, true, false, params.tareaAlumnoArchivoUi));
              }else if(value is Map<String, dynamic> && value.containsKey("idDrive")){
                await _unidadTareaRepository.saveDriveIdTareaAlumno(value, params.tareaAlumnoArchivoUi?.tareaAlumnoArchivoId);
                params.tareaAlumnoArchivoUi?.driveId = await _unidadTareaRepository.getDriveIdTareaAlumno(params.tareaAlumnoArchivoUi?.tareaAlumnoArchivoId);
                successListen.call(GetUrlDownloadTareaEvalResponse(true, sinConexion, false, false, params.tareaAlumnoArchivoUi));
              }else{
                print("ProcesarTareaEvaluacion :/ error");
                params.tareaAlumnoArchivoUi?.driveId = await _unidadTareaRepository.getDriveIdTareaAlumno(params.tareaAlumnoArchivoUi?.tareaAlumnoArchivoId);
                successListen.call(GetUrlDownloadTareaEvalResponse(false, sinConexion, false, false, params.tareaAlumnoArchivoUi));
              }


            });
  }
}

class GetUrlDownloadTareaEvalResponse{
  bool success;
  bool offline;
  bool errorServidor;
  bool errorInterno;
  TareaAlumnoArchivoUi? tareaAlumnoArchivoUi;

  GetUrlDownloadTareaEvalResponse(this.success, this.offline,
      this.errorServidor, this.errorInterno, this.tareaAlumnoArchivoUi);
}

class GetUrlDownloadTareaEvalParams{
  TareaUi? tareaUi;
  TareaAlumnoArchivoUi? tareaAlumnoArchivoUi;

  GetUrlDownloadTareaEvalParams(this.tareaAlumnoArchivoUi, this.tareaUi);
}

typedef UploadSuccessListen = void Function(GetUrlDownloadTareaEvalResponse response);
