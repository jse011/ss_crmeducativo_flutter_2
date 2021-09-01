
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fancy_shimer_image/fancy_shimmer_image.dart';
import 'package:ss_crmeducativo_2/src/app/page/curso/curso_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/animation_view.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';

class CursoView extends View{
  CursosUi cursosUi;
  CursoView(this.cursosUi);

  @override
  _CursoViewState createState() => _CursoViewState(cursosUi);

}

class _CursoViewState extends ViewState<CursoView, CursoController> with TickerProviderStateMixin{
  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late AnimationController animationController;

  _CursoViewState(cursosUi)
      : super(CursoController(cursosUi,MoorConfiguracionRepository()));

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
  Widget get view =>  Scaffold(
    backgroundColor:AppTheme.white,
    body: Stack(
      children: <Widget>[
        getMainTab(),
        getAppBarUI(),
      ],
    ),
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
                            right: 24,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child:  ControlledWidgetBuilder<CursoController>(
                          builder: (context, controller) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                                onPressed: () {
                                  animationController.reverse().then<dynamic>((data) {
                                    if (!mounted) {
                                      return;
                                    }
                                    Navigator.of(context).pop();
                                  });
                                },
                              ),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.fechaHoy??"",
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12 + 6 - 6 * topBarOpacity,
                                          letterSpacing: 1.2,
                                          color: AppTheme.darkerText,
                                        ),
                                      ),
                                      Text(
                                        controller.cursos?.nombreCurso??"",
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12 + 6 - 6 * topBarOpacity,
                                          letterSpacing: 1.2,
                                          color: AppTheme.darkerText,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              ClipOval(
                                child: Material(
                                  color: HexColor(controller.cursos?.color1).withOpacity(0.1), // button color
                                  child: InkWell(
                                    splashColor: HexColor(controller.cursos?.color1), // inkwell color
                                    child: SizedBox(width: 45 + 6 - 8 * topBarOpacity, height: 45 + 6 - 8 * topBarOpacity,
                                        child: Icon(Ionicons.mail_open_outline, size: 26 + 6 - 6 * topBarOpacity,color: HexColor(controller.cursos?.color1),)),
                                    onTap: () {},
                                  ),
                                ),
                              ),

                            ],
                          ),
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
    return Container(
        padding: EdgeInsets.only(
          top: AppBar().preferredSize.height +
              MediaQuery.of(context).padding.top +
              0,
        ),
        child: ControlledWidgetBuilder<CursoController>(
            builder: (context, controller) {
              //print()
              return Stack(
                children: [
                  AnimatedBuilder(
                    animation: animationController,
                    builder: (BuildContext? context, Widget? child) {
                      return FadeTransition(
                        opacity: topBarAnimation,
                        child: Transform(
                          transform: Matrix4.translationValues(
                              0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                          child:  CustomScrollView(
                            controller: scrollController,
                            slivers: <Widget>[
                              SliverList(
                                  delegate: SliverChildListDelegate(
                                    [
                                      Padding(padding: EdgeInsets.only( top: 40)),
                                      Container(
                                        height: 180,
                                        margin: EdgeInsets.only(left: 24, right: 24),
                                        child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(28)),
                                                  child: controller.cursos?.banner!=null?FancyShimmerImage(
                                                    boxFit: BoxFit.cover,
                                                    imageUrl: controller.cursos?.banner??'',
                                                    width: MediaQuery.of(context!).size.width,
                                                    errorWidget: Icon(Icons.warning_amber_rounded, color: AppTheme.white, size: 105,),
                                                  ):
                                                  Container(),
                                                ),
                                                Opacity(
                                                  opacity: 0.8,
                                                  child:  Container(
                                                    decoration: BoxDecoration(
                                                        color: HexColor(controller.cursos?.color1),
                                                        borderRadius: BorderRadius.all(Radius.circular(26))
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 16,
                                                  top: 0,
                                                  bottom: 0,
                                                  child: Opacity(
                                                    opacity:1,
                                                    child: SvgPicture.asset(AppIcon.ic_curso_exam, width: 150, height: 150,),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(right: 150),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 20, left: 20),
                                                        child:  Material(
                                                          color: HexColor(controller.cursos?.color3),
                                                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                          child: InkWell(
                                                            focusColor: Colors.transparent,
                                                            highlightColor: Colors.transparent,
                                                            hoverColor: Colors.transparent,
                                                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                            splashColor: AppTheme.colorPrimary.withOpacity(0.4),
                                                            onTap: () {

                                                            },
                                                            child:
                                                            Container(
                                                                padding: const EdgeInsets.only(top: 4, left: 10, bottom: 8, right: 10),
                                                                child: Text("Nuevo",
                                                                  style: TextStyle(
                                                                    fontSize: 12,
                                                                    letterSpacing: 0.8,
                                                                    color: AppTheme.white,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontFamily: AppTheme.fontName,
                                                                  ),)
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child:  Container(
                                                            padding: EdgeInsets.only(left: 24, top: 16),
                                                            child: Text("Registro\nde Evaluación\npor competencias",
                                                              maxLines: 3,
                                                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700 ),),
                                                          )
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(left: 24, bottom: 20),
                                                        child: Row(
                                                          children: [
                                                            Text("Haga clic y experimente ", style: TextStyle(color: Colors.white, fontSize: 12)),
                                                            Padding(
                                                                padding: EdgeInsets.all(2)
                                                            ),
                                                            SvgPicture.asset(AppIcon.ic_curso_flecha, color: AppTheme.white, width: 18, height: 18,)
                                                          ],
                                                        ) ,
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ],
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only( top: 24)),
                                      GestureDetector(
                                        onTap: () =>  {
                                          AppRouter.createRouteSesionListaRouter(context!, controller.cursos!)
                                        },
                                        child: Container(
                                          height: 90,
                                          margin: EdgeInsets.only(top: 0,left: 24, right: 24, bottom: 20),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: HexColor(controller.cursos?.color1).withOpacity(0.1),
                                                  width: 2
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(22)),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: HexColor("#E3F8FA"),
                                                    borderRadius: BorderRadius.all(Radius.circular(16))
                                                ),
                                                width: 65,
                                                height: 65,
                                                child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_curso_sesion),),
                                              ),
                                              Padding(padding: EdgeInsets.only(left: 8)),
                                              Expanded(
                                                  child: Text("Sesiones", style: TextStyle(
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 18,
                                                    letterSpacing: 0.8,
                                                    color: AppTheme.darkerText,
                                                  ),)
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 8, right: 28),
                                                child: ClipOval(
                                                  child: Material(
                                                    color: HexColor(controller.cursos?.color1), // button color
                                                    child: InkWell(
                                                      splashColor: HexColor(controller.cursos?.color3), // inkwell color
                                                      child: SizedBox(width: 42, height: 42,
                                                          child: Padding(
                                                          padding: EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 14),
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
                                      GestureDetector(
                                        onTap: () => {
                                          if(context!=null && controller.cursos != null){
                                            AppRouter.createRouteTareaRouter(context, controller.cursos!)
                                          }
                                        },
                                        child:  Container(
                                          height: 90,
                                          margin: EdgeInsets.only(top: 0,left: 24, right: 24, bottom: 20),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:  HexColor(controller.cursos?.color1).withOpacity(0.1),
                                                  width: 2
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(22))
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    color: HexColor("#FFF8EE"),
                                                    borderRadius: BorderRadius.all(Radius.circular(16))
                                                ),
                                                width: 65,
                                                child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_curso_tarea),),
                                              ),
                                              Padding(padding: EdgeInsets.only(left: 8)),
                                              Expanded(
                                                  child: Text("Tareas", style: TextStyle(
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 18,
                                                    letterSpacing: 0.8,
                                                    color: AppTheme.darkerText,
                                                  ),)
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(left: 8, right: 28),
                                                child: ClipOval(
                                                  child: Material(
                                                    color: HexColor(controller.cursos?.color1), // button color
                                                    child: InkWell(
                                                      splashColor: HexColor(controller.cursos?.color3), // inkwell color
                                                      child: SizedBox(width: 42, height: 42,
                                                          child: Padding(
                                                            padding: EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 14),
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
                                      GestureDetector(
                                        onTap: () =>  {
                                          if(context!=null && controller.cursos != null){
                                            AppRouter.createRouteRubrosRouter(context, controller.cursos!)
                                          }
                                        },
                                       child: Container(
                                         height: 90,
                                         margin: EdgeInsets.only(top: 0,left: 24, right: 24, bottom: 20),
                                         decoration: BoxDecoration(
                                             border: Border.all(
                                                 color:  HexColor(controller.cursos?.color1).withOpacity(0.1),
                                                 width: 2
                                             ),
                                             borderRadius: BorderRadius.all(Radius.circular(22))
                                         ),
                                         child: Row(
                                           children: [
                                             Container(
                                               margin: EdgeInsets.all(8),
                                               decoration: BoxDecoration(
                                                   color: HexColor("#EDF8FF"),
                                                   borderRadius: BorderRadius.all(Radius.circular(16))
                                               ),
                                               width: 65,
                                               child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_curso_evaluacion),),
                                             ),
                                             Padding(padding: EdgeInsets.only(left: 8)),
                                             Expanded(
                                                 child: Text("Evaluación", style: TextStyle(
                                                   fontFamily: AppTheme.fontTTNorms,
                                                   fontWeight: FontWeight.w800,
                                                   fontSize: 18,
                                                   letterSpacing: 0.8,
                                                   color: AppTheme.darkerText,
                                                 ),)
                                             ),
                                             Padding(
                                               padding: EdgeInsets.only(left: 8, right: 28),
                                               child: ClipOval(
                                                 child: Material(
                                                   color: HexColor(controller.cursos?.color1), // button color
                                                   child: InkWell(
                                                     splashColor: HexColor(controller.cursos?.color3), // inkwell color
                                                     child: SizedBox(width: 42, height: 42,
                                                         child: Padding(
                                                          padding: EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 14),
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
                                      Container(
                                        height: 90,
                                        margin: EdgeInsets.only(top: 0,left: 24, right: 24, bottom: 20),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: HexColor(controller.cursos?.color1).withOpacity(0.1),
                                                width: 2
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(22))
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: HexColor("#FFECFA"),
                                                  borderRadius: BorderRadius.all(Radius.circular(16))
                                              ),
                                              width: 65,
                                              child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_curso_grupo),),
                                            ),
                                            Padding(padding: EdgeInsets.only(left: 8)),
                                            Expanded(
                                                child: Text("Grupos", style: TextStyle(
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18,
                                                  color: AppTheme.darkerText,
                                                  letterSpacing: 0.8,
                                                ),)
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 8, right: 28),
                                              child: ClipOval(
                                                child: Material(
                                                  color: HexColor(controller.cursos?.color1), // button color
                                                  child: InkWell(
                                                    splashColor: HexColor(controller.cursos?.color3), // inkwell color
                                                    child: SizedBox(width: 42, height: 42,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 14),
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
                                      Container(
                                        height: 90,
                                        margin: EdgeInsets.only(top: 0,left: 24, right: 24, bottom: 20),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: HexColor(controller.cursos?.color1).withOpacity(0.1),
                                                width: 2
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(22))
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: HexColor("#FFECFA"),
                                                  borderRadius: BorderRadius.all(Radius.circular(16))
                                              ),
                                              width: 65,
                                              child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_curso_grupo),),
                                            ),
                                            Padding(padding: EdgeInsets.only(left: 8)),
                                            Expanded(
                                                child: Text("Nota final", style: TextStyle(
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18,
                                                  color: AppTheme.darkerText,
                                                  letterSpacing: 0.8,
                                                ),)
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 16, right: 28),
                                              child: ClipOval(
                                                child: Material(
                                                  color: HexColor(controller.cursos?.color1), // button color
                                                  child: InkWell(
                                                    splashColor: HexColor(controller.cursos?.color3), // inkwell color
                                                    child: SizedBox(width: 42, height: 42,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: 14, right: 14, top: 14, bottom: 14),
                                                          child: SvgPicture.asset(AppIcon.ic_curso_flecha, color: AppTheme.white,),
                                                        )
                                                    ),
                                                    onTap: () {},
                                                  ),
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only( top: 80)),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            })
    );

  }

}