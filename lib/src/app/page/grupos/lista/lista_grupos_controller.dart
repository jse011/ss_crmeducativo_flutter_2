import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_ui.dart';

class ListaGruposController extends Controller{
  bool _progress = false;
  bool get progress => _progress;
  bool _conexion = true;
  bool get conexion => _conexion;
  CursosUi? cursosUi;

  List<GrupoUi> _grupoUiList = [];
  List<GrupoUi> get grupoUiList => _grupoUiList;


  ListaGruposController(this.cursosUi);

  @override
  void initListeners() {

  }

  void cambiosGrupos() {}

}