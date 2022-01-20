
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fancy_shimer_image/fancy_shimmer_image.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/close_sesion.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/animation_view.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/dropdown_formfield_2.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/anio_academico_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/georeferencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/programa_educativo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';

import 'portal_docente_controller.dart';

class PortalDocenteView extends View{
  final AnimationController animationController;
  final MenuBuilder? menuBuilder;
  final CloseSession closeSessionHandler;

  PortalDocenteView({required this.animationController, this.menuBuilder, required this.closeSessionHandler});

  @override
  _PortalDocenteViewState createState() => _PortalDocenteViewState();

}

class _PortalDocenteViewState extends ViewState<PortalDocenteView, PortalDocenteController>{
  final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late Animation<double> topBarAnimation;

  _PortalDocenteViewState()
      : super(PortalDocenteController(MoorConfiguracionRepository(), DeviceHttpDatosRepositorio()));


  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
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

    Future.delayed(const Duration(milliseconds: 300), () {
// Here you can write your code
      setState(() {
        widget.animationController.forward();
      });

    });
    super.initState();
  }


  @override
  Widget get view =>  WillPopScope(
    onWillPop: () async{
      return await widget.closeSessionHandler.closeSession()??false;
    },
    child: ControlledWidgetBuilder<PortalDocenteController>(
        builder: (context, controller) {
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            widget.menuBuilder?.call(getMenuView(controller));
          });

          return Container(
            color: AppTheme.background,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: <Widget>[
                  getMainListViewUI(),
                  getAppBarUI(),
                ],
              ),
            ),
          );
        }),
  );

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
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
                            left: 0,
                            right: 0,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: ControlledWidgetBuilder<PortalDocenteController>(
                          builder: (context, controller) {
                            return Container(
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 24, right: 24,top: 8 * topBarOpacity, bottom: 8),
                                      child: Text(
                                        '${"Portal docente"}',
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18 + 8 - 4 * topBarOpacity,
                                          letterSpacing: 1.2,
                                          color: AppTheme.darkerText,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
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

  List<int> list = [1,2,3,4,5];
  int countView = 11;
  Widget getMainListViewUI() {
    return  AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext? context, Widget? child) {
        return FadeTransition(
          opacity: topBarAnimation,
          child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
              child: Container(
                  padding: EdgeInsets.only(
                      top: AppBar().preferredSize.height +
              MediaQuery.of(context!).padding.top +
              0,
                      //top: AppBar().preferredSize.height - 14
                  ),
                  child: ControlledWidgetBuilder<PortalDocenteController>(
                      builder: (context, controller) {
                        return Stack(
                          children: [
                            CustomScrollView(
                              controller: scrollController,
                              slivers: <Widget>[
                                SliverList(
                                    delegate: SliverChildListDelegate(
                                      [
                                        Padding(padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 16))),
                                        Center(
                                          child: InkWell(
                                            onTap: (){
                                              showDialogButtom(controller);
                                            },
                                            child: Container(
                                              constraints: BoxConstraints(
                                                //minWidth: 200.0,
                                                maxWidth: 600.0,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8))),
                                                color: AppTheme.colorPrimary.withOpacity(0.1),
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                      color: AppTheme.grey.withOpacity(0.1),
                                                      offset:  Offset(0,10),
                                                      blurRadius: 10.0,
                                                      spreadRadius: 0
                                                  ),
                                                ],
                                              ),
                                              margin: EdgeInsets.only(
                                                  top: 0,
                                                  left: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                                  right: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20)
                                              ),
                                              padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20)),
                                              child: Row(
                                                children: [
                                                  CachedNetworkImage(
                                                    placeholder: (context, url) => Container(
                                                      child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.colorPrimary,),
                                                    ),
                                                    imageUrl: controller.georeferenciaUi?.entidadUi?.foto??"",
                                                    errorWidget: (context, url, error) =>  (controller.georeferenciaUi?.entidadUi?.foto??"").isNotEmpty?
                                                    Icon(Icons.error_outline_rounded, size: 42):
                                                    Container(),
                                                    imageBuilder: (context, imageProvider) =>
                                                        Container(
                                                            width: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 44),
                                                            height: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 44),
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                image: imageProvider,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            )
                                                        ),
                                                  ),
                                                  Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 10))),
                                                  Expanded(child: Text("${controller.georeferenciaUi?.nombre??""}. Año académico ${controller.anioAcademicoUi?.nombre??""}.",
                                                    style: TextStyle(
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 16),
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: AppTheme.fontTTNorms
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 26))),
                                      ],
                                    )
                                ),
                                SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index){
                                          CursosUi cursoUi = controller.cursosUiList[index];
                                          ProgramaEducativoUi? programaEducativoUi = controller.programaEducativoUi;
                                          UsuarioUi? usuarioUi = controller.usuarioUi;
                                          return Stack(
                                            children: [
                                              Center(
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                    //minWidth: 200.0,
                                                    maxWidth: 550.0,
                                                  ),
                                                  child: getCuros(usuarioUi, cursoUi, programaEducativoUi, controller.anioAcademicoUi),
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                        childCount: controller.cursosUiList.length
                                    )
                                ),
                                SliverList(
                                    delegate: SliverChildListDelegate(
                                      [
                                        Padding(padding: EdgeInsets.only( bottom: 100))
                                      ],
                                    )
                                ),
                              ],
                            ),
                            controller.isLoading ?  Container(child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.colorPrimary,),
                            )): Container(),
                          ],
                        );
                      })
              )
          ),
        );
      },
    );
    /*ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.only(
        top: AppBar().preferredSize.height +
            MediaQuery.of(context).padding.top +
            24,
        bottom: 62 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: listViews.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        widget.animationController.forward();
        return listViews[index];
      },
    );*/
  }


  Widget getCuros( UsuarioUi? usuarioUi, CursosUi cursoUi, ProgramaEducativoUi? programaEducativoUi, AnioAcademicoUi? anioAcademicoUi){
    return GestureDetector(
      onTap: () {
        cursoUi.nivelAcademico = programaEducativoUi?.nivelAcademico;
        AppRouter.createRouteCursosRouter(context, usuarioUi, cursoUi, anioAcademicoUi);
      },
      child:  Padding(
        padding: EdgeInsets.only(
            left: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 26),
            right: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 26),
            top: 0,
            bottom: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 24)),
        child: Container(
          height: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 165),
          child: Stack(
            children: [
              Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: HexColor(cursoUi.color2).withOpacity(0.4),
                            offset:  Offset(0,3),
                            blurRadius: 6.0,
                            spreadRadius: 0
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20))))
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20))),
                child: cursoUi.banner!=null?FancyShimmerImage(
                  boxFit: BoxFit.cover,
                  imageUrl: cursoUi.banner??'',
                  width: MediaQuery.of(context).size.width,
                  errorWidget: Icon(Icons.warning_amber_rounded, color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 50),),
                ):
                Container(),
              ),
              Opacity(
                  opacity: 0.5,
                  child:  Container(
                      decoration: BoxDecoration(
                          color:  cursoUi.color1!=null&&cursoUi.color1!.isNotEmpty?
                          HexColor(cursoUi.color1):AppTheme.nearlyDarkBlue,
                          borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 19))))
                  ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 19)))),
                padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 24)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top:0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text((cursoUi.nombreCurso??""),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                        color: AppTheme.white,
                                        fontWeight: FontWeight.w900,
                                        fontFamily: AppTheme.fontTTNorms
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 4))
                                  ),
                                  Text("${cursoUi.gradoSeccion??""}  ${programaEducativoUi?.nivelAcademico??""}",
                                      style: TextStyle(
                                          fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 16),
                                          color: AppTheme.white,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: AppTheme.fontTTNorms
                                      )
                                  ),
                                ],
                              ),
                            )
                        ),

                      ],
                    ),
                    Expanded(
                        child: Container(

                        )
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /*Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${anioAcademicoUi?.nombre??""}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 16),
                                    color: AppTheme.white,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppTheme.fontTTNorms
                                )
                            ),
                          ],
                        ),*/
                        Expanded(
                          child: Container(),
                        ),
                        Text("${cursoUi.nroSalon??""}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 16),
                                color: AppTheme.white,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppTheme.fontTTNorms
                            )
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<bool?> showDialogButtom(PortalDocenteController controller) async {
    void Function(VoidCallback fn)? refresh = null;
    dialogState(){
      refresh?.call((){});
     };
    controller.addListener(dialogState);

    return await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return ArsProgressWidget(
              blur: 2,
              backgroundColor: Color(0x33000000),
              animationDuration: Duration(milliseconds: 500),
              loadingWidget: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 16)), // if you need this
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter childStte){
                    refresh = childStte;
                    return  Container(
                      constraints: BoxConstraints(minWidth: 100, maxWidth: 400),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            constraints: MediaQuery.of(context).orientation == Orientation.landscape?BoxConstraints( maxHeight: MediaQuery.of(context).size.width-200):null,
                            child:  SingleChildScrollView(
                              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(padding: EdgeInsets.all(8)),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 40),
                                            height: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 40),
                                            child: Icon(Icons.home, size: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 25), color: AppTheme.white,),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0XFF103347)),
                                          ),
                                          Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 4))),
                                          Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(padding: EdgeInsets.all(0),),
                                                  Text("Cambiar de colegio",
                                                    style: TextStyle(
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 17),
                                                        color: Color(0XFF103347),
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: AppTheme.fontTTNorms
                                                    ),),
                                                ],
                                              )
                                          ),
                                        ],
                                      ),
                                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 4))),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8),
                                            right: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8),
                                            top: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8)
                                        ),
                                        child: DropDownFormField2<GeoreferenciaUi>(
                                          inputDecoration: InputDecoration(
                                            labelText: "Colegio",
                                            labelStyle: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w800,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                                            ),
                                            helperText: " ",
                                            contentPadding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15)),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8)),
                                              borderSide: BorderSide(
                                                color: AppTheme.colorPrimary.withOpacity(0.5),
                                              ),
                                            ),
                                            suffixIcon: !controller.isLoading? IconButton(
                                              onPressed: (){
                                                //controller.clearTitulo();
                                                //_tiuloRubricacontroller.clear();
                                              },
                                              icon: Icon(
                                                Ionicons.caret_down,
                                                color: AppTheme.colorPrimary,
                                              ),
                                              iconSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                                            ):null,
                                          ),
                                          onChanged: !controller.isLoading?(item){
                                            controller.onSelectGeoreferencia(item);
                                          }:null,
                                          menuItems: controller.georeferenciaUiList.map<DropdownMenuItem<GeoreferenciaUi>>((item) {
                                            return DropdownMenuItem<GeoreferenciaUi>(child:
                                            Row(
                                              children: [
                                                Expanded(child:  Padding(
                                                  padding: EdgeInsets.only(left: 0),
                                                  child: Text("${item.nombre??""}",
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontTTNorms,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                                                      )
                                                  ),
                                                )),
                                                controller.isLoading?
                                                Container(
                                                  height: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                                  width: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                                  margin: EdgeInsets.only(right: 0),
                                                  child:  Center(
                                                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.colorPrimary,),
                                                  ),
                                                ):Container()
                                              ],
                                            ), value: item,);
                                          }).toList(),
                                          value: controller.georeferenciaUi,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 40),
                                        height: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 40),
                                        child: Icon(Icons.today, size: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 25), color: AppTheme.white,),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0XFF47102b)),
                                      ),
                                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 4))),
                                      Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 4)),),
                                              Text("Cambiar de año académico",
                                                style: TextStyle(
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 17),
                                                    color: Color(0XFF47102b),
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: AppTheme.fontTTNorms
                                                ),),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 4))),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8),
                                        right: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8),
                                        top: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8)
                                    ),
                                    child: DropDownFormField2<AnioAcademicoUi>(
                                      inputDecoration: InputDecoration(
                                        labelText: "Año académico",
                                        labelStyle: TextStyle(
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontWeight: FontWeight.w800,
                                          fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                                        ),
                                        helperText: " ",
                                        contentPadding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8)),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary.withOpacity(0.5),
                                          ),
                                        ),
                                        suffixIcon: !controller.isLoading? IconButton(
                                          onPressed: (){
                                            //controller.clearTitulo();
                                            //_tiuloRubricacontroller.clear();
                                          },
                                          icon: Icon(
                                            Ionicons.caret_down,
                                            color: AppTheme.colorPrimary,
                                          ),
                                          iconSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                                        ):null,
                                      ),
                                      onChanged:  !controller.isLoading?(item){
                                        controller.onSelectAnioAcademico(item);
                                      }:null,
                                      menuItems: controller.georeferenciaUi?.anioAcademicoUiList?.map<DropdownMenuItem<AnioAcademicoUi>>((item) {
                                        return DropdownMenuItem<AnioAcademicoUi>(child:
                                        Row(
                                          children: [
                                            Expanded(child: Padding(
                                              padding: EdgeInsets.only(left: 0),
                                              child: Text("${item.nombre??""}",
                                                  style: TextStyle(
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                                                  )
                                              ),
                                            )),
                                            controller.isLoading?
                                            Container(
                                                height: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                                width: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                                margin: EdgeInsets.only(right: 0),
                                                child:  Center(
                                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.colorPrimary,),
                                                ),
                                            ):Container()
                                          ],
                                        ), value: item,);
                                      }).toList(),
                                      value: controller.anioAcademicoUi,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 40),
                                            height: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 40),
                                            child: Icon(Icons.dns, size: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 25), color: AppTheme.white,),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0XFF66173d)),
                                          ),
                                          Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 4))),
                                          Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(padding: EdgeInsets.all(0),),
                                                  Text("Cambiar de programa",
                                                    style: TextStyle(
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 17),
                                                        color: Color(0XFF66173d),
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: AppTheme.fontTTNorms
                                                    ),),
                                                  Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8))),
                                                ],
                                              )
                                          ),
                                        ],
                                      ),
                                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 4))),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8),
                                            right: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8),
                                            top: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8)
                                        ),
                                        child: DropDownFormField2<ProgramaEducativoUi>(
                                          inputDecoration: InputDecoration(
                                            labelText: "Programa",
                                            labelStyle: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w800,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                                            ),
                                            helperText: " ",
                                            contentPadding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15)),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8)),
                                              borderSide: BorderSide(
                                                color: AppTheme.colorPrimary.withOpacity(0.5),
                                              ),
                                            ),
                                            suffixIcon: !controller.isLoading? IconButton(
                                              onPressed: (){
                                                //controller.clearTitulo();
                                                //_tiuloRubricacontroller.clear();
                                              },
                                              icon: Icon(
                                                Ionicons.caret_down,
                                                color: AppTheme.colorPrimary,
                                              ),
                                              iconSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                                            ):null,
                                          ),
                                          onChanged:  !controller.isLoading?(item){
                                            controller.onSelectPrograma(item);
                                          }:null,
                                          menuItems: controller.programaEducativoUiList.map<DropdownMenuItem<ProgramaEducativoUi>>((item) {
                                            return DropdownMenuItem<ProgramaEducativoUi>(child:
                                            Row(
                                              children: [
                                                Expanded(
                                                    child:  Padding(
                                                      padding: EdgeInsets.only(left: 0),
                                                      child: Text("${item.nombrePrograma??""}",
                                                          style: TextStyle(
                                                            fontFamily: AppTheme.fontTTNorms,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                                                          )
                                                      ),
                                                    )
                                                ),  controller.isLoading?
                                                Container(
                                                  height: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                                  width: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                                  margin: EdgeInsets.only(right: 0),
                                                  child:  Center(
                                                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.colorPrimary,),
                                                  ),
                                                ):Container()

                                              ],
                                            ), value: item,);
                                          }).toList(),
                                          value: controller.programaEducativoUi,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 16),
                                right: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 16),
                                bottom: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 16)
                            ),
                            child:  Row(
                              children: [
                                Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('Atras', style: TextStyle(fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 14)),),
                                      style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8)),
                                          ),
                                          primary: AppTheme.darkText
                                      ),
                                    )
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
          );
        },
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.transparent,
        transitionDuration:
        const Duration(milliseconds: 150))
        .then((value){
            controller.removeListener(dialogState);
            refresh = null;
        });
  }

  Widget getMenuView(PortalDocenteController controller){
    return Container(
      margin: EdgeInsets.only(
        top: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 16),
        left: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 24),
        right: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 24),
        bottom: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 64)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Configuración",
            style: TextStyle(
                fontFamily: AppTheme.fontTTNorms,
                fontWeight: FontWeight.w700,
                fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 16),
                color: AppTheme.colorPrimary
            ),
          ),
          Padding(padding: EdgeInsets.all(6)),
          Container(
            color: AppTheme.darkerText,
            height: 2,
          ),
          Padding(padding: EdgeInsets.all(12)),

          Container(
            padding: EdgeInsets.only(
              left: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8),
              right: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 0)
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 30),
                      height: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 30),
                      child: Icon(Icons.home, size: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15), color: AppTheme.white,),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0XFF103347)),
                    ),
                    Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 4))),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.all(0),),
                            Text("Cambiar de colegio",
                              style: TextStyle(
                                  fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 14),
                                  color: Color(0XFF103347),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppTheme.fontTTNorms
                              ),),
                          ],
                        )
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 6))),
                Padding(
                  padding: EdgeInsets.only(left: 0, right: 0, top: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8)),
                  child: DropDownFormField2<GeoreferenciaUi>(
                    inputDecoration: InputDecoration(
                      labelText: "Colegio",
                      labelStyle: TextStyle(
                        fontFamily: AppTheme.fontTTNorms,
                        fontWeight: FontWeight.w800,
                        fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                      ),
                      helperText: " ",
                      contentPadding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8)),
                        borderSide: BorderSide(
                          color: AppTheme.colorPrimary.withOpacity(0.5),
                        ),
                      ),
                      suffixIcon: !controller.isLoading? IconButton(
                        onPressed: (){
                          //controller.clearTitulo();
                          //_tiuloRubricacontroller.clear();
                        },
                        icon: Icon(
                          Ionicons.caret_down,
                          color: AppTheme.colorPrimary,
                        ),
                        iconSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                      ):null,
                    ),
                    onChanged: !controller.isLoading?(item){
                      controller.onSelectGeoreferencia(item);
                    }:null,
                    menuItems: controller.georeferenciaUiList.map<DropdownMenuItem<GeoreferenciaUi>>((item) {
                      return DropdownMenuItem<GeoreferenciaUi>(child:
                      Row(
                        children: [
                          Expanded(child:  Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: Text("${item.nombre??""}",
                                style: TextStyle(
                                  fontFamily: AppTheme.fontTTNorms,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 14),
                                )
                            ),
                          )),
                          controller.isLoading?
                          Container(
                            height: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                            width: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                            margin: EdgeInsets.only(right: 0),
                            child:  Center(
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.colorPrimary,),
                            ),
                          ):Container()
                        ],
                      ), value: item,);
                    }).toList(),
                    value: controller.georeferenciaUi,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 30),
                      height: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 30),
                      child: Icon(Icons.today, size: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15), color: AppTheme.white,),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0XFF47102b)),
                    ),
                    Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 4))),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Cambiar de año académico",
                              style: TextStyle(
                                  fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 14),
                                  color: Color(0XFF47102b),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppTheme.fontTTNorms
                              ),),
                          ],
                        )
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 6))),
                Padding(
                  padding: EdgeInsets.only(left: 0, right: 0, top: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8)),
                  child: DropDownFormField2<AnioAcademicoUi>(
                    inputDecoration: InputDecoration(
                      labelText: "Año académico",
                      labelStyle: TextStyle(
                        fontFamily: AppTheme.fontTTNorms,
                        fontWeight: FontWeight.w800,
                        fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                      ),
                      helperText: " ",
                      contentPadding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8)),
                        borderSide: BorderSide(
                          color: AppTheme.colorPrimary.withOpacity(0.5),
                        ),
                      ),
                      suffixIcon: !controller.isLoading? IconButton(
                        onPressed: (){
                          //controller.clearTitulo();
                          //_tiuloRubricacontroller.clear();
                        },
                        icon: Icon(
                          Ionicons.caret_down,
                          color: AppTheme.colorPrimary,
                        ),
                        iconSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                      ):null,
                    ),
                    onChanged:  !controller.isLoading?(item){
                      controller.onSelectAnioAcademico(item);
                    }:null,
                    menuItems: controller.georeferenciaUi?.anioAcademicoUiList?.map<DropdownMenuItem<AnioAcademicoUi>>((item) {
                      return DropdownMenuItem<AnioAcademicoUi>(child:
                      Row(
                        children: [
                          Expanded(child: Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: Text("${item.nombre??""}",
                                style: TextStyle(
                                  fontFamily: AppTheme.fontTTNorms,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                                )
                            ),
                          )),
                          controller.isLoading?
                          Container(
                            height: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                            width: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                            margin: EdgeInsets.only(right: 0),
                            child:  Center(
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.colorPrimary,),
                            ),
                          ):Container()
                        ],
                      ), value: item,);
                    }).toList(),
                    value: controller.anioAcademicoUi,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 30),
                      height: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 30),
                      child: Icon(Icons.dns, size: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15), color: AppTheme.white,),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0XFF66173d)),
                    ),
                    Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 6))),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.all(0),),
                            Text("Cambiar de programa",
                              style: TextStyle(
                                  fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 14),
                                  color: Color(0XFF66173d),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppTheme.fontTTNorms
                              ),),
                          ],
                        )
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 6))),
                Padding(
                  padding: EdgeInsets.only(left: 0, right: 0, top: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8)),
                  child: DropDownFormField2<ProgramaEducativoUi>(
                    inputDecoration: InputDecoration(
                      labelText: "Programa",
                      labelStyle: TextStyle(
                        fontFamily: AppTheme.fontTTNorms,
                        fontWeight: FontWeight.w800,
                        fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                      ),
                      helperText: " ",
                      contentPadding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthListaCurso(context, 8)),
                        borderSide: BorderSide(
                          color: AppTheme.colorPrimary.withOpacity(0.5),
                        ),
                      ),
                      suffixIcon: !controller.isLoading? IconButton(
                        onPressed: (){
                          //controller.clearTitulo();
                          //_tiuloRubricacontroller.clear();
                        },
                        icon: Icon(
                          Ionicons.caret_down,
                          color: AppTheme.colorPrimary,
                        ),
                        iconSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                      ):null,
                    ),
                    onChanged:  !controller.isLoading?(item){
                      controller.onSelectPrograma(item);
                    }:null,
                    menuItems: controller.programaEducativoUiList.map<DropdownMenuItem<ProgramaEducativoUi>>((item) {
                      return DropdownMenuItem<ProgramaEducativoUi>(child:
                      Row(
                        children: [
                          Expanded(
                              child:  Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: Text("${item.nombrePrograma??""}",
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w500,
                                      fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 15),
                                    )
                                ),
                              )
                          ),  controller.isLoading?
                          Container(
                            height: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                            width: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                            margin: EdgeInsets.only(right: 0),
                            child:  Center(
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.colorPrimary,),
                            ),
                          ):Container()

                        ],
                      ), value: item,);
                    }).toList(),
                    value: controller.programaEducativoUi,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


}

typedef MenuBuilder = void Function(Widget menuView);