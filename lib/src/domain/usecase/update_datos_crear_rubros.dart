import 'dart:async';
import 'dart:developer';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:collection/collection.dart';

class UpdateDatosCrearRubro extends UseCase<UpdateDatosCrearRubroResponse, UpdateDatosCrearRubroParams>{

  HttpDatosRepository httpDatosRepository;
  ConfiguracionRepository repository;
  RubroRepository rubroRepository;
  List<UpdateDatosCrearRubroParams> cancelarList = [];
  UpdateDatosCrearRubro(this.httpDatosRepository, this.repository, this.rubroRepository);

  @override
  Future<Stream<UpdateDatosCrearRubroResponse?>> buildUseCaseStream(UpdateDatosCrearRubroParams? params) async{
    print("dispose : ${(params?.cancelar??false)}");
    final controller = StreamController<UpdateDatosCrearRubroResponse>();
    bool offlineServidor = false;
    bool errorServidor = false;


    int usuarioId = await repository.getSessionUsuarioId();
    int georeferenciaId = await repository.getGeoreferenciaId();
    int empleadoId = await repository.getSessionEmpleadoId();
    int anioAcademicoId = await repository.getSessionAnioAcademicoId();
    int programaEducativoId = await repository.getSessionProgramaEducativoId();
    String urlServidorLocal = await repository.getSessionUsuarioUrlServidor();


    if((params?.calendarioPeriodoId??0)>0) {
      int sessionAprendizajeId = 0;
      int sessionAprendizajeAlumnoId = 0;
      int sessionAprendizajeDocenteId = 0;


      if ((params?.sesionUi?.rolId ?? 0) == 6) {
        sessionAprendizajeId = params?.sesionUi?.sesionAprendizajeId ?? 0;
        sessionAprendizajeDocenteId =
            params?.sesionUi?.sesionAprendizajePadreId ?? 0;
        sessionAprendizajeAlumnoId = params?.sesionUi?.sesionAprendizajeId ?? 0;
      } else {
        sessionAprendizajeDocenteId =
            params?.sesionUi?.sesionAprendizajeId ?? 0;
      }

      print("casoss: ${params?.casoSesion } ${params?.casoTarea}");

      if (params?.casoSesion ?? false) {

        updateDatosParaCrearRubro()async{
          Map<String, dynamic>? datosCrearRubro = null;
          try{
            datosCrearRubro = await httpDatosRepository.updateDatosParaCrearRubro(urlServidorLocal, anioAcademicoId, programaEducativoId, params?.calendarioPeriodoId??0, params?.silaboEventoId??0, empleadoId,sessionAprendizajeId);
          }catch(e){
            offlineServidor = true;
          }

          controller.add(UpdateDatosCrearRubroResponse(offlineServidor, errorServidor, true));
          return datosCrearRubro;
        }

        updateDatosParaCrearRubro().then((value)async {
          try{
            String? rubroEvaltareaId = await rubroRepository.getRubroEvaluacionIdTarea(params?.tareaId);
            print("rubroEvaltareaId sesion tarea: ${rubroEvaltareaId}");
            errorServidor = value == null;
            if (!errorServidor) {
              await rubroRepository.saveDatosCrearRubros(value!, params?.silaboEventoId??0, params?.calendarioPeriodoId??0,sessionAprendizajeId);
              List<dynamic> rubrosNoEnviados = await rubroRepository.getRubroEvalNoEnviadosServidorSerial(params?.silaboEventoId??0, params?.calendarioPeriodoId??0);
              print("rubrosNoEnviados sesion: ${rubrosNoEnviados.length}");
              Map<String, dynamic>? datosRubro = await httpDatosRepository.getDatosRubroFlutter(urlServidorLocal, params?.calendarioPeriodoId??0, params?.silaboEventoId??0, georeferenciaId, usuarioId, sessionAprendizajeDocenteId, sessionAprendizajeAlumnoId, rubroEvaltareaId, rubrosNoEnviados,false, anioAcademicoId, programaEducativoId, empleadoId);

              errorServidor = (datosRubro == null);
              if (!errorServidor) {
                await rubroRepository.saveDatosRubrosEval(datosRubro!, params?.silaboEventoId??0, params?.calendarioPeriodoId??0, sessionAprendizajeDocenteId, sessionAprendizajeAlumnoId, rubroEvaltareaId);
              }
            }
          }catch(e){
            offlineServidor = true;
          }

          controller.add(UpdateDatosCrearRubroResponse(offlineServidor, errorServidor, false));
          controller.close();


        });


      } else if (params?.casoTarea ?? false) {

        try{

          String? rubroEvaltareaId = await rubroRepository.getRubroEvaluacionIdTarea(params?.tareaId);

          List<dynamic> rubrosNoEnviados = await rubroRepository.getRubroEvalNoEnviadosServidorSerial(params?.silaboEventoId??0, params?.calendarioPeriodoId??0);
          print("rubrosNoEnviados tarea: ${rubrosNoEnviados.length}");

          Map<String, dynamic>? datosRubro = await httpDatosRepository.getDatosRubroFlutter(urlServidorLocal, params?.calendarioPeriodoId??0, params?.silaboEventoId??0, georeferenciaId, usuarioId, sessionAprendizajeDocenteId, sessionAprendizajeAlumnoId, params?.tareaId, rubrosNoEnviados, true, anioAcademicoId, programaEducativoId, empleadoId);
          errorServidor = datosRubro == null;
          if (!errorServidor) {
            await rubroRepository.saveDatosRubrosEval(datosRubro, params?.silaboEventoId??0, params?.calendarioPeriodoId??0, sessionAprendizajeDocenteId, sessionAprendizajeAlumnoId, params?.tareaId);
          }

          if((rubroEvaltareaId??"").isEmpty){
            Map<String, dynamic>? datosCrearRubro = await httpDatosRepository.updateDatosParaCrearRubro(urlServidorLocal, anioAcademicoId, programaEducativoId, params?.calendarioPeriodoId??0, params?.silaboEventoId??0, empleadoId,sessionAprendizajeId);
            errorServidor = datosCrearRubro == null;
            if (!errorServidor) {
              await rubroRepository.saveDatosCrearRubros(datosCrearRubro, params?.silaboEventoId??0, params?.calendarioPeriodoId??0,sessionAprendizajeId);
            }
          }
        }catch(e){
          offlineServidor = true;
        }

        controller.add(UpdateDatosCrearRubroResponse(offlineServidor, errorServidor, false));
        controller.close();

      } else {
        print("dispose 0 : ${(params?.cancelar??false)}");
        try{
          String? rubroEvaltareaId = await rubroRepository.getRubroEvaluacionIdTarea(params?.tareaId);
          print("getDatosRubroFlutter 1");
          List<dynamic> rubrosNoEnviados = await rubroRepository.getRubroEvalNoEnviadosServidorSerial(params?.silaboEventoId??0, params?.calendarioPeriodoId??0);
          Map<String, dynamic>? datosRubro = await httpDatosRepository.getDatosRubroFlutter(urlServidorLocal, params?.calendarioPeriodoId??0, params?.silaboEventoId??0, georeferenciaId, usuarioId, sessionAprendizajeDocenteId, sessionAprendizajeAlumnoId, rubroEvaltareaId, rubrosNoEnviados,false, anioAcademicoId, programaEducativoId, empleadoId);
          print("dispose 00 : ${(params?.cancelar??false)}");
          errorServidor = datosRubro == null;
          if (!errorServidor) {
            print("dispose1 : ${(params?.cancelar??false)}");
            if(!(params?.cancelar??false)){//No guardar si ya se cancelo el obtener la evaluacón
              await rubroRepository.saveDatosRubrosEval(datosRubro, params?.silaboEventoId??0, params?.calendarioPeriodoId??0, sessionAprendizajeDocenteId, sessionAprendizajeAlumnoId, rubroEvaltareaId);
            }
          }
          print("getDatosRubroFlutter 2");
          print("dispose2 : ${(params?.cancelar??false)}");
          if (!errorServidor) {
            print("dispose2 : ${(params?.cancelar??false)}");
            if(!(params?.cancelar??false)){//No obtener rubro si ya se salio de la evaluacón
              print("rubrosNoEnviados silabo: ${rubrosNoEnviados.length}");
              Map<String, dynamic>? datosCrearRubro = await httpDatosRepository.updateDatosParaCrearRubro(urlServidorLocal, anioAcademicoId, programaEducativoId, params?.calendarioPeriodoId??0, params?.silaboEventoId??0, empleadoId,sessionAprendizajeId);
              errorServidor = datosCrearRubro == null;
              if (!errorServidor) {
                if(!(params?.cancelar??false)){//No guardar si ya se salio de la evaluacón
                  await rubroRepository.saveDatosCrearRubros(datosCrearRubro, params?.silaboEventoId??0, params?.calendarioPeriodoId??0,sessionAprendizajeId);
                }
              }
            }

          }
        }catch(e){
          print("dispose error : ${e.toString()}");
          offlineServidor = true;
        }

        controller.add(UpdateDatosCrearRubroResponse(offlineServidor, errorServidor, false));
        controller.close();

      }


    }else{
      controller.add(UpdateDatosCrearRubroResponse(offlineServidor, errorServidor, false));
      controller.close();
    }

    return controller.stream;

  }

}
class UpdateDatosCrearRubroParams{
  int calendarioPeriodoId;
  int silaboEventoId;
  SesionUi? sesionUi;
  String? tareaId;
  bool? casoTarea;
  bool? casoSesion;
  bool? cancelar;

  UpdateDatosCrearRubroParams(this.calendarioPeriodoId, this.silaboEventoId, this.sesionUi, this.tareaId, this.casoTarea, this.casoSesion);

}
class UpdateDatosCrearRubroResponse {
  bool errorConexion;
  bool errorServidor;
  bool successAprendizaje;

  UpdateDatosCrearRubroResponse(this.errorConexion, this.errorServidor,
      this.successAprendizaje);
}
