import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class CrearServerUpdateRubroEvaluacion {
  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;
  RubroRepository repository;

  CrearServerUpdateRubroEvaluacion(this.configuracionRepository, this.repository, this.httpDatosRepository);

  Future<HttpStream?> execute(UpdateRubroEvaluacionParms params, UploadSuccessListen successListen) async{
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    int georeferenciaId = await configuracionRepository.getGeoreferenciaId();

    bool? success = false;
    bool errorServidor = false;
    bool offline = false;

    Map<String, dynamic>? dataBD =  await repository.updateRubroEvaluacionData(params.rubricaEvaluacionUi, usuarioId);
    Map<String, dynamic>? dataSerial = await repository.getRubroEvaluacionSerial(dataBD);

    if(dataSerial!=null){

      return await httpDatosRepository.updateEvaluacionRubroFlutter2(urlServidorLocal, params.rubricaEvaluacionUi?.calendarioPeriodoId??0, params.rubricaEvaluacionUi?.silaboEventoId??0, georeferenciaId, usuarioId, dataSerial,
              (success, sinConexion) async{
            if(success==null){
              successListen.call(UpdateRubroEvaluacionResponse(dataBD, false, sinConexion, true, false));
            }else if(success){
              await repository.saveRubroEvaluacionData(dataBD);
              await repository.cambiarEstadoActualizado(params.rubricaEvaluacionUi?.rubroEvaluacionId??"");
              successListen.call(UpdateRubroEvaluacionResponse(dataBD, true, sinConexion, false, false));
            }else{
              successListen.call(UpdateRubroEvaluacionResponse(dataBD,false, sinConexion, false, false));
            }
          });

    }else{
      successListen.call(UpdateRubroEvaluacionResponse(dataBD,false, false, false, true));
      return null;
    }

  }


}

typedef UploadSuccessListen = void Function(UpdateRubroEvaluacionResponse response);

class UpdateRubroEvaluacionParms{
  RubricaEvaluacionUi? rubricaEvaluacionUi;
  UpdateRubroEvaluacionParms(this.rubricaEvaluacionUi);
}

class UpdateRubroEvaluacionResponse{
    bool success;
    bool offline;
    bool errorServidor;
    bool errorInterno;
    Map<String, dynamic> dataBD;
    UpdateRubroEvaluacionResponse(this.dataBD, this.success, this.offline, this.errorServidor, this.errorInterno);
}