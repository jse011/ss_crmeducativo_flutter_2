
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:lottie/lottie.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_system_ui.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';

import '../../routers.dart';
import 'login_controller.dart';

class LoginView2 extends View{
  @override
  _LoginViewState2 createState() => _LoginViewState2();

}

class _LoginViewState2 extends ViewState<LoginView2, LoginController> {
  var selectedValue = 0;
  var isLargeScreen = false;
  ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  _LoginViewState2() : super(LoginController(
      DeviceHttpDatosRepositorio(), MoorConfiguracionRepository()));

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) =>
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget get view =>
      ControlledWidgetBuilder<LoginController>(
          builder: (context, controller) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: AppSystemUi.getSystemUiOverlayStyleOscuro(),
              child: Scaffold(
                body: OrientationBuilder(builder: (context, orientation) {
                  if (MediaQuery
                      .of(context)
                      .size
                      .width > 600) {
                    isLargeScreen = true;
                  } else {
                    isLargeScreen = false;
                  }

                  return Scaffold(
                    backgroundColor: AppTheme.background,
                    body: Container(
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 110, horizontal: 30),
                            color: Colors.white,
                            width: double.infinity,
                            child: Column(
                              children: [
                                Padding(padding: EdgeInsets.only()),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "Grapple",
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontSize: 40,
                                        color: Color(0xff205072),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                    height: SizeConfig.blockSizeVertical(context) * 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "Enter your login details to ",
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontSize: 25,
                                        color: Colors.greenAccent,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                    height: SizeConfig.blockSizeVertical(context) * 0.5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "access your account ",
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontSize: 25,
                                        color: Colors.greenAccent,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                    height: SizeConfig.blockSizeVertical(context) * 10),
                                _inputField1(),
                                SizedBox(
                                    height: SizeConfig.blockSizeVertical(context) * 3),
                                _inputField2(),
                                SizedBox(
                                    height: SizeConfig.blockSizeVertical(context) * 3),
                                _loginbtn(context),
                                SizedBox(
                                    height: SizeConfig.blockSizeVertical(context) * 10),
                                _passCode()
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
          }
      );
}
  Widget _inputField1() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 25,
            offset: Offset(0, 5),
            spreadRadius: -25,
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: TextField(
        style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
            fontSize: 20,
            color: Colors.black,
            letterSpacing: 0.24,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: "Email address",
          hintStyle: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
            color: Color(0xffA6B0BD),
          ),
          fillColor: Colors.white,
          filled: true,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.check,
              color: Colors.greenAccent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(1),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(1),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _inputField2() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 25,
            offset: Offset(0, 5),
            spreadRadius: -25,
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: TextField(
        style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
            fontSize: 20,
            color: Colors.black,
            letterSpacing: 0.24,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: "Password",
          hintStyle: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
            color: Color(0xffA6B0BD),
          ),
          fillColor: Colors.white,
          filled: true,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.panorama_fisheye_outlined,
              color: Color(0xffCDE0C9).withOpacity(0.9),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(1),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(1),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        obscureText: true,
      ),
    );
  }

  Widget _loginbtn(context) {
    // ignore: deprecated_member_use
    return FlatButton(
      onPressed: () => {},
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 140),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(20.0),
      ),
      child: Text(
        "LOG IN",
        style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
            fontSize: 23,
            color: Colors.white,
            letterSpacing: 0.168,
            fontWeight: FontWeight.w500),
      ),
      color: Colors.greenAccent,
    );
  }

  Widget _passCode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "I didn\'t receive the code ",
          style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,fontSize: 20, color: Colors.greenAccent),
        ),
        InkWell(
          child: Text(
            "Resend",
            style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {},
        )
      ],
    );
  }

class SizeConfig {

  static double screenWidth(BuildContext context){
    MediaQueryData? _mediaQueryData = MediaQuery.of(context);
    return _mediaQueryData.size.width;
  }
  static double screenHeight(BuildContext context){
    MediaQueryData? _mediaQueryData = MediaQuery.of(context);
    return _mediaQueryData.size.height;
  }
  static double blockSizeHorizontal(BuildContext context){
    return screenWidth(context) / 100;
  }

  static double blockSizeVertical(BuildContext context){
    return screenHeight(context) / 100;
  }

  static double _safeAreaHorizontal(BuildContext context){
    MediaQueryData? _mediaQueryData = MediaQuery.of(context);
    return
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
  }
  static double _safeAreaVertical(BuildContext context){
    MediaQueryData? _mediaQueryData = MediaQuery.of(context);
    return
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
  }
  static double safeBlockHorizontal(BuildContext context){
    return (screenWidth(context) - _safeAreaHorizontal(context)) / 100;
  }
  static double safeBlockVertical(BuildContext context){
    return (screenHeight(context) - _safeAreaVertical(context)) / 100;
  }


}