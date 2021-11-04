import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fancy_shimer_image/fancy_shimmer_image.dart';
import 'package:ss_crmeducativo_2/src/app/page/escritorio/portal/escritorio_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';

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

  _EscritorioViewState() : super(EscritorioController());

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
                            left: 8,
                            right: 8,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: ControlledWidgetBuilder<EscritorioController>(
                          builder: (context, controller) {
                            return Stack(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 48, top: 8, bottom: 10),
                                      child: Text(
                                        'Accesos',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18 + 10 - 6 * topBarOpacity,
                                          letterSpacing: 1.2,
                                          color: AppTheme.darkerText,
                                        ),
                                      ),
                                    ),
                                  ],
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

                    InkWell(
                      onTap: () async {
                        //dynamic respuesta = await AppRouter.createCrearEventoRouter(context, null, null);

                      },
                      child: Container(
                        height: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,90),
                        margin: EdgeInsets.only(
                            top: 0,
                            left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,24),
                            right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,24),
                            bottom: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20)
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppTheme.colorPrimary,
                                width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,2)
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,22))),
                            color: AppTheme.white
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8)),
                              decoration: BoxDecoration(
                                  color: HexColor("#f3f9d2"),
                                  borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,16)))
                              ),
                              width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,65),
                              child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_curso_foto_alumno),),
                            ),
                            Padding(padding: EdgeInsets.only(left: 8)),
                            Expanded(
                                child: Text("Foto Alumnos", style: TextStyle(
                                  fontFamily: AppTheme.fontTTNorms,
                                  fontWeight: FontWeight.w800,
                                  fontSize: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,18),
                                  color: AppTheme.darkerText,
                                  letterSpacing: 0.8,
                                ),)
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8),
                                  right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,28)
                              ),
                              child: ClipOval(
                                child: Material(
                                  color: AppTheme.colorPrimary, // button color
                                  child: InkWell(
                                    splashColor: AppTheme.colorPrimary, // inkwell color
                                    child: SizedBox(
                                        width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,42),
                                        height: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,42),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,14),
                                              right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,14),
                                              top: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,14),
                                              bottom: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,14)
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
                    InkWell(
                      onTap: () async {
                        dynamic respuesta = await AppRouter.showAgendaPortalView(context, null);

                      },
                      child: Container(
                        height: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,90),
                        margin: EdgeInsets.only(
                            top: 0,
                            left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,24),
                            right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,24),
                            bottom: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20)
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppTheme.colorPrimary,
                                width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,2)
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,22))),
                            color: AppTheme.white
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8)),
                              decoration: BoxDecoration(
                                  color: HexColor("#f3f9d2"),
                                  borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,16)))
                              ),
                              width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,65),
                              child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_curso_agenda),),
                            ),
                            Padding(padding: EdgeInsets.only(left: 8)),
                            Expanded(
                                child: Text("Agenda Escolar", style: TextStyle(
                                  fontFamily: AppTheme.fontTTNorms,
                                  fontWeight: FontWeight.w800,
                                  fontSize: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,18),
                                  color: AppTheme.darkerText,
                                  letterSpacing: 0.8,
                                ),)
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8),
                                  right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,28)
                              ),
                              child: ClipOval(
                                child: Material(
                                  color: AppTheme.colorPrimary, // button color
                                  child: InkWell(
                                    splashColor: AppTheme.colorPrimary, // inkwell color
                                    child: SizedBox(
                                        width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,42),
                                        height: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,42),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,14),
                                              right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,14),
                                              top: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,14),
                                              bottom: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,14)
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
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppTheme.white,
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
                                      child: Text("Sesiones de hoy", style: TextStyle(color: AppTheme.greyDarken2, fontWeight: FontWeight.w700, fontSize: 12),),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 0, bottom: 16),
                                      color: AppTheme.greyDarken1,
                                      height: 0.5,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child:  Column(
                                            children: [
                                              Card(
                                                margin: EdgeInsets.only(
                                                    top: 0,
                                                    left: 0,
                                                    right: 12,
                                                    bottom: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                child:  Container(
                                                  height: 120.0,
                                                  child:  Stack(
                                                    children: [
                                                      Container(
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                                          child: getCursoUi(controller, 5)?.banner!=null?FancyShimmerImage(
                                                            boxFit: BoxFit.cover,
                                                            imageUrl: getCursoUi(controller, 4)?.banner??'',
                                                            errorWidget: Icon(Icons.warning_amber_rounded, color: AppTheme.white, size: 105,),
                                                          ):
                                                          Container(),
                                                        ),
                                                      ),
                                                      Opacity(
                                                        opacity: 0.4,
                                                        child:  Container(
                                                            decoration: BoxDecoration(
                                                                color: HexColor(getCursoUi(controller, 4)?.color1),
                                                                borderRadius: BorderRadius.all(Radius.circular(8)))
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
                                                                      child: Text("Sesión 3", style: TextStyle(color: AppTheme.white, fontSize: 11, fontWeight: FontWeight.w700,),),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(top: 4, left: 16, right: 16),
                                                                      height: 0.5,
                                                                      color: AppTheme.white,
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(top: 8, left: 16, right: 16),
                                                                      child: Text("HÁBITAT DE LOS ANIMALES", textAlign: TextAlign.center,style: TextStyle(color: AppTheme.white, fontWeight: FontWeight.w700, fontSize: 11),),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                          ),
                                                          Container(
                                                            height: 40.0,
                                                            padding: EdgeInsets.only(top: 0, left: 16, right: 16),
                                                            width: double.infinity,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomRight: Radius.circular(8),
                                                                  bottomLeft: Radius.circular(8)
                                                              ),
                                                              color: AppTheme.white,
                                                            ),
                                                            child: Center(
                                                              child: Text(getCursoUi(controller, 4)?.nombreCurso??"",textAlign: TextAlign.center, style: TextStyle(color: HexColor(getCursoUi(controller, 4)?.color1), fontSize: 11),),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Card(
                                                margin: EdgeInsets.only(
                                                    top: 0,
                                                    left: 0,
                                                    right: 12,
                                                    bottom: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                child:   Container(
                                                  height: 120.0,
                                                  child:  Stack(
                                                    children: [
                                                      Container(
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                                          child: getCursoUi(controller, 3)?.banner!=null?FancyShimmerImage(
                                                            boxFit: BoxFit.cover,
                                                            imageUrl: getCursoUi(controller, 3)?.banner??'',
                                                            errorWidget: Icon(Icons.warning_amber_rounded, color: AppTheme.white, size: 105,),
                                                          ):
                                                          Container(),
                                                        ),
                                                      ),
                                                      Opacity(
                                                        opacity: 0.4,
                                                        child:  Container(
                                                            decoration: BoxDecoration(
                                                                color: HexColor(getCursoUi(controller, 3)?.color1),
                                                                borderRadius: BorderRadius.all(Radius.circular(8)))
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
                                                                      child: Text("Sesión 3", style: TextStyle(color: AppTheme.white, fontSize: 11, fontWeight: FontWeight.w700,),),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(top: 4, left: 16, right: 16),
                                                                      height: 0.5,
                                                                      color: AppTheme.white,
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(top: 8, left: 16, right: 16),
                                                                      child: Text("HÁBITAT DE LOS ANIMALES", textAlign: TextAlign.center,style: TextStyle(color: AppTheme.white, fontWeight: FontWeight.w700, fontSize: 11),),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                          ),
                                                          Container(
                                                            height: 40.0,
                                                            padding: EdgeInsets.only(top: 0, left: 16, right: 16),
                                                            width: double.infinity,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomRight: Radius.circular(8),
                                                                  bottomLeft: Radius.circular(8)
                                                              ),
                                                              color: AppTheme.white,
                                                            ),
                                                            child: Center(
                                                              child: Text(getCursoUi(controller, 3)?.nombreCurso??"",textAlign: TextAlign.center, style: TextStyle(color: HexColor(getCursoUi(controller, 3)?.color1), fontSize: 11),),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            children: [
                                              Card(
                                                margin: EdgeInsets.only(
                                                    top: 0,
                                                    left: 6,
                                                    right: 0,
                                                    bottom: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                child:   Container(
                                                  height: 120.0,
                                                  child:  Stack(
                                                    children: [
                                                      Container(
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                                          child: getCursoUi(controller, 0)?.banner!=null?FancyShimmerImage(
                                                            boxFit: BoxFit.cover,
                                                            imageUrl: getCursoUi(controller, 0)?.banner??'',
                                                            errorWidget: Icon(Icons.warning_amber_rounded, color: AppTheme.white, size: 105,),
                                                          ):
                                                          Container(),
                                                        ),
                                                      ),
                                                      Opacity(
                                                        opacity: 0.4,
                                                        child:  Container(
                                                            decoration: BoxDecoration(
                                                                color: HexColor(getCursoUi(controller, 0)?.color1),
                                                                borderRadius: BorderRadius.all(Radius.circular(8)))
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
                                                                      child: Text("Sesión 3", style: TextStyle(color: AppTheme.white, fontSize: 11, fontWeight: FontWeight.w700,),),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(top: 4, left: 16, right: 16),
                                                                      height: 0.5,
                                                                      color: AppTheme.white,
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(top: 8, left: 16, right: 16),
                                                                      child: Text("HÁBITAT DE LOS ANIMALES", textAlign: TextAlign.center,style: TextStyle(color: AppTheme.white, fontWeight: FontWeight.w700, fontSize: 11),),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                          ),
                                                          Container(
                                                            height: 40.0,
                                                            padding: EdgeInsets.only(top: 0, left: 16, right: 16),
                                                            width: double.infinity,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomRight: Radius.circular(8),
                                                                  bottomLeft: Radius.circular(8)
                                                              ),
                                                              color: AppTheme.white,
                                                            ),
                                                            child: Center(
                                                              child: Text(getCursoUi(controller, 0)?.nombreCurso??"",textAlign: TextAlign.center, style: TextStyle(color: HexColor(getCursoUi(controller, 0)?.color1), fontSize: 11),),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Card(
                                                margin: EdgeInsets.only(
                                                    top: 0,
                                                    left: 6,
                                                    right: 0,
                                                    bottom: 16),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                                child: Container(
                                                  height: 120.0,
                                                  child:  Stack(
                                                    children: [
                                                      Container(
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                                          child: getCursoUi(controller, 5)?.banner!=null?FancyShimmerImage(
                                                            boxFit: BoxFit.cover,
                                                            imageUrl: getCursoUi(controller, 4)?.banner??'',
                                                            errorWidget: Icon(Icons.warning_amber_rounded, color: AppTheme.white, size: 105,),
                                                          ):
                                                          Container(),
                                                        ),
                                                      ),
                                                      Opacity(
                                                        opacity: 0.4,
                                                        child:  Container(
                                                            decoration: BoxDecoration(
                                                                color: HexColor(getCursoUi(controller, 4)?.color1),
                                                                borderRadius: BorderRadius.all(Radius.circular(8)))
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
                                                                      child: Text("Sesión 3", style: TextStyle(color: AppTheme.white, fontSize: 11, fontWeight: FontWeight.w700,),),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(top: 4, left: 16, right: 16),
                                                                      height: 0.5,
                                                                      color: AppTheme.white,
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(top: 8, left: 16, right: 16),
                                                                      child: Text("HÁBITAT DE LOS ANIMALES", textAlign: TextAlign.center,style: TextStyle(color: AppTheme.white, fontWeight: FontWeight.w700, fontSize: 11),),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                          ),
                                                          Container(
                                                            height: 40.0,
                                                            padding: EdgeInsets.only(top: 0, left: 16, right: 16),
                                                            width: double.infinity,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  bottomRight: Radius.circular(8),
                                                                  bottomLeft: Radius.circular(8)
                                                              ),
                                                              color: AppTheme.white,
                                                            ),
                                                            child: Center(
                                                              child: Text(getCursoUi(controller, 4)?.nombreCurso??"",textAlign: TextAlign.center, style: TextStyle(color: HexColor(getCursoUi(controller, 4)?.color1), fontSize: 11),),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                        )
                                      ],
                                    )
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

  CursosUi? getCursoUi(EscritorioController controller, int postion){
    return controller.cursosList.isNotEmpty?controller.cursosList[postion]: null;
  }

}