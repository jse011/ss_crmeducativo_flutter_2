import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/io_client.dart';
import 'package:ss_crmeducativo_2/src/device/utils/http_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class DeviceHttpDatosRepositorio extends HttpDatosRepository{
  static const  TAG = "DeviceHttpDatosRepositorio";
  String getBody(String method, Object parameters){
    Map<String, dynamic> body = Map<String, dynamic>();
    body["interface"] = "RestAPI";
    body["method"] = method;
    body["parameters"] = parameters;
    String s = json.encode(body);
    print(TAG + " "+s);
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
    parameters["UsuarioId"] = usuarioId;

    final response = await http.post(Uri2.parse(urlServidor), body: getBody("fobj_ObtenerUsuario_By_Id",parameters));
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


    final response = await http.post(Uri2.parse(HttpTools.GlobalHttp), body: getBody("f_BuscarUsuarioCent",parameters));
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
  }

  @override
  Future<Map<String, dynamic>> getDatosAnioAcademico(String urlServidorLocal, int empleadoId, int anioAcademicoId) async {
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_EmpleadoId"] = empleadoId;
    parameters["vint_AnioAcademicoId"] = anioAcademicoId;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("flst_getDatosAnioAcademico",parameters))
        .timeout(Duration(seconds: 15), onTimeout: (){throw Exception('Failed to load getEventoAgenda');});
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
        .timeout(Duration(seconds: 20), onTimeout: (){throw Exception('Failed to load getEventoAgenda');});;
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
        .timeout(Duration(seconds: 15), onTimeout: (){throw Exception('Failed to load getEventoAgenda');});
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      if(body.containsKey("Successful")&&body.containsKey("Value")){
        Map<String, dynamic> salida = new  Map<String, dynamic>();
        List<dynamic> lista = body["Value"];
        salida["contactos"] = lista;
        return salida;
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
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("getCalendarioEventoDocenteFlutter",parameters))
        .timeout(Duration(seconds: 15), onTimeout: (){throw Exception('Failed to load getEventoAgenda');});
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
  Future<Map<String, dynamic>?> getUnidadSesion(String urlServidorLocal, int usuarioId, int calendarioId, int silaboEventoId, int rolId) async {

    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_UsuarioId"] = usuarioId;
    parameters["vint_CalendarioPeriodoId"] = calendarioId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_rolId"] = rolId;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("getUnidadSesionDocenteFlutter",parameters))
        .timeout(Duration(seconds: 15), onTimeout: (){throw Exception('Failed to load getUnidadSesion');});
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
        .timeout(Duration(seconds: 10), onTimeout: (){throw Exception('Failed to load getUnidadSesion');});
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
  Future<Map<String, dynamic>?> getDatosRubroFlutter(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int georeferenciaId, int usuarioId, int sesionAprendizajeDocenteId, int sesionAprendizajeAlumnoId, List<dynamic> rubrosNoEnviados) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_GeoreferenciaId"] = georeferenciaId;
    parameters["vint_UsuarioId"] = usuarioId;
    parameters["vint_SesionAprendizajeDocenteId"] = sesionAprendizajeDocenteId;
    parameters["vint_SesionAprendizajeAlumnoId"] = sesionAprendizajeAlumnoId;
    parameters["vlst_RubroEvalEnvioSimple"] = rubrosNoEnviados;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("getDatosRubroFlutter",parameters))
        .timeout(Duration(seconds: 60), onTimeout: (){throw Exception('Failed to load getDatosRubroFlutter');});

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
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("crearRubroEvaluacion", parameters))
        .timeout(Duration(seconds: 15), onTimeout: (){throw Exception('Failed to load rubro eval');});

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
  Future<bool?> updateEvaluacionRubroFlutter(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int georeferenciaId, int usuarioId, Map<String, dynamic> data) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_GeoreferenciaId"] = georeferenciaId;
    parameters["vint_UsuarioId"] = usuarioId;
    parameters["bERubroEvalEnvio"] = data;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("updateEvaluacionRubroFlutter", parameters))
        .timeout(Duration(seconds: 15), onTimeout: (){throw Exception('Failed to load rubro eval');});

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
        .timeout(Duration(seconds: 45), onTimeout: (){throw Exception('Failed to load rubro eval');});

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
        .timeout(Duration(seconds: 45), onTimeout: (){throw Exception('Failed to load rubro eval');});

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
  Future<Map<String, dynamic>?> getInfoTareaDocente(String urlServidorLocal, String? tareaId, String? rubroEvaluacionId, int? silaboEventoId, int? unidadEventoId) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vstr_TareaId"] = tareaId;
    parameters["vstr_rubroEvaluacionId"] = rubroEvaluacionId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_UnidadEventoId"] = unidadEventoId;
    final response = await http.post(Uri2.parse(urlServidorLocal), body: getBody("getInfoTareaDocente", parameters))
        .timeout(Duration(seconds: 45), onTimeout: (){throw Exception('Failed to load rubro eval');});

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
  Future<HttpStream> uploadFileArchivoDocente(String urlServidorLocal, int silaboEventoId, String nombre, File file, HttpProgressListen progressListen, HttpSuccess httpSuccessListen) async{
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
        .timeout(Duration(seconds: 20), onTimeout: (){throw Exception('Failed to load tarea eval');});

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
        .timeout(Duration(seconds: 45), onTimeout: (){throw Exception('Failed to load tarea sesion');});

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
        .timeout(Duration(seconds: 20), onTimeout: (){throw Exception('Failed to load tarea eval');});

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
        .timeout(Duration(seconds: 40), onTimeout: (){throw Exception('Failed to load tarea eval');});

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
  Future<HttpStream?> uploadFileAgendaDocente(String urlServidorLocal, String nombre, File file, HttpProgressListen progressListen, HttpSuccess httpSuccessListen) async {
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
        .timeout(Duration(seconds: 30), onTimeout: (){throw Exception('Failed to load tarea eval');});

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
        .timeout(Duration(seconds: 15), onTimeout: (){throw Exception('Failed to load tarea eval');});

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


}

class DioCancellation  extends HttpStream{
  CancelToken token;
  bool? finishesd;

  DioCancellation(this.token);

  @override
  void cancel() {
    token.cancel();
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
      url = url.replaceAll("CRMMovil", "CRMMovil2");
      return Uri.parse(url);
    }

   }

  static String validate(String url){
    if (kReleaseMode) {
      return url;
    } else {
      // Will be tree-shaked on release builds.
      url = url.replaceAll("CRMMovil", "CRMMovil2");
      return url;
    }

  }

}