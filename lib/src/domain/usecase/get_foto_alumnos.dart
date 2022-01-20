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

    }
    controller.add(GetFotoAlumnosCaseResponse(cursosUiList));
    controller.close();
    return controller.stream;
  }

  List<dynamic> agregarCabecera(List<ContactoUi> contactoUiList, int tipo){
    List<dynamic> list = [];
    contactoUiList.sort((a1, a2){
      String nombre1 = a1.personaUi?.nombreCompleto??" ";
      String nombre2 = a2.personaUi?.nombreCompleto??" ";
      return nombre1.compareTo(nombre2);

    });
    for(ContactoUi contactoUi in contactoUiList){
      if(tipo == contactoUi.tipo){
        String letra = (contactoUi.personaUi?.nombreCompleto??"").isNotEmpty?(contactoUi.personaUi?.nombreCompleto??"")[0]:" ";
        String? cabecera = list.firstWhereOrNull((element)=>element==letra);
        if(cabecera==null)list.add(letra);
        list.add(contactoUi);
      }
    }
    return list;
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