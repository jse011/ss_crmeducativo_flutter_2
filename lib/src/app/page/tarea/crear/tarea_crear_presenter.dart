import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/save_tarea_docente.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/upload_file_archivo.dart';

class TareaCrearPresenter extends Presenter{
  SaveTareaDocente _saveTareaDocente;
  UploadFileArchivo _uploadFileArchivo;
  late Function getCalendarioPeridoOnSucces, getCalendarioPeridoOnProgress;
  late Function saveTareaOnMessage;

  TareaCrearPresenter(HttpDatosRepository httpDatosRepo, ConfiguracionRepository configuracionRepo, UnidadTareaRepository unidadTareaRepository):
        _saveTareaDocente = SaveTareaDocente(httpDatosRepo, configuracionRepo, unidadTareaRepository),
        _uploadFileArchivo = UploadFileArchivo(configuracionRepo, httpDatosRepo),
        super();

  Future<bool> saveTareaDocente(TareaUi tareaUi) async{
    print("saveTareaDocente: ${tareaUi.silaboEventoId}");
    var response = await _saveTareaDocente.execute(tareaUi);
    saveTareaOnMessage(response.offline);

    return response.success??false;
  }

  Future<HttpStream?> uploadTareaRecurso(TareaRecusoUi tareaRecusoUi, CursosUi? cursosUi) async{
    return _uploadFileArchivo.execute(cursosUi?.silaboEventoId??0, tareaRecusoUi,  (progress){
      getCalendarioPeridoOnProgress( progress, tareaRecusoUi);
    },(success){
      getCalendarioPeridoOnSucces(success, tareaRecusoUi);
    });
  }

  @override
  void dispose() {

  }


}

