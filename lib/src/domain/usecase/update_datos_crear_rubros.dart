import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class UpdateDatosCrearRubro extends UseCase<UpdateDatosCrearRubroResponse, UpdateDatosCrearRubroParams>{

  HttpDatosRepository httpDatosRepository;
  ConfiguracionRepository repository;
  RubroRepository rubroRepository;

  UpdateDatosCrearRubro(this.httpDatosRepository, this.repository, this.rubroRepository);

  @override
  Future<Stream<UpdateDatosCrearRubroResponse?>> buildUseCaseStream(UpdateDatosCrearRubroParams? params) async{
    final controller = StreamController<UpdateDatosCrearRubroResponse>();
    bool offlineServidor = false;
    bool errorServidor = false;

    int usuarioId = await repository.getSessionUsuarioId();
    int georeferenciaId = await repository.getGeoreferenciaId();
    int empleadoId = await repository.getSessionEmpleadoId();
    int anioAcademicoId = await repository.getSessionAnioAcademicoId();
    int programaEducativoId = await repository.getSessionProgramaEducativoId();
    String urlServidorLocal = await repository.getSessionUsuarioUrlServidor();

    try{
      int sessionAprendizajeId = 0;
      int sessionAprendizajeAlumnoId = 0;
      int sessionAprendizajeDocenteId = 0;
      if((params?.sesionUi?.rolId??0)==6){
        sessionAprendizajeId = params?.sesionUi?.sesionAprendizajeId??0;
        sessionAprendizajeDocenteId = params?.sesionUi?.sesionAprendizajePadreId??0;
        sessionAprendizajeAlumnoId = params?.sesionUi?.sesionAprendizajeId??0;
      }else{
        sessionAprendizajeDocenteId = params?.sesionUi?.sesionAprendizajeId??0;
      }

      Map<String, dynamic>? datosCrearRubro = await httpDatosRepository.updateDatosParaCrearRubro(urlServidorLocal, anioAcademicoId, programaEducativoId, params?.calendarioPeriodoId??0, params?.silaboEventoId??0, empleadoId,sessionAprendizajeId);
      errorServidor = datosCrearRubro == null;
      if (!errorServidor) {
        await rubroRepository.saveDatosCrearRubros(datosCrearRubro, params?.silaboEventoId??0, params?.calendarioPeriodoId??0,sessionAprendizajeId);
        List<dynamic> rubrosNoEnviados = await rubroRepository.getRubroEvalNoEnviadosServidorSerial(params?.silaboEventoId??0, params?.calendarioPeriodoId??0);
        Map<String, dynamic>? datosRubro = await httpDatosRepository.getDatosRubroFlutter(urlServidorLocal, params?.calendarioPeriodoId??0, params?.silaboEventoId??0, georeferenciaId, usuarioId, sessionAprendizajeDocenteId, sessionAprendizajeAlumnoId,rubrosNoEnviados);
        errorServidor = datosRubro == null;
        if (!errorServidor) {
          await rubroRepository.saveDatosRubrosEval(datosRubro, params?.silaboEventoId??0, params?.calendarioPeriodoId??0, sessionAprendizajeDocenteId, sessionAprendizajeAlumnoId);
        }
      }

    }catch(e){
      offlineServidor = true;
      logger.severe('UpdateDatosCrearRubro unsuccessful: '+e.toString());
    }

    controller.add(UpdateDatosCrearRubroResponse(offlineServidor, errorServidor));
    controller.close();

    return controller.stream;

  }

}
class UpdateDatosCrearRubroParams{
  int calendarioPeriodoId;
  int silaboEventoId;
  SesionUi? sesionUi;

  UpdateDatosCrearRubroParams(this.calendarioPeriodoId, this.silaboEventoId, this.sesionUi);

}
class UpdateDatosCrearRubroResponse{
  bool errorConexion;
  bool errorServidor;

  UpdateDatosCrearRubroResponse(this.errorConexion, this.errorServidor);
}

