import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/libs/flutterOffline/src/main.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/lista/tarea_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/Item_tarea.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_calendario_periodo_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_unidad_tarea_repositoy.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';

class TareaView2 extends View{
  CursosUi cursosUi;
  UsuarioUi? usuarioUi;
  TareaView2(this.cursosUi, this.usuarioUi);

  @override
  _TareaViewState createState() => _TareaViewState(cursosUi, usuarioUi);

}

class _TareaViewState extends ViewState<TareaView2, TareaController> with TickerProviderStateMixin{

  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  Function(bool connected)? _onChangeConnected;
  bool? _connected;
  _TareaViewState(cursoUi, usuarioUi) : super(TareaController(usuarioUi, cursoUi, MoorConfiguracionRepository(), MoorCalendarioPeriodoRepository(), DeviceHttpDatosRepositorio(), MoorUnidadTareaRepository()));

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
    _pageController.dispose();
    super.dispose();
  }

  int _seletedItem = 0;
  bool result = true;
  PageController _pageController = PageController();

  Widget get view => ControlledWidgetBuilder<TareaController>(
      builder: (context, controller) {
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
            child:  Stack(
              children: [
                getMainTab(),
                controller.progress?  ArsProgressWidget(
                  blur: 2,
                  backgroundColor: Color(0x33000000),
                  animationDuration: Duration(milliseconds: 500),
                  dismissable: true,
                  onDismiss: (backgraund){
                    if(!backgraund){
                      Navigator.of(this.context).pop();
                    }

                  },
                ):Container(),
                getAppBarUI(),

              ],
            ),
          ),
        );
      });

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
          ),child:  Column(
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
              child: ControlledWidgetBuilder<TareaController>(
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
                        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppIcon.ic_curso_tarea, height: 35 +  6 - 10 * topBarOpacity, width: 35 +  6 - 10 * topBarOpacity,),
                            Padding(
                              padding: EdgeInsets.only(left: 12, top: 8),
                              child: Text(
                                'Tareas',
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
                      /*Positioned(
                                  right: 10,
                                  child: ClipOval(
                                    child: Material(
                                      color: AppTheme.colorPrimary.withOpacity(0.1), // button color
                                      child: InkWell(
                                        splashColor: AppTheme.colorPrimary, // inkwell color
                                        child: SizedBox(width: 43 + 6 - 8 * topBarOpacity, height: 43 + 6 - 8 * topBarOpacity,
                                          child: Icon(Ionicons.sync, size: 24 + 6 - 8 * topBarOpacity,color: AppTheme.colorPrimary, ),
                                        ),
                                        onTap: () {
                                          //controller.onSyncronizarCurso();
                                        },
                                      ),
                                    ),
                                  ),
                                )*/
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
    return ControlledWidgetBuilder<TareaController>(
        builder: (context, controller) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top +
                        0,
                    left: 0,//24,
                    right: 0,//48
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: ColumnCountProvider.aspectRatioForWidthTarea(context, 16),
                      right: ColumnCountProvider.aspectRatioForWidthTarea(context, 40)
                  ),
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
                      controller.unidadUiList.isEmpty?
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
                        controller: scrollController,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            (!controller.conexion && !controller.progress)?
                            Center(
                              child: Container(
                                  constraints: BoxConstraints(
                                    //minWidth: 200.0,
                                    maxWidth: 600.0,
                                  ),
                                  height: 45,
                                  margin: EdgeInsets.only(
                                    top: ColumnCountProvider.aspectRatioForWidthTarea(context, 24),
                                    left: ColumnCountProvider.aspectRatioForWidthTarea(context, 20),
                                    right: ColumnCountProvider.aspectRatioForWidthTarea(context, 20),
                                  ),
                                  decoration: BoxDecoration(
                                      color: AppTheme.redLighten5,
                                      borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthTarea(context, 8)))
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          width: ColumnCountProvider.aspectRatioForWidthTarea(context, 24),
                                          height: ColumnCountProvider.aspectRatioForWidthTarea(context, 24),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color:  Colors.red,
                                            ),
                                          )
                                      ),
                                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTarea(context, 4))),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: Text('Sin conexión',
                                            style: TextStyle(
                                                color:  Colors.red,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                fontFamily: AppTheme.fontTTNorms
                                            )
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ): Container(
                              padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthTarea(context, 16)),
                            ),
                            ListView.builder(
                              padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthTarea(context, 16)),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.unidadUiList.length,
                              itemBuilder: (BuildContext ctxt, int index){

                                UnidadUi unidadUi =  controller.unidadUiList[index];
                                List<dynamic> unidadItemList = controller.unidadItemsMap[unidadUi]??[];
                                int cant_tareas = unidadItemList.length;
                                int columnas = ColumnCountProvider.columnsForWidthTarea(context);
                                bool toogle = unidadUi.toogle??false;
                                int cant_reducida = columnas * 2;
                                bool isVisibleVerMas = cant_reducida < cant_tareas;
                                if(unidadUi.cantUnidades == 1){
                                  isVisibleVerMas = false;
                                }

                                int cant_lista;
                                if(toogle){
                                  if(isVisibleVerMas){

                                  }
                                  cant_lista = cant_tareas;
                                }else{
                                  if(isVisibleVerMas){
                                    cant_lista = cant_reducida;
                                  }else{
                                    cant_lista = cant_tareas;
                                  }
                                }

                                return Container(
                                  margin: EdgeInsets.only(
                                    bottom: controller.unidadUiList.length == index + 1 ?
                                    ColumnCountProvider.aspectRatioForWidthTarea(context, 70):
                                    ColumnCountProvider.aspectRatioForWidthTarea(context, 30),
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
                                                  borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthTarea(context, 8))),
                                                  color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                                                ),
                                                margin: EdgeInsets.only(
                                                    top: ColumnCountProvider.aspectRatioForWidthTarea(context, 8),
                                                    bottom: ColumnCountProvider.aspectRatioForWidthTarea(context, 20)
                                                ),
                                                padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTarea(context, 16)),
                                                child: Text("U${unidadUi.nroUnidad??""}: ${unidadUi.titulo??""}",
                                                  style: TextStyle(
                                                      fontSize: ColumnCountProvider.aspectRatioForWidthTarea(context, 14),
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: AppTheme.fontTTNorms
                                                  ),
                                                ),
                                              ),
                                              cant_tareas > 0?
                                              GridView.builder(
                                                  padding: EdgeInsets.only(top: 0,
                                                      left: ColumnCountProvider.aspectRatioForWidthTarea(context, 8),
                                                      right: ColumnCountProvider.aspectRatioForWidthTarea(context, 16)
                                                  ),
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: columnas,
                                                    mainAxisSpacing: ColumnCountProvider.aspectRatioForWidthTarea(context, 24),
                                                    crossAxisSpacing: ColumnCountProvider.aspectRatioForWidthTarea(context, 24),
                                                  ),
                                                  physics: NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: cant_lista,
                                                  itemBuilder: (context, index){
                                                    dynamic o = unidadItemList[index];
                                                    if(o is TareaUi){
                                                      return ItemTarea(
                                                          color1: HexColor(controller.cursosUi.color1),
                                                          color2: HexColor(controller.cursosUi.color2),
                                                          tareaUi: o, onTap: () async{
                                                        dynamic? result = await AppRouter.createRouteTareaPortalRouter(context, controller.usuarioUi,  controller.cursosUi, o, controller.calendarioPeriodoUI, unidadUi, controller.getSesionUi(o));
                                                        if(result is int) controller.refrescarListTarea(unidadUi);
                                                      });
                                                    }else{
                                                      return InkWell(
                                                        onTap: () async{
                                                          dynamic? result = await AppRouter.createRouteTareaCrearRouter(context, controller.usuarioUi, controller.cursosUi, null, controller.calendarioPeriodoUI, unidadUi, null);
                                                          if(result is int) controller.refrescarListTarea(unidadUi);
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTarea(context, 8)),
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
                                                                  Icon(Ionicons.add, color: AppTheme.white,
                                                                    size: ColumnCountProvider.aspectRatioForWidthTarea(context, 36),),
                                                                  Padding(padding: EdgeInsets.only(top: 4)),
                                                                  Text("Crear tarea",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: ColumnCountProvider.aspectRatioForWidthTarea(context, 14),
                                                                        fontWeight: FontWeight.w700,
                                                                        fontFamily: AppTheme.fontTTNorms,
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
                                                    child: Text("Unidad sin tareas",  style: TextStyle(
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
                                        InkWell(
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
                                              child: Text("${toogle?"Ver solo las últimas tareas":"Ver más tareas"}", style: TextStyle(color: AppTheme.black, fontSize: 12, fontWeight: FontWeight.w500),),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            )
                          ],
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
                                      splashColor: AppTheme.black.withOpacity(0.1),
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

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return true;
  }


}