import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/lista/sesion_lista_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_calendario_periodo_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_unidad_sesion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';
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

  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late AnimationController animationController;
  Function()? statetDialogSesion;

  _CursoListaViewState(cursoUi, usuarioUi) : super(SesionListaController(usuarioUi, cursoUi, MoorConfiguracionRepository(), MoorCalendarioPeriodoRepository(), DeviceHttpDatosRepositorio(), MoorUnidadSesionRepository()));

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
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

    animationController.reset();

    Future.delayed(const Duration(milliseconds: 500), () {
// Here you can write your code
      setState(() {
        animationController.forward();
      });}

    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget get view => ControlledWidgetBuilder<SesionListaController>(
      builder: (context, controller) {
        return Scaffold(
          extendBody: true,
          backgroundColor: AppTheme.background,
          body: Stack(
            children: [
              getMainTab(),
              getAppBarUI(),
              if(controller.progressDocente)
                ArsProgressWidget(
                  blur: 2,
                  backgroundColor: Color(0x33000000),
                  animationDuration: Duration(milliseconds: 500),
                )
            ],
          ),
        );
      }
  );

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext? context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
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
                        height: MediaQuery.of(context!).padding.top,
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
                                        animationController.reverse().then<dynamic>((data) {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.of(this.context).pop();
                                        });
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
                ),
              ),
            );
          },
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
                            child: Text("Seleciona un bimestre o trimestre", style: TextStyle(color: AppTheme.grey, fontStyle: FontStyle.italic, fontSize: 12),),
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
                            child: Text("Lista vacía${controller.datosOffline?", revice su conexión a internet":""}", style: TextStyle(color: AppTheme.grey, fontStyle: FontStyle.italic, fontSize: 12),),
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
                            color: HexColor(sesionUi.colorSesion),
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
                        color: HexColor(sesionUi.colorSesion),
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
                    color: HexColor(sesionUi.colorSesion),
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
            bottom: ColumnCountProvider.aspectRatioForWidthSesion(context, 8),
            right: ColumnCountProvider.aspectRatioForWidthSesion(context, 12),
            child: Material(
              color:HexColor(sesionUi.colorSesion).withOpacity(0.8),
              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthSesion(context, 8))),
              child: Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthSesion(context, 7)) // use instead of BorderRadius.all(Radius.circular(20))
                ),
                child: InkWell(
                  onTap: () {

                  },
                  child:
                  Container(
                      padding: EdgeInsets.only(
                          top: ColumnCountProvider.aspectRatioForWidthSesion(context, 4),
                          left: ColumnCountProvider.aspectRatioForWidthSesion(context, 4),
                          bottom: ColumnCountProvider.aspectRatioForWidthSesion(context, 4),
                          right: ColumnCountProvider.aspectRatioForWidthSesion(context, 4)),
                      child: Text(sesionUi.estadoEjecucion??"",
                        style: TextStyle(
                          fontSize: ColumnCountProvider.aspectRatioForWidthSesion(context, 9),
                          color: HexColor(sesionUi.colorSesion).withOpacity(0.9),
                          fontFamily: AppTheme.fontTTNorms,
                          fontWeight: FontWeight.w700
                        ),)
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

