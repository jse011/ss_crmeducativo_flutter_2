import 'package:intl/intl.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_qr_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/asistencia_qr_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';

class GetListaAsistenciaQR{
  ConfiguracionRepository configuracionRepository;
  HttpDatosRepository httpDatosRepository;
  AsistenciaQRRepository asistenciaQRRepository;


  GetListaAsistenciaQR(this.configuracionRepository, this.httpDatosRepository,
      this.asistenciaQRRepository);

  Future<HttpStream?> execute(int min, int max, String search, DateTime? dateTimeIncio , DateTime? dateTimeFin, SuccessListen listen) async{
    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    int anioAcademicoId = await configuracionRepository.getSessionAnioAcademicoId();
    bool? success = false;

    List<AsistenciaUi> asistenciaUiList = [];
    //GetListaAsistenciaQRResponse
    String fechaInicio = DateFormat('dd/MM/yyyy').format(dateTimeIncio??DateTime.now());
    String fechaFin = DateFormat('dd/MM/yyyy').format(dateTimeFin??DateTime.now());

    return await httpDatosRepository.getListaAsistencia(urlServidorLocal, anioAcademicoId, min, max, search, fechaInicio, fechaFin,
          (response, sinConexion) async{
      success = response!=null;
      if(success??false){
        asistenciaUiList = await asistenciaQRRepository.transformarAsistencia(response);
      }
      listen.call(GetListaAsistenciaQRResponse(success, sinConexion, asistenciaUiList ));
    },);

  }

}

class GetListaAsistenciaQRResponse{
  bool? success;
  bool? offline;
  List<AsistenciaUi>? asistenciaUiList;

  GetListaAsistenciaQRResponse(this.success, this.offline, this.asistenciaUiList);
}

typedef SuccessListen = void Function(GetListaAsistenciaQRResponse response);