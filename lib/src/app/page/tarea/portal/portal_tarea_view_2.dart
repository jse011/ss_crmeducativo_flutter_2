import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/libs/flutter_smart_text_view/smart_text_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/portal/portal_tarea_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_unidad_tarea_repositoy.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_archivo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_ui.dart';
import 'dart:math';

import 'package:ss_crmeducativo_2/src/domain/entities/tarea_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart'; // for max function
import 'package:url_launcher/url_launcher.dart';

class PortalTareaView2 extends View{
  CursosUi? cursosUi;
  TareaUi? tareaUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;
  PortalTareaView2(this.cursosUi, this.tareaUi, this.calendarioPeriodoUI);

  @override
  _PortalTareaViewState createState() => _PortalTareaViewState(cursosUi, tareaUi, calendarioPeriodoUI);

}

class _PortalTareaViewState extends ViewState<PortalTareaView2, PortalTareaController> with TickerProviderStateMixin{

  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late bool isExpandedSlidingSheet = false;
  late AnimationController animationController;
  _PortalTareaViewState(cursosUi, tareaUi, calendarioPeriodoUI) : super(PortalTareaController(cursosUi, tareaUi, calendarioPeriodoUI, DeviceHttpDatosRepositorio(), MoorUnidadTareaRepository(), MoorConfiguracionRepository()));

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
    super.dispose();
  }

  @override
  Widget get view => ControlledWidgetBuilder<PortalTareaController>(
      builder: (context, controller) {
        return WillPopScope(
          onWillPop: () async {
            bool  se_a_modicado =  controller.onChangeTarea();
            if(se_a_modicado){
              Navigator.of(context).pop(1);//si devuelve un entero se actualiza toda la lista;
              return false;
            }else{
              return true;
            }
          },
          child: Scaffold(
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
                controller.showDialogEliminar?
                  ArsProgressWidget(
                      blur: 2,
                      backgroundColor: Color(0x33000000),
                      animationDuration: Duration(milliseconds: 500),
                      loadingWidget: Card(
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
                                    child: Icon(Ionicons.trash, size: 35, color: AppTheme.white,),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppTheme.colorAccent),
                                  ),
                                  Padding(padding: EdgeInsets.all(8)),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(padding: EdgeInsets.all(8),
                                            child: Text("Eliminar tarea", style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: AppTheme.fontTTNormsMedium
                                            ),),
                                          ),
                                          Padding(padding: EdgeInsets.all(4),),
                                          Text("¿Está seguro de eliminar la tarea?\nRecuerde que si elimina se borrará la tarea permanentemente.",
                                            style: TextStyle(
                                                fontSize: 14,
                                                height: 1.5
                                            ),),
                                          Padding(padding: EdgeInsets.all(4),),
                                        ],
                                      )
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          controller.onClickCancelarEliminar();
                                        },
                                        child: Text('Cancelar'),
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      )
                                  ),
                                  Padding(padding: EdgeInsets.all(8)),
                                  Expanded(child: ElevatedButton(
                                    onPressed: () async {
                                      await controller.onClickAceptarEliminar();
                                      Navigator.of(context).pop(1);//si devuelve un entero se actualiza toda la lista
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      onPrimary: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Padding(padding: EdgeInsets.all(4), child: Text('Eliminar'),),
                                  )),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                  ):Container(),
              ],
            ),
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
                    color: isExpandedSlidingSheet? AppTheme.white : AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey
                              .withOpacity(0.4 * topBarOpacity * (isExpandedSlidingSheet?0:1)),
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
                            top: 16 - 8.0 * topBarOpacity * (isExpandedSlidingSheet?0:1),
                            bottom: 12 - 8.0 * topBarOpacity * (isExpandedSlidingSheet?0:1)),
                        child: ControlledWidgetBuilder<PortalTareaController>(
                          builder: (context, controller) {
                            return Stack(
                              children: <Widget>[
                                Positioned(
                                    child:  IconButton(
                                      icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity * (isExpandedSlidingSheet?0:1),),
                                      onPressed: () {
                                        bool  se_a_modicado =  controller.onChangeTarea();
                                        if(se_a_modicado){

                                          animationController.reverse().then<dynamic>((data) {
                                            if (!mounted) {
                                              return;
                                            }
                                            Navigator.of(context).pop(1);//si devuelve un entero se actualiza toda la lista;
                                          });
                                        }else{
                                          animationController.reverse().then<dynamic>((data) {
                                            if (!mounted) {
                                              return;
                                            }
                                            Navigator.of(context).pop(true);
                                          });
                                        }



                                        return;

                                      },
                                    )
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 52),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(AppIcon.ic_curso_tarea, height: 32 +  6 - 10 * topBarOpacity * (isExpandedSlidingSheet?0:1), width: 35 +  6 - 10 * topBarOpacity * (isExpandedSlidingSheet?0:1),),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8, top: 8),
                                        child: Text(
                                          'Tarea ${controller.tareaUi?.position??""}',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14 + 6 - 6 * topBarOpacity * (isExpandedSlidingSheet?0:1),
                                            letterSpacing: 0.8,
                                            color: AppTheme.darkerText,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  bottom: 0,
                                  right: 16,
                                  child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async{
                                          await controller.onClicPublicar();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,8)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,10))),
                                            color:  controller.tareaUi?.publicado??false?  HexColor(controller.cursosUi?.color2) : AppTheme.white,
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(controller.tareaUi?.publicado??false ?"Publicado":"Sin publicar",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      letterSpacing: 0.6,
                                                      color: controller.tareaUi?.publicado??false?AppTheme.white:AppTheme.greyDarken1,
                                                      fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context, 5 + 6 - 1 * topBarOpacity ),
                                                    )),
                                              ),
                                              Padding(padding: EdgeInsets.all(2),),
                                              Icon(
                                                Ionicons.earth,
                                                color: controller.tareaUi?.publicado??false?AppTheme.white :AppTheme.greyDarken1,
                                                size: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context, 9 + 6 - 2 * topBarOpacity), ),
                                            ],
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
            child: ControlledWidgetBuilder<PortalTareaController>(
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
                      length: 2,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                left: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,24),
                              right: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,24)
                            ),
                            constraints: BoxConstraints.expand(height: 50),
                            child: TabBar(
                                indicatorColor: HexColor(controller.cursosUi?.color1),
                                labelColor: HexColor(controller.cursosUi?.color1),
                                unselectedLabelColor: Colors.grey,
                                isScrollable: false,
                                tabs: [
                                  Tab(text: "Instruciones"),
                                  Tab(text: "Trabajo del alumno"),
                                ]),
                          ),
                          Expanded(
                            child: Container(
                              child: TabBarView(children: [
                                CustomScrollView(
                                  //controller: scrollController,
                                  slivers: [
                                    SliverPadding(
                                        padding: EdgeInsets.only(
                                            left: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,24),
                                            right: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,24)),
                                        sliver: SliverList(
                                            delegate: SliverChildListDelegate([
                                              Container(
                                                margin: EdgeInsets.only(top: 24),
                                                child:  Wrap(
                                                  spacing: 10.0,
                                                  runSpacing: 15.0,
                                                  direction: Axis.horizontal,
                                                  alignment: WrapAlignment.start,
                                                  children: <Widget>[
                                                    InkWell(
                                                      onTap: () async{
                                                        await controller.onClicPublicar();
                                                      },
                                                      child: Container(
                                                        width: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,120),
                                                        padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,8)),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,6))),
                                                            color: controller.tareaUi?.publicado??false?HexColor(controller.cursosUi?.color2) : AppTheme.white
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Icon(Ionicons.earth ,
                                                                color: controller.tareaUi?.publicado??false?AppTheme.white:AppTheme.greyDarken1,
                                                                size: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context, 9 + 6 - 2 * topBarOpacity)
                                                            ),
                                                            Padding(padding: EdgeInsets.all(2),),
                                                            FittedBox(
                                                              fit: BoxFit.scaleDown,
                                                              child: Text("Publicar Tarea",
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5,
                                                                    color: controller.tareaUi?.publicado??false?AppTheme.white: AppTheme.greyDarken1,
                                                                    fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context, 5 + 6 - 1 * topBarOpacity) ,
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    InkWell(
                                                      onTap: () async{
                                                        dynamic? result = await AppRouter.createRouteTareaCrearRouter(context,  controller.cursosUi, controller.tareaUi, controller.calendarioPeriodoUI, null, null);
                                                        if(result is int) controller.cambiosTarea();

                                                      },
                                                      child: Container(
                                                        width: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,110),
                                                        padding: EdgeInsets.only(
                                                            left: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,16) ,
                                                            right: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,16),
                                                            top: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,8),
                                                            bottom: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,8)),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,6))),
                                                            color: HexColor(controller.cursosUi?.color2)
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Icon(Ionicons.pencil ,
                                                              color: AppTheme.white,
                                                              size: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,9 + 6 - 2 * topBarOpacity * (isExpandedSlidingSheet?0:1))
                                                              , ),
                                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context, 2)),),
                                                            FittedBox(
                                                              fit: BoxFit.scaleDown,
                                                              child: Text("Modificar",
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5,
                                                                    color:AppTheme.white,
                                                                    fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context, 5 + 6 - 1 * topBarOpacity * (isExpandedSlidingSheet?0:1)),
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    InkWell(
                                                      onTap: () {
                                                        controller.onClicEliminar();
                                                      },
                                                      child: Container(
                                                        width: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,110),
                                                        padding: EdgeInsets.only(
                                                            left: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,16) ,
                                                            right: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,16),
                                                            top: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,8),
                                                            bottom: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,8)
                                                        ),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,6))),
                                                            color: HexColor(controller.cursosUi?.color2)
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Icon(Ionicons.trash ,color: AppTheme.white,
                                                              size: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,9 + 6 - 2 * topBarOpacity * (isExpandedSlidingSheet?0:1)),
                                                            ),
                                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,2)),),
                                                            FittedBox(
                                                              fit: BoxFit.scaleDown,
                                                              child: Text("Eliminar",
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5,
                                                                    color:AppTheme.white,
                                                                    fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,5 + 6 - 1 * topBarOpacity * (isExpandedSlidingSheet?0:1)),
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 24),
                                                child: Text("Fecha de entrega: ${(controller.tareaUi?.fechaEntrega??"sin fecha de entrega").replaceAll("\n", "")}", style: TextStyle(fontSize: 12),),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 8),
                                                child: Text("${controller.tareaUi?.titulo}", style: TextStyle(color: HexColor(controller.cursosUi?.color1) , fontSize: 18),),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 16),
                                                height: 1,
                                                color: HexColor(controller.cursosUi?.color1),
                                              ),
                                              (controller.tareaUi?.instrucciones??"").isNotEmpty?
                                              Container(
                                                margin: EdgeInsets.only(top: 24),
                                                child: Text("${controller.tareaUi?.instrucciones}",
                                                  style: TextStyle(fontSize: 14, height: 1.5),),
                                              ):Container(),
                                              controller.tareaRecursoUiList.isNotEmpty?
                                              Container(
                                                margin: EdgeInsets.only(top: 16),
                                                child: Text("Recursos",
                                                  style: TextStyle(fontSize: 14, color: AppTheme.black, fontWeight: FontWeight.w500),),
                                              ):Container(),
                                              ListView.builder(
                                                  padding: EdgeInsets.only(top: 8.0, bottom: 0),
                                                  itemCount: controller.tareaRecursoUiList.length,
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index){
                                                    TareaRecusoUi tareaRecursoUi = controller.tareaRecursoUiList[index];

                                                    return Stack(
                                                      children: [
                                                        Center(
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(8), // use instead of BorderRadius.all(Radius.circular(20))
                                                                border:  Border.all(
                                                                    width: 1,
                                                                    color: HexColor(controller.cursosUi?.color1)
                                                                ),
                                                                color: AppTheme.white
                                                            ),
                                                            margin: EdgeInsets.only(bottom: 8),
                                                            width: 450,
                                                            height: 50,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets.only(right: 16),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.only(
                                                                      bottomLeft: Radius.circular(8),
                                                                      topLeft: Radius.circular(8),
                                                                    ), // use instead of BorderRadius.all(Radius.circular(20))
                                                                    color: AppTheme.greyLighten2,
                                                                  ),
                                                                  width: 50,
                                                                  child: Center(
                                                                    child: Image.asset(getImagen(tareaRecursoUi.tipoRecurso),
                                                                      height: 30.0,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Text("${tareaRecursoUi.titulo??""}", style: TextStyle(color: AppTheme.greyDarken3, fontSize: 12),),
                                                                      Padding(padding: EdgeInsets.all(2)),
                                                                      tareaRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO_YOUTUBE || tareaRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO_DRIVE || tareaRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO?
                                                                      Text("${(tareaRecursoUi.url??"").isNotEmpty?tareaRecursoUi.url: tareaRecursoUi.descripcion}", maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(color: AppTheme.blue, fontSize: 10)):
                                                                      Text("${(tareaRecursoUi.descripcion??"").isNotEmpty?tareaRecursoUi.descripcion: getDescripcion(tareaRecursoUi.tipoRecurso)}", maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(color: AppTheme.grey, fontSize: 10)),
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                              ),
                                              controller.tareaRecursoUiList.isNotEmpty?
                                              Container(
                                                margin: EdgeInsets.only(top: 32),
                                                height: 1,
                                                color: AppTheme.greyLighten1,
                                              ):Container(),
                                              Container(
                                                margin: EdgeInsets.only(top: 16),
                                                child: Text("Comentario de clase",
                                                  style: TextStyle(fontSize: 14, color: AppTheme.black, fontWeight: FontWeight.w500),),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top:  4),
                                                child: Row(
                                                  children: [
                                                    CachedNetworkImage(
                                                      placeholder: (context, url) => Container(
                                                        child: CircularProgressIndicator(),
                                                      ),
                                                      imageUrl: "https://cdn.domestika.org/c_fill,dpr_1.0,f_auto,h_1200,pg_1,t_base_params,w_1200/v1589759117/project-covers/000/721/921/721921-original.png?1589759117",
                                                      errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                                      imageBuilder: (context, imageProvider) =>
                                                          Container(
                                                              width: 40,
                                                              height: 40,
                                                              margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                image: DecorationImage(
                                                                  image: imageProvider,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              )
                                                          ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              height: 65,
                                                              child: Row(
                                                                children: <Widget>[
                                                                  Expanded(
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppTheme.greyLighten3,
                                                                        borderRadius: BorderRadius.circular(8.0),
                                                                        border: Border.all(color: AppTheme.greyLighten2),
                                                                      ),
                                                                      padding: EdgeInsets.all(8),
                                                                      child: Row(
                                                                        children: <Widget>[
                                                                          Expanded(
                                                                            child: TextField(
                                                                              maxLines: null,
                                                                              keyboardType: TextInputType.multiline,
                                                                              style: TextStyle(
                                                                                fontSize: 12,

                                                                              ),
                                                                              decoration: InputDecoration(
                                                                                  isDense: true,
                                                                                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                                                                                  hintText: "",
                                                                                  border: InputBorder.none),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          IconButton(
                                                            onPressed: () {
                                                              // You enter here what you want the button to do once the user interacts with it
                                                            },
                                                            icon: Icon(
                                                              Icons.send,
                                                              color: AppTheme.greyDarken1,
                                                            ),
                                                            iconSize: 20.0,
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top:  4, bottom: 16),
                                                child: Row(
                                                  children: [
                                                    CachedNetworkImage(
                                                      placeholder: (context, url) => Container(
                                                        child: CircularProgressIndicator(),
                                                      ),
                                                      imageUrl: "https://cdn.domestika.org/c_fill,dpr_1.0,f_auto,h_1200,pg_1,t_base_params,w_1200/v1589759117/project-covers/000/721/921/721921-original.png?1589759117",
                                                      errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                                      imageBuilder: (context, imageProvider) =>
                                                          Container(
                                                              width: 40,
                                                              height: 40,
                                                              margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                image: DecorationImage(
                                                                  image: imageProvider,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              )
                                                          ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: AppTheme.greyLighten3,
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          border: Border.all(color: AppTheme.greyLighten2),
                                                        ),
                                                        padding: EdgeInsets.all(8),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                    child: Container(
                                                                        padding: EdgeInsets.only(right: 8),
                                                                        child: Text("Velasquez Vilma Gregoria",
                                                                            style: TextStyle(
                                                                                fontSize: 10,
                                                                                fontWeight: FontWeight.w700
                                                                            ))
                                                                    )
                                                                ),
                                                                Text("Vie 03 de set. - 13:37",
                                                                    style: TextStyle(
                                                                        fontSize: 10,
                                                                        color: AppTheme.greyDarken1
                                                                    )
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(padding: EdgeInsets.all(2)),
                                                            Container(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text("Miss mil disculpas no cargo el video por eso lo enviamos al whassap", style: TextStyle(fontSize: 10),),
                                                            ),
                                                            Padding(padding: EdgeInsets.all(2)),
                                                            Container(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text("Responder",
                                                                  style: TextStyle(
                                                                      fontSize: 10,
                                                                      color: AppTheme.greyDarken1
                                                                  )
                                                              ),
                                                            )

                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(padding: EdgeInsets.only(bottom: 200))
                                            ])
                                        ),
                                    ),
                                  ],
                                ),
                                CustomScrollView(
                                  //shrinkWrap: true,
                                  //physics: NeverScrollableScrollPhysics(),
                                  slivers: [
                                    SliverPadding(
                                      padding: EdgeInsets.only(
                                          left: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,24),
                                          right: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,24)),
                                      sliver: SliverList(
                                          delegate: SliverChildListDelegate([
                                            Container(
                                              margin: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,24)),
                                              child:  Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    //onTap: ()=> controller.onClicPrecision(),
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,16) ,
                                                          right: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,16),
                                                          top: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,8),
                                                          bottom: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,8)),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,6))),
                                                          color: HexColor(controller.cursosUi?.color2)
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Icon(Icons.add ,color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,15), ),
                                                          Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,2)),),
                                                          FittedBox(
                                                            fit: BoxFit.scaleDown,
                                                            child: Text("Crear rúbrica",
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  letterSpacing: 0.5,
                                                                  color:AppTheme.white,
                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,11),
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(padding: EdgeInsets.only(
                                                      left: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,16)
                                                  )),
                                                    InkWell(
                                                      //onTap: ()=> controller.onClicPrecision(),
                                                      child: Container(
                                                        padding: EdgeInsets.only(
                                                            left: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,16) ,
                                                            right: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,16),
                                                            top: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,8),
                                                            bottom: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,8)),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,6))),
                                                            color: HexColor(controller.cursosUi?.color2)
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Icon(Icons.apps_sharp ,color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,15), ),
                                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,2)),),
                                                            FittedBox(
                                                              fit: BoxFit.scaleDown,
                                                              child: Text("Abrir rúbrica",
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w500,
                                                                    letterSpacing: 0.5,
                                                                    color:AppTheme.white,
                                                                    fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,11),
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  Padding(padding: EdgeInsets.only(
                                                      left: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,16)
                                                  )),
                                                  true?
                                                  InkWell(
                                                    //onTap: ()=> controller.onClicPrecision(),
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          left: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,16) ,
                                                          right: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,16),
                                                          top: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,8),
                                                          bottom: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,8)
                                                      ),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,6))),
                                                          color: HexColor(controller.cursosUi?.color2)
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Icon(Ionicons.trash ,color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,14)),
                                                          Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,2)),),
                                                          FittedBox(
                                                            fit: BoxFit.scaleDown,
                                                            child: Text("Eliminar rúbrica",
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.w500,
                                                                  letterSpacing: 0.5,
                                                                  color:AppTheme.white,
                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,11),
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ):Container(),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,32)),
                                              child:  Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                      child: Container(
                                                        child: Column(
                                                          children: [
                                                            Text("20", style: TextStyle(color: HexColor(controller.cursosUi?.color1), fontSize: 20, fontWeight: FontWeight.w500),),
                                                            Text("Evaluados", style: TextStyle(color: AppTheme.greyDarken1, fontSize: 10))
                                                          ],
                                                        ),
                                                      )
                                                  ),
                                                  Container(
                                                    color: AppTheme.greyLighten1,
                                                    height: 40,
                                                    width: 1,
                                                  ),
                                                  Expanded(
                                                      child: Container(
                                                        child: Column(
                                                          children: [
                                                            Text("0", style: TextStyle(color: HexColor(controller.cursosUi?.color1), fontSize: 20, fontWeight: FontWeight.w500),),
                                                            Text("Sin evaluar", style: TextStyle(color: AppTheme.greyDarken1, fontSize: 10))
                                                          ],
                                                        ),
                                                      )
                                                  ),
                                                  InkWell(
                                                    onTap: ()=> controller.onClickMostrarTodo(),
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 4 , right: 4, top: 4, bottom: 4),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                                          color: HexColor(controller.cursosUi?.color2)
                                                      ),
                                                      alignment: Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Icon(controller.toogleGeneral?Ionicons.contract: Ionicons.expand,color: AppTheme.white, size: 16),
                                                        ],
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
                                      padding: EdgeInsets.only(
                                          left: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,24), 
                                          right: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,24)),
                                      sliver: SliverToBoxAdapter(
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthButtonPortalTarea(context,32)),
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index){
                                            TareaAlumnoUi tareaAlumnoUi = controller.tareaAlumnoUiList[index];
                                            return Column(
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    controller.onClickTareaAlumno(tareaAlumnoUi);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(4),
                                                    color: HexColor(controller.cursosUi?.color2).withOpacity(0.1),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          color: HexColor(controller.cursosUi?.color2).withOpacity(0.1),
                                                          child: Icon(Icons.keyboard_arrow_up, size: 20,color: HexColor(controller.cursosUi?.color1)),
                                                        ),
                                                        Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets.only(left: 4),
                                                              child: Text("${(tareaAlumnoUi.personaUi?.nombreCompleto??"").toUpperCase()}", style: TextStyle(color: HexColor(controller.cursosUi?.color1), fontSize: 10, fontWeight: FontWeight.w500),),
                                                            )
                                                        ),
                                                        (tareaAlumnoUi.entregado??false)?
                                                        Container(
                                                          padding: EdgeInsets.only(left: 4 , right: 4, top: 4, bottom: 4),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(2)),
                                                              color: HexColor(controller.cursosUi?.color2)
                                                          ),
                                                          alignment: Alignment.center,
                                                          child: Text((tareaAlumnoUi.entregado_retraso??false) ? "Entregado\ncon retrazo": "Entregado",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                color:AppTheme.white,
                                                                fontSize: 10,
                                                              )),
                                                        ):Container(),
                                                        Padding(padding: EdgeInsets.all(4)),
                                                        ((tareaAlumnoUi.valorTipoNotaId??"").isNotEmpty)?
                                                        Container(
                                                          padding: EdgeInsets.only(left: 4 , right: 4, top: 4, bottom: 4),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(2)),
                                                              color: HexColor(controller.cursosUi?.color2)
                                                          ),
                                                          alignment: Alignment.center,
                                                          child: Text("Evaluado",
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w500,
                                                                color:AppTheme.white,
                                                                fontSize: 10,
                                                              )),
                                                        ):Container()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                (tareaAlumnoUi.toogle??false)?
                                                Column(
                                                  children: [
                                                    Container(

                                                      height: 1,
                                                      color: HexColor(controller.cursosUi?.color1),
                                                    ),
                                                    true?
                                                    Container(
                                                      margin: EdgeInsets.only(top:  16,),
                                                      color: AppTheme.brownDarken4,
                                                      height: 100,
                                                      width: 200,
                                                    ): Container(),
                                                    Container(
                                                      margin: EdgeInsets.only(top: 8),
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          padding: EdgeInsets.only(top: 0),
                                                          physics: NeverScrollableScrollPhysics(),
                                                          itemCount: tareaAlumnoUi.archivos?.length??0,
                                                          itemBuilder: (context, index){
                                                            TareaAlumnoArchivoUi tareaAlumnoArchivoUi = tareaAlumnoUi.archivos![index];
                                                            return  Stack(
                                                              children: [
                                                                Center(
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(4), // use instead of BorderRadius.all(Radius.circular(20))
                                                                        border:  Border.all(
                                                                            width: 1,
                                                                            color: AppTheme.greyLighten2
                                                                        ),
                                                                        color: AppTheme.white
                                                                    ),
                                                                    margin: EdgeInsets.only(top: 8),
                                                                    width: 450,
                                                                    height: 50,
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          margin: EdgeInsets.only(right: 16),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.only(
                                                                                bottomLeft: Radius.circular(4),
                                                                                topLeft: Radius.circular(4),
                                                                              ), // use instead of BorderRadius.all(Radius.circular(20))
                                                                              color: AppTheme.greyLighten3
                                                                          ),
                                                                          width: 50,
                                                                          child: Center(
                                                                            child: Image.asset(
                                                                              getImagen(tareaAlumnoArchivoUi.tipoRecurso),
                                                                              height: 30.0,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text("${tareaAlumnoArchivoUi.nombre??""}", style: TextStyle(color: AppTheme.greyDarken3, fontSize: 12),),
                                                                              Padding(padding: EdgeInsets.all(2)),
                                                                              (tareaAlumnoArchivoUi.repositorio??false)?
                                                                              Text("${getDescripcion(tareaAlumnoArchivoUi.tipoRecurso)}", maxLines: 1, overflow: TextOverflow.ellipsis ,style: TextStyle(color: AppTheme.grey, fontSize: 10)):
                                                                              Text("${tareaAlumnoArchivoUi.url??""}", maxLines: 1, overflow: TextOverflow.ellipsis ,style: TextStyle(color: AppTheme.blue, fontSize: 10))
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(top:  16),
                                                      alignment: Alignment.centerLeft,
                                                      child: Text("Comentarios privados (Sólo los ve le alumno)", style: TextStyle(color: AppTheme.colorPrimary, fontSize: 10),),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(top:  4),
                                                      child: Row(
                                                        children: [
                                                          CachedNetworkImage(
                                                            placeholder: (context, url) => Container(
                                                              child: CircularProgressIndicator(),
                                                            ),
                                                            imageUrl: "https://cdn.domestika.org/c_fill,dpr_1.0,f_auto,h_1200,pg_1,t_base_params,w_1200/v1589759117/project-covers/000/721/921/721921-original.png?1589759117",
                                                            errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                                            imageBuilder: (context, imageProvider) =>
                                                                Container(
                                                                    width: 40,
                                                                    height: 40,
                                                                    margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                      image: DecorationImage(
                                                                        image: imageProvider,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    )
                                                                ),
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Container(
                                                                    height: 65,
                                                                    child: Row(
                                                                      children: <Widget>[
                                                                        Expanded(
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              color: AppTheme.greyLighten3,
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                              border: Border.all(color: AppTheme.greyLighten2),
                                                                            ),
                                                                            padding: EdgeInsets.all(8),
                                                                            child: Row(
                                                                              children: <Widget>[
                                                                                Expanded(
                                                                                  child: TextField(
                                                                                    maxLines: null,
                                                                                    keyboardType: TextInputType.multiline,
                                                                                    style: TextStyle(
                                                                                      fontSize: 12,

                                                                                    ),
                                                                                    decoration: InputDecoration(
                                                                                        isDense: true,
                                                                                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                                                                                        hintText: "",
                                                                                        border: InputBorder.none),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),

                                                                IconButton(
                                                                  onPressed: () {
                                                                    // You enter here what you want the button to do once the user interacts with it
                                                                  },
                                                                  icon: Icon(
                                                                    Icons.send,
                                                                    color: AppTheme.greyDarken1,
                                                                  ),
                                                                  iconSize: 20.0,
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(top:  4, bottom: 16),
                                                      child: Row(
                                                        children: [
                                                          CachedNetworkImage(
                                                            placeholder: (context, url) => Container(
                                                              child: CircularProgressIndicator(),
                                                            ),
                                                            imageUrl: "https://cdn.domestika.org/c_fill,dpr_1.0,f_auto,h_1200,pg_1,t_base_params,w_1200/v1589759117/project-covers/000/721/921/721921-original.png?1589759117",
                                                            errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                                            imageBuilder: (context, imageProvider) =>
                                                                Container(
                                                                    width: 40,
                                                                    height: 40,
                                                                    margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                      image: DecorationImage(
                                                                        image: imageProvider,
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    )
                                                                ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: AppTheme.greyLighten3,
                                                                borderRadius: BorderRadius.circular(8.0),
                                                                border: Border.all(color: AppTheme.greyLighten2),
                                                              ),
                                                              padding: EdgeInsets.all(8),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child: Container(
                                                                              padding: EdgeInsets.only(right: 8),
                                                                              child: Text("Velasquez Vilma Gregoria",
                                                                                  style: TextStyle(
                                                                                      fontSize: 10,
                                                                                      fontWeight: FontWeight.w700
                                                                                  ))
                                                                          )
                                                                      ),
                                                                      Text("Vie 03 de set. - 13:37",
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              color: AppTheme.greyDarken1
                                                                          )
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(padding: EdgeInsets.all(2)),
                                                                  Container(
                                                                    alignment: Alignment.centerLeft,
                                                                    child: Text("Miss mil disculpas no cargo el video por eso lo enviamos al whassap", style: TextStyle(fontSize: 10),),
                                                                  ),
                                                                  Padding(padding: EdgeInsets.all(2)),
                                                                  Container(
                                                                    alignment: Alignment.centerLeft,
                                                                    child: Text("Responder",
                                                                        style: TextStyle(
                                                                            fontSize: 10,
                                                                            color: AppTheme.greyDarken1
                                                                        )
                                                                    ),
                                                                  )

                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ):Container(padding: EdgeInsets.only(bottom: 8),)
                                              ],
                                            );
                                          },
                                          itemCount: controller.tareaAlumnoUiList.length,
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        );
      },
    );
  }

  String getImagen(TipoRecursosUi? tipoRecursosUi){
    switch(tipoRecursosUi??TipoRecursosUi.TIPO_VINCULO){
      case TipoRecursosUi.TIPO_VIDEO:
        return AppImagen.archivo_video;
      case TipoRecursosUi.TIPO_VINCULO:
        return AppImagen.archivo_link;
      case TipoRecursosUi.TIPO_DOCUMENTO:
        return AppImagen.archivo_documento;
      case TipoRecursosUi.TIPO_IMAGEN:
        return AppImagen.archivo_imagen;
      case TipoRecursosUi.TIPO_AUDIO:
        return AppImagen.archivo_audio;
      case TipoRecursosUi.TIPO_HOJA_CALCULO:
        return AppImagen.archivo_hoja_calculo;
      case TipoRecursosUi.TIPO_DIAPOSITIVA:
        return AppImagen.archivo_diapositiva;
      case TipoRecursosUi.TIPO_PDF:
        return AppImagen.archivo_pdf;
      case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
        return AppImagen.archivo_youtube;
      case TipoRecursosUi.TIPO_VINCULO_DRIVE:
        return AppImagen.archivo_drive;
      case TipoRecursosUi.TIPO_RECURSO:
        return AppImagen.archivo_recurso;
    }
  }

  String getDescripcion(TipoRecursosUi? tipoRecursosUi){
    switch(tipoRecursosUi??TipoRecursosUi.TIPO_VINCULO){
      case TipoRecursosUi.TIPO_VIDEO:
        return "Video";
      case TipoRecursosUi.TIPO_VINCULO:
        return "Link";
      case TipoRecursosUi.TIPO_DOCUMENTO:
        return "Documento";
      case TipoRecursosUi.TIPO_IMAGEN:
        return "Imagen";
      case TipoRecursosUi.TIPO_AUDIO:
        return "Audio";
      case TipoRecursosUi.TIPO_HOJA_CALCULO:
        return "Hoja cálculo";
      case TipoRecursosUi.TIPO_DIAPOSITIVA:
        return "Presentación";
      case TipoRecursosUi.TIPO_PDF:
        return "Documento Portátil";
      case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
        return "Youtube";
      case TipoRecursosUi.TIPO_VINCULO_DRIVE:
        return "Drive";
      case TipoRecursosUi.TIPO_RECURSO:
        return "Recurso";
    }
  }

}