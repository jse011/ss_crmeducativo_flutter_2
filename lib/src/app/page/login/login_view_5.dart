
import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:ss_crmeducativo_2/src/app/page/login/error_handler.dart';
import 'package:ss_crmeducativo_2/src/app/page/login/login_controller.dart';
import 'package:ss_crmeducativo_2/src/app/page/login/reset.dart';
import 'package:ss_crmeducativo_2/src/app/page/login/signup.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_lottie.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_system_ui.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';


class LoginView5 extends View{
  @override
  _LoginViewState5 createState() => _LoginViewState5();

}

class _LoginViewState5 extends ViewState<LoginView5, LoginController>{
  late final formKey = new GlobalKey<FormState>();
  String? email, password;


  //Color greenColor = Color(0XFF68BDFC);
  //Color greenColor = AppTheme.colorPrimaryDark;
  //Color greenColor = Color(0xFF00AF19);

  bool isLargeScreen  = false;

  _LoginViewState5() : super(LoginController(DeviceHttpDatosRepositorio(), MoorConfiguracionRepository()));

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget get view =>  ControlledWidgetBuilder<LoginController>(
      builder: (context, controller) {

        if(controller.dismis){
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            // fetch data
            AppRouter.createRouteHomeRemoveAll(context);
          });
          controller.clearDismis();
        }

        if((controller.mensaje??"").isNotEmpty){
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            // fetch data
            ErrorHandler().errorDialog(context, controller.mensaje);
            controller.clearMensaje();
          });

        }

        double size = MediaQuery.of(context).size.width;
        if (MediaQuery.of(context).size.width > 600 && ColumnCountProvider.isTablet(MediaQuery.of(context))) {
          isLargeScreen = true;
        } else {
          isLargeScreen = false;
        }

        return Scaffold(
            body: Container(

              child: Row(
                children: [
                  isLargeScreen?
                  Expanded(
                    flex: 1,
                      child: Container(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                           Center(
                             child:  Text('Contenidos organizados para\nuna enseñanza de calidad',
                                 style: TextStyle(
                                     fontFamily: AppTheme.fontTTNorms,
                                     fontSize: ColumnCountProvider.aspectRatioForWidthLogin(context, 24) ,
                                     height: ColumnCountProvider.aspectRatioForWidthLogin(context, 1.5),
                                     fontWeight: FontWeight.w500,
                                     color: AppTheme.white
                                 )
                             ),
                           ),
                            SizedBox(height: ColumnCountProvider.aspectRatioForWidthLogin(context, 20)),
                            SvgPicture.asset(
                              AppIcon.ic_login_banner_1,
                              width: ColumnCountProvider.aspectRatioForWidthLogin(context, 200),
                              height: ColumnCountProvider.aspectRatioForWidthLogin(context, 200),
                            ),
                          ],
                        ),
                      )
                  ):Container(),
                  Expanded(
                      flex: 1,
                      child:  Container(
                        color: ColumnCountProvider.isTablet(MediaQuery.of(context)) ?null:AppTheme.white,
                        child: Stack(
                          children: [
                            ListView(
                              padding: EdgeInsets.all(0),
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                Stack(
                                  children: [
                                    ColumnCountProvider.isTablet(MediaQuery.of(context))?
                                    Container():
                                    Positioned(
                                        top: 0,
                                        left: 0,
                                        child:  Container(
                                          height: MediaQuery.of(context).size.height/0.5,
                                          width: MediaQuery.of(context).size.width/0.5,
                                          child: Transform.rotate(
                                          angle: -0.9,
                                          child: Container(
                                            child: Lottie.asset(ChangeAppTheme.splahLottieLoginBanner()),
                                          ),
                                        ),
                                        )
                                    ),
                                    Container(
                                        height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,
                                        child: Form(key: formKey, child: _buildLoginForm(controller))),
                                  ],
                                )
                              ],
                            ),
                            if(controller.progress||controller.progressData)
                            ArsProgressWidget(
                              blur: 2,
                              backgroundColor: Color(0x33000000),
                              animationDuration: Duration(milliseconds: 500),
                            ),
                          ],
                        ),
                      )
                  ),
                ],
              ),
            )
        );
      }
  );



  //To check fields during submit
  checkFields() {
    final form = formKey.currentState;
    if (form?.validate()??false) {
      form?.save();
      return true;
    }
    return false;
  }

  //To Validate email
  String? validateEmail(String value) {
    /*String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value??""))
      return 'Enter Valid Email';
    else
      return null;*/
    if(value.length < 3){
      return 'Ingrese un usuario valido';
    }else{
      return  null;
    }
  }

  _buildLoginForm(LoginController controller) {
    return Container(
        child: Center(
          child: Container(
            //width: double.infinity,
            decoration: ColumnCountProvider.isTablet(MediaQuery.of(context))?BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.all( Radius.circular(ColumnCountProvider.aspectRatioForWidthLogin(context, 32))
              )
            ):null,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: ColumnCountProvider.aspectRatioForWidthLogin(context, 400)
              ),
              padding: EdgeInsets.only(
                left: ColumnCountProvider.aspectRatioForWidthLogin(context, 25),
                right: ColumnCountProvider.aspectRatioForWidthLogin(context, 25)
              ),
              child: ListView(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                        height: ColumnCountProvider.aspectRatioForWidthLogin(context, 60)
                    ),
                    Container(
                        height: ColumnCountProvider.aspectRatioForWidthLogin(context, 135),
                        width: ColumnCountProvider.aspectRatioForWidthLogin(context, 350),
                        child: Stack(
                          children: [
                            ChangeAppTheme.getApp() == AppType.EDUCAR?
                            Container(
                              child: Image.asset(
                                AppImagen.login_educar,
                              ),
                              padding: EdgeInsets.only(bottom: 26, top: 14),
                            ):
                            Container(
                              child: Image.asset(
                                AppImagen.login_icrm,
                              ),
                              padding: EdgeInsets.only(bottom: 26, top: 20),
                            ),
                            Positioned(
                                top: ColumnCountProvider.aspectRatioForWidthLogin(context, 115),
                                child: Column(
                                  children: [
                                    Text(ChangeAppTheme.getApp() == AppType.EDUCAR?'Centro de Aprendizaje Virtual':'Social iCRM Educativo Móvil',
                                        style:
                                        TextStyle(
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontSize: ColumnCountProvider.aspectRatioForWidthLogin(context, 16),
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.lightBlueDarken1
                                        )
                                    ),
                                  ],
                                )
                            ),

                          ],
                        )),
                    SizedBox(height: ColumnCountProvider.aspectRatioForWidthLogin(context, 25)),
                    if(controller.typeView==LoginTypeView.USUARIO)
                      TextFormField(
                          key: Key("Usuario"),
                          initialValue: controller.usuario,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: AppTheme.fontTTNorms
                          ),
                          decoration: InputDecoration(
                              labelText: 'USUARIO',
                              labelStyle: TextStyle(
                                  fontFamily: AppTheme.fontTTrueno,
                                  fontSize:  ColumnCountProvider.aspectRatioForWidthLogin(context, 12),
                                  color: AppTheme.grey.withOpacity(0.5)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: ChangeAppTheme.getApp() == AppType.EDUCAR?Color(0XFFEFB226):Color(0XFF68BDFC)),
                              )),
                          onChanged: (value) {
                            controller.onChangeUsuario(value);
                          },
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                          (value??"").isEmpty ? 'Ingrese un usuario' : validateEmail(value??"")

                      ),
                    if(controller.typeView==LoginTypeView.USUARIO)
                      TextFormField(
                          key: Key("Password"),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (term){
                            if(checkFields()) controller.onClickInciarSesion();
                          },
                          initialValue: controller.password,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: AppTheme.fontTTNorms
                          ),
                          decoration: InputDecoration(
                            labelText: 'CONTRASEÑA',
                            labelStyle: TextStyle(
                                fontFamily: AppTheme.fontTTrueno,
                                fontSize: ColumnCountProvider.aspectRatioForWidthLogin(context, 12),
                                color: AppTheme.grey.withOpacity(0.5)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: ChangeAppTheme.getApp() == AppType.EDUCAR?Color(0XFFEFB226):Color(0XFF68BDFC)),
                            ),
                            suffixIcon: IconButton(
                              icon: Container(
                                padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthLogin(context, 14)),
                                child: Icon(controller.ocultarContrasenia
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                  size: ColumnCountProvider.aspectRatioForWidthLogin(context, 20),
                                ),
                              ),
                              onPressed: (){
                                controller.onClikMostarContrasenia();
                              },
                            ),
                          ),
                          obscureText: controller.ocultarContrasenia,
                          onChanged: (value) {
                            controller.onChangeContrasenia(value);
                          },
                          validator: (value) => (value??"").isEmpty ? 'Ingrese una contraseña' : null
                      ),
                    if(controller.typeView==LoginTypeView.DNI)
                      TextFormField(
                          key: Key("DNI"),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (term){
                            if(checkFields()) controller.onClickInciarSesion();
                          },
                          initialValue: controller.dni,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: AppTheme.fontTTNorms
                          ),
                          decoration: InputDecoration(
                              labelText: 'Documento de identidad'.toUpperCase(),
                              labelStyle: TextStyle(
                                  fontFamily: AppTheme.fontTTrueno,
                                  fontSize:  ColumnCountProvider.aspectRatioForWidthLogin(context, 12),
                                  color: AppTheme.grey.withOpacity(0.5)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: ChangeAppTheme.getApp() == AppType.EDUCAR?Color(0XFFEFB226):Color(0XFF68BDFC)),
                              )),
                          onChanged: (value) {
                            controller.onChangeDni(value);
                          },
                          validator: (value) => (value??"").isEmpty ? 'Ingrese un documento de identidad' : null
                      ),
                    if(controller.typeView==LoginTypeView.CORREO)
                      TextFormField(
                          key: Key("Correo"),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (term){
                            if(checkFields()) controller.onClickInciarSesion();
                          },
                          initialValue: controller.dni,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: AppTheme.fontTTNorms
                          ),
                          decoration: InputDecoration(
                              labelText: 'Correo'.toUpperCase(),
                              labelStyle: TextStyle(
                                  fontFamily: AppTheme.fontTTrueno,
                                  fontSize:  ColumnCountProvider.aspectRatioForWidthLogin(context, 12),
                                  color: AppTheme.grey.withOpacity(0.5)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: ChangeAppTheme.getApp() == AppType.EDUCAR?Color(0XFFEFB226):Color(0XFF68BDFC)),
                              )),
                          onChanged: (value) {
                            controller.onChangeCorreo(value);
                          },
                          validator: (value) => (value??"").isEmpty ? 'Ingrese un correo' : null
                      ),
                    SizedBox(height: ColumnCountProvider.aspectRatioForWidthLogin(context, 5)),
                    controller.typeView==LoginTypeView.USUARIO?
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ResetPassword()));
                        },
                        child: Container(
                            alignment: Alignment(1.0, 0.0),
                            padding: EdgeInsets.only(
                                top: ColumnCountProvider.aspectRatioForWidthLogin(context, 15),
                                left: ColumnCountProvider.aspectRatioForWidthLogin(context, 20)
                            ),
                            child: InkWell(
                                child: Text('Has olvidado tu contraseña',
                                    style: TextStyle(
                                        color: AppTheme.colorPrimary,
                                        fontFamily: AppTheme.fontTTrueno,
                                        fontSize: ColumnCountProvider.aspectRatioForWidthLogin(context, 11),
                                        decoration: TextDecoration.underline
                                    )
                                )
                            )
                        )
                    ):
                    GestureDetector(
                        onTap: () {
                          controller.onClikAtrasLogin();
                        },
                        child: Container(
                            alignment: Alignment(1.0, 0.0),
                            padding: EdgeInsets.only(
                                top: ColumnCountProvider.aspectRatioForWidthLogin(context, 15),
                                left: ColumnCountProvider.aspectRatioForWidthLogin(context, 20)
                            ),
                            child: InkWell(
                                child: Text(controller.typeView==LoginTypeView.DNI?'Corregir usuario y contraseña':'Corregir el documento de identidad',
                                    style: TextStyle(
                                        color: ChangeAppTheme.getApp() == AppType.EDUCAR?Color(0XFFEFB226):Color(0XFF68BDFC),
                                        fontFamily: AppTheme.fontTTrueno,
                                        fontSize: ColumnCountProvider.aspectRatioForWidthLogin(context, 11),
                                        decoration: TextDecoration.underline
                                    )
                                )
                            )
                        )
                    ),
                    SizedBox(height: ColumnCountProvider.aspectRatioForWidthLogin(context, 50)),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();

                        if(checkFields()) controller.onClickInciarSesion();
                      },
                      child: Container(
                          height: ColumnCountProvider.aspectRatioForWidthLogin(context, 50),
                          child: Material(
                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthLogin(context, 25)),
                              shadowColor: ChangeAppTheme.getApp() == AppType.EDUCAR?Color(0XFFEFB226):Color(0XFF68BDFC),
                              color: ChangeAppTheme.getApp() == AppType.EDUCAR?Color(0XFFEFB226):Color(0XFF68BDFC),
                              elevation: 7.0,
                              child: Center(
                                  child: Text('INICIAR SESIÓN',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: AppTheme.fontTTrueno,
                                          fontSize: ColumnCountProvider.aspectRatioForWidthLogin(context, 14)
                                      )
                                  )
                              )
                          )
                      ),
                    ),
                    SizedBox(height: ColumnCountProvider.aspectRatioForWidthLogin(context, 20)),
                    /*GestureDetector(
            onTap: () {
              //AuthService().fbSignIn();
            },
            child: Container(
                height: 50.0,
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1.0),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(25.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: ImageIcon(AssetImage('assets/images/facebook.png'),//../Images/Inicio/logoiCRM.png
                              size: 15.0)),
                      SizedBox(width: 10.0),
                      Center(
                          child: Text('Login with facebook',
                              style: TextStyle(fontFamily: AppTheme.fontTTrueno))),
                    ],
                  ),
                )),
          ),
          SizedBox(height: 25.0),*/
                    /*
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Nuevo en iCRM ?'),
                      SizedBox(width: ColumnCountProvider.aspectRatioForWidthLogin(context, 5)),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => SignupPage()));
                          },
                          child: Text('Registrarse',
                              style: TextStyle(
                                  color: greenColor,
                                  fontFamily: AppTheme.fontTTrueno,
                                  decoration: TextDecoration.underline)))
                    ]),*/
                    SizedBox(height: ColumnCountProvider.aspectRatioForWidthLogin(context, 30)),
                    Row(
                      children: [
                        _educarLogo(ColumnCountProvider.aspectRatioForWidthLogin(context, 45), ColumnCountProvider.aspectRatioForWidthLogin(context, 135)),
                        Expanded(child: Container()),
                      ],
                    ),
                    SizedBox(height: ColumnCountProvider.aspectRatioForWidthLogin(context, 50)),
                  ]
              ),
            ),
          ),
        )
    );
  }

  Widget _educarLogo(double? height, double? width){
    return Image.asset(AppImagen.logo_ICRM,
      fit: BoxFit.cover,
      colorBlendMode: BlendMode.modulate,
      height: height,
      width: width,
    );
  }

}

class BezierClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(
        size.width - size.width / 4, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}