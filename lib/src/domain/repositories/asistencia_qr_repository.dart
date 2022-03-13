import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_qr_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_asistencia_qr_ui.dart';

abstract class AsistenciaQRRepository{
  void saveAsistenciaQR(AsistenciaQRUi? asistenciaQRUi);
  Future<List<AsistenciaQRUi>> getAsistenciaQRHoy(DateTime? dateTime);
  Future<AsistenciaQRUi?> getAsistenciaQRRepetida(AsistenciaQRUi? asistenciaQRUi);
  Future<void> updateAsistenciaQR(AsistenciaQRUi? asistenciaQRUi);
  Future<List<GrupoAsistenciaQRUi>> getAsistenciaQRNoEnviadas();
  transformarAsistencia(List<dynamic> response);
}