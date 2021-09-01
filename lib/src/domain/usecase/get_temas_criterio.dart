import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class GetTemaCriterios extends UseCase<GetTemaCriteriosResponse, GetTemaCriteriosParms>{

  RubroRepository repository;

  GetTemaCriterios(this.repository);

  @override
  Future<Stream<GetTemaCriteriosResponse?>> buildUseCaseStream(GetTemaCriteriosParms? params) async{
    final controller = StreamController<GetTemaCriteriosResponse>();
    try{
      List<CompetenciaUi> temaCriterioUiList = await repository.getTemasCriterios(params?.calendarioPeriodoId??0, params?.silaboEventoId??0);
      controller.add(GetTemaCriteriosResponse(temaCriterioUiList));
      controller.close();
    } catch (e) {
      logger.severe('GetTemaCriterios unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }


}

class GetTemaCriteriosParms{
    int? calendarioPeriodoId;
    int? silaboEventoId;

    GetTemaCriteriosParms(this.calendarioPeriodoId, this.silaboEventoId);
}

class GetTemaCriteriosResponse{
  List<CompetenciaUi> competenciaUiList;

  GetTemaCriteriosResponse(this.competenciaUiList);
}