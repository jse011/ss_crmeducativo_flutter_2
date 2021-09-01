import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/lista/sesion_lista_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_calendario_periodo_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_unidad_sesion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';

class SesionListaView extends View{
  CursosUi cursosUi;
  SesionListaView(this.cursosUi);

  @override
  _CursoListaViewState createState() => _CursoListaViewState(cursosUi);

}

class _CursoListaViewState extends ViewState<SesionListaView, SesionListaController> with TickerProviderStateMixin{

  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late AnimationController animationController;
  Function()? statetDialogSesion;

  _CursoListaViewState(cursoUi) : super(SesionListaController(cursoUi, MoorConfiguracionRepository(), MoorCalendarioPeriodoRepository(), DeviceHttpDatosRepositorio(), MoorUnidadSesionRepository()));

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
                    title: Text('Docente')),
                BottomNavigationBarItem(
                  // ignore: deprecated_member_use
                    icon: Container(),
                    // ignore: deprecated_member_use
                    title: Text('Alumno'))
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
                        child: ControlledWidgetBuilder<SesionListaController>(
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
                                      SvgPicture.asset(AppIcon.ic_curso_sesion, height: 35 +  6 - 8 * topBarOpacity, width: 35 +  6 - 8 * topBarOpacity,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 12, top: 8),
                                        child: Text(
                                          'Sesión',
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
                                          controller.onSyncronizarUnidades();
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
    return ControlledWidgetBuilder<SesionListaController>(
        builder: (context, controller) {

          var widthDp = context.widthPx;
          int countTareaRow;
          if (widthDp >= 800) {
            countTareaRow = 4;
          }if (widthDp >= 600) {
            countTareaRow = 3;
          } else if (widthDp >= 480) {
            countTareaRow = 2;
          } else {
            countTareaRow = 1;
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
                    progress(tabSesionDocente(controller, countTareaRow)),
                    progress(tabSesionAlumno(controller, countTareaRow)),
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
                                      splashColor: AppTheme.nearlyDarkBlue.withOpacity(0.8),
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


  Widget tabSesionDocente(SesionListaController controller, int countRow) {

     return Padding(
      padding: EdgeInsets.only(left: 24, right: 48),
      child: Stack(
        children: [
          controller.unidadUiDocenteList.isEmpty?
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
              itemCount: controller.unidadUiDocenteList.length,
              itemBuilder: (BuildContext ctxt, int index){
                UnidadUi unidadUi =  controller.unidadUiDocenteList[index];

                int cantidad = unidadUi.sesionUiList?.length??0;
                int cantSesionesVisibles = unidadUi.cantSesionesVisibles??0;
                bool vermas = cantSesionesVisibles < cantidad;
                int cantItems = vermas?cantSesionesVisibles+1:cantidad;

                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only( top: index==0?8:24, bottom: 16),
                        child: Text("U${unidadUi.nroUnidad}: ${unidadUi.titulo}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: AppTheme.fontTTNorms
                          ),
                        ),
                      ),
                      (unidadUi.sesionUiList?.length??0)>0?
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
                          itemCount: cantItems,
                          itemBuilder: (context, index){

                            if(vermas && cantSesionesVisibles == index){
                              return InkWell(
                                onTap: (){
                                  controller.unidadUiSelected = unidadUi;
                                  showSesionDocente(countRow, context);
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
                                              fontSize: 14,
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
                            }else {
                              SesionUi sesionUi = unidadUi.sesionUiList![index];
                              return getViewItemSesion(sesionUi, controller);
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
                    ]);
              },
            ),
          ),
          if(controller.progressDocente)
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );


  }

  Widget tabSesionAlumno(SesionListaController controller, int countRow) {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 48),
      child: Stack(
        children: [
          controller.unidadAUiAlumnoList.isEmpty?
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
              itemCount: controller.unidadAUiAlumnoList.length,
              itemBuilder: (BuildContext ctxt, int index){
                UnidadUi unidadUi =  controller.unidadAUiAlumnoList[index];
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only( top: index==0?8:24, bottom: 16),
                        child: Text("U${unidadUi.nroUnidad}: ${unidadUi.titulo}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: AppTheme.fontTTNorms
                          ),
                        ),
                      ),
                      (unidadUi.sesionUiList?.length??0)>0?
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
                          itemCount: unidadUi.sesionUiList?.length,
                          itemBuilder: (context, index){
                            SesionUi sesionUi = unidadUi.sesionUiList![index];
                            return InkWell(
                              onTap: (){
                                AppRouter.createRouteSesionPortalRouter(context, controller.cursosUi, sesionUi);
                              },
                              child: Stack(
                                children: [
                                  Container(
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
                                              Expanded(child: Text("Sesión ${sesionUi.nroSesion??0}", style: TextStyle(color: AppTheme.black, fontSize: 12, fontWeight: FontWeight.w600),),),
                                              Text(sesionUi.horas??"",  style: TextStyle(color: AppTheme.colorAccent, fontSize: 10,))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 12, right: 16, top: 4, bottom: 0),
                                          child: Text(sesionUi.fechaEjecucion??"",  style: TextStyle(color: AppTheme.colorAccent, fontSize: 10,)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 12, right: 16, top: 4, bottom: 0),
                                          child: Divider(
                                            height: 1,
                                            color: AppTheme.colorAccent,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 12, right: 16, top: 8, bottom: 0),
                                          child: Center(
                                            child: Text(sesionUi.titulo??"", style: TextStyle(color: AppTheme.black, fontSize: 12),),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 14,
                                    right: 14,
                                    child: Material(
                                      color: AppTheme.colorAccent.withOpacity(0.8),
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                            color: AppTheme.white,
                                            borderRadius: BorderRadius.circular(7) // use instead of BorderRadius.all(Radius.circular(20))
                                        ),
                                        child: InkWell(
                                          focusColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                          splashColor: HexColor(controller.cursosUi.color1).withOpacity(0.4),
                                          onTap: () {

                                          },
                                          child:
                                          Container(
                                              padding: const EdgeInsets.only(top: 4, left: 4, bottom: 4, right: 4),
                                              child: Text("Ejecución",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: AppTheme.colorAccent.withOpacity(0.9),
                                                  fontFamily: AppTheme.fontName,
                                                ),)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
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
                    ]);
              },
            ),
          ),
          if(controller.progressAlumno)
            Center(
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );


  }

  void showSesionDocente(int countRow, BuildContext context) {
    SesionListaController controller =
    FlutterCleanArchitecture.getController<SesionListaController>(context, listen: false);

    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              statetDialogSesion = (){
                setState((){});
              };
              controller.addListener(statetDialogSesion!);
              return Container(
                height: MediaQuery.of(context).size.height * 1,
                child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: new BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Column(
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
                                      icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6,),
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
                                      SvgPicture.asset(AppIcon.ic_curso_sesion, height: 35 +  6 , width: 35 +  6,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 12, top: 8),
                                        child: Text(
                                          'Sesión',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16 + 6,
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
                                        child: SizedBox(width: 43 + 6, height: 43 + 6,
                                          child: Icon(Ionicons.sync, size: 24 + 6,color: AppTheme.colorPrimary, ),
                                        ),
                                        onTap: () {
                                          controller.onSyncronizarUnidades();
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
                                    padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
                                    sliver: SliverList(
                                        delegate: SliverChildListDelegate([
                                          Text("U${controller.unidadUiSelected?.nroUnidad??0}: ${controller.unidadUiSelected?.titulo??""}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                fontFamily: AppTheme.fontTTNorms
                                            ),
                                          ),
                                        ])
                                    ),
                                  ),
                                  SliverPadding(
                                    padding: EdgeInsets.only(left: 24, right: 24, top: 24),
                                    sliver: SliverGrid(
                                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                        //crossAxisCount: countRow,
                                        maxCrossAxisExtent: 200.0,
                                        mainAxisExtent: 150.0,
                                        mainAxisSpacing: 24.0,
                                        crossAxisSpacing: 24.0,
                                        childAspectRatio: 1,
                                      ),
                                      delegate: SliverChildBuilderDelegate(
                                              (BuildContext context, int index){
                                            SesionUi sesionUi = controller.unidadUiSelected!.sesionUiList![index];
                                            return getViewItemSesion(sesionUi, controller);
                                          },
                                          childCount: controller.unidadUiSelected?.sesionUiList?.length??0
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
                      if(controller.progressDocente)
                        Center(
                          child: CircularProgressIndicator(),
                        )
                    ],
                  ),
                ),
              );
            },
          );
        })
        .then((value) => {
         if(statetDialogSesion!=null)controller.removeListener(statetDialogSesion!), statetDialogSesion = null
        });
  }

  Widget getViewItemSesion(SesionUi sesionUi, SesionListaController controller) {
    return InkWell(
      onTap: (){
        AppRouter.createRouteSesionPortalRouter(context, controller.cursosUi, sesionUi);
      },
      child: Stack(
        children: [
          Container(
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
                      Expanded(child: Text("Sesión ${sesionUi.nroSesion??0}", style: TextStyle(color: AppTheme.black, fontSize: 12, fontWeight: FontWeight.w600),),),
                      Text(sesionUi.horas??"",  style: TextStyle(color: HexColor(sesionUi.colorSesion), fontSize: 10,))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12, right: 16, top: 4, bottom: 0),
                  child: Text(sesionUi.fechaEjecucion??"",  style: TextStyle(color: HexColor(sesionUi.colorSesion), fontSize: 10,)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12, right: 16, top: 4, bottom: 0),
                  child: Divider(
                    height: 1,
                    color: HexColor(sesionUi.colorSesion),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12, right: 16, top: 8, bottom: 0),
                  child: Center(
                    child: Text(sesionUi.titulo??"", style: TextStyle(color: AppTheme.black, fontSize: 12),),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 14,
            right: 14,
            child: Material(
              color:HexColor(sesionUi.colorSesion).withOpacity(0.8),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              child: Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(7) // use instead of BorderRadius.all(Radius.circular(20))
                ),
                child: InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  splashColor: HexColor(controller.cursosUi.color1).withOpacity(0.4),
                  onTap: () {

                  },
                  child:
                  Container(
                      padding: const EdgeInsets.only(top: 4, left: 4, bottom: 4, right: 4),
                      child: Text(sesionUi.estadoEjecucion??"",
                        style: TextStyle(
                          fontSize: 10,
                          color: HexColor(sesionUi.colorSesion).withOpacity(0.9),
                          fontFamily: AppTheme.fontName,
                        ),)
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

