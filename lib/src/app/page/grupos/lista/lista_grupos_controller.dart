import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/grupos/lista/lista_grupos_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/lista_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/grupo_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class ListaGruposController extends Controller{
  ListaGruposPresenter presenter;
  bool _progress = false;
  bool get progress => _progress;
  bool _conexion = true;
  bool get conexion => _conexion;
  CursosUi? cursosUi;
  int _seletedItem = 0;
  int get seletedItem => _seletedItem;

  List<dynamic> _misGrupoUiList = [];
  List<dynamic> get misGrupoUiList => _misGrupoUiList;

  List<ListaGrupoUi> _otrosGrupoUiList = [];
  List<ListaGrupoUi> get otrosGrupoUiList => _otrosGrupoUiList;

  List<ListaGrupoUi> _grupoUiList = [];

  ListaGruposController(this.cursosUi, GrupoRepository repository, ConfiguracionRepository configuracionRepo, HttpDatosRepository httpDatosRepo):
            presenter = ListaGruposPresenter(repository, configuracionRepo, httpDatosRepo);

  @override
  void initListeners() {
      presenter.getListaGruposComplete = (bool? offline, bool? errorServidor, List<ListaGrupoUi>? listaGrupoUiList){
        _grupoUiList = listaGrupoUiList??[];
        _misGrupoUiList = [];
        _otrosGrupoUiList = [];
        _misGrupoUiList.add("add");
        for(ListaGrupoUi listaGrupoUi in listaGrupoUiList??[]){
          if(listaGrupoUi.editar??false){
            _misGrupoUiList.add(listaGrupoUi);
          }else{
            _otrosGrupoUiList.add(listaGrupoUi);
          }
        }

        _progress = false;
          refreshUI();
      };
      presenter.getListaGruposError = (e){
        _progress = false;
        refreshUI();
      };
  }

  @override
  void onInitState() {
    super.onInitState();
    _progress = true;
    refreshUI();
    presenter.getListaGrupos(cursosUi, true);
  }
  void cambiosGrupos() {
    _progress = true;
    refreshUI();
    presenter.getListaGrupos(cursosUi, false);
  }

  @override
  void onDisposed() {
    presenter.dispose();
    super.onDisposed();
  }

  void onCheckListGrupo(ListaGrupoUi listaGrupoUi) {
    listaGrupoUi.toogle = !(listaGrupoUi.toogle??false);
    for(var item in _grupoUiList){
     if(item is ListaGrupoUi){
       if(item != listaGrupoUi) item.toogle = false;
     }
    }
    refreshUI();
  }

  void onChangeTab(int index) {
    _seletedItem = index;
    refreshUI();
  }

}