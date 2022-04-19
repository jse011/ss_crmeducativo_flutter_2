import 'package:ss_crmeducativo_2/src/domain/entities/lista_grupo_ui.dart';

abstract class GrupoRepository{
  Future<Map<String, dynamic>> transformarListaGrupos(ListaGrupoUi? listaGrupoUi, int usuarioId, int empleadoId);

  Future<void> saveGrupoDocente(Map<String, dynamic> dataJson, String? grupoEquipoId);

  Future<void> saveGrupoDocenteCargaAcademicaList(Map<String, dynamic> contactoDocente, int? cargaAcademicaId);

  Future<List<ListaGrupoUi>> getListaGrupos(int? cargaAcademicaId);

}