import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_qr_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_asistencia_qr_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/asistencia_qr_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';

class GetAsistenciaQRNoEnviadas{
  AsistenciaQRRepository asistenciaQRRepository;
  ConfiguracionRepository configuracionRepository;

  GetAsistenciaQRNoEnviadas(this.asistenciaQRRepository, this.configuracionRepository);

  Future<List<GrupoAsistenciaQRUi>> execute()async{
    return asistenciaQRRepository.getAsistenciaQRNoEnviadas();
  }

}