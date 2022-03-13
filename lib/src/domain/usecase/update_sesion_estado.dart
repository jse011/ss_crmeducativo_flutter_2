import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_firebase_sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_sesion_repository.dart';

class UpdateSesionEstado {
  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;
  UnidadSesionRepository unidadSesionRepository;

  UpdateSesionEstado(this.configuracionRepository, this.httpDatosRepository, this.unidadSesionRepository);

  Future<UpdateSesionResponse> execute(CursosUi? cursosUi, SesionUi? sesionUi, CalendarioPeriodoUI? calendarioPeriodoUI, List<EvaluacionFirebaseSesionUi> evaluacionFbSesionUiList) async{

    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    int personaId = await configuracionRepository.getSessionPersonaId();
    //Map<String, dynamic>? response = null;
    bool offline = false;
    bool success = false;
    List<String>? preguntaPortalAlumnoIdErrorList = [];
    List<String>? tareaIdErrorList = [];
    List<int>? instrumentoEvalIdErrorList = [];
    try{
      var data = await httpDatosRepository.saveEstadoSesion2(urlServidorLocal,
          sesionUi?.sesionAprendizajeId, sesionUi?.unidadAprendizajeId, cursosUi?.silaboEventoId, calendarioPeriodoUI?.tipoId, calendarioPeriodoUI?.id, evaluacionFbSesionUiList, usuarioId, personaId);

      if( data!=null && data.containsKey("d") && data["d"].containsKey("response") && data["d"]["response"]!=null){
        print("saveEstadoSesion2 :3");
        var response = data["d"]["response"] as Map<String,dynamic>;
        if(response.containsKey("Exito") && response["Exito"]as bool){
          sesionUi?.sesionEstado = SesionEstado.HECHO;
          await unidadSesionRepository.saveEstadoSesion(sesionUi?.sesionAprendizajeId, UnidadSesionRepository.ESTADO_HECHO);
          success = true;
        }else if( data!=null && data.containsKey("d")){
          print("saveEstadoSesion2 :C");
          success = false;
          List<dynamic> errores = data["d"]["errores"] as  List<dynamic>;
          print("saveEstadoSesion2 errores ${errores.length}");
          for(dynamic item in errores){
            if(item.containsKey("PreguntaPortalAlumnoId")){
              preguntaPortalAlumnoIdErrorList.add(item["PreguntaPortalAlumnoId"] as String);
            }else if(item.containsKey("TareaId")){
              tareaIdErrorList.add(item["TareaId"] as String);
            }else if(item.containsKey("InstrumentoEvalId")){
              instrumentoEvalIdErrorList.add(item["InstrumentoEvalId"] as int);
            }
          }

          //toastr.warning("Error en la evaluación. Se desmarcaron los recursos que lo causaron, reintente otra vez.");

        }else{
          success = false;
        }

      }
    }catch(e){
      print("saveEstadoSesion2 error ${e}");
      offline = true;
    }
    return UpdateSesionResponse(success, offline, preguntaPortalAlumnoIdErrorList, tareaIdErrorList, instrumentoEvalIdErrorList);
  }


}

class UpdateSesionResponse{
  bool? success;
  bool offline;
  List<String>? preguntaPortalAlumnoIdErrorList;
  List<String>? tareaIdErrorList;
  List<int>? instrumentoEvalIdErrorList;
  UpdateSesionResponse(this.success, this.offline, this.preguntaPortalAlumnoIdErrorList, this.tareaIdErrorList, this.instrumentoEvalIdErrorList);
}