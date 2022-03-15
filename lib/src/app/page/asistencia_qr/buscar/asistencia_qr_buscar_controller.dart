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
  int _maximoRegistros = 15;
  int get maximoRegistros => _maximoRegistros;
  int _total = 0;
  int get total => _total;
  List<int> _circulos = [];
  List<int> get circulos => _circulos;
  int _paginaActual = 1;
  int get paginaActual => _paginaActual;
  int _maxpaginas = 0;
  int get maxpaginas => _maxpaginas;
  HttpStream? http = null;
  int _min = 0;
  int get min => _min;
  @override
  void initListeners() {
    _fechaIncio = DateTime.now();
    _fechaFin = DateTime.now();
    presenter.uploadListaAsistenciaQROnSucces = (bool? success, bool? offline, List<AsistenciaUi> asistenciaList, int? minimo){
      _list = asistenciaList;
      _min = minimo??0;
      if(offline??false){
        _dialogUi = DialogUi.errorInternet();
        refreshUI();
      }else if(!(success??false)){
        _dialogUi = DialogUi.errorServidor();
        refreshUI();
      }

      if(list.isNotEmpty){
        _total = _list[0].total??0;
      }

      if((total/maximoRegistros % 1) == 0){
        _maxpaginas =  (_total/maximoRegistros).toInt();
      }else{
        _maxpaginas =  (_total/maximoRegistros).toInt()+1;
      }

      _circulos = [];
      int cantMaxCirculos = _maxpaginas<8?_maxpaginas:8;
      int paginaActualCirculos = 0;
      if(((paginaActual/cantMaxCirculos)% 1) == 0){
        try{
          paginaActualCirculos = (paginaActual/cantMaxCirculos).toInt();
        }catch(e){

        }

      }else{
        try{
          paginaActualCirculos = (paginaActual/cantMaxCirculos).toInt() + 1;
        }catch(e){

        }

      }



      for(var index = 0; index < cantMaxCirculos ; index++){

        int circulo = (paginaActualCirculos * cantMaxCirculos) - index;
        _circulos.insert(0,circulo);

      }

      _circulos.removeWhere((element) => element > maxpaginas);

      _progress = false;
      refreshUI();


    };
  }

  @override
  void onInitState(){
   getListaAsistencia();
    super.onInitState();
  }

  void changeFechaFin(DateTime? value) {
    _fechaFin = value;
    getListaAsistencia();
  }

  void changeFechaInicio(DateTime? value) {
    _fechaIncio = value;
    getListaAsistencia();
  }

  @override
  void dispose() {
    http?.cancel();
    presenter.dispose();
    super.dispose();
  }

  void getListaAsistencia() async{
    int max = paginaActual * maximoRegistros ;//2 * 10

    int min = ((paginaActual-1) * maximoRegistros)  ;
    _progress = true;
    refreshUI();
    http?.cancel();
    http = await presenter.getAsistenciaUiList(min,max, search??"", fechaIncio, fechaFin);
  }

  void clearDialog() {
    _dialogUi = null;
  }

  void onClickPagina(int pagina) {
    _paginaActual = pagina;
    refreshUI();
    getListaAsistencia();
  }

  void onClickNextPagina() {
    if(paginaActual != maxpaginas){
      _paginaActual ++;
      refreshUI();
      getListaAsistencia();
    }

  }

  void onClickPreviusPagina() {
    if(paginaActual != 1){
      _paginaActual --;
      refreshUI();
      getListaAsistencia();
    }
  }

  void clearSearch() {
    _search = null;
  }

  void changeTitulo(String str) {
    _search = str;
  }

  void searchTitulo() {
    _paginaActual = 1;
    getListaAsistencia();
  }

}