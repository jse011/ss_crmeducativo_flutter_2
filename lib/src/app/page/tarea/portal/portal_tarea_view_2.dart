import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_not_expanded_custom.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/presicion/precision_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/multimedia/tarea_multimedia_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/portal/portal_tarea_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_url_launcher.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_unidad_tarea_repositoy.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_formula_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_archivo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_ui.dart';

import 'package:ss_crmeducativo_2/src/domain/entities/tarea_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart'; // for max function
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_drive_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_youtube_tools.dart';

class PortalTareaView2 extends View{
  CursosUi? cursosUi;
  UsuarioUi? usuarioUi;
  TareaUi? tareaUi;
  UnidadUi? unidadUi;
  SesionUi? sesionUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;

  PortalTareaView2(this.usuarioUi,this.cursosUi, this.tareaUi, this.calendarioPeriodoUI, this.unidadUi, this.sesionUi);

  @override
  _PortalTareaViewState createState() => _PortalTareaViewState(usuarioUi,cursosUi, tareaUi, calendarioPeriodoUI, unidadUi, sesionUi);

}

class _PortalTareaViewState extends ViewState<PortalTareaView2, PortalTareaController> with TickerProviderStateMixin{

  GlobalKey listaEvaluadoKey = GlobalKey();
  GlobalKey listaNoEvaluadoKey = GlobalKey();
  Map<TareaAlumnoUi,GlobalKey> evaluadoKeyMap = Map();


  final ScrollController scrollController = ScrollController();
  final FloatingSearchBarController floatingSearchBarController = FloatingSearchBarController();
  late double topBarOpacity = 0.0;
  int _indexTab = 0;
  _PortalTareaViewState(usuarioUi, cursosUi, tareaUi, calendarioPeriodoUI, unidadUi, sesionUi) : super(PortalTareaController(usuarioUi, cursosUi, tareaUi, calendarioPeriodoUI, unidadUi, sesionUi,DeviceHttpDatosRepositorio(), MoorUnidadTareaRepository(), MoorConfiguracionRepository(), MoorRubroRepository()));

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  ConnectivityResult _connectionStatusValidate = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  List<TareaAlumnoUi>? filteredUsers = null;

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

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    floatingSearchBarController.dispose();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch(result){
      case ConnectivityResult.wifi:
        print("_updateConnectionStatus wifi");
        break;
      case ConnectivityResult.ethernet:
        print("_updateConnectionStatus ethernet");
        break;
      case ConnectivityResult.mobile:
        print("_updateConnectionStatus mobile");
        break;
      case ConnectivityResult.none:
        print("_updateConnectionStatus none");
        break;
    }

    setState(() {
      _connectionStatus = result;
    });
  }

// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status errot:${e}');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }


  @override
  Widget get view => ControlledWidgetBuilder<PortalTareaController>(
      builder: (context, controller) {

        if(controller.cerraryactualizar){
          if (mounted) {
            WidgetsBinding.instance?.addPostFrameCallback((_){
              Navigator.of(context).pop(1);
              controller.clearCerraryactualizar();
            });
          }
        }

        comprobarConexion(controller);

        if(controller.mensaje!=null&&controller.mensaje!.isNotEmpty){
          Fluttertoast.showToast(
            msg: controller.mensaje!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
          controller.successMsg();
        }
        abrirRubrica(controller);
        abrirTareaAlumnoArchivosConDrive(controller);
        return WillPopScope(
          onWillPop: () async {
            if(!controller.progressSailrGuardar){
              bool  seaModicado =  controller.onChangeTarea();
              bool guardadoEvalEnProgreso = controller.onSaveProgressEvaluacion();
              bool errorAlguardar = controller.onCountErrorGuardar()>0;

              if((errorAlguardar || guardadoEvalEnProgreso)){
                controller.showDialogSaveEvaluacion();
              }else{
                if(seaModicado){
                  Navigator.of(context).pop(1);
                }else{
                  Navigator.of(context).pop(false);
                }
              }
            }
            return false;
          },
          child: Scaffold(
            backgroundColor: AppTheme.background,
            body: Stack(
              children: [
                getMainTab(),
                getAppBarUI(),
                if(controller.alumnoSearch)
                  buildFloatingSearchBar(context, controller),


                controller.progress?
                ArsProgressWidget(
                    blur: 2,
                    backgroundColor: Color(0x33000000),
                    animationDuration: Duration(milliseconds: 500)):
                Container(),
                controller.showDialogEliminar?
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
                                    child: Icon(Ionicons.trash, size: 35, color: AppTheme.white,),
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
                                            child: Text("Eliminar tarea", style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: AppTheme.fontTTNormsMedium
                                            ),),
                                          ),
                                          Padding(padding: EdgeInsets.all(4),),
                                          Text("¿Está seguro de eliminar la tarea?\nRecuerde que si elimina se borrará la tarea permanentemente.",
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
                                          controller.onClickCancelarEliminar();
                                        },
                                        child: Text('Cancelar'),
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
                                      await controller.onClickAceptarEliminar();
                                      Navigator.of(context).pop(1);//si devuelve un entero se actualiza toda la lista
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      onPrimary: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Padding(padding: EdgeInsets.all(4), child: Text('Eliminar'),),
                                  )),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                  ):
                  Container(),
                controller.showDialogSaveEval?
                ArsProgressWidget(
                    blur: 2,
                    backgroundColor: Color(0x33000000),
                    animationDuration: Duration(milliseconds: 500),
                    loadingWidget: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16)), // if you need this
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16)),
                        constraints: BoxConstraints(
                            minWidth: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 100),
                            maxWidth: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 400)
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 45),
                                    height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 45),
                                    child: Icon(Ionicons.save, size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 28), color: AppTheme.white,),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: HexColor(controller.cursosUi?.color1),
                                    )
                                ),
                                Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8))),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4)),),
                                        Text("No se ha guardado una o varias de sus evaluaciones",
                                          style: TextStyle(
                                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 18),
                                              fontWeight: FontWeight.w700,
                                              fontFamily: AppTheme.fontTTNormsMedium
                                          ),),
                                        Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4)),),
                                        Text("Existen evaluaciones que aun no se han guardardo. ¿Esta seguro que quiere salir?",
                                          style: TextStyle(
                                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14),
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
                                    child: ElevatedButton(
                                      onPressed: () {
                                        controller.onClickSalirGuardar();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: HexColor("#e5faf3"),
                                        onPrimary: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                            left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4),
                                            right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4),
                                            bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8),
                                            top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8),
                                          ),
                                          child: Text('Guardar',
                                              style: TextStyle(
                                                color:  HexColor("#00c985"),
                                                fontWeight: FontWeight.w700,
                                                fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14),)
                                          )
                                      ),
                                    )
                                ),
                                Padding(padding: EdgeInsets.all(8)),
                                Expanded(
                                  child:  Container(),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        controller.closeDialogSaveEvaluacion();
                                      },
                                      child: Text('Atras', style: TextStyle(fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14)),),
                                      style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8)),
                                          ),
                                          primary: AppTheme.darkText
                                      ),
                                    )
                                ),
                                Padding(padding: EdgeInsets.all(8)),
                                Expanded(
                                  child:  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: AppTheme.redLighten4,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text('Salir sin guardar',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14),
                                          color: AppTheme.red,
                                          fontWeight: FontWeight.w700
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                ):
                Container(),
                controller.progressSailrGuardar?
                ArsProgressWidget(
                    blur: 2,
                    backgroundColor: Color(0x33000000),
                    animationDuration: Duration(milliseconds: 500)):
                Container(),
                controller.showDialogPublicarEval?
                ArsProgressWidget(
                    blur: 2,
                    backgroundColor: Color(0x33000000),
                    animationDuration: Duration(milliseconds: 500),
                    loadingWidget: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16)), // if you need this
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16)),
                        constraints: BoxConstraints(
                            minWidth: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 100),
                            maxWidth: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 400)
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 45),
                                    height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 45),
                                    child: Icon(Icons.grid_on, size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 28), color: AppTheme.white,),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: HexColor(controller.cursosUi?.color1),
                                    )
                                ),
                                Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8))),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4)),),
                                        Text("Procesar evaluaciones",
                                          style: TextStyle(
                                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 18),
                                              fontWeight: FontWeight.w700,
                                              fontFamily: AppTheme.fontTTNormsMedium
                                          ),),
                                        Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4)),),
                                        Text('Las evaluaciones de esta tarea se procesarán y se enviarán a su rúbrica "${controller.rubricaEvalUI?.titulo}".',
                                          style: TextStyle(
                                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14),
                                              height: 1.5
                                          ),),
                                        Padding(padding: EdgeInsets.all(8),),
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
                                        controller.closeDialogPublicarEval();
                                      },
                                      child: Text('Atras', style: TextStyle(fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14)),),
                                      style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8)),
                                          ),
                                          primary: AppTheme.darkText
                                      ),
                                    )
                                ),
                                Padding(padding: EdgeInsets.all(8)),
                                Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        controller.clickPublicarDialogPublicarEval();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: HexColor("#e5faf3"),
                                        onPrimary: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                            left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4),
                                            right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4),
                                            bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8),
                                            top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8),
                                          ),
                                          child: Text('Procesar',
                                              style: TextStyle(
                                                color:  HexColor("#00c985"),
                                                fontWeight: FontWeight.w700,
                                                fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14),)
                                          )
                                      ),
                                    )
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                ):
                Container(),
                controller.progressPublicarEval?
                ArsProgressWidget(
                    blur: 2,
                    backgroundColor: Color(0x33000000),
                    animationDuration: Duration(milliseconds: 500)):
                Container(),
                controller.progressCambiosEvaluacion?
                ArsProgressWidget(
                    blur: 2,
                    backgroundColor: Color(0x33000000),
                    animationDuration: Duration(milliseconds: 500)):
                Container(),
              ],
            ),
          ),
        );
      });

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        ControlledWidgetBuilder<PortalTareaController>(
          builder: (context, controller) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8 + 4),
                      right:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8 + 4),
                      top:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16 + 4),
                      bottom:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 12  + 4)
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          child:  IconButton(
                            icon: Icon(Ionicons.arrow_back,
                                color: AppTheme.nearlyBlack,
                                size:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 22 + 6 + 4)
                            ),
                            onPressed: () {
                              bool  seaModicado =  controller.onChangeTarea();
                              bool guardadoEvalEnProgreso = controller.onSaveProgressEvaluacion();
                              bool errorAlguardar = controller.onCountErrorGuardar()>0;

                              if(errorAlguardar || guardadoEvalEnProgreso){
                                controller.showDialogSaveEvaluacion();
                              }else{
                                if(seaModicado){
                                  Navigator.of(context).pop(1);
                                }else{
                                  Navigator.of(context).pop(false);
                                }//si devuelve un entero se actualiza toda la lista;

                              }
                              return;

                            },
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8 + 4),
                            bottom:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8 + 4),
                            left:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8 + 4),
                            right:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 52 + 4)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppIcon.ic_curso_tarea,
                                height:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 32 +  6 + 4),
                                width:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 35 +  6 + 4)
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, top: 8),
                              child: Text(
                                'Tarea ${controller.tareaUi?.position??""}',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontTTNorms,
                                  fontWeight: FontWeight.w700,
                                  fontSize:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 14 + 6  + 4),
                                  letterSpacing: 0.8,
                                  color: AppTheme.darkerText,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      Positioned(
                        top:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8 + 4),
                        bottom: 0,
                        right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16 + 4),
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async{
                                await controller.onClicPublicar();
                              },
                              child:  controller.progressRubro?
                              SizedBox(
                                child: Shimmer.fromColors(
                                  baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                  highlightColor: Color.fromRGBO(166, 166, 166, 1.0),
                                  child: Container(
                                    height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 30),
                                    width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,80),
                                    padding: EdgeInsets.only(
                                        left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16) ,
                                        right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                                        top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8),
                                        bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                        color: HexColor(controller.cursosUi?.color2)
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ):Container(
                                padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                  color:  controller.tareaUi?.publicado??false?  HexColor(controller.cursosUi?.color2) : AppTheme.white,
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(controller.tareaUi?.publicado??false ?"Publicado":"Sin publicar",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.6,
                                            color: controller.tareaUi?.publicado??false?AppTheme.white:AppTheme.greyDarken1,
                                            fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 5 + 6  ),
                                          )),
                                    ),
                                    Padding(padding: EdgeInsets.all(2),),
                                    Icon(
                                      Ionicons.earth,
                                      color: controller.tareaUi?.publicado??false?AppTheme.white :AppTheme.greyDarken1,
                                      size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 9 + 6 ), ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        )
      ],
    );
  }

  Widget getMainTab() {
    return ControlledWidgetBuilder<PortalTareaController>(
        builder: (context, controller) {
          return Container(
            padding: EdgeInsets.only(
                top: AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top +
                    ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16 + 8),
                left: 0,
                right: 0
            ),
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,24),
                      right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,24),
                    ),
                    constraints: BoxConstraints.expand(height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 50 + 4)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TabBar(
                              indicatorColor: HexColor(controller.cursosUi?.color1),
                              labelColor: HexColor(controller.cursosUi?.color1),
                              unselectedLabelColor: Colors.grey,
                              onTap: (index){
                                setState(() {

                                  if(_indexTab != index){
                                    topBarOpacity = 0.0;
                                  }
                                  _indexTab = index;
                                });
                              },
                              //isScrollable: _indexTab == 1 && topBarOpacity == 1 && MediaQuery.of(context).orientation == Orientation.portrait,
                              labelStyle: TextStyle(fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 12 + 4), fontWeight: FontWeight.w500),
                              tabs: [
                                Tab(child: Text("Instruciones", maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                Tab(child: Text("Trabajo del alumno", maxLines: 1, overflow: TextOverflow.ellipsis,)),
                              ]),
                        ),
                        if(topBarOpacity == 1)
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: InkWell(
                              onTap: (){
                                if(!controller.alumnoSearch){
                                  controller.onClickMostrarBuscador();
                                  onMostrarBuscador();
                                }
                              },
                              child: Container(
                                height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 30),
                                width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 30),
                                padding: EdgeInsets.only(
                                    left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4 + 2) ,
                                    right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4 + 2),
                                    top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4 + 2),
                                    bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4 + 2)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    color: HexColor(controller.cursosUi?.color2)
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(controller.toogleGeneral?Ionicons.search: Ionicons.search,
                                        color: AppTheme.white,
                                        size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16 + 2)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: TabBarView(children: [
                        CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: EdgeInsets.only(
                                  left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,24 ),
                                  right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,24 )),
                              sliver: SliverList(
                                  delegate: SliverChildListDelegate([
                                    Stack(
                                      children: [
                                        Center(
                                          child: Container(
                                            constraints: BoxConstraints(
                                              //minWidth: 200.0,
                                              //maxWidth: 600.0,
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                controller.progressRubro?
                                                Container(
                                                  margin: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24 + 4)),
                                                  child:  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        child: Shimmer.fromColors(
                                                          baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                                          highlightColor: Color.fromRGBO(166, 166, 166, 1.0),
                                                          child: Container(
                                                            height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 30),
                                                            width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,100),
                                                            padding: EdgeInsets.only(
                                                                left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16) ,
                                                                right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                                                                top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8),
                                                                bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                                                color: HexColor(controller.cursosUi?.color2)
                                                            ),
                                                            alignment: Alignment.center,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(padding: EdgeInsets.only(
                                                          left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16)
                                                      )),
                                                      SizedBox(
                                                        child: Shimmer.fromColors(
                                                          baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                                          highlightColor: Color.fromRGBO(166, 166, 166, 1.0),
                                                          child: Container(
                                                            height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 30),
                                                            width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,100),
                                                            padding: EdgeInsets.only(
                                                                left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16) ,
                                                                right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                                                                top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8),
                                                                bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                                                color: HexColor(controller.cursosUi?.color2)
                                                            ),
                                                            alignment: Alignment.center,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(padding: EdgeInsets.only(
                                                          left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16)
                                                      )),
                                                      SizedBox(
                                                        child: Shimmer.fromColors(
                                                          baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                                          highlightColor: Color.fromRGBO(166, 166, 166, 1.0),
                                                          child: Container(
                                                            height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 30),
                                                            width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,100),
                                                            padding: EdgeInsets.only(
                                                                left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16) ,
                                                                right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                                                                top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8),
                                                                bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                                                color: HexColor(controller.cursosUi?.color2)
                                                            ),
                                                            alignment: Alignment.center,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ):
                                                Container(
                                                  margin: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24 + 4)),
                                                  child:  Wrap(
                                                    spacing: 10.0,
                                                    runSpacing: 15.0,
                                                    direction: Axis.horizontal,
                                                    alignment: WrapAlignment.start,
                                                    children: <Widget>[
                                                      InkWell(
                                                        onTap: () async{
                                                          await controller.onClicPublicar();
                                                        },
                                                        child: Container(
                                                          width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,120),
                                                          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                                              color: controller.tareaUi?.publicado??false?HexColor(controller.cursosUi?.color2) : AppTheme.white
                                                          ),
                                                          alignment: Alignment.center,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Icon(Ionicons.earth ,
                                                                  color: controller.tareaUi?.publicado??false?AppTheme.white:AppTheme.greyDarken1,
                                                                  size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 9 + 6 )
                                                              ),
                                                              Padding(padding: EdgeInsets.all(2),),
                                                              FittedBox(
                                                                fit: BoxFit.scaleDown,
                                                                child: Text("Publicar Tarea",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      letterSpacing: 0.5,
                                                                      color: controller.tareaUi?.publicado??false?AppTheme.white: AppTheme.greyDarken1,
                                                                      fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 5 + 6) ,
                                                                    )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                      InkWell(
                                                        onTap: () async{
                                                          dynamic? result = await AppRouter.createRouteTareaCrearRouter(context,  controller.usuarioUi, controller.cursosUi, controller.tareaUi, controller.calendarioPeriodoUI, controller.unidadUi, controller.sesionUi);
                                                          if(result is int) controller.cambiosTarea();

                                                        },
                                                        child: Container(
                                                          width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,110),
                                                          padding: EdgeInsets.only(
                                                              left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16) ,
                                                              right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                                                              top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8),
                                                              bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                                              color: HexColor(controller.cursosUi?.color2)
                                                          ),
                                                          alignment: Alignment.center,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Icon(Ionicons.pencil ,
                                                                color: AppTheme.white,
                                                                size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,9 + 6  )
                                                                , ),
                                                              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 2)),),
                                                              FittedBox(
                                                                fit: BoxFit.scaleDown,
                                                                child: Text("Modificar",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      letterSpacing: 0.5,
                                                                      color:AppTheme.white,
                                                                      fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 5 + 6 - 1),
                                                                    )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                      InkWell(
                                                        onTap: () {
                                                          controller.onClicEliminar();
                                                        },
                                                        child: Container(
                                                          width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,110),
                                                          padding: EdgeInsets.only(
                                                              left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16) ,
                                                              right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                                                              top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8),
                                                              bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)
                                                          ),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                                              color: HexColor(controller.cursosUi?.color2)
                                                          ),
                                                          alignment: Alignment.center,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Icon(Ionicons.trash ,color: AppTheme.white,
                                                                size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,9 + 6),
                                                              ),
                                                              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,2)),),
                                                              FittedBox(
                                                                fit: BoxFit.scaleDown,
                                                                child: Text("Eliminar",
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.w500,
                                                                      letterSpacing: 0.5,
                                                                      color:AppTheme.white,
                                                                      fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,5 + 6),
                                                                    )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 24),
                                                  child: Text("Fecha de entrega: ${(controller.tareaUi?.fechaEntrega??"sin fecha de entrega").replaceAll("\n", "")}", style: TextStyle(fontSize: 12),),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 8),
                                                  child: Text("${controller.tareaUi?.titulo}", style: TextStyle(color: HexColor(controller.cursosUi?.color1) , fontSize: 18),),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: 16),
                                                  height: 1,
                                                  color: HexColor(controller.cursosUi?.color1),
                                                ),
                                                (controller.tareaUi?.instrucciones??"").isNotEmpty?
                                                Container(
                                                  margin: EdgeInsets.only(top: 24),
                                                  child: Text("${controller.tareaUi?.instrucciones}",
                                                    style: TextStyle(fontSize: 14, height: 1.5),),
                                                ):Container(),
                                                controller.tareaRecursoUiList.isNotEmpty?
                                                Container(
                                                  margin: EdgeInsets.only(top: 16),
                                                  child: Text("Recursos",
                                                    style: TextStyle(fontSize: 14, color: AppTheme.black, fontWeight: FontWeight.w500),),
                                                ):Container(),
                                                ListView.builder(
                                                    padding: EdgeInsets.only(top: 8.0, bottom: 0),
                                                    itemCount: controller.tareaRecursoUiList.length,
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemBuilder: (context, index){
                                                      TareaRecusoUi tareaRecursoUi = controller.tareaRecursoUiList[index];

                                                      return Stack(
                                                        children: [
                                                          Container(
                                                            child: InkWell(
                                                              onTap: () async {

                                                                switch(tareaRecursoUi.tipoRecurso){
                                                                  case TipoRecursosUi.TIPO_DOCUMENTO:
                                                                  case TipoRecursosUi.TIPO_IMAGEN:
                                                                  case TipoRecursosUi.TIPO_AUDIO:
                                                                  case TipoRecursosUi.TIPO_HOJA_CALCULO:
                                                                  case TipoRecursosUi.TIPO_DIAPOSITIVA:
                                                                  case TipoRecursosUi.TIPO_PDF:
                                                                  case TipoRecursosUi.TIPO_VINCULO:
                                                                    await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(tareaRecursoUi.driveId), webview: false);
                                                                    break;
                                                                  case TipoRecursosUi.TIPO_ENCUESTA:
                                                                    await AppUrlLauncher.openLink(tareaRecursoUi.url, webview: false);
                                                                    break;
                                                                  case TipoRecursosUi.TIPO_VINCULO_DRIVE:
                                                                  //await AppUrlLauncher.openLink(tareaRecursoUi.url, webview: false);
                                                                    await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(tareaRecursoUi.driveId), webview: false);
                                                                    break;
                                                                  case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
                                                                    print("youtube: ${tareaRecursoUi.url}");
                                                                    TareaMultimediaView.showDialog(context, YouTubeUrlParser.getYoutubeVideoId(tareaRecursoUi.url), TareaMultimediaTipoArchivo.YOUTUBE);
                                                                    break;
                                                                  case TipoRecursosUi.TIPO_RECURSO:
                                                                  //await AppUrlLauncher.openLink(tareaRecursoUi.url, webview: false);

                                                                    break;
                                                                  default:
                                                                    await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(tareaRecursoUi.driveId), webview: false);
                                                                    break;
                                                                }


                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(8), // use instead of BorderRadius.all(Radius.circular(20))
                                                                  border:  Border.all(
                                                                      width: 1,
                                                                      color: HexColor(controller.cursosUi?.color1)
                                                                  ),
                                                                  color: AppTheme.greyLighten2,
                                                                ),
                                                                margin: EdgeInsets.only(bottom: 12),
                                                                width: 450,
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                                                  child: Container(
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          width: 50,
                                                                          child: Center(
                                                                            child: Image.asset(getImagen(tareaRecursoUi.tipoRecurso),
                                                                              height: 30.0,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Container(
                                                                            color: AppTheme.white,
                                                                            padding: EdgeInsets.only(left:16, top: 8, bottom: 8, right: 8),
                                                                            child:  Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text("${tareaRecursoUi.titulo??""}", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppTheme.greyDarken3, fontSize: 12),),
                                                                                Padding(padding: EdgeInsets.all(2)),
                                                                                tareaRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO_YOUTUBE || tareaRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO_DRIVE || tareaRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO?
                                                                                Text("${(tareaRecursoUi.url??"").isNotEmpty?tareaRecursoUi.url: tareaRecursoUi.descripcion}", maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(color: AppTheme.blue, fontSize: 10)):
                                                                                Text("${(tareaRecursoUi.descripcion??"").isNotEmpty?tareaRecursoUi.descripcion: getDescripcion(tareaRecursoUi.tipoRecurso)}", maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(color: AppTheme.grey, fontSize: 10)),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                ),
                                                controller.tareaRecursoUiList.isNotEmpty?
                                                Container(
                                                  margin: EdgeInsets.only(top: 32),
                                                  height: 1,
                                                  color: AppTheme.greyLighten1,
                                                ):Container(),
                                                Container(
                                                  margin: EdgeInsets.only(top: 16),
                                                  child: Text("Comentario de clase",
                                                    style: TextStyle(fontSize: 14, color: AppTheme.black, fontWeight: FontWeight.w500),),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top:  4),
                                                  child: Row(
                                                    children: [
                                                      CachedNetworkImage(
                                                        placeholder: (context, url) => Container(
                                                          child: CircularProgressIndicator(),
                                                        ),
                                                        imageUrl: controller.usuarioUi?.personaUi?.foto??"",
                                                        errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                                        imageBuilder: (context, imageProvider) =>
                                                            Container(
                                                                width: 40,
                                                                height: 40,
                                                                margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  image: DecorationImage(
                                                                    image: imageProvider,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                )
                                                            ),
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                height: 65,
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Expanded(
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                          color: AppTheme.greyLighten3,
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                          border: Border.all(color: AppTheme.greyLighten2),
                                                                        ),
                                                                        padding: EdgeInsets.all(8),
                                                                        child: Row(
                                                                          children: <Widget>[
                                                                            Expanded(
                                                                              child: TextField(
                                                                                maxLines: null,
                                                                                keyboardType: TextInputType.multiline,
                                                                                style: TextStyle(
                                                                                  fontSize: 12,

                                                                                ),
                                                                                decoration: InputDecoration(
                                                                                    isDense: true,
                                                                                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                                                                                    hintText: "",
                                                                                    border: InputBorder.none),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),

                                                            IconButton(
                                                              onPressed: () {
                                                                // You enter here what you want the button to do once the user interacts with it
                                                              },
                                                              icon: Icon(
                                                                Icons.send,
                                                                color: AppTheme.greyDarken1,
                                                              ),
                                                              iconSize: 20.0,
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                false?
                                                Container(
                                                  margin: EdgeInsets.only(top:  4, bottom: 16),
                                                  child: Row(
                                                    children: [
                                                      CachedNetworkImage(
                                                        placeholder: (context, url) => Container(
                                                          child: CircularProgressIndicator(),
                                                        ),
                                                        imageUrl: "https://cdn.domestika.org/c_fill,dpr_1.0,f_auto,h_1200,pg_1,t_base_params,w_1200/v1589759117/project-covers/000/721/921/721921-original.png?1589759117",
                                                        errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                                        imageBuilder: (context, imageProvider) =>
                                                            Container(
                                                                width: 40,
                                                                height: 40,
                                                                margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                  image: DecorationImage(
                                                                    image: imageProvider,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                )
                                                            ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: AppTheme.greyLighten3,
                                                            borderRadius: BorderRadius.circular(8.0),
                                                            border: Border.all(color: AppTheme.greyLighten2),
                                                          ),
                                                          padding: EdgeInsets.all(8),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                      child: Container(
                                                                          padding: EdgeInsets.only(right: 8),
                                                                          child: Text("Velasquez Vilma Gregoria",
                                                                              style: TextStyle(
                                                                                  fontSize: 10,
                                                                                  fontWeight: FontWeight.w700
                                                                              ))
                                                                      )
                                                                  ),
                                                                  Text("Vie 03 de set. - 13:37",
                                                                      style: TextStyle(
                                                                          fontSize: 10,
                                                                          color: AppTheme.greyDarken1
                                                                      )
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(padding: EdgeInsets.all(2)),
                                                              Container(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text("Miss mil disculpas no cargo el video por eso lo enviamos al whassap", style: TextStyle(fontSize: 10),),
                                                              ),
                                                              Padding(padding: EdgeInsets.all(2)),
                                                              Container(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text("Responder",
                                                                    style: TextStyle(
                                                                        fontSize: 10,
                                                                        color: AppTheme.greyDarken1
                                                                    )
                                                                ),
                                                              )

                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ):Container(),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.only(bottom: 200))
                                  ])
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            if(controller.onCountErrorGuardar()>0 || controller.progressEvalTarea == true)
                              Container(
                                padding: EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
                                color: AppTheme.yellowLighten4,
                                height: 50,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child:  Text("${controller.progressEvalTarea?"Guardando sus evaluaciones...":"No se ha guardado una o varias de sus evaluaciones."}", style: TextStyle(fontSize: 12),),
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 8),),
                                    controller.progressEvalTarea?
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ):
                                    TextButton(
                                        onPressed: (){
                                          controller.hayCambioEnLaConexion();
                                        },
                                        child: Text('Guardar')
                                    )
                                  ],
                                ),
                              ),
                            Expanded(
                              child: CustomScrollView(
                                //shrinkWrap: true,
                                //physics: NeverScrollableScrollPhysics(),
                                controller: scrollController,
                                slivers: [
                                  SliverToBoxAdapter(
                                    child: Container(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: (){

                                          double width_pantalla = MediaQuery.of(context).size.width;
                                          double padding_left = ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24 + 4);
                                          double padding_right = ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24 + 4);
                                          double width_table = padding_left + padding_right + 110;
                                          for(double column_px in controller.tablecolumnWidths){
                                            width_table += column_px;
                                          }
                                          double width = 0;
                                          if(width_pantalla>width_table){
                                            width = width_pantalla;
                                          }else{
                                            width = width_table;
                                          }

                                          return Column(
                                            children: [
                                              controller.progressRubro?
                                              Container(
                                                width: width,
                                                padding: EdgeInsets.only(left: padding_left, right: padding_right),
                                                margin: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,24)),
                                                child:  Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    if(controller.rubricaEvalUI == null)
                                                      SizedBox(
                                                        child: Shimmer.fromColors(
                                                          baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                                          highlightColor: Color.fromRGBO(166, 166, 166, 1.0),
                                                          child: Container(
                                                            height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 30),
                                                            width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,110),
                                                            padding: EdgeInsets.only(
                                                                left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16) ,
                                                                right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                                                                top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8),
                                                                bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                                                color: HexColor(controller.cursosUi?.color2)
                                                            ),
                                                            alignment: Alignment.center,
                                                          ),
                                                        ),
                                                      ),
                                                    if(controller.rubricaEvalUI == null)
                                                      Padding(padding: EdgeInsets.only(
                                                          left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16)
                                                      )),
                                                    if(controller.rubricaEvalUI != null)
                                                      SizedBox(
                                                        child: Shimmer.fromColors(
                                                          baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                                          highlightColor: Color.fromRGBO(166, 166, 166, 1.0),
                                                          child: Container(
                                                            height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 30),
                                                            width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,110),
                                                            padding: EdgeInsets.only(
                                                                left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16) ,
                                                                right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                                                                top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8),
                                                                bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                                                color: HexColor(controller.cursosUi?.color2)
                                                            ),
                                                            alignment: Alignment.center,
                                                          ),
                                                        ),
                                                      ),
                                                    if(controller.rubricaEvalUI != null)
                                                      Padding(padding: EdgeInsets.only(
                                                          left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16)
                                                      )),
                                                    if(controller.rubricaEvalUI != null && controller.cambiosEvaluacionFirebase)
                                                      SizedBox(
                                                        child: Shimmer.fromColors(
                                                          baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                                          highlightColor: Color.fromRGBO(166, 166, 166, 1.0),
                                                          child: Container(
                                                            height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 30),
                                                            width: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,110),
                                                            padding: EdgeInsets.only(
                                                                left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16) ,
                                                                right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                                                                top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8),
                                                                bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                                                color: HexColor(controller.cursosUi?.color2)
                                                            ),
                                                            alignment: Alignment.center,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ):
                                              Container(
                                                width: width,
                                                padding: EdgeInsets.only(left: padding_left, right: padding_right),
                                                margin: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,24)),
                                                child:  Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          if(controller.rubricaEvalUI == null)
                                                            InkWell(
                                                              onTap: () async{

                                                                dynamic response = await AppRouter.createRouteRubroCrearRouter(context, controller.cursosUi, controller.calendarioPeriodoUI, controller.sesionUi,controller.tareaUi, null, true);
                                                                if(response is String) controller.successCrearEvaluacion(response);
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets.only(
                                                                    left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16) ,
                                                                    right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                                                                    top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8),
                                                                    bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                                                    color: HexColor(controller.cursosUi?.color2)
                                                                ),
                                                                alignment: Alignment.center,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Icon(Icons.add ,color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,15), ),
                                                                    Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,2)),),
                                                                    FittedBox(
                                                                      fit: BoxFit.scaleDown,
                                                                      child: Text("Crear rúbrica",
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            letterSpacing: 0.5,
                                                                            color:AppTheme.white,
                                                                            fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,11),
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          if(controller.rubricaEvalUI == null)
                                                            Padding(padding: EdgeInsets.only(
                                                                left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16)
                                                            )),
                                                          if(controller.rubricaEvalUI != null)
                                                            InkWell(
                                                              onTap: () async{
                                                                await controller.onClickRubrica();
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets.only(
                                                                    left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16) ,
                                                                    right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                                                                    top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8),
                                                                    bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                                                    color: HexColor(controller.cursosUi?.color2)
                                                                ),
                                                                alignment: Alignment.center,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Icon(Icons.backpack ,color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,14), ),
                                                                    Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,2)),),
                                                                    FittedBox(
                                                                      fit: BoxFit.scaleDown,
                                                                      child: Text("Abrir rúbrica",
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            letterSpacing: 0.5,
                                                                            color:AppTheme.white,
                                                                            fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,11),
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          if(controller.rubricaEvalUI != null)
                                                            Padding(padding: EdgeInsets.only(
                                                                left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16)
                                                            )),
                                                          if(controller.rubricaEvalUI != null && controller.cambiosEvaluacionFirebase)
                                                            InkWell(
                                                              onTap: ()=> controller.onClickPublicarEvaluacion(),
                                                              child: Container(
                                                                padding: EdgeInsets.only(
                                                                    left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16) ,
                                                                    right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                                                                    top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8),
                                                                    bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                                                    color: HexColor(controller.cursosUi?.color1)
                                                                ),
                                                                alignment: Alignment.center,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Icon(Icons.grid_on ,color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,14)),
                                                                    Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,2)),),
                                                                    FittedBox(
                                                                      fit: BoxFit.scaleDown,
                                                                      child: Text("Actualizar nota",
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            letterSpacing: 0.5,
                                                                            color:AppTheme.white,
                                                                            fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,11),
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: (){
                                                        if(!controller.alumnoSearch){
                                                          controller.onClickMostrarBuscador();
                                                          onMostrarBuscador();
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.only(
                                                            left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4 + 2) ,
                                                            right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4 + 2),
                                                            top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4 + 2),
                                                            bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4 + 2)),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                                            color: HexColor(controller.cursosUi?.color2)
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Icon(controller.toogleGeneral?Ionicons.search: Ionicons.search,
                                                                color: AppTheme.white,
                                                                size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16 + 2)
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: width,
                                                padding: EdgeInsets.only(left: padding_left, right: padding_right),
                                                margin: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,32)),
                                                child:  Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        child: Container(
                                                          child: InkWell(
                                                            onTap: (){
                                                              final targetContext = listaEvaluadoKey.currentContext;
                                                              if (targetContext != null) {
                                                                Scrollable.ensureVisible(
                                                                  targetContext,
                                                                  duration: const Duration(milliseconds: 400),
                                                                  curve: Curves.easeInOut,
                                                                );
                                                              }
                                                            },
                                                            child: Column(
                                                              children: [
                                                                Text("${controller.alumnoEval}",
                                                                  style: TextStyle(
                                                                      color: HexColor(controller.cursosUi?.color1),
                                                                      fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 20 + 2),
                                                                      fontWeight: FontWeight.w500
                                                                  ),
                                                                ),
                                                                Text("Evaluados",
                                                                    style: TextStyle(
                                                                        color: AppTheme.greyDarken1,
                                                                        fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 10 + 2)
                                                                    )
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    Container(
                                                      color: AppTheme.greyLighten1,
                                                      height: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 40 + 2),
                                                      width: 1,
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                          child: InkWell(
                                                            onTap: (){
                                                              final targetContext = listaNoEvaluadoKey.currentContext;
                                                              if (targetContext != null) {
                                                                Scrollable.ensureVisible(
                                                                  targetContext,
                                                                  duration: const Duration(milliseconds: 400),
                                                                  curve: Curves.easeInOut,
                                                                );
                                                              }
                                                            },
                                                            child: Column(
                                                              children: [
                                                                Text("${controller.alumnoSinEval}",
                                                                  style: TextStyle(
                                                                      color: HexColor(controller.cursosUi?.color1),
                                                                      fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 20 + 2),
                                                                      fontWeight: FontWeight.w500
                                                                  ),
                                                                ),
                                                                Text("Sin evaluar",
                                                                    style: TextStyle(
                                                                        color: AppTheme.greyDarken1,
                                                                        fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 10 + 2)
                                                                    )
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    InkWell(
                                                      onTap: ()=> controller.onClickMostrarTodo(),
                                                      child: Container(
                                                        padding: EdgeInsets.only(
                                                            left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4 + 2) ,
                                                            right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4 + 2),
                                                            top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4 + 2),
                                                            bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4 + 2)),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                                            color: HexColor(controller.cursosUi?.color2)
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Icon(controller.toogleGeneral?Ionicons.contract: Ionicons.expand,
                                                                color: AppTheme.white,
                                                                size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16 + 2)
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              controller.mostrarDosListasAlumnos?
                                              Column(
                                                children: [
                                                  Container(
                                                    key: listaEvaluadoKey,
                                                    width: width,
                                                    padding: EdgeInsets.only(
                                                        left: padding_right,
                                                        right: padding_right,
                                                        top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 32 + 4)
                                                    ),
                                                    child: Text("Lista de evaluados".toUpperCase(),
                                                        style: TextStyle(
                                                            color: HexColor(controller.cursosUi?.color1),
                                                            fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 12 + 4),
                                                            fontWeight: FontWeight.w500
                                                        )
                                                    ),
                                                  ),
                                                  getViewTareaAlumno(controller, controller.tareaAlumnoUiEvaluadosList ,padding_left, padding_right, width_table, width),
                                                  Container(
                                                    key: listaNoEvaluadoKey,
                                                    width: width,
                                                    padding: EdgeInsets.only(
                                                        left: padding_right,
                                                        right: padding_right,
                                                        top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 32 + 4)
                                                    ),
                                                    child: Text("Lista de no evaluados".toUpperCase(),
                                                        style: TextStyle(
                                                            color: HexColor(controller.cursosUi?.color1),
                                                            fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 12 + 4),
                                                            fontWeight: FontWeight.w500
                                                        )
                                                    ),
                                                  ),
                                                  getViewTareaAlumno(controller, controller.tareaAlumnoUiNoEvaluadosList,padding_left, padding_right, width_table, width),
                                                ],
                                              ):
                                              getViewTareaAlumno(controller, controller.tareaAlumnoUiList,padding_left, padding_right, width_table, width),
                                              Container(
                                                padding: EdgeInsets.only(bottom: 200),
                                              )
                                            ],
                                          );

                                        }(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ]),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  String getImagen(TipoRecursosUi? tipoRecursosUi){
    switch(tipoRecursosUi??TipoRecursosUi.TIPO_VINCULO){
      case TipoRecursosUi.TIPO_VIDEO:
        return AppImagen.archivo_video;
      case TipoRecursosUi.TIPO_VINCULO:
        return AppImagen.archivo_link;
      case TipoRecursosUi.TIPO_DOCUMENTO:
        return AppImagen.archivo_documento;
      case TipoRecursosUi.TIPO_IMAGEN:
        return AppImagen.archivo_imagen;
      case TipoRecursosUi.TIPO_AUDIO:
        return AppImagen.archivo_audio;
      case TipoRecursosUi.TIPO_HOJA_CALCULO:
        return AppImagen.archivo_hoja_calculo;
      case TipoRecursosUi.TIPO_DIAPOSITIVA:
        return AppImagen.archivo_diapositiva;
      case TipoRecursosUi.TIPO_PDF:
        return AppImagen.archivo_pdf;
      case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
        return AppImagen.archivo_youtube;
      case TipoRecursosUi.TIPO_VINCULO_DRIVE:
        return AppImagen.archivo_drive;
      case TipoRecursosUi.TIPO_RECURSO:
        return AppImagen.archivo_recurso;
      case TipoRecursosUi.TIPO_ENCUESTA:
        return AppImagen.archivo_recurso;
    }
  }

  String getDescripcion(TipoRecursosUi? tipoRecursosUi){
    switch(tipoRecursosUi??TipoRecursosUi.TIPO_VINCULO){
      case TipoRecursosUi.TIPO_VIDEO:
        return "Video";
      case TipoRecursosUi.TIPO_VINCULO:
        return "Link";
      case TipoRecursosUi.TIPO_DOCUMENTO:
        return "Documento";
      case TipoRecursosUi.TIPO_IMAGEN:
        return "Imagen";
      case TipoRecursosUi.TIPO_AUDIO:
        return "Audio";
      case TipoRecursosUi.TIPO_HOJA_CALCULO:
        return "Hoja cálculo";
      case TipoRecursosUi.TIPO_DIAPOSITIVA:
        return "Presentación";
      case TipoRecursosUi.TIPO_PDF:
        return "Documento Portátil";
      case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
        return "Youtube";
      case TipoRecursosUi.TIPO_VINCULO_DRIVE:
        return "Drive";
      case TipoRecursosUi.TIPO_RECURSO:
        return "Recurso";
      case TipoRecursosUi.TIPO_ENCUESTA:
        return "Recurso";
    }
  }

  Widget showTableRubroDetalle(PortalTareaController controller, TareaAlumnoUi? tareaAlumnoUi) {

    return SingleChildScrollView(
      child: StickyHeadersTableNotExpandedCustom(
        cellDimensions: CellDimensions.variableColumnWidth(
            stickyLegendHeight: 35,
            stickyLegendWidth: 110,
            contentCellHeight: 50,
            columnWidths: controller.tablecolumnWidths
        ),
        //cellAlignments: CellAlignments.,
        scrollControllers: ScrollControllers() ,
        columnsLength: controller.mapColumnList[tareaAlumnoUi]?.length??0,
        rowsLength: controller.mapRowList[tareaAlumnoUi]?.length??0,
        columnsTitleBuilder: (i) {
          dynamic o = controller.mapColumnList[tareaAlumnoUi]![i];
          if(o is EvaluacionUi){
            return Container(
                constraints: BoxConstraints.expand(),
                padding: EdgeInsets.all(8),
                child: Center(
                  child:  RotatedBox(
                    quarterTurns: -1,
                    child: Text(" ", textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11,color: AppTheme.darkText ),),
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppTheme.greyLighten2),
                      right: BorderSide(color: AppTheme.greyLighten2),
                    ),
                    color: AppTheme.red
                )
            );
          }else if(o is ValorTipoNotaUi){
            return InkWell(
              onDoubleTap: () =>  controller.onClicClearEvaluacionAll(o, tareaAlumnoUi),
              onLongPress: () =>  controller.onClicEvaluacionAll(o, tareaAlumnoUi),
              child: Stack(
                children: [
                  _getTipoNotaCabeceraV2(o, controller)
                ],
              ),
            );
          }else if(o is RubricaEvaluacionFormulaPesoUi){
            return Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: AppTheme.greyLighten2.withOpacity(0.5),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(8))
                    )
                ),
                Container(
                    child: Center(
                      child: Text('%', style: TextStyle(color: AppTheme.darkerText, fontSize: 14),),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: AppTheme.greyLighten2),
                      ),
                    )
                ),

              ],
            );
          }else
            return Container();
        },
        rowsTitleBuilder: (i) {
          RubricaEvaluacionUi rubricaEvaluacionUi = controller.mapRowList[tareaAlumnoUi]![i];
          return  Container(
              constraints: BoxConstraints.expand(),
              padding: EdgeInsets.only(left: 8, right: 8, bottom: 4, top: 2),
              child: Center(
                  child: Text(rubricaEvaluacionUi.titulo??"",
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 10,
                        color:  AppTheme.colorAccent,
                        height: 1.2
                    ),
                  )
              ),
              decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.greyLighten2),
                    right: BorderSide(color: AppTheme.greyLighten2),
                    left: BorderSide(color: AppTheme.greyLighten2),
                    bottom: BorderSide(color: AppTheme.greyLighten2.withOpacity((controller.mapRowList[tareaAlumnoUi]?.length??0)-1 == i?1:0)),
                  ),
                  color: AppTheme.white
              )
          );
        },
        contentCellBuilder: (i, j){
          dynamic o = controller.mapCellListList[tareaAlumnoUi]![j][i];
          if(o is EvaluacionRubricaValorTipoNotaUi){
            return InkWell(
              onTap: () {

                if(o.evaluacionUi?.personaUi?.contratoVigente??false){
                  if(o.valorTipoNotaUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_NUMERICO)
                    showDialogPresicion(controller, o, i, tareaAlumnoUi);
                  else
                    controller.onClicEvaluar(o, tareaAlumnoUi);
                }else{
                  _showControNoVigente(context, tareaAlumnoUi?.personaUi);
                }

              },
              child: Stack(
                children: [
                  _getTipoNotaV2(o, controller, controller.mapCellListList[tareaAlumnoUi]?.length,i, j),
                  
                ],
              ),
            );
          }else if(o is EvaluacionUi){
            return InkWell(
              //onTap: () => _evaluacionCapacidadRetornar(context, controller, o),
              child: Stack(
                children: [
                  Container(
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppTheme.greyLighten2),
                          right: BorderSide(color:  AppTheme.greyLighten2),
                          bottom:  BorderSide(color:  AppTheme.greyLighten2.withOpacity((controller.mapCellListList[tareaAlumnoUi]!.length-1) <= j ? 1:0)),
                        ),
                        color: _getColorAlumnoBloqueados(o.personaUi, 0)
                    ),
                    //child: _getTipoNota(o.valorTipoNotaUi, o.nota, i),
                  ),
                  
                ],
              ),
            );
          }else if(o is RubricaEvaluacionFormulaPesoUi){
            return InkWell(
              //onTap: () => _evaluacionCapacidadRetornar(context, controller, o),
              child: Stack(
                children: [
                  Container(
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppTheme.greyLighten2),
                          right: BorderSide(color:  AppTheme.greyLighten2),
                          bottom:  BorderSide(color:  AppTheme.greyLighten2.withOpacity((controller.mapCellListList[tareaAlumnoUi]!.length-1) <= j ? 1:0)),
                        ),
                        color: AppTheme.white
                    ),
                    child: Center(
                      child: Text("${(o.formula_peso).toStringAsFixed(0)}%",
                        textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11,color:  AppTheme.greyDarken1 ),
                      ),
                    ),
                  ),
                  
                ],
              ),
            );
          }else
            return Container();
        },
        legendCell: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: AppTheme.colorPrimary,
                )
            ),
            Container(
                child: Center(
                  child: Text('Indicadores', style: TextStyle(color: AppTheme.white, fontSize: 11),),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: AppTheme.colorPrimary),
                  ),
                )
            ),

          ],
        ),
      ),
    );

  }

  Widget _getTipoNotaCabeceraV2(ValorTipoNotaUi? valorTipoNotaUi,PortalTareaController controller) {
    Widget? nota = null;
    Color color_fondo;
    Color? color_texto;
    int position = 0;

    for(ValorTipoNotaUi item in valorTipoNotaUi?.tipoNotaUi?.valorTipoNotaList??[]){
      position++;
      if(valorTipoNotaUi?.valorTipoNotaId == item.valorTipoNotaId)break;
    }

    if(position == 1){
      color_fondo = HexColor("#1976d2");
      color_texto = AppTheme.white;
    }else if(position == 2){
      color_fondo =  HexColor("#388e3c");
      color_texto = AppTheme.white;
    }else if(position == 3){
      color_fondo =  HexColor("#FF6D00");
      color_texto = AppTheme.white;
    }else if(position == 4){
      color_fondo =  HexColor("#D32F2F");
      color_texto = AppTheme.white;
    }else{
      color_fondo =  AppTheme.greyLighten2;
      color_texto = null;//defaul
    }

    var ver_detalle = false;
    //if(valorTipoNotaUi?.tipoNotaUi?.intervalo??false)
    ver_detalle = controller.precision;

    switch(valorTipoNotaUi?.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO) {
      case TipoNotaTiposUi.SELECTOR_VALORES:
        nota = Container(
          child: Center(
            child: Text(valorTipoNotaUi?.titulo ?? "",
                style: TextStyle(
                    fontFamily: AppTheme.fontTTNormsMedium,
                    fontSize: 12,
                    color: color_texto
                )),
          ),
        );
        break;
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        nota = Container(
          width: ver_detalle?20:25,
          height: ver_detalle?20:25,
          child: CachedNetworkImage(
            imageUrl: valorTipoNotaUi?.icono ?? "",
            placeholder: (context, url) => Stack(
              children: [
                CircularProgressIndicator()
              ],
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        );
        break;
      default:
        break;
    }

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: color_fondo),
          right: BorderSide(color:  color_fondo),
        ),
        color: color_fondo,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          nota??Container(),
          if(ver_detalle)
            Container(
              margin: EdgeInsets.only(top: 4),
              child: Text("${valorTipoNotaUi?.valorNumerico?.toStringAsFixed(1)??"-"}", style: TextStyle(
                  fontFamily: AppTheme.fontTTNormsMedium,
                  fontSize: 14,
                  color: color_texto
              ),),
            )
        ],
      ),
    );
  }

  Color _getColorAlumnoBloqueados(PersonaUi? personaUi, int intenciadad, {Color c_default = Colors.white}) {
    if(!(personaUi?.contratoVigente??false)){
      if(intenciadad == 0){
        return AppTheme.redLighten4;
      }else  if(intenciadad == 1){
        return AppTheme.redLighten3;
      }else  if(intenciadad == 2){
        return AppTheme.redLighten2;
      }else{
        return AppTheme.redLighten4;
      }
    }else if((personaUi?.soloApareceEnElCurso??false)){
      if(intenciadad == 0){
        return AppTheme.deepOrangeLighten4;
      }else  if(intenciadad == 1){
        return AppTheme.deepOrangeLighten3;
      }else  if(intenciadad == 2){
        return AppTheme.deepOrangeLighten2;
      }else{
        return AppTheme.deepOrangeLighten4;
      }
    }else{
      return c_default;
    }
  }

  Widget _getTipoNotaV2(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, PortalTareaController controller,int? length ,int positionX, int positionY) {
    Widget? widget = null;

    Color color_fondo;
    Color? color_texto;
    Color color_borde;

    if(positionX == 0){
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#1976d2");
        color_texto = AppTheme.white;
        color_borde = HexColor("#1976d2");
      }else{
        color_fondo = AppTheme.white;
        color_texto = HexColor("#1976d2");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 1){
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#388e3c");
        color_texto = AppTheme.white;
        color_borde = HexColor("#388e3c");
      }else{
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#388e3c");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 2){
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#FF6D00");
        color_texto = AppTheme.white;
        color_borde = HexColor("#FF6D00");
      }else{
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#FF6D00");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 3){
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#D32F2F");
        color_texto = AppTheme.white;
        color_borde = HexColor("#D32F2F");
      }else {
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#D32F2F");
        color_borde = AppTheme.greyLighten2;
      }
    }else{
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = AppTheme.greyLighten2;
        color_texto =  null;
        color_borde = AppTheme.greyLighten2;
      }else{
        color_fondo = AppTheme.white;
        color_texto = null;
        color_borde = AppTheme.greyLighten2;
      }
    }

    color_fondo = color_fondo.withOpacity(0.8);
    color_borde = AppTheme.greyLighten2.withOpacity(0.8);

    var tipo =TipoNotaTiposUi.VALOR_NUMERICO;
    if(!controller.precision) tipo = evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO;
    switch(tipo){
      case TipoNotaTiposUi.SELECTOR_VALORES:
        widget = Center(
          child: Text(evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.titulo??"",
              style: TextStyle(
                  fontFamily: AppTheme.fontTTNormsMedium,
                  fontSize: 11,
                  color: color_texto
              )),
        );
        break;
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        widget = Opacity(
          opacity: (evaluacionRubricaValorTipoNotaUi.toggle??false)? 1 : 0.5,
          child: Container(
            padding: EdgeInsets.all(4),
            child:  CachedNetworkImage(
              imageUrl: evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.icono??"",
              placeholder: (context, url) => Stack(
                children: [
                  CircularProgressIndicator()
                ],
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        );
        break;
      case TipoNotaTiposUi.VALOR_ASISTENCIA:
      case TipoNotaTiposUi.VALOR_NUMERICO:
      case TipoNotaTiposUi.SELECTOR_NUMERICO:
        double? nota = null;
        if(evaluacionRubricaValorTipoNotaUi.toggle??false)nota = evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota;
        else nota = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorNumerico;

        if(nota == 0){
          if(evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES ||
              evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
            if(evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.tipoNotaId == null){
              nota = null;
            }
          }
        }
        widget = Center(
          child: Text("${nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
              fontFamily: AppTheme.fontTTNormsMedium,
              fontSize: 14,
              color: color_texto
          ),),
        );;
        break;
    }

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.greyLighten2),
            right: BorderSide(color:  color_borde),
            bottom:  BorderSide(color:  AppTheme.greyLighten2.withOpacity(((length??0)-1) <= positionY ? 1:0)),
          ),
          color: (evaluacionRubricaValorTipoNotaUi.toggle??false)?color_fondo:_getColorAlumnoBloqueados(evaluacionRubricaValorTipoNotaUi.evaluacionUi?.personaUi, 0)
      ),
      child: widget,
    );

  }

  void showDialogPresicion(PortalTareaController controller, EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, int position, TareaAlumnoUi? tareaAlumnoUi) {

    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return PresicionView(
            valorTipoNotaUi: evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi,
            color: getPosition(position),
            personaUi: evaluacionRubricaValorTipoNotaUi.evaluacionUi?.personaUi,
            onSaveInput: (nota) {

              Navigator.pop(context, nota);
            },
            onCloseButton: () {
              Navigator.pop(context, null);
            },
          );
        })
        .then((nota){
      if(nota != null){
        controller.onClicEvaluarPresicion(evaluacionRubricaValorTipoNotaUi, tareaAlumnoUi, nota);
      }
    });
  }

  Future<bool?> _showControNoVigente(BuildContext context, PersonaUi? personaUi) async {
    return await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation) {
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
                            width: 50,
                            height: 50,
                            child: Icon(Icons.supervised_user_circle, size: 35, color: AppTheme.white,),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.colorAccent),
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("Contrato no vigente", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppTheme.fontTTNormsMedium
                                  ),),
                                  Padding(padding: EdgeInsets.all(8),),
                                  Text("El Contrato de ${personaUi?.nombreCompleto??""} no esta vigente.",
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
                              child: Container()
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: AppTheme.colorAccent,
                              onPrimary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Salir'),
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              )
          );
        },
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.transparent,
        transitionDuration:
        const Duration(milliseconds: 150));
  }
  Color getPosition(int position){
    if(position == 1){
      return HexColor("#1976d2");
    }else if(position == 2){
      return  HexColor("#388e3c");
    }else if(position == 3){
      return   HexColor("#FF6D00");
    }else if(position == 4){
      return  HexColor("#D32F2F");
    }else{
      return  AppTheme.greyLighten2;
    }
  }


  void comprobarConexion(PortalTareaController controller) {
    if (!mounted) {
      return;
    }

    if(_connectionStatusValidate != _connectionStatus && !controller.progressEvalTarea){
      WidgetsBinding.instance?.addPostFrameCallback((_){
        controller.hayCambioEnLaConexion();
      });
    }
    _connectionStatusValidate = _connectionStatus;
  }

  void abrirRubrica(PortalTareaController controller){
    if(controller.abrirRubrica){
      if (mounted) {
        WidgetsBinding.instance?.addPostFrameCallback((_) async{
          if((controller.rubricaEvalUI?.cantidadRubroDetalle??0) > 1){
            dynamic response = await AppRouter.createRouteEvaluacionMultiple(context, controller.calendarioPeriodoUI,controller.cursosUi, controller.rubricaEvalUI?.rubroEvaluacionId);
            if(response == -1){
              controller.seEliminoEvaluacion();
            }else if(response is int){
              controller.cambioEvaluacion();
            }
          }else{
            dynamic response = await AppRouter.createRouteEvaluacionSimple(context, controller.cursosUi, controller.rubricaEvalUI, controller.calendarioPeriodoUI);
            if(response == -1){
              controller.seEliminoEvaluacion();
            }else if(response is int){
              controller.cambioEvaluacion();
            }

          }
        });
      }

    }
    controller.celearAbrirRubrica();
  }

  Widget getViewTareaAlumno(PortalTareaController controller,List<TareaAlumnoUi> tareaAlumnoUiList,double padding_left, double padding_right, double width_table, double width){

    return Container(
      width: width,
      child: ListView.builder(
        padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16 + 2)),
        primary: false,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){

          TareaAlumnoUi tareaAlumnoUi = tareaAlumnoUiList[index];
          print("tareaAlumnoUi success ${tareaAlumnoUi.success }");

          if(evaluadoKeyMap[tareaAlumnoUi] == null){
            evaluadoKeyMap[tareaAlumnoUi] = GlobalKey();
          }

          return Column(
            key: evaluadoKeyMap[tareaAlumnoUi],
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: padding_left,
                    right: padding_right
                ),
                child: InkWell(
                  onTap: (){
                    controller.onClickTareaAlumno(tareaAlumnoUi);
                  },
                  child: Container(
                    padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4 + 4)),
                    color: HexColor(controller.cursosUi?.color2).withOpacity(0.1),
                    child: Row(
                      children: [
                        Container(
                          color: HexColor(controller.cursosUi?.color2).withOpacity(0.1),
                          child: Icon( tareaAlumnoUi.toogle??false?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
                              size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 20 + 2),
                              color: HexColor(controller.cursosUi?.color1)
                          ),
                        ),
                        Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4 + 2)),
                              child: Text("${(tareaAlumnoUi.personaUi?.nombreCompleto??"").toUpperCase()}",
                                style: TextStyle(color: HexColor(controller.cursosUi?.color1),
                                    fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 10 + 2),
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            )
                        ),
                        (tareaAlumnoUi.entregado??false)?
                        Container(
                          padding: EdgeInsets.only(left: 4 , right: 4, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(2)),
                              color: HexColor(controller.cursosUi?.color2)
                          ),
                          alignment: Alignment.center,
                          child: Text((tareaAlumnoUi.entregado_retraso??false) ? "Entregado\ncon retrazo": "Entregado",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color:AppTheme.white,
                                fontSize: 10,
                              )),
                        ):Container(),
                        Padding(padding: EdgeInsets.all(4)),
                        (((tareaAlumnoUi.valorTipoNotaId??"").isNotEmpty
                            && controller.rubricaEvalUI != null))
                            || tareaAlumnoUi.success == -1 || tareaAlumnoUi.success == 1?
                        Container(
                          padding: EdgeInsets.only(left: 4 , right: 4, top: 4, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(2)),
                              color: HexColor(controller.cursosUi?.color2)
                          ),
                          alignment: Alignment.center,
                          child: Text("${tareaAlumnoUi.success == 1? "Guardando": tareaAlumnoUi.success == -1?"Error al\nguardar":"Evaluado" }",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color:AppTheme.white,
                                fontSize: 10,
                              )),
                        ):Container()
                      ],
                    ),
                  ),
                ),
              ),
              (tareaAlumnoUi.toogle??false)?
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: padding_left, right: padding_right),
                    height: 1,
                    color: HexColor(controller.cursosUi?.color1),
                  ),
                  if(controller.rubricaEvalUI != null)
                    Container(
                        child:
                        !controller.progressRubro?
                        Container(
                          margin: EdgeInsets.only(top:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16 + 4),),
                          child: Center(
                            child: Container(
                                width: width_table,
                                padding: EdgeInsets.only(left: padding_left, right: padding_right),
                                child:  ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  child: showTableRubroDetalle(controller, tareaAlumnoUi),
                                )
                            ),
                          ),
                        ):
                        Shimmer.fromColors(
                          baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                          highlightColor: Color.fromRGBO(166, 166, 166, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only( topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              color: HexColor(controller.cursosUi?.color1),
                            ),
                            margin: EdgeInsets.only(top:  16, left: 24, right: 24),
                            height: 80,
                            width: 230,
                          )
                          ,
                        )
                    ),
                  Container(
                    child: Container(
                      width: width,
                      child:  ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 0),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: tareaAlumnoUi.archivos?.length??0,
                          itemBuilder: (context, index){
                            TareaAlumnoArchivoUi tareaAlumnoArchivoUi = tareaAlumnoUi.archivos![index];
                            return  Stack(
                              children: [
                                Container(
                                  child: InkWell(
                                    onTap: (){
                                      if(!(tareaAlumnoArchivoUi.upload??false)){
                                        controller.onClickTareaArchivoAlumno(tareaAlumnoArchivoUi);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8), // use instead of BorderRadius.all(Radius.circular(20))
                                        border:  Border.all(
                                            width: 1,
                                            color: AppTheme.greyLighten1
                                        ),
                                        color: AppTheme.greyLighten2,
                                      ),
                                      margin: EdgeInsets.only(top: 16, left: padding_left + 8, right: padding_right + 8),
                                      width: 450,
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(7)),
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    child: Center(
                                                      child: Image.asset(getImagen(tareaAlumnoArchivoUi.tipoRecurso),
                                                        height: 30.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      color: AppTheme.white,
                                                      padding: EdgeInsets.only(left:16, top: 8, bottom: 8, right: 8),
                                                      child:  Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("${tareaAlumnoArchivoUi.nombre??""}", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppTheme.greyDarken3, fontSize: 11),),
                                                          Padding(padding: EdgeInsets.all(2)),
                                                          (tareaAlumnoArchivoUi.repositorio??false)?
                                                          Text("${getDescripcion(tareaAlumnoArchivoUi.tipoRecurso)}", maxLines: 1, overflow: TextOverflow.ellipsis ,style: TextStyle(color: AppTheme.grey, fontSize: 9)):
                                                          Text("${tareaAlumnoArchivoUi.url??""}", maxLines: 1, overflow: TextOverflow.ellipsis ,style: TextStyle(color: AppTheme.blue, fontSize: 9))
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                          tareaAlumnoArchivoUi.upload??false?
                                          Positioned(
                                            child: SizedBox(
                                              child: Shimmer.fromColors(
                                                baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                                highlightColor: Color.fromRGBO(166, 166, 166, 1.0),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                                  child: Container(
                                                    color: AppTheme.greyDarken1.withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            top: 0,
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                          ):
                                          Container()
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: padding_left, right: padding_right),
                    margin: EdgeInsets.only(top:  16),
                    alignment: Alignment.centerLeft,
                    child: Text("Comentarios privados (Sólo los ve le foto_alumno)", style: TextStyle(color: AppTheme.colorPrimary, fontSize: 10),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top:  4, bottom: 4),
                    padding: EdgeInsets.only(left: padding_left, right: padding_right),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(),
                          ),
                          imageUrl: controller.usuarioUi?.personaUi?.foto??"",
                          errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                          imageBuilder: (context, imageProvider) =>
                              Container(
                                  width: 40,
                                  height: 40,
                                  margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 65,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.greyLighten3,
                                            borderRadius: BorderRadius.circular(8.0),
                                            border: Border.all(color: AppTheme.greyLighten2),
                                          ),
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: TextField(
                                                  maxLines: null,
                                                  keyboardType: TextInputType.multiline,
                                                  style: TextStyle(
                                                    fontSize: 12,

                                                  ),
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                                                      hintText: "",
                                                      border: InputBorder.none),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              IconButton(
                                onPressed: () {
                                  // You enter here what you want the button to do once the user interacts with it
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: AppTheme.greyDarken1,
                                ),
                                iconSize: 20.0,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  false?
                  Container(
                    margin: EdgeInsets.only(top:  0, bottom: 16),
                    padding: EdgeInsets.only(left: padding_left, right: padding_right),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(),
                          ),
                          imageUrl: "https://cdn.domestika.org/c_fill,dpr_1.0,f_auto,h_1200,pg_1,t_base_params,w_1200/v1589759117/project-covers/000/721/921/721921-original.png?1589759117",
                          errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                          imageBuilder: (context, imageProvider) =>
                              Container(
                                  width: 40,
                                  height: 40,
                                  margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.greyLighten3,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: AppTheme.greyLighten2),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Container(
                                            padding: EdgeInsets.only(right: 8),
                                            child: Text("Velasquez Vilma Gregoria",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700
                                                ))
                                        )
                                    ),
                                    Text("Vie 03 de set. - 13:37",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: AppTheme.greyDarken1
                                        )
                                    ),
                                  ],
                                ),
                                Padding(padding: EdgeInsets.all(2)),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Miss mil disculpas no cargo el video por eso lo enviamos al whassap", style: TextStyle(fontSize: 10),),
                                ),
                                Padding(padding: EdgeInsets.all(2)),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Responder",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: AppTheme.greyDarken1
                                      )
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ):Container(),
                  Padding(padding: EdgeInsets.only(bottom: 8))
                ],
              ):Container(padding: EdgeInsets.only(bottom:  ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8 + 6)),)
            ],
          );
        },
        itemCount: tareaAlumnoUiList.length,
      ),
    );
  }

  void abrirTareaAlumnoArchivosConDrive(PortalTareaController controller) async{

    if(controller.abrirTareaAlumnoArchivo!=null){
      switch(controller.abrirTareaAlumnoArchivo?.tipoRecurso){
        case TipoRecursosUi.TIPO_DOCUMENTO:
        case TipoRecursosUi.TIPO_IMAGEN:
        case TipoRecursosUi.TIPO_AUDIO:
        case TipoRecursosUi.TIPO_HOJA_CALCULO:
        case TipoRecursosUi.TIPO_DIAPOSITIVA:
        case TipoRecursosUi.TIPO_PDF:
        case TipoRecursosUi.TIPO_VINCULO:
          await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(controller.abrirTareaAlumnoArchivo?.driveId), webview: false);
          break;
        case TipoRecursosUi.TIPO_ENCUESTA:
          await AppUrlLauncher.openLink(controller.abrirTareaAlumnoArchivo?.url, webview: false);
          break;
        case TipoRecursosUi.TIPO_VINCULO_DRIVE:
        //await AppUrlLauncher.openLink(tareaRecursoUi.url, webview: false);
          await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(controller.abrirTareaAlumnoArchivo?.driveId), webview: false);
          break;
        case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
          TareaMultimediaView.showDialog(context, YouTubeUrlParser.getYoutubeVideoId(controller.abrirTareaAlumnoArchivo?.url), TareaMultimediaTipoArchivo.YOUTUBE);
          break;
        case TipoRecursosUi.TIPO_RECURSO:
        //await AppUrlLauncher.openLink(tareaRecursoUi.url, webview: false);

          break;
        default:
          await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(controller.abrirTareaAlumnoArchivo?.driveId), webview: false);
          break;
      }
    }
    controller.clearAbrirTareaAlumnoArchivosConDrive();
  }

  Widget buildFloatingSearchBar(BuildContext context, PortalTareaController controller){
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      child: FloatingSearchBar(
        hint: 'Buscar foto_alumno...',
        autocorrect: true,
        controller: floatingSearchBarController,
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        onFocusChanged: (focus){
          if(!focus){
            floatingSearchBarController.close();
            //floatingSearchBarController.hide();
            Future.delayed(const Duration(milliseconds: 900), () {
              if(floatingSearchBarController.isVisible){
                controller.onClickMostrarBuscador();
              }
            });

          }
        },
        physics: BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        elevation: 0,
        margins: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 24,
            left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16),
            right:ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 16)
        ),
        debounceDelay: const Duration(milliseconds: 500),
        automaticallyImplyBackButton: false,
        leadingActions: [
          FloatingSearchBarAction(
            showIfClosed: false,
            showIfOpened: true,
            child: CircularButton(
              icon: Icon(Icons.search),
              onPressed: () {

              },
            ),
          ),
          FloatingSearchBarAction(
            showIfClosed: true,
            showIfOpened: false,
            builder: (context, animation) {
              final canPop = Navigator.canPop(context);
              return CircularButton(
                tooltip: 'Back',
                size: 24,
                icon: Icon(Icons.arrow_back, size: 24),
                onPressed: () {
                  final bar = FloatingSearchAppBar.of(context)!;
                  if (bar.isOpen && !bar.isAlwaysOpened) {
                    bar.close();
                  } else if (canPop) {
                    //Navigator.pop(context);
                  }
                },
              );
            },
          )
        ],
        progress: false,
        automaticallyImplyDrawerHamburger: false,
        onQueryChanged: (query) {
          // Call your model, bloc, controller here.
          print("onQueryChanged ${query}");
          controller.onChangeText(query);
          if(query.isEmpty){
            filteredUsers = null;
          }else{
            filteredUsers = controller.tareaAlumnoUiList
                .where((u){
              return u.personaUi?.nombreCompleto?.toLowerCase().contains(query.toLowerCase())??false;
            }).toList();
          }
        },
        // Specify a custom transition to be used for
        // animating between opened and closed stated.
        transition: CircularFloatingSearchBarTransition(),
        actions: [
          /*FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: Icon(Icons.place),
              onPressed: () {},
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),*/
          FloatingSearchBarAction(
            showIfClosed: false,
            showIfOpened: true,
            builder: (context, animation) {
              final canPop = Navigator.canPop(context);
              return TextButton(
                  onPressed: (){
                    final bar = FloatingSearchAppBar.of(context)!;
                    if (bar.isOpen && !bar.isAlwaysOpened) {
                      bar.close();
                    } else if (canPop) {
                      //Navigator.pop(context);
                    }
                  },
                  child: Text("Cerrar")
              );

            },
          )
        ],
        onSubmitted: (texto){
          print("onSubmitted ${texto}");

        },
        builder: (context, transition) {
          print("builder ${transition}");
          return (controller.alumnoFiltro??"").isEmpty?
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              controller.mostrarDosListasAlumnos?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("- Lista de evaluados".toUpperCase(),
                        style: TextStyle(
                            color: AppTheme.white,
                            fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 10 + 4),
                            fontWeight: FontWeight.w500
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8)),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Material(
                        color: Colors.white,
                        elevation: 4.0,
                        child: ListView.separated(
                          itemCount: controller.tareaAlumnoUiEvaluadosList.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 0),
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, __) => Divider(height: 1),
                          itemBuilder: (_, index){
                            TareaAlumnoUi tareaAlumnoUi = controller.tareaAlumnoUiEvaluadosList[index];
                            return getItemSearchAlumno(tareaAlumnoUi, controller);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 24)),
                    ),
                    Text("- Lista de no evaluados".toUpperCase(),
                        style: TextStyle(
                            color: AppTheme.white,
                            fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 10 + 4),
                            fontWeight: FontWeight.w500
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 8)),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Material(
                        color: Colors.white,
                        elevation: 4.0,
                        child: ListView.separated(
                          itemCount: controller.tareaAlumnoUiNoEvaluadosList.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 0),
                          physics: NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, __) => Divider(height: 1),
                          itemBuilder: (_, index){
                            TareaAlumnoUi tareaAlumnoUi = controller.tareaAlumnoUiNoEvaluadosList[index];
                            return getItemSearchAlumno(tareaAlumnoUi, controller);
                          },
                        ),
                      ),
                    ),
                  ],
                ):
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Colors.white,
                  elevation: 4.0,
                  child: ListView.separated(
                    itemCount: controller.tareaAlumnoUiList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 0),
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => Divider(height: 1),
                    itemBuilder: (_, index){
                      TareaAlumnoUi tareaAlumnoUi = controller.tareaAlumnoUiList[index];
                      return getItemSearchAlumno(tareaAlumnoUi, controller);
                    },
                  ),
                ),
              ),
            ],
          ):
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              child: ListView.separated(
                itemCount: filteredUsers!=null? filteredUsers?.length??0 :controller.tareaAlumnoUiList.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 0),
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => Divider(height: 1),
                itemBuilder: (_, index){
                  TareaAlumnoUi tareaAlumnoUi = filteredUsers!=null?filteredUsers![index]: controller.tareaAlumnoUiList[index];
                  return getItemSearchAlumno(tareaAlumnoUi, controller);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void onMostrarBuscador() {
    Future.delayed(Duration(milliseconds: 200), () {
      //floatingSearchBarController.show();
      floatingSearchBarController.open();
    });
  }

  Widget getItemSearchAlumno(TareaAlumnoUi tareaAlumnoUi, PortalTareaController controller){
    return InkWell(
      onTap: (){
        final targetContext = evaluadoKeyMap[tareaAlumnoUi]?.currentContext;
        if (targetContext != null) {
          Scrollable.ensureVisible(
            targetContext,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
        floatingSearchBarController.close();
        controller.onClickSearchAlumno(tareaAlumnoUi);
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              placeholder: (context, url) => Container(
                child: Center(child: CircularProgressIndicator(),),
              ),
              imageUrl: tareaAlumnoUi.personaUi?.foto??"",
              errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 25,),
              imageBuilder: (context, imageProvider) =>
                  Container(
                      width: 25,
                      height: 25,
                      margin: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      )
                  ),
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((tareaAlumnoUi.personaUi?.apellidos??""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 13),
                            color: AppTheme.darkerText,
                            fontWeight: FontWeight.w700
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 4)),
                    ),
                    Text((tareaAlumnoUi.personaUi?.nombres??""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context, 12),
                          color: AppTheme.darkerText,
                        )
                    )
                  ],
                )
            ),
            (tareaAlumnoUi.entregado??false)?
            Container(
              padding: EdgeInsets.only(right: 16),
              child: Text((tareaAlumnoUi.entregado_retraso??false) ? "Entregado\ncon retrazo": "Entregado",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.darkerText,
                    fontSize: 10,
                  )
              ),
            ):
            Container(),
          ],
        ),
      ),
    );
  }
}
