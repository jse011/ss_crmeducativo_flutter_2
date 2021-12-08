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

class CrearLocalRubroEvaluacion {
  ConfiguracionRepository configuracionRepository;
  RubroRepository repository;

  CrearLocalRubroEvaluacion(this.configuracionRepository, this.repository);

  Future<void> execute(CrearLocalRubroEvaluacionParms params) async{
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    if(params.dataDB == null){
      params.dataDB = await repository.createRubroEvaluacionData(params.rubricaEvaluacionUi, usuarioId);
    }
    await repository.saveRubroEvaluacionData(params.dataDB!);
  }


}

class CrearLocalRubroEvaluacionParms{
  RubricaEvaluacionUi? rubricaEvaluacionUi;
  Map<String, dynamic>? dataDB;
  CrearLocalRubroEvaluacionParms(this.rubricaEvaluacionUi, this.dataDB);
}
