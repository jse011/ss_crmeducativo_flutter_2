import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/grupos/crear/equipo/equipo_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/integrante_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/lista_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:collection/collection.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/id_generator.dart';

class EquipoController extends Controller{
  EquipoPresenter presenter;
  bool _progress = false;
  bool get progress => _progress;
  bool _conexion = true;
  bool get conexion => _conexion;
  String? _nombreGrupo = null;
  String? get nombreGrupo => _nombreGrupo;
  int _numeroEquipos = 4;
  int get numeroEquipos => _numeroEquipos;
  CursosUi? cursosUi;
  GrupoUi? grupoUi;
  ListaGrupoUi? listaGrupoUi;
  List<IntegranteGrupoUi> get integranteUiListSelect => _integranteUiListSelect;
  List<IntegranteGrupoUi> _integranteUiListSelect = [];
  List<IntegranteGrupoUi> get integranteUiList => _integranteUiList;
  List<IntegranteGrupoUi> _integranteUiList = [];
  List<IntegranteGrupoUi> get integranteUiListOrtrosEquipos => _integranteUiListOrtrosEquipos;
  List<IntegranteGrupoUi> _integranteUiListOrtrosEquipos = [];

  String? _mensaje = null;
  String? get mensaje => _mensaje;

  EquipoController(this.cursosUi, this.grupoUi, this. listaGrupoUi,ConfiguracionRepository configuracionRepo):
        presenter = EquipoPresenter(configuracionRepo);

  @override
  void initListeners() {
    presenter.getAlumnoCursoError = (e){
      _integranteUiListSelect = [];
      _integranteUiList = [];
      _integranteUiListOrtrosEquipos = [];
      refreshUI();
    };

    presenter.getAlumnoCursoComplete = (List<PersonaUi>? personaUiList){
      _integranteUiList = [];
      for(IntegranteGrupoUi integranteUi in  grupoUi?.integranteUiList??[]){
        integranteUi = integranteUi.copy();
        integranteUi.toogle = true;
        _integranteUiListSelect.add(integranteUi);
        _integranteUiList.add(integranteUi);
        PersonaUi? search = personaUiList?.firstWhereOrNull((element) => element.personaId == integranteUi.personaUi?.personaId);
        if(search!=null){
          integranteUi.personaUi?.contratoVigente = search.contratoVigente;
          personaUiList?.remove(search);
        }

      }

      for(GrupoUi grupoUi in listaGrupoUi?.grupoUiList??[]){
        if(grupoUi != this.grupoUi){
          for(IntegranteGrupoUi integranteUi in  grupoUi.integranteUiList??[]){
            integranteUi = integranteUi.copy();
            _integranteUiListOrtrosEquipos.add(integranteUi);
            integranteUi.toogle = false;
            integranteUi.grupoUi = grupoUi;
            PersonaUi? search = personaUiList?.firstWhereOrNull((element) => element.personaId == integranteUi.personaUi?.personaId);
            if(search!=null){
              integranteUi.personaUi?.contratoVigente = search.contratoVigente;
              personaUiList?.remove(search);
            }
          }
        }

      }

      for(PersonaUi personaUi in  personaUiList??[]){
        if(personaUi.contratoVigente??false){
          IntegranteGrupoUi integranteGrupoUi = IntegranteGrupoUi();
          integranteGrupoUi.equipoIntegranteId = IdGenerator.generateId();
          integranteGrupoUi.personaUi = personaUi;
          _integranteUiList.add(integranteGrupoUi);
        }
      }

      refreshUI();
    };

  }

  @override
  void onInitState() {
    super.onInitState();
    _nombreGrupo = grupoUi?.nombre??"";
    presenter.getAlumnoCurso(cursosUi);
  }
  void clearTitulo() {
    _nombreGrupo = null;
  }

  void changeTitulo(String str) {
    _nombreGrupo = str;
  }

  void changeNEquipos(String str) {
    _numeroEquipos = int.tryParse(str)??0;
    refreshUI();
  }
  @override
  void onDisposed() {
    presenter.dispose();
    super.onDisposed();
  }

  void onClickIntegrante(IntegranteGrupoUi integranteGrupoUi) {
    integranteGrupoUi.toogle = !(integranteGrupoUi.toogle??false);
    if(!(integranteGrupoUi.toogle??false)){
      _integranteUiListSelect.remove(integranteGrupoUi);
    }else{
      _integranteUiListSelect.insert(0,integranteGrupoUi);
    }
    refreshUI();
  }

  void onClickRemoverIntegrante(IntegranteGrupoUi integranteGrupoUi) {
    integranteGrupoUi.toogle = false;
    _integranteUiListSelect.remove(integranteGrupoUi);
    refreshUI();
  }

  Future<bool> onSave() async{
    /*if((_nombreGrupo??"").isEmpty){
      _mensaje = "Ingrese el nombre del grupo";
      refreshUI();
      return false;
    }*/
    if(integranteUiListSelect.isEmpty){
      _mensaje = "seleccione a uno o más integrantes";
      refreshUI();
      return false;
    }
    if(grupoUi==null){
      grupoUi = GrupoUi();
      grupoUi?.equipoId = IdGenerator.generateId();
      grupoUi?.nombre = nombreGrupo;
      grupoUi?.integranteUiList = [];
      grupoUi?.integranteUiList?.addAll(integranteUiListSelect);
      if(listaGrupoUi?.grupoUiList==null)listaGrupoUi?.grupoUiList = [];
      listaGrupoUi?.grupoUiList?.insert(0,grupoUi!);
    }else{
      grupoUi?.nombre = nombreGrupo;
      grupoUi?.integranteUiList = [];
      grupoUi?.integranteUiList?.addAll(integranteUiListSelect);
    }

    for(IntegranteGrupoUi integranteGrupoUi in integranteUiListOrtrosEquipos){
      if(integranteGrupoUi.toogle??false){
        integranteGrupoUi.grupoUi?.integranteUiList?.removeWhere((element) => element.personaUi?.personaId == integranteGrupoUi.personaUi?.personaId);
      }
    }

    for(IntegranteGrupoUi integranteGrupoUi in grupoUi?.integranteUiList??[]){
      integranteGrupoUi.grupoUi = grupoUi;
    }


    return true;
  }

  void traerAlumnoAEsteGrupo(IntegranteGrupoUi integranteGrupoUi) {
    integranteGrupoUi.toogle = !(integranteGrupoUi.toogle??false);
    if(!(integranteGrupoUi.toogle??false)){
      _integranteUiListSelect.remove(integranteGrupoUi);
    }else{
      _integranteUiListSelect.insert(0,integranteGrupoUi);
    }
    refreshUI();
  }

  int get alumnosSinGrupos {
    int count = 0;
    for(IntegranteGrupoUi integranteGrupoUi in _integranteUiList){
      if(integranteGrupoUi.toogle??false){

      }else{
        count++;
      }
    }
    return count;
  }

  int get alumnosSeleccionados {
    int count = 0;
    for(IntegranteGrupoUi integranteGrupoUi in _integranteUiListSelect){
      if(integranteGrupoUi.grupoUi==null||integranteGrupoUi.grupoUi == grupoUi)
      if(integranteGrupoUi.toogle??false){
        count++;
      }else{

      }
    }
    return count;
  }

  int get alumnosSeleccionadosOtrosGrupos {

    int count = 0;
    for(IntegranteGrupoUi integranteGrupoUi in _integranteUiListSelect){
      if(integranteGrupoUi.grupoUi!=null&&integranteGrupoUi.grupoUi != grupoUi){

        if(integranteGrupoUi.toogle??false){
          count++;
        }else{

        }
      }
    }
    return count;
  }

  void successMsg() {
    _mensaje = null;
  }

  int alumnosSeleccionadosGrupo(GrupoUi? grupoUi) {
    int count = 0;
    for(IntegranteGrupoUi integranteGrupoUi in _integranteUiListSelect){
      if(integranteGrupoUi.grupoUi == grupoUi){
        if(integranteGrupoUi.toogle??false){
          count++;
        }else{

        }
      }

    }
    return count;
  }

}