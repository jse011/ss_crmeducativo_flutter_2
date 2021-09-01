import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';

abstract class CalendarioPeriodoRepository{
  Future<List<CalendarioPeriodoUI>> getCalendarioPerios(int programaEducativoId, int cargaCursoId, int anioAcademicoId);
  Future<void> saveCalendarioPeriodoCursoFlutter(List<dynamic> calendarioPeriodoList, String urlServidorLocal, int anioAcademicoIdSelect, int programaEducativoIdSelect, int cargaCursoId);

}