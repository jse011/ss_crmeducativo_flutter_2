import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/forma_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class GetFormaEvaluacion extends UseCase<GetFormaEvaluacionResponse, GetFormaEvaluacionParams>{

  RubroRepository repository;

  GetFormaEvaluacion(this.repository);

  @override
  Future<Stream<GetFormaEvaluacionResponse?>> buildUseCaseStream(GetFormaEvaluacionParams? params) async{
    final controller = StreamController<GetFormaEvaluacionResponse>();
    try{
      FormaEvaluacionUi? formaEvaluacionUi = null;
      List<FormaEvaluacionUi> formaEvaluacionUiList = await repository.getGetFormaEvaluacion();
      if(formaEvaluacionUiList.isNotEmpty)formaEvaluacionUi = formaEvaluacionUiList[0];
      controller.add(GetFormaEvaluacionResponse(formaEvaluacionUiList,formaEvaluacionUi));
    controller.close();
    } catch (e) {
    logger.severe('GetFormaEvaluacion unsuccessful: '+e.toString());
    controller.addError(e);
    }
    return controller.stream;
  }

}
class GetFormaEvaluacionResponse{
  List<FormaEvaluacionUi> formaEvaluacionUiList;
  FormaEvaluacionUi? formaEvaluacionUi;
  GetFormaEvaluacionResponse(this.formaEvaluacionUiList, this.formaEvaluacionUi);
}
class GetFormaEvaluacionParams {

}