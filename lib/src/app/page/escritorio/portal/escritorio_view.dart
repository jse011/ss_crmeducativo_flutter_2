import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fancy_shimer_image/fancy_shimmer_image.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/escritorio/portal/escritorio_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_unidad_sesion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_hoy_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';

class EscritorioView extends View{
  final AnimationController animationController;

  EscritorioView({required this.animationController});

  @override
  _EscritorioViewState createState() => _EscritorioViewState();

}

class _EscritorioViewState extends ViewState<EscritorioView, EscritorioController>{

  final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late Animation<double> topBarAnimation;

  _EscritorioViewState() : super(EscritorioController(MoorConfiguracionRepository(), DeviceHttpDatosRepositorio(), MoorUnidadSesionRepository()));

@override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
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

    Future.delayed(const Duration(milliseconds: 700), () {
  // Here you can write your code
      setState(() {
        widget.animationController.forward();
      });

    });
    super.initState();
  }

  @override
  Widget get view => Container(
    color: AppTheme.background,
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          getMainTab(),
          getAppBarUI(),
          false?
          ArsProgressWidget(
              blur: 2,
              backgroundColor: Color(0x33000000),
              animationDuration: Duration(milliseconds: 500)):
          Container(),

        ],
      ),
    ),
  );
  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
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
                            left: 0,
                            right: 32,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: ControlledWidgetBuilder<EscritorioController>(
                          builder: (context, controller) {
                            return Stack(
                              children: <Widget>[
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 48, top: 0, bottom: 10),
                                    child: Text(
                                      'Accesos',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18 + 8 - 4 * topBarOpacity,
                                        letterSpacing: 1.2,
                                        color: AppTheme.darkerText,
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
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget getMainTab() {
    return ControlledWidgetBuilder<EscritorioController>(
        builder: (context, controller) {
          return Container(
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height,
              left: 0, //24,
              right: 0, //48
            ),
            child: Container(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 24),
                    ),
                    Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 450
                        ),
                        child:  InkWell(
                          onTap: () async {
                            //dynamic respuesta = await AppRouter.createCrearEventoRouter(context, null, null);
                          },
                          child: Container(
                            height: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,90),
                            margin: EdgeInsets.only(
                                top: 0,
                                left: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,24),
                                right: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,24),
                                bottom: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,20)
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppTheme.colorPrimary,
                                    width: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,2)
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthSesionHoy(context,22))),
                                color: AppTheme.white
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthSesionHoy(context,8)),
                                  decoration: BoxDecoration(
                                      color: HexColor("#f3f9d2"),
                                      borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthSesionHoy(context,16)))
                                  ),
                                  width: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,65),
                                  child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_curso_foto_alumno),),
                                ),
                                Padding(padding: EdgeInsets.only(left: 8)),
                                Expanded(
                                    child: Text("Foto Alumnos", style: TextStyle(
                                      color: AppTheme.darkerText,
                                      fontWeight: FontWeight.w700,
                                      fontSize: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 16),
                                      fontFamily: AppTheme.fontTTNorms,
                                    ),)
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,8),
                                      right: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,28)
                                  ),
                                  child: ClipOval(
                                    child: Material(
                                      color: AppTheme.colorPrimary, // button color
                                      child: InkWell(
                                        splashColor: AppTheme.colorPrimary, // inkwell color
                                        child: SizedBox(
                                            width: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,42),
                                            height: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,42),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,14),
                                                  right: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,14),
                                                  top: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,14),
                                                  bottom: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,14)
                                              ),
                                              child: SvgPicture.asset(AppIcon.ic_curso_flecha, color: AppTheme.white,),
                                            )),
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: 450
                        ),
                        child: InkWell(
                          onTap: () async {
                            dynamic respuesta = await AppRouter.showAgendaPortalView(context, null);

                          },
                          child: Container(
                            height: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,90),
                            margin: EdgeInsets.only(
                                top: 0,
                                left: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,24),
                                right: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,24),
                                bottom: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,20)
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppTheme.colorPrimary,
                                    width: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,2)
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthSesionHoy(context,22))),
                                color: AppTheme.white
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthSesionHoy(context,8)),
                                  decoration: BoxDecoration(
                                      color: HexColor("#f3f9d2"),
                                      borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthSesionHoy(context,16)))
                                  ),
                                  width: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,65),
                                  child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_curso_agenda),),
                                ),
                                Padding(padding: EdgeInsets.only(left: 8)),
                                Expanded(
                                    child: Text("Agenda Escolar", style: TextStyle(
                                      color: AppTheme.darkerText,
                                      fontWeight: FontWeight.w700,
                                      fontSize: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 16),
                                      fontFamily: AppTheme.fontTTNorms,
                                    ),)
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,8),
                                      right: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,28)
                                  ),
                                  child: ClipOval(
                                    child: Material(
                                      color: AppTheme.colorPrimary, // button color
                                      child: InkWell(
                                        splashColor: AppTheme.colorPrimary, // inkwell color
                                        child: SizedBox(
                                            width: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,42),
                                            height: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,42),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,14),
                                                  right: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,14),
                                                  top: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,14),
                                                  bottom: ColumnCountProvider.aspectRatioForWidthSesionHoy(context,14)
                                              ),
                                              child: SvgPicture.asset(AppIcon.ic_curso_flecha, color: AppTheme.white,),
                                            )),
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Stack(
                        children: [
                          Center(
                              child: Container(
                                  padding: EdgeInsets.all(24),
                                  margin: EdgeInsets.only(
                                      top: 8,
                                      left: 16,
                                      right: 16,
                                      bottom: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: AppTheme.colorPrimary.withOpacity(0.1),
                                  ),
                                  constraints: BoxConstraints(
                                    minHeight: 150.0,
                                    maxWidth: 550.0,
                                  ),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 0, bottom: 4),
                                      alignment: Alignment.centerLeft,
                                      child: Text("Sesiones de hoy",
                                        style: TextStyle(
                                            color: AppTheme.darkerText,
                                            fontWeight: FontWeight.w700,
                                            fontSize: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 16),
                                            fontFamily: AppTheme.fontTTNorms,
                                        )
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 0, bottom: 16),
                                      color: AppTheme.darkerText,
                                      height: 2,
                                    ),
                                    (){

                                      int cant_sesiones = controller.sesionHoyUiList.length;
                                      int columnas = ColumnCountProvider.columnsForWidthSesionHoy(context);
                                      int cant_reducida = columnas * 2;
                                      bool isVisibleVerMas = cant_reducida < cant_sesiones;
                                      /*if(unidadUi.cantUnidades == 1){
                                        isVisibleVerMas = false;
                                      }*/

                                      int cant_lista;
                                      if(controller.sesionToogle){
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
                                      return Column(
                                        children: [
                                          controller.sesionProgress?
                                          Padding(
                                            padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 16)),
                                            child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.colorPrimary,),
                                          ): Container(
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  cant_sesiones > 0 ?
                                                  GridView.builder(
                                                      padding: EdgeInsets.only(top: 0, bottom: 0),
                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: columnas,
                                                        mainAxisSpacing: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 8),
                                                        crossAxisSpacing: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 8),
                                                      ),
                                                      physics: NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: cant_lista,
                                                      itemBuilder: (context, index){
                                                        SesionHoyUi sesionHoyUi =  controller.sesionHoyUiList[index];
                                                        return InkWell(
                                                          onTap: (){
                                                            AppRouter.createRouteSesionPortalRouter(context, controller.usuarioUi, sesionHoyUi.cursosUi, sesionHoyUi.unidadUi, sesionHoyUi.sesionUi, sesionHoyUi.calendarioPeriodoUI);
                                                          },
                                                          child: Card(
                                                            margin: EdgeInsets.only(
                                                                top: 0,
                                                                left: 0,
                                                                right: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 12),
                                                                bottom: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 16)),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 8)),
                                                            ),
                                                            child:  Container(
                                                              height: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 120),
                                                              child:  Stack(
                                                                children: [
                                                                  Container(
                                                                    child: ClipRRect(
                                                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                                                      child: sesionHoyUi.cursosUi?.banner!=null?FancyShimmerImage(
                                                                        boxFit: BoxFit.cover,
                                                                        imageUrl: sesionHoyUi.cursosUi?.banner??'',
                                                                        errorWidget: Icon(Icons.warning_amber_rounded, color: AppTheme.white, size: 40,),
                                                                      ):
                                                                      Container(),
                                                                    ),
                                                                  ),
                                                                  Opacity(
                                                                    opacity: 0.4,
                                                                    child:  Container(
                                                                        decoration: BoxDecoration(
                                                                            color: HexColor(sesionHoyUi.cursosUi?.color1),
                                                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 8))))
                                                                    ),
                                                                  ),
                                                                  Column(

                                                                    children: [
                                                                      Expanded(
                                                                          child: Container(
                                                                            child: Column(
                                                                              children: [
                                                                                Container(
                                                                                  margin: EdgeInsets.only(top: 8),
                                                                                  child: Text("Sesión ${sesionHoyUi.sesionUi?.nroSesion??""}",
                                                                                    style: TextStyle(
                                                                                      color: AppTheme.white,
                                                                                      fontSize: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 11),
                                                                                      fontWeight: FontWeight.w700,
                                                                                      fontFamily: AppTheme.fontTTNorms,
                                                                                    )
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  margin: EdgeInsets.only(
                                                                                      top: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 4),
                                                                                      left: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 16),
                                                                                      right: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 16)
                                                                                  ),
                                                                                  height: 0.5,
                                                                                  color: AppTheme.white,
                                                                                ),
                                                                                Container(
                                                                                  margin: EdgeInsets.only(
                                                                                      top: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 8),
                                                                                      left: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 16),
                                                                                      right: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 16)
                                                                                  ),
                                                                                  child: Text("${sesionHoyUi.sesionUi?.titulo??""}".toUpperCase(),
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 3,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(
                                                                                        color: AppTheme.white,
                                                                                        fontWeight: FontWeight.w700,
                                                                                        fontSize: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 11),
                                                                                        fontFamily: AppTheme.fontTTNorms,
                                                                                    )),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                      ),
                                                                      Container(
                                                                        height: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 35),
                                                                        padding: EdgeInsets.only(
                                                                            top: 0,
                                                                            left: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 16),
                                                                            right: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 16)
                                                                        ),
                                                                        width: double.infinity,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.only(
                                                                              bottomRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 8)),
                                                                              bottomLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 8))
                                                                          ),
                                                                          color: AppTheme.white,
                                                                        ),
                                                                        child: Center(
                                                                          child: Text(sesionHoyUi.cursosUi?.nombreCurso??"",
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(
                                                                                fontFamily: AppTheme.fontTTNorms,
                                                                                color: HexColor(sesionHoyUi.cursosUi?.color1),
                                                                                fontSize: ColumnCountProvider.aspectRatioForWidthSesionHoy(context, 11)),),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                  )
                                                      :Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.colorPrimary.withOpacity(0.1),
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
                                                        child: Text("Sin sesiones hoy",  style: TextStyle(
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
                                                controller.onClickVerMasSesiones();
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(top: 8),
                                                padding: EdgeInsets.all(10),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: AppTheme.white,
                                                    borderRadius: BorderRadius.circular(14) // use instead of BorderRadius.all(Radius.circular(20))
                                                ),
                                                child: Center(
                                                  child: Text("${controller.sesionToogle?"Ver solo las últimas sesiones":"Ver más sesiones"}", style: TextStyle(color: AppTheme.black, fontSize: 12, fontWeight: FontWeight.w500),),
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    }(),
                                  ],
                                ),
                              )
                          )
                        ]
                    ),
                    Container(
                      height: 150,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }


}