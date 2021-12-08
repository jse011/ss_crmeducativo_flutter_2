import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_hoy_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_sesion_repository.dart';

class GetSesionesHoy extends UseCase<GetSesionesHoyResponse, GetSesionesHoyParams>{

  ConfiguracionRepository  configuracionRepository;
  HttpDatosRepository httpRepository;
  UnidadSesionRepository unidadSesionRepository;


  GetSesionesHoy(this.configuracionRepository, this.httpRepository,
      this.unidadSesionRepository);

  @override
  Future<Stream<GetSesionesHoyResponse?>> buildUseCaseStream(GetSesionesHoyParams? params) async{
    final controller = StreamController<GetSesionesHoyResponse>();
    bool offlineServidor = false;
    bool errorServidor = false;
    List<SesionHoyUi>?  sesionHoyList = null;
    int anioAcademicoId = await configuracionRepository.getSessionAnioAcademicoId();
    int empleadoId = await configuracionRepository.getSessionEmpleadoId();
    print("GetSesionesHoy");
    try{
      String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
      List<dynamic>? sesionHoyListData = await httpRepository.getSesionesHoy(urlServidorLocal,anioAcademicoId, empleadoId);
      errorServidor = sesionHoyListData==null;
        print("sesionHoyListData ${sesionHoyListData==null}");
      if(!errorServidor){
        sesionHoyList = unidadSesionRepository.transformarSesionHoy(sesionHoyListData);

      }
    }catch(e){
      offlineServidor = true;
    }
    controller.add(GetSesionesHoyResponse(offlineServidor, errorServidor, sesionHoyList));
    return controller.stream;
  }

}

class GetSesionesHoyParams{

  GetSesionesHoyParams();
}

class GetSesionesHoyResponse{
  bool datosOffline;
  bool errorServidor;
  List<SesionHoyUi>? sesionHoyUiList;

  GetSesionesHoyResponse(
      this.datosOffline, this.errorServidor, this.sesionHoyUiList);
}