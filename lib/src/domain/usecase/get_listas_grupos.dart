import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/lista_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_lista_envio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/grupo_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class GetListaGrupos extends UseCase<GetListaGruposResponse, GetListaGruposParams>{

  GrupoRepository repository;
  ConfiguracionRepository configuracionRepo;
  HttpDatosRepository httpDatosRepo;

  GetListaGrupos(
      this.repository, this.configuracionRepo, this.httpDatosRepo);

  @override
  Future<Stream<GetListaGruposResponse?>> buildUseCaseStream(GetListaGruposParams? params)async {
    final controller = StreamController<GetListaGruposResponse>();
    try{
      bool offlineServidor = false;
      bool errorServidor = false;
      if((params?.sincronizar??false)){
        try {
          String urlServidorLocal = await configuracionRepo.getSessionUsuarioUrlServidor();

          Map<String, dynamic>? contactoDocente = await httpDatosRepo.getGrupoDocenteFlutter(urlServidorLocal, params?.cargaAcademicaId);
          errorServidor = contactoDocente == null;
          if (!errorServidor) {
            await repository.saveGrupoDocenteCargaAcademicaList(contactoDocente,  params?.cargaAcademicaId);
          }
        } catch (e) {
          print("contactosSerialList: ${e.toString()}");
          offlineServidor = true;
        }
      }


      int empleadoId = await configuracionRepo.getSessionEmpleadoId();
      List<ListaGrupoUi> listaGrupoUiList = await repository.getListaGrupos(params?.cargaAcademicaId);
      for(var item in listaGrupoUiList){
        if(item.docenteId == empleadoId){
          item.editar = true;
        }
      }
      controller.add(GetListaGruposResponse(offlineServidor, errorServidor, listaGrupoUiList));

      controller.close();
    } catch (e) {
      logger.severe('GetListaEnvioAgendaResponse unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;

  }

}

class GetListaGruposParams{
  int? cargaAcademicaId;
  int? cargaCursoId;
  bool? sincronizar;
  GetListaGruposParams(this.cargaAcademicaId, this.cargaCursoId, this.sincronizar);
}

class GetListaGruposResponse{
  bool? offlineServidor;
  bool? errorServidor;
  List<ListaGrupoUi> listaGrupoUiList;

  GetListaGruposResponse(
      this.offlineServidor, this.errorServidor, this.listaGrupoUiList);
}
