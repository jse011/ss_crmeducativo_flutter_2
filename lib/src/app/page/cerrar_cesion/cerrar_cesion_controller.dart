import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/cerrar_cesion/cerrar_cesion_presenter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class CerrarSesionController extends Controller{
  CerrarSesionPresenter presenter;
  List<Map<String,dynamic>> _rubroNoEnviados = [];
  List<Map<String,dynamic>> get rubroNoEnviados => _rubroNoEnviados;
  bool _conexion = true;
  bool get conexion => _conexion;
  bool _success = true;
  bool get success => _success;
  bool _progress = false;
  bool get progress => _progress;
  CerrarSesionController(ConfiguracionRepository configuracionRepo, MoorRubroRepository moorRubroRepository, HttpDatosRepository httpDatosRepository):
        presenter = CerrarSesionPresenter(configuracionRepo, moorRubroRepository, httpDatosRepository);

  @override
  void initListeners() {

  }

  @override
  void onInitState() {
    getRubrosNoEnviadosAlServidor();
    super.onInitState();
  }

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }

  Future<bool> onClickCerrarCession() async{
    _progress = true;
    refreshUI();
     var response = await presenter.onClickCerrarCession();
     if(response.offlineServidor??false){
       _conexion = false;
     }else if(response.errorServidor??false){
       _conexion = false;
     }else{
       _conexion = true;
     }
    _progress = false;


    if(response.success??false){
      _success = true;
    }else {
      _success = false;
    }

    refreshUI();
     return _success;
  }

  void getRubrosNoEnviadosAlServidor() async{
    refreshUI();
  }

  void changeConnected(bool connected) {

  }
}