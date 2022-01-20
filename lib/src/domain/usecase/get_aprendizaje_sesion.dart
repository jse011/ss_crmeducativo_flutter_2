import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/desempenio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/icd_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_sesion_repository.dart';
import 'package:collection/collection.dart';

class GetAprendizaje extends UseCase<GetAprendizajeResponse, GetAprendizajeParams>{
  ConfiguracionRepository configuracionRepository;
  UnidadSesionRepository  unidadSesionRepository;
  HttpDatosRepository httpRepository;


  GetAprendizaje(
  this.httpRepository, this.configuracionRepository, this.unidadSesionRepository, );

  @override
  Future<Stream<GetAprendizajeResponse?>> buildUseCaseStream(GetAprendizajeParams? params) async{
    final controller = StreamController<GetAprendizajeResponse>();
    try {
      int usuarioId = await configuracionRepository.getSessionUsuarioId();
      bool offlineServidor = false;
      bool errorServidor = false;
      try{
        String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
        Map<String, dynamic>? unidadAprendizaje = await httpRepository.getAprendizajeSesion(urlServidorLocal,  params?.sesionAprendizajeId);
        errorServidor = unidadAprendizaje==null;
        if(!errorServidor){
          await unidadSesionRepository.saveAprendizajeSesion(params?.sesionAprendizajeId,  unidadAprendizaje);
        }
      }catch(e){
        offlineServidor = true;
      }

      SesionUi sesionUi =  await unidadSesionRepository.getAprendizajeSesion(params?.sesionAprendizajeId);
      List<CompetenciaUi> competenciaUiList = sesionUi.competenciaUiList??[];
      List<TemaCriterioUi>? temaCriterioUiList = [];
      for(CompetenciaUi competenciaUi in competenciaUiList){
        for(CapacidadUi capacidadUi in competenciaUi.capacidadUiList??[]){
          for(DesempenioUi desempenioUi in capacidadUi.desempenioUiList??[]){
            for(IcdUi icdUi in desempenioUi.icdUiList??[]){
              for(TemaCriterioUi temaCriterioUi in icdUi.temaCriterioUiList??[]){
                TemaCriterioUi? filter = temaCriterioUiList.firstWhereOrNull((element) => element.campoTematicoId == temaCriterioUi.campoTematicoId);
                if(filter==null)temaCriterioUiList.add(temaCriterioUi);
              }

            }
          }

        }
      }
      controller.add(GetAprendizajeResponse(errorServidor, offlineServidor, competenciaUiList, temaCriterioUiList, sesionUi.recursosUiList));
      controller.close();

    } catch (e) {
      logger.severe('GetAprendizaje unsuccessful: '+e.toString());
      // Trigger .onError
      controller.addError(e);

    }
    return controller.stream;
  }
}

class GetAprendizajeParams {
  int? sesionAprendizajeId;

  GetAprendizajeParams(this.sesionAprendizajeId);

}

class GetAprendizajeResponse {
  bool datosOffline;
  bool errorServidor;
  List<CompetenciaUi>? competenciaUiList;
  List<TemaCriterioUi>? temaCriterioUiList;
  List<SesionRecursoUi>? sesionRecursoUiList;

  GetAprendizajeResponse(
      this.datosOffline, this.errorServidor, this.competenciaUiList, this.temaCriterioUiList, this.sesionRecursoUiList);
}
