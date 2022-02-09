import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import 'package:ss_crmeducativo_2/libs/new_version.dart';
//import 'package:sqlite_viewer/sqlite_viewer.dart';
import 'package:ss_crmeducativo_2/src/app/page/carga_curso/portal/portal_docente_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/contactos/contactos_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/escritorio/portal/escritorio_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/eventos_agenda/portal/evento_agenda_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/home/home_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/close_sesion.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/barra_navegacion.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/bottom_navigation.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/splash.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/database/app_database.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeView extends View{
  static const TAG = "HomePage";
  BuildContext context;

  HomeView(this.context);

  @override
  _HomePageState createState(){

    return _HomePageState(context);
  }
      // inject dependencies inwards

}

class _HomePageState extends ViewState<HomeView, HomeController> with TickerProviderStateMixin{
  late Widget _screenView;
  Widget _menuScreenView = Container();
  late CloseSession closeSessionHandler;
  late Function CloseMenuView;
  Function? _closeMenu;
  Function(bool connected)? _onChangeConnected;
  bool? _connected;

  _HomePageState(BuildContext context) :
        super(HomeController(MoorConfiguracionRepository(), DeviceHttpDatosRepositorio()));

  @override
  void initState() {
    super.initState();
    newVersion();

  }

  void newVersion() {
    Future.delayed(const Duration(milliseconds: 500), () async {
      PackageInfo info = await PackageInfo.fromPlatform();
      print("packageName: ${info.packageName}");
      /*NewVersion(
        context: context,
        dismissText: "Quizás más tarde",
        updateText: "Actualizar",
        dialogTitle: "Actualización disponible",
        //iOSId: 'com.google.Vespa',
        iOSId: 'com.consultoraestrategia.padre_mentor',
        androidId: 'com.consultoraestrategia.ss_crmeducativo_2',
        dialogTextBuilder: (localVersion, storeVersion) => 'Ahora puede actualizar esta aplicación del ${localVersion} al ${storeVersion}',
      ).showAlertIfNecessary();*/


      final newVersion = NewVersion(
        iOSId: info.packageName,
        androidId: info.packageName,
      );
      // You can let the plugin handle fetching the status and showing a dialog,
      // or you can fetch the status and display your own dialog, or no dialog.
      const simpleBehavior = true;

      if (simpleBehavior) {
        basicStatusCheck(newVersion);
      } else {
        advancedStatusCheck(newVersion);
      }
    }
    );
  }

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Actualizar',
        dialogText: 'Actualización disponible',
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  double scrolloffset = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget get view => ControlledWidgetBuilder<HomeController>(
      builder: (context, controller) {

        return Container(
          //color: AppTheme.nearlyWhite,
          child: SafeArea(
              top: false,
              bottom: false,
              child: Scaffold(
                //  backgroundColor: AppTheme.nearlyWhite,
 /*               appBar: AppBar(
                title: Text('Status: ${_connectionStatus.toString()}'),
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
                  body: (){
                    if(controller.showLoggin == 0){
                      return Container(
                        color:  ChangeAppTheme.colorEspera(),
                      );
                    }else if(controller.showLoggin == 1){
                      SchedulerBinding.instance?.addPostFrameCallback((_) {
                        // fetch data
                        AppRouter.createRouteLogin(context);
                      });
                      return Container(
                        color:  ChangeAppTheme.colorEspera(),
                      );

                    }else{
                      changeIndex(controller.vistaActual, controller);
                      return OfflineBuilder(
                          connectivityBuilder: (
                              BuildContext context,
                              ConnectivityResult connectivity,
                              Widget child,
                          ){
                            bool connected = connectivity != ConnectivityResult.none;
                            if(_connected!=null && connected != _connected){
                              _onChangeConnected?.call(connected);
                              controller.changeConnected(connected);
                            }
                            _connected = connected;
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                child,
                                Positioned(
                                  height: 32.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: AnimatedOpacity(
                                    opacity: !connected ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 3000),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 350),
                                      color: connected ?  Color(0xFF00EE44) : Color(0xFFEE4400),
                                      child: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 350),
                                        child: connected
                                            ? Text('Conectado')
                                            : Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const <Widget>[
                                            Text('Sin conexión'),
                                            SizedBox(width: 8.0),
                                            SizedBox(
                                              width: 12.0,
                                              height: 12.0,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        child: Stack(
                            children:[
                              DrawerUserController(
                                photoUser: controller.usuario == null ? '' : '${controller.usuario?.personaUi?.foto??""}',
                                nameUser: controller.usuario == null ? '' : '${controller.usuario?.personaUi?.nombreCompleto??""}',
                                correo: '',
                                screenView: _screenView,
                                menuListaView: _menuScreenView,
                                drawerWidth: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.70,
                                onClickCerrarCession: () async{
                                  AppRouter.createRouteCerrarSesion(context);
                                },
                                drawerIsOpen: (bool ) { },
                                onTapImagePerfil: () {
                                  AppRouter.showEditarUsuarioView(context, controller.usuario);
                                },
                                closeMenuCallback: (closeSesion) {
                                  _closeMenu = closeSesion;
                                },
                              ),
                            ]
                        ),
                      );
                    }
                  }()
              )
          ),

        );
      }
  );

  void changeIndex(VistaIndex vistaIndex, HomeController controller) {
    print("changeIndex");
    switch (vistaIndex) {
      case VistaIndex.Principal:
        _screenView = BottomNavigationView(
            icono: controller.logoApp??"",
              builder: (context, position, animationController) {
                    switch(position){
                      case 2:
                        return EscritorioView(animationController: animationController!, menuBuilder: (menuView) {
                          setState(() {
                            _menuScreenView = menuView;
                          });
                        }, closeSessionHandler: CloseSession(context), connectedCallback: (dynamic Function(bool) onChangeConnected) {
                          _onChangeConnected = onChangeConnected;
                        },);
                      case 1:
                        return PortalDocenteView(animationController: animationController!, menuBuilder: (menuView) {
                          setState(() {
                            _menuScreenView = menuView;
                          });
                        }, closeSessionHandler: CloseSession(context), connectedCallback: (dynamic Function(bool) onChangeConnected) {
                          _onChangeConnected = onChangeConnected;
                        },);
                      case 0:
                        return EventoAgendaView(controller.usuario,animationController: animationController!,closeMenu: _closeMenu, menuBuilder: (menuView) {
                          setState(() {
                            _menuScreenView = menuView;
                          });
                        }, closeSessionHandler: CloseSession(context), connectedCallback: (dynamic Function(bool) onChangeConnected) {
                          _onChangeConnected = onChangeConnected;
                        },);
                      default:
                        return ContactosView(animationController: animationController!, menuBuilder: (menuView) {
                          setState(() {
                            _menuScreenView = menuView;
                          });
                        }, closeSessionHandler: CloseSession(context));
                    }
              },
        );
        break;
      case VistaIndex.EditarUsuario:
        _menuScreenView = Container(
          color: Colors.red,
        );
        //_screenView = EditarUsuarioView();
        break;
      case VistaIndex.Sugerencia:
        _menuScreenView = Container(
          color: Colors.red,
        );
        //_screenView = HelpScreen();
        break;
      case VistaIndex.SobreNosotros:
        _menuScreenView = Container(
          color: Colors.red,
        );
        //_screenView = InviteFriend();
        break;
    }
  }

}
typedef OnChangeConnected = void Function(bool connected);
