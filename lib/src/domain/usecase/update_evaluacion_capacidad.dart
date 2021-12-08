import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_trasnformada_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/calcular_evaluacion_proceso.dart';

class UpdateEvaluacionCapacidad {
  RubroRepository repository;
  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;

  UpdateEvaluacionCapacidad(this.repository, this.configuracionRepository, this.httpDatosRepository);

  Future<void> execute(RubricaEvaluacionUi? rubricaEvaluacionUiDetalle, PersonaUi? personaUi) async {
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    RubricaEvaluacionUi? rubricaEvaluacionUiCabeceraUi =  await repository.getRubroEvaluacion(rubricaEvaluacionUiDetalle?.rubricaIdRubroCabecera??"");


    EvaluacionTransformadaUi? evaluacionUiDetalle;
    for(EvaluacionTransformadaUi evaluacionUi in rubricaEvaluacionUiDetalle?.evaluacionTransformadaUiList??[]){
      if(evaluacionUi.alumnoId == personaUi?.personaId){
        evaluacionUiDetalle = evaluacionUi;
      }
    }

    for (RubricaEvaluacionUi item in rubricaEvaluacionUiCabeceraUi.rubrosDetalleList??[]) {
      if(item.rubroEvaluacionId == rubricaEvaluacionUiDetalle?.rubroEvaluacionId){
        for(EvaluacionUi evaluacionUi in item.evaluacionUiList??[]){
          if(evaluacionUi.alumnoId == personaUi?.personaId){
            print("modificado12: ${evaluacionUiDetalle?.evaluacionUiOriginal?.evaluacionId}");
            evaluacionUi.valorTipoNotaId = evaluacionUiDetalle?.evaluacionUiOriginal?.valorTipoNotaId;
            evaluacionUi.valorTipoNotaUi = evaluacionUiDetalle?.evaluacionUiOriginal?.valorTipoNotaUi;
            evaluacionUi.nota = evaluacionUiDetalle?.evaluacionUiOriginal?.nota;
          }
        }
      }
    }

    CalcularEvaluacionProceso.actualizarCabecera(rubricaEvaluacionUiCabeceraUi, personaUi);
    return repository.updateEvaluacion(rubricaEvaluacionUiCabeceraUi, personaUi?.personaId, usuarioId);

  }
  
}

