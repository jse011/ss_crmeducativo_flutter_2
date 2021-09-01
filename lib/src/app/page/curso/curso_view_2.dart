
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/src/app/page/curso/curso_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/animation_view.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';

class CursoView extends View{
  @override
  _CursoViewState createState() => _CursoViewState();

}

class _CursoViewState extends ViewState<CursoView, CursoController> with TickerProviderStateMixin{
  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late AnimationController animationController;

  _CursoViewState()
      : super(CursoController(CursosUi(), MoorConfiguracionRepository()));

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
  Widget get view =>  Container(
    color: AppTheme.background,
    child: Scaffold(
      backgroundColor: HexColor("#FFFFFF"),
      body: Stack(
        children: <Widget>[
          getMainTab(),
          getAppBarUI(),
        ],
      ),
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
                        child: Row(
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
                                      'Hi sanskriti',
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
                                      'Welcome Back!',
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
                                color: HexColor("#E7F7FE"), // button color
                                child: InkWell(
                                  splashColor: HexColor("#F2F2F2"), // inkwell color
                                  child: SizedBox(width: 45 + 6 - 8 * topBarOpacity, height: 45 + 6 - 8 * topBarOpacity,
                                      child: Icon(Ionicons.mail_open_outline, size: 30,color: HexColor("#2F3176"),)),
                                  onTap: () {},
                                ),
                              ),
                            )
                          ],
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

  int countView = 4;
  Widget getMainTab() {
    return Container(
        padding: EdgeInsets.only(
          top: AppBar().preferredSize.height +
              MediaQuery.of(context).padding.top +
              0,
        ),
        child: ControlledWidgetBuilder<CursoController>(
            builder: (context, controller) {
              return Stack(
                children: [
                  CustomScrollView(
                    controller: scrollController,
                    slivers: <Widget>[
                      SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Padding(padding: EdgeInsets.only( top: 48)),
                              Container(
                                height: 180,
                                  margin: EdgeInsets.only(left: 24, right: 24),
                                  decoration: BoxDecoration(
                                      color: HexColor("#2F3176"),
                                      borderRadius: BorderRadius.all(Radius.circular(28))
                                  ),

                              ),
                              Padding(padding: EdgeInsets.only( top: 24)),
                              Container(
                                height: 90,
                                margin: EdgeInsets.only(top: 0,left: 24, right: 24, bottom: 20),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: HexColor("#2F3176").withOpacity(0.1),
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
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 8)),
                                    Expanded(
                                        child: Text("Homework", style: TextStyle(
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                          letterSpacing: 0.5,
                                          color: AppTheme.darkerText,
                                        ),)
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8, right: 28),
                                      child: ClipOval(
                                        child: Material(
                                          color: HexColor("#2F3176"), // button color
                                          child: InkWell(
                                            splashColor: HexColor("#2F3176"), // inkwell color
                                            child: SizedBox(width: 42, height: 42,
                                                child: Icon(Ionicons.return_down_forward_outline, size: 24,color: Colors.white,)),
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
                                        color: HexColor("#2F3176").withOpacity(0.1),
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
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 8)),
                                    Expanded(
                                        child: Text("Materials", style: TextStyle(
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                          letterSpacing: 0.5,
                                          color: AppTheme.darkerText,
                                        ),)
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8, right: 28),
                                      child: ClipOval(
                                        child: Material(
                                          color: HexColor("#2F3176"), // button color
                                          child: InkWell(
                                            splashColor: HexColor("#2F3176"), // inkwell color
                                            child: SizedBox(width: 42, height: 42,
                                                child: Icon(Ionicons.return_down_forward_outline, size: 24,color: Colors.white,)),
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
                                        color: HexColor("#2F3176").withOpacity(0.1),
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
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 8)),
                                    Expanded(
                                        child: Text("Classes", style: TextStyle(
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                          letterSpacing: 0.5,
                                          color: AppTheme.darkerText,
                                        ),)
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8, right: 28),
                                      child: ClipOval(
                                        child: Material(
                                          color: HexColor("#2F3176"), // button color
                                          child: InkWell(
                                            splashColor: HexColor("#2F3176"), // inkwell color
                                            child: SizedBox(width: 42, height: 42,
                                                child: Icon(Ionicons.return_down_forward_outline, size: 24,color: Colors.white,)),
                                            onTap: () {},
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Container(
                                height: 100,
                                margin: EdgeInsets.only(top: 0,left: 24, right: 24, bottom: 24),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: HexColor("#2F3176").withOpacity(0.1),
                                        width: 2
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: HexColor("#EDF8FF"),
                                          borderRadius: BorderRadius.all(Radius.circular(15))
                                      ),
                                      width: 75,
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 8)),
                                    Expanded(
                                        child: Text("Homework", style: TextStyle(
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                          letterSpacing: 0.5,
                                          color: AppTheme.darkerText,
                                        ),)
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8, right: 28),
                                      child: ClipOval(
                                        child: Material(
                                          color: HexColor("#2F3176"), // button color
                                          child: InkWell(
                                            splashColor: HexColor("#2F3176"), // inkwell color
                                            child: SizedBox(width: 45, height: 45,
                                                child: Icon(Ionicons.return_down_forward_outline, size: 30,color: Colors.white,)),
                                            onTap: () {},
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.only( top: 800)),
                            ],
                          )
                      ),
                    ],
                  ),
                ],
              );
            })
    );

  }

}