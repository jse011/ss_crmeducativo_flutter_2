import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/asistencia_qr_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_lista_asistencia.dart';

class AsistenciaQRBuscarPresenter extends Presenter{
  GetListaAsistenciaQR uploadListaAsistenciaQR;
  late Function uploadListaAsistenciaQROnSucces;
  AsistenciaQRBuscarPresenter( ConfiguracionRepository configuracionRepository,
  HttpDatosRepository httpDatosRepository,
  AsistenciaQRRepository asistenciaQRRepository):
        this.uploadListaAsistenciaQR = GetListaAsistenciaQR(configuracionRepository, httpDatosRepository, asistenciaQRRepository);


  Future<List<AsistenciaUi>?> getAsistenciaUiList(int min, int max, String search, DateTime? fechaInicio, DateTime? fechaFin)async{
    var response = await uploadListaAsistenciaQR.execute(min ,max, search, fechaInicio, fechaFin);
    uploadListaAsistenciaQROnSucces(response.success, response.offline);
    return response.asistenciaUiList;
  }


  @override
  void dispose() {

  }

}