import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ss_crmeducativo_2/libs/fancy_shimer_image/fancy_shimmer_image.dart';
import 'package:ss_crmeducativo_2/libs/flutter_smart_text_view/smart_text_view.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/animation_view.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:url_launcher/url_launcher.dart';

import 'evento_agenda_controller.dart';

class EventoAgendaView extends View{
  final AnimationController animationController;

  EventoAgendaView({required this.animationController});

  @override
  _EventoAgendaViewState createState() => _EventoAgendaViewState();

}

class _EventoAgendaViewState extends ViewState<EventoAgendaView, EventoAgendaController> with TickerProviderStateMixin{

  _EventoAgendaViewState() : super(EventoAgendaController(DeviceHttpDatosRepositorio(), MoorConfiguracionRepository(), MoorAgendaEventoRepository()));

  late Animation<double> topBarAnimation;

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

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

    Future.delayed(const Duration(milliseconds: 500), () {
// Here you can write your code
      setState(() {
        widget.animationController.forward();
      });

    });

    super.initState();
  }

  @override
  Widget get view => Stack(
    children: <Widget>[
      getMainTab(),
      getAppBarUI(),
      ControlledWidgetBuilder<EventoAgendaController>(
          builder: (context, controller){
            if(controller.msgConexion!=null ? true:false){
              return Positioned(
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
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                          child: Text(controller.msgConexion??"", style: TextStyle(color: AppTheme.white),),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }else{
              return Container();
            }
          }
      )


    ],
  );

  Widget chip(TipoEventoUi tipo, Function onClick) {
    Color color;
    String imagepath;
    switch(tipo.tipo??EventoIconoEnumUI.DEFAULT){
      case EventoIconoEnumUI.DEFAULT:
        color = Color(0xFF00BCD4);
        imagepath = AppIcon.ic_tipo_evento_agenda;
        break;
      case EventoIconoEnumUI.EVENTO:
        color = Color(0xFF4CAF50);
        imagepath = AppIcon.ic_tipo_evento_evento;
        break;
      case EventoIconoEnumUI.NOTICIA:
        color = Color(0xFF03A9F4);
        imagepath = AppIcon.ic_tipo_evento_noticia;
        break;
      case EventoIconoEnumUI.ACTIVIDAD:
        color = Color(0xFFFF9800);
        imagepath = AppIcon.ic_tipo_evento_actividad;
        break;
      case EventoIconoEnumUI.TAREA:
        color = Color(0xFFE91E63);
        imagepath =  AppIcon.ic_tipo_evento_tarea;
        break;
      case EventoIconoEnumUI.CITA:
        color = Color(0xFF00BCD4);
        imagepath = AppIcon.ic_tipo_evento_cita;
        break;
      case EventoIconoEnumUI.AGENDA:
        color = Color(0xFFAD3FF8);
        imagepath = AppIcon.ic_tipo_evento_agenda;
        break;
      case EventoIconoEnumUI.TODOS:
        color = Color(0xFF00BCD4);
        imagepath = AppIcon.ic_tipo_evento_todos;
        break;
    }

    return Container(
      //margin: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
      height: 65,
      width: 80,
      decoration: BoxDecoration(
        color: color.withOpacity(tipo.toogle??false?1:0.5),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
            topRight: Radius.circular(8.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: AppTheme.grey.withOpacity(0.4),
              offset: const Offset(1.1, 1.1),
              blurRadius: 10.0),
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
                    padding: const EdgeInsets.only(top: 4),
                    child: SvgPicture.asset(
                      imagepath,
                      semanticsLabel:"Eventos",
                      color: AppTheme.white,
                      width: 35,
                      height: 35,
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4,left: 8, right: 8),
                child: Text(tipo.nombre??"", textAlign: TextAlign.center , style: TextStyle(color: AppTheme.white, fontSize: 10)),
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
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context!).padding.top,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 48,
                          right: 16,
                          top: 16 - 8.0 * topBarOpacity,
                          bottom: 12 - 8.0 * topBarOpacity),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Eventos',
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22 + 6 - 6 * topBarOpacity,
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
                child: NestedScrollView(
                    controller: scrollController,
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[

                        SliverAppBar(
                          toolbarHeight: 65,
                          expandedHeight: 200.0 + MediaQuery.of(context).padding.top,
                          backgroundColor: AppTheme.white,
                          brightness: Brightness.light,
                          shadowColor: AppTheme.grey
                              .withOpacity(0.4),
                          automaticallyImplyLeading: false,
                          floating: false,
                          pinned: true,
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(80), bottomRight: Radius.circular(0))),
                          flexibleSpace: FlexibleSpaceBar(
                            background: ControlledWidgetBuilder<EventoAgendaController>(
                                builder: (context, controller) {
                                  return Container(
                                    padding: EdgeInsets.only(top: 70 + MediaQuery.of(context).padding.top, right: 0, left: 0),
                                    child: Wrap(
                                      spacing: 10.0,
                                      runSpacing: 6.0,
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
                                  );
                                }),
                          ),
                        )

                      ];
                    },
                    body: ControlledWidgetBuilder<EventoAgendaController>(
                      builder: (context, controller){
                        return Stack(
                          children: [
                            CustomScrollView(
                              slivers: <Widget>[
                                SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                            (BuildContext context, int index){
                                          EventoUi eventoUi = controller.eventoUiList[index];
                                          return Card(
                                            //color: AppTheme.colorAccent,
                                            margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10), // if you need this
                                              side: BorderSide(
                                                color: Colors.grey.withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          margin: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 0),
                                                          child: CachedNetworkImage(
                                                              placeholder: (context, url) => CircularProgressIndicator(),
                                                              imageUrl: eventoUi.fotoEntidad??'',
                                                              errorWidget: (context, url, error) => Container(),
                                                              imageBuilder: (context, imageProvider) => Container(
                                                                  height: 40,
                                                                  width: 40,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                                                    image: DecorationImage(
                                                                      image: imageProvider,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  )
                                                              )
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 6,
                                                            child: Container(
                                                              margin: const EdgeInsets.only(top: 8, left: 8, right: 16, bottom: 0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  //Text(eventoUi.nombreEntidad??'', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 16, color: AppTheme.darkText),),
                                                                  Text(eventoUi.nombreEmisor??'', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 14, color: AppTheme.darkText),),
                                                                  Text(eventoUi.rolEmisor??'', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 10, color: AppTheme.darkText),),
                                                                  Text(eventoUi.nombreFecha??'', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 10, color: AppTheme.lightText))
                                                                ],
                                                              ),
                                                            )
                                                        ),
                                                        //Icon(Icons.arrow_right, color: AppTheme.grey,),
                                                        /*Expanded(
                                                  flex: 5,
                                                  child: Container(
                                                    margin: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(eventoUi.rolEmisor??'', maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 16, color: AppTheme.darkText),),
                                                        Text(eventoUi.nombreEmisor??'', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 12, color: AppTheme.lightText))
                                                      ],
                                                    ),
                                                  )
                                              ),*/
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 0),
                                                    child: Text(eventoUi.titulo??'', style: TextStyle( fontSize: 16, color: AppTheme.darkText, fontFamily: AppTheme.fontName, )),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 0),
                                                    child: SmartText(
                                                      text: eventoUi.descripcion??'',
                                                      style: TextStyle( fontSize: 16, color: AppTheme.darkText, fontFamily: AppTheme.fontName, fontWeight: FontWeight.w300,),
                                                      onOpen: (url) => launch(url),
                                                    ),
                                                  ),

                                                  /*
                            * CENTER = none
                            * CENTER_CROP = Cover
                            * CENTER_INSIDE = scaleDown
                            * FIT_CENTER = contain (alignment.center)
                            * FIT_END = contain (alignment.bottomright)
                            * FIT_START = contain (alignment.topleft)
                            * FIT_XY = Fill
                            *
                            * */
                                                      (){
                                                    EventoIconoEnumUI tipo = eventoUi.tipoEventoUi?.tipo??EventoIconoEnumUI.DEFAULT;

                                                    if (tipo == EventoIconoEnumUI.NOTICIA ||
                                                        tipo == EventoIconoEnumUI.EVENTO || (tipo == EventoIconoEnumUI.AGENDA && eventoUi.foto!=null&&(eventoUi.foto??"").isNotEmpty)){
                                                      return Container(
                                                        margin: const EdgeInsets.only(top: 8, left: 0, right: 0, bottom: 0),
                                                        color: AppTheme.grey.withOpacity(0.7),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.stretch,  // add this
                                                          children: [
                                                            ClipRRect(
                                                              /*borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0),
                                          ),*/
                                                                child: InkWell(
                                                                  onTap: (){
                                                                    //controller.onClickVerEvento(eventoUi);
                                                                    //Navigator.of(context).push(InformacionEventoAgendaView.createRouteAgenda(eventoUi));

                                                                  },
                                                                  child: FancyShimmerImage(
                                                                    boxFit: BoxFit.cover,
                                                                    imageUrl: eventoUi.foto??'',
                                                                    errorWidget: Icon(Icons.warning_amber_rounded, color: AppTheme.white, size: 105,),
                                                                  ),
                                                                )
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }else{
                                                      return Container();
                                                    }

                                                  }(),
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 8, left: 16, right: 0, bottom: 0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width:18,
                                                          height:18,
                                                          margin: const EdgeInsets.only(top: 0, left: 0, right: 8, bottom: 0),
                                                          child: Image.asset(AppIcon.img_evento_megusta_1),
                                                        ),
                                                            (){
                                                          String megusta = "me gusta";
                                                          if((eventoUi.cantLike??0)!=0){
                                                            megusta =  eventoUi.cantLike.toString() + " me gusta";
                                                          }else if((eventoUi.cantLike??0)>1000){
                                                            megusta += "1k me gusta" ;
                                                          }
                                                          return Text(megusta, style: TextStyle( fontSize: 12, color: AppTheme.darkText),);
                                                        }(),
                                                        Expanded(
                                                          child: Container(),
                                                        ),
                                                        Text(eventoUi.nombreEntidad??'', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 12, color: AppTheme.darkText, fontStyle: FontStyle.italic),),
                                                        Padding(padding: const EdgeInsets.only(right: 16))
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:  const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 0),
                                                    child: Divider(
                                                      height: 1,
                                                      color: AppTheme.colorShimmer,
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Material(
                                                        color: Colors.transparent,
                                                        child: InkWell(
                                                            focusColor: Colors.transparent,
                                                            highlightColor: Colors.transparent,
                                                            hoverColor: Colors.transparent,
                                                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                            splashColor: AppTheme.nearlyDarkBlue.withOpacity(0.2),
                                                            onTap: () {

                                                            },
                                                            child:
                                                            Container(
                                                              padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 0),
                                                              height: 48,
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width:20,
                                                                    height:20,
                                                                    margin: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
                                                                    child: Image.asset(AppIcon.img_evento_megusta),
                                                                  ),
                                                                  Text("Me gusta", style: TextStyle( fontSize: 14, color: AppTheme.lightText),),
                                                                ],
                                                              ),
                                                            )
                                                        ),
                                                      ),
                                                      Expanded(child: Container()),
                                                      Material(
                                                        color: Colors.transparent,
                                                        child: InkWell(
                                                            focusColor: Colors.transparent,
                                                            highlightColor: Colors.transparent,
                                                            hoverColor: Colors.transparent,
                                                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                            splashColor: AppTheme.nearlyDarkBlue.withOpacity(0.2),
                                                            onTap: () {
                                                              if(eventoUi.fotoEntidad!=null && (eventoUi.fotoEntidad??"").isNotEmpty){
                                                                _shareImageFromUrl(eventoUi);
                                                              }else{
                                                                _shareText(eventoUi);
                                                              }
                                                            },
                                                            child:
                                                            Container(
                                                              padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 0),
                                                              height: 48,
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width:20,
                                                                    height:20,
                                                                    margin: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
                                                                    child: Image.asset(AppIcon.img_evento_compartir),
                                                                  ),
                                                                  Text("Compartir", style: TextStyle( fontSize: 14, color: AppTheme.lightText),),
                                                                ],
                                                              ),
                                                            )
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        childCount: controller.eventoUiList.length
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
                            controller.isLoading ?  Container(child: Center(
                              child: CircularProgressIndicator(),
                            )): Container(),
                          ],
                        );
                      },
                    )

                ),
              )
          ),
        );
      },
    );
  }

  Future<void> _shareImageFromUrl(EventoUi eventoUi) async {
    try {
      /*var request = await HttpClient().getUrl(Uri.parse(
          'https://shop.esys.eu/media/image/6f/8f/af/amlog_transport-berwachung.jpg'));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);*/

      var file = await DefaultCacheManager().getSingleFile(eventoUi.foto??"");
      List<int> bytes = await file.readAsBytes();
      Uint8List ubytes = Uint8List.fromList(bytes);

      //await Share.file(eventoUi.titulo, 'amlog.jpg', ubytes, 'image/jpg', text: eventoUi.titulo +"\n"+eventoUi.descripcion,);
    } catch (e) {}
  }

  Future<void> _shareText(EventoUi eventoUi) async {
    try {
      //Share.text(eventoUi.titulo,
      //    eventoUi.titulo +"\n"+eventoUi.descripcion, 'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }

}