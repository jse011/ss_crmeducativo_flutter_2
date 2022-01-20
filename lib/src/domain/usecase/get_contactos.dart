import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:collection/collection.dart';

class GetContactos extends UseCase<GetContactosCaseResponse, GetContactosCaseParams>{

  ConfiguracionRepository configuracionRepository;

  GetContactos(this.configuracionRepository);


  @override
  Future<Stream<GetContactosCaseResponse?>> buildUseCaseStream(GetContactosCaseParams? params)async {
    final controller = StreamController<GetContactosCaseResponse>();
    int anioAcademicoId = await configuracionRepository.getSessionAnioAcademicoId();
    int docenteId = await configuracionRepository.getSessionEmpleadoId();
    List<ContactoUi> contactoUIList = await configuracionRepository.getListContacto(docenteId, anioAcademicoId);
    controller.add(GetContactosCaseResponse(agregarCabecera(contactoUIList, ConfiguracionRepository.CONTACTO_ALUMNO), agregarCabecera(contactoUIList, ConfiguracionRepository.CONTACTO_DOCENTE), agregarCabecera(contactoUIList, ConfiguracionRepository.CONTACTO_DIRECTIVO)));
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

class GetContactosCaseParams {
  GetContactosCaseParams();
}

/// Wrapping response inside an object makes it easier to change later
class GetContactosCaseResponse {
  List<dynamic> alumnosList;
  List<dynamic> docentesList;
  List<dynamic> directivosList;

  GetContactosCaseResponse(
      this.alumnosList, this.docentesList, this.directivosList);
}