import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/libs/flutterOffline/flutter_offline.dart';
import 'package:ss_crmeducativo_2/src/app/page/cerrar_cesion/cerrar_cesion_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';

import '../../routers.dart';

class CerrarSesionView extends View{
  @override
  _CerrarSesionViewState createState() => _CerrarSesionViewState();

}

class _CerrarSesionViewState extends ViewState<CerrarSesionView, CerrarSesionController>{
  _CerrarSesionViewState() : super(CerrarSesionController(MoorConfiguracionRepository(), MoorRubroRepository(), DeviceHttpDatosRepositorio()));
  bool? _connected;
  Function(bool connected)? _onChangeConnected;

  @override
  Widget get view => ControlledWidgetBuilder<CerrarSesionController>(
      builder: (context, controller){
        return Scaffold(
          backgroundColor: Color(0x33000000),
          body: OfflineBuilder(
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
            child: ArsProgressWidget(
              blur: 2,
              backgroundColor: Color(0x33000000),
              animationDuration: Duration(milliseconds: 500),
              loadingWidget: !controller.progress?Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // if you need this
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            child: Icon(Ionicons.
                            log_out_outline, size: 35, color: AppTheme.white,),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.redAccent4),
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("Cerrar su sesión de ${ChangeAppTheme.nameApp()}", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppTheme.fontTTNormsMedium
                                  ),),
                                  Padding(padding: EdgeInsets.all(8),),
                                  if(controller.conexion && controller.success)
                                    Text("¿Está seguro de cerrar su sesión de ${ChangeAppTheme.nameApp()}?",
                                      style: TextStyle(
                                          fontSize: 14,
                                          height: 1.5
                                      ),),
                                  if(controller.conexion && controller.success)
                                    Padding(padding: EdgeInsets.all(16),),
                                ],
                              )
                          )
                        ],
                      ),
                      (!controller.conexion)?
                        Container(
                          padding: EdgeInsets.only(
                            top: ( 0),
                            left: ( 24),
                            right: ( 24),
                            bottom: ( 16),
                          ),
                          child:  Container(
                            padding: EdgeInsets.all(( 8)),
                            decoration: BoxDecoration(
                              color: AppTheme.red.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(( 8)), // use instead of BorderRadius.all(Radius.circular(20))
                            ),
                            child: FDottedLine(
                              color: AppTheme.white,
                              strokeWidth: 2.0,
                              dottedLength: 10.0,
                              space: 2.0,
                              corner: FDottedLineCorner.all(( 7)),
                              /// add widget
                              child: Container(
                                padding: EdgeInsets.all(( 16)),
                                alignment: Alignment.center,
                                child: Text("Sin conexión, no se puede cerrar sesión porque existen evaluaciones aun sin enviar. Por favor reintente cerrar sesión cuando tenga una conexión a internet estable.",  style: TextStyle(
                                    fontSize: ( 14),
                                    fontWeight: FontWeight.w800,
                                    fontFamily: AppTheme.fontTTNorms,
                                    color: AppTheme.white
                                ),),
                              ),
                            ),
                          ),
                        ):
                      (!controller.success)?
                        Container(
                          padding: EdgeInsets.only(
                            top: ( 0),
                            left: ( 24),
                            right: ( 24),
                            bottom: ( 16),
                          ),
                          child:  Container(
                            padding: EdgeInsets.all(( 8)),
                            decoration: BoxDecoration(
                              color: AppTheme.red.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(( 8)), // use instead of BorderRadius.all(Radius.circular(20))
                            ),
                            child: FDottedLine(
                              color: AppTheme.white,
                              strokeWidth: 2.0,
                              dottedLength: 10.0,
                              space: 2.0,
                              corner: FDottedLineCorner.all(( 7)),
                              /// add widget
                              child: Container(
                                padding: EdgeInsets.all(( 16)),
                                alignment: Alignment.center,
                                child: Text("Error en nuestros servidores, existen evaluaciones aun sin enviar. Por favor comuníquese con nuestro soporte iCRM Educativo.",  style: TextStyle(
                                    fontSize: ( 14),
                                    fontWeight: FontWeight.w800,
                                    fontFamily: AppTheme.fontTTNorms,
                                    color: AppTheme.white
                                ),),
                              ),
                            ),
                          ),
                        ):Container(),
                      Row(
                        children: [
                          Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Atras', style: TextStyle(color: AppTheme.colorPrimary, fontSize: 13),),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(child: ElevatedButton(
                            onPressed: () async{
                              bool success = await controller.onClickCerrarCession();
                              if(success){
                                AppRouter.createRouteLogin(context);
                              }else{

                              }
                              //Navigator.of(context).pop(true);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: AppTheme.redAccent4,
                              onPrimary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Cerrar sesión',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              ):null,
            ),
          ),
        );
      }
  );

}