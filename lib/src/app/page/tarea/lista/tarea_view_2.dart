import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/lista/tarea_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_calendario_periodo_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_unidad_tarea_repositoy.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';

class TareaView2 extends View{
  CursosUi cursosUi;
  TareaView2(this.cursosUi);

  @override
  _TareaViewState createState() => _TareaViewState(cursosUi);

}

class _TareaViewState extends ViewState<TareaView2, TareaController> with TickerProviderStateMixin{

  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late AnimationController animationController;

  _TareaViewState(cursoUi) : super(TareaController(cursoUi, MoorConfiguracionRepository(), MoorCalendarioPeriodoRepository(), DeviceHttpDatosRepositorio(), MoorUnidadTareaRepository()));

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

  Widget get view => ControlledWidgetBuilder<TareaController>(
      builder: (context, controller) {
        return Scaffold(
          extendBody: true,
          backgroundColor: AppTheme.background,
          body: Stack(
            children: [
              getMainTab(),
              getAppBarUI(),
              if(controller.progress)ArsProgressWidget(
                blur: 2,
                backgroundColor: Color(0x33000000),
                animationDuration: Duration(milliseconds: 500),
              ),
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
                        child: ControlledWidgetBuilder<TareaController>(
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
                                      SvgPicture.asset(AppIcon.ic_curso_tarea, height: 35 +  6 - 8 * topBarOpacity, width: 35 +  6 - 8 * topBarOpacity,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 12, top: 8),
                                        child: Text(
                                          'Trabajo',
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
    return ControlledWidgetBuilder<TareaController>(
        builder: (context, controller) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery.of(context).padding.top +
                        0,
                    left: 0,//24,
                    right: 0,//48
                ),
                child: Stack(
                  children: [
                    false?
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
                    ):Container(),
                    SingleChildScrollView(
                      physics: ScrollPhysics(),
                      controller: scrollController,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.unidadUiList.length,
                        itemBuilder: (BuildContext ctxt, int index){

                          UnidadUi unidadUi =  controller.unidadUiList[index];

                          /*int cantidad = unidadUi.sesionUiList?.length??0;
                          int cantSesionesVisibles = unidadUi.cantSesionesVisibles??0;
                          bool vermas = cantSesionesVisibles < cantidad;
                          int cantItems = vermas?cantSesionesVisibles+1:cantidad;*/

                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 24, right: 48),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only( top: index==0?8:32, bottom: 24),
                                        child: Text("U${unidadUi.nroUnidad??""}: ${unidadUi.titulo??""}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: AppTheme.fontTTNorms
                                          ),
                                        ),
                                      ),
                                      true?
                                      GridView.builder(
                                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                            //crossAxisCount: countRow,
                                            maxCrossAxisExtent: 200.0,
                                            mainAxisExtent: 150.0,
                                            mainAxisSpacing: 24.0,
                                            crossAxisSpacing: 24.0,
                                            childAspectRatio: 1,
                                          ),
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: (unidadUi.tareaUiList?.length??0)+1 ,
                                          itemBuilder: (context, index){


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
                                                    alignment: Alignment.center,
                                                    child:  Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(Ionicons.add, color: AppTheme.white, size: 36,),
                                                        Text("Crear tarea",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w500,
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
                                                    color: AppTheme.white,
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
                                                          Icon(Icons.assignment, color: HexColor(controller.cursosUi.color1), size: 16,),
                                                          Padding(padding: EdgeInsets.all(2)),
                                                          Text("Tarea ${index}", style: TextStyle(color: HexColor(controller.cursosUi.color1), fontSize: 12, fontWeight: FontWeight.w500),),
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
                              Container(
                                margin: EdgeInsets.only(left: 24, right: 48, top: 18),
                                padding: EdgeInsets.all(10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: AppTheme.white,
                                    borderRadius: BorderRadius.circular(14) // use instead of BorderRadius.all(Radius.circular(20))
                                ),
                                child: Center(
                                  child: Text("Ver más tareas", style: TextStyle(color: AppTheme.black, fontSize: 12, fontWeight: FontWeight.w500),),
                                ),
                              ),

                            ],
                          );
                        },
                      ),
                    ),
                  ],
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
                                      splashColor: AppTheme.black.withOpacity(0.1),
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



  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return true;
  }


}