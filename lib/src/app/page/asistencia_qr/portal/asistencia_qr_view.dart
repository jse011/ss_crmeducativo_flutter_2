import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:ss_crmeducativo_2/src/app/page/asistencia_qr/portal/asistencia_qr_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_sound.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_system_ui.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_utils.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/error_handler.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/progress_bar.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_asistencia_qr_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_qr_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';

import '../../../../../libs/fdottedline/fdottedline.dart';
import '../../../utils/app_lottie.dart';

class AsistenciaQRView extends View{
  AsistenciaQRView();

  @override
  _AsistenciaQRViewState createState() => _AsistenciaQRViewState();

}


class _AsistenciaQRViewState extends ViewState<AsistenciaQRView, AsistenciaQRController> with TickerProviderStateMixin{
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  final player = AudioCache();
  Color colorPrincipal = Color(0XFFBAD3F5);
  _AsistenciaQRViewState() : super(AsistenciaQRController(DeviceHttpDatosRepositorio(), MoorConfiguracionRepository(), MoorAsistenciaQRRepository()));

  Barcode? result;
  QRViewController? controllerQR;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  late SheetController _sheetController = SheetController();
  late bool isExpandedSlidingSheet = false;
  late bool isCollapsedSlidingSheet = true;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });

    super.initState();
  }
  @override
  Widget get view => ControlledWidgetBuilder<AsistenciaQRController>(
    builder: (context, controller) {

      if(controller.salirApp){
        if (mounted) {
          WidgetsBinding.instance?.addPostFrameCallback((_){
            Navigator.of(context).pop();
            controller.clearSalirApp();
          });
        }
      }

      if(controller.dialogUi!=null){
        SchedulerBinding.instance?.addPostFrameCallback((_) {
          // fetch data

          ErrorHandler().errorDialog(context,ErrorData(
              message: controller.dialogUi?.mensaje,
              title: controller.dialogUi?.titulo,
              icon: Ionicons.cloud_offline,
            callback: (){
              controller.closeDialogo();
            }
          ));
          controller.clearDialog();
        });

      }

      return WillPopScope(
        onWillPop: () async {
          if(_sheetController.state?.isExpanded??false){
            _sheetController.collapse();
            FocusScope.of(context).unfocus();
            return false;
          } else{
            return controller.salirAplicacion();
          }
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: AppSystemUi.getSystemUiOverlayStyleClaro(),
            child: Stack(
              key: globalKey,
              children: [
                Scaffold(
                  extendBody: true,
                  backgroundColor: AppTheme.white,
                  body: SlidingSheet(
                    cornerRadius: /*isExpandedSlidingSheet?0:*/16,
                    border: Border.all(color: colorPrincipal),
                    listener: (state) {
                      if(state.isCollapsed != isCollapsedSlidingSheet){
                        setState(() {
                          isCollapsedSlidingSheet = state.isCollapsed;
                        });
                        FocusScope.of(context).unfocus();
                        print("camara: resumeCamera");
                      }

                    },
                    controller: _sheetController,
                    snapSpec: SnapSpec(
                      // Enable snapping. This is true by default.
                        snap: true,
                        // Set custom snapping points.
                        snappings: [0.3, 0.85],
                        // Define to what the snappings relate to. In this case,
                        // the total available space that the sheet can expand to.
                        //positioning: SnapPositioning.relativeToAvailableSpace,
                        initialSnap: 0.3
                    ),
                    // The body widget will be displayed under the SlidingSheet
                    // and a parallax effect can be applied to it.
                    body: Stack(
                      children: [
                        getMainTab(),
                        getAppBarUI(),
                      ],
                    ),
                    minHeight: MediaQuery.of(context).size.height/2,
                    builder: (context, state){
                      // This is the content of the sheet that will get
                      // scrolled, if the content is bigger than the available
                      // height of the sheet.
                      return SheetListenerBuilder(
                        // buildWhen can be used to only rebuild the widget when needed.
                        //buildWhen: (oldState, newState) => oldState.isExpanded != newState.isExpanded || oldState.isCollapsed != newState.isCollapsed,
                        builder: (context, state) {
                          return ControlledWidgetBuilder<AsistenciaQRController>(
                              builder: (context, controller) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if(!state.isCollapsed)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        (controller.asistenciaQRList.isNotEmpty)?
                                        Flexible(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.only(
                                                  left: 32,
                                                  right: 32,
                                                  bottom: 100
                                              ),
                                              itemBuilder: (context, index) {
                                                AsistenciaQRUi asistenciaQRUi =  controller.asistenciaQRList[index];
                                                return Row(
                                                  children: [
                                                    Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets.all(8),
                                                          decoration: BoxDecoration(
                                                              color: AppTheme.greyLighten3,
                                                              borderRadius: BorderRadius.all(Radius.circular(16))
                                                          ),
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                padding: EdgeInsets.all(16),
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets.all(4),
                                                                      child:  Text("${ controller.asistenciaQRList.length - index}.",
                                                                        style: TextStyle(
                                                                            fontFamily: AppTheme.fontTTNorms,
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: 12
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(padding: EdgeInsets.all(4)),
                                                                    Container(
                                                                      padding: EdgeInsets.all(8),
                                                                      decoration: BoxDecoration(
                                                                          color: AppTheme.white,
                                                                          borderRadius: BorderRadius.all(Radius.circular(8))
                                                                      ),
                                                                      child:  Image.asset(AppImagen.qr_image,
                                                                        height: 28.0,
                                                                        width: 28.0,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ),
                                                                    Padding(padding: EdgeInsets.all(8)),
                                                                    Expanded(child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text("${asistenciaQRUi.alumno??""}",
                                                                          style: TextStyle(
                                                                              fontFamily: AppTheme.fontTTNorms,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 12
                                                                          ),
                                                                        ),
                                                                        Text("Hoy ${DomainTools.changeTime12Hour(asistenciaQRUi.hora??0, asistenciaQRUi.minuto??0)}",
                                                                          style: TextStyle(
                                                                              fontFamily: AppTheme.fontTTNorms,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 12,
                                                                              color: AppTheme.greyDarken1
                                                                          ),
                                                                        ),
                                                                        if(asistenciaQRUi.repetido??false)
                                                                        Text("Ya registrado el día de hoy",
                                                                          style: TextStyle(
                                                                              fontFamily: AppTheme.fontTTNorms,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 12,
                                                                              color: AppTheme.red
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                    ),
                                                    if(asistenciaQRUi.guardado!=true)
                                                    Padding(padding: EdgeInsets.all(4)),
                                                    if(asistenciaQRUi.guardado!=true)
                                                    Container(
                                                      width: 65,
                                                      child: !(asistenciaQRUi.progreso??false)?
                                                      InkWell(
                                                        onTap: (){
                                                          controller.reintentar(asistenciaQRUi);
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Center(
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: AppTheme.red,
                                                                    borderRadius: BorderRadius.all(Radius.circular(16))
                                                                ),
                                                                margin: EdgeInsets.only(right: 16),
                                                                padding: EdgeInsets.all(8),
                                                                child: Icon(Icons.refresh, color: AppTheme.white,),
                                                              ),
                                                            ),
                                                            Padding(padding: EdgeInsets.all(4)),
                                                            Text("Reintentar",
                                                              style: TextStyle(
                                                                  color: AppTheme.red,
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  fontSize: 11,
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ):
                                                      Container(
                                                        child: Column(
                                                          children: [
                                                            Padding(padding: EdgeInsets.all(4)),
                                                            Center(
                                                              child: CircularProgressIndicator(
                                                                color: colorPrincipal,
                                                                strokeWidth: 2,
                                                              ),
                                                            ),
                                                            Padding(padding: EdgeInsets.all(4)),
                                                            Text("Enviando",
                                                              style: TextStyle(
                                                                  color: colorPrincipal,
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  fontSize: 11,
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                              itemCount:controller.asistenciaQRList.length,
                                            ),

                                          ),
                                        ):
                                        Container(
                                          padding: EdgeInsets.only(top: 16),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
                                              ),
                                              Padding(padding: EdgeInsets.all(4)),
                                              Center(
                                                child: Text("No se escaneo ningún código QR de asistencia\nel día de hoy con este dispositivo",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: AppTheme.grey,
                                                      fontStyle: FontStyle.italic,
                                                      fontSize: 12,
                                                    fontFamily: AppTheme.fontTTNorms
                                                  ),),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              });
                        },
                      );
                    },
                    headerBuilder: (context, state) {
                      return AnnotatedRegion<SystemUiOverlayStyle>(
                        value: AppSystemUi.getSystemUiOverlayStyleOscuro(),
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: (){
                                  if(state.isCollapsed){
                                    _sheetController.expand();
                                  }else{
                                    _sheetController.collapse();
                                  }
                                },
                                child:  Stack(
                                  children: [
                                    Center(
                                      child: Icon(state.isCollapsed ? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down, size: 32, color: colorPrincipal,),
                                    )
                                  ],
                                ),
                              ),
                              isCollapsedSlidingSheet?
                              Container(
                                padding: EdgeInsets.only(top: 0,left: 24, right: 24),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 0,),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(AppIcon.ic_curso_asistencia, height: 25 +  6 - 10 * topBarOpacity, width: 25 +  6 - 10 * topBarOpacity,),
                                          Padding(
                                            padding: EdgeInsets.only(left: 12, top: 8),
                                            child: Text(
                                              'Asistencia QR',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12 + 6 - 6 * topBarOpacity,
                                                letterSpacing: 0.8,
                                                color: AppTheme.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(4)),
                                    Row(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          child: Lottie.asset(AppLottie.qr_animation),
                                        ),
                                        Padding(padding: EdgeInsets.all(4)),
                                        Expanded(
                                            child:  Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text("Última asistencia de hoy",
                                                    style: TextStyle(
                                                        fontFamily: AppTheme.fontTTNorms,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w700
                                                    ),
                                                  ),
                                                ),
                                                Padding(padding: EdgeInsets.all(2)),
                                                controller.asistenciahoy!=null?
                                                Container(
                                                  child: Row(
                                                    children: [
                                                     Expanded(
                                                         child:  Text("${DomainTools.capitalize(controller.asistenciahoy?.alumno??"desconocido")}",
                                                             maxLines: 1,
                                                             overflow: TextOverflow.ellipsis,
                                                             style: TextStyle(
                                                                 fontFamily: AppTheme.fontTTNorms,
                                                                 fontSize: 14
                                                             )
                                                         ),
                                                     ),
                                                      Text(" ${DomainTools.changeTime12Hour(controller.asistenciahoy?.hora??0, controller.asistenciahoy?.minuto??0)}",
                                                          style: TextStyle(
                                                              fontFamily: AppTheme.fontTTNorms,
                                                              fontSize: 14
                                                          )
                                                      ),
                                                    ],
                                                  )
                                                ): Container(
                                                  child: Text("Escaneando...",
                                                    style: TextStyle(
                                                        fontFamily: AppTheme.fontTTNorms,
                                                        fontSize: 14
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.all(8)),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if(!state.isExpanded){
                                                _sheetController.expand();
                                              }else{
                                                _sheetController.collapse();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: colorPrincipal,
                                              onPrimary: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            child: Text('Historial de asistencia',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ):Container(
                                child: Container(
                                  padding: EdgeInsets.only(top: 0,left: 24, right: 24),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: Container()),
                                          InkWell(
                                            onTap: () async{
                                              AppRouter.showBuscarAsistenciaQR(context);
                                            },
                                            child: Container(
                                              width: 120,
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(6)),
                                                  color: colorPrincipal
                                              ),
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Ionicons.earth ,
                                                      color: AppTheme.white,
                                                      size: 15
                                                  ),
                                                  Padding(padding: EdgeInsets.all(2),),
                                                  FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text("Buscar",
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: AppTheme.fontTTNorms,
                                                          color: AppTheme.white,
                                                          fontSize: 11 ,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(padding: EdgeInsets.all(16)),
                                      Text('Historial de asistencia',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontWeight: FontWeight.w800
                                        ),
                                      ),
                                      if(controller.existeAsistenciaNoEnviadas)
                                      Padding(padding: EdgeInsets.all(8)),
                                      if(controller.existeAsistenciaNoEnviadas)
                                      Text('Existen asistencia que no se guardaron.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: AppTheme.fontTTNorms,
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(4)),
                                      if(controller.existeAsistenciaNoEnviadas)
                                      InkWell(
                                        onTap: () async{
                                            controller.guardarAhora();
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 32 , right: 32),
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                              color: AppTheme.green
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Ionicons.cloud ,
                                                  color: AppTheme.white,
                                                  size: 15
                                              ),
                                              Padding(padding: EdgeInsets.all(2),),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text("Guardar ahora",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: AppTheme.fontTTNorms,
                                                      color: AppTheme.white,
                                                      fontSize: 11 ,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(8)),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                controller.progress?
                ArsProgressWidget(
                    blur: 2,
                    backgroundColor: Color(0x33000000),
                    animationDuration: Duration(milliseconds: 500)):
                Container(),
                if(controller.showEvaluacionesNoEnviadas)
                  ArsProgressWidget(
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
                                    width: 50,
                                    height: 50,
                                    child: Icon(Ionicons.cloud, size: 35, color: AppTheme.white,),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppTheme.colorAccent),
                                  ),
                                  Padding(padding: EdgeInsets.all(8)),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(padding: EdgeInsets.all(8),
                                            child: Text("Existen asistencias sin guardar", style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: AppTheme.fontTTNormsMedium
                                            ),),
                                          ),
                                          Padding(padding: EdgeInsets.all(4),),
                                          Text("Para que se procésese las asistencias es necesario guardarlos en nuestros servidores",
                                            style: TextStyle(
                                                fontSize: 14,
                                                height: 1.5
                                            ),),
                                          Padding(padding: EdgeInsets.all(4),),
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
                                          controller.onClickCancelarAsistenciaNoEnvidas();
                                        },
                                        child: Text('Cerrar'),
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      )
                                  ),
                                  Padding(padding: EdgeInsets.all(8)),
                                  Expanded(child: ElevatedButton(
                                    onPressed: () async {
                                      //await controller.onClicGuardarAsistencia();
                                      controller.onClickGuardarAsistenciaNoEnvidas();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: AppTheme.green,
                                      onPrimary: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Padding(padding: EdgeInsets.all(4), child: Text('Guardar'),),
                                  )),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                  ),

              ],
            )
        ),
      );

    },
  );

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: AppTheme.white.withOpacity(topBarOpacity),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32.0),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: AppTheme.white
                      .withOpacity(0.4 * topBarOpacity),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,

              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: 16 - 8.0 * topBarOpacity,
                    bottom: 12 - 8.0 * topBarOpacity),
                child: ControlledWidgetBuilder<AsistenciaQRController>(
                  builder: (context, controller) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                            top: 0,
                            child:  IconButton(
                              icon: Icon(Ionicons.arrow_back, color: AppTheme.white, size: 22 + 6 - 6 * topBarOpacity,),
                              onPressed: () {

                                bool salir = controller.salirAplicacion();
                                if(salir){
                                  Navigator.of(this.context).pop();
                                }
                              },
                            )
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    controller.dfechaServidor == null?'Cargando...':"${DomainTools.getNombreDia(controller.dfechaServidor?.weekday)??""} ${controller.dfechaServidor?.day??0} - ${DomainTools.getNombreMes(controller.dfechaServidor?.month)??""}",
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14 + 6 - 6 * topBarOpacity,
                                      letterSpacing: 0.8,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                  Text(
                                    controller.dfechaServidor == null?'':"${DomainTools.changeTime12Hour(controller.dfechaServidor?.hour??0, controller.dfechaServidor?.minute??0)}",
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14 + 6 - 6 * topBarOpacity,
                                      letterSpacing: 0.8,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                                  right: 10,
                                  child: ClipOval(
                                    child: Material(
                                      color: colorPrincipal.withOpacity(0.1), // button color
                                      child: InkWell(
                                        splashColor: colorPrincipal, // inkwell color
                                        child: SizedBox(width: 43 + 6 - 8 * topBarOpacity, height: 43 + 6 - 8 * topBarOpacity,
                                          child: Icon(Icons.settings, size: 24 + 6 - 8 * topBarOpacity,color: AppTheme.white, ),
                                        ),
                                        onTap: () {
                                          _showConfiguracionDialog();
                                        },
                                      ),
                                    ),
                                  ),
                                )
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget getAppBarUI2() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: AppTheme.white.withOpacity(topBarOpacity),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32.0),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: AppTheme.white
                      .withOpacity(0.4 * topBarOpacity),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,

              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: 16 - 8.0 * topBarOpacity,
                    bottom: 12 - 8.0 * topBarOpacity),
                child: ControlledWidgetBuilder<AsistenciaQRController>(
                  builder: (context, controller) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                            top: 8,
                            child:  IconButton(
                              icon: Icon(Ionicons.arrow_back, color: AppTheme.white, size: 22 + 6 - 6 * topBarOpacity,),
                              onPressed: () {
                                Navigator.of(this.context).pop();
                              },
                            )
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppIcon.ic_curso_asistencia, height: 35 +  6 - 10 * topBarOpacity, width: 35 +  6 - 10 * topBarOpacity,),
                              Padding(
                                padding: EdgeInsets.only(left: 12, top: 8),
                                child: Text(
                                  'Asistencia QR',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontTTNorms,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 0.8,
                                    color: AppTheme.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 10,
                          child: ClipOval(
                            child: Material(
                              color: colorPrincipal.withOpacity(0.1), // button color
                              child: InkWell(
                                splashColor: colorPrincipal, // inkwell color
                                child: SizedBox(width: 43 + 6 - 8 * topBarOpacity, height: 43 + 6 - 8 * topBarOpacity,
                                  child: Icon(Icons.settings, size: 24 + 6 - 8 * topBarOpacity,color: AppTheme.white, ),
                                ),
                                onTap: () {
                                  _showConfiguracionDialog();
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget getMainTab() {
    return ControlledWidgetBuilder<AsistenciaQRController>(
        builder: (context, controller) {

          return Container(
            padding: EdgeInsets.only(
              top: /*AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24*/0,
              left: 0,//24,
              right: 0,//48
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                        flex: 8,
                        child: Container(
                          color: AppTheme.black,
                          padding: EdgeInsets.only(
                              left: 0,
                              right: 0
                          ),
                          child: _buildQrView(context, controller),
                        )
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: AppTheme.black,
                      ),
                    )

                  ],
                )
              ],
            ),
          );
        });
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controllerQR!.pauseCamera();
    }
    controllerQR!.resumeCamera();
  }

  Widget _buildQrView(BuildContext context, AsistenciaQRController controller) {

    return FutureBuilder<bool>(
        future: getData(),
    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      if (!snapshot.hasData) {
        return Container(
          color: AppTheme.black,
          child: Stack(
            children: [
              Center(
                child: CircularProgressIndicator(
                  color: AppTheme.white,
                  strokeWidth: 2,
                ),
              )
            ],
          ),
        );
      } else {
        // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
        var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
            ? 250.0
            : 300.0;
        // To ensure the Scanner view is properly sizes after rotation
        // we need to listen for Flutter SizeChanged notification and update controller
        return QRView(
          key: qrKey,
          onQRViewCreated: (controllerQR){
            return _onQRViewCreated(controllerQR, controller);
          },
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        );
      }
    });

  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    //log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('sin permiso')),
      );
    }
  }

  void _onQRViewCreated(QRViewController controllerQR, AsistenciaQRController controller) {
    setState(() {
      this.controllerQR = controllerQR;
    });

    controllerQR.scannedDataStream.listen((scanData) {

      if((scanData.code??"").isNotEmpty&&scanData.code != result?.code){

        if(scanData.code!.contains('|')){
          List<String> codes = scanData.code!.split("|");
          if(codes.isNotEmpty){
            String code = codes[0];
            player.play(AppSound.so_beep,
              volume: 0.3
            );

            String nombre = scanData.code!.replaceAll(code, "");
            nombre = nombre.replaceAll("|", "");
            result = scanData;
            controller.scanCodeAlumno(code, nombre);
          }
        }
      }

    });
  }

  Future<bool?> _showConfiguracionDialog() async {
    return await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return StatefulBuilder(
              builder: (context, setState) {
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
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  /*if (result != null)
                              Text(
                                  'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                            else
                              const Text('Scan a code'),*/
                                  Text("Configuración",
                                    style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16
                                    ),
                                  ),
                                  Padding(padding: const EdgeInsets.all(8),),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 250,
                                        child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () async {
                                              await controllerQR?.toggleFlash();
                                              setState(() {});
                                            },
                                            child: FutureBuilder(
                                              future: controllerQR?.getFlashStatus(),
                                              builder: (context, snapshot) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                        (snapshot.data==true)?Ionicons.flash:Ionicons.flash_off,
                                                      color: colorPrincipal,
                                                    ),
                                                    Text(' Flash',
                                                      style: TextStyle(
                                                          fontFamily: AppTheme.fontTTNorms,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 14,
                                                        color: colorPrincipal,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            )),
                                      ),
                                      Container(
                                        width: 250,
                                        child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () async {
                                              await controllerQR?.flipCamera();
                                              setState(() {});
                                            },
                                            child: FutureBuilder(
                                              future: controllerQR?.getCameraInfo(),
                                              builder: (context, snapshot) {
                                                if (snapshot.data != null) {
                                                  return Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Ionicons.camera_reverse,
                                                        color: colorPrincipal,
                                                      ),
                                                      Text(
                                                        ' Cámara ${(describeEnum(snapshot.data!).toString() == "front")?"frontal":"trasera"}',
                                                        style: TextStyle(
                                                          fontFamily: AppTheme.fontTTNorms,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 14,
                                                          color: colorPrincipal,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Text('Cargando',
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontTTNorms,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 14,
                                                      color: colorPrincipal,
                                                    ),
                                                  );
                                                }
                                              },
                                            )),
                                      )
                                    ],
                                  ),
                                  /*Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.all(8),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            await controllerQR?.pauseCamera();
                                          },
                                          child: const Text('pause',
                                              style: TextStyle(fontSize: 20)),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.all(8),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            await controllerQR?.resumeCamera();
                                          },
                                          child: const Text('resume',
                                              style: TextStyle(fontSize: 20)),
                                        ),
                                      )
                                    ],
                                  ),*/
                                ],
                              ),
                            ),
                            Padding(padding: const EdgeInsets.all(8),),
                            Row(
                              children: [
                                Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary:colorPrincipal,
                                        onPrimary: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('Atras',
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                );
              },
          );
        },
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.transparent,
        transitionDuration:
        const Duration(milliseconds: 150));
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  @override
  void dispose() {
    controllerQR?.dispose();
    super.dispose();
  }
}