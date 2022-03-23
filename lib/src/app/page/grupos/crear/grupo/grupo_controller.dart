import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/equipo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_ui.dart';

class GrupoController extends Controller{
  bool _progress = false;
  bool get progress => _progress;
  bool _conexion = true;
  bool get conexion => _conexion;
  String? _tituloEvento = null;
  String? get tituloEvento => _tituloEvento;
  int _numeroEquipos = 4;
  int get numeroEquipos => _numeroEquipos;
  CursosUi? cursosUi;
  List<dynamic> get equiposUiList => _equiposUiList;
  List<dynamic> _equiposUiList = [];
  GrupoUi? grupoUi;

  GrupoController(this.cursosUi, this.grupoUi);

  @override
  void initListeners() {
    _equiposUiList.add("add");
    _equiposUiList.add(EquipoUi());
    _equiposUiList.add(EquipoUi());
    _equiposUiList.add(EquipoUi());
    _equiposUiList.add(EquipoUi());
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

  void cambiosEquipos() {}

}