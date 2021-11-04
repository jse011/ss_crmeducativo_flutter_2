import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/model/cursos.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';

class EscritorioController extends Controller{
  List<CursosUi> get cursosList {
    return _cursosList;
  }

  List<CursosUi> _cursosList = [];


  @override
  void initListeners() {
    _cursosList.add(CursosUi());
    cursos();
  }

  Future<void> cursos()async{
    var repo = MoorConfiguracionRepository();
    _cursosList.clear();
    _cursosList = await repo.getListCursos(await repo.getSessionEmpleadoId(), await repo.getSessionAnioAcademicoId(), await repo.getSessionProgramaEducativoId());
    refreshUI();
  }



}