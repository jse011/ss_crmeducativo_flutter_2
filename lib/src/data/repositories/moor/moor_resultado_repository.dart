import 'package:ss_crmeducativo_2/src/data/helpers/serelizable/rest_api_response.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/matriz_resultado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/resultado_respository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/resultado_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/resultado_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/resultado_evaluacion.dart';

class MoorResultadoRepository extends ResultadoRepository{
  static const int TN_VALOR_NUMERICO = 410, TN_SELECTOR_NUMERICO = 411, TN_SELECTOR_VALORES = 412, TN_SELECTOR_ICONOS = 409, TN_VALOR_ASISTENCIA= 474;
  @override
  MatrizResultadoUi transformarMatrizResultado(Map<String, dynamic> matrizResultado) {
    MatrizResultadoUi matrizResultadoUi = MatrizResultadoUi();
    List<PersonaUi> peronaUiList = [];
    List<ResultadoCompetenciaUi> resultadoCompetenciaUiList = [];
    List<ResultadoCapacidadUi> resultadoCapacidadUiList = [];
    List<ResultadoEvaluacionUi> resultadoEvaluacionUiList = [];

    print("transformarMatrizResultado");

    if(matrizResultado.containsKey("alumnos")){
      Iterable alumnos = matrizResultado["alumnos"];

      for(var alumno in alumnos){
        ResultadoAlumnoSerial alumnoSerial = ResultadoAlumnoSerial.fromJson(alumno);
        PersonaUi personaUi = new PersonaUi();
        personaUi.personaId = alumnoSerial.personaId;
        personaUi.foto = alumnoSerial.foto;
        personaUi.nombreCompleto = '${DomainTools.capitalize(alumnoSerial.apellidoPaterno??"")} ${DomainTools.capitalize(alumnoSerial.apellidoMaterno??"")}, ${DomainTools.capitalize(alumnoSerial.nombres??"")}';
        personaUi.nombres = DomainTools.capitalize(alumnoSerial.nombres??"");
        personaUi.apellidos  = '${DomainTools.capitalize(alumnoSerial.apellidoPaterno??"")} ${DomainTools.capitalize(alumnoSerial.apellidoMaterno??"")}';
        personaUi.contratoVigente = alumnoSerial.vigencia;
        peronaUiList.add(personaUi);
      }

    }

    if(matrizResultado.containsKey("competencias")){
      Iterable competencias = matrizResultado["competencias"];

      for(var competencia in competencias){
        ResultadoCompetenciaSerial competenciaSerial = ResultadoCompetenciaSerial.fromJson(competencia);
        ResultadoCompetenciaUi resultadoCompetenciaUi = ResultadoCompetenciaUi();
        resultadoCompetenciaUi.titulo = competenciaSerial.titulo;
        resultadoCompetenciaUi.rubroResultadoId = competenciaSerial.rubroEvalResultadoId;
        resultadoCompetenciaUi.competenciaId = competenciaSerial.competenciaId;
        resultadoCompetenciaUi.rubroformal = competenciaSerial.rubroFormal;

        resultadoCompetenciaUiList.add(resultadoCompetenciaUi);
      }
    }

    if(matrizResultado.containsKey("capacidades")){
      Iterable capacidades = matrizResultado["capacidades"];

      for(var capacidad in capacidades){
        ResultadoCapacidadSerial capacidadSerial = ResultadoCapacidadSerial.fromJson(capacidad);
        ResultadoCapacidadUi resultadoCapacidadUi = ResultadoCapacidadUi();
        resultadoCapacidadUi.titulo = capacidadSerial.titulo;
        resultadoCapacidadUi.rubroResultadoId = capacidadSerial.rubroEvalResultadoId;
        try {
          resultadoCapacidadUi.competenciaId = (int.parse(capacidadSerial.competenciaId??"0"));
        }catch (e){

        }
        resultadoCapacidadUi.rubroPrincipalId = capacidadSerial.rubroEvaluacionPrinId;
        resultadoCapacidadUi.parendId = capacidadSerial.parentId;
        resultadoCapacidadUi.orden = capacidadSerial.orden;
        resultadoCapacidadUi.orden2 = capacidadSerial.orden2;

        resultadoCapacidadUiList.add(resultadoCapacidadUi);
      }
    }

    if(matrizResultado.containsKey("evaluaciones")){
      Iterable evaluaciones = matrizResultado["evaluaciones"];

      for(var evaluacion in evaluaciones){
        ResultadoEvaluacionSerial evaluacionSerial = ResultadoEvaluacionSerial.fromJson(evaluacion);
        ResultadoEvaluacionUi resultadoEvaluacionUi = ResultadoEvaluacionUi();
        resultadoEvaluacionUi.evaluacionResultadoId = evaluacionSerial.evaluacionResultadoId;
        resultadoEvaluacionUi.alumnoId = evaluacionSerial.alumnoId;
        resultadoEvaluacionUi.rubroEvalResultadoId = evaluacionSerial.rubroEvalResultadoId;
        resultadoEvaluacionUi.color = evaluacionSerial.color;
        resultadoEvaluacionUi.nota = evaluacionSerial.nota;
        resultadoEvaluacionUi.valorTipoNotaId = evaluacionSerial.valorTipoNotaId;
        resultadoEvaluacionUi.tituloNota = evaluacionSerial.tituloNota;
        resultadoEvaluacionUi.orden = evaluacionSerial.orden;
        resultadoEvaluacionUi.orden2 = evaluacionSerial.orden2;

        resultadoEvaluacionUi.evaluado = evaluacionSerial.evaluado;
        int? tipoId = null;
        try {
          tipoId = int.parse(evaluacionSerial.tipoId??"0");
        }catch (e){

        }


        switch(tipoId??0){
          case TN_SELECTOR_ICONOS:
            resultadoEvaluacionUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_ICONOS;
            break;
          case TN_SELECTOR_NUMERICO:
            resultadoEvaluacionUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_NUMERICO;
            break;
          case TN_SELECTOR_VALORES:
            resultadoEvaluacionUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_VALORES;
            break;
          case TN_VALOR_NUMERICO:
            resultadoEvaluacionUi.tipoNotaTiposUi = TipoNotaTiposUi.SELECTOR_ICONOS;
            break;
          case TN_VALOR_ASISTENCIA:
            resultadoEvaluacionUi.tipoNotaTiposUi = TipoNotaTiposUi.VALOR_ASISTENCIA;
            break;
        }

        resultadoEvaluacionUi.rFEditable = evaluacionSerial.rFEditable;
        resultadoEvaluacionUi.color = evaluacionSerial.color;
        resultadoEvaluacionUi.notaDup = evaluacionSerial.notaDup;
        resultadoEvaluacionUi.conclusionDescriptiva = evaluacionSerial.conclusionDescriptiva;

        resultadoEvaluacionUiList.add(resultadoEvaluacionUi);
      }
    }

    if(matrizResultado.containsKey("Habilitado")){
      matrizResultadoUi.habilitado = matrizResultado["Habilitado"];
    }

    if(matrizResultado.containsKey("RangoFecha")){
      matrizResultadoUi.habilitado = matrizResultado["RangoFecha"];
    }

    matrizResultadoUi.capacidadUiList = resultadoCapacidadUiList;
    matrizResultadoUi.competenciaUiList = resultadoCompetenciaUiList;
    matrizResultadoUi.evaluacionUiList = resultadoEvaluacionUiList;
    matrizResultadoUi.personaUiList = peronaUiList;
    return matrizResultadoUi;
  }



}