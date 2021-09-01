import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/login_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class Login extends UseCase<LoginResponse,LoginParams>{
  final HttpDatosRepository repository;
  final ConfiguracionRepository datosrepository;

  Login(this.repository, this.datosrepository);

  @override
  Future<Stream<LoginResponse?>> buildUseCaseStream(LoginParams? params) async{
    final controller = StreamController<LoginResponse>();
    try{
      await datosrepository.destroyBaseDatos();
    }catch(e){

    }

    try {
      Map<String, dynamic>? loginRest = null;
      if(params!=null&&params.usuario!=null&&params.usuario.isNotEmpty
          && params.password!=null&&params.password.isNotEmpty){
        loginRest = await this.repository.getUsuarioExterno(1, params.usuario, params.password, "", "");
      }else if(params!=null&&params.usuario!=null&&params.usuario.isNotEmpty
          && params.password!=null&&params.password.isNotEmpty
          && params.correo!=null&&params.correo.isNotEmpty){
        loginRest = await this.repository.getUsuarioExterno(2, params.usuario, params.password, params.correo, "");
      }else if(params!=null&&params.usuario!=null&&params.usuario.isNotEmpty
          && params.password!=null&&params.password.isNotEmpty
          && params.correo!=null&&params.correo.isNotEmpty
          && params.dni!=null&&params.dni.isNotEmpty){
        loginRest = await this.repository.getUsuarioExterno(3, params.usuario, params.password, params.correo, params.dni);
      }
      LoginUi? loginUi = null;
      bool errorServidor = loginRest==null;
      if(!errorServidor){
        try{
          loginUi = await datosrepository.saveDatosServidor(loginRest);
        }catch(e){
          errorServidor = true;
        }
      }

      controller.add(LoginResponseValidate(errorServidor, loginUi));

      Future<void> executeDatos() async{
        if(loginUi == LoginUi.SUCCESS){
          int usuarioId = await datosrepository.getSessionUsuarioId();
          String urlServidorLocal = await datosrepository.getSessionUsuarioUrlServidor();
          Map<String, dynamic>? usuarioRest = await repository.getUsuario(urlServidorLocal, usuarioId);
          bool errorServidor = usuarioRest==null;
          if(!errorServidor){
            try{
              await datosrepository.saveUsuario(usuarioRest);
            }catch(e){
              errorServidor = true;
            }
          }

          bool rolValidado = await datosrepository.validarRol(usuarioId);
          int anioAcademicoId = 0;
          if(rolValidado && !errorServidor){

            var datosInicio = await repository.getDatosInicioDocente(urlServidorLocal, usuarioId);
            if(datosInicio!=null){
              print("Aqui 1");
              UsuarioUi usuarioUi = await datosrepository.saveDatosIniciales(datosInicio);
              print("Aqui 2");
              var datosAnioAcademico = await repository.getDatosAnioAcademico(urlServidorLocal, usuarioUi.empleadoId??0, usuarioUi.anioAcademicoIdSelected??0);
              print("Aqui 3");
              anioAcademicoId = usuarioUi.anioAcademicoIdSelected??0;
              if(datosAnioAcademico!=null){
                print("Aqui 4");
                await datosrepository.saveDatosAnioAcademico(datosAnioAcademico);
                print("Aqui 4");
              }else{
                errorServidor = true;
              }
            }else{
              errorServidor = true;
            }
          }

          if(rolValidado && !errorServidor){
            try{
              await datosrepository.updateUsuarioSuccessData(usuarioId, anioAcademicoId);
            }catch(e){
              errorServidor = true;
            }
          }

          if(!rolValidado || errorServidor){ //Eliminar la bd si existe algun error
            try{
              await datosrepository.destroyBaseDatos();
            }catch(e){
            }
          }

          controller.add(LoginResponseDatos(errorServidor, rolValidado));
        }
        logger.finest('Login successful.');
        controller.close();
      }


      executeDatos().catchError((e) {
        controller.addError(e);
        //print("Got error: ${e.error}");     // Finally, callback fires.
        //throw Exception(e);              // Future completes with 42.
      }).timeout(const Duration (seconds:60),onTimeout : () {
        Exception exception = Exception("Login timeout 60 seconds");
        controller.addError(exception);
      });



    } catch (e) {
      logger.severe('Login unsuccessful: '+e.toString());
      // Trigger .onError
      controller.addError(e);

    }
    return controller.stream;

  }

}

class LoginResponse {
  bool errorServidor;

  LoginResponse(this.errorServidor);


}

class LoginResponseValidate extends LoginResponse {
  LoginUi? loginUi;
  LoginResponseValidate(errorServidor, this.loginUi) : super(errorServidor);


}

class LoginResponseDatos  extends LoginResponse{
  bool rolValidado;
  LoginResponseDatos(errorServidor, this.rolValidado): super(errorServidor);

}

class LoginParams {
  final String usuario;
  final String password;
  final String correo;
  final String dni;

  LoginParams({required this.usuario, required this.password, required this.correo, required this.dni});


}