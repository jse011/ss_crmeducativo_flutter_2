import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/io_client.dart';
import 'package:ss_crmeducativo_2/src/data/helpers/serelizable/rest_api_response.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/database/app_database.dart';
import 'package:ss_crmeducativo_2/src/device/utils/http_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_comentario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';

class DeviceHttpDatosRepositorio extends HttpDatosRepository{
  static const  TAG = "DeviceHttpDatosRepositorio";
  static const MIN_TIMEOUT = 60;
  static const MAX_TIMEOUT = MIN_TIMEOUT*2;

  String getBody(String method, Object parameters){
    Map<String, dynamic> body = Map<String, dynamic>();
    body["interface"] = "RestAPI";
    body["method"] = method;
    body["parameters"] = parameters;
    String s = json.encode(body);
    log(TAG + " "+s);
    return s;
  }

  @override
  Future<Map<String, dynamic>> getDatosInicioDocente(String urlServidor, int usuarioId) async {
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_UsuarioId"] = usuarioId;
    final response = await http.post(Uri2.parse(urlServidor), body: getBody("flst_getDatosInicioSesion",parameters));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        throw Exception('Failed to load usuario 1');
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load usuario 0');
    }
  }

  @override
  Future<Map<String, dynamic>?> getUsuario(String urlServidor, int usuarioId) async {
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_usuarioId"] = usuarioId;

    final response = await http.post(Uri2.parse(urlServidor), body: getBody("fobj_ObtenerUsuarioComplejo",parameters));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){

        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load crear_agenda 0');
    }
  }

  @override
  Future<Map<String, dynamic>?> getUsuarioExterno(int opcion, String usuario, String password, String correo, String dni) async{

    Map<String, dynamic> obj_usuario = Map<String, dynamic>();
    obj_usuario["Opcion"] = opcion;
    obj_usuario["Usuario"] = usuario;
    obj_usuario["Passwordd"] = password;
    obj_usuario["Correo"] = correo;
    obj_usuario["NumDoc"] = dni;

    Map<String, dynamic>  parameters = Map<String, dynamic>();
    parameters["vobj_Usuario"] = obj_usuario;

    try {

      final response = await http.post(Uri2.parse(HttpTools.GlobalHttp), body: getBody("f_BuscarUsuarioCent",parameters))
          .timeout(Duration(seconds: MIN_TIMEOUT));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String,dynamic> body = json.decode(response.body);
        if(body.containsKey("Successful")&&body.containsKey("Value")){
          return body["Value"];;
        }else{
          return null;
        }

      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load crear_agenda 0');
      }

    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      return null;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      throw Exception('Failed to load crear_agenda 0');
    } on Error catch (e) {
      print('General Error: $e');
      return null;
    }

  }

  @override
  Future<Map<String, dynamic>> getDatosAnioAcademico(String urlServidorLocal, int empleadoId, int anioAcademicoId) async {
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_EmpleadoId"] = empleadoId;
    parameters["vint_AnioAcademicoId"] = anioAcademicoId;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("flst_getDatosAnioAcademicoFlutter",parameters))
        .timeout(Duration(seconds: MIN_TIMEOUT), onTimeout: (){throw Exception('Failed to load getEventoAgenda');});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        throw Exception('Failed to load usuario 1');
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load usuario 0');
    }
  }

  @override
  Future<Map<String, dynamic>?> updateDatosParaCrearRubro(String urlServidorLocal, int anioAcademicoId, int programaEducativoId, int calendarioPeriodoId, int silaboEventoId, int empleadoId, int sesionAprendizajeId)  async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_AnioAcademicoId"] = anioAcademicoId;
    parameters["vint_ProgramaEducativoId"] = programaEducativoId;
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_EmpleadoId"] = empleadoId;
    parameters["vint_SesionAprendizajeId"] = sesionAprendizajeId;

    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("getDatosParaCrearRubro",parameters))
        .timeout(Duration(seconds: MAX_TIMEOUT), onTimeout: (){throw Exception('Failed to load getEventoAgenda');});;
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load usuario 0');
    }
  }

  @override
  Future<Map<String, dynamic>?> getContactoDocente(String urlServidorLocal, int empleadoId, int anioAcademicoId) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_EmpleadoId"] = empleadoId;
    parameters["vint_AnioAcademicoId"] = anioAcademicoId;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("getContactoDocenteFlutter",parameters))
        .timeout(Duration(seconds: MIN_TIMEOUT), onTimeout: (){throw Exception('Failed to load getEventoAgenda');});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        throw Exception('Failed to load');
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }

  @override
  Future<Map<String, dynamic>?> getEventoAgenda(String urlServidorLocal, int usuarioId, int georeferenciaId, int tipoEventoId) async {

    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_UsuarioId"] = usuarioId;
    parameters["vint_GeoreferenciaId"] = georeferenciaId;
    parameters["vint_tipoEventoId"] = tipoEventoId;

    final response = await http.post(Uri2.parse(urlServidorLocal),
        body: getBody("getCalendarioEventoDocenteFlutter",parameters))
        .timeout(Duration(seconds: MIN_TIMEOUT));
    /*
    var params =  {
      "item": "itemx",
      "options": [1,2,3],
    };*/
    /*Dio dio = Dio();
    Response response = await dio.post(Uri2.validate(urlServidorLocal),
    options: Options(
        headers: { HttpHeaders.contentTypeHeader: "application/json",},
        ),
      onSendProgress: (int sent, int total) {
        print('onSendProgress: $sent $total');
      },
      onReceiveProgress: (rec, total) {
        print('onReceiveProgress: $rec $total');
      },
    data: getBody("getCalendarioEventoDocenteFlutter",parameters),
    );*/

   //print("getEventoAgenda ${byte.lengthInBytes}");
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);

      if(body.containsKey("Successful")&&body.containsKey("Value")){
        print("success getCalendarioEventoDocenteFlutter");
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load crear_agenda 0');
    }

  }

  @override
  Future<Map<String, dynamic>?> getUnidadSesion(String urlServidorLocal, int usuarioId, int calendarioId, int silaboEventoId, int rolId) async {

    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_UsuarioId"] = usuarioId;
    parameters["vint_CalendarioPeriodoId"] = calendarioId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_rolId"] = rolId;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("getUnidadSesionDocenteFlutter",parameters))
        .timeout(Duration(seconds: MIN_TIMEOUT), onTimeout: (){throw Exception('Failed to load getUnidadSesion');});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load crear_agenda 0');
    }

  }

  @override
  Future<List<dynamic>?> getCalendarioPeriodoCursoFlutter(String urlServidorLocal, int anioAcademicoId, int programaEducativoId, int cargaCursoId) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_AnioAcademicoId"] = anioAcademicoId;
    parameters["vint_ProgramaEducativoId"] = programaEducativoId;
    parameters["vint_CargaCursoId"] = cargaCursoId;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("getCalendarioPeriodoCursoFlutter",parameters))
        .timeout(Duration(seconds: MIN_TIMEOUT), onTimeout: (){throw Exception('Failed to load getUnidadSesion');});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){
        log("getCalendarioPeriodoCursoFlutter ${body.containsKey("Value").toString()}");
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load crear_agenda 0');
    }
  }

  @override
  Future<Map<String, dynamic>?> getDatosRubroFlutter(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int georeferenciaId, int usuarioId, int sesionAprendizajeDocenteId, int sesionAprendizajeAlumnoId, String? tareaId,List<dynamic> rubrosNoEnviados, bool contenidoExtra, int anioAcademicoId, int programaEducativoId, int empleadoId) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_GeoreferenciaId"] = georeferenciaId;
    parameters["vint_UsuarioId"] = usuarioId;
    parameters["vint_SesionAprendizajeDocenteId"] = sesionAprendizajeDocenteId;
    parameters["vint_SesionAprendizajeAlumnoId"] = sesionAprendizajeAlumnoId;
    parameters["vstr_tareaId"] = tareaId;
    parameters["vlst_RubroEvalEnvioSimple"] = rubrosNoEnviados;
    parameters["vbol_contenidoExtra"] = contenidoExtra;
    parameters["vint_AnioAcademicoId"] = anioAcademicoId;
    parameters["vint_ProgramaEducativoId"] = programaEducativoId;
    parameters["vint_EmpleadoId"] = empleadoId;


    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("getDatosRubroFlutter",parameters))
        .timeout(Duration(seconds: MAX_TIMEOUT), onTimeout: (){throw Exception('Failed to load getDatosRubroFlutter');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);

      if(body.containsKey("Successful")&&body.containsKey("Value")){

        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load rubro eval');
    }
  }


  @override
  Future<bool?> crearRubroEvaluacion(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int georeferenciaId, int usuarioId, Map<String, dynamic> data) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_GeoreferenciaId"] = georeferenciaId;
    parameters["vint_UsuarioId"] = usuarioId;
    parameters["bERubroEvalEnvio"] = data;
    String params = getBody("crearRubroEvaluacion", parameters);
    //log(params);
    final response = await http.post(Uri2.parse(urlServidorLocal), body: params)
        .timeout(Duration(seconds: MIN_TIMEOUT), onTimeout: (){throw Exception('Failed to load rubro eval');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);

      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return false;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load rubro eval');
    }
  }

  @override
  Future<HttpStream> crearRubroEvaluacion2(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int georeferenciaId, int usuarioId, Map<String, dynamic> data, HttpSuccess httpSuccessListen) async {
    CancelToken token = CancelToken();
    DioCancellation dioCancellation = DioCancellation(token);
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_GeoreferenciaId"] = georeferenciaId;
    parameters["vint_UsuarioId"] = usuarioId;
    parameters["bERubroEvalEnvio"] = data;
    Dio dio = new Dio();
    String params = getBody("crearRubroEvaluacion", parameters);
    //log(params);
    dio.post(
      Uri2.validate(urlServidorLocal),
      data: params,
      cancelToken: token,
    ).then((Response response) async{
      if (response.statusCode == 200) {
        Map<String,dynamic> body = response.data;
        if(body.containsKey("Successful")&&body.containsKey("Value")){
          dioCancellation.finishesd = true;
          httpSuccessListen.call(body["Value"], true);
          print("Response success");
        }else{
          dioCancellation.finishesd = true;
          httpSuccessListen.call(false, true);
          print("Response null ${response.data}");
        }
      }
    }).catchError((dioError, stackTrace) {
      switch (dioError.type) {
        case DioErrorType.cancel:
        //message = "Request to API server was cancelled";
          break;
        case DioErrorType.connectTimeout:
          print("Connection timeout with API server");
          httpSuccessListen.call(false, true);
          break;
        case DioErrorType.other:
          print("Connection to API server failed due to internet connection");
          httpSuccessListen.call(false, true);
          break;
        case DioErrorType.receiveTimeout:
          httpSuccessListen.call(false, true);
          print("Receive timeout in connection with API server");
          break;
        case DioErrorType.response:
        /// When the server response, but with a incorrect status, such as 404, 503...
          httpSuccessListen.call(false, false);
          print("Response error 404, 503 ...");
          break;
        case DioErrorType.sendTimeout:
          throw Exception("Send timeout in connection with API server");
        default:
          httpSuccessListen.call(false, false);
          print("Response error Something went wrong");
          //message = "Something went wrong";
          break;
      }
    });

    return dioCancellation;
  }


  @override
  Future<bool?> updateEvaluacionRubroFlutter(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int georeferenciaId, int usuarioId, Map<String, dynamic> data) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_GeoreferenciaId"] = georeferenciaId;
    parameters["vint_UsuarioId"] = usuarioId;
    parameters["bERubroEvalEnvio"] = data;
    String params = getBody("updateEvaluacionRubroFlutter", parameters);
    //log(params);
    final response = await http.post(Uri2.parse(urlServidorLocal), body: params)
        .timeout(Duration(seconds: MIN_TIMEOUT), onTimeout: (){throw Exception('Failed to load rubro eval');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);

      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return false;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load rubro eval');
    }
  }

  @override
  Future<bool?> updateCompetenciaRubroFlutter(String urlServidorLocal, int georeferenciaId, int usuarioId, List<Map<String, dynamic>?> rubrosEnviados) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_GeoreferenciaId"] = georeferenciaId;
    parameters["vint_UsuarioId"] = usuarioId;
    parameters["bERubroEvalEnvioSimplesList"] = rubrosEnviados;
    print("updateCompetenciaRubroFlutter");
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("updateCompetenciaRubroFlutter", parameters))
        .timeout(Duration(seconds: MAX_TIMEOUT), onTimeout: (){throw Exception('Failed to load rubro eval');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);

      if(body.containsKey("Successful")&&body.containsKey("Value")){
        print("Value: ${body.containsKey("Value")}");
        return body["Value"];
      }else{
        return false;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load rubro eval');
    }
  }

  @override
  Future<Map<String, dynamic>?> getUnidadTarea(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("getUnidadTareaDocenteFlutter", parameters))
        .timeout(Duration(seconds: MAX_TIMEOUT), onTimeout: (){throw Exception('Failed to load rubro eval');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);

      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load unidad tarea');
    }
  }

  @override
  Future<Map<String, dynamic>?> getInfoTareaDocente(String urlServidorLocal, String? tareaId, int? silaboEventoId, int? unidadEventoId) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vstr_TareaId"] = tareaId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_UnidadEventoId"] = unidadEventoId;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("getInfoTareaDocente", parameters))
        .timeout(Duration(seconds: MAX_TIMEOUT), onTimeout: (){throw Exception('Failed to load rubro eval');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);

      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load info tarea');
    }
  }

  @override
  Future<HttpStream> uploadFileArchivoDocente(String urlServidorLocal, int silaboEventoId, String nombre, File file, HttpProgressListen progressListen, HttpValueSuccess httpSuccessListen) async{
    CancelToken token = CancelToken();
    DioCancellation dioCancellation = DioCancellation(token);
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_SilaboEventoId"] = silaboEventoId;

    var formData = FormData.fromMap({
      'body': getBody("uploadFileArchivoDocente", parameters),
      'file': await MultipartFile.fromFile(file.path, filename: nombre),
    });

    Dio dio = new Dio();
    dio.post(
      Uri2.validate(urlServidorLocal),
      data: formData,
      cancelToken: token,
      onSendProgress: (received, total){
        if (total != -1){
          var progress = (received / total * 100);
          print("${progress}%");
          progressListen.call(progress);
        }
      },
    ).then((Response response) async{
      if (response.statusCode == 200) {
        Map<String,dynamic> body = response.data;
        if(body.containsKey("Successful")&&body.containsKey("Value")){
          dioCancellation.finishesd = true;
          httpSuccessListen.call(true, body["Value"]);
          print("Response success");
        }else{
          dioCancellation.finishesd = true;
          httpSuccessListen.call(false, null);
          print("Response null");
        }
      }
    });

    return dioCancellation;
  }

  @override
  Future<bool?> saveTareaDocente(String urlServidorLocal, Map<String, dynamic> data) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vobj_TareEvento"] = data;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("saveTareaDocente", parameters))
        .timeout(Duration(seconds: MIN_TIMEOUT), onTimeout: (){throw Exception('Failed to load tarea eval');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);

      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load info tarea');
    }

  }

  @override
  Future<Map<String, dynamic>?> getSesionTarea(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int sesionAprendizajeId) async {
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_SesionAprendizajeId"] = sesionAprendizajeId;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("getSesionTareaDocenteFlutter", parameters))
        .timeout(Duration(seconds: MAX_TIMEOUT), onTimeout: (){throw Exception('Failed to load tarea sesion');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);

      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load unidad tarea');
    }
  }

  @override
  Future<bool?> saveEstadoTareaDocente(String urlServidorLocal, String? tareaId, int? estadoId, int? usuarioId) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vstr_TareaId"] = tareaId;
    parameters["vint_EstadoId"] = estadoId;
    parameters["vint_UsuarioId"] = usuarioId;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("saveEstadoTareaDocente", parameters))
        .timeout(Duration(seconds: MIN_TIMEOUT), onTimeout: (){throw Exception('Failed to load tarea eval');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);

      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load info tarea');
    }
  }

  @override
  Future<Map<String, dynamic>?> getMatrizResultado(String urlServidor, int? silaboEventoId, int? cargaCursoId, int? calendarioPeriodoId) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_CargaCursoId"] = cargaCursoId;
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    final response = await http.post(Uri2.parse(urlServidor), body: getBody("flst_RegistroEvaluacionFlutter", parameters))
        .timeout(Duration(seconds: MAX_TIMEOUT), onTimeout: (){throw Exception('Failed to load tarea eval');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load info tarea');
    }
  }

  @override
  Future<HttpStream?> uploadFileAgendaDocente(String urlServidorLocal, String nombre, File file, HttpProgressListen progressListen, HttpValueSuccess httpSuccessListen) async {
    CancelToken token = CancelToken();
    DioCancellation dioCancellation = DioCancellation(token);
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_UsuarioId"] = 0;
    print("nombre ${nombre}");
    print("nombre ${file.path}");
    var formData = FormData.fromMap({
      'body': getBody("uploadFileAgendaDocente", parameters),
      'file': await MultipartFile.fromFile(file.path, filename: nombre),
    });
    Dio dio = new Dio();
    dio.post(
      Uri2.validate(urlServidorLocal),
      data: formData,
      cancelToken: token,
      onSendProgress: (received, total){
        if (total != -1){
          var progress = (received / total * 100);
          print("${progress}%");
          progressListen.call(progress);
        }
      },
    ).then((Response response) async{
      if (response.statusCode == 200) {
        Map<String,dynamic> body = response.data;
        print("Response success");
        if(body.containsKey("Successful")&&body.containsKey("Value")){
          dioCancellation.finishesd = true;
          httpSuccessListen.call(true, body["Value"]);
          print("Response success");
        }else{
          dioCancellation.finishesd = true;
          httpSuccessListen.call(false, null);
          print("Response null ${response.data}");
        }
      }
    });

    return dioCancellation;
  }

  @override
  Future<bool?> saveEventoDocente(String urlServidorLocal, Map<String, dynamic> data)async {
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vobj_Eventos"] = data["evento"];
    parameters["vobj_Calendario"] = data["calendario"];
    parameters["vlst_EventoPersona"] = data["eventoPersonas"];
    parameters["vlst_EventoAdjunto"] = data["eventoAdjuntos"];

    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("saveEventoFlutter", parameters))
        .timeout(Duration(seconds: MAX_TIMEOUT), onTimeout: (){throw Exception('Failed to load tarea eval');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);

      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load info tarea');
    }
  }

  @override
  Future<bool?> changeEventoEstadoDocente(String urlServidorLocal, String? eventoId, int? estadoId, bool? publicado, int? usuarioId) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    Map<String, dynamic> evento = Map<String, dynamic>();

    evento["eventoId"] = eventoId;
    evento["estadoId"] = estadoId;
    evento["estadoPublicacion"] = publicado;
    evento["usuarioAccionId"] = usuarioId;


    parameters["vobj_Eventos"] = evento;


    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("changeEventoEstadoFlutter", parameters))
        .timeout(Duration(seconds: MIN_TIMEOUT), onTimeout: (){throw Exception('Failed to load tarea eval');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);

      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load info tarea');
    }
  }

  @override
  Future<bool?> saveTareaDocenteFlutter(String urlServidorLocal, Map<String, dynamic> data)async {
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vobj_TareEvento"] = data;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("saveTareaDocenteFirebase", parameters))
        .timeout(Duration(seconds: MIN_TIMEOUT), onTimeout: (){throw Exception('Failed to load tarea eval');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);

      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load info tarea');
    }
  }

  @override
  Future<HttpStream> saveTareaEvalDocente(String urlServidorLocal, int? georeferenciaId,int? usuarioId, int? calendarioPeriodoId, int? silaboEventoId, int? unidadAprendizajeId, String? tareaId, Map<String, dynamic> dataSerial, HttpSuccess httpSuccessListen) async{

    Dio dio = new Dio();
    DioCancellation2 dioCancellation = DioCancellation2(dio);
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_GeoreferenciaId"] = georeferenciaId;
    parameters["vint_UsuarioId"] = usuarioId;
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_UnidadAprendizajeId"] = unidadAprendizajeId;
    parameters["vstr_TareaId"] = tareaId;
    parameters["bERubroEvalEnvio"] = dataSerial;


    String params = getBody("evaluacionTareaFlutter", parameters);
    log(params);



    dio.post(
      Uri2.validate(urlServidorLocal),
      data: params,
      cancelToken: dioCancellation.token,
    ).then((Response response) async{
      if (response.statusCode == 200) {
        Map<String,dynamic> body = response.data;
        if(body.containsKey("Successful")&&body.containsKey("Value")){
          dioCancellation.finishesd = true;
          httpSuccessListen.call(body["Value"], false);
          print("Response success");
        }else{
          dioCancellation.finishesd = true;
          httpSuccessListen.call(false, false);
          print("Response null ${response.data}");
        }
      }
    }).catchError((dioError, stackTrace) {
      dioCancellation.finishesd = true;
      switch (dioError.type) {
        case DioErrorType.cancel:
          print("Request to API server was cancelled");
          httpSuccessListen.call(false, false);
          break;
        case DioErrorType.connectTimeout:
          print("Connection timeout with API server");
          httpSuccessListen.call(false, true);
          break;
        case DioErrorType.other:
          print("Connection to API server failed due to internet connection");
          httpSuccessListen.call(false, true);
          break;
        case DioErrorType.receiveTimeout:
          httpSuccessListen.call(false, true);
          print("Receive timeout in connection with API server");
          break;
        case DioErrorType.response:
        /// When the server response, but with a incorrect status, such as 404, 503...
          httpSuccessListen.call(null, false);
          print("Response error 404, 503 ...");
          break;
        case DioErrorType.sendTimeout:
          print("Send timeout in connection with API server");
          httpSuccessListen.call(false, true);
          break;
        default:
          httpSuccessListen.call(false, false);
          print("Response error Something went wrong");
          //message = "Something went wrong";
          break;
      }
    });

    return dioCancellation;
  }

  @override
  Future<HttpStream> procesarEvaluacionTarea(String urlServidorLocal, int georeferenciaId, int usuarioId, int? calendarioPeriodoId, int? silaboEventoId, int? unidadEventoId, String? rubroEvalId, String? tareaId, HttpSuccess httpSuccessListen) async {
    Dio dio = new Dio();
    DioCancellation2 dioCancellation = DioCancellation2(dio);
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_UsuarioId"] = usuarioId;
    parameters["vint_GeoreferenciaId"] = georeferenciaId;
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_UnidadAprendizajeId"] = unidadEventoId;
    parameters["vstr_RubroEvalId"] = rubroEvalId;
    parameters["vstr_TareaId"] = tareaId;


    String params = getBody("procesarEvaluacionTareaFlutter", parameters);
    //log(params);
    dio.post(
      Uri2.validate(urlServidorLocal),
      data: params,
      cancelToken: dioCancellation.token,
    ).then((Response response) async{
      if (response.statusCode == 200) {
        Map<String,dynamic> body = response.data;
        if(body.containsKey("Successful")&&body.containsKey("Value")){
          dioCancellation.finishesd = true;
          httpSuccessListen.call(body["Value"], false);
          print("Response success");
        }else{
          dioCancellation.finishesd = true;
          httpSuccessListen.call(null, false);
          print("Response null ${response.data}");
        }
      }
    }).catchError((dioError, stackTrace) {
      dioCancellation.finishesd = true;
      try{
        switch (dioError.type) {
          case DioErrorType.cancel:
            print("Request to API server was cancelled");
            httpSuccessListen.call(false, false);
            break;
          case DioErrorType.connectTimeout:
            print("Connection timeout with API server");
            httpSuccessListen.call(false, true);
            break;
          case DioErrorType.other:
            print("Connection to API server failed due to internet connection");
            httpSuccessListen.call(false, true);
            break;
          case DioErrorType.receiveTimeout:
            httpSuccessListen.call(false, true);
            print("Receive timeout in connection with API server");
            break;
          case DioErrorType.response:
          /// When the server response, but with a incorrect status, such as 404, 503...
            httpSuccessListen.call(null, false);
            print("Response error 404, 503 ...");
            break;
          case DioErrorType.sendTimeout:
            print("Send timeout in connection with API server");
            httpSuccessListen.call(false, true);
            break;
          default:
            httpSuccessListen.call(false, false);
            print("Response error Something went wrong");
            //message = "Something went wrong";
            break;
        }
      }catch(e){
        print(e);
        httpSuccessListen.call(null, false);
      }

    });

    return dioCancellation;
  }

  @override
  Future<HttpStream> getUrlDownloadTareaEvaluacion(String urlServidorLocal, int? silaboEventoId, int? unidadAprendizajeId, String? tareaId, int? personaId, String? archivo, HttpSuccessValue2 httpSuccessListen) async{

    Dio dio = new Dio();
    DioCancellation2 dioCancellation = DioCancellation2(dio);
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_UnidadAprendizajeId"] = unidadAprendizajeId;
    parameters["vstr_TareaId"] = tareaId;
    parameters["vint_PersonaId"] = personaId;
    parameters["vsts_Archivo"] = archivo;


    String params = getBody("getUrlDowloadTareaEvaluacion", parameters);
    //log(params);
    dio.post(
      Uri2.validate(urlServidorLocal),
      data: params,
      cancelToken: dioCancellation.token,
    ).then((Response response) async{
      if (response.statusCode == 200) {
        Map<String,dynamic> body = response.data;
        if(body.containsKey("Successful")&&body.containsKey("Value")){
          dioCancellation.finishesd = true;
          httpSuccessListen.call(body["Value"], false, );
          print("Response success");
        }else{
          dioCancellation.finishesd = true;
          httpSuccessListen.call(null, false);
          print("Response null ${response.data}");
        }
      }
    }).catchError((dioError, stackTrace) {
      dioCancellation.finishesd = true;
      try{
        switch (dioError.type) {
          case DioErrorType.cancel:
            print("Request to API server was cancelled");
            httpSuccessListen.call(false, false);
            break;
          case DioErrorType.connectTimeout:
            print("Connection timeout with API server");
            httpSuccessListen.call(false, true);
            break;
          case DioErrorType.other:
            print("Connection to API server failed due to internet connection");
            httpSuccessListen.call(false, true);
            break;
          case DioErrorType.receiveTimeout:
            httpSuccessListen.call(false, true);
            print("Receive timeout in connection with API server");
            break;
          case DioErrorType.response:
          /// When the server response, but with a incorrect status, such as 404, 503...
            httpSuccessListen.call(null, false);
            print("Response error 404, 503 ...");
            break;
          case DioErrorType.sendTimeout:
            print("Send timeout in connection with API server");
            httpSuccessListen.call(false, true);
            break;
          default:
            httpSuccessListen.call(false, false);
            print("Response error Something went wrong");
            //message = "Something went wrong";
            break;
        }
      }catch(e){
        print(e);
        httpSuccessListen.call(null, false);
      }

    });

    return dioCancellation;


  }

  @override
  Future<List<dynamic>?> getSesionesHoy(String urlServidorLocal, int? anioAcademicoId, int? docenteId) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_AnioAcademicoId"] = anioAcademicoId;
    parameters["vint_DocenteId"] = docenteId;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("getSesionesHoy",parameters))
        .timeout(Duration(seconds: MIN_TIMEOUT), onTimeout: (){throw Exception('Failed to load getSesionesHoy');});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load crear_agenda 0');
    }
  }

  @override
  Future<Map<String, dynamic>?> getAprendizajeSesion(String urlServidorLocal, int? sesionAprendizajeId) async {
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_SesionAprendizajeId"] = sesionAprendizajeId;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("getAprendizajeSesion",parameters))
        .timeout(Duration(seconds: MIN_TIMEOUT), onTimeout: (){throw Exception('Failed to load getAprendizajeSesion');});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load crear_agenda 0');
    }
  }

  @override
  Future<HttpStream?> uploadFilePersona(String urlServidorLocal, PersonaUi? personaUi, File? foto, bool? soloCambiarFoto, bool? removeFoto, HttpProgressListen progressListen, HttpValueSuccess httpSuccessListen) async {
    CancelToken token = CancelToken();
    DioCancellation dioCancellation = DioCancellation(token);

    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["bEPersona"] = DomainTools.removeNull( PersonaSerial(
      personaId: personaUi?.personaId??0,
      celular: personaUi?.telefono,
      correo: personaUi?.correo,
    ).toJson());
    parameters["vbol_soloCambiarFoto"] = soloCambiarFoto??false;
    parameters["vbol_removeFoto"] = removeFoto??false;

    var formData;

    if(foto!=null){
      formData = FormData.fromMap({
        'body': getBody("uploadPersonaDocente", parameters),
        'file': await MultipartFile.fromFile(foto.path, filename: ""),
      });
    }else{
      formData = getBody("uploadPersonaDocente", parameters);
    }

    Dio dio = new Dio();
    dio.post(
      Uri2.validate(urlServidorLocal),
      data: formData,
      cancelToken: token,
      onSendProgress: (received, total){
        if (total != -1){
          var progress = (received / total * 100);
          print("${progress}%");
          progressListen.call(progress);
        }
      },
    ).then((Response response) async{
      if (response.statusCode == 200) {
        Map<String,dynamic> body = response.data;
        print("Response ${body.toString()}");
        if(body.containsKey("Successful")&&body.containsKey("Value")){
          dioCancellation.finishesd = true;
          httpSuccessListen.call(true, body["Value"]);
          print("Response success");
        }else{
          dioCancellation.finishesd = true;
          httpSuccessListen.call(false, null);
          print("Response null ${response.data}");
        }
      }
    });

    return dioCancellation;
  }

  @override
  Future<bool?> saveEstadoSesion(String urlServidorLocal, int? sesionAprendizajeId, int estado_hecho, int usuarioId)async {
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_SesionAprendizajeId"] = sesionAprendizajeId;
    parameters["vint_EstadoId"] = estado_hecho;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("saveEstadoSesion", parameters))
        .timeout(Duration(seconds: MIN_TIMEOUT), onTimeout: (){throw Exception('Failed to load tarea eval');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);

      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load info tarea');
    }
  }

  @override
  Future<List?> getActividadesSesion(String urlServidorLocal, int? sesionAprendizajeId) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_SesionAprendizajeId"] = sesionAprendizajeId;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("getActividadesSesion",parameters))
        .timeout(Duration(seconds: MIN_TIMEOUT), onTimeout: (){throw Exception('Failed to load getActividadesSesion');});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load crear_agenda 0');
    }
  }

  @override
  Future<Map<String, dynamic>?> updateUsuario(String urlServidorLocal, int usuarioId)async {
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_usuarioId"] = usuarioId;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("fobj_ObtenerUsuarioSimple",parameters))
        .timeout(Duration(seconds: MIN_TIMEOUT), onTimeout: (){throw Exception('Failed to load updateUsuario');});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load crear_agenda 0');
    }
  }

  @override
  Future<HttpStream> updateEvaluacionRubroFlutter2(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int georeferenciaId, int usuarioId, Map<String, dynamic> data, HttpSuccess httpSuccessListen) async{

    CancelToken token = CancelToken();
    DioCancellation dioCancellation = DioCancellation(token);
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_GeoreferenciaId"] = georeferenciaId;
    parameters["vint_UsuarioId"] = usuarioId;
    parameters["bERubroEvalEnvio"] = data;
    Dio dio = new Dio();
    String params = getBody("updateEvaluacionRubroFlutter", parameters);
    //log(params);
    dio.post(
      Uri2.validate(urlServidorLocal),
      data: params,
      cancelToken: token,
    ).then((Response response) async{
      if (response.statusCode == 200) {
        Map<String,dynamic> body = response.data;
        if(body.containsKey("Successful")&&body.containsKey("Value")){
          dioCancellation.finishesd = true;
          httpSuccessListen.call(body["Value"], true);
          print("Response success");
        }else{
          dioCancellation.finishesd = true;
          httpSuccessListen.call(false, true);
          print("Response null ${response.data}");
        }
      }
    }).catchError((dioError, stackTrace) {
      switch (dioError.type) {
        case DioErrorType.cancel:
        //message = "Request to API server was cancelled";
          break;
        case DioErrorType.connectTimeout:
          print("Connection timeout with API server");
          httpSuccessListen.call(false, true);
          break;
        case DioErrorType.other:
          print("Connection to API server failed due to internet connection");
          httpSuccessListen.call(false, true);
          break;
        case DioErrorType.receiveTimeout:
          httpSuccessListen.call(false, true);
          print("Receive timeout in connection with API server");
          break;
        case DioErrorType.response:
        /// When the server response, but with a incorrect status, such as 404, 503...
          httpSuccessListen.call(false, false);
          print("Response error 404, 503 ...");
          break;
        case DioErrorType.sendTimeout:
          throw Exception("Send timeout in connection with API server");
        default:
          httpSuccessListen.call(false, false);
          print("Response error Something went wrong");
          //message = "Something went wrong";
          break;
      }
    });

    return dioCancellation;

  }

  @override
  Future<bool?> cerrarCursoDocente(String urlServidorLocal, int? cargaCursoId, int? calendarioPeriodoId, int usuarioId) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_CargaCursoId"] = cargaCursoId;
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_usuarioId"] = usuarioId;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("fupd_cerrarCursoDocente", parameters))
        .timeout(Duration(seconds: MIN_TIMEOUT), onTimeout: (){throw Exception('Failed to load tarea eval');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);

      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load info tarea');
    }
  }

  @override
  Future<bool?> updResultadoFlutter(String urlServidorLocal, int? silaboEventoId, int? cargaCursoId, int? calendarioPeriodoId, int usuarioId, List rubrosNoEnviados) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_CargaCursoId"] = cargaCursoId;
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_usuarioId"] = usuarioId;
    parameters["vlst_RubroEvalEnvioSimple"] = rubrosNoEnviados;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("fupd_ResultadoFlutter", parameters))
        .timeout(Duration(seconds: MAX_TIMEOUT), onTimeout: (){throw Exception('Failed to load tarea eval');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);

      if(body.containsKey("Successful")&&body.containsKey("Value")){
        return body["Value"];
      }else{
        return null;
      }

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load info tarea');
    }
  }

  @override
  Future<HttpStream?> uploadRubroComentario(String urlServidorLocal, Map<String, dynamic> json, HttpValueSuccess httpValueSuccess)async {
    CancelToken token = CancelToken();
    DioCancellation dioCancellation = DioCancellation(token);

    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vobj_RubroComentario"] = json;


    Dio dio = new Dio();
    dio.post(
      Uri2.validate(urlServidorLocal),
      data: getBody("fbol_uploadRubtoComentario", parameters),
      cancelToken: token,
      onSendProgress: (received, total){
        if (total != -1){
          var progress = (received / total * 100);
          print("${progress}%");
        }
      },
    ).then((Response response) async{
      if (response.statusCode == 200) {
        Map<String,dynamic> body = response.data;
        print("Response ${body.toString()}");
        if(body.containsKey("Successful")&&body.containsKey("Value")){
          dioCancellation.finishesd = true;
          httpValueSuccess.call(true, body["Value"]);
          print("Response success");
        }else{
          dioCancellation.finishesd = true;
          httpValueSuccess.call(false, null);
          print("Response null ${response.data}");
        }
      }
    });

    return dioCancellation;
  }

  @override
  Future<HttpStream?> uploadFileRubroEvidencia(String urlServidorLocal, String nombre, File file, HttpProgressListen progressListen, HttpValueSuccess httpSuccessListen) async{
    CancelToken token = CancelToken();
    DioCancellation dioCancellation = DioCancellation(token);
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_UsuarioId"] = 0;
    print("nombre ${nombre}");
    var formData = FormData.fromMap({
      'body': getBody("uploadFileRubroEvidencia", parameters),
      'file': await MultipartFile.fromFile(file.path, filename: nombre),
    });
    Dio dio = new Dio();
    dio.post(
      Uri2.validate(urlServidorLocal),
      data: formData,
      cancelToken: token,
      onSendProgress: (received, total){
        if (total != -1){
          var progress = (received / total * 100);
          print("${progress}%");
          progressListen.call(progress);
        }
      },
    ).then((Response response) async{
      if (response.statusCode == 200) {
        Map<String,dynamic> body = response.data;
        print("Response success");
        if(body.containsKey("Successful")&&body.containsKey("Value")){
          dioCancellation.finishesd = true;
          httpSuccessListen.call(true, body["Value"]);
          print("Response success ${body["Value"]}");
        }else{
          dioCancellation.finishesd = true;
          httpSuccessListen.call(false, null);
          print("Response null ${response.data}");
        }
      }
    });

    return dioCancellation;
  }

}

class DioCancellation  extends HttpStream{
  CancelToken token;
  bool? finishesd;

  DioCancellation(this.token);

  @override
  void cancel()async{
    print("token ${token.hashCode}");
    token.cancel('cancelled');
  }

  @override
  bool isFinished() {
    return finishesd??false;
  }
}

class DioCancellation2  extends HttpStream{
  Dio dio;
  bool? finishesd;
  CancelToken? token;

  DioCancellation2(this.dio){
    //dio.interceptors.add(LogInterceptor());
    // Token can be shared with different requests.
    token = CancelToken();
  }

  @override
  void cancel()async{
    print("token ${token.hashCode}");
    token?.cancel('cancelled');
  }

  @override
  bool isFinished() {
    return finishesd??false;
  }
}

class Uri2{
  static Uri parse(String url){
    if (kReleaseMode) {
      return Uri.parse(url);
    } else {
      // Will be tree-shaked on release builds.
      //url = url.replaceAll("CRMMovil", "CRMMovil2");
      //url = modificarServidorLocalCata(url);
      //print("modificarServidorLocalCata3: ${url}");
      return Uri.parse(url);
    }

   }

  static String validate(String url){
    if (kReleaseMode) {
      return url;
    } else {
      // Will be tree-shaked on release builds.
      // jessica.galvis	jessicacolombia1
      //ray.tejada tejada1234567
      //url = url.replaceAll("CRMMovil", "CRMMovil2");
      //url = modificarServidorLocalCata(url);
      //print("modificarServidorLocalCata4: ${url}");
      return url;
    }

  }

  static String modificarServidorLocalCata(String url){
    print("modificarServidorLocalCata: ${url}");
    url = url.replaceAll("https", "http");
    url = url.replaceAll("cata.icrmedu.com", "192.168.0.6");
    print("modificarServidorLocalCata2: ${url}");
    return url;
  }

}