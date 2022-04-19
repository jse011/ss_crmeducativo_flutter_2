import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class CerrarSession {
  ConfiguracionRepository repository;
  RubroRepository rubroRepository;
  HttpDatosRepository httpDatosRepository;


  CerrarSession(
      this.repository, this.rubroRepository, this.httpDatosRepository);

  Future<CerrarSessionResponse> execute() async {

    bool offlineServidor = false;
    bool errorServidor = false;
    bool success = false;
    List<dynamic> rubrosNoEnviados = await rubroRepository.getRubroEvalNoEnviadosServidorSerialAll();
    if(rubrosNoEnviados.isNotEmpty){
      try{
        String urlServidorLocal = await repository.getSessionUsuarioUrlServidor();
        print("rubrosNoEnviados sesion: ${rubrosNoEnviados.length}");
        bool? datosRubro = await httpDatosRepository.uploadEvaluacoinCerrarSession(urlServidorLocal, rubrosNoEnviados);
        errorServidor = (datosRubro == null);
        if (!errorServidor) {
          success = datosRubro;
        }
      }catch(e){
        offlineServidor = true;
      }
    }else{
      success = true;
    }

    if(success){
      await repository.cerrrarSession();
    }

    return CerrarSessionResponse(offlineServidor, errorServidor, success);
  }



}

class CerrarSessionResponse{
  bool? offlineServidor;
  bool? errorServidor;
  bool? success;

  CerrarSessionResponse(this.offlineServidor, this.errorServidor, this.success);
}