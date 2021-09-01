import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';

abstract class UnidadSesionRepository{
  Future<void> saveUnidadSesion(Map<String, dynamic> unidadSesion, int usuarioId, int calendarioId, int silaboEventoId, int rol);
  Future<List<UnidadUi>> getUnidadSesion(int usuarioId, int calendarioId, int silaboEventoId, int rolId);

}