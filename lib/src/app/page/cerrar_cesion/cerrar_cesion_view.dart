import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/src/app/page/cerrar_cesion/cerrar_cesion_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';

import '../../routers.dart';

class CerrarSesionView extends View{
  @override
  _CerrarSesionViewState createState() => _CerrarSesionViewState();

}

class _CerrarSesionViewState extends ViewState<CerrarSesionView, CerrarSesionController>{
  _CerrarSesionViewState() : super(CerrarSesionController());

  @override
  Widget get view => ControlledWidgetBuilder<CerrarSesionController>(
      builder: (context, controller){
        return ArsProgressWidget(
          blur: 2,
          backgroundColor: Color(0x33000000),
          animationDuration: Duration(milliseconds: 500),
          loadingWidget: Card(
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
                              Text("¿Está seguro de cerrar su sesión de ${ChangeAppTheme.nameApp()}?",
                                style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5
                                ),),
                              Padding(padding: EdgeInsets.all(16),),
                            ],
                          )
                      )
                    ],
                  ),
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
                            Fluttertoast.showToast(
                              msg: "Error Cerrar Sesion",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                            );
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
          ),
        );
      }
  );

}