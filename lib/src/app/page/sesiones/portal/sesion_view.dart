import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/sesion_controller.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/tab/tab_actividades.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/tab/tab_aprendizaje.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/tab/tab_rubros.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/tab/tab_tareas.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_unidad_tarea_repositoy.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';

import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';

class SesionView extends View{
  CursosUi cursosUi;
  SesionUi sesionUi;
  CalendarioPeriodoUI calendarioPeriodoUI;
  SesionView(this.cursosUi, this.sesionUi, this.calendarioPeriodoUI);

  @override
  _CursoViewState createState() => _CursoViewState(cursosUi, sesionUi, calendarioPeriodoUI);

}

class _CursoViewState extends ViewState<SesionView, SesionController> with TickerProviderStateMixin{

  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late AnimationController animationController;


  _CursoViewState(cursoUi, sesionUi, calendarioPeriodoUI) : super(SesionController(cursoUi, sesionUi, calendarioPeriodoUI, MoorConfiguracionRepository(), DeviceHttpDatosRepositorio(), MoorUnidadTareaRepository(), MoorRubroRepository()));

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
    _pageController.dispose();
    super.dispose();
  }

  int _seletedItem = 0;
  bool result = true;
  PageController _pageController = PageController();

  Widget get view => Scaffold(
    extendBody: true,
    backgroundColor: AppTheme.background,
    body: Stack(
      children: [
        getMainTab(),
        getAppBarUI(),
      ],
    )
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
                        child: ControlledWidgetBuilder<SesionController>(
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
                                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(AppIcon.ic_curso_sesion, height: 35 +  6 - 8 * topBarOpacity, width: 35 +  6 - 8 * topBarOpacity,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 12, top: 8),
                                        child: Text(
                                          'Sesión ${controller.sesionUi.nroSesion}',
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
    return  AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext? context, Widget? child) {
        return FadeTransition(
          opacity: topBarAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
            child: ControlledWidgetBuilder<SesionController>(
                builder: (context, controller) {
                  return Container(
                      padding: EdgeInsets.only(
                          top: AppBar().preferredSize.height +
                              MediaQuery.of(context).padding.top +
                              16,
                          left: 0,
                          right: 0
                      ),
                      child: DefaultTabController(
                        length: 4,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 24),
                              constraints: BoxConstraints.expand(height: 50),
                              child: TabBar(
                                  indicatorColor: AppTheme.colorSesion,
                                  labelColor: AppTheme.colorSesion,
                                  unselectedLabelColor: Colors.grey,
                                  isScrollable: true,
                                  tabs: [
                                Tab(text: "APRENDIZAJE"),
                                Tab(text: "ACTIVIDADES"),
                                Tab(text: "EVALUACIÓN"),
                                Tab(text: "TRABAJOS"),
                              ]),
                            ),
                            Expanded(
                              child: Container(
                                child: TabBarView(children: [
                                  TabAprendizaje(),
                                  TabActividades(),
                                  TabRubros(),
                                  TabTareas(),

                                ]),
                              ),
                            )
                          ],
                        ),
                      )
                  );
                }),
          ),
        );
      },
    );
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


}