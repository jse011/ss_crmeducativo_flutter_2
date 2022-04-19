import 'package:ss_crmeducativo_2/src/domain/entities/lista_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/grupo_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class SaveGrupo{
  ConfiguracionRepository configuracionRepository;
  GrupoRepository grupoRepository;
  HttpDatosRepository httpDatosRepository;

  SaveGrupo(this.configuracionRepository, this.grupoRepository,
      this.httpDatosRepository);

  Future<SaveGrupoResponse> execute(ListaGrupoUi? listaGrupoUi) async{
    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    int usuarioId = await configuracionRepository.getSessionUsuarioId();
    int empleadoId = await configuracionRepository.getSessionEmpleadoId();
    Map<String, dynamic> dataJson = await  grupoRepository.transformarListaGrupos(listaGrupoUi, usuarioId, empleadoId);
    print("dataJson");
    bool offlineServidor = false;
    bool errorServidor = false;
    bool success = false;
    try{
      bool? datosGrupo = await httpDatosRepository.saveGrupoDocente(urlServidorLocal, dataJson);
      errorServidor = (datosGrupo == null);
      if (!errorServidor) {
        success = datosGrupo;
        await grupoRepository.saveGrupoDocente(dataJson, listaGrupoUi?.grupoEquipoId);
      }
    }catch(e){
      print("${e.toString()}");
      offlineServidor = true;
    }
    return SaveGrupoResponse(offlineServidor, errorServidor, success);
  }

}



class SaveGrupoResponse{
  bool? offlineServidor;
  bool? errorServidor;
  bool? success;

  SaveGrupoResponse(this.offlineServidor, this.errorServidor, this.success);
}