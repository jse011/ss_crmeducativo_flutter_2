import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class GetTipoNota extends UseCase<GetTipoNotaResponse, GetTipoNotaParms>{
  ConfiguracionRepository configuracionRepository;
  RubroRepository repository;

  GetTipoNota(this.configuracionRepository, this.repository);

  @override
  Future<Stream<GetTipoNotaResponse?>> buildUseCaseStream(GetTipoNotaParms? params) async{
    final controller = StreamController<GetTipoNotaResponse>();
    try{
      int programaEducativoId = await configuracionRepository.getSessionProgramaEducativoId();

      TipoNotaUi? tipoNotaUi = null;
      List<TipoNotaUi> tipoNotaUiList = await repository.getGetTipoNota(programaEducativoId);
      if(tipoNotaUiList.isNotEmpty)tipoNotaUi = tipoNotaUiList[0];
      controller.add(GetTipoNotaResponse(tipoNotaUiList,tipoNotaUi));
      controller.close();
    } catch (e) {
      logger.severe('GetTipoNota unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }


}

class GetTipoNotaParms{

}

class GetTipoNotaResponse{
  List<TipoNotaUi> tipoNotaUiList;
  TipoNotaUi? tipoEvaluacionUi;

  GetTipoNotaResponse(this.tipoNotaUiList, this.tipoEvaluacionUi);
}