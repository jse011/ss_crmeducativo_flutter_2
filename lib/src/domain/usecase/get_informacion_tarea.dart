import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/TareaEvaluacionUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class GetInformacionTarea extends UseCase<GetInformacionTareaResponse, GetInformacionTareaParams>{
  HttpDatosRepository httpDatosRepository;
  UnidadTareaRepository unidadTareaRepository;
  ConfiguracionRepository configuracionRepository;


  GetInformacionTarea(this.httpDatosRepository, this.unidadTareaRepository,
      this.configuracionRepository);

  @override
  Future<Stream<GetInformacionTareaResponse?>> buildUseCaseStream(GetInformacionTareaParams? params) async{
    final controller = StreamController<GetInformacionTareaResponse>();
    try {

      executeServidor() async{
        bool offlineServidor = false;
        bool errorServidor = false;
        try{
          String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
          Map<String, dynamic>? unidadSesion = await httpDatosRepository.getInfoTareaDocente(urlServidorLocal, params?.tareaUi?.tareaId, params?.silaboEventoId, params?.unidadEventoId);

          errorServidor = unidadSesion==null;
          if(!errorServidor){
            await unidadTareaRepository.saveInformacionTarea(params?.tareaUi?.tareaId, unidadSesion);
          }
        }catch(e){
          print(e);
          offlineServidor = true;
        }

        List<TareaRecusoUi> tareaRecusoUiList = await unidadTareaRepository.getRecursosTarea(params?.tareaUi?.tareaId);
        List<TareaAlumnoUi> tareaAlumnoUiList = await unidadTareaRepository.getTareaAlumnos(params?.tareaUi?.tareaId);
        List<PersonaUi> contactoList = await configuracionRepository.getListAlumnoCurso(params?.cargaCursoId??0);
        print("tareaAlumnoUiList ${tareaAlumnoUiList.length}");
        List<TareaAlumnoUi> alumnoUiList = [];
        for(PersonaUi personaUi in contactoList){
          TareaAlumnoUi? tareaAlumnoUi = tareaAlumnoUiList.firstWhereOrNull((element) => element.alumnoId == personaUi.personaId);
          if(tareaAlumnoUi==null){
            tareaAlumnoUi = new TareaAlumnoUi();
            tareaAlumnoUi.tareaId = params?.tareaUi?.tareaId;
            tareaAlumnoUi.alumnoId = personaUi.personaId;
          }
          tareaAlumnoUi.personaUi = personaUi;
          DateTime? fechaEntregaTareaTime = params?.tareaUi?.fechaEntregaTime;
          if(fechaEntregaTareaTime != null && (tareaAlumnoUi.entregado??false)){
            DateTime fechaEntregaTime = DateTime.fromMillisecondsSinceEpoch(tareaAlumnoUi.fechaEntrega??0);
            bool isbefore = fechaEntregaTareaTime.isBefore(fechaEntregaTime);
            tareaAlumnoUi.entregado_retraso = isbefore;
          }
          alumnoUiList.add(tareaAlumnoUi);
        }

        controller.add(GetInformacionTareaResponse(errorServidor, offlineServidor, tareaRecusoUiList, alumnoUiList));
        controller.close();
      }

      executeServidor().catchError((e) {
        controller.addError(e);
        // Finally, callback fires.
        // throw Exception(e);              // Future completes with 42.
      }).timeout(const Duration (seconds:10),onTimeout : () {
        throw Exception("GetUnidadSesion timeout 10 seconds");
      });

    } catch (e) {
      logger.severe('GetUnidadSesion unsuccessful: '+e.toString());
      // Trigger .onError
      controller.addError(e);

    }
    return controller.stream;
  }

}

class GetInformacionTareaParams{
  TareaUi? tareaUi;
  int? cargaCursoId;
  int? silaboEventoId;
  int? unidadEventoId;

  GetInformacionTareaParams(this.tareaUi, this.cargaCursoId,
      this.silaboEventoId, this.unidadEventoId);
}

class GetInformacionTareaResponse{
  bool? errorServidor;
  bool? offlineServidor;
  List<TareaRecusoUi>? tareaRecusoUiList;
  List<TareaAlumnoUi>? tareaAlumnoUiList;

  GetInformacionTareaResponse(this.errorServidor, this.offlineServidor,
      this.tareaRecusoUiList, this.tareaAlumnoUiList);
}