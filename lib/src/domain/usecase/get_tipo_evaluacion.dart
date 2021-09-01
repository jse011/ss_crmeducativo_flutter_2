import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class GetTipoEvaluacion extends UseCase<GetTipoEvaluacionResponse, GetTipoEvaluacionParms>{
  RubroRepository repository;

  GetTipoEvaluacion(this.repository);

  @override
  Future<Stream<GetTipoEvaluacionResponse?>> buildUseCaseStream(GetTipoEvaluacionParms? params) async{
    final controller = StreamController<GetTipoEvaluacionResponse>();
    try{
      TipoEvaluacionUi? tipoEvaluacionUi = null;
      List<TipoEvaluacionUi> tipoEvaluacionUiList = await repository.getGetTipoEvaluacion();
      if(tipoEvaluacionUiList.isNotEmpty)tipoEvaluacionUi = tipoEvaluacionUiList[0];
      controller.add(GetTipoEvaluacionResponse(tipoEvaluacionUiList,tipoEvaluacionUi));
      controller.close();
    } catch (e) {
      logger.severe('GetTipoEvaluacion unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }


}

class GetTipoEvaluacionParms{

}

class GetTipoEvaluacionResponse{
  List<TipoEvaluacionUi> tipoEvaluacionUiList;
  TipoEvaluacionUi? tipoEvaluacionUi;

  GetTipoEvaluacionResponse(this.tipoEvaluacionUiList, this.tipoEvaluacionUi);
}