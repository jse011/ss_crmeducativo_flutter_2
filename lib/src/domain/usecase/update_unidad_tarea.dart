import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class UpdateUnidadTarea extends UseCase<GetUnidadTareaResponse, GetUnidadTareaParams>{
  ConfiguracionRepository configuracionRepository;
  UnidadTareaRepository  unidadTareaRepository;
  HttpDatosRepository httpRepository;


  UpdateUnidadTarea(
  this.httpRepository, this.configuracionRepository, this.unidadTareaRepository, );

  @override
  Future<Stream<GetUnidadTareaResponse?>> buildUseCaseStream(GetUnidadTareaParams? params) async{
    final controller = StreamController<GetUnidadTareaResponse>();
    try {

      executeServidor() async{
        bool offlineServidor = false;
        bool errorServidor = false;
        try{
          String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
          Map<String, dynamic>? unidadSesion = await httpRepository.getUnidadTarea(urlServidorLocal, params?.calendarioPeridoId??0,  params?.silaboEventoId??0);
          errorServidor = unidadSesion==null;
          if(!errorServidor){
            await unidadTareaRepository.saveUnidadTarea(unidadSesion,  params?.calendarioPeridoId??0,  params?.silaboEventoId??0);
          }
        }catch(e){
          print(e);
          offlineServidor = true;
        }

        List<UnidadUi> eventoUIList = await unidadTareaRepository.getUnidadTarea( params?.calendarioPeridoId??0,  params?.silaboEventoId??0);

        controller.add(GetUnidadTareaResponse(errorServidor, offlineServidor, eventoUIList));
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

class GetUnidadTareaParams {
  int? calendarioPeridoId;
  int? silaboEventoId;

  GetUnidadTareaParams(this.calendarioPeridoId, this.silaboEventoId);

}

class GetUnidadTareaResponse {
  bool datosOffline;
  bool errorServidor;
  List<UnidadUi> unidadUiList;

  GetUnidadTareaResponse(
      this.datosOffline, this.errorServidor, this.unidadUiList);
}
