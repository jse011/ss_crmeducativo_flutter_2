import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class CrearServerRubroEvaluacion {
  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;
  RubroRepository repository;

  CrearServerRubroEvaluacion(this.configuracionRepository, this.repository, this.httpDatosRepository);

  Future<SaveRubroEvaluacionResponse> execute(SaveRubroEvaluacionParms params) async{
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    int georeferenciaId = await configuracionRepository.getGeoreferenciaId();

    bool? success = false;
    bool offline = false;
    try{
      String? rubroEvaluacionId = await repository.saveRubroEvaluacion(params.titulo, params.formaEvaluacionId, params.tipoEvaluacionId, params.promedioLogroId, params.calendarioPeriodoId, params.silaboEventoId, params.cargaCursoId, params.sesionAprendizajeId, params.tareaId, usuarioId, params.criterioPesoUiList, params.criterioValorTipoNotaUiList, params.tipoNotaUi);
      print("rubroEvaluacionId: " + (rubroEvaluacionId??"null"));
      if(rubroEvaluacionId!=null){
        Map<String, dynamic>? data = await repository.getRubroEvaluacionSerial(rubroEvaluacionId);
        if(data!=null){
          success = await httpDatosRepository.crearRubroEvaluacion(urlServidorLocal, params.calendarioPeriodoId??0, params.silaboEventoId??0, georeferenciaId, usuarioId, data);
          if(success??false) await repository.cambiarEstadoActualizado(rubroEvaluacionId);
        }
      }
    }catch(e){
      offline = true;
    }
    return SaveRubroEvaluacionResponse(success, offline );
  }


}

class SaveRubroEvaluacionParms{
  String? rubroEvaluacionId;
  String? titulo;
  int? formaEvaluacionId;
  int? tipoEvaluacionId;
  String? promedioLogroId;
  int? calendarioPeriodoId;
  int? silaboEventoId;
  int? cargaCursoId;
  int? sesionAprendizajeId;
  String? tareaId;
  List<CriterioPesoUi>? criterioPesoUiList;
  List<CriterioValorTipoNotaUi>? criterioValorTipoNotaUiList;
  TipoNotaUi? tipoNotaUi;

  SaveRubroEvaluacionParms(this.rubroEvaluacionId, this.titulo,
      this.formaEvaluacionId, this.tipoEvaluacionId, this.promedioLogroId,
      this.calendarioPeriodoId, this.silaboEventoId, this.cargaCursoId,
      this.sesionAprendizajeId, this.tareaId, this.criterioPesoUiList,
      this.criterioValorTipoNotaUiList, this.tipoNotaUi);
}

class SaveRubroEvaluacionResponse{
    bool? success;
    bool offline;
    SaveRubroEvaluacionResponse(this.success, this.offline);
}