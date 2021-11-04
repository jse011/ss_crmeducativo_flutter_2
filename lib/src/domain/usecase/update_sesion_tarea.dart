import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class UpdateSesionTarea extends UseCase<GetSesionTareaResponse, GetSesionTareaParams>{
  ConfiguracionRepository configuracionRepository;
  UnidadTareaRepository  unidadTareaRepository;
  HttpDatosRepository httpRepository;


  UpdateSesionTarea(
  this.httpRepository, this.configuracionRepository, this.unidadTareaRepository, );

  @override
  Future<Stream<GetSesionTareaResponse?>> buildUseCaseStream(GetSesionTareaParams? params) async{
    final controller = StreamController<GetSesionTareaResponse>();
    try {

      executeServidor() async{
        bool offlineServidor = false;
        bool errorServidor = false;
        try{
          String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
          Map<String, dynamic>? unidadTareaSesion = await httpRepository.getSesionTarea(urlServidorLocal, params?.calendarioPeridoId??0,  params?.silaboEventoId??0, params?.sesionAprendizajeId??0);
          errorServidor = unidadTareaSesion==null;
          if(!errorServidor){
            await unidadTareaRepository.saveSesionTarea(unidadTareaSesion,  params?.calendarioPeridoId??0,  params?.silaboEventoId??0, params?.sesionAprendizajeId??0);
          }
        }catch(e){
          print(e);
          offlineServidor = true;
        }

        List<TareaUi> tareaUIList = await unidadTareaRepository.getSesionTarea( params?.calendarioPeridoId??0,  params?.silaboEventoId??0,  params?.sesionAprendizajeId??0);

        controller.add(GetSesionTareaResponse(errorServidor, offlineServidor, tareaUIList));
        controller.close();
      }

      executeServidor().catchError((e) {
        controller.addError(e);
        // Finally, callback fires.
        // throw Exception(e);              // Future completes with 42.
      });

    } catch (e) {
      logger.severe('GetUnidadSesion unsuccessful: '+e.toString());
      // Trigger .onError
      controller.addError(e);

    }
    return controller.stream;
  }
}

class GetSesionTareaParams {
  int? calendarioPeridoId;
  int? silaboEventoId;
  int? sesionAprendizajeId;
  GetSesionTareaParams(this.calendarioPeridoId, this.silaboEventoId, this.sesionAprendizajeId);

}

class GetSesionTareaResponse {
  bool datosOffline;
  bool errorServidor;
  List<TareaUi> tareaUiList;

  GetSesionTareaResponse(
      this.datosOffline, this.errorServidor, this.tareaUiList);
}
