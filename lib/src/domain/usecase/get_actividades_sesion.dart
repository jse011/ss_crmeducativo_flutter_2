import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/actividad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/desempenio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/icd_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_sesion_repository.dart';
import 'package:collection/collection.dart';

class GetActividadesSesion extends UseCase<GetActividadesSesionResponse, GetActividadesSesionParams>{
  ConfiguracionRepository configuracionRepository;
  UnidadSesionRepository  unidadSesionRepository;
  HttpDatosRepository httpRepository;


  GetActividadesSesion(
  this.httpRepository, this.configuracionRepository, this.unidadSesionRepository, );

  @override
  Future<Stream<GetActividadesSesionResponse?>> buildUseCaseStream(GetActividadesSesionParams? params) async{
    final controller = StreamController<GetActividadesSesionResponse>();
    try {
      int usuarioId = await configuracionRepository.getSessionUsuarioId();
      bool offlineServidor = false;
      bool errorServidor = false;
      try{
        String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
        List<dynamic>? actividades = await httpRepository.getActividadesSesion(urlServidorLocal,  params?.sesionAprendizajeId);
        errorServidor = actividades==null;
        if(!errorServidor){
          await unidadSesionRepository.saveActividadesSesion(params?.sesionAprendizajeId,  actividades);
        }
      }catch(e){
        offlineServidor = true;
      }

      SesionUi sesionUi =  await unidadSesionRepository.getActividadSesion(params?.sesionAprendizajeId);
      controller.add(GetActividadesSesionResponse(errorServidor, offlineServidor, sesionUi));
      controller.close();

    } catch (e) {
      logger.severe('GetAprendizaje unsuccessful: '+e.toString());
      // Trigger .onError
      controller.addError(e);

    }
    return controller.stream;
  }
}

class GetActividadesSesionParams {
  int? sesionAprendizajeId;

  GetActividadesSesionParams(this.sesionAprendizajeId);

}

class GetActividadesSesionResponse {
  bool datosOffline;
  bool errorServidor;
  SesionUi? sesionUi;

  GetActividadesSesionResponse(
      this.datosOffline, this.errorServidor, this.sesionUi);
}
