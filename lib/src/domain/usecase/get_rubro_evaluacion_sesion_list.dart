import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class GetRubroEvaluacionSesionList extends UseCase<GetRubroEvaluacionSesionListResponse, GetRubroEvaluacionSesionListParms>{

  RubroRepository repository;

  GetRubroEvaluacionSesionList(this.repository);

  @override
  Future<Stream<GetRubroEvaluacionSesionListResponse?>> buildUseCaseStream(GetRubroEvaluacionSesionListParms? params) async{
    final controller = StreamController<GetRubroEvaluacionSesionListResponse>();
    try{
      controller.add(GetRubroEvaluacionSesionListResponse(await repository.getRubroEvaluacionSesionList( params?.silaboEventoId??0, params?.calendarioPeriodoId??0, params?.sesionAprendizajeDocenteId??0, params?.sesionAprendizajeAlumnoId??0)));
      controller.close();
    } catch (e) {
      logger.severe('GetRubroEvaluacionSesionListResponse unsuccessful: '+e.toString());
      controller.addError(e);
    }
    return controller.stream;
  }


}

class GetRubroEvaluacionSesionListParms{
    int? calendarioPeriodoId;
    int? silaboEventoId;
    int? sesionAprendizajeDocenteId;
    int? sesionAprendizajeAlumnoId;

    GetRubroEvaluacionSesionListParms(this.calendarioPeriodoId, this.silaboEventoId, this.sesionAprendizajeDocenteId, this.sesionAprendizajeAlumnoId);
}

class GetRubroEvaluacionSesionListResponse{
  List<RubricaEvaluacionUi> rubricaEvaluacionList;

  GetRubroEvaluacionSesionListResponse(this.rubricaEvaluacionList);
}