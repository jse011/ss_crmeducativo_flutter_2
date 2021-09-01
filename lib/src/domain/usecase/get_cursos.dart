import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';

class GetCursos extends UseCase<GetCursosResponse, GetCursosParams>{
  ConfiguracionRepository repository;


  GetCursos(this.repository);

  @override
  Future<Stream<GetCursosResponse?>> buildUseCaseStream(GetCursosParams? params) async{
    final controller = StreamController<GetCursosResponse>();
    try{


      int empleadoId = await repository.getSessionEmpleadoId();
      int anioAcademicoIdSelect = await repository.getSessionAnioAcademicoId();

      controller.add(GetCursosResponse(await repository.getListCursos(empleadoId, anioAcademicoIdSelect, params!.programaEducativoId)));
      controller.close();
    } catch (e) {
      logger.severe('EventoAgenda unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }

}
class GetCursosParams{
  int programaEducativoId;

  GetCursosParams(this.programaEducativoId);
}
class GetCursosResponse{
  List<CursosUi> cursolist;
  GetCursosResponse(this.cursolist);
}