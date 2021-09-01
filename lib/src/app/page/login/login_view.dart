
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:lottie/lottie.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';

import '../../routers.dart';
import 'login_controller.dart';

class LoginView extends View{
  @override
  _LoginViewState createState() => _LoginViewState();

}

class _LoginViewState extends ViewState<LoginView, LoginController>{
  // Initially password is obscure

  _LoginViewState() : super(LoginController(DeviceHttpDatosRepositorio(), MoorConfiguracionRepository()));

  @override
  Widget get view =>  Container(
      color: AppTheme.nearlyWhite,
    child: ControlledWidgetBuilder<LoginController>(
        builder: (context, controller) {

          if(controller.dismis){
            SchedulerBinding.instance?.addPostFrameCallback((_) {
              // fetch data
              AppRouter.createRouteHomeRemoveAll(context);
            });

          }

          return controller.progressData?
          Container(
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Lottie.asset('assets/lottie/blobbyloader.json'),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 80),
                  child:  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text("Hi ", style: Theme.of(context).textTheme.caption?.copyWith(
                            fontSize: 32,
                            fontFamily: AppTheme.fontGotham,
                            color: AppTheme.black
                        ), ),
                      ),
                      Column(
                        children: [
                          Text(ChangeAppTheme.nameApp(), style: Theme.of(context).textTheme.caption?.copyWith(
                            fontSize: 32,
                            fontFamily: AppTheme.fontGotham,
                              color: AppTheme.black
                          )),
                          Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            width: 260,
                            height: 2,
                            color: AppTheme.redAccent3,
                          ),
                          Text("Perseguimos una experiencia relajada.", style: Theme.of(context).textTheme.caption?.copyWith(
                              fontSize: 10,
                              color: AppTheme.grey
                          )),
                        ],
                      )

                    ],
                  ),
                )
              ],
            ),
          ):
          Padding(
            padding: const EdgeInsets.only(top: 32, bottom: 32, right: 32, left: 32),
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),

                elevation: 10,
                child: Stack(
                  children: [
                    if(controller.typeView!=LoginTypeView.USUARIO)
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 8),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                            splashColor: AppTheme.colorPrimary.withOpacity(0.4),
                            onTap: () {
                              controller.onClikAtrasLogin();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
                              child: Icon(
                                Icons.arrow_back,
                                color: AppTheme.colorPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if(controller.progress)
                          Padding(
                            padding: const EdgeInsets.only(left: 7, right: 7, top: 0.0),
                            child:  ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(0), topRight: Radius.circular(16), bottomRight: Radius.circular(0)),
                              child: LinearProgressIndicator(),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 52, right: 32, left: 32 ),
                          child: Image.asset(
                            ChangeAppTheme.loginBanner(),
                            height: 100.0,
                          ),

                        ),
                        Padding(padding: const EdgeInsets.only(top: 8)),
                        Center(
                          child: Text("Acceder", style: TextStyle(fontSize: 14)),
                        ),
                        Padding(padding: const EdgeInsets.only(top: 8)),
                        Center(
                          child: Text("Usa tu cuenta de iCRM Educativo", style: TextStyle(fontSize: 14, color: AppTheme.lightText)),
                        ),
                        if(controller.typeView==LoginTypeView.USUARIO)
                          Padding(
                            padding: const EdgeInsets.only(top: 16, right: 24, left: 24),
                            child: TextFormField(
                              key: Key("Usuario"),
                              maxLength: 25,
                              autofocus: true,
                              autovalidateMode: AutovalidateMode.disabled,
                              validator: (val) => '' ,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.caption?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              initialValue: controller.usuario,
                              //controller: accountController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: "Usuario",
                                labelStyle: TextStyle(
                                  color:  AppTheme.colorPrimary,
                                ),
                                helperText: "",
                                contentPadding: EdgeInsets.all(15.0),
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: AppTheme.colorPrimary,
                                ),
                                errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                hintText: "Ingrese su usuario",
                                hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                focusColor: AppTheme.colorAccent,
                              ),
                              onChanged: (str) {
                                controller.onChangeUsuario(str);
                              },
                              onSaved: (str) {
                                //  To do
                              },
                            ),
                          ),
                        if(controller.typeView==LoginTypeView.USUARIO)
                          Padding(
                            padding: const EdgeInsets.only(top: 16, right: 24, left: 24),
                            child: TextFormField(
                              key: Key("Password"),
                              maxLength: 25,
                              autofocus: false,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.caption?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              initialValue: controller.password,
                              obscureText: controller.ocultarContrasenia,
                              validator: (val) => (val?.length??0) < 3 ? 'Contraseña demasiado corta' : null,
                              //controller: accountController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: "Contraseña",
                                labelStyle: TextStyle(
                                  color:  AppTheme.colorPrimary,
                                ),
                                helperText: "",
                                contentPadding: EdgeInsets.all(15.0),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: AppTheme.colorPrimary,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(controller.ocultarContrasenia
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: (){
                                    controller.onClikMostarContrasenia();
                                  },
                                ),
                                errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                hintText: "Ingrese su contraseña",
                                hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                focusColor: AppTheme.colorAccent,
                              ),
                              onChanged: (str) {
                                controller.onChangeContrasenia(str);
                              },
                              onSaved: (str) {
                                //  To do
                              },
                            ),
                          ),
                        if(controller.typeView==LoginTypeView.DNI)
                          Padding(
                            key: Key("DNI"),
                            padding: const EdgeInsets.only(top: 16, right: 24, left: 24),
                            child: TextFormField(
                              maxLength: 20,
                              autofocus: true,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.caption?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              initialValue: controller.dni,
                              validator: (val) => (val?.length??0) < 3 ? 'DNI demasiado corta' : null,
                              //controller: accountController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: "DNI",
                                labelStyle: TextStyle(
                                  color:  AppTheme.colorPrimary,
                                ),
                                helperText: "DNI o Tarjeta de extranjería",
                                contentPadding: EdgeInsets.all(15.0),
                                prefixIcon: Icon(
                                  Icons.style,
                                  color: AppTheme.colorPrimary,
                                ),
                                errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                hintText: "Ingrese su DNI",
                                hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                focusColor: AppTheme.colorAccent,
                              ),
                              onChanged: (str) {
                                controller.onChangeDni(str);
                              },
                              onSaved: (str) {
                                //  To do
                              },
                            ),
                          ),
                        if(controller.typeView==LoginTypeView.CORREO)
                          Padding(
                            padding: const EdgeInsets.only(top: 16, right: 24, left: 24),
                            child: TextFormField(
                              key: Key("Correo"),
                              maxLength: 50,
                              //autovalidate: true,
                              autofocus: true,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.caption?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              initialValue: controller.correo,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (val) {
                                controller.onValidatorCorreo(EmailValidator.validate(val??""));
                                return EmailValidator.validate(val??"") ? null : "Correo inválido";
                              },
                              //controller: accountController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: "Correo",
                                labelStyle: TextStyle(
                                  color:  AppTheme.colorPrimary,
                                ),
                                helperText: "",
                                contentPadding: EdgeInsets.all(15.0),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: AppTheme.colorPrimary,
                                ),
                                errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                hintText: "Ingrese su correo",
                                hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                  borderSide: BorderSide(
                                    color: AppTheme.colorPrimary,
                                  ),
                                ),
                                focusColor: AppTheme.colorAccent,
                              ),
                              onChanged: (str) {
                                controller.onChangeCorreo(str);
                              },
                              onSaved: (str) {
                                //  To do
                              },
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 24),
                          child: Text("Social iCRM Educativo Móvil", style: TextStyle(fontSize: 14, color: AppTheme.colorAccent)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 24),
                          child: Text("Un millón de Padres Mentores enlazados a Instituciones Educativas apoyados por el Social iCRM Educativo Móvil.", style: TextStyle(fontSize: 14, color: AppTheme.lightText)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, right: 32, left: 32 ),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: ChangeAppTheme.getApp() != App.ICRM?
                                  Image.asset(
                                    ChangeAppTheme.loginBanner(app: App.ICRM),
                                    height: 70.0,
                                  ): Container()
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Container()
                              ),
                              Expanded(
                                flex: 3,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                    splashColor: AppTheme.colorPrimary.withOpacity(0.4),
                                    onTap: () {
                                      controller.onClickInciarSesion();
                                    },
                                    child:
                                    Container(
                                        padding: const EdgeInsets.only(top: 8, left: 4, bottom: 8, right: 4),
                                        child: Row(
                                          children: [
                                            Text("Iniciar sesión", style: TextStyle(fontSize: 14, color: AppTheme.colorAccent, fontWeight: FontWeight.w500),),
                                          ],
                                        )
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                        ),
                      ],
                    ),
                  ],
                )
            ),
          );
        })
  );

}