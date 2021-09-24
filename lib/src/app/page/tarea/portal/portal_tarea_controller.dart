import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';

class PortalTareaController extends Controller{

  CursosUi? cursosUi;
  TareaUi? tareaUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;


  PortalTareaController(this.cursosUi, this.tareaUi, this.calendarioPeriodoUI);

  @override
  void initListeners() {
    // TODO: implement initListeners
  }

}