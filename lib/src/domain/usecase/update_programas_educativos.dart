import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/programa_educativo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class UpdateProgramasEducativos extends UseCase<GetProgramasEducativosResponse, GetProgramasEducativosParams> {

  HttpDatosRepository httpDatosRepo;
  ConfiguracionRepository repository;

  UpdateProgramasEducativos(this.repository, this.httpDatosRepo);

  @override
  Future<Stream<GetProgramasEducativosResponse?>> buildUseCaseStream(
      GetProgramasEducativosParams? params) async {
    final controller = StreamController<GetProgramasEducativosResponse>();
    logger.severe('getProgramaEducativo int');
    try {
      int usuarioId = await repository.getSessionUsuarioId();
      int empleadoId = await repository.getSessionEmpleadoId();
      int anioAcademicoIdSelect = await repository.getSessionAnioAcademicoId();
      String urlServidorLocal = await repository.getSessionUsuarioUrlServidor();
      print("getProgramaEducativo datos principales webconfig 1");

      Future<void> executeDatos() async {
        bool offlineServidor = false;
        bool errorServidor = false;

        try {
          String urlServidorLocal = await repository
              .getSessionUsuarioUrlServidor();

          Map<String, dynamic>? anioAcedemico = await await httpDatosRepo.getDatosAnioAcademico(urlServidorLocal, empleadoId, anioAcademicoIdSelect);

          errorServidor = anioAcedemico == null;

          print("getProgramaEducativo datos principales webconfig 2: estado. "+ errorServidor.toString());
          if (!errorServidor) {
            //printTime();
            await repository.saveDatosAnioAcademico(anioAcedemico);
            print("getProgramaEducativo datos principales webconfig 2: Save. ");
            //printTime();
          }

        } catch (e) {
          offlineServidor = true;
          print("getProgramaEducativo datos principales webconfig 3");
        }

        ProgramaEducativoUi? programaEducativoUiSelected = null;
        int programaEducativoId = await repository
            .getSessionProgramaEducativoId();
        List<ProgramaEducativoUi> programaEducativoUiList = await repository.getListProgramaEducativo(empleadoId, anioAcademicoIdSelect);

        for (ProgramaEducativoUi programaEducativoUi in programaEducativoUiList) {
          if (programaEducativoUi.idPrograma == programaEducativoId) {
            programaEducativoUiSelected = programaEducativoUi;
            programaEducativoUiSelected.seleccionado = true;
          }
        }

        if(programaEducativoUiSelected==null&&programaEducativoUiList.isNotEmpty){
          programaEducativoUiSelected = programaEducativoUiList[0];
          programaEducativoUiSelected.seleccionado = true;
        }

        repository.updateSessionProgramaEducativoId(programaEducativoUiSelected?.idPrograma??0);
        print("getProgramaEducativo datos principales webconfig 4");
        controller.add(GetProgramasEducativosResponse(offlineServidor, errorServidor, programaEducativoUiSelected, programaEducativoUiList));

        controller.close();
      }


      executeDatos().catchError((e) {
        controller.addError(e);
      });

    } catch (e) {
      logger.severe('getProgramaEducativo unsuccessful: '+e.toString());
      controller.addError(e);
    }

    return controller.stream;
  }

}


class GetProgramasEducativosParams {

}
class GetProgramasEducativosResponse{
  bool datosOffline;
  bool errorServidor;
  ProgramaEducativoUi? programaEducativoUi;
  List<ProgramaEducativoUi> programaEducativoUiList;

  GetProgramasEducativosResponse(this.datosOffline, this.errorServidor,
      this.programaEducativoUi, this.programaEducativoUiList);
}
