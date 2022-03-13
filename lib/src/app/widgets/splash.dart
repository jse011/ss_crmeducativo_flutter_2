import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';

import '../utils/app_imagen.dart';

class SplashView extends StatefulWidget {

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body:  OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {

          return InkWell(
            child:  Stack(
              children: <Widget>[
                ChangeAppTheme.getApp() == AppType.EDUCAR?
                Container(
                  //color: ChangeAppTheme.colorEspera(),
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                          focal: Alignment.center,
                          radius: 0.5,
                          colors: [
                            Color(0XFFFFD754),
                            Color(0XFFEFB226),
                            //Color(0XFFFFA1C9),
                            //Color(0XFFFBE5E5)
                          ])
                  ),

                ):
                Container(
                  //color: ChangeAppTheme.colorEspera(),
                  decoration: BoxDecoration(
                      gradient: RadialGradient(
                          focal: Alignment.center,
                          radius: 0.5,
                          colors: [
                            Color(0XFFBD3072),
                            Color(0XFF89276A),
                          ])
                  ),

                ),
                Center(
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: ColumnCountProvider.aspectRatioForWidthLogin(context, 400)
                    ),
                    padding: EdgeInsets.only(
                        left: ColumnCountProvider.aspectRatioForWidthLogin(context, 64),
                        right: ColumnCountProvider.aspectRatioForWidthLogin(context, 64)
                    ),
                    child: ChangeAppTheme.getApp() == AppType.EDUCAR?Container(
                      child:  Container(
                        child: Image.asset(
                          AppImagen.splash_educar_1,
                        ),
                        padding: EdgeInsets.only(bottom: 0, top: 0),
                      ),
                    ): Container(
                      child: Image.asset(
                        AppImagen.splash_icrm_1,
                      ),
                      padding: EdgeInsets.only(bottom: 0, top: 0),
                    ),
                  ),
                ),
                ChangeAppTheme.getApp() == AppType.EDUCAR?
                Column(
                  children: [
                    Expanded(
                        flex: orientation == Orientation.portrait?40:20,
                        child: Container()
                    ),
                    Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            AppImagen.splash_icono_educar,
                          ),
                        )
                    ),
                    Expanded(
                        flex: 1,
                        child: Container()
                    ),
                  ],
                ):Container()
              ],
            ),
          );
        },

      )
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width/2, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}