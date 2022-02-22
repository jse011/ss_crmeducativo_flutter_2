import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fancy_shimer_image/fancy_shimmer_image.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_url_launcher.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/item_evento_view.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_adjunto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_drive_tools.dart';

import 'agenda_controller.dart';

class AgendaView extends View{
  CursosUi? cursosUi;

  AgendaView(this.cursosUi);

  @override
  _AgendaViewState createState() => _AgendaViewState(this.cursosUi);

}

class _AgendaViewState extends ViewState<AgendaView, AgendaController> with TickerProviderStateMixin{
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  
  _AgendaViewState(CursosUi? cursosUi) : super(AgendaController(cursosUi, MoorAgendaEventoRepository(), MoorConfiguracionRepository(), DeviceHttpDatosRepositorio()));

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
  Widget get view => ControlledWidgetBuilder<AgendaController>(
    builder: (context, controller) {
      return Scaffold(
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
      );
    },
  );

  Widget getAppBarUI() {
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
                    left: 8,
                    right: 8,
                    top: 16 - 8.0 * topBarOpacity,
                    bottom: 12 - 8.0 * topBarOpacity),
                child: ControlledWidgetBuilder<AgendaController>(
                  builder: (context, controller) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                            child:  IconButton(
                              icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                              onPressed: () {
                                Navigator.of(this.context).pop();
                              },
                            )
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppIcon.ic_curso_agenda, height: 35 +  6 - 10 * topBarOpacity, width: 35 +  6 - 10 * topBarOpacity,),
                              Padding(
                                padding: EdgeInsets.only(left: 12, top: 8),
                                child: Text(
                                  'Agenda',
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
        )
      ],
    );
  }

  Widget getMainTab() {
    return ControlledWidgetBuilder<AgendaController>(
        builder: (context, controller) {
          return  Container(
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  0,
              left: 0,//24,
              right: 0,//48
            ),
            child: Stack(
              children: [
                if(controller.eventoUiList.isEmpty)
                  Column(
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
                  ),
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
                    SliverList(
                        delegate: SliverChildListDelegate([
                          controller.cursosUi!=null?
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text((controller.cursosUi?.nombreCurso??""),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                                color: AppTheme.darkText,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: AppTheme.fontTTNorms
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 4))
                                          ),
                                          Text("${controller.cursosUi?.gradoSeccion??""}",
                                              style: TextStyle(
                                                  fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 16),
                                                  color: AppTheme.darkText,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: AppTheme.fontTTNorms
                                              )
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ):Container(
                              padding: EdgeInsets.only(
                                top: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 24),
                              )
                          ),
                        ])
                    ),
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
                                      dynamic respuesta = await AppRouter.createCrearEventoRouter(context, null, controller.cursosUi);
                                      if(respuesta is int) controller.cambiosEvento();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8)),
                                      decoration: BoxDecoration(
                                        color: (controller.cursosUi!=null?HexColor(controller.cursosUi?.color2):Color(0XFF71bb74)),
                                        borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 8)), // use instead of BorderRadius.all(Radius.circular(20))
                                        boxShadow: [
                                          BoxShadow(
                                              color: (controller.cursosUi!=null?HexColor(controller.cursosUi?.color2):Color(0XFF71bb74)).withOpacity(0.4),
                                              offset:  Offset(0,3),
                                              blurRadius: 6.0,
                                              spreadRadius: 0
                                          ),
                                        ],
                                      ),
                                      width: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 410),
                                      height: ColumnCountProvider.aspectRatioForWidthButtonPortalAgenda(context, 80),
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
                              EventoUi eventoUi = controller.eventoUiList[index];

                              return ItemEventoView(eventoUi,
                                color: controller.cursosUi!=null?HexColor(controller.cursosUi?.color1):Color(0XFF71bb74),
                                tipoEditar: true,
                                onClickMoreEventoAdjuntoDowload:(eventoUi) {
                                  controller.onClickMoreEventoAdjuntoDowload(eventoUi);
                                },
                                onClickPreview: (eventoUi, eventoAdjuntoUi) async{
                                  if((eventoUi?.eventoAdjuntoUiPreviewList??[]).isNotEmpty&&(eventoUi?.eventoAdjuntoUiPreviewList??[]).length>1){
                                    dynamic response = await AppRouter.createEventoInfoComplejoRouter(context, eventoUi);
                                  }else{
                                    dynamic response = await AppRouter.createEventoInfoSimpleRouter(context, eventoUi, eventoAdjuntoUi);
                                  }
                                },
                                onClickPreviewComplejo: (eventoUi, eventoAdjuntoUi) async {
                                  dynamic response = await AppRouter.createEventoInfoComplejoRouter(context, eventoUi);
                                },
                                onClickEditar: (eventoUi) async {
                                  dynamic respuesta = await AppRouter.createCrearEventoRouter(context, eventoUi, controller.cursosUi);
                                  if(respuesta is int) controller.cambiosEvento();
                                },
                                onClickEliminar: (eventoUi) async{
                                  controller.onClickElimarEvento(eventoUi);
                                },
                                onClickPublicar: (eventoUi) async{
                                  bool? result = await controller.onClickPublicar(eventoUi);

                                },
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
                )
              ],
            ),
          );
        });
  }

  Widget dialogAdjuntoDownload(AgendaController controller) {
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
                          if(eventoAdjuntoUi.tipoRecursosUi == TipoRecursosUi.TIPO_VINCULO ||
                              eventoAdjuntoUi.tipoRecursosUi == TipoRecursosUi.TIPO_VINCULO_YOUTUBE){
                            await AppUrlLauncher.openLink(eventoAdjuntoUi.titulo, webview: false);
                          }else{
                            await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(eventoAdjuntoUi.driveId), webview: false);
                          }
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

  @override
  void dispose() {
    super.dispose();
  }
}