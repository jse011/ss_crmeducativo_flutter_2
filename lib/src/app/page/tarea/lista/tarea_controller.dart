import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';

class TareaController extends Controller{
  CursosUi cursosUi;
  List<CalendarioPeriodoUI> _calendarioPeriodoList = [];
  List<CalendarioPeriodoUI> get calendarioPeriodoList => _calendarioPeriodoList;

  TareaController(this.cursosUi);

  @override
  void initListeners() {
    CalendarioPeriodoUI calendarioPeriodoUI = CalendarioPeriodoUI();
    calendarioPeriodoUI.nombre = "Bimestr I";
    _calendarioPeriodoList.add(calendarioPeriodoUI);
    _calendarioPeriodoList.add(calendarioPeriodoUI);
    _calendarioPeriodoList.add(calendarioPeriodoUI);
    _calendarioPeriodoList.add(calendarioPeriodoUI);
    refreshUI();

  }


}