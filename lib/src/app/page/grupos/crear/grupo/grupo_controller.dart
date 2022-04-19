import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/grupos/crear/grupo/grupo_presenter.dart';
import 'package:ss_crmeducativo_2/src/app/utils/grupo_aleatorio.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/integrante_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/lista_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/grupo_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/id_generator.dart';
import 'dart:math';

class GrupoController extends Controller{
  GrupoPresenter _presenter;
  bool _progress = false;
  bool get progress => _progress;
  bool _conexion = true;
  bool get conexion => _conexion;
  bool _success = true;
  bool get success => _success;
  String? _nombreListaGrupos = null;
  String? get nombreListaGrupos => _nombreListaGrupos;
  int _numeroEquipos = 4;
  int get numeroEquipos => _numeroEquipos;
  CursosUi? cursosUi;
  ListaGrupoUi? listaGrupoUi;
  List<IntegranteGrupoUi> get integranteUiList => _integranteUiList;
  List<IntegranteGrupoUi> _integranteUiList = [];
  String? _mensaje = null;
  String? get mensaje => _mensaje;
  bool _validateGenerarGrupos = true;
  bool get validateGenerarGrupos => _validateGenerarGrupos;

  GrupoController(this.cursosUi, this.listaGrupoUi, ConfiguracionRepository configuracionRepo, GrupoRepository grupoRepository, HttpDatosRepository httpDatosRepository):
        _presenter = GrupoPresenter(configuracionRepo, grupoRepository, httpDatosRepository);

  @override
  void initListeners() {
    _presenter.getAlumnoCursoError = (e){
      _integranteUiList = [];
    };

    _presenter.getAlumnoCursoComplete = (List<PersonaUi>? personaUiList){
      _integranteUiList = [];
      for(PersonaUi personaUi in  personaUiList??[]){
        if(personaUi.contratoVigente??false){
          IntegranteGrupoUi integranteGrupoUi = IntegranteGrupoUi();
          integranteGrupoUi.equipoIntegranteId = IdGenerator.generateId();
          integranteGrupoUi.personaUi = personaUi;
          _integranteUiList.add(integranteGrupoUi);
        }

      }
    };
  }

  @override
  void onInitState() {
    if(listaGrupoUi?.grupoEquipoId?.isEmpty??true){
      this.listaGrupoUi?.color1 = cursosUi?.color1;
      this.listaGrupoUi?.color2 = cursosUi?.color2;
      this.listaGrupoUi?.color3 = cursosUi?.color3;
      this.listaGrupoUi?.imagen = cursosUi?.banner;
      this.listaGrupoUi?.nombreCurso = cursosUi?.nombreCurso;
    }else{
      _nombreListaGrupos = listaGrupoUi?.nombre;
      _numeroEquipos = listaGrupoUi?.grupoUiList?.length??1;
    }
    refreshUI();
    _presenter.getAlumnoCurso(cursosUi);
    super.onInitState();
  }

  void clearTitulo() {
    _nombreListaGrupos = null;
  }

  void changeTitulo(String str) {
    _nombreListaGrupos = str;
  }

  void changeNEquipos(String str) {
    _numeroEquipos = int.tryParse(str)??0;
    refreshUI();
  }

  void cambiosEquipos() {
    refreshUI();
  }

  void onClickIntegrante(GrupoUi? grupoUi, IntegranteGrupoUi? integranteUi) {

    integranteUi?.showMore = !(integranteUi.showMore??false);
    for(GrupoUi grupoUi in listaGrupoUi?.grupoUiList??[]){
      for(IntegranteGrupoUi item in grupoUi.integranteUiList??[]){
        if(integranteUi!=item){
          item.showMore = false;
        }
      }
    }

    refreshUI();

  }

  void elminarGrupo(GrupoUi? grupoUi) {
    listaGrupoUi?.grupoUiList?.remove(grupoUi);
    refreshUI();
  }

  void onClickGenerarGrupos(int index)async {
    _progress = true;
    refreshUI();
    _integranteUiList.shuffle();
    List<List<IntegranteGrupoUi>>? aletorioList = GrupoAleatorio<IntegranteGrupoUi>().execute(_integranteUiList, _numeroEquipos);
    if(aletorioList==null){
      _mensaje = "No hay suficientes participantes para hacer ${_numeroEquipos} grupos";
    }
    List<GrupoUi> grupoUiList = [];
    List<String> nombreGrupos = [];
    if(index == 1){
      nombreGrupos = await _presenter.getNombreAnimales();
    }else if(index == 2){
      nombreGrupos = await _presenter.getNombreColores();
    }else if(index == 3){
      nombreGrupos = await _presenter.getNombrePaises();
    }

    nombreGrupos.shuffle();;
    for (var i = 0; i < (aletorioList?.length??0); i++) {
      GrupoUi grupoUi = GrupoUi();
      grupoUi.equipoId = IdGenerator.generateId();
      grupoUi.posicion = i + 1;
      grupoUi.nombre = nombreGrupos.isNotEmpty? nombreGrupos[i]:null;
      grupoUi.integranteUiList = [];
      for(IntegranteGrupoUi integranteGrupoUi in aletorioList?[i]??[]){
        integranteGrupoUi.grupoUi = grupoUi;
        grupoUi.integranteUiList?.add(integranteGrupoUi);
      }
      grupoUi.integranteUiList?.sort((a, b) {
        String o1 = a.personaUi?.nombreCompleto??"";
        String o2 = b.personaUi?.nombreCompleto??"";
        return o1.compareTo(o2);
      });

      grupoUiList.add(grupoUi);
    }
    listaGrupoUi?.grupoUiList = grupoUiList;
    _progress = false;
    refreshUI();
  }


  void successMsg() {
    _mensaje = null;
  }

  void onValidateGenerarGrupos(bool? validate) {
    _validateGenerarGrupos = validate??false;
    refreshUI();
  }

  void onSelectedMoverGrupo(IntegranteGrupoUi? integranteUi, GrupoUi? newGrupoUi, GrupoUi? oldGrupoUi) {
    integranteUi?.showMore = false;
    oldGrupoUi?.integranteUiList?.remove(integranteUi);
    if(integranteUi!=null){
      integranteUi.grupoUi = newGrupoUi;
      newGrupoUi?.integranteUiList?.add(integranteUi);
      newGrupoUi?.integranteUiList?.sort((a, b) {
        String o1 = a.personaUi?.nombreCompleto??"";
        String o2 = b.personaUi?.nombreCompleto??"";
        return o1.compareTo(o2);
      });
    }

    refreshUI();
  }

  void onClickVerMasGrupo(GrupoUi? grupoUi) {
    grupoUi?.showMore = !(grupoUi.showMore??false);
    for(GrupoUi item in listaGrupoUi?.grupoUiList??[]){
      if(item != grupoUi){
        item.showMore = false;
      }
    }
  }

  void onSelectedTransferirAlumno(IntegranteGrupoUi? oldIntegranteUi, IntegranteGrupoUi? newIntegranteGrupoUi) {
    oldIntegranteUi?.showMore = false;
    newIntegranteGrupoUi?.showMore = false;

    GrupoUi? oldGrupo  = oldIntegranteUi?.grupoUi;
    GrupoUi? newGrupo  = newIntegranteGrupoUi?.grupoUi;
    oldGrupo?.integranteUiList?.remove(oldIntegranteUi);
    newGrupo?.integranteUiList?.remove(newIntegranteGrupoUi);

    if(oldIntegranteUi!=null){
      newGrupo?.integranteUiList?.add(oldIntegranteUi);
      newGrupo?.integranteUiList?.sort((a, b) {
        String o1 = a.personaUi?.nombreCompleto??"";
        String o2 = b.personaUi?.nombreCompleto??"";
        return o1.compareTo(o2);
      });
    }
    if(newIntegranteGrupoUi!=null){
      oldGrupo?.integranteUiList?.add(newIntegranteGrupoUi);
      oldGrupo?.integranteUiList?.sort((a, b) {
        String o1 = a.personaUi?.nombreCompleto??"";
        String o2 = b.personaUi?.nombreCompleto??"";
        return o1.compareTo(o2);
      });
    }
    oldIntegranteUi?.grupoUi = newGrupo;
    newIntegranteGrupoUi?.grupoUi = oldGrupo;
    refreshUI();
  }

  Future<dynamic?> onSave(bool validarAlumnosFaltantes) async{

    if((_nombreListaGrupos??"").isEmpty){
      _mensaje = "Ingrese el nombre del grupo";
      refreshUI();
      return false;
    }

    if((listaGrupoUi?.grupoUiList??[]).length<2){
      if(listaGrupoUi?.modoAletorio??false){
        _mensaje = "Genere dos o más grupos";
      }else{
        _mensaje = "Cree dos o más grupos";
      }
      refreshUI();
      return false;
      //return
    }
    print("Aqui dentro :(");
    List<IntegranteGrupoUi> integranteGrupoUiListUnSelected = [];
    integranteGrupoUiListUnSelected.addAll(integranteUiList);
    int grupoSinNombres = 0;
    for(GrupoUi grupoUi in listaGrupoUi?.grupoUiList??[]){
      if((grupoUi.nombre??"").isEmpty)grupoSinNombres++;
      for(IntegranteGrupoUi integranteGrupoUi in grupoUi.integranteUiList??[]){
        integranteGrupoUiListUnSelected.removeWhere((element) => element.personaUi?.personaId == integranteGrupoUi.personaUi?.personaId);
      }
    }
    /*
    if(grupoSinNombres != 0){
      _mensaje = "Existen ${grupoSinNombres==1?"un grupo":"${grupoSinNombres} grupos"} sin nombres";
      refreshUI();
      return false;
      //return
    }*/
    print("Aqui dentro :(");
    if(validarAlumnosFaltantes){
      if(integranteGrupoUiListUnSelected.isNotEmpty){
        return integranteGrupoUiListUnSelected.length;
      }
    }

    print("Aqui dentro :(");
    if((listaGrupoUi?.grupoEquipoId??"").isEmpty){
      listaGrupoUi?.grupoEquipoId = IdGenerator.generateId();
      listaGrupoUi?.cargaAcademicaId =  cursosUi?.cargaAcademicaId;
      listaGrupoUi?.cargaCursoId =  cursosUi?.cargaCursoId;
    }
    listaGrupoUi?.nombre = nombreListaGrupos;
    _progress = true;
    print("Aqui dentro2 :(");
    var response = await _presenter.saveGrupo(listaGrupoUi);
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

    return response.success;
  }

  Future<dynamic?> onDelete() async{
    _progress = true;
    listaGrupoUi?.remover = true;
    var response = await _presenter.saveGrupo(listaGrupoUi);
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

    return response.success;
  }

  //
//
//

}