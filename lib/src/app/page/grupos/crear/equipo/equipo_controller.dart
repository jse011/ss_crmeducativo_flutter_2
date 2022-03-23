import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/equipo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';

class EquipoController extends Controller{
  bool _progress = false;
  bool get progress => _progress;
  bool _conexion = true;
  bool get conexion => _conexion;
  String? _tituloEvento = null;
  String? get tituloEvento => _tituloEvento;
  int _numeroEquipos = 4;
  int get numeroEquipos => _numeroEquipos;
  CursosUi? cursosUi;
  List<PersonaUi> get personaList => _personaList;
  List<PersonaUi> _personaList = [];
  EquipoUi? equipoUi;

  EquipoController(this.cursosUi, this.equipoUi);

  @override
  void initListeners() {

    _personaList.add(PersonaUi());
    _personaList.add(PersonaUi());
    _personaList.add(PersonaUi());
    _personaList.add(PersonaUi());
    _personaList.add(PersonaUi());
    _personaList.add(PersonaUi());
    _personaList.add(PersonaUi());
    _personaList.add(PersonaUi());
    _personaList.add(PersonaUi());
    _personaList.add(PersonaUi());
    _personaList.add(PersonaUi());
    _personaList.add(PersonaUi());
    _personaList.add(PersonaUi());
    refreshUI();
  }

  void clearTitulo() {
    _tituloEvento = null;
  }

  void changeTitulo(String str) {
    _tituloEvento = str;
  }

  void changeNEquipos(String str) {
    _numeroEquipos = int.tryParse(str)??0;
    refreshUI();
  }

}