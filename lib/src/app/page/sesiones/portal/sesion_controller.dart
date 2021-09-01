import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/lista/sesion_lista_presenter.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/sesion_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';

class SesionController extends Controller{
  SesionPresenter presenter;
  CursosUi cursosUi;
  SesionUi sesionUi;
  List<CalendarioPeriodoUI> _calendarioPeriodoList = [];
  List<CalendarioPeriodoUI> get calendarioPeriodoList => _calendarioPeriodoList;

  SesionController(this.cursosUi, this.sesionUi):
        presenter = SesionPresenter();



  @override
  void initListeners() {


  }

  @override
  void onInitState() {
    super.onInitState();

  }

}