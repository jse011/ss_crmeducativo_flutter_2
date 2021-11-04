import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/matriz_resultado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/resultado_respository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/resultado_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/resultado_competencia_ui.dart';

class GetResultados extends UseCase<GetResultadosResponse, GetResultadosParams> {
  HttpDatosRepository httpDatosRepository;
  ConfiguracionRepository configuracionRepository;
  ResultadoRepository resultadoRepository;


  GetResultados(this.httpDatosRepository, this.configuracionRepository,
      this.resultadoRepository);

  @override
  Future<Stream<GetResultadosResponse?>> buildUseCaseStream(
      GetResultadosParams? params) async {

    print("GetResultados");
    final controller = StreamController<GetResultadosResponse>();
    MatrizResultadoUi? matrizResultadoUi = null;
    bool offlineServidor = false;
    bool errorServidor = false;
    try {
      String urlServidorLocal = await configuracionRepository
          .getSessionUsuarioUrlServidor();
      Map<String, dynamic>? matrizResultado = await httpDatosRepository
          .getMatrizResultado(
          urlServidorLocal, params?.cursosUi?.silaboEventoId,
          params?.cursosUi?.cargaCursoId, params?.calendarioPeriodoId);
      errorServidor = matrizResultado == null;
      print("GetResultados ${errorServidor}");
      if (!errorServidor) {
        print("GetResultados aqui");
         matrizResultadoUi = resultadoRepository
            .transformarMatrizResultado(matrizResultado);

         matrizResultadoUi.capacidadUiList?.sort((o1, o2){
           int value1 = (o1.orden2??0).compareTo((o2.orden2??0));
           if(value1 == 0){
             int value2 = (o1.orden??0).compareTo((o2.orden??0));
             if(value2 == 0){
               return (o1.rubroResultadoId??0).compareTo((o2.rubroResultadoId??0));
             }else{
               return value2;
             }
           }
           return 1;
         });

         matrizResultadoUi.competenciaUiList?.sort((o1, o2){
           return (o1.competenciaId??0).compareTo((o2.competenciaId??0));
         });

         matrizResultadoUi.evaluacionUiList?.sort((o1, o2){
           int value1 = (o1.orden2??0).compareTo((o2.orden2??0));
           if(value1 == 0){
             int value2 = (o1.orden??0).compareTo((o2.orden??0));
             if(value2 == 0){
               return (o1.rubroEvalResultadoId??0).compareTo((o2.rubroEvalResultadoId??0));
             }else{
               return value2;
             }
           }
           return 1;
         });

        matrizResultadoUi.personaUiList?.sort((o1, o2){
          return (o1.apellidos??"").compareTo((o2.apellidos??""));
        });

         for(ResultadoCompetenciaUi competenciaUi in matrizResultadoUi.competenciaUiList??[]){
           competenciaUi.resulCapacidadUiList = [];
           for(ResultadoCapacidadUi capacidadUi in matrizResultadoUi.capacidadUiList??[]){
              if(competenciaUi.competenciaId == capacidadUi.parendId){
                competenciaUi.resulCapacidadUiList?.add(capacidadUi);
              }
           }
         }




      }
    } catch (e) {
      print(e);
      offlineServidor = true;
    }

    controller.add(GetResultadosResponse(
        errorServidor, offlineServidor, matrizResultadoUi));
    controller.close();

    return controller.stream;
  }
}
class GetResultadosParams{
  CursosUi? cursosUi;
  int? calendarioPeriodoId;

  GetResultadosParams(this.cursosUi, this.calendarioPeriodoId);
}
class GetResultadosResponse{
  bool? errorServidor;
  bool? offlineServidor;
  MatrizResultadoUi? matrizResultadoUi;

  GetResultadosResponse(
      this.errorServidor, this.offlineServidor, this.matrizResultadoUi);
}