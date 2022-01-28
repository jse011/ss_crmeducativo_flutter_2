import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fancy_shimer_image/fancy_shimmer_image.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/close_sesion.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_linkify.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_system_ui.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_url_launcher.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/animation_view.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/item_evento_view.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_adjunto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_drive_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/provider/homeProvider.dart';
import 'evento_agenda_controller_2.dart';
import 'package:provider/provider.dart';

class EventoAgendaView extends View{
  UsuarioUi? usuarioUi;
  final AnimationController animationController;
  final MenuBuilder? menuBuilder;
  final CloseSession closeSessionHandler;

  EventoAgendaView(this.usuarioUi, {required this.animationController, this.menuBuilder, required this.closeSessionHandler});

  @override
  _EventoAgendaViewState createState() => _EventoAgendaViewState(this.usuarioUi);

}

class _EventoAgendaViewState extends ViewState<EventoAgendaView, EventoAgendaController2> with TickerProviderStateMixin{

  _EventoAgendaViewState(UsuarioUi? usuarioUi) :
        super(EventoAgendaController2(usuarioUi,
          DeviceHttpDatosRepositorio(), MoorConfiguracionRepository(), MoorAgendaEventoRepository()));

  late Animation<double> topBarAnimation;
  late ScrollController scrollController;
  double topBarOpacity = 0.0;

  @override
  void initState() {
    scrollController = ScrollController();

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

    Future.delayed(const Duration(milliseconds: 100), () {
// Here you can write your code
      setState(() {
        widget.animationController.forward();
      });

    });
    super.initState();
  }

  @override
  Widget get view =>  ControlledWidgetBuilder<EventoAgendaController2>(
      builder: (context, controller){
        SchedulerBinding.instance?.addPostFrameCallback((_) {
          widget.menuBuilder?.call(getMenuView(controller));
        });
        return WillPopScope(
          onWillPop: () async {
            bool salir = controller.onBackPress();
            if(salir){
              return await widget.closeSessionHandler.closeSession()??false;
            }
            return salir;
          },
          child:  AnnotatedRegion<SystemUiOverlayStyle>(
            value: AppSystemUi.getSystemUiOverlayStyleOscuro(),
            child: Stack(
              children: <Widget>[
                getMainTab(),
                getAppBarUI(),
                (controller.msgConexion??"").isNotEmpty?
                Positioned(
                  bottom: 100.0,
                  right: 1,
                  left: 1,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          //color:
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: AppTheme.black.withOpacity(0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                            child: Text(controller.msgConexion??"", style: TextStyle(color: AppTheme.white),),
                          ),
                        )
                      ],
                    ),
                  ),
                ):Container(),
                controller.isLoading?
                controller.eventoUiList!=null? ArsProgressWidget(
                    blur: 2,
                    backgroundColor: Color(0x33000000),
                    animationDuration: Duration(milliseconds: 500)):
                Center(
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.colorPrimary,),
                ):Container(),
                if(controller.showDialogEliminar)
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
                                            child: Text("Eliminar evento", style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: AppTheme.fontTTNormsMedium
                                            ),),
                                          ),
                                          Padding(padding: EdgeInsets.all(4),),
                                          Text("¿Está seguro de eliminar el evento? Recuerde que si elimina se borrará permanentemente el evento.",
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
                                      bool? result = await controller.onClickAceptarEliminar();
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
                  ),
                controller.dialogAdjuntoDownload?
                dialogAdjuntoDownload(controller):
                Container(),
              ],
            ),
          ),
        );
      });

  Widget chip(TipoEventoUi tipo, Function onClick) {
    Color color;
    String imagepath;
    switch(tipo.tipo??EventoIconoEnumUI.DEFAULT){
      case EventoIconoEnumUI.DEFAULT:
        color = HexColor("#00BCD4");
        imagepath = AppIcon.ic_tipo_evento_cita;
        break;
      case EventoIconoEnumUI.EVENTO:
        color = HexColor("#bfca52");
        imagepath = AppIcon.ic_tipo_evento_evento;
        break;
      case EventoIconoEnumUI.NOTICIA:
        color = HexColor("#ffc107");
        imagepath = AppIcon.ic_tipo_evento_noticia;
        break;
      case EventoIconoEnumUI.ACTIVIDAD:
        color = HexColor("#ff6b9d");
        imagepath = AppIcon.ic_tipo_evento_actividad;
        break;
      case EventoIconoEnumUI.TAREA:
        color = HexColor("#ff9800");
        imagepath =  AppIcon.ic_tipo_evento_tarea;
        break;
      case EventoIconoEnumUI.CITA:
        color = HexColor("#00bcd4");
        imagepath = AppIcon.ic_tipo_evento_cita;
        break;
      case EventoIconoEnumUI.AGENDA:
        color = HexColor("#71bb74");
        imagepath = AppIcon.ic_tipo_evento_agenda;
        break;
      case EventoIconoEnumUI.TODOS:
        color = HexColor("#0091EA");
        imagepath = AppIcon.ic_tipo_evento_todos;
        break;
    }

    return Container(
      //margin: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
      height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,65),
      width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 78),
      decoration: BoxDecoration(
        color: color.withOpacity(tipo.toogle??false?1:1),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,8.0)),
            bottomLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,8.0)),
            bottomRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,8.0)),
            topRight:Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,8.0))),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: color.withOpacity(tipo.toogle??false?1:0.3),
              offset: Offset(0, tipo.toogle??false?3:1),
              blurRadius: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,10.0)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          splashColor: AppTheme.nearlyDarkBlue.withOpacity(0.2),
          onTap: () {
            onClick(tipo);
          },
          child: Column(
            //alignment: AlignmentDirectional.center,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,8)),
                    child: SvgPicture.asset(
                      imagepath,
                      semanticsLabel:"Eventos",
                      color: AppTheme.white,
                      width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,20.0),
                      height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,20.0),
                    ),
                  )
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,8),
                    left: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,4.0),
                    right: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,4.0)),
                child: Text(tipo.nombre??"",
                    textAlign: TextAlign.center ,
                    style: TextStyle(
                        color: AppTheme.white,
                        fontFamily: AppTheme.fontTTNorms,
                        fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context,12.0),
                        fontWeight: FontWeight.w900)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget chipEspacio() {
    return Container(
      //margin: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
      height: 65,
      width: 80,
      color: Colors.transparent,
    );
  }

  Widget getAppBarUI2() {
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
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context!).padding.top,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 0,
                          right: 0,
                          top: 16 + 4.0 * topBarOpacity,
                          bottom: 12 - 8.0 * topBarOpacity),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Center(
                              child: Text(
                                'Agenda digital',
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontTTNorms,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16 + 10 - 4 * topBarOpacity,
                                  letterSpacing: 1.2,
                                  color: AppTheme.darkerText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }

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
                        child: Container(
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 24, right: 24,top: 8 * topBarOpacity, bottom: 8),
                                  child: Text(
                                    'Agenda digital',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16 + 10 - 4 * topBarOpacity,
                                      letterSpacing: 1.2,
                                      color: AppTheme.darkerText,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
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
      animation: widget.animationController,
      builder: (BuildContext? context, Widget? child) {
        return FadeTransition(
          opacity: topBarAnimation,
          child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
              child: Container(
                color: AppTheme.background,
                child:
                /*NestedScrollView(
                    controller: scrollController,
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          toolbarHeight: 65 - 5 * topBarOpacity,
                          expandedHeight: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 225.0) + MediaQuery.of(context).padding.top,
                          backgroundColor: AppTheme.white,
                          //brightness: Brightness.light,
                          systemOverlayStyle: AppSystemUi.getSystemUiOverlayStyleOscuro(),
                          shadowColor: AppTheme.grey
                              .withOpacity(0.4),
                          automaticallyImplyLeading: false,
                          floating: false,
                          pinned: true,
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(80), bottomRight: Radius.circular(0))),
                          flexibleSpace: FlexibleSpaceBar(
                            background: ControlledWidgetBuilder<EventoAgendaController2>(
                                builder: (context, controller) {
                                  return Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          constraints: BoxConstraints(
                                            //minWidth: 200.0,
                                            maxWidth: 450.0,
                                          ),
                                          padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 55) + MediaQuery.of(context).padding.top,
                                              right: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 10),
                                              left: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 10)),
                                          child: Wrap(
                                            spacing: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16),
                                            runSpacing: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16),
                                            direction: Axis.horizontal,
                                            alignment: WrapAlignment.center,
                                            children: <Widget>[
                                              for(var item in controller.tipoEventoList)
                                                chip(item, (tipoEvento){
                                                  controller.onSelectedTipoEvento(tipoEvento);
                                                }),
                                              //chipEspacio()
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          ),
                        )
                      ];
                    },
                    body: Container()

                ),*/
               Container(
                 padding: EdgeInsets.only(
                   top: AppBar().preferredSize.height +
                       MediaQuery.of(context!).padding.top +
                       0),
                 child:  ControlledWidgetBuilder<EventoAgendaController2>(
                   builder: (context, controller){
                     return Stack(
                       children: [
                         controller.eventoUiList == null?
                         Container():
                         controller.eventoUiList!.isEmpty?
                         Column(
                           children: [
                             Expanded(
                                 flex: 5,
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Center(
                                       child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
                                     ),
                                     Padding(padding: EdgeInsets.all(4)),
                                     Center(
                                       child: Text("Lista vacía${(controller.msgConexion??"").isNotEmpty?", revice su conexión a internet":""}", style: TextStyle(color: AppTheme.grey, fontStyle: FontStyle.italic, fontSize: 12),),
                                     )
                                   ],
                                 )
                             ),Expanded(
                                 flex: 1,
                                 child: Container()
                             )
                           ],
                         ):Container(),
                         CustomScrollView(
                           controller: scrollController,
                           slivers: <Widget>[
                             SliverList(
                                 delegate: SliverChildListDelegate([
                                   Container(
                                     padding: EdgeInsets.only(
                                       top: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16),
                                     ),
                                   ),
                                 ])
                             ),
                             if(controller.selectedTipoEventoUi?.tipo == EventoIconoEnumUI.AGENDA)
                               SliverList(
                                   delegate: SliverChildListDelegate([
                                     Container(
                                       padding: EdgeInsets.only(
                                         left: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 24),
                                         right: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 24),
                                         top: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 0),
                                         bottom: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 24),
                                       ),
                                       child: Stack(
                                         children: [
                                           Center(
                                             child: InkWell(
                                               onTap: () async{
                                                 dynamic respuesta = await AppRouter.createCrearEventoRouter(context, null, null);
                                                 if(respuesta is int) controller.cambiosEvento();
                                               },
                                               child: Container(
                                                 padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8)),
                                                 decoration: BoxDecoration(
                                                   color:  HexColor("#71bb74").withOpacity(1),
                                                   borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8)), // use instead of BorderRadius.all(Radius.circular(20)),
                                                   boxShadow: [
                                                     BoxShadow(
                                                         color: (Color(0XFF71bb74)).withOpacity(0.4),
                                                         offset:  Offset(0,3),
                                                         blurRadius: 6.0,
                                                         spreadRadius: 0
                                                     ),
                                                   ],
                                                 ),
                                                 width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 410),
                                                 height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 70),
                                                 child: FDottedLine(
                                                   color: AppTheme.white,
                                                   strokeWidth: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 2),
                                                   dottedLength: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 10),
                                                   space: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 2),
                                                   corner: FDottedLineCorner.all(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 14)),

                                                   /// add widget
                                                   child: Container(
                                                     alignment: Alignment.center,
                                                     child: Text("Crear un evento",  style: TextStyle(
                                                         fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 18),
                                                         fontWeight: FontWeight.w700,
                                                         fontFamily: AppTheme.fontTTNorms,
                                                         color:  AppTheme.white
                                                     ),),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           )
                                         ],
                                       ),
                                     ),
                                   ])
                               ),
                             SliverList(
                                 delegate: SliverChildBuilderDelegate(
                                         (BuildContext context, int index){
                                       EventoUi? eventoUi = controller.eventoUiList?[index];

                                       return ItemEventoView(eventoUi, tipoEditar: controller.selectedTipoEventoUi?.tipo == EventoIconoEnumUI.AGENDA,
                                         onClickMoreEventoAdjuntoDowload:(eventoUi) {
                                           controller.onClickMoreEventoAdjuntoDowload(eventoUi);
                                         }, onClickPreview: (eventoUi, eventoAdjuntoUi) async{
                                           if((eventoUi?.eventoAdjuntoUiPreviewList??[]).isNotEmpty&&(eventoUi?.eventoAdjuntoUiPreviewList??[]).length>1){
                                             dynamic response = await AppRouter.createEventoInfoComplejoRouter(context, eventoUi);
                                           }else{
                                             dynamic response = await AppRouter.createEventoInfoSimpleRouter(context, eventoUi, eventoAdjuntoUi);
                                           }
                                         }, onClickPreviewComplejo: (eventoUi, eventoAdjuntoUi) async {
                                           dynamic response = await AppRouter.createEventoInfoComplejoRouter(context, eventoUi);
                                         },
                                         onClickEditar: (eventoUi) async{
                                           dynamic respuesta = await AppRouter.createCrearEventoRouter(context, eventoUi, null);
                                           if(respuesta is int) controller.cambiosEvento();
                                         },
                                         onClickEliminar: (eventoUi) {
                                           controller.onClickElimarEvento(eventoUi);
                                         },
                                         onClickPublicar: (eventoUi) async{
                                           bool? result = await controller.onClickPublicar(eventoUi);

                                         },
                                       );
                                     },
                                     childCount: controller.eventoUiList?.length??0
                                 )
                             ),
                             SliverList(
                                 delegate: SliverChildListDelegate(
                                     [
                                       Container(
                                         height: 100,
                                       )
                                     ])
                             )
                           ],
                         ),
                       ],
                     );
                   },
                 ),
               ),
              )
          ),
        );
      },
    );
  }

  String getImagen(TipoRecursosUi? tipoRecursosUi){
    switch(tipoRecursosUi??TipoRecursosUi.TIPO_VINCULO){
      case TipoRecursosUi.TIPO_VIDEO:
        return AppImagen.archivo_video_ico;
      case TipoRecursosUi.TIPO_VINCULO:
        return AppImagen.archivo_link_ico;
      case TipoRecursosUi.TIPO_DOCUMENTO:
        return AppImagen.archivo_documento_ico;
      case TipoRecursosUi.TIPO_IMAGEN:
        return AppImagen.archivo_imagen_ico;
      case TipoRecursosUi.TIPO_AUDIO:
        return AppImagen.archivo_audio_ico;
      case TipoRecursosUi.TIPO_HOJA_CALCULO:
        return AppImagen.archivo_hoja_calculo_ico;
      case TipoRecursosUi.TIPO_DIAPOSITIVA:
        return AppImagen.archivo_diapositiva_ico;
      case TipoRecursosUi.TIPO_PDF:
        return AppImagen.archivo_pdf_ico;
      case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
        return AppImagen.archivo_youtube_ico;
      case TipoRecursosUi.TIPO_VINCULO_DRIVE:
        return AppImagen.archivo_drive;
      case TipoRecursosUi.TIPO_RECURSO:
        return AppImagen.archivo_recurso_ico;
      case TipoRecursosUi.TIPO_ENCUESTA:
        return AppImagen.archivo_recurso_ico;
    }
  }

  Widget dialogAdjuntoDownload(EventoAgendaController2 controller) {
    List<EventoAdjuntoUi> eventoAdjuntoUiList = controller.eventoUiSelected?.eventoAdjuntoUiDownloadList??[];
    print("eventoAdjuntoUiList: a ${eventoAdjuntoUiList.length}");
    return ArsProgressWidget(
      blur: 2,
      backgroundColor: Color(0x33000000),
      animationDuration: Duration(milliseconds: 500),
      loadingWidget: Container(
        constraints: BoxConstraints(
            minWidth: 280.0,
            maxHeight: MediaQuery.of(context).size.height * 0.8
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: HexColor("#6D8392")
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 48),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(right: 32, left: 32, top: 16, bottom: 8),
                color: HexColor("#F5F5F5"),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 0),
                    itemBuilder: (context, index) {
                      EventoAdjuntoUi eventoAdjuntoUi = eventoAdjuntoUiList[index];
                      return InkWell(
                        onTap: () async{
                          await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(eventoAdjuntoUi.driveId), webview: false);
                        },
                        child:  Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: HexColor("#526D8392"),
                              )
                            )
                          ),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 18, right: 16),
                                width: 30,
                                height: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.asset(
                                    getImagen(eventoAdjuntoUi.tipoRecursosUi),
                                    height: 25.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Text("${eventoAdjuntoUi.titulo??""}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: HexColor("#013A62"),
                                          fontSize: 12
                                      )
                                  )
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 12, right: 12),
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                    color: HexColor("#E0E0E0")
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppIcon.ic_evento_adjunto_download,
                                    semanticsLabel:"Download Evento",
                                    color: HexColor("#6D8392"),
                                    width: 14,
                                    height: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: eventoAdjuntoUiList.length,
                  ),

                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 32, top: 16, bottom: 8),
              child: TextButton(
                onPressed: () {
                  controller.onClickAtrasDialogEventoAdjuntoDownload();
                },
                child: Text('Atras', style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 16
                ),),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getMenuView(EventoAgendaController2 controller) {
    return Container(
      margin: EdgeInsets.only(
          top: 16,
          left: 24,
          right: 24,
          bottom: 64
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Filtrar publicaciones",
            style: TextStyle(
              fontFamily: AppTheme.fontTTNorms,
              fontWeight: FontWeight.w700,
              fontSize: 16,
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
            alignment: Alignment.center,
            child:  Wrap(
              spacing: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 12),
              runSpacing: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 12),
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              children: <Widget>[
                for(var item in controller.tipoEventoList)
                  chip(item, (tipoEvento){
                    controller.onSelectedTipoEvento(tipoEvento);
                  }),
                //chipEspacio()
              ],
            ),
          )
        ],
      ),
    );
  }

}

typedef MenuBuilder = void Function(Widget menuView);