import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';

class GetCurso extends UseCase<GetCursoResponse, GetCursoParams>{
  ConfiguracionRepository repository;


  GetCurso(this.repository);

  @override
  Future<Stream<GetCursoResponse?>> buildUseCaseStream(GetCursoParams? params) async{
    final controller = StreamController<GetCursoResponse>();
    try{

      controller.add(GetCursoResponse(await repository.getCurso(params?.cargaCursoId??0)));
      controller.close();
    } catch (e) {
      logger.severe('EventoAgenda unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }

}
class GetCursoParams{
  int cargaCursoId;

  GetCursoParams(this.cargaCursoId);
}
class GetCursoResponse{
   CursosUi? cursoUi;

   GetCursoResponse(this.cursoUi);

}