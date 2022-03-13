import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_trasnformada_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/calcular_evaluacion_proceso.dart';
import 'package:collection/collection.dart';

class UpdateEvaluacionCapacidad {
  RubroRepository repository;
  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;

  UpdateEvaluacionCapacidad(this.repository, this.configuracionRepository, this.httpDatosRepository);

  Future<void> execute(RubricaEvaluacionUi? rubricaEvaluacionUiDetalle, PersonaUi? personaUi) async {
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    RubricaEvaluacionUi? rubricaEvaluacionUi = null;
    if((rubricaEvaluacionUiDetalle?.rubricaIdRubroCabecera??"").isNotEmpty){
      RubricaEvaluacionUi? rubricaEvaluacionUiCabeceraUi =  await repository.getRubroEvaluacion(rubricaEvaluacionUiDetalle?.rubricaIdRubroCabecera??"");
      print("UpdateEvaluacionCapacidad: ${rubricaEvaluacionUiCabeceraUi.titulo}");
      EvaluacionTransformadaUi? evaluacionUiDetalle;
      for(EvaluacionTransformadaUi evaluacionUi in rubricaEvaluacionUiDetalle?.evaluacionTransformadaUiList??[]){
        if(evaluacionUi.alumnoId == personaUi?.personaId){
          evaluacionUiDetalle = evaluacionUi;
        }
      }

      for (RubricaEvaluacionUi item in rubricaEvaluacionUiCabeceraUi.rubrosDetalleList??[]) {
        if(item.rubroEvaluacionId == rubricaEvaluacionUiDetalle?.rubroEvaluacionId){
          bool existeAlumno = false;
          for(EvaluacionUi evaluacionUi in item.evaluacionUiList??[]){
            if(evaluacionUi.alumnoId == personaUi?.personaId){
              print("modificado12: ${evaluacionUiDetalle?.evaluacionUiOriginal?.valorTipoNotaUi?.titulo}");
              print("modificado12: ${evaluacionUiDetalle?.evaluacionUiOriginal?.valorTipoNotaUi?.alias}");
              evaluacionUi.valorTipoNotaId = evaluacionUiDetalle?.evaluacionUiOriginal?.valorTipoNotaId;
              evaluacionUi.valorTipoNotaUi = evaluacionUiDetalle?.evaluacionUiOriginal?.valorTipoNotaUi;
              evaluacionUi.nota = evaluacionUiDetalle?.evaluacionUiOriginal?.nota;
              existeAlumno = true;
            }
          }
          if(evaluacionUiDetalle!=null && !existeAlumno && (personaUi?.soloApareceEnElCurso??false))item.evaluacionUiList?.add(evaluacionUiDetalle);
        }
      }

      var evaluacionUiCabecera = rubricaEvaluacionUiCabeceraUi.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == personaUi?.personaId);
      if (evaluacionUiCabecera == null&& (personaUi?.soloApareceEnElCurso??false)){
        evaluacionUiCabecera = EvaluacionUi(); //Una evaluacion vasia significa que el foto_alumno no tiene evaluacion
        evaluacionUiCabecera.rubroEvaluacionUi = rubricaEvaluacionUiCabeceraUi;
        evaluacionUiCabecera.rubroEvaluacionId = rubricaEvaluacionUiCabeceraUi.rubroEvaluacionId;
        evaluacionUiCabecera.alumnoId = personaUi?.personaId;
        evaluacionUiCabecera.personaUi = personaUi;
        rubricaEvaluacionUiCabeceraUi.evaluacionUiList?.add(evaluacionUiCabecera);
      }

      CalcularEvaluacionProceso.actualizarCabecera(rubricaEvaluacionUiCabeceraUi, personaUi);
      rubricaEvaluacionUi = rubricaEvaluacionUiCabeceraUi;
    }else{
      rubricaEvaluacionUi =  await repository.getRubroEvaluacion(rubricaEvaluacionUiDetalle?.rubroEvaluacionId??"");
      EvaluacionTransformadaUi? evaluacionUiDetalle;
      for(EvaluacionTransformadaUi evaluacionUi in rubricaEvaluacionUiDetalle?.evaluacionTransformadaUiList??[]){
        if(evaluacionUi.alumnoId == personaUi?.personaId){
          evaluacionUiDetalle = evaluacionUi;
        }
      }
      bool existeAlumno = false;
      for(EvaluacionUi evaluacionUi in rubricaEvaluacionUi.evaluacionUiList??[]){
        if(evaluacionUi.alumnoId == personaUi?.personaId){
          print("modificado12: ${evaluacionUiDetalle?.evaluacionUiOriginal?.evaluacionId}");
          evaluacionUi.valorTipoNotaId = evaluacionUiDetalle?.evaluacionUiOriginal?.valorTipoNotaId;
          evaluacionUi.valorTipoNotaUi = evaluacionUiDetalle?.evaluacionUiOriginal?.valorTipoNotaUi;
          evaluacionUi.nota = evaluacionUiDetalle?.evaluacionUiOriginal?.nota;
          existeAlumno = true;
        }
      }
      if(evaluacionUiDetalle!=null && !existeAlumno && (personaUi?.soloApareceEnElCurso??false))rubricaEvaluacionUi.evaluacionUiList?.add(evaluacionUiDetalle);
    }

    return repository.updateEvaluacion(rubricaEvaluacionUi, personaUi?.personaId, usuarioId);

  }
  
}

