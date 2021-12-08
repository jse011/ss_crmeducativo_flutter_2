import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class SaveTareaDocente {
    HttpDatosRepository _httpDatosRepository;
    ConfiguracionRepository configuracionRepository;
    UnidadTareaRepository repository;

    SaveTareaDocente(this._httpDatosRepository, this.configuracionRepository, this.repository);

    Future<SaveTareaDocenteResponse> execute(TareaUi tareaUi) async{

      String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
      int usuarioId = await configuracionRepository.getSessionUsuarioId();
      bool? success = false;
      bool offline = false;
      try{
        Map<String, dynamic> data =  repository.getTareaDosenteSerial(tareaUi, usuarioId);
        success = await _httpDatosRepository.saveTareaDocente(urlServidorLocal, data);
        if(success??false){
          bool? sucess = await _httpDatosRepository.saveTareaDocenteFlutter(urlServidorLocal, data);
          print("sucess:) ${sucess}");
          if(sucess??false){
            await repository.saveTareaDocenteSerial(data);
          }
        }
      }catch(e){
        offline = true;
      }
      return SaveTareaDocenteResponse(success, offline );
    }



}

class SaveTareaDocenteResponse{
  bool? success;
  bool offline;
  SaveTareaDocenteResponse(this.success, this.offline);
}