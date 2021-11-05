import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';

class SplashErrorView extends StatefulWidget {

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashErrorView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new InkWell(
        child: new Stack(
          children: <Widget>[
            Container(
              color: ChangeAppTheme.colorEspera(),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 4,
                      child: Container(
                        child: Text("Error registering services", style: TextStyle(color: AppTheme.white, fontSize: 16),),
                      ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(

                            ),
                            onPressed: () {
                              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                            },
                            child: const Text('Salir de la aplicación'),
                          )
                        ],
                      )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
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