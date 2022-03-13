import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_qr_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/asistencia_qr_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';

class GetAsistenciaQRHoy{
  AsistenciaQRRepository asistenciaQRRepository;
  ConfiguracionRepository configuracionRepository;

  GetAsistenciaQRHoy(this.asistenciaQRRepository, this.configuracionRepository);

  Future<List<AsistenciaQRUi>> execute(DateTime? dateTime)async{
    return asistenciaQRRepository.getAsistenciaQRHoy(dateTime);
  }

}