import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_v2.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/resultado/resultado_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_calendario_periodo_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_resultado_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/resultado_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/resultado_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/resultado_evaluacion.dart';

import 'table_resultado.dart';

class ResultadoView extends View{
  CursosUi cursosUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;

  ResultadoView(this.cursosUi, this.calendarioPeriodoUI);

  @override
  _ResultadoState createState() => _ResultadoState(cursosUi, calendarioPeriodoUI, key: key);


}

class _ResultadoState extends ViewState<ResultadoView, ResultadoController> with TickerProviderStateMixin{
  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late AnimationController animationController;
  late final ScrollControllers scrollControllers = ScrollControllers();
  Key? key;

  _ResultadoState(CursosUi cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI, {this.key}) : super(ResultadoController(cursosUi, calendarioPeriodoUI, MoorConfiguracionRepository(), MoorCalendarioPeriodoRepository(), MoorResultadoRepository(), DeviceHttpDatosRepositorio()));

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
  Widget get view => ControlledWidgetBuilder<ResultadoController>(
      builder: (context, controller) {
        return Scaffold(
          key: key,
          extendBody: true,
          backgroundColor: AppTheme.background,
          body: Stack(
            children: [
              getMainTab(),
              getAppBarUI(),
              controller.progress?
              ArsProgressWidget(
                  blur: 2,
                  backgroundColor: Color(0x33000000),
                  animationDuration: Duration(milliseconds: 500)):
              Container(),
            ],
          ),
        );
      });

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
                        child: ControlledWidgetBuilder<ResultadoController>(
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
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget getMainTab() {
    return ControlledWidgetBuilder<ResultadoController>(
        builder: (context, controller) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: AppBar().preferredSize.height +
                      MediaQuery
                          .of(context)
                          .padding
                          .top +
                      16,
                  left: 0, //24,
                  right: 0, //48
                ),
                child: TableResultado(
                  calendarioPeriodoUI: controller.calendarioPeriodoUI,
                  rows: controller.rows,
                  cells: controller.cells,
                  columns: controller.columns,
                  datosOffline: controller.datosOffline,
                  cursosUi: controller.cursosUi,
                  precision: controller.precision,
                  scrollControllers: scrollControllers,
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
                        MediaQuery
                            .of(context)
                            .padding
                            .top +
                        0,
                  ),
                  child: Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.calendarioPeriodoList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 0, left: 8, right: 0, bottom: 0),
                                decoration: BoxDecoration(
                                  color: controller.cursosUi.color3 != null
                                      ? HexColor(controller.cursosUi.color3)
                                      : AppTheme.colorAccent,
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    bottomLeft: const Radius.circular(10.0),
                                  ),
                                ),
                                child: Container(
                                  height: 110,
                                  margin: const EdgeInsets.only(
                                      top: 1, left: 1, right: 1, bottom: 1),
                                  decoration: BoxDecoration(
                                    color: controller
                                        .calendarioPeriodoList[index]
                                        .selected ?? false
                                        ? AppTheme.white
                                        : controller.cursosUi.color3 != null
                                        ? HexColor(controller.cursosUi.color3)
                                        : AppTheme.colorAccent,
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      focusColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(9.0)),
                                      splashColor: AppTheme.black.withOpacity(
                                          0.1),
                                      onTap: () {
                                        controller.onSelectedCalendarioPeriodo(
                                            controller
                                                .calendarioPeriodoList[index]);
                                      },
                                      child: Center(
                                        child: RotatedBox(quarterTurns: 1,
                                            child: Text(controller
                                                .calendarioPeriodoList[index]
                                                .nombre ?? "".toUpperCase(),
                                              style: TextStyle(color: controller
                                                  .calendarioPeriodoList[index]
                                                  .selected ?? false
                                                  ? (controller.cursosUi
                                                  .color3 != null
                                                  ? HexColor(
                                                  controller.cursosUi.color3)
                                                  : AppTheme.colorAccent)
                                                  : AppTheme.white,
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 9),)
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

}


