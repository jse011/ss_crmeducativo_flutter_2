import 'package:moor_flutter/moor_flutter.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/database/app_database.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_qr_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_asistencia_qr_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/asistencia_qr_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/id_generator.dart';
import 'package:collection/collection.dart';

class MoorAsistenciaQRRepository extends AsistenciaQRRepository{



  @override
  Future<List<AsistenciaQRUi>> getAsistenciaQRHoy(DateTime? dateTime) async{
    AppDataBase SQL = AppDataBase();

    var query = SQL.select(SQL.asistenciaQR)..where((tbl) => tbl.anio.equals(dateTime?.year));
    query.where((tbl) => tbl.mes.equals(dateTime?.month));
    query.where((tbl) => tbl.dia.equals(dateTime?.day));

    query.orderBy([
          (u) => OrderingTerm(expression: u.anio, mode: OrderingMode.desc),
          (u) => OrderingTerm(expression: u.mes, mode: OrderingMode.desc),
          (u) => OrderingTerm(expression: u.dia, mode: OrderingMode.desc),
          (u) => OrderingTerm(expression: u.hora, mode: OrderingMode.desc),
          (u) => OrderingTerm(expression: u.minuto, mode: OrderingMode.desc),
          (u) => OrderingTerm(expression: u.segundo, mode: OrderingMode.desc),
    ]);

    List<AsistenciaQRUi> asistenciaQRUiList = [];
    List<AsistenciaQRData> asistenciaQRList = await query.get();
    for(AsistenciaQRData asistenciaQRData in asistenciaQRList){

      asistenciaQRUiList.add(transformarAsistenciaQR(asistenciaQRData));
    }

    return asistenciaQRUiList;
    
  }

  AsistenciaQRUi transformarAsistenciaQR(AsistenciaQRData? asistenciaQRData){
    AsistenciaQRUi asistenciaQRUi = AsistenciaQRUi();
    asistenciaQRUi.aistenciaQRId = asistenciaQRData?.aistenciaQRId;
    asistenciaQRUi.codigo = asistenciaQRData?.code;
    asistenciaQRUi.alumno = asistenciaQRData?.alumno;

    asistenciaQRUi.hora = asistenciaQRData?.hora;
    asistenciaQRUi.segundo = asistenciaQRData?.segundo;
    asistenciaQRUi.minuto = asistenciaQRData?.minuto;

    asistenciaQRUi.dia = asistenciaQRData?.dia;
    asistenciaQRUi.mes = asistenciaQRData?.mes;
    asistenciaQRUi.anio = asistenciaQRData?.anio;

    asistenciaQRUi.repetido = asistenciaQRData?.repetido;
    asistenciaQRUi.guardado = asistenciaQRData?.enviado;
    return asistenciaQRUi;
  }

  @override
  Future<AsistenciaQRUi?> getAsistenciaQRRepetida(AsistenciaQRUi? asistenciaQRUi) async{
    AppDataBase SQL = AppDataBase();
    var query = SQL.selectSingle(SQL.asistenciaQR)..where((tbl) => tbl.code.equals(asistenciaQRUi?.codigo));
    query.where((tbl) => tbl.anio.equals(asistenciaQRUi?.anio));
    query.where((tbl) => tbl.mes.equals(asistenciaQRUi?.mes));
    query.where((tbl) => tbl.dia.equals(asistenciaQRUi?.dia));
    AsistenciaQRData? asistenciaQRData = await query.getSingleOrNull();
    print("getAsistenciaQRRepetida ${asistenciaQRData?.alumno}");
    return asistenciaQRData!=null?transformarAsistenciaQR(asistenciaQRData):null;
  }

  @override
  void saveAsistenciaQR(AsistenciaQRUi? asistenciaQRUi) async{
    DateTime dateTime = DateTime(asistenciaQRUi?.anio??0,
        asistenciaQRUi?.mes??0, asistenciaQRUi?.dia??0, asistenciaQRUi?.hora??0, asistenciaQRUi?.minuto??0, asistenciaQRUi?.segundo??0);

    AppDataBase SQL = AppDataBase();
    AsistenciaQRData asistenciaQR = AsistenciaQRData(
        aistenciaQRId: asistenciaQRUi?.aistenciaQRId??"",
        anio: asistenciaQRUi?.anio,
        mes: asistenciaQRUi?.mes,
        dia: asistenciaQRUi?.dia,
        hora: asistenciaQRUi?.hora,
        minuto: asistenciaQRUi?.minuto,
        segundo: asistenciaQRUi?.segundo,
        alumno: asistenciaQRUi?.alumno,
        code: asistenciaQRUi?.codigo,
        repetido: asistenciaQRUi?.repetido,
        enviado: asistenciaQRUi?.guardado??false
    );

    await SQL.into(SQL.asistenciaQR).insert(asistenciaQR);
  }

  @override
  Future<void> updateAsistenciaQR(AsistenciaQRUi? asistenciaQRUi)async{
    AppDataBase SQL = AppDataBase();

    await (SQL.update(SQL.asistenciaQR)
      ..where((tbl) => tbl.aistenciaQRId.equals(asistenciaQRUi?.aistenciaQRId)))
        .write(
        AsistenciaQRCompanion(
          enviado: Value(asistenciaQRUi?.guardado??false),
          repetido: Value(asistenciaQRUi?.repetido)
        ));

  }

  @override
  Future<List<GrupoAsistenciaQRUi>> getAsistenciaQRNoEnviadas() async{
    AppDataBase SQL = AppDataBase();

    var query = SQL.select(SQL.asistenciaQR)..where((tbl) => tbl.enviado.equals(false));
    query.orderBy([
          (u) => OrderingTerm(expression: u.anio, mode: OrderingMode.desc),
          (u) => OrderingTerm(expression: u.mes, mode: OrderingMode.desc),
          (u) => OrderingTerm(expression: u.dia, mode: OrderingMode.desc),
          (u) => OrderingTerm(expression: u.hora, mode: OrderingMode.desc),
          (u) => OrderingTerm(expression: u.minuto, mode: OrderingMode.desc),
          (u) => OrderingTerm(expression: u.segundo, mode: OrderingMode.desc),
    ]);

    List<GrupoAsistenciaQRUi> gerupoAsistenciaQRUiList = [];
    List<AsistenciaQRData> asistenciaQRList = await query.get();

    for(AsistenciaQRData asistenciaQRData in asistenciaQRList){
      GrupoAsistenciaQRUi? grupoAsistenciaQRUi = gerupoAsistenciaQRUiList.firstWhereOrNull((element) => element.anio == asistenciaQRData.anio && element.mes == asistenciaQRData.mes && element.dia == asistenciaQRData.dia);

      if(grupoAsistenciaQRUi==null){
        grupoAsistenciaQRUi = GrupoAsistenciaQRUi();
        grupoAsistenciaQRUi.anio = asistenciaQRData.anio;
        grupoAsistenciaQRUi.mes = asistenciaQRData.mes;
        grupoAsistenciaQRUi.dia = asistenciaQRData.dia;
        grupoAsistenciaQRUi.asistenciaQRUiList = [];
        gerupoAsistenciaQRUiList.add(grupoAsistenciaQRUi);

      }
      grupoAsistenciaQRUi.asistenciaQRUiList?.add(transformarAsistenciaQR(asistenciaQRData));
    }
    return gerupoAsistenciaQRUiList;
  }

  @override
  Future<List<AsistenciaUi>> transformarAsistencia(List<dynamic> asistencias) async{
    List<AsistenciaUi> asistenciaUiList = [];

    asistencias.forEach((v) {
      Map<String, dynamic> json = v;
      AsistenciaUi asistenciaUi = AsistenciaUi();
      ValueSerializer serializer = moorRuntimeOptions.defaultSerializer;
      asistenciaUi.asistenciaId =
          serializer.fromJson<String>(json['asistenciaId']);
      asistenciaUi.nombreNivelAcademico =
          serializer.fromJson<String>(json['nombreNivelAcademico']);
      asistenciaUi.nombrePeriodo =
          serializer.fromJson<String>(json['nombrePeriodo']);
      asistenciaUi.nombreGrupo =
          serializer.fromJson<String>(json['nombreGrupo']);
      String nombres = serializer.fromJson<String>(json['nombres']);
      String apellidoPaterno = serializer.fromJson<String>(
          json['apellidoPaterno']);
      String apellidoMaterno = serializer.fromJson<String>(
          json['apellidoMaterno']);
      asistenciaUi.nombre =
      "${DomainTools.capitalize(apellidoPaterno)} ${DomainTools.capitalize(
          apellidoMaterno)} ${DomainTools.capitalize(nombres)}";
      String nombres_Padre = serializer.fromJson<String>(json['nombres_Padre']);
      String apellidoMaterno_Padre = serializer.fromJson<String>(
          json['apellidoMaterno_Padre']);
      String apellidoPaterno_Padre = serializer.fromJson<String>(
          json['apellidoPaterno_Padre']);
      asistenciaUi.nombreApoderado =
      "${DomainTools.capitalize(apellidoPaterno_Padre)} ${DomainTools
          .capitalize(apellidoMaterno_Padre)} ${DomainTools.capitalize(
          nombres_Padre)}";
      asistenciaUi.celularApoderado =
          serializer.fromJson<String>(json['celular_Padre']);
      asistenciaUi.correoApoderado =
          serializer.fromJson<String>(json['correo_Padre']);
      asistenciaUi.horaIngreso =
          serializer.fromJson<String>(json['horaIngreso']);
      asistenciaUi.contador =
          serializer.fromJson<int>(json['contador']);
      asistenciaUi.total =
          serializer.fromJson<int>(json['total']);
      if (json.containsKey("controlDetall")) {
        Map<String, dynamic> controlDetallejson = json["controlDetall"];
        asistenciaUi.estadoIngreso =
            serializer.fromJson<String>(controlDetallejson['NombreEstado']);
      }
      asistenciaUiList.add(asistenciaUi);
    });
    return asistenciaUiList;
  }



}