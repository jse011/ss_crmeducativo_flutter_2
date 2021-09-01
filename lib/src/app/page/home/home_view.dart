import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
//import 'package:sqlite_viewer/sqlite_viewer.dart';
import 'package:ss_crmeducativo_2/libs/new_version.dart';
import 'package:ss_crmeducativo_2/src/app/page/eventos_agenda/evento_agenda_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/portal_docente/portal_docente_view.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/barra_navegacion.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/bottom_navigation.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/splash.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/database/app_database.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import '../../routers.dart';
import 'home_controller.dart';


class HomeView extends View{
  static const TAG = "HomePage";
  @override
  _HomePageState createState() =>
      // inject dependencies inwards
      _HomePageState();

}

class _HomePageState extends ViewState<HomeView, HomeController> with TickerProviderStateMixin{
  late Widget _screenView;
  _HomePageState() :
        super(HomeController(MoorConfiguracionRepository(), DeviceHttpDatosRepositorio()));

  @override
  void initState() {
    super.initState();
  }
  double scrolloffset = 0.0;

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
    /*Future.delayed(const Duration(milliseconds: 500), () {
      NewVersion(
        context: context,
        dismissText: "Quizás más tarde",
        updateText: "Actualizar",
        dialogTitle: "Actualización disponible",
        //iOSId: 'com.google.Vespa',
        iOSId: 'com.consultoraestrategia.padre_mentor',
        androidId: 'com.consultoraestrategia.ss_crmeducativo_2',
        dialogTextBuilder: (localVersion, storeVersion) => 'Ahora puede actualizar esta aplicación del ${localVersion} al ${storeVersion}',
      ).showAlertIfNecessary();
    }
    );*/
  }


  @override
  Widget get view =>
      Container(
        //color: AppTheme.nearlyWhite,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
          //  backgroundColor: AppTheme.nearlyWhite,
          /* appBar: AppBar(
                title: Text('DBDEBUG'),
                actions: <Widget>[
                  new IconButton(
                      icon: new Icon(Icons.folder),
                      onPressed: () {
                        final db =  AppDataBase(); //This should be a singleton
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoorDbViewer(db)));
                        //Navigator.push(context, MaterialPageRoute(builder: (_) => DatabaseList()));
                      }
                  ),
                ]
            ),*/
            body: ControlledWidgetBuilder<HomeController>(
                builder: (context, controller) {
                  if(controller.showLoggin == 0){
                    return Container(
                      color:  ChangeAppTheme.colorEspera(),
                    );
                  }else if(controller.showLoggin == 1){
                    SchedulerBinding.instance?.addPostFrameCallback((_) {
                      // fetch data
                      AppRouter.createRouteLogin(context);
                    });
                    return Container();
                  }else{
                    changeIndex(controller.vistaActual);
                    return Stack(
                        children:[
                          DrawerUserController(
                            photoUser: controller.usuario == null ? '' : '${controller.usuario?.foto??""}',
                            nameUser: controller.usuario == null ? '' : '${controller.usuario?.nombreSimple??""}',
                            correo: controller.usuario == null ? '' : controller.usuario?.correo??"",
                            screenView: _screenView,
                            drawerWidth: MediaQuery
                                .of(context)
                                .size
                                .width * 0.70,
                            onClickCerrarCession: (){
                              controller.onClickCerrarCession();
                            },
                            menuListaView: Container(

                            ),
                            drawerIsOpen: (bool ) { },
                          ),
                          if(controller.splash)SplashView(),
                        ]
                    );
                  }
                }
            )
          )
        ),

      );

  void changeIndex(VistaIndex vistaIndex) {
    switch (vistaIndex) {
      case VistaIndex.Principal:
        _screenView = BottomNavigationView(
            icono: "http://cata.icrmedu.com/Academico/Images/Entidades/ic_logo_cata.png",
              builder: (context, position, animationController) {
                    switch(position){
                      case 1:
                        return PortalDocenteView(animationController: animationController!,);
                      case 0:
                        return EventoAgendaView(animationController: animationController!,);
                      default:
                        return Container(
                          color: Colors.red,
                          child: Text(position.toString(), style: TextStyle(color: Colors.black),),
                        );
                    }

              },
        );
        break;
      case VistaIndex.EditarUsuario:
        //_screenView = EditarUsuarioView();
        break;
      case VistaIndex.Sugerencia:
        //_screenView = HelpScreen();
        break;
      case VistaIndex.SobreNosotros:
        //_screenView = InviteFriend();
        break;
    }
  }
}
