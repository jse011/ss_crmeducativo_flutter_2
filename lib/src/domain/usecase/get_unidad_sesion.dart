import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_sesion_repository.dart';

class GetUnidadSesion extends UseCase<GetUnidadSesionResponse, GetUnidadSesionParams>{
  ConfiguracionRepository configuracionRepository;
  UnidadSesionRepository  unidadSesionRepository;
  HttpDatosRepository httpRepository;


  GetUnidadSesion(
  this.httpRepository, this.configuracionRepository, this.unidadSesionRepository, );

  @override
  Future<Stream<GetUnidadSesionResponse?>> buildUseCaseStream(GetUnidadSesionParams? params) async{
    final controller = StreamController<GetUnidadSesionResponse>();
    try {
      int usuarioId = await configuracionRepository.getSessionUsuarioId();
      executeServidor() async{
        bool offlineServidor = false;
        bool errorServidor = false;
        List<UnidadUi> eventoUIList = [];
        if((params?.calendarioPeridoId??0)>0){
          try{
            String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
            Map<String, dynamic>? unidadSesion = await httpRepository.getUnidadSesion(urlServidorLocal, usuarioId,  params?.calendarioPeridoId??0,  params?.silaboEventoId??0, params?.rolId??0);
            errorServidor = unidadSesion==null;
            if(!errorServidor){
              await unidadSesionRepository.saveUnidadSesion(unidadSesion, usuarioId,  params?.calendarioPeridoId??0,  params?.silaboEventoId??0, params?.rolId??0);
            }
          }catch(e){
            offlineServidor = true;
          }
          print("unidadUIList rolId: ${params?.rolId}");
          eventoUIList = await unidadSesionRepository.getUnidadSesion(usuarioId, params?.calendarioPeridoId??0,  params?.silaboEventoId??0, params?.rolId??0);
          for(UnidadUi unidadUi in eventoUIList){
            unidadUi.cantSesionesVisibles = 3;
          }
        }

        controller.add(GetUnidadSesionResponse(errorServidor, offlineServidor, eventoUIList));
        controller.close();
      }

      executeServidor().catchError((e) {
        controller.addError(e);
        // Finally, callback fires.
        // throw Exception(e);              // Future completes with 42.
      }).timeout(const Duration (seconds:60),onTimeout : () {
        throw Exception("GetUnidadSesion timeout 60 seconds");
      });

    } catch (e) {
      logger.severe('GetUnidadSesion unsuccessful: '+e.toString());
      // Trigger .onError
      controller.addError(e);

    }
    return controller.stream;
  }
}

class GetUnidadSesionParams {
  int? calendarioPeridoId;
  int? silaboEventoId;
  int? rolId;

  GetUnidadSesionParams(this.calendarioPeridoId, this.silaboEventoId, this.rolId);

}

class GetUnidadSesionResponse {
  bool datosOffline;
  bool errorServidor;
  List<UnidadUi> unidadUiList;

  GetUnidadSesionResponse(
      this.datosOffline, this.errorServidor, this.unidadUiList);
}
