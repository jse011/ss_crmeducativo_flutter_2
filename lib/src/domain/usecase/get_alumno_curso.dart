import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';

class GetAlumnoCurso extends UseCase<GetAlumnoCursoResponse, GetAlumnoCursoParams>{

  ConfiguracionRepository repository;

  GetAlumnoCurso(this.repository);

  @override
  Future<Stream<GetAlumnoCursoResponse?>> buildUseCaseStream(GetAlumnoCursoParams? params)async {
    final controller = StreamController<GetAlumnoCursoResponse>();
    try{
      controller.add(GetAlumnoCursoResponse(await repository.getListAlumnoCurso(params?.cargaCursoId??0)));
    controller.close();
    } catch (e) {
    logger.severe('GetTemaCriterios unsuccessful: '+e.toString());
    controller.addError(e);
    }
    return controller.stream;
  }

}

class GetAlumnoCursoResponse{
  List<PersonaUi> contactoUiList;

  GetAlumnoCursoResponse(this.contactoUiList);
}
class GetAlumnoCursoParams{
  int? cargaCursoId;

  GetAlumnoCursoParams(this.cargaCursoId);

}
