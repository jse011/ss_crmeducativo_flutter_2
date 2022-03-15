import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/sesion_controller.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/multimedia/tarea_multimedia_view.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_url_launcher.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_utils.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/read_more_text.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/desempenio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/icd_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_drive_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_youtube_tools.dart';

class TabAprendizaje extends StatefulWidget{
  @override
  _TabAprendizajeState createState() => _TabAprendizajeState();

}

class _TabAprendizajeState extends State<TabAprendizaje>{

  @override
  Widget build(BuildContext context) {
    SesionController controller =
    FlutterCleanArchitecture.getController<SesionController>(context, listen: false);
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(left: 24, right: 24),
              sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      margin: EdgeInsets.only(top: 24, left: 0, right: 0),
                      height: 170,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16))
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppTheme.colorSesion,
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            constraints: BoxConstraints.expand(),

                            child: Stack(
                              children: [
                                Image.asset(AppImagen.fondo_sesion13,
                                  fit: BoxFit.fill,
                                  color: Colors.white.withOpacity(0.4),
                                  colorBlendMode: BlendMode.modulate,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                Image.asset(AppImagen.fondo_sesion12,
                                  fit: BoxFit.cover,
                                  color: Colors.white.withOpacity(0.4),
                                  colorBlendMode: BlendMode.modulate,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                Container(
                                  padding: EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      Expanded(
                                        child: Container(),
                                      ),
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        child: Text("${controller.sesionUi.titulo}",
                                          textAlign: TextAlign.start,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: AppTheme.white.withOpacity(0.9),
                                              fontSize: 22,
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w700
                                          ),
                                        ),
                                      )

                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      margin: EdgeInsets.only(top: 16),
                      padding: EdgeInsets.all(16),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${controller.sesionUi.titulo}",
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppTheme.darkText,
                                  fontFamily: AppTheme.fontTTNorms,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 16)),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: AppTheme.darkText,
                                    fontFamily: AppTheme.fontTTNorms,
                                    height: 1.5
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Propósito: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: controller.sesionUi.proposito??""),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                        padding: EdgeInsets.only(top: 0, bottom: 0),
                        itemCount: controller.competenciaUiList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index){
                          CompetenciaUi competenciaUi = controller.competenciaUiList[index];
                          return Container(
                            decoration: BoxDecoration(
                                color: AppTheme.white,
                                borderRadius: BorderRadius.all(Radius.circular(6))
                            ),
                            margin: EdgeInsets.only(top: 16),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${competenciaUi.tipoCompetencia}",
                                  textAlign: TextAlign.start,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppTheme.darkText,
                                      fontSize:14.0,
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 16)),
                                Container(
                                  color: HexColor("#3AB174"),
                                  padding: EdgeInsets.all(8),
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: AppTheme.white,
                                          fontFamily: AppTheme.fontTTNorms,
                                          height: 1.5,
                                          fontWeight: FontWeight.w400
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(text: 'Competencia:  ', style: new TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: "${competenciaUi.nombre}"),
                                      ],
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                    padding: EdgeInsets.only(top: 0, bottom: 0),
                                    itemCount: competenciaUi.capacidadUiList?.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index){
                                      CapacidadUi capacidadUi = competenciaUi.capacidadUiList![index];
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            color: AppTheme.white,
                                            padding: EdgeInsets.all(8),
                                            child: RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: AppTheme.darkerText,
                                                  height: 1.5,
                                                  fontFamily: AppTheme.fontTTNorms,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(text: 'Capacidad:  ', style: new TextStyle(fontWeight: FontWeight.bold)),
                                                  TextSpan(text: "${capacidadUi.nombre}"),
                                                ],
                                              ),
                                            ),
                                          ),
                                          ListView.builder(
                                              padding: EdgeInsets.only(top: 0, bottom: 0),
                                              itemCount: capacidadUi.desempenioUiList?.length,
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index){
                                                DesempenioUi desempenioUi = capacidadUi.desempenioUiList![index];
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      color: AppTheme.grey,
                                                      height: 0.5,
                                                    ),
                                                    Container(
                                                      color: HexColor("#EDECEC"),
                                                      height: 35,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                child: Text("Desempeño",
                                                                  style: TextStyle(
                                                                      fontSize: 12.0,
                                                                      color: AppTheme.darkerText,
                                                                      fontFamily: AppTheme.fontTTNorms,
                                                                      height: 1.5,
                                                                      fontWeight: FontWeight.w700
                                                                  ),
                                                                ),
                                                              )
                                                          ),
                                                          Expanded(
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                child: Text("Criterios",
                                                                  style: TextStyle(
                                                                      fontSize: 12.0,
                                                                      fontFamily: AppTheme.fontTTNorms,
                                                                      color: AppTheme.darkerText,
                                                                      height: 1.5,
                                                                      fontWeight: FontWeight.w700
                                                                  ),
                                                                ),
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      color: AppTheme.grey,
                                                      height: 0.5,
                                                    ),
                                                    Container(
                                                      color: AppTheme.white,
                                                      padding: EdgeInsets.all(8),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            flex: 5,
                                                            child: Container(
                                                              margin: EdgeInsets.only(right: 8),
                                                              child: ReadMoreText(
                                                                  "${desempenioUi.desempenio}",
                                                                  trimMode: TrimMode.Length,
                                                                  trimCollapsedText: ' Ver más',
                                                                  trimExpandedText: ' Ver menos',
                                                                  style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: AppTheme.darkerText,
                                                                fontFamily: AppTheme.fontTTNorms,
                                                                height: 1.5,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                                  textAlign: TextAlign.justify
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 4,
                                                            child: Container(
                                                              margin: EdgeInsets.only(left: 8),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  ListView.builder(
                                                                      padding: EdgeInsets.only(top: 0, bottom: 0),
                                                                      itemCount: desempenioUi.icdUiList?.length,
                                                                      shrinkWrap: true,
                                                                      physics: NeverScrollableScrollPhysics(),
                                                                      itemBuilder: (context, index){
                                                                        IcdUi icdUi = desempenioUi.icdUiList![index];
                                                                        return Column(
                                                                          children: [
                                                                            Container(
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text("${(index+1).toString().padLeft(2, '0')}. ",
                                                                                    style: TextStyle(
                                                                                      fontSize: 12.0,
                                                                                      color: AppTheme.darkerText,
                                                                                      fontFamily: AppTheme.fontTTNorms,
                                                                                      height: 1.5,
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                      child: Text("${icdUi.titulo?.replaceAll("\n", " ").trim()??""}",
                                                                                        style: TextStyle(
                                                                                          fontSize: 12.0,
                                                                                          fontFamily: AppTheme.fontTTNorms,
                                                                                          color: AppTheme.darkerText,
                                                                                          height: 1.5,
                                                                                          fontWeight: FontWeight.w400,
                                                                                        ),
                                                                                      )
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            ListView.builder(
                                                                                padding: EdgeInsets.only(top: 0, bottom: 0),
                                                                                itemCount: icdUi.temaCriterioUiList?.length,
                                                                                shrinkWrap: true,
                                                                                physics: NeverScrollableScrollPhysics(),
                                                                                itemBuilder: (context, index){
                                                                                  TemaCriterioUi temaCriterioUi = icdUi.temaCriterioUiList![index];
                                                                                  return Column(
                                                                                    children: [
                                                                                      Container(
                                                                                        margin: EdgeInsets.only(left: 20),
                                                                                        child: Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Text("${AppUtils.indexAlfabetico(index)}. ",
                                                                                              style: TextStyle(
                                                                                                fontSize: 12.0,
                                                                                                color: AppTheme.darkerText,
                                                                                                height: 1.5,
                                                                                                fontFamily: AppTheme.fontTTNorms,
                                                                                                fontWeight: FontWeight.w500,
                                                                                              ),
                                                                                            ),
                                                                                            Expanded(
                                                                                                child: Text("${temaCriterioUi.titulo?.replaceAll("\n", " ")??""}",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 12.0,
                                                                                                    color: AppTheme.darkerText,
                                                                                                    height: 1.5,
                                                                                                    fontFamily: AppTheme.fontTTNorms,
                                                                                                    fontWeight: FontWeight.w400,
                                                                                                  ),
                                                                                                )
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      ListView.builder(
                                                                                          padding: EdgeInsets.only(top: 0, bottom: 0),
                                                                                          itemCount: temaCriterioUi.temaCriterioUiList?.length??0,
                                                                                          shrinkWrap: true,
                                                                                          physics: NeverScrollableScrollPhysics(),
                                                                                          itemBuilder: (context, index){
                                                                                            TemaCriterioUi temaCriHijoUi = temaCriterioUi.temaCriterioUiList![index];
                                                                                            return Column(
                                                                                              children: [
                                                                                                Container(
                                                                                                  margin: EdgeInsets.only(left: 30),
                                                                                                  child: Row(
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Text("* ",
                                                                                                        style: TextStyle(
                                                                                                          fontSize: 12.0,
                                                                                                          color: AppTheme.darkerText,
                                                                                                          height: 1.5,
                                                                                                          fontFamily: AppTheme.fontTTNorms,
                                                                                                          fontWeight: FontWeight.w400,
                                                                                                        ),
                                                                                                      ),
                                                                                                      Expanded(
                                                                                                          child: Text("${temaCriHijoUi.titulo?.replaceAll("\n", " ").trim()??""}",
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 12.0,
                                                                                                              color: AppTheme.darkerText,
                                                                                                              height: 1.5,
                                                                                                              fontFamily: AppTheme.fontTTNorms,
                                                                                                              fontWeight: FontWeight.w400,
                                                                                                            ),
                                                                                                          )
                                                                                                      )
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            );
                                                                                          }
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                }
                                                                            ),
                                                                          ],
                                                                        );
                                                                      }
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),

                                                  ],
                                                );
                                              }
                                          ),
                                        ],
                                      );
                                    }
                                ),

                              ],
                            ),
                          );
                        }
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      margin: EdgeInsets.only(top: 16),
                      padding: EdgeInsets.all(16),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Temas de la sesión",
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppTheme.darkText,
                                  fontSize:14.0,
                                  fontFamily: AppTheme.fontTTNorms,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 16)),
                            controller.temaCriterioUiList.isNotEmpty?
                            ListView.builder(
                                padding: EdgeInsets.only(top: 0, bottom: 0),
                                itemCount: controller.temaCriterioUiList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index){
                                  TemaCriterioUi temaCriterioUi = controller.temaCriterioUiList[index];
                                  return Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.add, size: 16,),
                                            Padding(padding: EdgeInsets.all(4)),
                                            Text("${(index+1).toString().padLeft(2, '0')}. ",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: AppTheme.darkerText,
                                                fontFamily: AppTheme.fontTTNorms,
                                                height: 1.5,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Expanded(
                                                child: Text("${temaCriterioUi.titulo?.replaceAll("\n", " ")??""}",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: AppTheme.darkerText,
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    height: 1.5,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                      ListView.builder(
                                          padding: EdgeInsets.only(top: 0, bottom: 8),
                                          itemCount: temaCriterioUi.temaCriterioUiList?.length??0,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index){
                                            TemaCriterioUi temaCriHijoUi = temaCriterioUi.temaCriterioUiList![index];
                                            return Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(left: 30, bottom: 4, top: 2),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("${AppUtils.indexAlfabetico(index)}. ",
                                                        style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: AppTheme.darkerText,
                                                          fontFamily: AppTheme.fontTTNorms,
                                                          height: 1.5,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: Text("${temaCriHijoUi.titulo?.replaceAll("\n", " ").trim()??""}",
                                                            style: TextStyle(
                                                              fontSize: 12.0,
                                                              color: AppTheme.darkerText,
                                                              height: 1.5,
                                                              fontFamily: AppTheme.fontTTNorms,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                      ),
                                    ],
                                  );
                                }
                            ):
                            Container(
                              margin: EdgeInsets.only(top: 16, bottom: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
                                  ),
                                  Padding(padding: EdgeInsets.all(4)),
                                  Center(
                                    child: Text("Sin temas de la sesión${!controller.conexionAprendizaje?", revice su conexión a internet":""}",
                                        style: TextStyle(
                                            color: AppTheme.grey,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 12,
                                            fontFamily: AppTheme.fontTTNorms
                                        )
                                    ),
                                  )
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.all(Radius.circular(6))
                      ),
                      margin: EdgeInsets.only(top: 16),
                      padding: EdgeInsets.all(16),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Recursos didácticos de la sesión",
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppTheme.darkText,
                                  fontSize:14.0,
                                  fontFamily: AppTheme.fontTTNorms,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 8)),
                           controller.sesionRecursoUiList.isNotEmpty?
                            ListView.builder(
                                padding: EdgeInsets.only(top: 0, bottom: 0),
                                itemCount: controller.sesionRecursoUiList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index){
                                  SesionRecursoUi sesionRecursoUi = controller.sesionRecursoUiList[index];
                                  return Container(
                                    child: InkWell(
                                      onTap: () async {

                                        switch(sesionRecursoUi.tipoRecurso){
                                          case TipoRecursosUi.TIPO_DOCUMENTO:
                                          case TipoRecursosUi.TIPO_IMAGEN:
                                          case TipoRecursosUi.TIPO_AUDIO:
                                          case TipoRecursosUi.TIPO_HOJA_CALCULO:
                                          case TipoRecursosUi.TIPO_DIAPOSITIVA:
                                          case TipoRecursosUi.TIPO_PDF:
                                            await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(sesionRecursoUi.driveId), webview: false);
                                            break;
                                          case TipoRecursosUi.TIPO_VINCULO:
                                            await AppUrlLauncher.openLink(sesionRecursoUi.descripcion, webview: false);
                                            break;
                                          case TipoRecursosUi.TIPO_ENCUESTA:
                                            await AppUrlLauncher.openLink(sesionRecursoUi.descripcion, webview: false);
                                            break;
                                          case TipoRecursosUi.TIPO_VINCULO_DRIVE:
                                          //await AppUrlLauncher.openLink(tareaRecursoUi.url, webview: false);
                                            await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(sesionRecursoUi.driveId), webview: false);
                                            break;
                                          case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
                                            print("youtube: ${sesionRecursoUi.descripcion}");
                                            TareaMultimediaView.showDialog(context, YouTubeUrlParser.getYoutubeVideoId(sesionRecursoUi.descripcion), TareaMultimediaTipoArchivo.YOUTUBE);
                                            break;
                                          case TipoRecursosUi.TIPO_RECURSO:
                                          //await AppUrlLauncher.openLink(tareaRecursoUi.url, webview: false);

                                            break;
                                          default:
                                            await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(sesionRecursoUi.driveId), webview: false);
                                            break;
                                        }


                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4), // use instead of BorderRadius.all(Radius.circular(20))
                                          color: AppTheme.greyLighten4,
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
                                                    child: Image.asset(getImagen(sesionRecursoUi.tipoRecurso),
                                                      height: 30.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.only(left:4, top: 8, bottom: 8, right: 8),
                                                    child:  Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        RichText(
                                                            maxLines: 3,
                                                            overflow: TextOverflow.ellipsis,
                                                            text: TextSpan(
                                                                children: [
                                                                  WidgetSpan(
                                                                    child: Container(
                                                                      padding: EdgeInsets.only(
                                                                        top: 2,
                                                                        bottom: 2,
                                                                        left: 4,
                                                                        right: 4
                                                                      ),
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                                                        color: AppTheme.colorAccent
                                                                      ),
                                                                      child: Text("${sesionRecursoUi.tipoRecursoActNombre??""}",
                                                                          style: TextStyle(
                                                                              color: AppTheme.white,
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontFamily: AppTheme.fontTTNorms
                                                                          )
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  TextSpan(text: "  ${sesionRecursoUi.titulo??""}",
                                                                      style: TextStyle(
                                                                          color: AppTheme.greyDarken3,
                                                                          fontSize: 12,
                                                                          fontWeight: FontWeight.w500,
                                                                          fontFamily: AppTheme.fontTTNorms
                                                                      )
                                                                  )
                                                                ]
                                                            )
                                                        ),
                                                        Padding(padding: EdgeInsets.all(2)),
                                                        Text("${sesionRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO_YOUTUBE ||
                                                            sesionRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO_DRIVE ||
                                                            sesionRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO?
                                                        sesionRecursoUi.descripcion:getDescripcion(sesionRecursoUi.tipoRecurso)}",
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                color: DomainTools.esValidaUrl(sesionRecursoUi.descripcion)?AppTheme.blue:null,
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
                                    ),
                                  );
                                }
                            ):
                            Container(
                              margin: EdgeInsets.only(top: 16, bottom: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
                                  ),
                                  Padding(padding: EdgeInsets.all(4)),
                                  Center(
                                    child: Text("Sesión sin recursos de Aprendizaje${!controller.conexionAprendizaje?", revice su conexión a internet":""}",
                                        style: TextStyle(
                                            color: AppTheme.grey,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 12,
                                            fontFamily: AppTheme.fontTTNorms
                                        )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 200),)
                  ])
              ),
            ),
          ],
        ),
        if(controller.progressAprendizaje)
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

}