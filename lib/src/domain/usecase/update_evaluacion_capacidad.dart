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
    //CalcularEvaluacionProceso.actualizarCabecera(rubricaEvaluacionUiCabecera, personaUi);

    EvaluacionUi? evaluacionUiDetalle = null;
    for(EvaluacionUi evaluacionUi in rubricaEvaluacionUiDetalle?.evaluacionUiList??[]){
      if(evaluacionUi.alumnoId == personaUi?.personaId){
        evaluacionUiDetalle = evaluacionUi;
      }
    }

    for (RubricaEvaluacionUi item in rubricaEvaluacionUiCabeceraUi.rubrosDetalleList??[]) {
      if(item.rubricaId == rubricaEvaluacionUiDetalle?.rubricaId){
        for(EvaluacionUi evaluacionUi in item.evaluacionUiList??[]){
          if(evaluacionUi.alumnoId == personaUi?.personaId){
            print("modificado12: ${evaluacionUi.evaluacionId}");
            evaluacionUi.evaluacionId = evaluacionUiDetalle?.evaluacionId;
            evaluacionUi.valorTipoNotaUi = evaluacionUiDetalle?.valorTipoNotaUi;
            evaluacionUi.nota = evaluacionUiDetalle?.nota;

          }
        }
      }
    }

    CalcularEvaluacionProceso.actualizarCabecera(rubricaEvaluacionUiCabeceraUi, personaUi);
    return repository.updateEvaluacion(rubricaEvaluacionUiCabeceraUi, personaUi?.personaId, usuarioId);

  }
  
}

