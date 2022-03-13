import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/init.dart';
import 'package:ss_crmeducativo_2/src/app/page/home/home_view.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_system_ui.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/splash.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/splash_error.dart';
import 'package:provider/provider.dart';
import 'package:ss_crmeducativo_2/src/provider/contactos_provider.dart';
import 'package:ss_crmeducativo_2/src/provider/homeProvider.dart';
import 'package:ss_crmeducativo_2/src/provider/conexion_provaider.dart';

void main() {
  FlutterCleanArchitecture.debugModeOn();
  SystemChrome.setSystemUIOverlayStyle(AppSystemUi.getSystemUiOverlayStyleOscuro());
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future _initialization = Init.initialize();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {

          return MultiProvider(
              providers: [
                Provider(create: (_) => HomeProvider()),
                ChangeNotifierProvider(
                  create: (_) => HomeProvider(),
                ),
                Provider(create: (_) => ConexionProvider()),
                ChangeNotifierProvider(
                  create: (_) => ConexionProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => ContactoProvider(),
                ),
              ],
              child: MaterialApp(
                title: ' ',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  textTheme: AppTheme.textTheme,
                  //platform: TargetPlatform.iOS,
                ),
                /*theme: ThemeData(
        primaryColor: Colors.black,
        bottomAppBarColor: Colors.white,
        bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
        brightness: Brightness.dark,
        hintColor: Colors.white,
      ),*/
                home: HomeView(context, snapshot: snapshot),
                routes: AppRouter.routes,
                onGenerateRoute: (settings) {
                  return AppRouter.generateRoute(settings);
                },
              )
          );



        },
    );
  }


}