
import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:lottie/lottie.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_system_ui.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';

import '../../routers.dart';
import 'login_controller.dart';

class LoginView3 extends View{
  @override
  _LoginViewState3 createState() => _LoginViewState3();

}

class _LoginViewState3 extends ViewState<LoginView3, LoginController>{
  var selectedValue = 0;
  var isLargeScreen = false;
  ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  String? _password;
  String? _email;

  _LoginViewState3() : super(LoginController(DeviceHttpDatosRepositorio(), MoorConfiguracionRepository()));

  @override
  void initState() {
    super.initState();

  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget get view =>  ControlledWidgetBuilder<LoginController>(
      builder: (context, controller) {


        return  AnnotatedRegion<SystemUiOverlayStyle>(
            value: AppSystemUi.getSystemUiOverlayStyleOscuro(),
            child: Scaffold(
              body: OrientationBuilder(builder: (context, orientation) {
                if (MediaQuery.of(context).size.width > 600) {
                  isLargeScreen = true;
                } else {
                  isLargeScreen = false;
                }

                double size = MediaQuery.of(context).size.height * (isLargeScreen?1:0.65);
                //
                //X = (Zise * 0.4) - (Zise - with)
                double width = MediaQuery.of(context).size.width;
                double height = MediaQuery.of(context).size.height;

                double x = 0;
                if(isLargeScreen){
                  x = 0;
                }else{
                  x = (size * 0.35) - (size - width);
                }

                print("resultado x ${x}");
                x = x<0?0:x;
                double y =  height-size;
                y = y<0?0:y/3;
                print("resultado y ${y}");


                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          HexColor("#072a5c"),
                          HexColor("#3d94c5"),
                        ],
                        //stops: [0.1, 0.5],
                      )
                  ),
                  child: Row(
                    children: [
                      isLargeScreen?
                      Expanded(child: Container()):Container(),
                      Expanded(
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                physics:  NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                reverse: true,
                                controller: _scrollController,
                                child: Column(
                                  children: [
                                    Expanded(child: Container()),
                                    Container(
                                      margin: EdgeInsets.only(bottom: y, right: x),
                                      height: size,
                                      width: size,
                                      //color: Colors.orangeAccent,
                                      child: Transform.rotate(
                                        angle: isLargeScreen?0.78:0,
                                        child: ClipPath(
                                          clipper: Squared2Clipper(),
                                          child: Container(
                                            color : AppTheme.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                               Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: size,
                                      child:  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Container()
                                          ),
                                          Expanded(
                                              flex: 7,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: size/2,
                                                    padding: EdgeInsets.only(left: 32),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(padding: EdgeInsets.only(top: 50)),
                                                        Text("Welcome to",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w700,
                                                              fontFamily: AppTheme.fontTTNorms
                                                          ),
                                                        ),
                                                        Text("Helth Care",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.w900,
                                                              fontFamily: AppTheme.fontTTNorms
                                                          ),
                                                        ),/*
                                                        CachedNetworkImage(
                                                          imageUrl: "http://educar.icrmedu.com/Images/Inicio/logo_Inicio.png",
                                                          imageBuilder: (context, imageProvider) => Container(
                                                            height: size/8,
                                                            width: size/4,
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: imageProvider,
                                                                  fit: BoxFit.contain),
                                                            ),
                                                          ),
                                                          placeholder: (context, url) => CircularProgressIndicator(),
                                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                                        ),*/
                                                        Padding(padding: EdgeInsets.all(4)),
                                                        Text("Please sign in to continue",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: AppTheme.fontTTNorms
                                                          ),
                                                        ),
                                                        showEmailInput(),
                                                        showPasswordInput()
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(padding: EdgeInsets.all(12)),
                                                  Container(
                                                    width: size/1.6,
                                                    child:  Row(
                                                      children: [
                                                        Expanded(child: Container()),
                                                        Container(
                                                          width: size/3,
                                                          child: ElevatedButton(
                                                            onPressed: () {},
                                                            style: ElevatedButton.styleFrom(
                                                              primary: AppTheme.colorPrimary,
                                                              //fixedSize: Size(80, 60),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(25),
                                                              ),
                                                              elevation: 4.0,
                                                            ),
                                                            child: Padding(
                                                              padding:  EdgeInsets.all(15.0),
                                                              child: Text(
                                                                'Login'.toUpperCase(),
                                                                style: TextStyle(fontSize: 16),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(padding: EdgeInsets.all(14)),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 32),
                                                    child: Text("Forgot Password?",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w900,
                                                          fontFamily: AppTheme.fontTTNorms
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                          ),

                                        ],
                                      ),
                                    )
                                  ],
                               ),
                               Positioned(
                                  right: 24,
                                   top: 24,
                                   child: CachedNetworkImage(
                                     imageUrl: "http://educar.icrmedu.com/Images/Inicio/logo_Inicio.png",
                                     imageBuilder: (context, imageProvider) => Container(
                                       height: size/4,
                                       width: size/4,
                                       decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: imageProvider,
                                             fit: BoxFit.contain),
                                       ),
                                     ),
                                     placeholder: (context, url) => CircularProgressIndicator(),
                                     errorWidget: (context, url, error) => Icon(Icons.error),
                                   ),
                               ),
                               Positioned(
                                right: 24,
                                bottom: 24,
                                child: CachedNetworkImage(
                                  imageUrl: "http://www.icrmedu.com/wp-content/uploads/elementor/thumbs/icrm-ic-ou3uzqk8ghfj2x767lszicutttfut3qvqxh0ga1bus.png",
                                  imageBuilder: (context, imageProvider) => Container(
                                    height: size/5,
                                    width: size/5,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              )
                            ],
                          )
                      )
                    ],
                  ),
                );
              }),
            ),
        );

      }
  );

  Widget showEmailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 8, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: TextStyle(
            fontSize: 14,
            color: AppTheme.darkerText,
            fontWeight: FontWeight.w700,
            fontFamily: AppTheme.fontTTNorms
        ),
        decoration: new InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: AppTheme.fontTTNorms
            ),
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
              size: 18,
            )),
        validator: (value) => (value??"").isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = (value??"").trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        style: TextStyle(
            fontSize: 14,
            color: AppTheme.darkerText,
            fontWeight: FontWeight.w700,
            fontFamily: AppTheme.fontTTNorms
        ),
        decoration: new InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: AppTheme.fontTTNorms
            ),
            labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: AppTheme.fontTTNorms
            ),
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
              size: 18,
            )),
        validator: (value) => (value??"").isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = (value??"").trim(),
      ),
    );
  }

}


class BezierClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height*0.85); //vertical line
    path.cubicTo(size.width/3, size.height, 2*size.width/3, size.height*0.7, size.width, size.height*0.85); //cubic curve
    path.lineTo(size.width, 0); //vertical line
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}

class Squared2Clipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 14142;
    final double _yScaling = size.height / 14142;
    path.cubicTo(0 * _xScaling,0 * _yScaling,0 * _xScaling,0 * _yScaling,0 * _xScaling,0 * _yScaling,);
    path.lineTo(5275 * _xScaling,1167 * _yScaling);
    path.cubicTo(5275 * _xScaling,1167 * _yScaling,6099 * _xScaling,359 * _yScaling,6099 * _xScaling,359 * _yScaling,);
    path.cubicTo(6651 * _xScaling,-93 * _yScaling,7432 * _xScaling,-145 * _yScaling,8067 * _xScaling,357 * _yScaling,);
    path.cubicTo(8067 * _xScaling,357 * _yScaling,13525 * _xScaling,5874 * _yScaling,13525 * _xScaling,5874 * _yScaling,);
    path.cubicTo(14357 * _xScaling,6616 * _yScaling,14372 * _xScaling,7675 * _yScaling,13420 * _xScaling,8463 * _yScaling,);
    path.cubicTo(13420 * _xScaling,8463 * _yScaling,8815 * _xScaling,13016 * _yScaling,8815 * _xScaling,13016 * _yScaling,);
    path.cubicTo(8815 * _xScaling,13016 * _yScaling,8143 * _xScaling,13680 * _yScaling,8143 * _xScaling,13680 * _yScaling,);
    path.cubicTo(7526 * _xScaling,14290 * _yScaling,6537 * _xScaling,14335 * _yScaling,5854 * _xScaling,13578 * _yScaling,);
    path.cubicTo(5854 * _xScaling,13578 * _yScaling,5278 * _xScaling,12996 * _yScaling,5278 * _xScaling,12996 * _yScaling,);
    path.cubicTo(5278 * _xScaling,12996 * _yScaling,434 * _xScaling,8096 * _yScaling,434 * _xScaling,8096 * _yScaling,);
    path.cubicTo(-117 * _xScaling,7542 * _yScaling,-196 * _xScaling,6568 * _yScaling,503 * _xScaling,5884 * _yScaling,);
    path.cubicTo(503 * _xScaling,5884 * _yScaling,5275 * _xScaling,1167 * _yScaling,5275 * _xScaling,1167 * _yScaling,);
    path.cubicTo(5275 * _xScaling,1167 * _yScaling,5275 * _xScaling,1167 * _yScaling,5275 * _xScaling,1167 * _yScaling,);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}