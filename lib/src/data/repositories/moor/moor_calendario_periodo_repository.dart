import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/database/app_database.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/calendario_perido_repository.dart';

class MoorCalendarioPeriodoRepository extends CalendarioPeriodoRepository{


  @override
  Future<List<CalendarioPeriodoUI>> getCalendarioPerios(int programaEducativoId, int cargaCursoId, int anioAcademicoId) async {
    print("calendarioPeriodoUI "+ programaEducativoId.toString() + " " +cargaCursoId.toString() + " "+ anioAcademicoId.toString());
      List<CalendarioPeriodoUI> calendarioPeriodoList = [];
      AppDataBase SQL = AppDataBase();

     List<CalendarioPeriodoCargaCursoData> list =
     await (SQL.select(SQL.calendarioPeriodoCargaCurso)..where((tbl) => tbl.cargaCursoId.equals(cargaCursoId))).get();

      for(CalendarioPeriodoCargaCursoData calendarioPeriodoData in list){
        CalendarioPeriodoUI calendarioPeriodoUI = CalendarioPeriodoUI();
        calendarioPeriodoUI.id = calendarioPeriodoData.calendarioPeriodoId;
        calendarioPeriodoUI.tipoId = calendarioPeriodoData.tipoId;
        calendarioPeriodoUI.nombre = calendarioPeriodoData.nombre;
        calendarioPeriodoUI.habilitado = calendarioPeriodoData.habilitado;
        calendarioPeriodoList.add(calendarioPeriodoUI);
      }

      return calendarioPeriodoList;
  }

  @override
  Future<void> saveCalendarioPeriodoCursoFlutter(List<dynamic> calendarioPeriodoList, String urlServidorLocal, int anioAcademicoIdSelect, int programaEducativoIdSelect, int cargaCursoId) async{
    AppDataBase SQL = AppDataBase();
    await SQL.batch((batch) async {
      (SQL.delete(SQL.calendarioPeriodoCargaCurso)..where((tbl) => tbl.cargaCursoId.equals(cargaCursoId))).go();
      batch.insertAll(SQL.calendarioPeriodoCargaCurso, SerializableConvert.converListSerializeCalendarioPeriodoCargaCurso(calendarioPeriodoList), mode: InsertMode.insertOrReplace);
    });
  }

}