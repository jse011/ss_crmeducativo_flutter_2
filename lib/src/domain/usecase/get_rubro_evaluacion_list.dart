import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class GetRubroEvaluacionList extends UseCase<GetRubroEvaluacionListResponse, GetRubroEvaluacionListParms>{

  RubroRepository repository;

  GetRubroEvaluacionList(this.repository);

  @override
  Future<Stream<GetRubroEvaluacionListResponse?>> buildUseCaseStream(GetRubroEvaluacionListParms? params) async{
    final controller = StreamController<GetRubroEvaluacionListResponse>();
    try{

      controller.add(GetRubroEvaluacionListResponse(await repository.getRubroEvaluacionList(params?.calendarioPeriodoId??0, params?.silaboEventoId??0, params?.origenRubroUi??OrigenRubroUi.TODOS)));
      controller.close();
    } catch (e) {
      logger.severe('GetTemaCriterios unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }


}

class GetRubroEvaluacionListParms{
    int? calendarioPeriodoId;
    int? silaboEventoId;
    OrigenRubroUi? origenRubroUi;

    GetRubroEvaluacionListParms(this.calendarioPeriodoId, this.silaboEventoId, this.origenRubroUi);
}

class GetRubroEvaluacionListResponse{
  List<RubricaEvaluacionUi> rubricaEvaluacionList;

  GetRubroEvaluacionListResponse(this.rubricaEvaluacionList);
}