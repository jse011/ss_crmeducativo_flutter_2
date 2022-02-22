import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/sesion_controller.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/multimedia/tarea_multimedia_view.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_url_launcher.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';

import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/actividad_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/actividad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/instrumento_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_drive_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_youtube_tools.dart';

class TabActividades extends StatefulWidget{
  @override
  _TabActividadesSatate createState() => _TabActividadesSatate();

}
class _TabActividadesSatate extends State<TabActividades>{
  Function()? statetDialogActividad;

  @override
  Widget build(BuildContext context) {
    SesionController controller =
    FlutterCleanArchitecture.getController<SesionController>(context, listen: false);
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(
              top: 16,
              left: 24,
              right: 24,
            bottom: 100
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          left: 32,
                          right: 16
                      ),
                      child: Text("Sesión ${controller.sesionUi.nroSesion??""}: ${controller.sesionUi.titulo??""}",
                          style: TextStyle(
                            fontFamily: AppTheme.fontTTNorms,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: 0.4,
                            color: HexColor(controller.cursosUi.color1),
                          )),

                    ),
                    Container(
                      height: 2,
                      color: HexColor(controller.cursosUi.color1),
                    ),
                    ListView.builder(
                        padding: EdgeInsets.only(top: 0, bottom: 0),
                        itemCount: controller.actividadUiList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index){
                          ActividadUi actividadUi = controller.actividadUiList[index];
                          return  Container(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: (){
                                    controller.onClickActividad(actividadUi);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 8, left: 24, top: 8, bottom: 8),
                                          decoration: BoxDecoration(
                                              color: HexColor(controller.cursosUi.color1),
                                              shape: BoxShape.circle
                                          ),
                                          width: 40,
                                          height: 40,
                                          child: Padding(padding: EdgeInsets.all(8),
                                            child: SvgPicture.asset(
                                                    (){
                                                  switch(actividadUi.tipo){
                                                    case ActividadTipo.APRENDIZAJE:
                                                      return AppIcon.ic_tipo_actividad_aprendizaje;
                                                    case ActividadTipo.CONECTA:
                                                      return AppIcon.ic_tipo_actividad_conecta;
                                                    case ActividadTipo.TEORIA:
                                                      return AppIcon.ic_tipo_actividad_teoria;
                                                    case ActividadTipo.PRACTICA:
                                                      return AppIcon.ic_tipo_actividad_practica;
                                                    default:
                                                      return AppIcon.ic_tipo_actividad_conecta;
                                                  }
                                                }()
                                            ),
                                          ),
                                        ),
                                        Padding(padding: EdgeInsets.only(left: 8)),
                                        Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${actividadUi.actividad??""}",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontTTNorms,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 12,
                                                      letterSpacing: 0.4,
                                                      color: HexColor(controller.cursosUi.color1),
                                                    )),
                                                Padding(padding: EdgeInsets.all(0),),
                                                Text("${actividadUi.secuencia}",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      letterSpacing: 0.4,
                                                      fontWeight: FontWeight.w500,
                                                      fontFamily: AppTheme.fontTTNorms,
                                                      color: AppTheme.darkerText,
                                                    ))
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actividadUi.toogle??false?
                                Column(
                                  children: [
                                    Container(
                                      height: 1,
                                      color: AppTheme.colorLine,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: 16,
                                          left: 32,
                                          right: 24,
                                          bottom: 0
                                      ),
                                      child: Text("${actividadUi.descripcion}",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          color: AppTheme.darkerText,
                                          fontFamily: AppTheme.fontTTNorms,
                                          height: 1.5,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                        padding: EdgeInsets.only(top: 8, bottom: 0),
                                        itemCount: actividadUi.subActividades?.length??0,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, subindex){
                                          ActividadUi subActividadUi = actividadUi.subActividades![subindex];
                                          return  Container(
                                            padding: EdgeInsets.only(
                                                top: 8,
                                                left: 32,
                                                right: 24,
                                                bottom: 0
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${index+1}.${subindex+1}  ",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: AppTheme.darkerText,
                                                        fontFamily: AppTheme.fontTTNorms,
                                                        height: 1.5,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Expanded(child: Text("${subActividadUi.descripcion}",
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: AppTheme.darkerText,
                                                        fontFamily: AppTheme.fontTTNorms,
                                                        height: 1.5,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ))
                                                  ],
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    left: 24
                                                  ),
                                                  child: getListaRecursos(subActividadUi.recursos, controller),
                                                ),
                                                subActividadUi.instrumentoEvaluacionUi!=null?
                                                 Container(
                                                   margin: EdgeInsets.only(
                                                       left: 24,
                                                      bottom: 8
                                                   ),
                                                   child: Column(
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: [
                                                       Padding(padding: EdgeInsets.only(top: 16)),
                                                       Text("Evaluación de la Sub-Actividad",
                                                         style: TextStyle(
                                                           fontSize: 11.0,
                                                           color: AppTheme.darkerText,
                                                           fontFamily: AppTheme.fontTTNorms,
                                                           fontWeight: FontWeight.w400,
                                                           fontStyle: FontStyle.italic
                                                         ),
                                                       ),
                                                       Padding(padding: EdgeInsets.only(top: 4)),
                                                       getItemInstumento(subActividadUi.instrumentoEvaluacionUi, controller)
                                                     ],
                                                   ),
                                                 ):Container()
                                              ],
                                            ),
                                          );
                                        }
                                    ),
                                    getListaRecursos(actividadUi.recursos, controller),
                                    Padding(padding: EdgeInsets.only(bottom: 32)),
                                  ],
                                ):Container(),
                                controller.actividadUiList.length>index+1 || controller.instrumentoEvaluacionUiList.isNotEmpty?
                                Container(
                                  height: 1,
                                  color: AppTheme.colorLine,
                                ):Container(),
                              ],
                            ),
                          );
                        }
                    ),
                    controller.instrumentoEvaluacionUiList.isNotEmpty?
                    Container(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.onClickContenedorInstrumentos();
                            },
                            child:  Container(
                              padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 8, left: 16, top: 8, bottom: 8),
                                    decoration: BoxDecoration(
                                        color: HexColor(controller.cursosUi.color1),
                                        shape: BoxShape.circle
                                    ),
                                    width: 40,
                                    height: 40,
                                    child: Padding(padding: EdgeInsets.all(8),
                                      child: SvgPicture.asset(AppIcon.ic_tipo_actividad_instrumento),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 8)),
                                  Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Instrumentos de Evaluación".toUpperCase(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                                letterSpacing: 0.4,
                                                color: HexColor(controller.cursosUi.color1),
                                              )),
                                          Padding(padding: EdgeInsets.all(0),),
                                          Text("Evaluación",
                                              style: TextStyle(
                                                fontSize: 11,
                                                letterSpacing: 0.4,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: AppTheme.fontTTNorms,
                                                color: AppTheme.darkerText,
                                              ))
                                        ],
                                      )
                                  ),
                                ],
                              ),
                            ),
                          ),
                          controller.contenedorInstrumentos?
                          Column(
                            children: [
                              Container(
                                height: 1,
                                color: AppTheme.colorLine,
                              ),
                              ListView.builder(
                                  padding: EdgeInsets.only(top: 0, bottom: 0),
                                  itemCount: controller.instrumentoEvaluacionUiList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index){
                                    InstrumentoEvaluacionUi instrumentoEvaluacionUi = controller.instrumentoEvaluacionUiList[index];
                                    return  Container(
                                      padding: EdgeInsets.only(
                                          top: 16,
                                          left: 32,
                                          right: 24,
                                          bottom: 0
                                      ),
                                      child: getItemInstumento(instrumentoEvaluacionUi, controller),
                                    );
                                  }
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 24)),
                            ],
                          ):Container()
                        ],
                      ),
                    )
                   :Container()
                  ],
                ),
              ),
            ],
          ),
        ),
        if(controller.progressActividad)
          Padding(padding: EdgeInsets.only(top: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16)
              ),
              child: ArsProgressWidget(
                blur: 2,
                backgroundColor: Color(0x33000000),
                animationDuration: Duration(milliseconds: 500),
              ),
            ),
          ),
      ],
    );;
  }

  Widget getListaRecursos(List<ActividadRecursoUi>? recursosUiList, SesionController controller){
    return ListView.builder(
        padding: EdgeInsets.only(top: 0, bottom: 0),
        itemCount: recursosUiList?.length??0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
          ActividadRecursoUi actividadRecursoUi = recursosUiList![index];

          return InkWell(
            onTap: () async {

              switch(actividadRecursoUi.tipoRecurso){
                case TipoRecursosUi.TIPO_DOCUMENTO:
                case TipoRecursosUi.TIPO_IMAGEN:
                case TipoRecursosUi.TIPO_AUDIO:
                case TipoRecursosUi.TIPO_HOJA_CALCULO:
                case TipoRecursosUi.TIPO_DIAPOSITIVA:
                case TipoRecursosUi.TIPO_PDF:
                  await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(actividadRecursoUi.driveId), webview: false);
                  break;
                case TipoRecursosUi.TIPO_VINCULO:
                  await AppUrlLauncher.openLink(actividadRecursoUi.descripcion, webview: false);
                  break;
                case TipoRecursosUi.TIPO_ENCUESTA:
                  await AppUrlLauncher.openLink(actividadRecursoUi.descripcion, webview: false);
                  break;
                case TipoRecursosUi.TIPO_VINCULO_DRIVE:
                //await AppUrlLauncher.openLink(tareaRecursoUi.url, webview: false);
                  await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(actividadRecursoUi.driveId), webview: false);
                  break;
                case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
                  print("youtube: ${actividadRecursoUi.descripcion}");
                  TareaMultimediaView.showDialog(context, YouTubeUrlParser.getYoutubeVideoId(actividadRecursoUi.descripcion), TareaMultimediaTipoArchivo.YOUTUBE);
                  break;
                case TipoRecursosUi.TIPO_RECURSO:
                //await AppUrlLauncher.openLink(tareaRecursoUi.url, webview: false);

                  break;
                default:
                  await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(actividadRecursoUi.driveId), webview: false);
                  break;
              }


            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), // use instead of BorderRadius.all(Radius.circular(20))
                border:  Border.all(
                    width: 1,
                    color: AppTheme.colorLine
                ),
                color: AppTheme.greyLighten2,
              ),
              margin: EdgeInsets.only(bottom: 0, top: 8),
              width: 450,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        child: Center(
                          child: Image.asset(getImagen(actividadRecursoUi.tipoRecurso),
                            height: 30.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: AppTheme.white,
                          padding: EdgeInsets.only(left:16, top: 8, bottom: 8, right: 8),
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${actividadRecursoUi.titulo??""}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: AppTheme.greyDarken3,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppTheme.fontTTNorms
                                )
                              ),
                              Padding(padding: EdgeInsets.all(2)),
                              Text("${actividadRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO_YOUTUBE ||
                                  actividadRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO_DRIVE ||
                                  actividadRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO?
                                  actividadRecursoUi.descripcion:getDescripcion(actividadRecursoUi.tipoRecurso)}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: DomainTools.esValidaUrl(actividadRecursoUi.descripcion)?AppTheme.blue:null,
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontSize: 11
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  Widget getItemInstumento(InstrumentoEvaluacionUi? instrumentoEvaluacionUi, SesionController controller){
    return  Container(
      decoration: BoxDecoration(
          color: AppTheme.greyLighten4,
          borderRadius: BorderRadius.all(Radius.circular(4))
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.all(Radius.circular(2))
            ),
            child: Icon(Icons.school, color: HexColor(controller.cursosUi.color1),),
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${instrumentoEvaluacionUi?.nombre??""}",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: HexColor(controller.cursosUi.color1),
                      fontFamily: AppTheme.fontTTNorms,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(3)),
                  Text("${(instrumentoEvaluacionUi?.cantidadPreguntas??0)==0?"":instrumentoEvaluacionUi?.cantidadPreguntas==1?"1 pregunta":"${instrumentoEvaluacionUi?.cantidadPreguntas} preguntas"}",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: AppTheme.darkerText,
                      fontFamily: AppTheme.fontTTNorms,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )
          )
        ],
      ),
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
      case TipoRecursosUi.TIPO_ENCUESTA:
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
      case TipoRecursosUi.TIPO_ENCUESTA:
        return "Recurso";
    }
  }

  void showActivdadDocente(BuildContext context) {
    SesionController controller =
    FlutterCleanArchitecture.getController<SesionController>(context, listen: false);

    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              statetDialogActividad = (){
                setState((){});
              };
              controller.addListener(statetDialogActividad!);
              bool isLandscape = context.isLandscape;
              return Container(
                height: MediaQuery.of(context).size.height * (isLandscape?1:0.7),
                child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: new BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: Container(
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(this.context).padding.top,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                  top: 16 - 8.0,
                                  bottom: 12 - 8.0),
                              child:   Stack(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(top: 0, bottom: 8, left: 8, right: 32),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 8, left: 16, top: 0, bottom: 8),
                                          decoration: BoxDecoration(
                                              color: HexColor(controller.cursosUi.color1).withOpacity(1),
                                              borderRadius: BorderRadius.all(Radius.circular(16))
                                          ),
                                          width: 50,
                                          height: 50,
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: SvgPicture.asset(AppIcon.ic_tipo_actividad_conecta),
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 12, top: 8),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("CONECTA TU MENTE",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontTTNorms,
                                                      fontWeight: FontWeight.w800,
                                                      fontSize: 14,
                                                      letterSpacing: 0.4,
                                                      color: AppTheme.darkerText,
                                                    )),
                                                Padding(padding: EdgeInsets.all(4),),
                                                Text("Inicio - 10 min.",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      letterSpacing: 0.4,
                                                      color: AppTheme.darkerText,
                                                    ))
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 10,
                                    child: ClipOval(
                                      child: Material(
                                        color: AppTheme.colorPrimary.withOpacity(0.1), // button color
                                        child: InkWell(
                                          splashColor: AppTheme.colorPrimary, // inkwell color
                                          child: SizedBox(width: 43 + 6, height: 43 + 6,
                                            child: Icon(Ionicons.close, size: 24 + 6,color: AppTheme.colorPrimary, ),
                                          ),
                                          onTap: () {

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
                                      padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
                                      sliver: SliverList(
                                          delegate: SliverChildListDelegate([
                                            Text("Bienvenido apreciado estudiante a la PLATAFORMA EDUCAR; iniciaremos conectándonos primero con nuestro padre celestial y meditando en las enseñanzas bíblicas. ",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  height: 1.4
                                              ),
                                            ),
                                          ])
                                      ),
                                    ),
                                    SliverPadding(
                                      padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
                                      sliver: SliverList(
                                          delegate: SliverChildListDelegate([
                                            Stack(
                                              children: [
                                                Positioned(
                                                  child:  Text("1.1",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          height: 1.4,
                                                          fontWeight: FontWeight.bold
                                                      )
                                                  ),
                                                ),
                                                Positioned(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(left: 40),
                                                      child: Text("GUÍA AUTÓNOMA: Te invito a revisar la:  que es la parte TEÓRICA que como maestro te daré para esta clase virtual. Revisa los conceptos y ejemplos que te daré en la video conferencia, que han sido especialmente diseñadas para apoyar tu aprendizaje. Tienes que estar muy atento y listo para responder las preguntas que haré en el chat virtual de la de la PLATAFORMA EDUCAR. Te ánimo a comunicar tus dudas e inquietudes.    ",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            height: 1.4
                                                        ),),
                                                    )
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 24),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    child:  Text("1.2",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            height: 1.4,
                                                            fontWeight: FontWeight.bold
                                                        )
                                                    ),
                                                  ),
                                                  Positioned(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(left: 40),
                                                        child: Text("PRACTICA DIRIGIDA: Descarga la ficha de trabajo, si es posible imprime:  y escribe la solución en la Ficha de acuerdo a lo que se indique en el desarrollo de la clase y de la explicación en la videoconferencia que la puedes volver a ver si deseas en la grabación.      ",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              height: 1.4
                                                          ),),
                                                      )
                                                  )
                                                ],
                                              ),
                                            )
                                          ])
                                      ),
                                    ),
                                    SliverPadding(
                                      padding: EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 16),
                                      sliver: SliverList(
                                          delegate: SliverChildListDelegate([
                                            Padding(
                                              padding: EdgeInsets.only(top: 0),
                                              child: Row(
                                                children: [
                                                  Padding(padding: EdgeInsets.all(4),),
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      primary: Colors.blue,
                                                    ),
                                                    onPressed: () { },
                                                    child: Text('Atras'),
                                                  ),
                                                  Expanded(child: Container())
                                                  ,TextButton(
                                                    style: TextButton.styleFrom(
                                                      primary: Colors.blue,
                                                    ),
                                                    onPressed: () { },
                                                    child: Text('Siguiente'),
                                                  )
                                                ],
                                              ),
                                            )
                                          ])
                                      ),
                                    ),
                                  ]
                              ),
                            )
                          ],
                        ),
                        if(true)
                          Center(
                            child: CircularProgressIndicator(),
                          )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        })
        .then((value) => {
      if(statetDialogActividad!=null)controller.removeListener(statetDialogActividad!), statetDialogActividad = null
    });
  }
}