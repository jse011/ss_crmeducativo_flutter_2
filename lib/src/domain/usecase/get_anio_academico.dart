import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/anio_academico_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/georeferencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class GetAnioAcademico extends UseCase<GetAnioAcademicoResponse, GetAnioAcademicoParams>{
  ConfiguracionRepository repository;

  GetAnioAcademico(this.repository);

  @override
  Future<Stream<GetAnioAcademicoResponse?>> buildUseCaseStream(GetAnioAcademicoParams? params) async {
    final controller = StreamController<GetAnioAcademicoResponse>();

    try {
      int usuarioId = await repository.getSessionUsuarioId();
      AnioAcademicoUi? anioAcademicoUiSelected = null;

      List<GeoreferenciaUi> georeferenciaUiList = await repository.getGeoreferenciaList(usuarioId);
      int anioAcademicoId = await repository.getSessionAnioAcademicoId();
      for(GeoreferenciaUi georeferenciaUi in georeferenciaUiList){

        for(AnioAcademicoUi anioAcademicoUi in georeferenciaUi.anioAcademicoUiList??[]){
          anioAcademicoUi.toogle = anioAcademicoUi.anioAcademicoId == anioAcademicoId;
          if(anioAcademicoUi.toogle??false){
            anioAcademicoUiSelected = anioAcademicoUi;
          }
        }

        if(anioAcademicoUiSelected==null){
          for (AnioAcademicoUi anioAcademicoUi in georeferenciaUi.anioAcademicoUiList??[]) {
            if (anioAcademicoUi.vigente??false) {
              anioAcademicoUiSelected = anioAcademicoUi;
              repository.updateSessionAnioAcademicoId(anioAcademicoUi.anioAcademicoId??0);
            }
          }
        }

        if(anioAcademicoUiSelected == null && (georeferenciaUi.anioAcademicoUiList??[]).isNotEmpty){
          anioAcademicoUiSelected = georeferenciaUi.anioAcademicoUiList![0];
        }

      }



      controller.add(GetAnioAcademicoResponse(georeferenciaUiList, anioAcademicoUiSelected));
      logger.finest('GetAnioAcademico successful.');
      controller.close();
    } catch (e) {
      logger.severe('GetAnioAcademico unsuccessful: ' + e.toString());
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

}

class GetAnioAcademicoParams {

}

class GetAnioAcademicoResponse {
  List<GeoreferenciaUi> georeferenciaUiList;
  AnioAcademicoUi? anioAcademicoUi;
  GetAnioAcademicoResponse(this.georeferenciaUiList, this.anioAcademicoUi);

}