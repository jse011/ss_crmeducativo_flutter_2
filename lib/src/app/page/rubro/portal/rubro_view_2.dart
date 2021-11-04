import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/example/main.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_v2.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/portal/rubro_controller.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/resultado/table_resultado.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_info_devices.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/Item_rubro.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_calendario_periodo_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_resultado_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_calendario_periodo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'dart:math' as math;

import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';

class RubroView2 extends View {
  CursosUi cursosUi;

  RubroView2(this.cursosUi);

  @override
  RubroViewState createState() => RubroViewState(this.cursosUi);

}

class RubroViewState extends ViewState<RubroView2, RubroController> with TickerProviderStateMixin{
  Function()? statetDialogRubroSesion;

  RubroViewState(cursosUi) : super(RubroController(cursosUi, MoorCalendarioPeriodoRepository(), MoorConfiguracionRepository(), DeviceHttpDatosRepositorio(), MoorRubroRepository(), MoorResultadoRepository()));

  late Animation<double> topBarAnimation;
  late final ScrollControllers scrollControllersProceso = ScrollControllers();
  late final ScrollControllers scrollControllersResultado = ScrollControllers();
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late AnimationController animationController;
  int? _seletedItem = 0;

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

  bool result = true;
  PageController _pageController = PageController();

  Widget get view => ControlledWidgetBuilder<RubroController>(
      builder: (context, controller) {
        return Stack(
          children: [
            Scaffold(
              extendBody: true,
              body: Stack(
                children: [
                  getMainTab(),
                  getAppBarUI(),
                ],
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(100),
                          topLeft: Radius.circular(100),
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12, spreadRadius: 0, blurRadius: 10),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100.0),
                          topRight: Radius.circular(100.0),
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100)),
                      child: BottomNavigationBar(
                        selectedItemColor: Theme.of(context).primaryColor,
                        unselectedItemColor: Colors.grey[500],
                        items: [
                          // ignore: deprecated_member_use
                          BottomNavigationBarItem(
                            // ignore: deprecated_member_use
                              icon: Container(),
                              // ignore: deprecated_member_use
                              title: Text('Rúbrica')),
                          /* BottomNavigationBarItem(
                      // ignore: deprecated_member_use
                        icon: Container(),
                        // ignore: deprecated_member_use
                        title: Text('Sesión')),*/
                          BottomNavigationBarItem(
                            // ignore: deprecated_member_use
                              icon: Container(),
                              // ignore: deprecated_member_use
                              title: Text('Registro')),
                          BottomNavigationBarItem(
                            // ignore: deprecated_member_use
                              icon: Container(),
                              // ignore: deprecated_member_use
                              title: Text('Resultado')),
                        ],
                        currentIndex: controller.seletedItem,
                        onTap: (index) {
                          controller.onChangeTab(index);
                          _pageController.jumpToPage(controller.seletedItem);
                        },
                      ),
                    )),
              ),
            ),
            if(controller.progress && (controller.seletedItem == 1||controller.seletedItem == 0))ArsProgressWidget(
              blur: 2,
              backgroundColor: Color(0x33000000),
              animationDuration: Duration(milliseconds: 500),
            ),
            if(controller.progressResultado && (controller.seletedItem == 2))ArsProgressWidget(
              blur: 2,
              backgroundColor: Color(0x33000000),
              animationDuration: Duration(milliseconds: 500),
            ),
            if(controller.showDialogModoOffline)
              ArsProgressWidget(
                blur: 2,
                backgroundColor: Color(0x33000000),
                animationDuration: Duration(milliseconds: 500),
                loadingWidget:  Card(
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
                              child: Icon(Ionicons.cellular_outline, size: 35, color: AppTheme.white,),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.yellowDarken3),
                            ),
                            Padding(padding: EdgeInsets.all(8)),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsets.all(4),),
                                    Text("Señal Lenta", style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppTheme.fontTTNormsMedium
                                    ),),
                                    Padding(padding: EdgeInsets.all(8),),
                                    Text("Trabajar sin conexión a internet",
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
                                controller.onClicContinuarOffline();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: AppTheme.orangeAccent3,
                                onPrimary: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text('Trabajar'),
                            )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            controller.showDialogInformar?
            ArsProgressWidget(
              blur: 2,
              backgroundColor: Color(0x33000000),
              animationDuration: Duration(milliseconds: 500),
              onDismiss: (){
                controller.onClickSalirDialogInformar();
              },
              loadingWidget:  Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // if you need this
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  constraints: BoxConstraints(minWidth: 280, maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Padding(padding: EdgeInsets.all(8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(AppIcon.ic_procesear_nota, width: 40, height: 40,),
                          Padding(padding: EdgeInsets.all(8)),
                          Container(
                            width: 250,
                            height: 40,
                            child:  ElevatedButton(
                              onPressed: () {

                              },
                              style: ElevatedButton.styleFrom(
                                primary: HexColor(controller.cursosUi.color2),
                                onPrimary: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Ionicons.send , color: AppTheme.white, size: 14, ),
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("Informar registro".toUpperCase(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                        color: AppTheme.white,
                                        fontSize: 14,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(AppIcon.ic_cerrar_curso, width: 40, height: 40,),
                          Padding(padding: EdgeInsets.all(8)),
                          Container(
                            width: 250,
                            height: 40,
                            child:  ElevatedButton(
                              onPressed: () {

                              },
                              style: ElevatedButton.styleFrom(
                                primary: HexColor("#CD005A"),
                                onPrimary: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Ionicons.lock_closed ,color: AppTheme.white, size: 14, ),
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("Cerrar curso".toUpperCase(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                        color:AppTheme.white,
                                        fontSize: 14,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(16)),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          Container(
                            width: 110,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.onClickSalirDialogInformar();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: HexColor(controller.cursosUi.color2),
                                onPrimary: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text('Atras', style: TextStyle(fontSize: 14, color: AppTheme.white),),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ):Container(),

          ],
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
                        child:   ControlledWidgetBuilder<RubroController>(
                          builder: (context, controller) {
                            return Stack(
                              children: <Widget>[
                                Positioned(
                                    child:  IconButton(
                                      icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size:  controller.seletedItem == 0 ?(22 + 6 - 6 * topBarOpacity): 22,),
                                      onPressed: () {
                                        animationController.reverse().then<dynamic>((data) {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    )
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 0, bottom: 8, left: 8, right: 32),
                                  child:
                                  topBarOpacity >= 1  && controller.seletedItem == 0 ?
                                  Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child:  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                            onTap: (){
                                              showDialogButtom(controller);
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(_getnombreFiltro(controller.origenRubroUi, sesion: controller.listar_eval_sesiones),
                                                    textAlign: TextAlign.left,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontTTNorms,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 16 + 6 - 1 * topBarOpacity,
                                                      color: HexColor("#35377A"),
                                                    )
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(right: 8),
                                                ),
                                                Icon(Icons.keyboard_arrow_down_rounded,
                                                  color: HexColor("#35377A"),
                                                  size: 24 + 4 - 1 * topBarOpacity,)
                                              ],
                                            )
                                        )
                                      ],
                                    ),
                                  ):
                                  controller.seletedItem==0?
                                  Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(AppIcon.ic_curso_evaluacion, height: 35 +  6 - 8 * topBarOpacity, width: 35 +  6 - 8 * topBarOpacity,),
                                          Padding(
                                            padding: EdgeInsets.only(left: 12, top: 8),
                                            child: Text(
                                              'Evaluación',
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
                                          )
                                        ],
                                      ),
                                  ): controller.seletedItem==1?Stack(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          //SvgPicture.asset(AppIcon.ic_curso_evaluacion, height: 35 +  6 , width: 35 +  6,),
                                          Padding(
                                            padding: EdgeInsets.only(left: 12, top: 8),
                                            child: Text(
                                              'Evaluación',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16 + 6,
                                                letterSpacing: 0.8,
                                                color: AppTheme.white.withOpacity(0),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 48), top: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: ()=> controller.onClicPrecision(),
                                              child: Container(
                                                width: ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 100),
                                                padding: EdgeInsets.all( ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 8)),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular( ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 6))),
                                                    color:  controller.precision?HexColor(controller.cursosUi.color2) : AppTheme.greyLighten3
                                                ),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(AppIcon.ic_presicion,
                                                      color: controller.precision? AppTheme.white :AppTheme.greyDarken1,
                                                      height:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 16),
                                                      width:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 16),
                                                    ),
                                                    Padding(padding: EdgeInsets.all( ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 2)),),
                                                    FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text("Precisión",
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5,
                                                            color:  controller.precision? AppTheme.white :AppTheme.greyDarken1,
                                                            fontSize:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 5 + 6 - 1 * topBarOpacity ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.all( ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 8))),
                                            InkWell(
                                              onTap: ()=> controller.onClickShowDialogInformar(),
                                              child: Container(
                                                width:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 100),
                                                padding: EdgeInsets.only(
                                                    left:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 16) ,
                                                    right:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 16),
                                                    top:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 8),
                                                    bottom:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 8)
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular( ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 6))),
                                                    color: HexColor(controller.cursosUi.color2)
                                                ),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(Ionicons.send ,color: AppTheme.white, size:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 7 + 6 - 2 * topBarOpacity ), ),
                                                    Padding(padding: EdgeInsets.all( ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 2)),),
                                                    Text("Informar",
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5,
                                                          color:AppTheme.white,
                                                          fontSize:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 5 + 6 - 1 * topBarOpacity ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.all( ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 8))),
                                            InkWell(
                                              //onTap: ()=> controller.onClicPrecision(),
                                              child: Container(
                                                width:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 110),
                                                padding: EdgeInsets.only(
                                                    left:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 12) ,
                                                    right:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 12),
                                                    top:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 8),
                                                    bottom:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 8)
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular( ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 6))),
                                                    color: HexColor(controller.cursosUi.color2)
                                                ),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.find_in_page ,color: AppTheme.white, size:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 14), ),
                                                    Padding(padding: EdgeInsets.all( ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 2)),),
                                                    FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text("Comprobar",
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.5,
                                                            color:AppTheme.white,
                                                            fontSize:  ColumnCountProvider.aspectRatioForWidthButtonRubroRegistro(context, 5 + 6 - 1 * topBarOpacity) ,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ):
                                  Container(
                                    margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 32),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(AppIcon.ic_curso_nota_final, height: 35 +  6 - 10 * topBarOpacity, width: 35 +  6 - 10 * topBarOpacity,),
                                        Padding(
                                          padding: EdgeInsets.only(left: 12, top: 8),
                                          child: Text(
                                            'Resultado',
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
                                          controller.onSyncronizarCurso();
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
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget getMainTab() {
    return ControlledWidgetBuilder<RubroController>(
        builder: (context, controller) {

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
                child:  PageView(
                  //scrollDirection: Axis.vertical,
                  children: [
                    tabRubroGeneral(controller),
                    //progress(tabRubroSesiones3(controller, count)),
                    tabRubCompetencia(controller),//:Container(child: Center(child: CircularProgressIndicator(),),),
                    Padding(padding: EdgeInsets.only(top: 14),
                      child:  TableResultado(
                        calendarioPeriodoUI: controller.calendarioPeriodoUI,
                        rows: controller.rowsResultado,
                        cells: controller.cellsResultado,
                        columns: controller.columnsResultado,
                        datosOffline: controller.datosOfflineResultado,
                        cursosUi: controller.cursosUi,
                        precision: controller.precisionResultado,
                        scrollControllers: scrollControllersProceso,
                        scrollOffsetX: controller.scrollResultadoX,
                        scrollOffsetY: controller.scrollResultadoY,
                        onEndScrolling: (x, y) {
                          print("x ${x}, y ${y}");
                          controller.scrollResultado(x,y);
                        },
                      ),
                    )
                  ],
                  onPageChanged: (index) {
                    topBarOpacity = 0;
                    controller.onChangeTab(index);
                  },
                  controller: _pageController,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: Container(
                  width: 24,
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
                          return InkWell(
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            borderRadius: const BorderRadius.all(Radius.circular(9.0)),
                            splashColor: HexColor(controller.cursosUi.color2).withOpacity(0.8),
                            onTap: () {
                              controller.onSelectedCalendarioPeriodo(controller.calendarioPeriodoList[index]);
                            },
                            child: Center(
                                child:Container(
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
                                      child: Center(
                                        child: RotatedBox(quarterTurns: 1,
                                            child: Text(controller.calendarioPeriodoList[index].nombre??"".toUpperCase(), style: TextStyle(color: controller.calendarioPeriodoList[index].selected??false ? (controller.cursosUi.color3!=null?HexColor(controller.cursosUi.color3):AppTheme.colorAccent): AppTheme.white, fontFamily: AppTheme.fontName, fontWeight: FontWeight.w700, fontSize: 10), )
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          );
                        }
                    ),
                  ),
                ),
              ),

            ],
          );
        });
  }

  void _guardarRubroyRetornar(BuildContext context, RubroController controller, SesionUi? sesionUi) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    dynamic response = await AppRouter.createRouteRubroCrearRouter(context, controller.cursosUi, controller.calendarioPeriodoUI, sesionUi, null);
    if(response is int) controller.respuestaFormularioCrearRubro();
  }

  void _evaluacionCapacidadRetornar(BuildContext context, RubroController controller, EvaluacionCapacidadUi evaluacionCapacidadUi) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    dynamic response = await AppRouter.createRouteEvaluacionCapacidad(context, controller.cursosUi, evaluacionCapacidadUi);
    if(response is int) controller.respuestaEvaluacionCapacidad();
  }

  void _evaluacionMultipleRetornar(BuildContext context, RubroController controller, RubricaEvaluacionUi rubricaEvaluacionUi) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    dynamic response = await AppRouter.createRouteEvaluacionMultiple(context, controller.calendarioPeriodoUI,controller.cursosUi, rubricaEvaluacionUi.rubricaId);
    if(response is int) controller.respuestaEvaluacion();
  }

  void _evaluacionSimpleRetornar(BuildContext context, RubroController controller, RubricaEvaluacionUi rubricaEvaluacionUi, CalendarioPeriodoUI? calendarioPeriodoUI) async{
    dynamic response = await AppRouter.createRouteEvaluacionSimple(context, controller.cursosUi, rubricaEvaluacionUi.rubricaId, calendarioPeriodoUI);
    if(response is int) controller.respuestaEvaluacion();
  }

  void showDialogButtom(RubroController controller) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
            title: Text('Mis evaluaciones'),
            message: Text('Reduzca su busqueda con las opciones a continuación'),
            actions: [
              CupertinoActionSheetAction(
                child: Text(_getnombreFiltro(null, sesion: true)),
                onPressed: () {
                  controller.clicMostrarSoloSesiones();
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(_getnombreFiltro(OrigenRubroUi.GENERADO_TAREA)),
                onPressed: () {
                  controller.clicMostrarSolo(OrigenRubroUi.GENERADO_TAREA);
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(_getnombreFiltro(OrigenRubroUi.GENERADO_INSTRUMENTO)),
                onPressed: () {
                  controller.clicMostrarSolo(OrigenRubroUi.GENERADO_INSTRUMENTO);
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(_getnombreFiltro(OrigenRubroUi.GENERADO_PREGUNTA)),
                onPressed: () {
                  controller.clicMostrarSolo(OrigenRubroUi.GENERADO_PREGUNTA);
                  Navigator.pop(context);
                },
              ),

              CupertinoActionSheetAction(
                child: Text(_getnombreFiltro(OrigenRubroUi.CREADO_DOCENTE)),
                onPressed: () {
                  controller.clicMostrarSolo(OrigenRubroUi.CREADO_DOCENTE);
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text(_getnombreFiltro(OrigenRubroUi.TODOS)),
                onPressed: () {
                  controller.clicMostrarSolo(OrigenRubroUi.TODOS);
                  Navigator.pop(context);
                },
              ),

            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
        );
      },
    );
  }


  String _getnombreFiltro(OrigenRubroUi? origenRubroUi, {sesion = false}){
    String nombre = "";
    if(sesion){
      nombre = "Rúbricas de sesion";
    }else{
      switch(origenRubroUi??OrigenRubroUi.TODOS){
        case OrigenRubroUi.GENERADO_INSTRUMENTO:
          nombre = "Rúbricas de instrumento";
          break;
        case OrigenRubroUi.GENERADO_TAREA:
          nombre = "Rúbricas de tarea";
          break;
        case OrigenRubroUi.GENERADO_PREGUNTA:
          nombre = "Rúbricas de pregunta";
          break;
        case OrigenRubroUi.CREADO_DOCENTE:
          nombre = "Rúbricas del curso";
          break;
        case OrigenRubroUi.TODOS:
          nombre = "Mostrar todos";
          break;
      }
    }

    return nombre;
  }

  //#region Tab



  Widget tabRubCompetencia(RubroController controller) {
    if(controller.columnList2!=null){
      List<double> tablecolumnWidths = [];
      for(dynamic s in controller.columnList2){
        if(s is ContactoUi){
          tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTableRubro(context, 85));
        } else if(s is CalendarioPeriodoUI){
          tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTableRubro(context, 70)*3);
        }else if(s is CapacidadUi){
          tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTableRubro(context, 65));
        }else{
          tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTableRubro(context, 70));
        }
      }

      if((controller.columnList2.length)<= 3){
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
            ),
            Padding(padding: EdgeInsets.all(4)),
            Center(
              child: Text("Sin compentencias", style: TextStyle(color: AppTheme.grey, fontStyle: FontStyle.italic, fontSize: 12),),
            )
          ],
        );
      }

      return Padding(
        padding: const EdgeInsets.only(left: 8, right: 0, top: 16),
        child:  StickyHeadersTableV2(
          scrollControllers: scrollControllersResultado,
          cellDimensions: CellDimensions.variableColumnWidth(
              stickyLegendHeight:ColumnCountProvider.aspectRatioForWidthTableRubro(context, 120),
              stickyLegendWidth: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 50),
              contentCellHeight: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 35),
              columnWidths: tablecolumnWidths
          ),
          initialScrollOffsetX: controller.scrollRubroProcesoX,
          initialScrollOffsetY: controller.scrollRubroProcesoY,
          onEndScrolling: (x, y) {
            print("x ${x}, y ${y}");
            controller.scrollRubroProceso(x,y);
          },
          columnsLength: controller.columnList2.length,
          rowsLength: controller.rowList2.length,
          columnsTitleBuilder: (i) {
            dynamic o = controller.columnList2[i];
            if(o is ContactoUi){
              return Container(
                  constraints: BoxConstraints.expand(),
                  child: Center(
                    child:  Text("Apellidos y\n Nombres",
                      style: TextStyle(
                          fontSize: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 10),
                          color: AppTheme.black,
                          fontWeight: FontWeight.w500 ),),
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                        right: BorderSide(color: HexColor(controller.cursosUi.color3)),
                      ),
                      color: HexColor("#EFEDEE")
                  )
              );
            }else if(o is CompetenciaUi){
              return Container(
                  constraints: BoxConstraints.expand(),
                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTableRubro(context, 8)),
                  child: Center(
                    child:  RotatedBox(
                      quarterTurns: -1,
                      child: Text(o.nombre??"",
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 9),
                            color: AppTheme.darkText,
                            fontWeight: FontWeight.w700
                        )
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                        right: BorderSide(color: HexColor(controller.cursosUi.color3)),
                      ),
                      color: HexColor("#EFEDEE")
                  )
              );
            }else if(o is CapacidadUi){
              return InkWell(
                onTap: () async{
                  dynamic response = await AppRouter.createRoutePesoCriterio(context, controller.cursosUi, o);
                  print("response PesoCriterio: ${response}");
                  if(response is int) controller.respuestaPesoCriterio();
                },
                child: Container(
                    constraints: BoxConstraints.expand(),
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 8),
                              top: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 8),
                              bottom: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 24),
                              right: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 8)
                          ),
                          child: Center(
                            child:  RotatedBox(
                              quarterTurns: -1,
                              child: Text(o.nombre??"",
                                  textAlign: TextAlign.center,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 9),
                                      color: AppTheme.greyDarken3,
                                      fontWeight: FontWeight.w500
                                  )
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          left: 4,
                          bottom: 4,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4) ,
                              color: HexColor(controller.cursosUi.color2),// use instead of BorderRadius.all(Radius.circular(20))
                            ),
                            height: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Ionicons.pencil,
                                  color: AppTheme.white,
                                  size: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 8),
                                ),
                                Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTableRubro(context, 2))),
                                Text("Modifica",
                                  style: TextStyle(
                                      fontSize: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 8),
                                      color: AppTheme.white
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                          right: BorderSide(color: HexColor(controller.cursosUi.color3)),
                        ),
                        color: AppTheme.white
                    )
                ),
              );
            }else if(o is CalendarioPeriodoUI){
              return Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                          constraints: BoxConstraints.expand(),
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child:  RotatedBox(
                              quarterTurns: -1,
                              child: Text("Final ${o.nombre??""}",
                                textAlign: TextAlign.center,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 10),
                                    color: AppTheme.black,
                                    fontWeight: FontWeight.w700
                                )),
                            ),
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                                right: BorderSide(color: HexColor(controller.cursosUi.color3)),
                              ),
                              color: AppTheme.greyLighten1
                          )
                      )
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                          constraints: BoxConstraints.expand(),
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                                right: BorderSide(color:  HexColor(controller.cursosUi.color3)),
                              ),
                              color: HexColor("#EFEDEE")
                          )
                      )
                  )
                ],
              );
            }else{
              return Container();
            }

          },
          rowsTitleBuilder: (i) {
            dynamic o = controller.rowList2[i];
            if(o is PersonaUi){
              return  Container(
                  constraints: BoxConstraints.expand(),
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTableRubro(context, 4))),
                      Expanded(
                          child: Text((i+1).toString() + ".",
                            style: TextStyle(
                                color: AppTheme.white,
                                fontSize: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 9),
                                fontWeight: FontWeight.w700
                            )
                          )
                      ),
                      Container(
                        height: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 20),
                        width: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 20),
                        margin: EdgeInsets.only(
                            right: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 3)
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor(controller.cursosUi.color3),
                        ),
                        child: true?
                        CachedNetworkImage(
                          placeholder: (context, url) => CircularProgressIndicator(),
                          imageUrl: o.foto??"",
                          errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded,
                            size: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 80)
                          ),
                          imageBuilder: (context, imageProvider) =>
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              ),
                        ):
                        Container(),
                      ),
                      Padding(padding: EdgeInsets.all(1)),
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                        right: BorderSide(color: HexColor(controller.cursosUi.color3)),
                      ),
                      color: HexColor(controller.cursosUi.color2)
                  )
              );
            }else{
              return  Container();
            }

          },
          contentCellBuilder: (i, j) {
            dynamic o = controller.cellListList[j][i];
            if(o is PersonaUi){
              return Container(
                  constraints: BoxConstraints.expand(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(o.apellidos??"",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 9),
                            color: AppTheme.black,
                            fontWeight: FontWeight.w500
                        )
                      ),
                      Text(o.nombres??"",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 9),
                        )
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                        right: BorderSide(color:  HexColor(controller.cursosUi.color3)),
                      ),
                      color: _getColorAlumnoBloqueados(o, 0)
                  )
              );
            }else if(o is EvaluacionCapacidadUi){
              return InkWell(
                onTap: () => _evaluacionCapacidadRetornar(context, controller, o),
                child: Stack(
                  children: [
                    Container(
                      constraints: BoxConstraints.expand(),
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                            right: BorderSide(color:  HexColor(controller.cursosUi.color3)),
                          ),
                          color: _getColorAlumnoBloqueados(o.personaUi, 0)
                      ),
                      child: _getTipoNota(controller.tipoNotaUi, o.valorTipoNotaUi, o.nota, controller.precision),
                    ),
                    if(controller.calendarioPeriodoUI?.habilitado != 1)
                    Positioned(
                        bottom: 4,
                        right: 4,
                        child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 15,)
                    ),
                  ],
                ),
              );
            }else if(o is EvaluacionCompetenciaUi){
              return Stack(
                children: [
                  Container(
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                          right: BorderSide(color:  HexColor(controller.cursosUi.color3)),
                        ),
                        color: _getColorAlumnoBloqueados(o.personaUi, 1, c_default: HexColor("#EFEDEE"))
                    ),
                    child: _getTipoNota(controller.tipoNotaUi,o.valorTipoNotaUi, o.nota, controller.precision),
                  ),
                  if(controller.calendarioPeriodoUI?.habilitado != 1)
                  Positioned(
                      bottom: 4,
                      right: 4,
                      child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 18,)
                  ),
                ],
              );
            }else if(o is EvaluacionCalendarioPeriodoUi){
              return Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            constraints: BoxConstraints.expand(),
                            decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                                  right: BorderSide(color:  HexColor(controller.cursosUi.color3)),
                                ),
                                color: _getColorAlumnoBloqueados(o.personaUi, 2, c_default: AppTheme.greyLighten1)
                            ),
                            child: _getTipoNota(controller.tipoNotaUi, o.valorTipoNotaUi, o.nota, controller.precision),
                          ),
                          if(controller.calendarioPeriodoUI?.habilitado != 1)
                          Positioned(
                              bottom: 4,
                              right: 4,
                              child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 18,)
                          ),
                        ],
                      )
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                          constraints: BoxConstraints.expand(),
                          decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color:  HexColor(controller.cursosUi.color3)),
                              ),
                              color: HexColor("#EFEDEE")
                          )
                      )
                  ),
                ],
              );
            }else{
              return Container();
            }

          },
          legendCell: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: HexColor(controller.cursosUi.color1),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(7))
                  )
              ),
              Container(
                  child: Center(
                    child: Text('N°',
                      style: TextStyle(
                          color: AppTheme.white,
                          fontWeight: FontWeight.w700,
                          fontSize: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 11),
                      )
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: HexColor(controller.cursosUi.color3)),
                    ),
                  )
              ),

            ],
          ),
        ),

      );
    }else{
      return Container();
    }
  }

  Widget tabRubroGeneral(RubroController controller) {
    if(controller.rubricaEvaluacionUiList!=null){
      return Padding(
        padding: EdgeInsets.only(left: 24, right: 48),
        child: Stack(
          children: [
            (controller.rubricaEvaluacionUiList?.isEmpty??false)?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
                ),
                Padding(padding: EdgeInsets.all(4)),
                Center(
                  child: Text("Sin evaluaciones", style: TextStyle(color: AppTheme.grey, fontStyle: FontStyle.italic, fontSize: 12),),
                )
              ],
            ):Container(),
            CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        controller.calendarioPeriodoUI==null || (controller.calendarioPeriodoUI?.habilitado??0)==1?
                        Padding(padding: EdgeInsets.only( top: 32)):
                        Container(
                          margin: EdgeInsets.only(top:24, bottom: 16),
                          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.redLighten1,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text("El ${controller.calendarioPeriodoUI?.nombre??"período"} no se encuentra vigente.", textAlign: TextAlign.center,style: TextStyle(color: AppTheme.white, fontSize: 14),),
                        ),
                        controller.calendarioPeriodoUI!=null?
                        Stack(
                          children: [
                            InkWell(
                              onTap: (){
                                showDialogButtom(controller);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(_getnombreFiltro(controller.origenRubroUi, sesion: controller.listar_eval_sesiones),
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14 + 6 - 3 * topBarOpacity,
                                        color: HexColor("#35377A"),
                                      )
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                  ),
                                  Icon(Icons.keyboard_arrow_down_rounded,
                                    color: HexColor("#35377A"),
                                    size: 20 + 4 - 4 * topBarOpacity,)
                                ],
                              ),
                            )
                          ],
                        ):Container(),
                      ],
                    )
                ),
                !controller.listar_eval_sesiones?
               SliverPadding(
                   padding: EdgeInsets.only(top: 32),
                  sliver:  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ColumnCountProvider.columnsForWidthRubro(context),
                      mainAxisSpacing: 24.0,
                      crossAxisSpacing: 24.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index){
                          dynamic o =  controller.rubricaEvaluacionUiList?[index];

                          if(o is String){
                            return InkWell(
                              onTap: () async{
                                _guardarRubroyRetornar(context, controller, null);
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
                                        Icon(Ionicons.add, color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthRubro(context, 40),),
                                        Padding(padding: EdgeInsets.only(top: 4)),
                                        Text("Crear\nevaluación",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: ColumnCountProvider.aspectRatioForWidthRubro(context, 16),
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
                          }else if(o is RubricaEvaluacionUi){
                            //int position = (controller.rubricaEvaluacionUiList?.length??0) - index;
                            return ItemRubro(rubricaEvalProcesoUi: o,
                              calendarioPeriodoUI: controller.calendarioPeriodoUI,
                              cursosUi: controller.cursosUi,
                              onTap: (){
                                if((o.cantidadRubroDetalle??0) > 1){
                                  _evaluacionMultipleRetornar(context, controller, o);
                                }else{
                                  _evaluacionSimpleRetornar(context, controller, o, controller.calendarioPeriodoUI);
                                }
                              },
                            );;
                          }
                        },
                        childCount: controller.rubricaEvaluacionUiList?.length??0
                    ),
                  ),
               ):
                SliverToBoxAdapter(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.unidadUiList.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        UnidadUi unidadUi = controller.unidadUiList[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text("U${unidadUi.nroUnidad??""}: ${unidadUi.titulo??""}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: AppTheme.fontTTNorms
                                ),
                              ),
                            ),
                            (unidadUi.sesionUiList?.length??0)>0?
                            Row(
                              children: [
                                Expanded(child: Container()),
                                InkWell(
                                  onTap: ()=> controller.onClickMostrarTodo(unidadUi),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 4 , right: 4, top: 4, bottom: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        color: AppTheme.colorSesion
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon((unidadUi.toogle??false)?Ionicons.contract: Ionicons.expand,color: AppTheme.white, size: 16),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ):Container(),
                            (unidadUi.sesionUiList?.length??0)>0?
                            ListView.builder(
                              padding: EdgeInsets.only(top: 16),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: unidadUi.sesionUiList?.length,
                              itemBuilder: (context, index) {
                                SesionUi  sesionUi = unidadUi.sesionUiList![index];

                                List<dynamic> sesionItemList = controller.sesionItemsMap[sesionUi]??[];
                                int cant_rubro = sesionItemList.length;
                                int columnas = ColumnCountProvider.columnsForWidthRubro(context);
                                bool toogle = sesionUi.ver_mas??false;
                                int cant_reducida = columnas * 2;
                                bool isVisibleVerMas = cant_reducida < cant_rubro;
                                if(sesionUi.cantSesion == 1){
                                  isVisibleVerMas = false;
                                }

                                int cant_lista;
                                if(toogle){
                                  if(isVisibleVerMas){

                                  }
                                  cant_lista = cant_rubro;
                                }else{
                                  if(isVisibleVerMas){
                                    cant_lista = cant_reducida;
                                  }else{
                                    cant_lista = cant_rubro;
                                  }
                                }
                                return Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          controller.onClickSesion(sesionUi, unidadUi);
                                        },
                                        child: Container(
                                          child:  Container(
                                            padding: EdgeInsets.all(8),
                                            color: AppTheme.colorSesion.withOpacity(0.1),
                                            child: Row(
                                              children: [
                                                Container(
                                                  color: AppTheme.colorSesion.withOpacity(0.1),
                                                  child: Icon((sesionUi.toogle2??false)?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down, size: 20,color: AppTheme.colorSesion),
                                                ),
                                                Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(left: 8),
                                                      child: RichText(
                                                        text: TextSpan(
                                                          style: TextStyle(
                                                              color: AppTheme.colorSesion,
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.w500,
                                                              fontFamily: AppTheme.fontTTNorms
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(text: "S${sesionUi.nroSesion}: ".toUpperCase()),
                                                            TextSpan(text: "${sesionUi.titulo}".toUpperCase()),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      sesionUi.toogle2??false?
                                      Container(
                                        height: 1,
                                        color: AppTheme.colorSesion,
                                      ):Container(),
                                      sesionUi.toogle2??false?
                                      Container(
                                        padding: EdgeInsets.only(top: 16, bottom: 18),
                                        child:  Column(
                                          children: [
                                            Container(
                                              child: Column(
                                                children: [
                                                  cant_rubro > 0?
                                                  GridView.builder(
                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: columnas,
                                                      mainAxisSpacing: 24.0,
                                                      crossAxisSpacing: 24.0,
                                                    ),
                                                    physics: NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: cant_lista,
                                                    itemBuilder: (context, index) {
                                                      dynamic o = sesionItemList[index];

                                                      if(o is String){
                                                        return InkWell(
                                                          onTap: () async{
                                                             _guardarRubroyRetornar(context, controller, sesionUi);
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.all(8),
                                                            decoration: BoxDecoration(
                                                              color: AppTheme.colorSesion,
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
                                                                    Icon(Ionicons.add, color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthRubro(context, 40),),
                                                                    Padding(padding: EdgeInsets.only(top: 4)),
                                                                    Text("Crear\nevaluación\nSesion ${sesionUi.nroSesion}",
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                          fontSize: ColumnCountProvider.aspectRatioForWidthRubro(context, 16),
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
                                                      }else if (o is RubricaEvaluacionUi){
                                                        return ItemRubro(rubricaEvalProcesoUi: o,
                                                          calendarioPeriodoUI: controller.calendarioPeriodoUI,
                                                          cursosUi: controller.cursosUi,
                                                          onTap: (){
                                                            if((o.cantidadRubroDetalle??0) > 1){
                                                                _evaluacionMultipleRetornar(context, controller, o);
                                                              }else{
                                                                _evaluacionSimpleRetornar(context, controller, o, controller.calendarioPeriodoUI);
                                                              }
                                                          },
                                                        );
                                                      }else{
                                                        return Container();
                                                      }
                                                    },
                                                  )
                                                      :Container(
                                                    margin: EdgeInsets.only(left: 8, right: 8),
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.colorSesion.withOpacity(0.1),
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
                                                        child: Text("Sesión sin evaluaciones",  style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w800,
                                                            fontFamily: AppTheme.fontTTNorms,
                                                            color: AppTheme.white
                                                        ),),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            if(isVisibleVerMas)
                                              InkWell(
                                                onTap: (){
                                                  controller.onClickVerMas(sesionUi);
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
                                      ):Container()
                                    ],
                                  ),
                                );
                              },
                            ):Container(
                              margin: EdgeInsets.only(top: 16, bottom: 24),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.colorSesion.withOpacity(0.1),
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

                          ],
                        );
                      }
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
            )
            /*Positioned(
              right: 16,
              bottom: 120,
              child: FloatingActionButton(
                backgroundColor: controller.cursosUi.color2!=null?HexColor(controller.cursosUi.color2):AppTheme.colorAccent,
                foregroundColor: Colors.white,
                onPressed: () {
                  _guardarRubroyRetornar(context, controller);
                },
                child: Icon(Ionicons.add),
              ),
            )*/
          ],
        ),
      );
    }else{
      return Container();
    }

  }

  Widget tabRubroSesiones3(RubroController controller, int countRow) {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 48),
      child: Stack(
        children: [
          controller.unidadUiList.isEmpty?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
              ),
              Padding(padding: EdgeInsets.all(4)),
              Center(
                child: Text("Sin unidades", style: TextStyle(color: AppTheme.grey, fontStyle: FontStyle.italic, fontSize: 12),),
              )
            ],
          ):
          Container(),
        ],
      ),
    );
  }

//#region Tab


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

  Widget? _getTipoNota(TipoNotaUi? tipoNotaUi, ValorTipoNotaUi? valorTipoNotaUi, double? nota, bool precision) {

    nota = nota!=null?DomainTools.roundDouble(nota, 1): null;

    var tipo =TipoNotaTiposUi.VALOR_NUMERICO;
    if(!precision) tipo = tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO;
    switch(tipo){
      case TipoNotaTiposUi.SELECTOR_VALORES:
        Color color;
        if (("B" == (valorTipoNotaUi?.titulo??"") || "C" == (valorTipoNotaUi?.titulo??""))) {
          color = AppTheme.redDarken4;
        }else if (("AD" == (valorTipoNotaUi?.titulo??"")) || "A" == (valorTipoNotaUi?.titulo??"")) {
          color = AppTheme.blueDarken4;
        }else {
          color = AppTheme.black;
        }
        return Center(
          child: Container(
            padding: EdgeInsets.only(left: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 4),),
            child: Text("${ valorTipoNotaUi?.titulo??"-"}",
                style: TextStyle(
                  fontFamily: AppTheme.fontTTNormsMedium,
                  fontSize: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 10),
                  fontWeight: FontWeight.w700,
                  color: color,
                )),
          ),
        );
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        if(valorTipoNotaUi!=null){
          return Container(
            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTableRubro(context, 4)),
            child:  CachedNetworkImage(
              imageUrl: valorTipoNotaUi.icono??"",
              placeholder: (context, url) => Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                    height: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 20),
                    width: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 20),
                  )
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        }else{
          return Center(
            child: Text("-",
                style: TextStyle(
                  fontFamily: AppTheme.fontTTNormsMedium,
                  fontSize: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 10),
                  fontWeight: FontWeight.w700,
                  color: AppTheme.black,
                )),
          );
        }
      case TipoNotaTiposUi.VALOR_ASISTENCIA:
      case TipoNotaTiposUi.VALOR_NUMERICO:
      case TipoNotaTiposUi.SELECTOR_NUMERICO:
        Color color;
        if(tipoNotaUi?.escalavalorMaximo == 20){
          if ((nota??0) < 10.5) {
            color = AppTheme.redDarken4;
          }else if ( (nota??0) >= 10.5) {
            color = AppTheme.blueDarken4;
          }else {
            color = AppTheme.black;
          }
        }else if(tipoNotaUi?.escalavalorMaximo == 4){
          if ((nota??0) < 3) {
            color = AppTheme.redDarken4;
          }else if ( (nota??0) >= 3) {
            color = AppTheme.blueDarken4;
          }else {
            color = AppTheme.black;
          }
        }else if(tipoNotaUi?.escalavalorMaximo == 3){
          if ((nota??0) < 3) {
            color = AppTheme.redDarken4;
          }else if ( (nota??0) >= 3) {
            color = AppTheme.blueDarken4;
          }else {
            color = AppTheme.black;
          }
        }else{
          color = AppTheme.black;
        }

        return Center(
          child: Text("${nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
            fontFamily: AppTheme.fontTTNormsMedium,
            fontSize: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 10),
            fontWeight: FontWeight.w700,
            color: color,
          ),),
        );
    }
  }

  Widget evaluacionCapacidadDetalle(RubroController controller) {
    return ArsProgressWidget(
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500),
        loadingWidget:  Container(
          margin: EdgeInsets.only(top:32 ,bottom: 32, left: 24, right: 48),
          height: 140,
          decoration: BoxDecoration(
              color: HexColor("#4987F3"),
              borderRadius: BorderRadius.circular(24) // use instead of BorderRadius.all(Radius.circular(20))
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 24, right: 36, top: 16, bottom: 16),
                child:   Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Actualizando sus evaluaciones",
                            style: TextStyle(
                              fontFamily: AppTheme.fontTTNormsMedium,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              letterSpacing: 0.5,
                              color: AppTheme.white,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 8)),
                          Text("Congrats! Your progress are growing up",
                            style: TextStyle(
                              fontFamily: AppTheme.fontTTNormsLigth,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              letterSpacing: 0.5,
                              color: AppTheme.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 8)),
                    Container(
                      width: 72,
                      height: 72,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor("#3C7BE9")),
                      child:Container(
                        child: Center(
                          child: Text("0%",
                            style: TextStyle(
                              fontFamily: AppTheme.fontTTNormsMedium,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              letterSpacing: 0.5,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: HexColor("#4987F3")),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: -88,
                child: Container(
                  width: 280,
                  child: Lottie.asset('assets/lottie/progress_portal_alumno.json',
                      fit: BoxFit.fill
                  ),
                ),
              )
            ],
          ),
        )
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

}


/*
* if(controller.contenedorSyncronizar) ArsProgressWidget(
                      blur: 2,
                      backgroundColor: Color(0x33000000),
                      animationDuration: Duration(milliseconds: 500),
                      loadingWidget:  Container(
                        margin: EdgeInsets.only(top:32 ,bottom: 32, left: 24, right: 48),
                        height: 140,
                        decoration: BoxDecoration(
                            color: HexColor("#4987F3"),
                            borderRadius: BorderRadius.circular(24) // use instead of BorderRadius.all(Radius.circular(20))
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 24, right: 36, top: 16, bottom: 16),
                              child:   Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Actualizando sus evaluaciones",
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontTTNormsMedium,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                            letterSpacing: 0.5,
                                            color: AppTheme.white,
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.only(top: 8)),
                                        Text("Congrats! Your progress are growing up",
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontTTNormsLigth,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            letterSpacing: 0.5,
                                            color: AppTheme.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 8)),
                                  Container(
                                    width: 72,
                                    height: 72,
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: HexColor("#3C7BE9")),
                                    child:Container(
                                      child: Center(
                                        child: Text(controller.progresoSyncronizar.toString() + "%",
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontTTNormsMedium,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                            letterSpacing: 0.5,
                                            color: AppTheme.white,
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: HexColor("#4987F3")),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: -88,
                              child: Container(
                                width: 280,
                                child: Lottie.asset('assets/lottie/progress_portal_alumno.json',
                                    fit: BoxFit.fill
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                  ),
* */




