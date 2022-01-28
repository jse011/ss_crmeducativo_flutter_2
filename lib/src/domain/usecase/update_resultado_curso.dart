import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_sesion_repository.dart';

class UpdateResultadoCurso {
  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;
  RubroRepository rubroRepository;

  UpdateResultadoCurso(this.configuracionRepository, this.httpDatosRepository, this.rubroRepository);

  Future<UpdateResultadoCursoResponse> execute(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI) async{

    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    bool? success = false;
    bool offline = false;
    try{
      List<dynamic> rubrosNoEnviados = await rubroRepository.getRubroEvalNoEnviadosServidorSerial(cursosUi?.silaboEventoId, calendarioPeriodoUI?.id);
      success = await httpDatosRepository.updResultadoFlutter(urlServidorLocal, cursosUi?.silaboEventoId, cursosUi?.cargaCursoId, calendarioPeriodoUI?.id, usuarioId, rubrosNoEnviados);
      print("UpdateResultadoCurso ${success}");

    }catch(e){
      offline = true;
    }
    return UpdateResultadoCursoResponse(success, offline );
  }


}

class UpdateResultadoCursoResponse{
  bool? success;
  bool offline;
  UpdateResultadoCursoResponse(this.success, this.offline);
}