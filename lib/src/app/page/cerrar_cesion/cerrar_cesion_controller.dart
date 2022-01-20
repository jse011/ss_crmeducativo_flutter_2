import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/cerrar_cesion/cerrar_cesion_presenter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';

class CerrarSesionController extends Controller{
  CerrarSesionPresenter presenter;


  CerrarSesionController():
        presenter = CerrarSesionPresenter(MoorConfiguracionRepository());

  @override
  void initListeners() {

  }

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }

  Future<bool> onClickCerrarCession() {
    return presenter.onClickCerrarCession();
  }
}