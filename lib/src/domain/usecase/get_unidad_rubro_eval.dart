import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class GetUnidadRubroEval extends UseCase<GetUnidadRubroEvalResponse, GetUnidadRubroEvalParams>{
  RubroRepository repository;

  GetUnidadRubroEval(this.repository);

  @override
  Future<Stream<GetUnidadRubroEvalResponse?>> buildUseCaseStream(GetUnidadRubroEvalParams? params) async{
    final controller = StreamController<GetUnidadRubroEvalResponse>();
    try{
      List<UnidadUi> unidadUiList = await repository.getUnidadAprendizaje(params?.silaboEventoId, params?.calendarioPeriodoId);
      controller.add(GetUnidadRubroEvalResponse(unidadUiList));


    controller.close();
    } catch (e) {
    logger.severe('GetUnidadRubroEval unsuccessful: '+e.toString());
    controller.addError(e);
    }
    return controller.stream;
  }

}

class GetUnidadRubroEvalResponse {
  List<UnidadUi> unidadUiList;

  GetUnidadRubroEvalResponse(this.unidadUiList);
}

class GetUnidadRubroEvalParams {
  int? calendarioPeriodoId;
  int? silaboEventoId;

  GetUnidadRubroEvalParams(this.calendarioPeriodoId, this.silaboEventoId);
}