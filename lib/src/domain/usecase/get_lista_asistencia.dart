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

  Future<GetListaAsistenciaQRResponse> execute(int min, int max, String search, DateTime? dateTimeIncio , DateTime? dateTimeFin) async{
    String urlServidorLocal = await configuracionRepository.getSessionUsuarioUrlServidor();
    int anioAcademicoId = await configuracionRepository.getSessionAnioAcademicoId();
    bool? success = false;
    bool offline = false;
    List<AsistenciaUi> asistenciaUiList = [];
    try{


      String fechaInicio = DateFormat('dd/MM/yyyy').format(dateTimeIncio??DateTime.now());
      String fechaFin = DateFormat('dd/MM/yyyy').format(dateTimeFin??DateTime.now());

      List<dynamic>? response = await httpDatosRepository.getListaAsistencia(urlServidorLocal, anioAcademicoId, min, max, search, fechaInicio, fechaFin);
      success = response!=null;
      if(success){
        asistenciaUiList = await asistenciaQRRepository.transformarAsistencia(response);
      }

    }catch(e){
      print("error: ${e.toString()}");
      offline = true;
    }
    return GetListaAsistenciaQRResponse(success, offline, asistenciaUiList );
  }

}

class GetListaAsistenciaQRResponse{
  bool? success;
  bool? offline;
  List<AsistenciaUi>? asistenciaUiList;

  GetListaAsistenciaQRResponse(this.success, this.offline, this.asistenciaUiList);
}