import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:collection/collection.dart';

class GetFotoAlumnos extends UseCase<GetFotoAlumnosCaseResponse, GetFotoAlumnosCaseParams>{

  ConfiguracionRepository configuracionRepository;

  GetFotoAlumnos(this.configuracionRepository);


  @override
  Future<Stream<GetFotoAlumnosCaseResponse?>> buildUseCaseStream(GetFotoAlumnosCaseParams? params)async {
    final controller = StreamController<GetFotoAlumnosCaseResponse>();
    int anioAcademicoId = await configuracionRepository.getSessionAnioAcademicoId();
    int docenteId = await configuracionRepository.getSessionEmpleadoId();
    List<CursosUi> cursosUiList = await configuracionRepository.getFotoAlumnos(docenteId, anioAcademicoId);
    for(CursosUi cursosUi in cursosUiList){
      cursosUi.alumnoUiList?.sort((a1, a2){
        String nombre1 = a1.nombreCompleto??" ";
        String nombre2 = a2.nombreCompleto??" ";
        return nombre1.compareTo(nombre2);

      });
    }
    //cursosUiList.removeWhere((element) => element.cargaCursoId == null || element.cargaCursoId == 0);
    controller.add(GetFotoAlumnosCaseResponse(cursosUiList));
    controller.close();
    return controller.stream;
  }

}

class GetFotoAlumnosCaseParams {
  GetFotoAlumnosCaseParams();
}

/// Wrapping response inside an object makes it easier to change later
class GetFotoAlumnosCaseResponse {
  List<CursosUi> cursoUiList;

  GetFotoAlumnosCaseResponse(
      this.cursoUiList);
}