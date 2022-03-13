import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_firebase_sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_hoy_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_sesion_repository.dart';

class GetEvaluacionSesionesFirebase extends UseCase<GetEvaluacionSesionesFirebaseResponse, GetEvaluacionSesionesFirebaseParams>{

  ConfiguracionRepository  configuracionRepository;
  HttpDatosRepository httpRepository;
  UnidadSesionRepository unidadSesionRepository;


  GetEvaluacionSesionesFirebase(this.configuracionRepository, this.httpRepository,
      this.unidadSesionRepository);

  @override
  Future<Stream<GetEvaluacionSesionesFirebaseResponse?>> buildUseCaseStream(GetEvaluacionSesionesFirebaseParams? params) async{
    final controller = StreamController<GetEvaluacionSesionesFirebaseResponse>();
    bool offlineServidor = false;
    bool errorServidor = false;
    Map<EvaluacionFirebaseTipoUi?, List<EvaluacionFirebaseSesionUi>>?  evaluacionFirebaseUiMap = Map();

    try{
      String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
      int sessionAprendizajeId = 0;
      int sessionAprendizajeAlumnoId = 0;
      int sessionAprendizajeDocenteId = 0;

      if ((params?.sesionUi?.rolId ?? 0) == 6) {
        sessionAprendizajeId = params?.sesionUi?.sesionAprendizajeId ?? 0;
        sessionAprendizajeDocenteId =
            params?.sesionUi?.sesionAprendizajePadreId ?? 0;
        sessionAprendizajeAlumnoId = params?.sesionUi?.sesionAprendizajeId ?? 0;
      } else {
        sessionAprendizajeDocenteId =
            params?.sesionUi?.sesionAprendizajeId ?? 0;
      }
      Map<String, dynamic>? evalaucionesSesionesData = await httpRepository.getFirebaseGetEvaluaciones(urlServidorLocal,params?.silaboEventoId, params?.tipoPeriodoId, params?.unidadAprendizajeId, sessionAprendizajeAlumnoId);
      errorServidor = evalaucionesSesionesData==null;

      if(!errorServidor){
        for(EvaluacionFirebaseSesionUi item in unidadSesionRepository.transformarEvaluacionesData(evalaucionesSesionesData)??[]){
          if( evaluacionFirebaseUiMap[item.tipo]==null) evaluacionFirebaseUiMap[item.tipo] = [];

          evaluacionFirebaseUiMap[item.tipo]?.add(item);
        }
      }
    }catch(e){
      offlineServidor = true;
      print("error ${e}");
    }
    controller.add(GetEvaluacionSesionesFirebaseResponse(offlineServidor, errorServidor, evaluacionFirebaseUiMap));
    return controller.stream;
  }
}

class GetEvaluacionSesionesFirebaseParams{
  int? silaboEventoId;
  int? tipoPeriodoId;
  int? unidadAprendizajeId;
  SesionUi? sesionUi;

  GetEvaluacionSesionesFirebaseParams(this.silaboEventoId, this.tipoPeriodoId,
      this.unidadAprendizajeId, this.sesionUi);
}

class GetEvaluacionSesionesFirebaseResponse{
  bool datosOffline;
  bool errorServidor;
  Map<EvaluacionFirebaseTipoUi?, List<EvaluacionFirebaseSesionUi>>? evaluacionFirebaseUiMap;

  GetEvaluacionSesionesFirebaseResponse(
      this.datosOffline, this.errorServidor, this.evaluacionFirebaseUiMap);
}