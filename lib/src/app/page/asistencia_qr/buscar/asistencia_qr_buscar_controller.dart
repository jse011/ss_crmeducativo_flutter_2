import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/asistencia_qr/buscar/asistencia_qr_buscar_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/dialog_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/asistencia_qr_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class AsistenciaQRBuscarController extends Controller{
  AsistenciaQRBuscarPresenter presenter;





  AsistenciaQRBuscarController(ConfiguracionRepository configuracionRepository,
      HttpDatosRepository httpDatosRepository,
      AsistenciaQRRepository asistenciaQRRepository):
        this.presenter = AsistenciaQRBuscarPresenter(configuracionRepository, httpDatosRepository, asistenciaQRRepository);

  bool get progress => _progress;
  bool  _progress = false ;
  DateTime? _fechaIncio = null;
  DateTime? get fechaIncio => _fechaIncio;
  DateTime? _fechaFin = null;
  DateTime? get fechaFin => _fechaFin;
  List<AsistenciaUi> _list = [];
  List<AsistenciaUi> get list => _list;
  DialogUi? _dialogUi = null;
  DialogUi? get dialogUi => _dialogUi;
  String? _search = null;
  String? get search => _search;
  int _maximoRegistros = 10;
  int get maximoRegistros => _maximoRegistros;
  int _total = 0;
  int get total => _total;
  List<int> _circulos = [];
  List<int> get circulos => _circulos;
  int _paginaActual = 1;
  int get paginaActual => _paginaActual;
  int _maxpaginas = 0;
  int get maxpaginas => _maxpaginas;

  int _min = 0;
  int get min => _min;
  @override
  void initListeners() {
    _fechaIncio = DateTime.now();
    _fechaFin = DateTime.now();
    presenter.uploadListaAsistenciaQROnSucces = (bool? success, bool? offline){
      if(offline??false){
        _dialogUi = DialogUi.errorInternet();
        refreshUI();
      }else if(!(success??false)){
        _dialogUi = DialogUi.errorServidor();
        refreshUI();
      }
    };
  }

  @override
  void onInitState(){
   getListaAsistencia();
    super.onInitState();
  }

  void changeFechaFin(DateTime? value) {
    _fechaFin = value;
  }

  void changeFechaInicio(DateTime? value) {
    _fechaIncio = value;
  }

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }

  void getListaAsistencia() async{
    int max = paginaActual * maximoRegistros ;//2 * 10

    _min = ((paginaActual-1) * maximoRegistros)  ;
    _progress = true;
    refreshUI();
    _list = await presenter.getAsistenciaUiList(min,max, search??"", fechaIncio, fechaFin)??[];
    if(list.isNotEmpty){
      _total = _list[0].total??0;
    }

    if((total/maximoRegistros % 1) == 0){
      _maxpaginas =  (_total/maximoRegistros).toInt();
    }else{
      _maxpaginas =  (_total/maximoRegistros).toInt()+1;
    }

    _circulos = [];
    if(_maxpaginas<=8){
      for (var index = 0; index < 8; index++){
        _circulos.add(index+1);
      }
    }else{
      for (var index = 0; index < 8; index++){
        if(_paginaActual > 8){
          _circulos.insert(0,_paginaActual-index);
        }else{
          _circulos.add(index+1);
        }


      }
    }

    _progress = false;
    refreshUI();
  }

  void clearDialog() {
    _dialogUi = null;
  }

  void onClickPagina(int pagina) {
    _paginaActual = pagina;
    refreshUI();
    getListaAsistencia();
  }

}