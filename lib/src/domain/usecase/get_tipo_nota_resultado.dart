import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class GetTipoNotaResultado extends UseCase<GetTipoNotaResultadoResponse, GetTipoNotaResultadoParms>{
  RubroRepository repository;

  GetTipoNotaResultado(this.repository);

  @override
  Future<Stream<GetTipoNotaResultadoResponse?>> buildUseCaseStream(GetTipoNotaResultadoParms? params) async{
    final controller = StreamController<GetTipoNotaResultadoResponse>();
    try{

      TipoNotaUi? tipoNotaUi = await repository.getGetTipoNotaResultado(params?.silaboEventoId);
      controller.add(GetTipoNotaResultadoResponse(tipoNotaUi));
      controller.close();
    } catch (e) {
      logger.severe('GetTipoNota unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetTipoNotaResultadoParms{
  int? silaboEventoId;
  GetTipoNotaResultadoParms(this.silaboEventoId);
}

class GetTipoNotaResultadoResponse{
  TipoNotaUi? tipoEvaluacionUi;
  GetTipoNotaResultadoResponse(this.tipoEvaluacionUi);
}