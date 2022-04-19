import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/cerrar_session.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_rubros_no_enviados_servidor.dart';

class CerrarSesionPresenter extends Presenter{
  final CerrarSession _cerrarSession;
  GetRubrosNoEnviadosAlServidor _getRubrosNoEnviadosAlServidor;

  CerrarSesionPresenter(ConfiguracionRepository configuracionRepo, RubroRepository rubroRepository, HttpDatosRepository httpDatosRepository):
        this._cerrarSession = CerrarSession(configuracionRepo, rubroRepository, httpDatosRepository),
        this._getRubrosNoEnviadosAlServidor = GetRubrosNoEnviadosAlServidor(rubroRepository);


  Future< List<Map<String, dynamic>>> getRubrosNoEnviadosAlServidor() async{
    return _getRubrosNoEnviadosAlServidor.execute();
  }

  @override
  void dispose() {

  }

  Future<CerrarSessionResponse> onClickCerrarCession() {
    return _cerrarSession.execute();
  }

}