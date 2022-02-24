import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ss_crmeducativo_2/libs/fancy_shimer_image/fancy_shimmer_image.dart';
import 'package:ss_crmeducativo_2/src/app/page/eventos_agenda/informacion/evento_informacion_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_linkify.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_system_ui.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_url_launcher.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_adjunto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_drive_tools.dart';

class EventoInfoComplejoView extends View{
  EventoUi? eventoUi;
  EventoInfoComplejoView(this.eventoUi);

  @override
  _EventoInfoComplejoState createState() => _EventoInfoComplejoState(eventoUi);

  
}

class _EventoInfoComplejoState extends ViewState<EventoInfoComplejoView, EventoInformacionController>{
  _EventoInfoComplejoState( EventoUi? eventoUi) : super(EventoInformacionController(eventoUi, null));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget get view => AnnotatedRegion<SystemUiOverlayStyle>(
    value: AppSystemUi.getSystemUiOverlayStyleClaro(),
    child:  ControlledWidgetBuilder<EventoInformacionController>(
        builder: (context, controller) {

          String? imagePreview = (controller.eventoUi?.eventoAdjuntoUiPreviewList?.isNotEmpty??false)?
          (controller.eventoUi?.eventoAdjuntoUiPreviewList?[0].imagePreview):"";

          return ControlledWidgetBuilder<EventoInformacionController>(
              builder: (context, controller) {

                return WillPopScope(
                  onWillPop: () async {

                    return controller.onBackPress();
                  },
                  child: Stack(
                    children: [
                      Scaffold(
                        extendBody: true,
                        backgroundColor: HexColor("#292A2B"),
                        body: Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16,),
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Container(
                                  padding: EdgeInsets.only(left: 24, right: 24),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      getCabeceraEvento(controller.eventoUi),
                                      Container(
                                        margin:  const EdgeInsets.only(top: 8, bottom: 0),
                                        color: HexColor("#33979797"),
                                        height: 1,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(top: 8, bottom: 0),
                                              child: CachedNetworkImage(
                                                  placeholder: (context, url) => CircularProgressIndicator(),
                                                  imageUrl: controller.eventoUi?.fotoEntidad??'',
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
                                                child: Container(
                                                  margin: const EdgeInsets.only(top: 8, left: 8, right: 16, bottom: 0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      //Text(eventoUi.nombreEntidad??'', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 16, color: AppTheme.darkText),),
                                                      Text('${controller.eventoUi?.nombreEmisor??""}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 14, color: AppTheme.white),),
                                                      Padding(padding: EdgeInsets.all(2)),
                                                      Text('${controller.eventoUi?.rolEmisor??""} ${(controller.eventoUi?.nombreFechaPublicacion??"").isNotEmpty?" - " + (controller.eventoUi?.nombreFechaPublicacion??""): ""}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 11, color: AppTheme.white))
                                                    ],
                                                  ),
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        color: HexColor("#33979797"),
                                        height: 1,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(top: 16, bottom: 0),
                                        child: Text(controller.eventoUi?.titulo??'', style: TextStyle( fontSize: 14, color: AppTheme.white, fontFamily: AppTheme.fontName, )),
                                      ),
                                      if((controller.eventoUi?.descripcion??"").isNotEmpty && controller.eventoUi?.descripcion != ".")
                                        Container(
                                          margin: const EdgeInsets.only(top: 8, ),
                                          child: Linkify(
                                            text: '${controller.eventoUi?.descripcion}',
                                            style: TextStyle( fontSize: 12, color: AppTheme.white, fontWeight: FontWeight.w300, height: 1.5),
                                            onOpen: (url) async {
                                              await AppUrlLauncher.openLink(url.url);
                                            },
                                          ),
                                        ),
                                      Column(
                                        children:List.generate(controller.eventoUi?.eventoAdjuntoUiEncuestaList?.length??0, (index){
                                          EventoAdjuntoUi? eventoAdjuntoUi = controller.eventoUi?.eventoAdjuntoUiEncuestaList?[index];
                                          return Container(
                                            padding: EdgeInsets.only(top: index==0?8:4),
                                            child: Row(
                                              children: [
                                                Padding(padding: EdgeInsets.all(8)),
                                                SvgPicture.asset(
                                                  AppIcon.ic_evento_adjunto_instrumetno,
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                Padding(padding: EdgeInsets.all(4)),
                                                Text("Encuesta: ",  style: TextStyle(
                                                    fontSize: 12,
                                                    color: HexColor("#5588AD"),
                                                    fontWeight: FontWeight.w700
                                                ),),
                                                Expanded(
                                                    child: InkWell(
                                                      onTap: () async{
                                                        String? url = AppLinkify.extractLink(eventoAdjuntoUi?.titulo??"");
                                                        await AppUrlLauncher.openLink(url);
                                                      },
                                                      child: Text("${eventoAdjuntoUi?.titulo??""}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: HexColor("439EF2"),
                                                            fontWeight: FontWeight.w400
                                                        )
                                                        ,),
                                                    )
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 14, left: 14, right: 0, bottom: 0),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(top: 0, left: 0, right: 8, bottom: 0),
                                              child: Image.asset(AppIcon.img_evento_megusta_1, width: 16, height: 16,),
                                            ),
                                                (){
                                              String megusta = "me gusta";
                                              if((controller.eventoUi?.cantLike??0)!=0){
                                                megusta =  "${controller.eventoUi?.cantLike??""} me gusta";
                                              }else if((controller.eventoUi?.cantLike??0)>1000){
                                                megusta += "1k me gusta" ;
                                              }
                                              return Text(megusta, style: TextStyle( fontSize: 11, color: AppTheme.white),);
                                            }(),
                                            Expanded(
                                              child: Container(),
                                            ),
                                            Text(controller.eventoUi?.nombreEntidad??'', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 11, color: AppTheme.white, fontStyle: FontStyle.italic),),
                                            Padding(padding: const EdgeInsets.only(right: 16))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:  const EdgeInsets.only(top: 16, bottom: 0),
                                        color: AppTheme.white,
                                        height: 0.5,
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
                                                  height: 45,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
                                                        child: Image.asset(AppIcon.img_evento_megusta, width: 18, height: 18, color: AppTheme.white,),
                                                      ),
                                                      Text("Me gusta", style: TextStyle( fontSize: 12, color: AppTheme.white),),
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
                                                  if(controller.eventoUi?.fotoEntidad!=null && (controller.eventoUi?.fotoEntidad??"").isNotEmpty){
                                                    //_shareImageFromUrl(eventoUi);
                                                  }else{
                                                    //_shareText(eventoUi);
                                                  }
                                                },
                                                child:
                                                Container(
                                                  padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 0),
                                                  height: 45,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
                                                        child: Image.asset(AppIcon.img_evento_compartir,  width:18, height:18, color: AppTheme.white,),
                                                      ),
                                                      Text("Compartir", style: TextStyle( fontSize: 12, color: AppTheme.white), ),
                                                    ],
                                                  ),
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin:  const EdgeInsets.only(top: 0, bottom: 0),
                                        color: AppTheme.white,
                                        height: 0.5,
                                      ),
                                      listarAdjuntosEventos(controller.eventoUi,controller.eventoUi?.eventoAdjuntoUiDownloadList, controller ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          EventoAdjuntoUi eventoAdjuntoUi = controller.eventoUi!.eventoAdjuntoUiPreviewList![index];
                                          return previewEventos(controller.eventoUi!, eventoAdjuntoUi);
                                        },
                                        itemCount: controller.eventoUi?.eventoAdjuntoUiPreviewList?.length,
                                      ),


                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                  left: 16,
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: AppTheme.black.withOpacity(0.4),
                                        shape: BoxShape.circle
                                      ),
                                      child: Center(
                                        child: Icon(Icons.arrow_back, color: AppTheme.white, size: 28,),
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                      controller.dialogAdjuntoDownload?
                      dialogAdjuntoDownload(controller):Container()
                    ],
                  ),
                );
              });
        }),
  );

  Widget getCabeceraEvento(EventoUi? eventoUi) {
    Color? color;
    String? imagepath;

    switch(eventoUi?.tipoEventoUi?.tipo??EventoIconoEnumUI.DEFAULT){
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
      height: 52,
      //color: AppTheme.black.withOpacity(0.5),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: color,
            ),
            height: 30,
            width: 30,
            child: Center(
              child: SvgPicture.asset(
                imagepath,
                semanticsLabel:"Eventos",
                color: AppTheme.white,
                width: 16,
                height: 16,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 16),
              child: Text("${eventoUi?.tipoEventoUi?.nombre??""} ${eventoUi?.nombreFecha??""}",
                style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.white
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget previewEventos(EventoUi eventoUi, EventoAdjuntoUi? eventoAdjuntoUi) {
    double _sigmaX = 6.0; // from 0-10
    double _sigmaY = 6.0; // from 0-10
    double _opacity = 0.1; // from 0-1.0

    return AspectRatio(
      aspectRatio: 4/3,
      child: Container(
          margin: EdgeInsets.only(bottom: 24),
          color: HexColor("#DFDFDF"),
          child: InkWell(
            onTap: () async{
              dynamic response = await AppRouter.createEventoInfoSimpleRouter(context, eventoUi, eventoAdjuntoUi);
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(eventoAdjuntoUi?.imagePreview??""),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                      child: Container(
                        color: Colors.black.withOpacity(_opacity),
                      ),
                    ),
                  ),
                ),
                FancyShimmerImage(
                  height: double.infinity,
                  width: double.infinity,
                  boxFit: BoxFit.contain,
                  imageUrl: eventoAdjuntoUi?.imagePreview??"",
                  errorWidget: Icon(Icons.warning_amber_rounded, color: AppTheme.white, size: 105,),
                ),
                if(eventoAdjuntoUi?.tipoRecursosUi == TipoRecursosUi.TIPO_VIDEO ||
                    eventoAdjuntoUi?.tipoRecursosUi == TipoRecursosUi.TIPO_VINCULO_YOUTUBE)
                  Center(
                    child: Container(
                      height: 40,
                      width: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: AppTheme.redAccent4.withOpacity(0.7)
                      ),
                      child: Center(
                        child: Icon(Icons.play_arrow, size: 30, color: AppTheme.white.withOpacity(0.8),),
                      ),
                    ),
                  )
              ],
            ),
          )
      ),
    );
  }

  Widget listarAdjuntosEventos(EventoUi? eventoUi, List<EventoAdjuntoUi>? eventoAdjuntoList, EventoInformacionController controller){

    return eventoAdjuntoList?.isNotEmpty??false?Container(
      height: 40,
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          color: HexColor("#F5F5F5")
      ),
      child:Row(
        children: List.generate((eventoAdjuntoList??[]).length>4?4:(eventoAdjuntoList??[]).length, (index) {

          EventoAdjuntoUi? eventoAdjuntoUi = eventoAdjuntoList?[index];

          return Expanded(
              child: Stack(
                children: [
                  InkWell(
                    onTap: () async{
                      if(eventoAdjuntoUi?.tipoRecursosUi == TipoRecursosUi.TIPO_VINCULO ||
                          eventoAdjuntoUi?.tipoRecursosUi == TipoRecursosUi.TIPO_VINCULO_YOUTUBE){
                        await AppUrlLauncher.openLink(eventoAdjuntoUi?.titulo, webview: false);
                      }else{
                        await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(eventoAdjuntoUi?.driveId), webview: false);
                      }
                    },
                    child:  Container(
                      height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 45),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8),
                                right: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 4)
                            ),
                            width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 23),
                            height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 23),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                getImagen(eventoAdjuntoUi?.tipoRecursosUi),
                                height:ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 23),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Text("${eventoAdjuntoUi?.titulo??""}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: HexColor("#013A62"),
                                      fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 10)
                                  )
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 12),
                                right: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 12)
                            ),
                            width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 20),
                            height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                color: HexColor("#E0E0E0")
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                AppIcon.ic_evento_adjunto_download,
                                semanticsLabel:"Download Evento",
                                color: HexColor("#6D8392"),
                                width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 10),
                                height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 10),
                              ),
                            ),
                          ),
                          if(index != (eventoAdjuntoList?.length??0)-1 && index != 3)
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: HexColor("#526D8392"),
                                          width: 0.5
                                      )
                                  )
                              ),
                              height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 45),
                            )
                        ],
                      ),
                    ),
                  ),
                  if(index >= 3)
                    InkWell(
                      onTap: (){
                        controller.onClickMoreEventoAdjuntoDowload(eventoUi);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(0),
                              bottomRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 4))
                          ),
                          color: HexColor("#80000000"),
                        ),
                        child: Center(
                          child: Text("+${((eventoAdjuntoList?.length??0)-4)}",
                            style: TextStyle(
                              color: AppTheme.white,
                              fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 24),
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(2.0, 2.5),
                                  blurRadius: 5.0,
                                  color:  AppTheme.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              )
          );
        }),
      ),
    ):
    Container();
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

  Widget dialogAdjuntoDownload(EventoInformacionController controller) {
    List<EventoAdjuntoUi> eventoAdjuntoUiList = controller.eventoUiSelected?.eventoAdjuntoUiDownloadList??[];

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

}