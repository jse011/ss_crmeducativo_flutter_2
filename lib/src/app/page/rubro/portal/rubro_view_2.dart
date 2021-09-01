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
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_calendario_periodo_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
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

class RubroView2 extends View {
  CursosUi cursosUi;

  RubroView2(this.cursosUi);

  @override
  RubroViewState createState() => RubroViewState(this.cursosUi);

}

class RubroViewState extends ViewState<RubroView2, RubroController> with TickerProviderStateMixin{
  Function()? statetDialogRubroSesion;

  RubroViewState(cursosUi) : super(RubroController(cursosUi, MoorCalendarioPeriodoRepository(), MoorConfiguracionRepository(), DeviceHttpDatosRepositorio(), MoorRubroRepository()));

  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late AnimationController animationController;

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

  Widget get view => Stack(
    children: [
      Scaffold(
        extendBody: true,
        backgroundColor: getBackground(),
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
                        title: Text('General')),
                    BottomNavigationBarItem(
                      // ignore: deprecated_member_use
                        icon: Container(),
                        // ignore: deprecated_member_use
                        title: Text('Sesión')),
                    BottomNavigationBarItem(
                      // ignore: deprecated_member_use
                        icon: Container(),
                        // ignore: deprecated_member_use
                        title: Text('Competencia'))
                  ],
                  currentIndex: _seletedItem,
                  onTap: (index) {
                    setState(() {
                      _seletedItem = index;
                      _pageController.jumpToPage(_seletedItem);
                    });
                  },
                ),
              )),
        ),
      ),
      ControlledWidgetBuilder<RubroController>(
          builder: (context, controller) {
            return Stack(
              children: [
                if(controller.progress)ArsProgressWidget(
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
              ],
            );
          }
      )
    ],
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
                                      icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
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
                                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 32),
                                  child:
                                  topBarOpacity >= 1  && _seletedItem == 0 ?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          showDialogButtom(controller);
                                        },
                                        child: Text(_getnombreFiltro(controller.origenRubroUi),
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
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 8),
                                      ),
                                      Icon(Icons.keyboard_arrow_down_rounded,
                                        color: HexColor("#35377A"),
                                        size: 24 + 4 - 1 * topBarOpacity,)
                                    ],
                                  ):
                                  Row(
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
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
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
    return ControlledWidgetBuilder<RubroController>(
        builder: (context, controller) {

          var widthDp = context.widthPx;
          int count;
          if (widthDp >= 800) {
            count = 5;
          }if (widthDp >= 600) {
            count = 4;
          } else if (widthDp >= 480) {
            count = 3;
          } else {
            count = 2;
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
                child:  PageView(
                  //scrollDirection: Axis.vertical,
                  children: [
                    tabRubroGeneral(controller, count),
                    progress(tabRubroSesiones3(controller, count)),
                    progress(_seletedItem==2?tabRubCompetencia(controller):Container())
                  ],
                  onPageChanged: (index) {
                    setState(() {
                      topBarOpacity = 0;
                      _seletedItem = index;
                    });
                  },
                  controller: _pageController,
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
                                      splashColor: HexColor(controller.cursosUi.color2).withOpacity(0.8),
                                      onTap: () {
                                        controller.onSelectedCalendarioPeriodo(controller.calendarioPeriodoList[index]);
                                      },
                                      child: Center(
                                        child: RotatedBox(quarterTurns: 1,
                                            child: Text(controller.calendarioPeriodoList[index].nombre??"".toUpperCase(), style: TextStyle(color: controller.calendarioPeriodoList[index].selected??false ? (controller.cursosUi.color3!=null?HexColor(controller.cursosUi.color3):AppTheme.colorAccent): AppTheme.white, fontFamily: AppTheme.fontName, fontWeight: FontWeight.w700, fontSize: 10), )
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

  void _guardarRubroyRetornar(BuildContext context, RubroController controller) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    await AppRouter.createRouteRubroCrearRouter(context, controller.cursosUi, controller.calendarioPeriodoUI, null);
    controller.respuestaFormularioCrearRubro();
  }

  void _evaluacionCapacidadRetornar(BuildContext context, RubroController controller, EvaluacionCapacidadUi evaluacionCapacidadUi) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    await AppRouter.createRouteEvaluacionCapacidad(context, controller.cursosUi, evaluacionCapacidadUi);
    controller.respuestaEvaluacionCapacidad();
  }

  void _evaluacionMultipleRetornar(BuildContext context, RubroController controller, RubricaEvaluacionUi rubricaEvaluacionUi) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    await AppRouter.createRouteEvaluacionMultiple(context, controller.calendarioPeriodoUI,controller.cursosUi, rubricaEvaluacionUi.rubricaId);
    controller.respuestaEvaluacion();
  }

  void _evaluacionSimpleRetornar(BuildContext context, RubroController controller, RubricaEvaluacionUi rubricaEvaluacionUi, CalendarioPeriodoUI? calendarioPeriodoUI) async{
    await AppRouter.createRouteEvaluacionSimple(context, controller.cursosUi, rubricaEvaluacionUi.rubricaId, calendarioPeriodoUI);
    controller.respuestaEvaluacion();
  }

  void showDialogButtom(RubroController controller) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
            title: const Text('Mis evaluaciones'),
            message: const Text('Reduzca su busqueda con las opciones a continuación'),
            actions: [
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


  String _getnombreFiltro(OrigenRubroUi origenRubroUi){
    String nombre = "";
    switch(origenRubroUi){
      case OrigenRubroUi.GENERADO_INSTRUMENTO:
        nombre = "Mostrar solo Instrumentos";
        break;
      case OrigenRubroUi.GENERADO_TAREA:
        nombre = "Mostrar solo Tareas";
        break;
      case OrigenRubroUi.GENERADO_PREGUNTA:
        nombre = "Mostrar solo Preguntas";
        break;
      case OrigenRubroUi.CREADO_DOCENTE:
        nombre = "Mostrar solo Registro";
        break;
      case OrigenRubroUi.TODOS:
        nombre = "Mostrar Todos";
        break;
    }
    return nombre;
  }

  Color getBackground() {
    switch(_seletedItem){
      case 15:
        return HexColor("#E3F8FA");
      default:
        return AppTheme.background;
    }
  }
  //#region Tab


  ScrollControllers _scrollControllers = ScrollControllers();
  Widget tabRubCompetencia(RubroController controller) {

    List<double> tablecolumnWidths = [];
    for(dynamic s in controller.columnList2){
      if(s is ContactoUi){
        tablecolumnWidths.add(95.0);
      } else if(s is CalendarioPeriodoUI){
        tablecolumnWidths.add(70.0*3);
      }else{
        tablecolumnWidths.add(70.0);
      }
    }

    if(controller.columnList2.length <= 3){
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
      padding: const EdgeInsets.only(left: 8, right: 0, top: 24),
      child:  StickyHeadersTableV2(
        scrollControllers: _scrollControllers,
        cellDimensions: CellDimensions.variableColumnWidth(
            stickyLegendHeight:125,
            stickyLegendWidth: 65,
            contentCellHeight: 45,
            columnWidths: tablecolumnWidths
        ),
        columnsLength: controller.columnList2.length,
        rowsLength: controller.rowList2.length,
        columnsTitleBuilder: (i) {
          dynamic o = controller.columnList2[i];
          if(o is ContactoUi){
            return Container(
                constraints: BoxConstraints.expand(),
                child: Center(
                  child:  Text("Apellidos y\n Nombres", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500 ),),
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
                padding: EdgeInsets.all(8),
                child: Center(
                  child:  RotatedBox(
                    quarterTurns: -1,
                    child: Text(o.nombre??"", textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11,color: AppTheme.darkText ),),
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
            return Container(
                constraints: BoxConstraints.expand(),
                padding: EdgeInsets.all(8),
                child: Center(
                  child:  RotatedBox(
                    quarterTurns: -1,
                    child: Text(o.nombre??"", textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11,color: AppTheme.greyDarken3 ),),
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                      right: BorderSide(color: HexColor(controller.cursosUi.color3)),
                    ),
                    color: AppTheme.white
                )
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
                            child: Text("Final ${o.nombre??""}", textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11,color: AppTheme.greyDarken3, fontWeight: FontWeight.w700 ),),
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
                     Padding(padding: EdgeInsets.all(4)),
                     Expanded(
                         child: Text((i+1).toString() + ".", style: TextStyle(color: AppTheme.white, fontSize: 12),)
                     ),
                     Container(
                       height: 30,
                       width: 30,
                       margin: EdgeInsets.only(right: 3),
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         color: HexColor(controller.cursosUi.color3),
                       ),
                       child: true?
                       CachedNetworkImage(
                         placeholder: (context, url) => CircularProgressIndicator(),
                         imageUrl: o.foto??"",
                         errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
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
                    Text(o.nombreCompleto??"", maxLines: 1, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppTheme.black),),
                    Text(o.apellidos??"", maxLines: 1, textAlign: TextAlign.center,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10),),
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
                    child: _getTipoNota(o.valorTipoNotaUi, o.nota),
                  ),
                  Positioned(
                      bottom: 4,
                      right: 4,
                      child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 18,)
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
                  child: _getTipoNota(o.valorTipoNotaUi, o.nota),
                ),
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
                          child: _getTipoNota(o.valorTipoNotaUi, o.nota),
                        ),
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
                  child: Text('N°', style: TextStyle(color: AppTheme.white, fontWeight: FontWeight.w700),),
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
  }

  Widget tabRubroGeneral(RubroController controller, int countRow) {
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
                        Padding(
                          padding: EdgeInsets.only(bottom: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: (){
                                  showDialogButtom(controller);
                                },
                                child:  Text(_getnombreFiltro(controller.origenRubroUi),
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
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 8),
                              ),
                              Icon(Icons.keyboard_arrow_down_rounded,
                                color: HexColor("#35377A"),
                                size: 20 + 4 - 4 * topBarOpacity,)
                            ],
                          ),
                        ):Container(),
                      ],
                    )
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: countRow,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,

                  ),
                  delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index){
                        dynamic o =  controller.rubricaEvaluacionUiList?[index];

                        if(o is String){
                          return InkWell(
                            onTap: (){
                              _guardarRubroyRetornar(context, controller);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: HexColor(controller.cursosUi.color2).withOpacity(1),
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
                                  padding: EdgeInsets.all(4),
                                  color: HexColor(controller.cursosUi.color2).withOpacity(1),
                                  alignment: Alignment.center,
                                  child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Ionicons.add, color: AppTheme.white, size: 45,),
                                      Text("Crear Evaluación",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: AppTheme.fontTTNorms,
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
                          int position = (controller.rubricaEvaluacionUiList?.length??0) - index;
                          return _getRubrica(position, o, controller);
                        }
                      },
                      childCount: controller.rubricaEvaluacionUiList?.length??0
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
          SingleChildScrollView(
            physics: ScrollPhysics(),
            controller: scrollController,
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.unidadUiList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  UnidadUi unidadUi = controller.unidadUiList[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      index==0?
                      controller.calendarioPeriodoUI==null || (controller.calendarioPeriodoUI?.habilitado??0)==1?
                      Padding(padding: EdgeInsets.only( top: 20)):
                      Container(
                        margin: EdgeInsets.only(top:0, bottom: 16),
                        padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.redLighten1,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text("El ${controller.calendarioPeriodoUI?.nombre??"período"} no se encuentra vigente.", textAlign: TextAlign.center,style: TextStyle(color: AppTheme.white, fontSize: 14),),
                      ):
                      Padding(padding: EdgeInsets.only( top: 36)),
                      Container(
                        child: Text("U${unidadUi.nroUnidad}: ${unidadUi.titulo}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              height: 1.5,
                              color: AppTheme.colorAccent,
                              fontFamily: AppTheme.fontTTNorms
                          ),
                        ),
                      ),
                      (unidadUi.sesionUiList?.length??0)>0?
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: unidadUi.sesionUiList?.length,
                        itemBuilder: (context, index) {
                          SesionUi  sesionUi = unidadUi.sesionUiList![index];
                          int cantidadRubros = sesionUi.rubricaEvaluacionUiList?.length??0;
                          int cantidadRubrosVisibles = controller.mapSesionRubroList[sesionUi]?.length??0;
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only( top: index == 0?16:32, bottom: 24, ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 4),
                                      height: 20,
                                      width: 3,
                                      color: AppTheme.colorSesion,
                                    ),
                                    Padding(padding: EdgeInsets.all(4)),
                                    Expanded(
                                        child:  Text("S${sesionUi.nroSesion}: ${sesionUi.titulo}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              height: 1.5,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: AppTheme.fontTTNorms
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                              cantidadRubrosVisibles>0?
                              GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: countRow,
                                  mainAxisSpacing: 24.0,
                                  crossAxisSpacing: 24.0,
                                ),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: cantidadRubrosVisibles,
                                itemBuilder: (context, index) {
                                  dynamic o = controller.mapSesionRubroList[sesionUi]?[index];
                                 if(o is String && o == "add"){
                                   cantidadRubros++;
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
                                          padding: EdgeInsets.all(4),
                                          color: HexColor(controller.cursosUi.color2),
                                          alignment: Alignment.center,
                                          child:  Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Ionicons.add, color: AppTheme.white, size: 45,),
                                              Text("Crear Evaluación",
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
                                  }else if(o is String && o == "ver_mas"){
                                    cantidadRubros++;
                                    return InkWell(
                                      onTap: (){
                                        showRubroSesion(controller, unidadUi, sesionUi, countRow);
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
                                            color: HexColor(controller.cursosUi.color2),
                                            alignment: Alignment.center,
                                            child: Center(
                                              child: Text("Ver más",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    color: AppTheme.white
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else if (o is RubricaEvaluacionUi){
                                    int position = (cantidadRubros) - index;
                                    return _getRubrica(position, o, controller);
                                  }else{
                                   return Container();
                                 }
                                },
                              )
                              :Container(
                                margin: EdgeInsets.only(left: 8, right: 8),
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
                          );
                        },
                      ):Container(
                        margin: EdgeInsets.only(top: 16),
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

                    ],
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

//#region Tab

  void showRubroSesion(RubroController controller, UnidadUi unidadUi, SesionUi sesionUi, int countRow) {

    List<dynamic> rubroSesionList = controller.getRubrosSesionDialog(sesionUi);

    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (context, dialogState) {
              statetDialogRubroSesion = (){
                setState((){});
              };
              controller.addListener(statetDialogRubroSesion!);
              return Container(
                height: MediaQuery.of(context).size.height * 1,
                child: Container(
                  padding: EdgeInsets.all(0),
                  color: AppTheme.background,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(this.context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 16 - 8.0,
                            bottom: 12 - 8.0),
                        child:   Stack(
                          children: <Widget>[
                            Positioned(
                                child:  IconButton(
                                  icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22,),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 32),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AppIcon.ic_curso_evaluacion, height: 35 , width: 35,),
                                  Padding(
                                    padding: EdgeInsets.only(left: 12, top: 8),
                                    child: Text(
                                      'Evaluación',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        letterSpacing: 0.8,
                                        color: AppTheme.darkerText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 10,
                              child: ClipOval(
                                child: Material(
                                  color: AppTheme.colorPrimary.withOpacity(0.1), // button color
                                  child: InkWell(
                                    splashColor: AppTheme.colorPrimary, // inkwell color
                                    child: SizedBox(width: 43, height: 43,
                                      child: Icon(Ionicons.sync, size: 24,color: AppTheme.colorPrimary, ),
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
                                    padding: EdgeInsets.only( left: 24, right: 24),
                                        sliver:  SliverList(
                                            delegate: SliverChildListDelegate([
                                              controller.calendarioPeriodoUI==null || (controller.calendarioPeriodoUI?.habilitado??0)==1?
                                              Padding(padding: EdgeInsets.only( top: 16)):
                                              Container(
                                                margin: EdgeInsets.only(top:0, bottom: 16),
                                                padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.redLighten1,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text("El ${controller.calendarioPeriodoUI?.nombre??"período"} no se encuentra vigente.", textAlign: TextAlign.center,style: TextStyle(color: AppTheme.white, fontSize: 14),),
                                              ),
                                              Container(
                                                child: Text("U${sesionUi.nroUnidad}: ${sesionUi.tituloUnidad}", style: TextStyle(
                                                    fontSize: 16,
                                                    color: AppTheme.colorAccent,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: AppTheme.fontTTNorms
                                                ),),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(top: 8),
                                                child: Text("- ${controller.cursosUi.nombreCurso??""} ${controller.cursosUi.gradoSeccion??""} - ${controller.cursosUi.nivelAcademico??""}",
                                                  style: TextStyle( fontSize: 12),),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 8),
                                                height: 160,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(16))
                                                ),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: HexColor(controller.cursosUi.color1),
                                                          //color: AppTheme.colorSesion,
                                                          borderRadius: BorderRadius.all(Radius.circular(12))
                                                      ),
                                                      margin: EdgeInsets.all(8),
                                                      constraints: BoxConstraints.expand(),
                                                      padding: EdgeInsets.all(24),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                color: AppTheme.black.withOpacity(0.2),
                                                                borderRadius: BorderRadius.all(Radius.circular(6))
                                                            ),
                                                            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                                            child: RichText(
                                                              text: TextSpan(
                                                                  children: [
                                                                    TextSpan(text: "Sesión "),
                                                                    TextSpan(text: "Docente", style: new TextStyle(fontWeight: FontWeight.bold))
                                                                  ]
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(padding: EdgeInsets.all(4)),
                                                          Expanded(
                                                              child: Text("S${sesionUi.nroSesion}: ${sesionUi.titulo}",
                                                                textAlign: TextAlign.center,
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(color: AppTheme.white, fontSize: 20),
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 16,
                                                      left: 0,
                                                      right: 120,
                                                      child: Transform.rotate(
                                                        angle: -math.pi / 7,
                                                        child: Container(
                                                          width:35,
                                                          height:35,
                                                          margin: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
                                                          child: Image.asset(AppIcon.img_sesion_birrete),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ])
                                        ),
                                ),
                                SliverPadding(
                                  padding: EdgeInsets.only(left: 32, right: 32, top: 24),
                                  sliver:  SliverGrid(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: countRow,
                                      mainAxisSpacing: 24.0,
                                      crossAxisSpacing: 24.0,

                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index){
                                          dynamic o =  rubroSesionList[index];

                                          if(o is String){
                                            return InkWell(
                                              onTap: (){
                                                _guardarRubroyRetornar(context, controller);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: HexColor(controller.cursosUi.color2).withOpacity(1),
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
                                                    padding: EdgeInsets.all(4),
                                                    color: HexColor(controller.cursosUi.color2).withOpacity(1),
                                                    alignment: Alignment.center,
                                                    child:  Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(Ionicons.add, color: AppTheme.white, size: 45,),
                                                        Text("Crear Evaluación",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w800,
                                                              fontFamily: AppTheme.fontTTNorms,
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
                                            int position = (rubroSesionList.length) - index;
                                            return _getRubrica(position, o, controller);
                                          }
                                        },
                                        childCount: rubroSesionList.length
                                    ),
                                  ),
                                ),
                                SliverList(
                                    delegate: SliverChildListDelegate([
                                      Container(
                                        height: 100,
                                      )
                                    ])
                                ),
                              ]
                          ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        })
        .then((value) => {if(statetDialogRubroSesion!=null)controller.removeListener(statetDialogRubroSesion!), statetDialogRubroSesion = null});
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

  Widget? _getTipoNota(ValorTipoNotaUi? valorTipoNotaUi, double? nota) {

    switch(valorTipoNotaUi?.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO){
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
          child: Text(valorTipoNotaUi?.titulo??"",
              style: TextStyle(
                fontFamily: AppTheme.fontTTNormsMedium,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              )),
        );
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                      height: 3.5,
                      width: 3.5,
                      decoration: new BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      )
                  ),
                  Padding(padding: EdgeInsets.only(left: 8)),
                  Text(valorTipoNotaUi?.titulo??"",
                      style: TextStyle(
                        fontFamily: AppTheme.fontTTNormsMedium,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      )),
                  CachedNetworkImage(
                    height: 20,
                    width: 20,
                    imageUrl: valorTipoNotaUi?.icono??"",
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Padding(padding: EdgeInsets.only(left: 8)),
                  Expanded(child: Text(valorTipoNotaUi?.alias??"",))
                ],
              ),
              Padding(padding: EdgeInsets.only(left: 12),
                child:  Text("Valor numérico: " + (valorTipoNotaUi?.valorNumerico??0.0).toStringAsFixed(1),
                    style: TextStyle(
                      fontFamily: AppTheme.fontName,
                      fontSize: 8,
                    )
                ),
              ),
            ],
          ),
        );
      case TipoNotaTiposUi.VALOR_ASISTENCIA:
      case TipoNotaTiposUi.VALOR_NUMERICO:
      case TipoNotaTiposUi.SELECTOR_NUMERICO:
        Color color;
      if ((nota??0) < 10.5) {
        color = AppTheme.redDarken4;
      }else if ( (nota??0) >= 10.5) {
        color = AppTheme.blueDarken4;
      }else {
        color = AppTheme.black;
      }

        return Center(
          child: Text("${(nota??0).toStringAsFixed(1)}", style: TextStyle(
            fontFamily: AppTheme.fontTTNormsMedium,
            fontSize: 12,
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

  Widget _getRubrica(int index, RubricaEvaluacionUi rubricaEvalProcesoUi, RubroController controller) {
    String origen = "";
    switch(rubricaEvalProcesoUi.origenRubroUi??OrigenRubroUi.CREADO_DOCENTE){
      case OrigenRubroUi.GENERADO_INSTRUMENTO:
        origen = "Instrumento";
        break;
      case OrigenRubroUi.GENERADO_TAREA:
        origen = "Tarea";
        break;
      case OrigenRubroUi.GENERADO_PREGUNTA:
        origen = "Pregunta";
        break;
      case OrigenRubroUi.CREADO_DOCENTE:
        origen = "";
        break;
      case OrigenRubroUi.TODOS:
        origen = "";
        break;
    }

    String origen2 = "";
    if((rubricaEvalProcesoUi.sesionAprendizajeId??0) > 0){
      origen2 =  "Sesion";
    }else{
      origen2 =  "Mi Registro";
    }

    return InkWell(
      onTap: (){
        if((rubricaEvalProcesoUi.cantidadRubroDetalle??0) > 1){
          _evaluacionMultipleRetornar(context, controller, rubricaEvalProcesoUi);
        }else{
          _evaluacionSimpleRetornar(context, controller, rubricaEvalProcesoUi, controller.calendarioPeriodoUI);
        }
      },
      child:  Container(
        decoration: BoxDecoration(
            color: HexColor(controller.cursosUi.color1??"#FEFAE2").withOpacity(0.1),
            borderRadius: BorderRadius.circular(16) // use instead of BorderRadius.all(Radius.circular(20))
        ),
        child: Column(
          children: [
           Expanded(
               flex: 3,
               child:  Row(
                 children: [
                   Container(
                     margin: EdgeInsets.only(top: 12, bottom: 10, left: 12, right: 8),
                     width: 2.5,
                     decoration: BoxDecoration(
                         color: HexColor(controller.cursosUi.color2??"#8767EB"),
                         borderRadius: BorderRadius.circular(5) // use instead of BorderRadius.all(Radius.circular(20))
                     ),
                   ),
                   Expanded(
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Expanded(
                             flex: 8,
                             child: Container(
                               padding: EdgeInsets.only(top: 10, right: 0),
                               child: FittedBox(
                                 fit: BoxFit.scaleDown,
                                 child: Text("${index}.${origen} ${origen2}",
                                     overflow: TextOverflow.ellipsis,
                                     style: TextStyle(
                                       fontFamily: AppTheme.fontTTNorms,
                                       fontWeight: FontWeight.w700,
                                       letterSpacing: 0.5,
                                       fontSize: 12,
                                       color: (rubricaEvalProcesoUi.guardadoLocal??false)?AppTheme.red:AppTheme.darkerText,
                                     )),
                               ),
                             )
                         ),
                         Expanded(
                              flex: 7,
                             child: Padding(
                               padding: EdgeInsets.only(bottom: 8, top: 4),
                               child:  FittedBox(
                                 fit: BoxFit.fitWidth,
                                 child: Text("Media: ${rubricaEvalProcesoUi.mediaDesvicion}",
                                     style: TextStyle(
                                       fontFamily: AppTheme.fontTTNormsLigth,
                                       fontWeight: FontWeight.w700,
                                       fontSize: 8,
                                       letterSpacing: 0.5,
                                       color: AppTheme.darkerText.withOpacity(0.6),
                                     )

                                 ),
                               ),
                             )
                         )
                       ],
                     ),
                   ),
                   Padding(
                     padding: EdgeInsets.only(top: 4, right: 14, left: 4),
                     child: Icon(Ionicons.ellipsis_vertical_outline, color: AppTheme.darkerText, size: 14,),
                   )
                 ],
               ),
           ),
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)) // use instead of BorderRadius.all(Radius.circular(20))
                    ),
                  ),
                  controller.calendarioPeriodoUI?.habilitado==1?Container():
                  Positioned(
                      bottom: 8,
                      right: 8,
                      child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8),)
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Expanded(
                         flex: 1,
                         child: Padding(
                           padding: EdgeInsets.only(left: 14, top: 10, right: 14),
                           child: Row(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Icon(Ionicons.time, color: HexColor("#45D8B8"), size: 12,),
                               Padding(padding: EdgeInsets.only(left: 4)),
                               Expanded(
                                 child:  Stack(
                                  children: [
                                    FittedBox(
                                      child: Text(rubricaEvalProcesoUi.efechaCreacion??"",
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontTTNormsLigth,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 9,
                                            letterSpacing: 0.5,
                                            color: AppTheme.darkerText.withOpacity(0.6),
                                          )
                                      ),
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ],
                                 ),
                               ),
                               if(rubricaEvalProcesoUi.rubroGrupal??false)
                                 Icon(Ionicons.people, color: HexColor(controller.cursosUi.color2??"#8767EB"), size: 14,),
                               Padding(padding: EdgeInsets.only(left: 4)),
                               if(rubricaEvalProcesoUi.publicado??false)
                                 Icon(Ionicons.earth, color: HexColor(controller.cursosUi.color2??"#8767EB"), size: 14,)
                             ],
                           ),
                         ),
                     ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.only(left: 14, top: 8,bottom: 8, right: 14),
                          child: Text(rubricaEvalProcesoUi.titulo??"",
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppTheme.fontTTNormsMedium,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                letterSpacing: 1,
                                color: AppTheme.darkerText.withOpacity(0.8),
                              )
                          )
                        ),
                      ),

                    ],
                  ),
                  _getListRubricaDetalle(rubricaEvalProcesoUi, controller)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getListRubricaDetalle(RubricaEvaluacionUi rubricaEvaluacionUi, RubroController controller){
    return Positioned(
        bottom: 10,
        right: 34,
        left: 8,
        child: Row(
          children: [
            if((rubricaEvaluacionUi.cantidadRubroDetalle??0) >= 0)
            Container(
              height: 16,
              width: 16,
              decoration: new BoxDecoration(
                color: HexColor(controller.cursosUi.color2).withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              margin: EdgeInsets.only(right: 4),
              child: Center(
                child: Text("1", textAlign: TextAlign.center,style: TextStyle(fontSize: 10, color: AppTheme.white),),
              ),
            ),
            if((rubricaEvaluacionUi.cantidadRubroDetalle??0) > 1)
            Container(
              height: 16,
              width: 16,
              decoration: new BoxDecoration(
                color: HexColor(controller.cursosUi.color2).withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              margin: EdgeInsets.only(right: 4),
              child: Center(
                child: Text("2", textAlign: TextAlign.center,style: TextStyle(fontSize: 10, color: AppTheme.white),),
              ),
            ),
            if((rubricaEvaluacionUi.cantidadRubroDetalle??0) > 2)
            Container(
              height: 16,
              width: 16,
              decoration: new BoxDecoration(
                color: HexColor(controller.cursosUi.color2).withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              margin: EdgeInsets.only(right: 4),
              child: Center(
                child: Text("3", textAlign: TextAlign.center,style: TextStyle(fontSize: 10, color: AppTheme.white),),
              ),
            ),
            if((rubricaEvaluacionUi.cantidadRubroDetalle??0) > 3)
            Container(
              height: 16,
              width: 16,
              decoration: new BoxDecoration(
                color: HexColor(controller.cursosUi.color2).withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              margin: EdgeInsets.only(right: 4),
              child: Center(
                child: Text("4", textAlign: TextAlign.center,style: TextStyle(fontSize: 10, color: AppTheme.white),),
              ),
            ),
            if((rubricaEvaluacionUi.cantidadRubroDetalle??0) > 4)
              Container(
                height: 16,
                width: 16,
                decoration: new BoxDecoration(
                  color: HexColor(controller.cursosUi.color2).withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                margin: EdgeInsets.only(right: 4),
                child: Center(
                  child: Text(((rubricaEvaluacionUi.cantidadRubroDetalle??0)>5?"+":"")+ "5", textAlign: TextAlign.center,style: TextStyle(fontSize: 10, color: AppTheme.white),),
                ),
              ),
          ],
        )
    );
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




