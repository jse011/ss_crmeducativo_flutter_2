import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/sesion_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'dart:math' as math;
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';

import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';

class SesionView extends View{
  CursosUi cursosUi;
  SesionUi sesionUi;
  SesionView(this.cursosUi, this.sesionUi);

  @override
  _CursoViewState createState() => _CursoViewState(cursosUi, sesionUi);

}

class _CursoViewState extends ViewState<SesionView, SesionController> with TickerProviderStateMixin{

  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late AnimationController animationController;
  Function()? statetDialogActividad;

  _CursoViewState(cursoUi, sesionUi) : super(SesionController(cursoUi, sesionUi));

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
                          left: 24,
                          right: 24
                      ),
                      child: DefaultTabController(
                        length: 4,
                        child: Column(
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints.expand(height: 50),
                              child: TabBar(
                                  indicatorColor: AppTheme.colorSesion,
                                  labelColor: AppTheme.colorSesion,
                                  unselectedLabelColor: Colors.grey,
                                  isScrollable: true,
                                  tabs: [
                                Tab(text: "APRENDIZAJE"),
                                Tab(text: "ACTIVIDADES"),
                                Tab(text: "TRABAJOS"),
                                Tab(text: "EVALUACIÓN"),
                              ]),
                            ),
                            Expanded(
                              child: Container(
                                child: TabBarView(children: [
                                  CustomScrollView(
                                    slivers: [
                                      SliverList(
                                          delegate: SliverChildListDelegate([
                                            Container(
                                              margin: EdgeInsets.only(top: 24),
                                              height: 170,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(16))
                                              ),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: AppTheme.colorSesion,
                                                        borderRadius: BorderRadius.all(Radius.circular(12))
                                                    ),
                                                    constraints: BoxConstraints.expand(),
                                                    padding: EdgeInsets.all(24),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [

                                                        Expanded(
                                                            child: Container(),
                                                        ),
                                                        Container(
                                                          alignment: Alignment.bottomLeft,
                                                          child: Text("${controller.sesionUi.titulo}",
                                                            textAlign: TextAlign.start,
                                                            maxLines: 3,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                color: AppTheme.white.withOpacity(0.9),
                                                                fontSize: 22,
                                                                fontFamily: AppTheme.fontTTNorms,
                                                                fontWeight: FontWeight.w700
                                                            ),
                                                          ),
                                                        )

                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: AppTheme.white,
                                                  borderRadius: BorderRadius.all(Radius.circular(6))
                                              ),
                                              margin: EdgeInsets.only(top: 16),
                                              padding: EdgeInsets.all(16),
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${controller.sesionUi.titulo}",
                                                      textAlign: TextAlign.start,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: AppTheme.darkText,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w700
                                                      ),
                                                    ),
                                                    Padding(padding: EdgeInsets.only(top: 16)),
                                                    RichText(
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: AppTheme.darkText,
                                                            height: 1.5
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(text: 'Propósito: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                                                          TextSpan(text: controller.sesionUi.proposito??""),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: AppTheme.white,
                                                  borderRadius: BorderRadius.all(Radius.circular(6))
                                              ),
                                              margin: EdgeInsets.only(top: 16),
                                              padding: EdgeInsets.all(16),
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Competencia Base",
                                                      textAlign: TextAlign.start,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: AppTheme.darkText,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w700
                                                      ),
                                                    ),
                                                    Padding(padding: EdgeInsets.only(top: 16)),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          color: HexColor("#3AB174"),
                                                          padding: EdgeInsets.all(8),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: TextStyle(
                                                                  fontSize: 12.0,
                                                                  color: AppTheme.white,
                                                                  height: 1.5,
                                                                  fontWeight: FontWeight.w400
                                                              ),
                                                              children: <TextSpan>[
                                                                TextSpan(text: 'Competencia:  ', style: new TextStyle(fontWeight: FontWeight.bold)),
                                                                TextSpan(text: "Explica el mundo físico basándose en conocimientos sobre los seres vivos, materia y energía, biodiversidad, tierra y universo."),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          color: AppTheme.white,
                                                          padding: EdgeInsets.all(8),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: TextStyle(
                                                                  fontSize: 12.0,
                                                                  color: AppTheme.darkerText,
                                                                  height: 1.5,
                                                                  fontWeight: FontWeight.w400
                                                              ),
                                                              children: <TextSpan>[
                                                                TextSpan(text: 'Capacidad:  ', style: new TextStyle(fontWeight: FontWeight.bold)),
                                                                TextSpan(text: "Comprende y usa conocimientos sobre los seres vivos, materia y energía, biodiversidad, Tierra y universo"),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          color: AppTheme.grey,
                                                          height: 0.5,
                                                        ),
                                                        Container(
                                                          color: HexColor("#EDECEC"),
                                                          height: 35,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child: Container(
                                                                    alignment: Alignment.center,
                                                                    child: Text("Desempeño",
                                                                      style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          color: AppTheme.darkerText,
                                                                          height: 1.5,
                                                                          fontWeight: FontWeight.w700
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                    alignment: Alignment.center,
                                                                    child: Text("ICDs",
                                                                      style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          color: AppTheme.darkerText,
                                                                          height: 1.5,
                                                                          fontWeight: FontWeight.w700
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          color: AppTheme.grey,
                                                          height: 0.5,
                                                        ),
                                                        Container(
                                                          color: AppTheme.white,
                                                          padding: EdgeInsets.all(8),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Expanded(
                                                                  child: Container(
                                                                    margin: EdgeInsets.only(right: 8),
                                                                    child: Text(
                                                                        "Explica que el suelo está formado por seres vivos y no vivos. Ejemplo: El estudiante distingue lo que hay dentro del suelo, tierra, gusanos, rocas, objetos plásticos, etc Justifica por qué el agua, el aire y el suelo son importantes para los seres vivos. (CN 2017: P1-CT-C25-D5) Explica que un sistema puede describirse en términos de sus interacciones. ¿Cómo te relacionas con los demás? ¿Cómo debemos"
                                                                        ,style: TextStyle(
                                                                      fontSize: 12.0,
                                                                      color: AppTheme.darkerText,
                                                                      height: 1.5,
                                                                      fontWeight: FontWeight.w400,
                                                                    ),
                                                                        textAlign: TextAlign.justify
                                                                    ),
                                                                  ),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      child: Text("01. Explica que el suelo",
                                                                        style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          color: AppTheme.darkerText,
                                                                          height: 1.5,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(left: 20),
                                                                      child: Text("a. ECOSISTEMAS: INTERACCIONES, ENERGÍA, Y DINÁMICA",
                                                                        textAlign: TextAlign.justify,
                                                                        style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          color: AppTheme.darkerText,
                                                                          height: 1.5,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(left: 30),
                                                                      child: Text("* Nuestra necesidades básicas.",
                                                                        style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          color: AppTheme.darkerText,
                                                                          height: 1.5,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: Text("01. Explica que el suelo",
                                                                        style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          color: AppTheme.darkerText,
                                                                          height: 1.5,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(left: 20),
                                                                      child: Text("a. ECOSISTEMAS: INTERACCIONES, ENERGÍA, Y DINÁMICA",
                                                                        textAlign: TextAlign.justify,
                                                                        style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          color: AppTheme.darkerText,
                                                                          height: 1.5,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(left: 30),
                                                                      child: Text("* Nuestra necesidades básicas.",
                                                                        style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          color: AppTheme.darkerText,
                                                                          height: 1.5,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: AppTheme.white,
                                                  borderRadius: BorderRadius.all(Radius.circular(6))
                                              ),
                                              margin: EdgeInsets.only(top: 16),
                                              padding: EdgeInsets.all(16),
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Competencia Transversal",
                                                      textAlign: TextAlign.start,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: AppTheme.darkText,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w700
                                                      ),
                                                    ),
                                                    Padding(padding: EdgeInsets.only(top: 16)),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          color: HexColor("#3AB174"),
                                                          padding: EdgeInsets.all(8),
                                                          child: Row(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          color: AppTheme.white,
                                                                          height: 1.5,
                                                                          fontWeight: FontWeight.w400
                                                                      ),
                                                                      children: <TextSpan>[
                                                                        TextSpan(text: 'Competencia:  ', style: new TextStyle(fontWeight: FontWeight.bold)),
                                                                        TextSpan(text: "Servicio Cristiano (Orientación al Bien Común)"),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          color: AppTheme.white,
                                                          padding: EdgeInsets.all(8),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              style: TextStyle(
                                                                  fontSize: 12.0,
                                                                  color: AppTheme.darkerText,
                                                                  height: 1.5,
                                                                  fontWeight: FontWeight.w400
                                                              ),
                                                              children: <TextSpan>[
                                                                TextSpan(text: 'Capacidad:  ', style: new TextStyle(fontWeight: FontWeight.bold)),
                                                                TextSpan(text: "Demostrar Empatía - Servicio/Convivencia"),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          color: AppTheme.grey,
                                                          height: 0.5,
                                                        ),
                                                        Container(
                                                          color: HexColor("#EDECEC"),
                                                          height: 35,
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child: Container(
                                                                    alignment: Alignment.center,
                                                                    child: Text("Desempeño",
                                                                      style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          color: AppTheme.darkerText,
                                                                          height: 1.5,
                                                                          fontWeight: FontWeight.w700
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                              Expanded(
                                                                  child: Container(
                                                                      alignment: Alignment.center,
                                                                    child: Text("ICDs",
                                                                        style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          color: AppTheme.darkerText,
                                                                          height: 1.5,
                                                                          fontWeight: FontWeight.w700
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          color: AppTheme.grey,
                                                          height: 0.5,
                                                        ),
                                                        Container(
                                                          color: AppTheme.white,
                                                          padding: EdgeInsets.all(8),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Expanded(
                                                                child: Container(
                                                                  margin: EdgeInsets.only(right: 8),
                                                                  child: Text(
                                                                      "Identificación afectiva con los sentimientos del otro y disposición para apoyar y comprender sus circunstancias. Se demuestra por ejemplo cuando los docentes identifican, valoran y destacan continuamente actos espontáneos de los estudiantes en beneficio de otros, dirigidos a procurar o restaurar su bienestar en situaciones que lo requieran."
                                                                      ,style: TextStyle(
                                                                    fontSize: 12.0,
                                                                    color: AppTheme.darkerText,
                                                                    height: 1.5,
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                      textAlign: TextAlign.justify
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      child: Text("01. Disposición a escuchar, comprender y ayudar afectivamente problemas de otras personas",
                                                                        style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          color: AppTheme.darkerText,
                                                                          height: 1.5,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(left: 20),
                                                                      child: Text("a. Valores",
                                                                        textAlign: TextAlign.justify,
                                                                        style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          color: AppTheme.darkerText,
                                                                          height: 1.5,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(left: 30),
                                                                      child: Text("Empatía",
                                                                        style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          color: AppTheme.darkerText,
                                                                          height: 1.5,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: AppTheme.white,
                                                  borderRadius: BorderRadius.all(Radius.circular(6))
                                              ),
                                              margin: EdgeInsets.only(top: 16),
                                              padding: EdgeInsets.all(16),
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Campos Temáticos",
                                                      textAlign: TextAlign.start,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: AppTheme.darkText,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w700
                                                      ),
                                                    ),
                                                    Padding(padding: EdgeInsets.only(top: 16)),
                                                    Row(
                                                        children: [
                                                          Icon(Icons.add),
                                                          Padding(padding: EdgeInsets.all(4)),
                                                          Expanded(
                                                              child: Text(
                                                                  "1. ECOSISTEMAS: INTERACCIONES, ENERGÍA, Y DINÁMICA",
                                                                  style: TextStyle(
                                                                    fontSize: 12.0,
                                                                    color: AppTheme.darkerText,
                                                                    height: 1.5,
                                                                    fontWeight: FontWeight.w400,
                                                                  )
                                                              ),
                                                          )
                                                        ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.add),
                                                        Padding(padding: EdgeInsets.all(4)),
                                                        Expanded(
                                                          child: Text(
                                                              "1. ECOSISTEMAS: INTERACCIONES, ENERGÍA, Y DINÁMICA",
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: AppTheme.darkerText,
                                                                height: 1.5,
                                                                fontWeight: FontWeight.w400,
                                                              )
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.add),
                                                        Padding(padding: EdgeInsets.all(4)),
                                                        Expanded(
                                                          child: Text(
                                                              "1. ECOSISTEMAS: INTERACCIONES, ENERGÍA, Y DINÁMICA",
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: AppTheme.darkerText,
                                                                height: 1.5,
                                                                fontWeight: FontWeight.w400,
                                                              )
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.only(bottom: 200),)
                                          ])
                                      ),
                                    ],
                                  ),
                                  CustomScrollView(
                                    slivers: [

                                      SliverList(
                                          delegate: SliverChildListDelegate([
                                            GestureDetector(
                                              onTap: () =>  {
                                                showActivdadDocente(context)
                                              },
                                              child: Container(
                                                height: 90,
                                                margin: EdgeInsets.only(top: 16,left: 16, right: 0, bottom: 20),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                                                        width: 2
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                    color: HexColor(controller.cursosUi.color3).withOpacity(0.1)
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(right: 8, left: 16, top: 8, bottom: 8),
                                                      decoration: BoxDecoration(
                                                          color: HexColor(controller.cursosUi.color1).withOpacity(1),
                                                          borderRadius: BorderRadius.all(Radius.circular(16))
                                                      ),
                                                      width: 65,
                                                      height: 65,
                                                      child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_tipo_actividad_conecta),),
                                                    ),
                                                    Padding(padding: EdgeInsets.only(left: 8)),
                                                    Expanded(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("CONECTA TU MENTE",
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  fontWeight: FontWeight.w800,
                                                                  fontSize: 14,
                                                                  letterSpacing: 0.8,
                                                                  color: AppTheme.darkerText,
                                                                )),
                                                            Padding(padding: EdgeInsets.all(4),),
                                                            Text("Inicio",
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  letterSpacing: 0.8,
                                                                  color: AppTheme.darkerText,
                                                                ))
                                                          ],
                                                        )
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 16, right: 16),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(25)),
                                                          color: Colors.white,
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: true
                                                              ? Icon(
                                                            Icons.check_outlined,
                                                            size: 25.0,
                                                            color: HexColor(controller.cursosUi.color1),
                                                          )
                                                              : Container(width: 25, height: 25,),
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () =>  {
                                                showActivdadDocente(context)
                                              },
                                              child: Container(
                                                height: 90,
                                                margin: EdgeInsets.only(top: 4,left: 16, right: 0, bottom: 20),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                                                        width: 2
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                    color: HexColor(controller.cursosUi.color3).withOpacity(0.1)
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(right: 8, left: 16, top: 8, bottom: 8),
                                                      decoration: BoxDecoration(
                                                          color: HexColor(controller.cursosUi.color1).withOpacity(1),
                                                          borderRadius: BorderRadius.all(Radius.circular(16))
                                                      ),
                                                      width: 65,
                                                      height: 65,
                                                      child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_tipo_actividad_conecta),),
                                                    ),
                                                    Padding(padding: EdgeInsets.only(left: 8)),
                                                    Expanded(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("EXPLORANDO Y EXPLICANDO",
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontFamily: AppTheme.fontTTNorms,
                                                                fontWeight: FontWeight.w800,
                                                                fontSize: 14,
                                                                letterSpacing: 0.8,
                                                                color: AppTheme.darkerText,
                                                              ),),
                                                            Padding(padding: EdgeInsets.all(4),),
                                                            Text("Desarrollo",
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  letterSpacing: 0.8,
                                                                  color: AppTheme.darkerText,
                                                                ))
                                                          ],
                                                        )
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 16, right: 16),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(25)),
                                                          color: Colors.white,
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: true
                                                              ? Icon(
                                                            Icons.check_outlined,
                                                            size: 25.0,
                                                            color: HexColor(controller.cursosUi.color1),
                                                          )
                                                              : Container(width: 25, height: 25,),
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () =>  {
                                                showActivdadDocente(context)
                                              },
                                              child: Container(
                                                height: 90,
                                                margin: EdgeInsets.only(top: 8,left: 16, right: 0, bottom: 20),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: HexColor(controller.cursosUi.color1).withOpacity(0.5),
                                                        width: 2
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                    color: HexColor(controller.cursosUi.color2).withOpacity(0.5)
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(right: 8, left: 16, top: 8, bottom: 8),
                                                      decoration: BoxDecoration(
                                                          color: HexColor(controller.cursosUi.color1).withOpacity(1),
                                                          borderRadius: BorderRadius.all(Radius.circular(16))
                                                      ),
                                                      width: 65,
                                                      height: 65,
                                                      child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_tipo_actividad_conecta),),
                                                    ),
                                                    Padding(padding: EdgeInsets.only(left: 8)),
                                                    Expanded(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("APLICA/REFLEXIONA",
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontFamily: AppTheme.fontTTNorms,
                                                                fontWeight: FontWeight.w800,
                                                                fontSize: 14,
                                                                letterSpacing: 0.8,
                                                                color: AppTheme.darkerText,
                                                              ),),
                                                            Padding(padding: EdgeInsets.all(4),),
                                                            Text("Desarrollo",
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  letterSpacing: 0.8,
                                                                  color: AppTheme.darkerText,
                                                                ))
                                                          ],
                                                        )
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.all(1),
                                                      padding: EdgeInsets.only(left: 16, right: 16),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(25)),
                                                          border: Border.all(
                                                              color: HexColor(controller.cursosUi.color1).withOpacity(0.5),
                                                              width: 2
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: true
                                                              ? Icon(
                                                            Icons.check_outlined,
                                                            size: 25.0,
                                                            color: HexColor(controller.cursosUi.color1),
                                                          )
                                                              : Icon(
                                                            Icons.check_box_outline_blank,
                                                            size: 20.0,
                                                            color: Colors.blue,
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
                                                showActivdadDocente(context)
                                              },
                                              child: Container(
                                                height: 90,
                                                margin: EdgeInsets.only(top: 8,left: 16, right: 0, bottom: 20),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                                                        width: 2
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                    color: HexColor(controller.cursosUi.color3).withOpacity(0.1)
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(right: 8, left: 16, top: 8, bottom: 8),
                                                      decoration: BoxDecoration(
                                                          color: HexColor(controller.cursosUi.color1).withOpacity(1),
                                                          borderRadius: BorderRadius.all(Radius.circular(16))
                                                      ),
                                                      width: 65,
                                                      height: 65,
                                                      child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_tipo_actividad_conecta),),
                                                    ),
                                                    Padding(padding: EdgeInsets.only(left: 8)),
                                                    Expanded(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("INSTRUMENTO DE EVALUACIÓN",
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontFamily: AppTheme.fontTTNorms,
                                                                fontWeight: FontWeight.w800,
                                                                fontSize: 14,
                                                                letterSpacing: 0.8,
                                                                color: AppTheme.darkerText,
                                                              ),),
                                                            Padding(padding: EdgeInsets.all(4),),
                                                            Text("Desarrollo",
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  letterSpacing: 0.8,
                                                                  color: AppTheme.darkerText,
                                                                ))
                                                          ],
                                                        )
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 16, right: 16),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(25)),
                                                          color: Colors.white,
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: false
                                                              ? Icon(
                                                            Icons.check_outlined,
                                                            size: 25.0,
                                                            color: HexColor(controller.cursosUi.color1),
                                                          )
                                                              : Container(width: 25, height: 25,),
                                                        ),
                                                      ),

                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () =>  {
                                                showActivdadDocente(context)
                                              },
                                              child: Container(
                                                height: 90,
                                                margin: EdgeInsets.only(top: 8,left: 16, right: 0, bottom: 20),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                                                        width: 2
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                    color: HexColor(controller.cursosUi.color3).withOpacity(0.1)
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(right: 8, left: 16, top: 8, bottom: 8),
                                                      decoration: BoxDecoration(
                                                          color: HexColor(controller.cursosUi.color1).withOpacity(1),
                                                          borderRadius: BorderRadius.all(Radius.circular(16))
                                                      ),
                                                      width: 65,
                                                      height: 65,
                                                      child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_tipo_actividad_conecta),),
                                                    ),
                                                    Padding(padding: EdgeInsets.only(left: 8)),
                                                    Expanded(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("EVALUACIÓN",
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                fontFamily: AppTheme.fontTTNorms,
                                                                fontWeight: FontWeight.w800,
                                                                fontSize: 14,
                                                                letterSpacing: 0.8,
                                                                color: AppTheme.darkerText,
                                                              ),),
                                                            Padding(padding: EdgeInsets.all(4),),
                                                            Text("Cierre",
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  letterSpacing: 0.8,
                                                                  color: AppTheme.darkerText,
                                                                ))
                                                          ],
                                                        )
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 16, right: 16),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(25)),
                                                          color: Colors.white,
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: false
                                                              ? Icon(
                                                            Icons.check_outlined,
                                                            size: 25.0,
                                                            color: HexColor(controller.cursosUi.color1),
                                                          )
                                                              : Container(width: 25, height: 25,),
                                                        ),
                                                      ),

                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                          ])
                                      ),
                                      SliverList(
                                          delegate: SliverChildListDelegate([
                                            Container(
                                              padding: EdgeInsets.only(top: 32, left: 8, right: 8),
                                              child: Text("TRABAJOS", style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: AppTheme.fontTTNorms
                                              ),),
                                            ),
                                          ])
                                      ),
                                      SliverPadding(
                                        padding: EdgeInsets.only(left: 8, right: 0, top: 16),
                                        sliver: SliverGrid(
                                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                            //crossAxisCount: countRow,
                                            maxCrossAxisExtent: 160.0,
                                            mainAxisExtent: 160.0,
                                            mainAxisSpacing: 24.0,
                                            crossAxisSpacing: 24.0,
                                            childAspectRatio: 1,
                                          ),
                                          delegate: SliverChildBuilderDelegate(
                                                  (BuildContext context, int index){
                                                if(index == 0){
                                                  return Container(
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
                                                        color: HexColor(controller.cursosUi.color2),
                                                        alignment: Alignment.center,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(Ionicons.add, color: AppTheme.white, size: 45,),
                                                            Text("Crear Tarea",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w800,
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  color: AppTheme.white
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }else{
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        color: HexColor(controller.cursosUi.color3??"#FEFAE2").withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(14) // use instead of BorderRadius.all(Radius.circular(20))
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 12, right: 16, top: 16, bottom: 0),
                                                          child: Row(
                                                            children: [
                                                              Icon(Icons.assignment, color: HexColor(controller.cursosUi.color1), size: 18,),
                                                              Padding(padding: EdgeInsets.all(2)),
                                                              Text("Tarea ${index+1}",
                                                                style: TextStyle(
                                                                    color: HexColor(controller.cursosUi.color1),
                                                                    fontSize: 12),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 0),
                                                          child: Text("APRENDEMOS ADIVINANZAS", style: TextStyle(color: AppTheme.black, fontSize: 12),),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 0),
                                                          child: Text("Pare el Dom 11 de Abr. 09:11 p. m.", style: TextStyle(fontSize: 10),),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 8),
                                                          child: Row(
                                                            children: [
                                                              Expanded(child: Text("Sin Publicar", style: TextStyle(color: AppTheme.colorPrimary, fontSize: 12),),),
                                                              Text("0/15", style: TextStyle(color: AppTheme.colorPrimary, fontSize: 12),),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }

                                              },
                                              childCount: 2
                                          ),
                                        ),
                                      ),
                                      SliverList(
                                          delegate: SliverChildListDelegate(
                                            [
                                              Padding(padding: EdgeInsets.only( top: 150)),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                  CustomScrollView(
                                    slivers: [
                                      SliverPadding(
                                        padding: EdgeInsets.only(left: 8, right: 0, top: 16),
                                        sliver: SliverGrid(
                                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                            //crossAxisCount: countRow,
                                            maxCrossAxisExtent: 160.0,
                                            mainAxisExtent: 160.0,
                                            mainAxisSpacing: 24.0,
                                            crossAxisSpacing: 24.0,
                                            childAspectRatio: 1,
                                          ),
                                          delegate: SliverChildBuilderDelegate(
                                                  (BuildContext context, int index){
                                                if(index == 0){
                                                  return Container(
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
                                                        color: HexColor(controller.cursosUi.color2),
                                                        alignment: Alignment.center,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(Ionicons.add, color: AppTheme.white, size: 45,),
                                                            Text("Crear Tarea",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.w800,
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  color: AppTheme.white
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }else{
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        color: HexColor(controller.cursosUi.color3??"#FEFAE2").withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(14) // use instead of BorderRadius.all(Radius.circular(20))
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 12, right: 16, top: 16, bottom: 0),
                                                          child: Row(
                                                            children: [
                                                              Icon(Icons.assignment, color: HexColor(controller.cursosUi.color1), size: 18,),
                                                              Padding(padding: EdgeInsets.all(2)),
                                                              Text("Tarea ${index+1}",
                                                                style: TextStyle(
                                                                    color: HexColor(controller.cursosUi.color1),
                                                                    fontSize: 12),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 0),
                                                          child: Text("APRENDEMOS ADIVINANZAS", style: TextStyle(color: AppTheme.black, fontSize: 12),),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 0),
                                                          child: Text("Pare el Dom 11 de Abr. 09:11 p. m.", style: TextStyle(fontSize: 10),),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 8),
                                                          child: Row(
                                                            children: [
                                                              Expanded(child: Text("Sin Publicar", style: TextStyle(color: AppTheme.colorPrimary, fontSize: 12),),),
                                                              Text("0/15", style: TextStyle(color: AppTheme.colorPrimary, fontSize: 12),),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }

                                              },
                                              childCount: 2
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    child: Text("User Body"),
                                  ),
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

  void showActivdadDocente(BuildContext context) {
    SesionController controller =
    FlutterCleanArchitecture.getController<SesionController>(context, listen: false);

    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              statetDialogActividad = (){
                setState((){});
              };
              controller.addListener(statetDialogActividad!);
              bool isLandscape = context.isLandscape;
              return Container(
                height: MediaQuery.of(context).size.height * (isLandscape?1:0.7),
                child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: new BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: Container(
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(this.context).padding.top,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                  top: 16 - 8.0,
                                  bottom: 12 - 8.0),
                              child:   Stack(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(top: 0, bottom: 8, left: 8, right: 32),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 8, left: 16, top: 0, bottom: 8),
                                          decoration: BoxDecoration(
                                              color: HexColor(controller.cursosUi.color1).withOpacity(1),
                                              borderRadius: BorderRadius.all(Radius.circular(16))
                                          ),
                                          width: 50,
                                          height: 50,
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: SvgPicture.asset(AppIcon.ic_tipo_actividad_conecta),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 12, top: 8),
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("CONECTA TU MENTE",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontTTNorms,
                                                      fontWeight: FontWeight.w800,
                                                      fontSize: 14,
                                                      letterSpacing: 0.8,
                                                      color: AppTheme.darkerText,
                                                    )),
                                                Padding(padding: EdgeInsets.all(4),),
                                                Text("Inicio - 10 min.",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      letterSpacing: 0.8,
                                                      color: AppTheme.darkerText,
                                                    ))
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 10,
                                    child: ClipOval(
                                      child: Material(
                                        color: AppTheme.colorPrimary.withOpacity(0.1), // button color
                                        child: InkWell(
                                          splashColor: AppTheme.colorPrimary, // inkwell color
                                          child: SizedBox(width: 43 + 6, height: 43 + 6,
                                            child: Icon(Ionicons.close, size: 24 + 6,color: AppTheme.colorPrimary, ),
                                          ),
                                          onTap: () {

                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: CustomScrollView(
                                  scrollDirection: Axis.vertical,
                                  slivers: <Widget>[
                                    SliverPadding(
                                      padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
                                      sliver: SliverList(
                                          delegate: SliverChildListDelegate([
                                            Text("Bienvenido apreciado estudiante a la PLATAFORMA EDUCAR; iniciaremos conectándonos primero con nuestro padre celestial y meditando en las enseñanzas bíblicas. ",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  height: 1.4
                                              ),
                                            ),
                                          ])
                                      ),
                                    ),
                                    SliverPadding(
                                      padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
                                      sliver: SliverList(
                                          delegate: SliverChildListDelegate([
                                            Stack(
                                              children: [
                                               Positioned(
                                                   child:  Text("1.1",
                                                       style: TextStyle(
                                                           fontSize: 14,
                                                           height: 1.4,
                                                           fontWeight: FontWeight.bold
                                                       )
                                                   ),
                                               ),
                                               Positioned(
                                                   child: Padding(
                                                     padding: EdgeInsets.only(left: 40),
                                                     child: Text("GUÍA AUTÓNOMA: Te invito a revisar la:  que es la parte TEÓRICA que como maestro te daré para esta clase virtual. Revisa los conceptos y ejemplos que te daré en la video conferencia, que han sido especialmente diseñadas para apoyar tu aprendizaje. Tienes que estar muy atento y listo para responder las preguntas que haré en el chat virtual de la de la PLATAFORMA EDUCAR. Te ánimo a comunicar tus dudas e inquietudes.    ",
                                                       style: TextStyle(
                                                           fontSize: 14,
                                                           height: 1.4
                                                       ),),
                                                   )
                                               )
                                              ],
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(top: 24),
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      child:  Text("1.2",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              height: 1.4,
                                                              fontWeight: FontWeight.bold
                                                          )
                                                      ),
                                                    ),
                                                    Positioned(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: 40),
                                                          child: Text("PRACTICA DIRIGIDA: Descarga la ficha de trabajo, si es posible imprime:  y escribe la solución en la Ficha de acuerdo a lo que se indique en el desarrollo de la clase y de la explicación en la videoconferencia que la puedes volver a ver si deseas en la grabación.      ",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                height: 1.4
                                                            ),),
                                                        )
                                                    )
                                                  ],
                                                ),
                                            )
                                          ])
                                      ),
                                    ),
                                    SliverPadding(
                                      padding: EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 16),
                                      sliver: SliverList(
                                          delegate: SliverChildListDelegate([
                                            Padding(
                                              padding: EdgeInsets.only(top: 0),
                                              child: Row(
                                                children: [
                                                  Padding(padding: EdgeInsets.all(4),),
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      primary: Colors.blue,
                                                    ),
                                                    onPressed: () { },
                                                    child: Text('Atras'),
                                                  ),
                                                  Expanded(child: Container())
                                                  ,TextButton(
                                                    style: TextButton.styleFrom(
                                                      primary: Colors.blue,
                                                    ),
                                                    onPressed: () { },
                                                    child: Text('Siguiente'),
                                                  )
                                                ],
                                              ),
                                            )
                                          ])
                                      ),
                                    ),
                                  ]
                              ),
                            )
                          ],
                        ),
                        if(true)
                          Center(
                            child: CircularProgressIndicator(),
                          )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        })
        .then((value) => {
      if(statetDialogActividad!=null)controller.removeListener(statetDialogActividad!), statetDialogActividad = null
    });
  }

}