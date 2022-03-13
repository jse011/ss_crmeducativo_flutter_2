import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/asistencia_qr_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';

class GetFechaActualAsistenciaQR extends UseCase<GetFechaActualAsistenciaQRResponse, GetFechaActualAsistenciaQRParams>{
  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpRepository;
  GetFechaActualAsistenciaQR(this.configuracionRepository, this.httpRepository);

  @override
  Future<Stream<GetFechaActualAsistenciaQRResponse?>> buildUseCaseStream(GetFechaActualAsistenciaQRParams? params) async{
    final controller = StreamController<GetFechaActualAsistenciaQRResponse>();
    bool offlineServidor = false;
    bool errorServidor = false;
    DateTime? dfechaServidor = null;
    try{
      String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
      String? fechaServidor = await httpRepository.getFechaActualServidor(urlServidorLocal);
      errorServidor = fechaServidor==null;

      if(!errorServidor){

        List<String> datos = fechaServidor.split("|");
        String fecha = "";
        String hora = "";
        if(datos.isNotEmpty){
          fecha = datos[0];
          if(datos.length>1){
            hora = datos[1];
          }
        }

        dfechaServidor = await DomainTools.convertDateTimePtBR(fecha, hora);

        if(dfechaServidor.year <= 2000){
          dfechaServidor = DateTime.now();
        }

      }else{
        dfechaServidor = DateTime.now();
      }
    }catch(e){
      offlineServidor = true;
      dfechaServidor = DateTime.now();
      print("error ${e}");
    }
    print("fechaServidor1: ${dfechaServidor!=null}");
    controller.add(GetFechaActualAsistenciaQRResponse(offlineServidor, errorServidor, dfechaServidor));
    return controller.stream;
  }

}

class GetFechaActualAsistenciaQRResponse{
  bool? offlineServidor;
  bool? errorServidor;
  DateTime? dfechaServidor;

  GetFechaActualAsistenciaQRResponse(
      this.offlineServidor, this.errorServidor, this.dfechaServidor);
}

class GetFechaActualAsistenciaQRParams{

}