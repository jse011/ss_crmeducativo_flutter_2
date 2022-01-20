import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/cerrar_session.dart';

class CerrarSesionPresenter extends Presenter{
  final CerrarSession _cerrarSession;

  CerrarSesionPresenter(ConfiguracionRepository configuracionRepo):
        this._cerrarSession = CerrarSession(configuracionRepo);

  @override
  void dispose() {

  }

  Future<bool> onClickCerrarCession() {
    return _cerrarSession.execute();
  }

}