import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class GetCompetenciaSesion extends UseCase<GetCompetenciaSesionResponse, GetCompetenciaSesionParams>{

  RubroRepository repository;

  GetCompetenciaSesion(this.repository);

  @override
  Future<Stream<GetCompetenciaSesionResponse?>> buildUseCaseStream(GetCompetenciaSesionParams? params)async {
    final controller = StreamController<GetCompetenciaSesionResponse>();
    try{

     // controller.add(GetCompetenciaSesionResponse(await repository.getCompetencia(params?.cargaCursoId??0)));
    controller.close();
    } catch (e) {
    logger.severe('EventoAgenda unsuccessful: '+e.toString());
    controller.addError(e);
    }
    return controller.stream;
  }

}

class GetCompetenciaSesionParams{

}

class GetCompetenciaSesionResponse{

}