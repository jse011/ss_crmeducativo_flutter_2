import 'dart:convert';

import 'package:ss_crmeducativo_2/src/device/utils/http_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:http/http.dart' as http;

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
    final response = await http.post(Uri.parse(urlServidor), body: getBody("flst_getDatosInicioSesion",parameters));
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

    final response = await http.post(Uri.parse(urlServidor), body: getBody("fobj_ObtenerUsuario_By_Id",parameters));
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
      throw Exception('Failed to load agenda 0');
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


    final response = await http.post(Uri.parse(HttpTools.GlobalHttp), body: getBody("f_BuscarUsuarioCent",parameters));
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
      throw Exception('Failed to load agenda 0');
    }
  }

  @override
  Future<Map<String, dynamic>> getDatosAnioAcademico(String urlServidorLocal, int empleadoId, int anioAcademicoId) async {
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_EmpleadoId"] = empleadoId;
    parameters["vint_AnioAcademicoId"] = anioAcademicoId;
    final response = await http.post(Uri.parse(urlServidorLocal), body: getBody("flst_getDatosAnioAcademico",parameters))
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
  Future<Map<String, dynamic>?> updateDatosParaCrearRubro(String urlServidorLocal, int anioAcademicoId, int programaEducativoId, int calendarioPeriodoId, int silaboEventoId, int empleadoId)  async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_AnioAcademicoId"] = anioAcademicoId;
    parameters["vint_ProgramaEducativoId"] = programaEducativoId;
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_EmpleadoId"] = empleadoId;
    final response = await http.post(Uri.parse(urlServidorLocal), body: getBody("getDatosParaCrearRubro",parameters))
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
    final response = await http.post(Uri.parse(urlServidorLocal), body: getBody("getContactoDocenteFlutter",parameters))
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
    final response = await http.post(Uri.parse(urlServidorLocal), body: getBody("getCalendarioEventoDocenteFlutter",parameters))
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
      throw Exception('Failed to load agenda 0');
    }

  }

  @override
  Future<Map<String, dynamic>?> getUnidadSesion(String urlServidorLocal, int usuarioId, int calendarioId, int silaboEventoId, int rolId) async {

    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_UsuarioId"] = usuarioId;
    parameters["vint_CalendarioPeriodoId"] = calendarioId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_rolId"] = rolId;
    final response = await http.post(Uri.parse(urlServidorLocal), body: getBody("getUnidadSesionDocenteFlutter",parameters))
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
      throw Exception('Failed to load agenda 0');
    }

  }

  @override
  Future<List<dynamic>?> getCalendarioPeriodoCursoFlutter(String urlServidorLocal, int anioAcademicoId, int programaEducativoId, int cargaCursoId) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_AnioAcademicoId"] = anioAcademicoId;
    parameters["vint_ProgramaEducativoId"] = programaEducativoId;
    parameters["vint_CargaCursoId"] = cargaCursoId;
    final response = await http.post(Uri.parse(urlServidorLocal), body: getBody("getCalendarioPeriodoCursoFlutter",parameters))
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
      throw Exception('Failed to load agenda 0');
    }
  }

  @override
  Future<Map<String, dynamic>?> getDatosRubroFlutter(String urlServidorLocal, int calendarioPeriodoId, int silaboEventoId, int georeferenciaId, int usuarioId, List<dynamic> rubrosNoEnviados) async{
    Map<String, dynamic> parameters = Map<String, dynamic>();
    parameters["vint_CalendarioPeriodoId"] = calendarioPeriodoId;
    parameters["vint_SilaboEventoId"] = silaboEventoId;
    parameters["vint_GeoreferenciaId"] = georeferenciaId;
    parameters["vint_UsuarioId"] = usuarioId;
    parameters["vlst_RubroEvalEnvioSimple"] = rubrosNoEnviados;
    final response = await http.post(Uri.parse(urlServidorLocal), body: getBody("getDatosRubroFlutter",parameters))
        .timeout(Duration(seconds: 60), onTimeout: (){throw Exception('Failed to load getDatosRubroFlutter');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      print(body.toString());
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
    final response = await http.post(Uri.parse(urlServidorLocal), body: getBody("crearRubroEvaluacion", parameters))
        .timeout(Duration(seconds: 15), onTimeout: (){throw Exception('Failed to load rubro eval');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      print(body.toString());
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
    final response = await http.post(Uri.parse(urlServidorLocal), body: getBody("crearRubroEvaluacion", parameters))
        .timeout(Duration(seconds: 15), onTimeout: (){throw Exception('Failed to load rubro eval');});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String,dynamic> body = json.decode(response.body);
      print(body.toString());
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


}

class _DeviceHttpStream extends HttpStream{
  var listen;

  _DeviceHttpStream(this.listen);

  @override
  void cancel() {
   listen?.cancel();
  }

}