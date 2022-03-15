import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/libs/flutterOffline/src/main.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/lista/sesion_lista_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/utils/tipo_sesion.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/progress_bar.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_calendario_periodo_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_unidad_sesion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_firebase_sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';

class SesionListaView extends View{
  CursosUi? cursosUi;
  UsuarioUi? usuarioUi;
  SesionListaView(this.cursosUi, this.usuarioUi);

  @override
  _CursoListaViewState createState() => _CursoListaViewState(cursosUi, usuarioUi);

}

class _CursoListaViewState extends ViewState<SesionListaView, SesionListaController> with TickerProviderStateMixin{

  Function(bool connected)? _onChangeConnected;
  bool? _connected;

  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  Function()? statetDialogSesion;

  _CursoListaViewState(cursoUi, usuarioUi) : super(SesionListaController(usuarioUi, cursoUi, MoorConfiguracionRepository(), MoorCalendarioPeriodoRepository(), DeviceHttpDatosRepositorio(), MoorUnidadSesionRepository()));

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
  void dispose() {
    super.dispose();
  }

  Widget get view => ControlledWidgetBuilder<SesionListaController>(
      builder: (context, controller) {

        SchedulerBinding.instance?.addPostFrameCallback((_) {
          if(controller.showRealizarSesion){
            _showRealizarSesion(context, controller);
            controller.successShowRealizarSesion();
          }
        });

        return Scaffold(
          extendBody: true,
          backgroundColor: AppTheme.background,
          body: OfflineBuilder(
            connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
                ){
              bool connected = connectivity != ConnectivityResult.none;
              if(_connected!=null && connected != _connected){
                _onChangeConnected?.call(connected);
                if (mounted) {
                  WidgetsBinding.instance?.addPostFrameCallback((_){
                    controller.changeConnected(connected);
                  });
                }

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
              children: [
                getMainTab(),
                getAppBarUI(),
                if(controller.progressDocente)
                  ArsProgressWidget(
                    blur: 2,
                    backgroundColor: Color(0x33000000),
                    animationDuration: Duration(milliseconds: 500),
                  ),
              ],
            ),
          ),
        );
      }
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
                  color: AppTheme.grey
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
                child: ControlledWidgetBuilder<SesionListaController>(
                  builder: (context, controller) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                            child:  IconButton(
                              icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                              onPressed: () {
                                Navigator.of(this.context).pop();
                              },
                            )
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 1, bottom: 8, left: 8, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppIcon.ic_curso_sesion, height: 35 +  6 - 8 * topBarOpacity, width: 35 +  6 - 8 * topBarOpacity,),
                              Padding(
                                padding: EdgeInsets.only(left: 12, top: 8),
                                child: Text(
                                  'Sesiones',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontTTNorms,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 0.8,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
    return ControlledWidgetBuilder<SesionListaController>(
        builder: (context, controller) {

          var widthDp = context.widthPx;
          int countTareaRow;
          if (widthDp >= 800) {
            countTareaRow = 4;
          }if (widthDp >= 600) {
            countTareaRow = 3;
          } else if (widthDp >= 480) {
            countTareaRow = 2;
          } else {
            countTareaRow = 1;
          }

          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top +
                        0,
                    left: 0,//24
                    right: 0//16
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 40),
                  child: Stack(
                    children: [
                      controller.calendarioPeriodoUI==null||(controller.calendarioPeriodoUI??0)==0?
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
                          ),
                          Padding(padding: EdgeInsets.all(4)),
                          Center(
                            child: Text("Selecciona un bimestre o trimestre", style: TextStyle(color: AppTheme.grey, fontStyle: FontStyle.italic, fontSize: 12),),
                          )
                        ],
                      ):
                      controller.unidadUiDocenteList.isEmpty?
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
                          ),
                          Padding(padding: EdgeInsets.all(4)),
                          Center(
                            child: Text("Lista vacía${!controller.conexion?", revice su conexión a internet":""}", style: TextStyle(color: AppTheme.grey, fontStyle: FontStyle.italic, fontSize: 12),),
                          )
                        ],
                      ):Container(),
                      SingleChildScrollView(
                        physics: ScrollPhysics(),
                        controller: scrollController,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.unidadUiDocenteList.length,
                          itemBuilder: (BuildContext ctxt, int index){
                            UnidadUi unidadUi =  controller.unidadUiDocenteList[index];
                            List<dynamic> unidadItemList = controller.unidadItemsMap[unidadUi]??[];
                            int cant_sesiones = unidadItemList.length;
                            int columnas = ColumnCountProvider.columnsForWidthSesion(context);
                            bool toogle = unidadUi.toogle??false;
                            int cant_reducida = columnas * 2;
                            bool isVisibleVerMas = cant_reducida < cant_sesiones;
                            if(unidadUi.cantUnidades == 1){
                              isVisibleVerMas = false;
                            }

                            int cant_lista;
                            if(toogle){
                              if(isVisibleVerMas){

                              }
                              cant_lista = cant_sesiones;
                            }else{
                              if(isVisibleVerMas){
                                cant_lista = cant_reducida;
                              }else{
                                cant_lista = cant_sesiones;
                              }
                            }

                            return Container(
                              margin: EdgeInsets.only(
                                bottom: controller.unidadUiDocenteList.length == index + 1 ?
                                ColumnCountProvider.aspectRatioForWidthSesion(context, 70):
                                ColumnCountProvider.aspectRatioForWidthSesion(context, 30),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthSesion(context, 8))),
                                              color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                                            ),
                                            margin: EdgeInsets.only(
                                                top: ColumnCountProvider.aspectRatioForWidthSesion(context, 8),
                                                bottom: ColumnCountProvider.aspectRatioForWidthSesion(context, 20)
                                            ),
                                            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthSesion(context, 16)),
                                            child: Text("U${unidadUi.nroUnidad??""}: ${unidadUi.titulo??""}",
                                              style: TextStyle(
                                                  fontSize: ColumnCountProvider.aspectRatioForWidthSesion(context, 14),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: AppTheme.fontTTNorms
                                              ),
                                            ),
                                          ),
                                          cant_sesiones > 0?
                                          GridView.builder(
                                              padding: EdgeInsets.only(top: 0,
                                                  left: ColumnCountProvider.aspectRatioForWidthSesion(context, 8),
                                                  right: ColumnCountProvider.aspectRatioForWidthSesion(context, 16)
                                              ),
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: columnas,
                                                mainAxisSpacing: ColumnCountProvider.aspectRatioForWidthSesion(context, 24),
                                                crossAxisSpacing: ColumnCountProvider.aspectRatioForWidthSesion(context, 24),
                                              ),
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: cant_lista,
                                              itemBuilder: (context, index){
                                                dynamic o = unidadItemList[index];
                                                if(o is SesionUi){
                                                  return getViewItemSesion(unidadUi, o, controller);
                                                }else {
                                                  return InkWell(
                                                    onTap: () async{
                                                      //dynamic? result = await AppRouter.createRouteTareaCrearRouter(context,  controller.cursosUi, null, controller.calendarioPeriodoUI, unidadUi.unidadAprendizajeId, null);
                                                      //if(result is int) controller.refrescarListTarea(unidadUi);
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color: HexColor(controller.cursosUi.color2),
                                                        borderRadius: BorderRadius.circular(14), // use instead of BorderRadius.all(Radius.circular(20))
                                                      ),
                                                      child: FDottedLine(
                                                        color: AppTheme.white,
                                                        strokeWidth: 3.0,
                                                        dottedLength: 10.0,
                                                        space: 3.0,
                                                        corner: FDottedLineCorner.all(14.0),

                                                        /// add widget
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          child:  Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Icon(Ionicons.add, color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthTarea(context, 40),),
                                                              Padding(padding: EdgeInsets.only(top: 4)),
                                                              Text("Crear tarea",
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: ColumnCountProvider.aspectRatioForWidthTarea(context, 16),
                                                                    fontWeight: FontWeight.w700,
                                                                    letterSpacing: 0.5,
                                                                    color: AppTheme.white
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }

                                              }
                                          )
                                              :Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(14), // use instead of BorderRadius.all(Radius.circular(20))
                                            ),
                                            child: FDottedLine(
                                              color: AppTheme.white,
                                              strokeWidth: 3.0,
                                              dottedLength: 10.0,
                                              space: 3.0,
                                              corner: FDottedLineCorner.all(14.0),

                                              /// add widget
                                              child: Container(
                                                padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 16),
                                                alignment: Alignment.center,
                                                child: Text("Unidad sin sesiones",  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    color: AppTheme.white
                                                ),),
                                              ),
                                            ),
                                          )
                                        ]),
                                  ),
                                  if(isVisibleVerMas)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 8,
                                          right: 16
                                      ),
                                      child:  InkWell(
                                        onTap: (){
                                          controller.onClickVerMas(unidadUi);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 18),
                                          padding: EdgeInsets.all(10),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: AppTheme.white,
                                              borderRadius: BorderRadius.circular(14) // use instead of BorderRadius.all(Radius.circular(20))
                                          ),
                                          child: Center(
                                            child: Text("${toogle?"Ver solo las últimas sesiones":"Ver más sesiones"}",
                                                style: TextStyle(
                                                    color: AppTheme.black,
                                                    fontSize: 12,
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontWeight: FontWeight.w500)),
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: Container(
                  width: 32,
                  padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top +
                        0,
                  ),
                  child: Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.calendarioPeriodoList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                              child:Container(
                                margin: const EdgeInsets.only(top: 0, left: 8, right: 0, bottom: 0),
                                decoration: BoxDecoration(
                                  color: controller.cursosUi.color3!=null?HexColor(controller.cursosUi.color3):AppTheme.colorAccent,
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    bottomLeft:const Radius.circular(10.0),
                                  ),
                                ),
                                child: Container(
                                  height: 110,
                                  margin: const EdgeInsets.only(top: 1, left: 1, right: 1, bottom: 1),
                                  decoration: BoxDecoration(
                                    color:controller.calendarioPeriodoList[index].selected??false ? AppTheme.white: controller.cursosUi.color3!=null?HexColor(controller.cursosUi.color3):AppTheme.colorAccent,
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(10.0),
                                      bottomLeft:const Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      focusColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      borderRadius: const BorderRadius.all(Radius.circular(9.0)),
                                      splashColor: AppTheme.nearlyDarkBlue.withOpacity(0.8),
                                      onTap: () {
                                        controller.onSelectedCalendarioPeriodo(controller.calendarioPeriodoList[index]);
                                      },
                                      child: Center(
                                        child: RotatedBox(quarterTurns: 1,
                                            child: Text(controller.calendarioPeriodoList[index].nombre??"".toUpperCase(), style: TextStyle(color: controller.calendarioPeriodoList[index].selected??false ? (controller.cursosUi.color3!=null?HexColor(controller.cursosUi.color3):AppTheme.colorAccent): AppTheme.white, fontFamily: AppTheme.fontName, fontWeight: FontWeight.w600, fontSize: 9), )
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          );
                        }
                    ),
                  ),
                ),
              )
            ],
          );

        });
  }

  Widget progress(Widget widget){
    return FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return widget;
          }

        });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  Widget getViewItemSesion(UnidadUi unidadUi, SesionUi sesionUi, SesionListaController controller) {
    return InkWell(
      onTap: (){
        AppRouter.createRouteSesionPortalRouter(context, controller.usuarioUi, controller.cursosUi, unidadUi, sesionUi, controller.calendarioPeriodoUI);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthSesion(context, 14)) // use instead of BorderRadius.all(Radius.circular(20))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: ColumnCountProvider.aspectRatioForWidthSesion(context, 12),
                      right: ColumnCountProvider.aspectRatioForWidthSesion(context, 12),
                      top: ColumnCountProvider.aspectRatioForWidthSesion(context, 12),
                      bottom: 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text("Sesión ${sesionUi.nroSesion??0}",
                              style: TextStyle(
                                  color: AppTheme.black,
                                  fontFamily: AppTheme.fontTTNorms,
                                  fontSize: ColumnCountProvider.aspectRatioForWidthSesion(context, 12),
                                  fontWeight: FontWeight.w600
                              )
                          )
                      ),
                      Text(sesionUi.horas??"",
                          style: TextStyle(
                              fontFamily: AppTheme.fontTTNorms,
                              fontWeight: FontWeight.w600,
                            color: TipoSession(sesionUi.sesionEstado).color,
                            fontSize: ColumnCountProvider.aspectRatioForWidthSesion(context, 10)
                          )
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: ColumnCountProvider.aspectRatioForWidthSesion(context, 12),
                      right: ColumnCountProvider.aspectRatioForWidthSesion(context, 16),
                      top: ColumnCountProvider.aspectRatioForWidthSesion(context, 4),
                      bottom: 0
                  ),
                  child: Text(sesionUi.fechaEjecucion??"",
                      style: TextStyle(
                          fontFamily: AppTheme.fontTTNorms,
                          fontWeight: FontWeight.w600,
                        color: TipoSession(sesionUi.sesionEstado).color,
                        fontSize: ColumnCountProvider.aspectRatioForWidthSesion(context, 10)
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: ColumnCountProvider.aspectRatioForWidthSesion(context, 12),
                      right: ColumnCountProvider.aspectRatioForWidthSesion(context, 16),
                      top: ColumnCountProvider.aspectRatioForWidthSesion(context, 4),
                      bottom: 0
                  ),
                  child: Divider(
                    height: ColumnCountProvider.aspectRatioForWidthSesion(context, 2),
                    color: TipoSession(sesionUi.sesionEstado).color,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: ColumnCountProvider.aspectRatioForWidthSesion(context, 12),
                      right: ColumnCountProvider.aspectRatioForWidthSesion(context, 16),
                      top: ColumnCountProvider.aspectRatioForWidthSesion(context, 8),
                      bottom: 0),
                  child: Center(
                    child: Text(sesionUi.titulo??"",
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: AppTheme.fontTTNorms,
                          color: AppTheme.black,
                          fontSize: ColumnCountProvider.aspectRatioForWidthSesion(context, 11)
                      )
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: (){
                controller.showEvaluacionSesionesFirebase(sesionUi, unidadUi);
              },
              child: Container(
                margin: EdgeInsets.only(
                  bottom: ColumnCountProvider.aspectRatioForWidthSesion(context, 8),
                  right: ColumnCountProvider.aspectRatioForWidthSesion(context, 12),
                ),
                child: Material(
                  color: TipoSession(sesionUi.sesionEstado).color.withOpacity(0.8),
                  borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthSesion(context, 8))),
                  child: Container(
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthSesion(context, 7)) // use instead of BorderRadius.all(Radius.circular(20))
                    ),
                    child: Container(
                        padding: EdgeInsets.only(
                            top: ColumnCountProvider.aspectRatioForWidthSesion(context, 4),
                            left: ColumnCountProvider.aspectRatioForWidthSesion(context, 4),
                            bottom: ColumnCountProvider.aspectRatioForWidthSesion(context, 4),
                            right: ColumnCountProvider.aspectRatioForWidthSesion(context, 4)),
                        child: Text(TipoSession(sesionUi.sesionEstado).nombre,
                          style: TextStyle(
                              fontSize: ColumnCountProvider.aspectRatioForWidthSesion(context, 9),
                              color: TipoSession(sesionUi.sesionEstado).color.withOpacity(0.9),
                              fontFamily: AppTheme.fontTTNorms,
                              fontWeight: FontWeight.w700
                          ),)
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showRealizarSesion(BuildContext context, SesionListaController controller) async {
    void Function(VoidCallback fn)? refresh = null;
    dialogState(){
      refresh?.call((){});
    };
    controller.addListener(dialogState);
    return await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              refresh = setState;
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
                                child: Icon(Ionicons.checkbox_outline, size: 35, color: AppTheme.white,),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.colorSesion),
                              ),
                              Padding(padding: EdgeInsets.all(8)),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(padding: EdgeInsets.all(8),
                                        child: Text("Sesión realizada", style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: AppTheme.fontTTNormsMedium
                                        ),),
                                      ),
                                      Padding(padding: EdgeInsets.all(4),),
                                    ],
                                  )
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(4)),
                          Flexible(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(
                                  left: 8,
                                  right: 8
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ((controller.msgRealizarSesion??"").isNotEmpty)?
                                    Column(
                                      children: [
                                        Padding(padding: EdgeInsets.all(4),),
                                        Text("Error en la evaluación. Se desmarcaron los recursos que lo causaron, reintente otra vez.",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: AppTheme.fontTTNorms,
                                              color: AppTheme.red
                                          ),),
                                      ],
                                    ):Container(),
                                    Padding(padding: EdgeInsets.all(4),),
                                    Text("Al aceptar se procesarán los siguientes recursos:",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: AppTheme.fontTTNorms
                                      ),),
                                    (controller.progressFirebase)?
                                    Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ):
                                    Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        (controller.evaluacionFirebaseUiMap?.isNotEmpty??false)?
                                        ListView.builder(
                                          padding: EdgeInsets.only(top: 8),
                                          shrinkWrap: true,
                                          itemCount: controller.evaluacionFirebaseUiMap?.length??0,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context, int index) {
                                            EvaluacionFirebaseTipoUi? key = controller.evaluacionFirebaseUiMap?.keys.elementAt(index);
                                            List<EvaluacionFirebaseSesionUi>? evaluacionFirebaseSesionUiList = controller.evaluacionFirebaseUiMap?[key];
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${index+1}. ${(){
                                                  switch(key){
                                                    case EvaluacionFirebaseTipoUi.TAREA:
                                                      return "Las evaluaciones de las tareas";
                                                    case EvaluacionFirebaseTipoUi.INSTRUMENTO:
                                                      return "Las evaluaciones de los instrumentos";
                                                    case EvaluacionFirebaseTipoUi.PREGUNTA:
                                                      return "Las evaluaciones de las preguntas";
                                                    case EvaluacionFirebaseTipoUi.TAREAUNIDAD:
                                                      return "Las evaluaciones de las tareas de unidad";
                                                    default:
                                                      return "Las evaluaciones de las tareas";
                                                  }
                                                }()}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: AppTheme.fontTTNorms,
                                                      fontWeight: FontWeight.w700
                                                  ),),
                                                ListView.builder(
                                                    padding: EdgeInsets.only(top: 4),
                                                    shrinkWrap: true,
                                                    itemCount: evaluacionFirebaseSesionUiList?.length??0,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemBuilder: (BuildContext context, int index) {
                                                      EvaluacionFirebaseSesionUi evaluacionFirebaseSesionUi = evaluacionFirebaseSesionUiList![index];
                                                      return Row(
                                                        children: [
                                                          Checkbox(
                                                              value: controller.checkedMap?[evaluacionFirebaseSesionUi]??false,
                                                              onChanged: (check){
                                                                setState((){
                                                                  controller.onClickEvaluacionFirebase(evaluacionFirebaseSesionUi);
                                                                });
                                                              }),
                                                          Expanded(child: Text("${evaluacionFirebaseSesionUi.nombre}",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontFamily: AppTheme.fontTTNorms,
                                                              )
                                                          ))
                                                        ],
                                                      );
                                                    }),
                                              ],
                                            );

                                          },
                                        ):Container(
                                          margin: EdgeInsets.only(top: 8),
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(14), // use instead of BorderRadius.all(Radius.circular(20))
                                          ),
                                          child: FDottedLine(
                                            color: AppTheme.white,
                                            strokeWidth: 3.0,
                                            dottedLength: 10.0,
                                            space: 3.0,
                                            corner: FDottedLineCorner.all(14.0),

                                            /// add widget
                                            child: Container(
                                              padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 16),
                                              alignment: Alignment.center,
                                              child: Text("No se encontraron recursos a enviar en la sesión",  style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  color: AppTheme.white
                                              ),),
                                            ),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.all(4)),
                                        InkWell(
                                          onTap: (){
                                            if(!controller.progressFirebase){
                                              controller.onClickAgregarUnidadTarea();
                                            }
                                          },
                                          child: Text("Agregar tareas de mi unidad",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  color: controller.progressFirebase?AppTheme.white:AppTheme.colorAccent
                                              )
                                          ),
                                        ),
                                        (controller.agregarunidadTarea??false)?
                                        (controller.evaluacionFirebaseUiUnidadList?.isNotEmpty??false)?
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(padding: EdgeInsets.all(8)),
                                            Text("${(controller.evaluacionFirebaseUiMap?.length??0)+2}. Las evaluaciones de las tareas de unidad",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            ListView.builder(
                                                padding: EdgeInsets.only(top: 4),
                                                shrinkWrap: true,
                                                itemCount: controller.evaluacionFirebaseUiUnidadList?.length??0,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemBuilder: (BuildContext context, int index) {
                                                  EvaluacionFirebaseSesionUi evaluacionFirebaseSesionUi = controller.evaluacionFirebaseUiUnidadList![index];
                                                  return Row(
                                                    children: [
                                                      Checkbox(
                                                          value: controller.checkedMap?[evaluacionFirebaseSesionUi]??false,
                                                          onChanged: (check){
                                                            setState((){
                                                              controller.onClickEvaluacionFirebase(evaluacionFirebaseSesionUi);
                                                            });
                                                          }),
                                                      Expanded(child: Text("${evaluacionFirebaseSesionUi.nombre}",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontFamily: AppTheme.fontTTNorms,
                                                          )
                                                      ))
                                                    ],
                                                  );
                                                }),
                                          ],
                                        ):Container(
                                          margin: EdgeInsets.only(top: 8),
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(14), // use instead of BorderRadius.all(Radius.circular(20))
                                          ),
                                          child: FDottedLine(
                                            color: AppTheme.white,
                                            strokeWidth: 3.0,
                                            dottedLength: 10.0,
                                            space: 3.0,
                                            corner: FDottedLineCorner.all(14.0),

                                            /// add widget
                                            child: Container(
                                              padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 16),
                                              alignment: Alignment.center,
                                              child: Text("No se encontraron tareas a enviar en la unidad",  style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  color: AppTheme.white
                                              ),),
                                            ),
                                          ),
                                        ):Container(),
                                        Padding(padding: EdgeInsets.all(8)),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Row(
                            children: [
                              Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text('Cancelar'),
                                    style: OutlinedButton.styleFrom(
                                      primary: AppTheme.colorSesion,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  )
                              ),
                              Padding(padding: EdgeInsets.all(8)),
                              Expanded(
                                  child:  (!controller.progressFirebase)?
                                  ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop(true);
                                  bool succes = await controller.onClickSessionHecho();


                                },
                                style: ElevatedButton.styleFrom(
                                  primary: AppTheme.colorSesion,
                                  onPrimary: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Padding(padding: EdgeInsets.all(4), child: Text( ((controller.msgRealizarSesion??"").isNotEmpty)?'Reintentar':'Aceptar'),),
                              ):Container()
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
              );
            });
        },
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.transparent,
        transitionDuration:
        const Duration(milliseconds: 150))
        .then((value){
            controller.removeListener(dialogState);
            refresh = null;
          });
  }


  Map<String, bool> cityList = {
    'Balagam': false, 'Bangalore': false, 'Hyderabad': false, 'Chennai': false,
    'Delhi': false, 'Surat': false, 'Junagadh': false,
    'Porbander': false, 'Rajkot': false, 'Pune': false,
  };

  Future<Map<String, bool>?> _preLocation() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Preferred Location'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    child: Text('Cancle'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context, cityList);
                    },
                    child: Text('Done'),
                  ),
                ],
                content: Container(
                  width: double.minPositive,
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cityList.length,
                    itemBuilder: (BuildContext context, int index) {
                      String _key = cityList.keys.elementAt(index);
                      return CheckboxListTile(
                        value: cityList[_key],
                        title: Text(_key),
                        onChanged: (val) {
                          setState(() {
                            cityList[_key] = val??false;
                          });
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        });
  }

}




