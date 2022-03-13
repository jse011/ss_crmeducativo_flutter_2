import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_qr_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/asistencia_qr_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';

class SaveAsistenciaQR{
  ConfiguracionRepository configuracionRepository;
  AsistenciaQRRepository asistenciaQRRepository;

  SaveAsistenciaQR(this.configuracionRepository, this.asistenciaQRRepository);

  Future<void> execute(AsistenciaQRUi asistenciaQRUi)async{

    return asistenciaQRRepository.saveAsistenciaQR(asistenciaQRUi);
  }

}