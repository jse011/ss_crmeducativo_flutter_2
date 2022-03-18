
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fancy_shimer_image/fancy_shimmer_image.dart';
import 'package:ss_crmeducativo_2/libs/flutterOffline/src/main.dart';
import 'package:ss_crmeducativo_2/src/app/page/carga_curso/curso/curso_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_calendario_periodo_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/anio_academico_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';

class CursoView extends View{
  CursosUi cursosUi;
  UsuarioUi? usuarioUi;
  AnioAcademicoUi anioAcademicoUi;


  CursoView(this.cursosUi, this.usuarioUi, this.anioAcademicoUi);

  @override
  _CursoViewState createState() => _CursoViewState(cursosUi, usuarioUi, anioAcademicoUi);

}

class _CursoViewState extends ViewState<CursoView, CursoController> with TickerProviderStateMixin{

  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  Function(bool connected)? _onChangeConnected;
  bool? _connected;

  _CursoViewState(cursosUi, usuarioUi, anioAcademicoUi)
      : super(CursoController(usuarioUi, anioAcademicoUi, cursosUi, MoorConfiguracionRepository(), MoorCalendarioPeriodoRepository(), DeviceHttpDatosRepositorio()));

  @override
  void initState() {

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


    super.initState();
  }

  @override
  Widget get view =>  ControlledWidgetBuilder<CursoController>(
      builder: (context, controller) {
        return Scaffold(
          backgroundColor:AppTheme.white,
          body: OfflineBuilder(
            connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
                ){
              bool connected = connectivity != ConnectivityResult.none;
              if(_connected!=null && connected != _connected){
                _onChangeConnected?.call(connected);
                controller.changeConnected(connected);
              }
              _connected = connected;
              return Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  Positioned(
                    height: 32.0,
                    left: 0.0,
                    right: 0.0,
                    child: AnimatedOpacity(
                      opacity: !connected ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 3000),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        color: connected ?  Color(0xFF00EE44) : Color(0xFFEE4400),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: connected
                              ? Text('Conectado')
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text('Sin conexión'),
                              SizedBox(width: 8.0),
                              SizedBox(
                                width: 12.0,
                                height: 12.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            child:  Stack(
              children: <Widget>[
                getMainTab(controller),
                controller.showProgress?  ArsProgressWidget(
                  blur: 2,
                  backgroundColor: Color(0x33000000),
                  animationDuration: Duration(milliseconds: 500),
                  dismissable: true,
                  onDismiss: (backgraund){
                    if(!backgraund){
                      controller.cerrarProgreso();
                    }

                  },
                ):Container(),
                getAppBarUI(controller),

              ],
            ),
          ),
        );
      });


  Widget getAppBarUI(CursoController controller) {
    return Column(
      children: <Widget>[
        Container(
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
                height: MediaQuery.of(context).padding.top,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context, 12),
                    right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context, 28),
                    top: ColumnCountProvider.aspectRatioForWidthPortalCurso(context, 18 - 10.0 * topBarOpacity),
                    bottom: ColumnCountProvider.aspectRatioForWidthPortalCurso(context, 14 - 10.0 * topBarOpacity)),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Ionicons.arrow_back,
                          color: AppTheme.nearlyBlack,
                          size: ColumnCountProvider.aspectRatioForWidthPortalCurso(context, 24 + 8 - 8 * topBarOpacity)
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          constraints: BoxConstraints(
                            //minWidth: 200.0,
                            maxWidth: 550.0,
                          ),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Container(
                                child:  Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalCurso(context, 12)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${controller.cursos?.nombreCurso??""}",
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontWeight: FontWeight.w900,
                                                fontSize: ColumnCountProvider.aspectRatioForWidthPortalCurso(context, 18 + 5 - 5 * topBarOpacity),
                                                letterSpacing: 1.2,
                                                color: AppTheme.darkerText,
                                              ),
                                            ),
                                            Text(
                                              "${controller.cursos?.gradoSeccion??""}",
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontWeight: FontWeight.w500,
                                                fontSize: ColumnCountProvider.aspectRatioForWidthPortalCurso(context, 15 + 5 - 5 * topBarOpacity),
                                                letterSpacing: 1.2,
                                                color: AppTheme.darkerText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    /*ClipOval(
                                                child: Material(
                                                  color: HexColor(controller.cursos?.color1).withOpacity(0.2), // button color
                                                  child: InkWell(
                                                    splashColor:HexColor(controller.cursos?.color1).withOpacity(0.5), // inkwell color
                                                    child: SizedBox(width: 45 + 6 - 8 * topBarOpacity, height: 45 + 6 - 8 * topBarOpacity,
                                                        child: Icon(Ionicons.mail_open_outline, size: 26 + 6 - 6 * topBarOpacity,color: HexColor(controller.cursos?.color1),)),
                                                    onTap: () {

                                                    },
                                                  ),
                                                ),
                                              ),*/
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context, 8)),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Container(
                                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.colorPrimary,),
                                  ),
                                  imageUrl: controller.anioAcademicoUi.georeferenciaUi?.entidadUi?.foto??"",
                                  errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: ColumnCountProvider.aspectRatioForWidthPortalCurso(context, 48 +10 - 10 * topBarOpacity)),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                          width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,  48 +10 - 10 * topBarOpacity),
                                          height: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,  48 +10 - 10 * topBarOpacity),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                      ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget getMainTab(CursoController controller) {
    return Container(
        padding: EdgeInsets.only(
          top: AppBar().preferredSize.height +
              MediaQuery.of(context).padding.top +
              0,
        ),
        child:Stack(
          children: [
            CustomScrollView(
              controller: scrollController,
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(padding: EdgeInsets.only( top: ColumnCountProvider.aspectRatioForWidthPortalCurso(context, 50))),
                        (controller.progress)?
                        Center(
                          child: Container(
                              constraints: BoxConstraints(
                                //minWidth: 200.0,
                                maxWidth: 600.0,
                              ),
                              height: 45,
                              margin: EdgeInsets.only(
                                  top: 0,
                                  left: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                  right: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                  bottom: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 16)
                              ),
                              decoration: BoxDecoration(
                                  color: HexColor("#e5faf3"),
                                  borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8)))
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8))),
                                  Container(
                                      width: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 24),
                                      height: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 24),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: HexColor("#00c985"),
                                        ),
                                      )
                                  ),
                                  Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 4))),
                                  Flexible(
                                    child:  Container(
                                      padding: EdgeInsets.all(8),
                                      child: Text('Actualizando el bimestres o trimestres',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color:  HexColor("#00c985"),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              fontFamily: AppTheme.fontTTNorms
                                          )
                                      ),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 4))),
                                ],
                              )
                          ),
                        ): Container(),
                        (!controller.conexion && !controller.progress)?
                        Center(
                          child: Container(
                              constraints: BoxConstraints(
                                //minWidth: 200.0,
                                maxWidth: 600.0,
                              ),
                              height: 45,
                              margin: EdgeInsets.only(
                                  top: 0,
                                  left: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                  right: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                  bottom: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 16)
                              ),
                              decoration: BoxDecoration(
                                  color: AppTheme.redLighten5,
                                  borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8)))
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 24),
                                      height: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 24),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color:  Colors.red,
                                        ),
                                      )
                                  ),
                                  Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 4))),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text('Sin conexión',
                                        style: TextStyle(
                                            color:  Colors.red,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            fontFamily: AppTheme.fontTTNorms
                                        )
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ): Container(),

                        Stack(
                          children: [
                            Center(
                              child: Container(
                                constraints: BoxConstraints(
                                  //minWidth: 200.0,
                                  maxWidth: 550.0,
                                ),
                                child:  Container(
                                  height: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,180),
                                  margin: EdgeInsets.only(
                                      left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,24),
                                      right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,24)
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 8, right: 8),
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    color: HexColor(controller.cursos?.color2).withOpacity(0.4),
                                                    offset:  Offset(0,3),
                                                    blurRadius: 6.0,
                                                    spreadRadius: 0
                                                ),
                                              ],
                                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context, 28))))
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20))),
                                        child: controller.cursos?.banner!=null?FancyShimmerImage(
                                          boxFit: BoxFit.cover,
                                          imageUrl: controller.cursos?.banner??'',
                                          width: MediaQuery.of(context).size.width,
                                          errorWidget: Icon(Icons.warning_amber_rounded, color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,105),),
                                        ):
                                        Container(),
                                      ),
                                      Opacity(
                                        opacity: 0.6,
                                        child:  Container(
                                          decoration: BoxDecoration(
                                              color: HexColor(controller.cursos?.color1),
                                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20)))
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 16,
                                        top: 0,
                                        bottom: 0,
                                        child: Opacity(
                                          opacity:1,
                                          child: SvgPicture.asset(AppIcon.ic_curso_exam,
                                            width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,150),
                                            height: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,150),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,150)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20),
                                                  left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20)
                                              ),
                                              child:  Material(
                                                color: HexColor(controller.cursos?.color3),
                                                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8))),
                                                child: InkWell(
                                                  focusColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  hoverColor: Colors.transparent,
                                                  borderRadius:  BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8))),
                                                  splashColor: AppTheme.colorPrimary.withOpacity(0.4),
                                                  onTap: () {

                                                  },
                                                  child:
                                                  Container(
                                                      padding:  EdgeInsets.only(
                                                          top: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,4),
                                                          left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,10),
                                                          bottom: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8),
                                                          right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,10)
                                                      ),
                                                      child: Text("Nuevo",
                                                        style: TextStyle(
                                                          fontSize: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,13),
                                                          letterSpacing: 0.8,
                                                          color: AppTheme.white,
                                                          fontWeight: FontWeight.w900,
                                                          fontFamily: AppTheme.fontTTNorms,
                                                        ),)
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                child:  Container(
                                                  padding: EdgeInsets.only(
                                                      left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,24),
                                                      top: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,16)
                                                  ),
                                                  child: Text("Registro\nde evaluación\npor competencias",
                                                    maxLines: 3,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,17),
                                                        fontFamily: AppTheme.fontTTNorms,
                                                        fontWeight: FontWeight.w900 ),),
                                                )
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,24),
                                                  bottom: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20)
                                              ),
                                              child: Row(
                                                children: [
                                                  Text("Haga clic en evaluación y experimente ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: AppTheme.fontTTNorms,
                                                          fontSize: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,12)
                                                      )
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,2))
                                                  ),
                                                  SvgPicture.asset(AppIcon.ic_curso_flecha,
                                                    color: AppTheme.white,
                                                    width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,17),
                                                    height: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,17),
                                                  )
                                                ],
                                              ) ,
                                            )

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only( top: 24)),
                        Stack(
                          children: [
                            Center(
                              child: Container(
                                constraints: BoxConstraints(
                                  //minWidth: 200.0,
                                  maxWidth: 550.0,
                                ),
                                child:  GestureDetector(
                                  onTap: () =>  {
                                    AppRouter.createRouteSesionListaRouter(context, controller.usuarioUi, controller.cursos!)
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
                                          color: HexColor(controller.cursos?.color1).withOpacity(0.2),
                                          width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,2)
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,22))),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8)),
                                          decoration: BoxDecoration(
                                              color: HexColor("#E3F8FA"),
                                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,16)))
                                          ),
                                          width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,65),
                                          height: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,65),
                                          child: Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,10)), child: SvgPicture.asset(AppIcon.ic_curso_sesion),),
                                        ),
                                        Padding(padding: EdgeInsets.only(left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8))),
                                        Expanded(
                                            child: Text("Sesiones", style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w700,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20),
                                              letterSpacing: 1.2,
                                              color: AppTheme.darkerText,
                                            ),)
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8),
                                              right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,28)
                                          ),
                                          child: ClipOval(
                                            child: Material(
                                              color: HexColor(controller.cursos?.color1), // button color
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
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Stack(
                          children: [
                            Center(
                              child: Container(
                                constraints: BoxConstraints(
                                  //minWidth: 200.0,
                                  maxWidth: 550.0,
                                ),
                                child:   GestureDetector(
                                  onTap: () => {
                                    if(context!=null && controller.cursos != null){
                                      AppRouter.createRouteTareaRouter(context, controller.usuarioUi, controller.cursos!)
                                    }
                                  },
                                  child:  Container(
                                    height: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,90),
                                    margin: EdgeInsets.only(
                                        top: 0,
                                        left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,24),
                                        right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,24),
                                        bottom: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20)
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:  HexColor(controller.cursos?.color1).withOpacity(0.2),
                                            width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,2)
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,22)))
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8)),
                                          decoration: BoxDecoration(
                                              color: HexColor("#FFF8EE"),
                                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,16)))
                                          ),
                                          width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,65),
                                          child: Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,10)), child: SvgPicture.asset(AppIcon.ic_curso_tarea),),
                                        ),
                                        Padding(padding: EdgeInsets.only(left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8))),
                                        Expanded(
                                            child: Text("Tareas", style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w700,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20),
                                              letterSpacing: 0.8,
                                              color: AppTheme.darkerText,
                                            ),)
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8),
                                              right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,28)
                                          ),
                                          child: ClipOval(
                                            child: Material(
                                              color: HexColor(controller.cursos?.color1), // button color
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
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Stack(
                          children: [
                            Center(
                              child: Container(
                                constraints: BoxConstraints(
                                  //minWidth: 200.0,
                                  maxWidth: 550.0,
                                ),
                                child: GestureDetector(
                                  onTap: () =>  {
                                    if(context!=null && controller.cursos != null){
                                      AppRouter.createRouteRubrosRouter(context, controller.cursos!)
                                    }
                                  },
                                  child: Container(
                                    height: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,90),
                                    margin: EdgeInsets.only(top: 0,
                                        left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,24),
                                        right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,24),
                                        bottom: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20)
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color:  HexColor(controller.cursos?.color1).withOpacity(0.2),
                                            width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,2)
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,22)))
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8)),
                                          decoration: BoxDecoration(
                                              color: HexColor("#EDF8FF"),
                                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,16)))
                                          ),
                                          width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,65),
                                          child: Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,10)), child: SvgPicture.asset(AppIcon.ic_curso_evaluacion),),
                                        ),
                                        Padding(padding: EdgeInsets.only(left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8))),
                                        Expanded(
                                            child: Text("Evaluación", style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w700,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20),
                                              letterSpacing: 0.8,
                                              color: AppTheme.darkerText,
                                            ),)
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8),
                                              right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,28)
                                          ),
                                          child: ClipOval(
                                            child: Material(
                                              color: HexColor(controller.cursos?.color1), // button color
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
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Stack(
                          children: [
                            Center(
                              child: Container(
                                constraints: BoxConstraints(
                                  //minWidth: 200.0,
                                  maxWidth: 550.0,
                                ),
                                child:  Container(
                                  height: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,90),
                                  margin: EdgeInsets.only(
                                      top: 0,
                                      left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,24),
                                      right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,24),
                                      bottom: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20)
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: HexColor(controller.cursos?.color1).withOpacity(0.2),
                                          width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,2)
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,22)))
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8)),
                                        decoration: BoxDecoration(
                                            color: HexColor("#FFECFA"),
                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,16)))
                                        ),
                                        width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,65),
                                        child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_curso_grupo),),
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 8)),
                                      Expanded(
                                          child: Text("Grupos", style: TextStyle(
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontWeight: FontWeight.w700,
                                            fontSize: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20),
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
                                            color: HexColor(controller.cursos?.color1), // button color
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
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Stack(
                          children: [
                            Center(
                              child: Container(
                                constraints: BoxConstraints(
                                  //minWidth: 200.0,
                                  maxWidth: 550.0,
                                ),
                                child:   GestureDetector(
                                  onTap: (){
                                    if(context!=null && controller.cursos != null){
                                      AppRouter.createRouteResultadoRouter(context, controller.cursos!, null);
                                    }
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
                                            color: HexColor(controller.cursos?.color1).withOpacity(0.2),
                                            width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,2)
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,22)))
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,8)),
                                          decoration: BoxDecoration(
                                              color: HexColor("#edf2fb"),
                                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,16)))
                                          ),
                                          width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,65),
                                          child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_curso_nota_final),),
                                        ),
                                        Padding(padding: EdgeInsets.only(left: 8)),
                                        Expanded(
                                            child: Text("Resultado", style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w700,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20),
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
                                              color: HexColor(controller.cursos?.color1), // button color
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
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Stack(
                          children: [
                            Center(
                              child: InkWell(
                                onTap: () async {
                                  dynamic respuesta = await AppRouter.showAgendaPortalView(context, controller.cursos);
                                },
                                child: Container(
                                  constraints: BoxConstraints(
                                    //minWidth: 200.0,
                                    maxWidth: 550.0,
                                  ),
                                  child:  Container(
                                    height: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,90),
                                    margin: EdgeInsets.only(
                                        top: 0,
                                        left: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,24),
                                        right: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,24),
                                        bottom: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20)
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: HexColor(controller.cursos?.color1).withOpacity(0.2),
                                            width: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,2)
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalCurso(context,22)))
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
                                              fontWeight: FontWeight.w700,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthPortalCurso(context,20),
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
                                              color: HexColor(controller.cursos?.color1), // button color
                                              child:SizedBox(
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
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only( top: 150)),
                      ],
                    )
                ),
              ],
            ),
          ],
        )
    );

  }

}