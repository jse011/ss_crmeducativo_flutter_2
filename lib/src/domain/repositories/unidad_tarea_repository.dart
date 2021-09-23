import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';

abstract class UnidadTareaRepository {
  Future<void> saveUnidadTarea(Map<String, dynamic> unidadSesion, int calendarioPeriodoId, int silaboEventoId);
  Future<List<UnidadUi>> getUnidadTarea(int calendarioPeriodoId, int silaboEventoId);

}