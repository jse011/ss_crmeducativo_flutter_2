import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fancy_shimer_image/fancy_shimmer_image.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_linkify.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_url_launcher.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_adjunto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_eventoUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_drive_tools.dart';

class ItemEventoView extends StatefulWidget{
  EventoUi? eventoUi;
  bool? tipoEditar;
  OnClickMoreEventoAdjuntoDowload? onClickMoreEventoAdjuntoDowload;
  OnClickPreview? onClickPreview;
  OnClickPreviewComplejo? onClickPreviewComplejo;
  OnClickEliminar? onClickEliminar;
  OnClickEditar? onClickEditar;
  OnClickPublicar? onClickPublicar;
  OnClickMegusta? onClickMegusta;

  ItemEventoView(this.eventoUi, {this.tipoEditar, this.onClickMoreEventoAdjuntoDowload, this.onClickPreview, this.onClickPreviewComplejo, this.onClickEditar, this.onClickMegusta, this.onClickEliminar, this.onClickPublicar});

  @override
  State<StatefulWidget> createState()  => _ItemEventoState();

}

class _ItemEventoState extends State<ItemEventoView>{
  _ItemEventoState();

  @override
  Widget build(BuildContext context) {
   return Stack(
     children: [
       Center(
         child: Container(
           margin: EdgeInsets.only(
               top: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 24),
               left: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 24),
               right: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 24),
               bottom: 0),
           padding: EdgeInsets.only(
               top: widget.eventoUi?.tipoEventoUi?.tipo == EventoIconoEnumUI.AGENDA && (widget.tipoEditar??false)? 8 : 0,
               left: widget.eventoUi?.tipoEventoUi?.tipo == EventoIconoEnumUI.AGENDA && (widget.tipoEditar??false)? 8 : 0,
               right: widget.eventoUi?.tipoEventoUi?.tipo == EventoIconoEnumUI.AGENDA && (widget.tipoEditar??false)? 8 : 0,
               bottom: widget.eventoUi?.tipoEventoUi?.tipo == EventoIconoEnumUI.AGENDA && (widget.tipoEditar??false)? 8 : 0
           ),
           decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16)),
               color: HexColor("#71bb74").withOpacity(0.5)
           ),
           child: Column(
             children: [
               if(widget.eventoUi?.tipoEventoUi?.tipo == EventoIconoEnumUI.AGENDA && (widget.tipoEditar??false))
                 Container(
                   margin: EdgeInsets.only(top:8, bottom: 8),
                   child:  Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Expanded(
                         child: Container(),
                       ),
                       InkWell(
                         onTap: (){
                           widget.onClickEditar?.call(widget.eventoUi);
                         },
                         child: Container(
                           padding: EdgeInsets.only(
                               left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16) ,
                               right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                               top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8),
                               bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                               color: HexColor("#71bb74")
                           ),
                           alignment: Alignment.center,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               Icon(Icons.edit ,color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,15), ),
                               Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,2)),),
                               FittedBox(
                                 fit: BoxFit.scaleDown,
                                 child: Text("Editar",
                                     overflow: TextOverflow.ellipsis,
                                     style: TextStyle(
                                       fontWeight: FontWeight.w500,
                                       letterSpacing: 0.5,
                                       color:AppTheme.white,
                                       fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,11),
                                     )),
                               ),
                             ],
                           ),
                         ),
                       ),
                       Padding(padding: EdgeInsets.only(
                           left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16)
                       )),
                       InkWell(
                         onTap: ()=> widget.onClickEliminar?.call(widget.eventoUi),
                         child: Container(
                           padding: EdgeInsets.only(
                               left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16) ,
                               right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16),
                               top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8),
                               bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)
                           ),
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                               color: HexColor("#71bb74")
                           ),
                           alignment: Alignment.center,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               Icon(Ionicons.trash ,color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,14)),
                               Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,2)),),
                               FittedBox(
                                 fit: BoxFit.scaleDown,
                                 child: Text("Elimnar",
                                     overflow: TextOverflow.ellipsis,
                                     style: TextStyle(
                                       fontWeight: FontWeight.w500,
                                       letterSpacing: 0.5,
                                       color:AppTheme.white,
                                       fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,11),
                                     )),
                               ),
                             ],
                           ),
                         ),
                       ),
                       Padding(padding: EdgeInsets.only(
                           left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)
                       )),
                     ],
                   ),
                 ),
               Container(
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 10)),
                     color: AppTheme.white
                 ),
                 constraints: BoxConstraints(
                   //minWidth: 200.0,
                   maxWidth: 410.0,
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     getCabeceraEvento(widget.eventoUi),
                     Container(
                       color: HexColor("#33979797"),
                       height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 1),
                     ),
                     Container(
                       margin: EdgeInsets.only(
                           bottom: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8)
                       ),
                       child: Row(
                         children: [
                           Container(
                             margin: EdgeInsets.only(
                                 top: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8),
                                 left: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16),
                                 right: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8),
                                 bottom: 0),
                             child: CachedNetworkImage(
                                 placeholder: (context, url) => CircularProgressIndicator(),
                                 imageUrl: widget.eventoUi?.fotoEntidad??'',
                                 errorWidget: (context, url, error) => Container(),
                                 imageBuilder: (context, imageProvider) => Container(
                                     height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 30),
                                     width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 30),
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 50))),
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
                                 margin: EdgeInsets.only(
                                     top: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8),
                                     left: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8),
                                     right: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16),
                                     bottom: 0),
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     //Text(eventoUi?.nombreEntidad??'', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 16, color: AppTheme.darkText),),
                                     Text('${widget.eventoUi?.nombreEmisor}',
                                         maxLines: 1,
                                         overflow: TextOverflow.ellipsis,
                                         style: TextStyle(
                                             fontFamily: AppTheme.fontTTNorms,
                                             fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 12),
                                             fontWeight: FontWeight.w500,
                                             color: AppTheme.darkText
                                         )
                                     ),
                                     Padding(
                                         padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 1))
                                     ),
                                     Text('${widget.eventoUi?.rolEmisor??""} ${(widget.eventoUi?.nombreFechaPublicacion??"").isNotEmpty?" - " + (widget.eventoUi?.nombreFechaPublicacion??""): ""}',
                                         maxLines: 1,
                                         overflow: TextOverflow.ellipsis,
                                         style: TextStyle(
                                             fontFamily: AppTheme.fontTTNorms,
                                             fontWeight: FontWeight.w700,
                                             fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 10),
                                             color: AppTheme.lightText)
                                     )
                                   ],
                                 ),
                               )
                           ),
                         ],
                       ),
                     ),
                     Container(
                       color: HexColor("#33979797"),
                       height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 1),
                     ),
                     Container(
                       margin: EdgeInsets.only(
                           top: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16),
                           left: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16),
                           right: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16),
                           bottom: 0
                       ),
                       child: Text(widget.eventoUi?.titulo??'',
                           style: TextStyle(
                             fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 14),
                             color: AppTheme.darkText,
                             fontWeight: FontWeight.w500,
                             fontFamily: AppTheme.fontTTNorms,
                           )
                       ),
                     ),
                     if((widget.eventoUi?.descripcion??"").isNotEmpty && widget.eventoUi?.descripcion != ".")
                       Container(
                         margin: EdgeInsets.only(
                             top: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8),
                             left: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16),
                             right: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16)
                         ),
                         child: Linkify(
                           text: '${widget.eventoUi?.descripcion}',
                           style: TextStyle(
                               fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 14),
                               color: AppTheme.darkText,
                               fontWeight: FontWeight.w300,
                               height: 1.5),
                           onOpen: (url) async {
                             await AppUrlLauncher.openLink(url.url);
                           },
                         ),
                       ),
                     Column(
                       children:List.generate(widget.eventoUi?.eventoAdjuntoUiEncuestaList?.length??0, (index){
                         EventoAdjuntoUi eventoAdjuntoUi = widget.eventoUi!.eventoAdjuntoUiEncuestaList![index];
                         return Container(
                           padding: EdgeInsets.only(
                               top: index==0?ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8):ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 4)
                           ),
                           child: Row(
                             children: [
                               Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8))),
                               SvgPicture.asset(
                                 AppIcon.ic_evento_adjunto_instrumetno,
                                 width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 20),
                                 height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 20),
                               ),
                               Padding(padding: EdgeInsets.all(4)),
                               Text("Encuesta: ",  style: TextStyle(
                                   fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 12),
                                   color: HexColor("#5588AD"),
                                   fontFamily: AppTheme.fontTTNorms,
                                   fontWeight: FontWeight.w700
                               ),),
                               Expanded(
                                   child: InkWell(
                                     onTap: () async{
                                       String? url = AppLinkify.extractLink(eventoAdjuntoUi.titulo??"");
                                       await AppUrlLauncher.openLink(url);
                                     },
                                     child: Text("${eventoAdjuntoUi.titulo??""}",
                                       maxLines: 1,
                                       overflow: TextOverflow.ellipsis,
                                       style: TextStyle(
                                           fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 12),
                                           color: HexColor("439EF2"),
                                           fontFamily: AppTheme.fontTTNorms,
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
                     Padding(padding: EdgeInsets.only(bottom: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16))
                     ),
                     if( widget.eventoUi?.eventoAdjuntoUiPreviewList?.isNotEmpty??false)
                       Container(
                         height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 220),
                         child: listarPreviewEventos(widget.eventoUi, widget.eventoUi?.eventoAdjuntoUiPreviewList),
                       ),
                     Container(
                       margin: EdgeInsets.only(
                           top: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8),
                           left: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16),
                           right: 0,
                           bottom: 0
                       ),
                       child: Row(
                         children: [
                           Container(
                             width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16),
                             height:ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16),
                             margin: EdgeInsets.only(
                                 top: 0,
                                 left: 0,
                                 right: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8),
                                 bottom: 0),
                             child: Image.asset(AppIcon.img_evento_megusta_1),
                           ),
                               (){
                             String megusta = "me gusta";
                             if((widget.eventoUi?.cantLike??0)!=0){
                               megusta =   "${widget.eventoUi?.cantLike??0} me gusta";
                             }else if((widget.eventoUi?.cantLike??0)>1000){
                               megusta += "1k me gusta" ;
                             }
                             return Text(megusta, style: TextStyle(
                                 fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 11),
                                 fontFamily: AppTheme.fontTTNorms,
                                 color: AppTheme.darkText
                             ));
                           }(),
                           Expanded(
                             child: Container(),
                           ),
                           Text(widget.eventoUi?.nombreEntidad??'',
                             maxLines: 1,
                             overflow: TextOverflow.ellipsis,
                             style: TextStyle( fontSize: 11, fontFamily: AppTheme.fontTTNorms, color: AppTheme.darkText,fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),),
                           Padding(padding: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16)))
                         ],
                       ),
                     ),

                     listarAdjuntosEventos(widget.eventoUi, widget.eventoUi?.eventoAdjuntoUiDownloadList),
                     Container(
                       margin:  EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8), bottom: 0),
                       color: HexColor("#33979797"),
                       height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 1),
                     ),
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Material(
                           color: Colors.transparent,
                           child: Container(
                             padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                             height: 36,
                             child: (){
                               if(widget.eventoUi?.tipoEventoUi?.tipo != EventoIconoEnumUI.AGENDA){
                                 return InkWell(
                                   focusColor: Colors.transparent,
                                   highlightColor: Colors.transparent,
                                   hoverColor: Colors.transparent,
                                   borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                   splashColor: AppTheme.nearlyDarkBlue.withOpacity(0.2),
                                   onTap: () => widget.onClickMegusta?.call(widget.eventoUi),
                                   child: Row(
                                     children: [
                                       Container(
                                         width:18,
                                         height:18,
                                         margin: const EdgeInsets.only(top: 0, left: 16, right: 8, bottom: 0),
                                         child: Image.asset(AppIcon.img_evento_megusta),
                                       ),
                                       Text("Me gusta", style: TextStyle( fontSize: 12, fontFamily: AppTheme.fontTTNorms, color: AppTheme.lightText, fontWeight: FontWeight.w500),),
                                       Padding(padding: EdgeInsets.only(left: 16))
                                     ],
                                   ),
                                 );
                               }else{
                                 return InkWell(
                                   focusColor: Colors.transparent,
                                   highlightColor: Colors.transparent,
                                   hoverColor: Colors.transparent,
                                   borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                   splashColor: AppTheme.nearlyDarkBlue.withOpacity(0.2),
                                   onTap: (){
                                     widget.onClickPublicar?.call(widget.eventoUi);
                                   },
                                   child: Row(
                                     children: [
                                       Container(
                                         width:18,
                                         height:18,
                                         margin:  EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
                                         child: Icon(Ionicons.globe_outline, size: 20, color: AppTheme.blueGreyDarken1,),
                                       ),
                                       Padding(
                                           padding: EdgeInsets.only(top: 2),
                                            child: Text(widget.eventoUi?.publicado??false?"Publicado":"Sin publicar", style: TextStyle( fontSize: 12,   fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w500,color: AppTheme.lightText),),
                                       ),
                                       Padding(padding: EdgeInsets.only(left: 8))
                                     ],
                                   ),
                                 );
                               }
                             }(),
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
                                 if(widget.eventoUi?.fotoEntidad!=null && (widget.eventoUi?.fotoEntidad??"").isNotEmpty){
                                   _shareImageFromUrl(widget.eventoUi);
                                 }else{
                                   _shareText(widget.eventoUi);
                                 }
                               },
                               child:
                               Container(
                                 padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 0),
                                 height: 36,
                                 child: Row(
                                   children: [
                                     Container(
                                       width:18,
                                       height:18,
                                       margin: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
                                       child: Image.asset(AppIcon.img_evento_compartir),
                                     ),
                                     Text("Compartir", style: TextStyle( fontSize: 12,   fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w500,color: AppTheme.lightText),),
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
             ],
           ),
         ),
       )
     ],
   );
  }

  Widget? listarPreviewEventos(EventoUi? eventoUi, List<EventoAdjuntoUi>? eventoAdjuntoList){

    if((eventoAdjuntoList?.length??0) > 4){
      return Column(
        children: [
          Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: previewEventos(eventoUi, eventoAdjuntoList?[0])
                  ),
                  Container(
                    color: AppTheme.white,
                    width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 2),
                  ),
                  Expanded(
                      child: previewEventos(eventoUi, eventoAdjuntoList?[1])
                  )
                ],
              )
          ),
          Container(
            color: AppTheme.white,
            height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 2),
          ),
          Expanded(
              child: Row(
                children: [
                  Expanded(
                    child:  previewEventos(eventoUi, eventoAdjuntoList?[2]),
                  ),
                  Container(
                    color: AppTheme.white,
                    width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 2),
                  ),
                  Expanded(
                      child: Container(
                          child: Stack(
                            children: [
                              previewEventos(eventoUi, eventoAdjuntoList?[3]),
                              InkWell(
                                onTap: () async{
//
                                  widget.onClickPreviewComplejo?.call(eventoUi, eventoAdjuntoList?[3]);
                                },
                                child:  Container(
                                  color: HexColor("#80000000"),
                                  child: Center(
                                    child: Text("+${((eventoAdjuntoList?.length??0)-4)}",
                                      style: TextStyle(
                                        color: AppTheme.white,
                                        fontSize: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 48),
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
                              )
                            ],
                          )
                      )
                  )
                ],
              )
          )
        ],
      );
    }else if(eventoAdjuntoList?.length == 4){
      return Column(
        children: [
          Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: previewEventos(eventoUi, eventoAdjuntoList?[0])
                  ),
                  Container(
                    color: AppTheme.white,
                    width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 2),
                  ),
                  Expanded(
                      child: previewEventos(eventoUi, eventoAdjuntoList?[1])
                  )
                ],
              )
          ),
          Container(
            color: AppTheme.white,
            height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 2),
          ),
          Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: previewEventos(eventoUi, eventoAdjuntoList?[2])
                  ),
                  Container(
                    color: AppTheme.white,
                    width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 2),
                  ),
                  Expanded(
                      child: previewEventos(eventoUi, eventoAdjuntoList?[3])
                  )
                ],
              )
          )
        ],
      );
    }else if(eventoAdjuntoList?.length == 3){
      return Column(
        children: [
          Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: previewEventos(eventoUi, eventoAdjuntoList?[0])
                  ),
                  Container(
                    color: AppTheme.white,
                    width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 2),
                  ),
                  Expanded(
                      child: previewEventos(eventoUi, eventoAdjuntoList?[1])
                  )
                ],
              )
          ),
          Container(
            color: AppTheme.white,
            height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 2),
          ),
          Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: previewEventos(eventoUi, eventoAdjuntoList?[2])
                  ),
                ],
              )
          )
        ],
      );
    }else if(eventoAdjuntoList?.length == 2){
      return Column(
        children: [
          Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: previewEventos(eventoUi, eventoAdjuntoList?[0])
                  ),
                  Container(
                    color: AppTheme.white,
                    width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 2),
                  ),
                  Expanded(
                      child: previewEventos(eventoUi, eventoAdjuntoList?[1])
                  )
                ],
              )
          ),
        ],
      );
    }else if(eventoAdjuntoList?.length == 1){
      return  Stack(
        children: [
          previewEventos(eventoUi, eventoAdjuntoList?[0])
        ],
      );
    }


  }

  Widget listarAdjuntosEventos(EventoUi? eventoUi, List<EventoAdjuntoUi>? eventoAdjuntoList){

    return eventoAdjuntoList?.isNotEmpty??false?Column(
      children: [
        Container(
          margin:  EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8), bottom: 0),
          color: HexColor("#33979797"),
          height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 1),
        ),
        Container(
          height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 40),
          margin: EdgeInsets.only(
              top: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8),
              left: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16),
              right: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 16)
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 4)),
                topRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 4)),
                bottomLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8)),
                bottomRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8)),
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
                          await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(eventoAdjuntoUi?.driveId), webview: false);
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
                                  borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 4)),
                                  child: Image.asset(
                                    getImagen(eventoAdjuntoUi?.tipoRecursosUi),
                                    height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 25),
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
                                    left: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8),
                                    right: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8)
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
                            //controller.onClickMoreEventoAdjuntoDowload(eventoUi);
                            widget.onClickMoreEventoAdjuntoDowload?.call(eventoUi);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 4)),
                                  bottomRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8))
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
        )
      ],
    ):
    Container();
  }

  Future<void> _shareImageFromUrl(EventoUi? eventoUi) async {
    try {
      /*var request = await HttpClient().getUrl(Uri.parse(
          'https://shop.esys.eu/media/image/6f/8f/af/amlog_transport-berwachung.jpg'));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);*/

      /*var file = await DefaultCacheManager().getSingleFile(eventoUi.foto??"");
      List<int> bytes = await file.readAsBytes();
      Uint8List ubytes = Uint8List.fromList(bytes);*/

      //await Share.file(eventoUi.titulo, 'amlog.jpg', ubytes, 'image/jpg', text: eventoUi.titulo +"\n"+eventoUi.descripcion,);
    } catch (e) {}
  }

  Future<void> _shareText(EventoUi? eventoUi) async {
    try {
      //Share.text(eventoUi.titulo,
      //    eventoUi.titulo +"\n"+eventoUi.descripcion, 'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }

  Widget previewEventos(EventoUi? eventoUi, EventoAdjuntoUi? eventoAdjuntoUi) {
    double _sigmaX = 6.0; // from 0-10
    double _sigmaY = 6.0; // from 0-10
    double _opacity = 0.1; // from 0-1.0

    return InkWell(
      onTap: () async{

        widget.onClickPreview?.call(eventoUi, eventoAdjuntoUi);
      },
      child: Container(
          color: HexColor("#DFDFDF"),
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
                errorWidget: Icon(Icons.warning_amber_rounded, color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 105),),
              ),
              if(eventoAdjuntoUi?.tipoRecursosUi == TipoRecursosUi.TIPO_VIDEO ||
                  eventoAdjuntoUi?.tipoRecursosUi == TipoRecursosUi.TIPO_VINCULO_YOUTUBE)
                Center(
                  child: Container(
                    height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 40),
                    width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 70),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8))),
                        color: AppTheme.redAccent4.withOpacity(0.7)
                    ),
                    child: Center(
                      child: Icon(Icons.play_arrow, size: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 30), color: AppTheme.white.withOpacity(0.8),),
                    ),
                  ),
                )
            ],
          )
      ),
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

  Widget getCabeceraEvento(EventoUi? eventoUi) {
    Color? color = null;
    String? imagepath = null;

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
      height: 45,
      //color: AppTheme.black.withOpacity(0.5),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: color,
            ),
            height: 18,
            width: 18,
            child: Center(
              child: SvgPicture.asset(
                imagepath,
                semanticsLabel:"Eventos",
                color: AppTheme.white,
                width: 10,
                height: 10,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 8),
              child: Text(eventoUi?.tipoEventoUi?.nombre??"",
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: AppTheme.fontTTNorms,
                    fontWeight: FontWeight.w700,
                    color: HexColor("#346081")
                ),
              ),
            ),
          ),
          if((eventoUi?.nombreFecha??"").isNotEmpty)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: color,
              ),
              height: 20,
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Center(
                child: Text("${eventoUi?.tipoEventoUi?.nombre??""} ${eventoUi?.nombreFecha??""}",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppTheme.fontTTNorms,
                      color: AppTheme.white
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(8),
          )
        ],
      ),
    );
  }

}

typedef OnClickMoreEventoAdjuntoDowload = void Function(EventoUi? eventoUi );
typedef OnClickPreview = void Function(EventoUi? eventoUi, EventoAdjuntoUi? eventoAdjuntoUi);
typedef OnClickPreviewComplejo = void Function(EventoUi? eventoUi, EventoAdjuntoUi? eventoAdjuntoUi);
typedef OnClickEditar = void Function(EventoUi? eventoUi);
typedef OnClickEliminar = void Function(EventoUi? eventoUi);
typedef OnClickPublicar = void Function(EventoUi? eventoUi);
typedef OnClickMegusta = void Function(EventoUi? eventoUi);