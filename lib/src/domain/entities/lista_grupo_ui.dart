
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_ui.dart';

class ListaGrupoUi{
  String? grupoEquipoId;
  bool? modoAletorio;
  String? nombre;
  int? cargaCursoId;
  int? cargaAcademicaId;
  List<GrupoUi>? grupoUiList;
  String? color1;
  String? color2;
  String? color3;
  String? imagen;
  String? nombreCurso;
  bool? remover;
  bool? editar;
  int? docenteId;
  bool? toogle;

  ListaGrupoUi copy(){
    ListaGrupoUi r = ListaGrupoUi();
    r.grupoEquipoId = grupoEquipoId;
    r.modoAletorio = modoAletorio;
    r.nombre = nombre;
    r.cargaCursoId = cargaCursoId;
    r.cargaAcademicaId = cargaAcademicaId;
    r.grupoUiList = grupoUiList;
    r.color1 = color1;
    r.color2 = color2;
    r.color3 = color3;
    r.imagen = imagen;
    r.nombreCurso = nombreCurso;
    r.remover = remover;
    r.editar = editar;
    r.docenteId = docenteId;
    r.toogle = toogle;

    return r;
  }
}