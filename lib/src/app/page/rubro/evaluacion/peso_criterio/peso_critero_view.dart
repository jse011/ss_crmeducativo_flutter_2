import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_not_expanded_custom.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/peso_criterio/peso_criterio_controller.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/presicion/peso_view.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_porcentaje_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_peso_selected_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';

class PesoCriterioView extends View{
  CapacidadUi? capacidadUi;
  CursosUi? cursosUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;
  PesoCriterioView(this.capacidadUi, this.cursosUi, this.calendarioPeriodoUI);

  @override
  _PesoCriterioViewState createState() => _PesoCriterioViewState(capacidadUi, cursosUi, calendarioPeriodoUI);

}

class _PesoCriterioViewState extends ViewState<PesoCriterioView, PesoCriterioController> with TickerProviderStateMixin{
  ScrollControllers crollControllers = ScrollControllers();

  _PesoCriterioViewState(capacidadUi, cursosUi, calendarioPeriodoUI) : super(PesoCriterioController(capacidadUi, cursosUi, calendarioPeriodoUI, MoorConfiguracionRepository(), MoorRubroRepository(), DeviceHttpDatosRepositorio()));

  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget get view => ControlledWidgetBuilder<PesoCriterioController>(
      builder: (context, controller) {

        return WillPopScope(
            onWillPop: () async {
              bool?  se_a_modicado = await controller.onSave();
              if(se_a_modicado){
                Navigator.of(context).pop(1);//si devuelve un entero se actualiza toda la lista;
                return false;
              }else{
                return true;
              }
            },
            child: Container(
              color: AppTheme.background,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: <Widget>[
                    getMainTab(),
                    getAppBarUI(),
                    if(controller.showDialog)
                      ArsProgressWidget(
                          blur: 2,
                          backgroundColor: Color(0x33000000),
                          animationDuration: Duration(milliseconds: 500)),
                  ],
                ),
              ),
            )
        );
      }
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
                child:   ControlledWidgetBuilder<PesoCriterioController>(
                  builder: (context, controller) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                            child:  IconButton(
                              icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                              onPressed: () async{
                                bool?  se_a_modicado = await controller.onSave();
                                if(se_a_modicado){
                                  Navigator.of(context).pop(1);//si devuelve un entero se actualiza toda la lista;
                                }else{
                                  Navigator.of(context).pop(true);
                                }
                              },
                            )
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 52),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppIcon.ic_curso_evaluacion, height: 32 +  6 - 10 * topBarOpacity , width: 35 +  6 - 10 * topBarOpacity ,),
                              Padding(
                                padding: EdgeInsets.only(left: 8, top: 8),
                                child: Text(
                                  "Capacidad",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontTTNorms,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14 + 6 - 6 * topBarOpacity ,
                                    letterSpacing: 0.8,
                                    color: AppTheme.darkerText,
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
        )
      ],
    );
  }

  Widget getMainTab() {


    return ControlledWidgetBuilder<PesoCriterioController>(
        builder: (context, controller) {

          return Container(
            padding: EdgeInsets.only(
                top: AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top +
                    0,
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                    child: Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: (){

                            List<double> tableTipoNotacolumnWidths = [];

                            for(var column in controller.tableColumns){
                              if(column is String){
                                if(column == "peso_criterio"){
                                  tableTipoNotacolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 75));
                                }else if(column == "estandar"){
                                  tableTipoNotacolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 50));
                                }else if(column == "baja"){
                                  tableTipoNotacolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 50));
                                }else if(column == "alta"){
                                  tableTipoNotacolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 50));
                                }else if(column == "no_usar"){
                                  tableTipoNotacolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 50));
                                }else{
                                  tableTipoNotacolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 70));
                                }
                              }else{
                                tableTipoNotacolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 60));
                              }

                            }

                            double width_pantalla = MediaQuery.of(context).size.width;
                            double padding_left = ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 32);
                            double padding_right = ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 32);
                            double width_table = padding_left + padding_right + ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 190);
                            for(double column_px in tableTipoNotacolumnWidths){
                              width_table += column_px;
                            }
                            double width = 0;
                            if(width_pantalla>width_table){
                              width = width_pantalla;
                            }else{
                              width = width_table;
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    top: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 32),
                                    left: padding_left,
                                    right: padding_right
                                  ),
                                  width: width,
                                  child:  Wrap(
                                    spacing: 10.0,
                                    runSpacing: 15.0,
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.start,
                                    children: <Widget>[
                                      InkWell(
                                        //onTap: ()=> controller.onClicPrecision(),
                                        child: Container(
                                          width: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 110),
                                          padding: EdgeInsets.only(
                                              left: 0 ,
                                              right: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 16),
                                              top: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 8),
                                              bottom: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 8)
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                              color: HexColor(controller.cursosUi.color2)
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Ionicons.help_circle ,
                                                color: AppTheme.white,
                                                size:  ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 16)
                                              ),
                                              Padding(padding: EdgeInsets.all(2),),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text("Ayuda",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: AppTheme.fontTTNorms,
                                                      letterSpacing: 0.5,
                                                      color:AppTheme.white,
                                                      fontSize: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12) ,
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
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(left: padding_left, right: padding_right, top: 24),
                                  width: width - (padding_left + padding_right),
                                  color: HexColor(controller.cursosUi.color3).withOpacity(0.1),
                                  child: Column(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 12),
                                              height: 1.5,
                                              letterSpacing: 0.3,
                                              color: HexColor(controller.cursosUi.color1),
                                            ),
                                            children: [
                                              TextSpan(text: 'MODIFICA EL NIVEL DE COMPLEJIDAD DE LOS CRITERIOS ASOCIADOS A LA CAPACIDAD '),
                                              //TextSpan(text: "${(controller.evaluacionCapacidadUi.personaUi?.nombreCompleto??"").toUpperCase()}"),
                                              TextSpan(text: '"${(controller.capacidadUi.nombre??"").toUpperCase()}"', style: TextStyle(fontWeight: FontWeight.w900)),

                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: padding_left, right: padding_right),
                                  width: width - (padding_left + padding_right),
                                  height: 1,
                                  color: HexColor(controller.cursosUi.color1),
                                ),

                                Container(
                                  width: width,
                                  padding: EdgeInsets.only(
                                      left: padding_left,
                                      top: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 24)
                                  ),
                                  child: showTableTipoNota(controller, tableTipoNotacolumnWidths),
                                ),
                              ],
                            );

                          }(),
                        ),
                    )
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(padding: EdgeInsets.only(bottom: 80))
                    ])
                ),
              ],
            ),
          );
        });
  }

  Widget showTableTipoNota(PesoCriterioController controller, List<double> tableTipoNotacolumnWidths) {
    return SingleChildScrollView(
      child: StickyHeadersTableNotExpandedCustom(
          cellDimensions: CellDimensions.variableColumnWidth(
              stickyLegendHeight: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 100),
              stickyLegendWidth: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 190),
              contentCellHeight: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 90),
              columnWidths: tableTipoNotacolumnWidths
          ),
          //cellAlignments: CellAlignments.,
          scrollControllers: crollControllers,
          columnsLength: controller.tableColumns.length,
          rowsLength: controller.rubricaEvaluacionList.length,
          columnsTitleBuilder: (i) {
            //#region columnsTitleBuilder
            var obj = controller.tableColumns[i];
            if(obj is String && obj == "promedio"){
              return Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: AppTheme.greyDarken1,
                      )
                  ),
                  Center(
                    child:  Text("Detalle",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color:  AppTheme.white,
                            fontSize: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12),
                            fontFamily: AppTheme.fontTTNorms,
                            fontWeight: FontWeight.w700
                        )
                    ),
                  )
                ],
              );
            }else if(obj is String && obj == "peso_criterio"){
              return Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(7)),
                        color: HexColor(controller.cursosUi.color1),
                      )
                  ),
                  Center(
                    child:  Text("Peso del criterio",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:  AppTheme.white,
                          fontSize: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12),
                          fontFamily: AppTheme.fontTTNorms,
                          fontWeight: FontWeight.w700
                      )
                    ),
                  )
                ],
              );
            } else if(obj is String && obj == "alta"){
              return Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color:  AppTheme.greyLighten2),
                          right: BorderSide(color:  AppTheme.greyLighten2),
                        ),
                        color: getPosition(0),
                      )
                  ),
                  Center(
                    child:  RotatedBox(
                     quarterTurns: -1,
                      child: Text("Peso\nAlta",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color:  AppTheme.white,
                              fontSize: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 11),
                              fontFamily: AppTheme.fontTTNorms,
                              fontWeight: FontWeight.w700
                          )
                      ),
                    ),
                  )
                ],
              );
            }else if(obj is String && obj == "estandar"){
                return Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color:  AppTheme.greyLighten2),
                          ),
                          color: getPosition(1),
                        )
                    ),
                    Center(
                      child:  RotatedBox(
                       quarterTurns: -1,
                        child: Text("Peso\nEstandar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color:  AppTheme.white,
                                fontSize: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 11),
                                fontFamily: AppTheme.fontTTNorms,
                                fontWeight: FontWeight.w700
                            )
                        )
                      ),
                    )
                  ],
                );
              }else if(obj is String && obj == "baja"){
                return Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color:  AppTheme.greyLighten2),
                          ),
                          color: getPosition(2),
                        )
                    ),
                    Center(
                      child:  RotatedBox(
                       quarterTurns: -1,
                        child: Text("Peso\nBaja",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color:  AppTheme.white,
                                fontSize: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 11),
                                fontFamily: AppTheme.fontTTNorms,
                                fontWeight: FontWeight.w700
                            )
                        ),
                      ),
                    )
                  ],
                );
              }else if(obj is String && obj == "no_usar"){
                return Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color:  AppTheme.greyLighten2),
                          ),
                          color: getPosition(3),
                        )
                    ),
                    Center(
                      child:  RotatedBox(
                       quarterTurns: -1,
                        child: Text("No usar\ncriterio",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color:  AppTheme.white,
                                fontSize: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 11),
                                fontFamily: AppTheme.fontTTNorms,
                                fontWeight: FontWeight.w700
                            )
                        ),
                      ),
                    )
                  ],
                );
              }else{
              return Container();
            }
            //#endregion
          },
          rowsTitleBuilder: (i) {
            RubricaEvaluacionUi rubricaEvaluacionUi = controller.rubricaEvaluacionList[i];
            bool rubrica =  (rubricaEvaluacionUi.tituloRubroCabecera??"").isNotEmpty;

            if(rubricaEvaluacionUi.cantidadRubroDetalle == 1){
              rubrica = false;
            }

            return InkWell(
              onTap: (){

              },
              child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 8),
                        right: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 8),
                        top: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 4),
                        bottom: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 4)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        rubrica?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  top: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 2),
                                  bottom: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 2)
                              ),
                              child: Text("${rubricaEvaluacionUi.tituloRubroCabecera??""}".trim(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis ,
                                style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 10),
                                    fontWeight: FontWeight.w900,
                                    fontFamily: AppTheme.fontTTNorms
                                  //fontStyle: FontStyle.italic
                                ),),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 4)
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        right: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 6)
                                    ),
                                    child:  (){
                                      switch(controller.capacidadUi.competenciaUi?.tipoCompetenciaUi??TipoCompetenciaUi.BASE){
                                        case TipoCompetenciaUi.BASE:
                                          return CachedNetworkImage(
                                            height: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12),
                                            width: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12),
                                            imageUrl: controller.capacidadUi.competenciaUi?.url??"",
                                            placeholder: (context, url) => SizedBox(
                                              child: Shimmer.fromColors(
                                                baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                                highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                                child: Container(
                                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                  decoration: BoxDecoration(
                                                      color: AppTheme.blue,
                                                      shape: BoxShape.circle
                                                  ),
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => SvgPicture.asset(AppIcon.ic_criterio_2, width: 8, height: 8,),
                                          );
                                        case TipoCompetenciaUi.TRANSVERSAL:
                                          return SvgPicture.asset(AppIcon.ic_transversal,
                                              width: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12),
                                              height: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12)
                                          );
                                        case TipoCompetenciaUi.ENFOQUE:
                                          return SvgPicture.asset(AppIcon.ic_enfoque,
                                              width: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12),
                                              height: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12)
                                          );
                                      }
                                    }(),
                                  ),
                                  Expanded(
                                    child: Text((rubricaEvaluacionUi.titulo?.trim()??""),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis ,
                                        style: TextStyle(
                                            fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 10),
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.textGrey
                                        )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ):
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  top: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 2),
                                  bottom: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 2)
                              ),
                              child: Text("${rubricaEvaluacionUi.titulo??""}".trim(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis ,
                                style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 10),
                                    fontWeight: FontWeight.w900,
                                    fontFamily: AppTheme.fontTTNorms
                                  //fontStyle: FontStyle.italic
                                ),),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context,4)
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        right: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 6)
                                    ),
                                    child:  (){
                                      switch(controller.capacidadUi.competenciaUi?.tipoCompetenciaUi??TipoCompetenciaUi.BASE){
                                        case TipoCompetenciaUi.BASE:
                                          return CachedNetworkImage(
                                            height: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12),
                                            width: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12),
                                            imageUrl: controller.capacidadUi.competenciaUi?.url??"",
                                            placeholder: (context, url) => SizedBox(
                                              child: Shimmer.fromColors(
                                                baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                                highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                                child: Container(
                                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                  decoration: BoxDecoration(
                                                      color: AppTheme.blue,
                                                      shape: BoxShape.circle
                                                  ),
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => SvgPicture.asset(AppIcon.ic_criterio_2, width: 8, height: 8,),
                                          );
                                        case TipoCompetenciaUi.TRANSVERSAL:
                                          return SvgPicture.asset(AppIcon.ic_transversal,
                                              width: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12),
                                              height: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12)
                                          );
                                        case TipoCompetenciaUi.ENFOQUE:
                                          return SvgPicture.asset(AppIcon.ic_enfoque,
                                              width: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12),
                                              height: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12)
                                          );
                                      }
                                    }(),
                                  ),
                                  Expanded(
                                    child: Text((rubricaEvaluacionUi.criterioUi?.icdTitulo?.trim()??""),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis ,
                                        style: TextStyle(
                                            fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 10),
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.textGrey
                                        )
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppTheme.greyLighten2),
                      left: BorderSide(color: AppTheme.greyLighten2),
                      right: BorderSide(color: AppTheme.greyLighten2),
                      bottom: BorderSide(color: AppTheme.greyLighten2.withOpacity((controller.rubricaEvaluacionList.length-1) <= i ? 1:0)),
                    ),
                    color: ((rubricaEvaluacionUi.peso??0) > RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO && !(rubricaEvaluacionUi.ningunaEvalCalificada??false))? AppTheme.white:AppTheme.red.withOpacity(0.1),
                  )
              ),
            );
          },
          contentCellBuilder: (i, j){
            dynamic o = controller.tableCells[j][i];
            if(o is RubricaEvaluacionPesoSelectedUi){
              return InkWell(
                onTap: () {
                  if(controller.calendarioPeriodoUI?.habilitadoProceso==1){
                    controller.onClickPeso(o);
                  }
                } ,
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: Text("${(){
                          if(o.peso==3){
                            return "Peso\nAlta";
                          }else if(o.peso==2){
                            return "Peso\nEstandar";
                          }else if(o.peso==1){
                            return "Peso\nBaja";
                          }else if(o.peso==-1){
                            return "No usar\ncriterio";
                          }else{
                            return "";
                          }
                        }()}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color:  (o.selected??false)?AppTheme.white: getPosition((){
                                  if(o.peso==3){
                                    return 0;
                                  }else if(o.peso==2){
                                    return 1;
                                  }else if(o.peso==1){
                                    return 2;
                                  }else if(o.peso==-1){
                                    return 3;
                                  }else{
                                    return 4;
                                  }
                                }()).withOpacity(0.8),
                                fontSize: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 11),
                                fontFamily: AppTheme.fontTTNorms,
                                fontWeight: FontWeight.w700
                            )
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppTheme.greyLighten2),
                          right: BorderSide(color: AppTheme.greyLighten2),
                          bottom: BorderSide(color: AppTheme.greyLighten2.withOpacity((controller.tableCells.length-1) <= j ? 1:0)),
                        ),
                        color: (o.peso??0) == 0 || !(o.selected??false)?AppTheme.white : getPosition((){
                          if(o.peso==3){
                            return 0;
                          }else if(o.peso==2){
                            return 1;
                          }else if(o.peso==1){
                            return 2;
                          }else if(o.peso==-1){
                            return 3;
                          }else{
                            return 4;
                          }
                        }()).withOpacity(0.8),
                      ),
                    ),
                    (controller.calendarioPeriodoUI?.habilitadoProceso!=1)?
                    Positioned(
                        bottom: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 4),
                        right: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 4),
                        child: Icon(Icons.block,
                            color: AppTheme.redLighten1.withOpacity(0.8),
                            size: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 14)
                        )
                    ):Container(),
                  ],
                ),
              );
            }
            else if(o is EvaluacionPorcentajeUi){
              return InkWell(
                onTap: (){
                    showDialogPeso(controller, o.rubricaEvaluacionUi, o.capacidadUi);
                },
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text((){
                        if(o.rubricaEvaluacionUi?.ningunaEvalCalificada??false)
                          return "Criterio sin\nevaluaciones";
                        if((o.rubricaEvaluacionUi?.peso??0) > RubricaEvaluacionUi.PESO_ALTO){
                          return "Peso\ndesconocido";
                        }if(o.rubricaEvaluacionUi?.peso == RubricaEvaluacionUi.PESO_ALTO){
                          return "Peso\nalto";
                        }else if(o.rubricaEvaluacionUi?.peso == RubricaEvaluacionUi.PESO_NORMAL){
                          return "Peso\nestandar";
                        }else if(o.rubricaEvaluacionUi?.peso == RubricaEvaluacionUi.PESO_BAJO){
                          return "Peso\nbajo";
                        }else{
                          return "No usar\ncriterio";
                        }
                      }(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 10),
                              fontFamily: AppTheme.fontTTNorms,
                              fontWeight: FontWeight.w500
                          )
                      ),
                      if((o.rubricaEvaluacionUi?.peso??0) > RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO)
                        Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 2))),
                      if((o.rubricaEvaluacionUi?.peso??0) > RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO && !(o.rubricaEvaluacionUi?.ningunaEvalCalificada??false))
                        Text("${DomainTools.removeDecimalZeroFormat((o.rubricaEvaluacionUi?.peso??0)/(o.capacidadUi?.total_peso??1)*100, fractionDigits: 3)}%",
                            style: TextStyle(
                              color: AppTheme.greyDarken3,
                              fontWeight: FontWeight.w700,
                              fontSize: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 11),
                              fontFamily: AppTheme.fontTTNorms,
                            )
                        ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppTheme.greyLighten2),
                      right: BorderSide(color: AppTheme.greyLighten2),
                      bottom: BorderSide(color: AppTheme.greyLighten2.withOpacity((controller.tableCells.length-1) <= j ? 1:0)),
                    ),
                    color:  ((o.rubricaEvaluacionUi?.peso??0) > RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO && !(o.rubricaEvaluacionUi?.ningunaEvalCalificada??false))
                        ?AppTheme.greyLighten5:AppTheme.red.withOpacity(0.1),
                  ),
                ),
              );
            }else if(o is RubricaEvaluacionUi){
              return InkWell(
                child: Container(
                  padding: EdgeInsets.only(
                    top: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Evaluados", style: TextStyle(
                          fontSize: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 10),
                          fontFamily: AppTheme.fontTTNorms,
                          fontWeight: FontWeight.w500
                      )),
                      Padding(padding: EdgeInsets.only(bottom: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 2))),
                      Text("${o.cantiEvalCalificadas??0} de ${o.evaluacionUiList?.length??0}.", style: TextStyle(
                        color: AppTheme.greyDarken3,
                        fontWeight: FontWeight.w700,
                        fontSize: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 11),
                        fontFamily: AppTheme.fontTTNorms,
                      )),
                      Padding(padding: EdgeInsets.only(bottom: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 4))),
                      Text("Media", style: TextStyle(
                          fontSize: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 10),
                          fontFamily: AppTheme.fontTTNorms,
                          fontWeight: FontWeight.w500
                      ),),
                      Padding(padding: EdgeInsets.only(bottom: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 2))),
                      Text("${o.mediaDesvicion??""}", style: TextStyle(
                        color: AppTheme.greyDarken3,
                        fontWeight: FontWeight.w700,
                        fontSize: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 11),
                        fontFamily: AppTheme.fontTTNorms,
                      )),

                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppTheme.greyLighten2),
                      right: BorderSide(color: AppTheme.greyLighten2),
                      bottom: BorderSide(color: AppTheme.greyLighten2.withOpacity((controller.tableCells.length-1) <= j ? 1:0)),
                    ),
                    color: ((o.peso??0) > RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO && !(o.ningunaEvalCalificada??false))?AppTheme.greyLighten5:AppTheme.red.withOpacity(0.1),
                  ),
                ),
              );
            } else
            return InkWell(
              child: Container(

                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.greyLighten2),
                    right: BorderSide(color: AppTheme.greyLighten2),
                    bottom: BorderSide(color: AppTheme.greyLighten2.withOpacity((controller.tableCells.length-1) <= j ? 1:0)),
                  ),
                  color: AppTheme.white,
                ),
              ),
            );
          },
          legendCell: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: HexColor(controller.cursosUi.color1),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(7))
                  )
              ),
              Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Criterios evaluados",
                          style: TextStyle(
                              color: AppTheme.white,
                              fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 12),
                              fontWeight: FontWeight.w700,
                              fontFamily: AppTheme.fontTTNorms
                          ))
                    ],
                  ),
              )
            ],
          )
      ),
    );
  }

  Color getPosition(int position){
    if(position == 0){
      return HexColor("#1976d2");
    }else if(position == 1){
      return  HexColor("#388e3c");
    }else if(position == 2){
      return   HexColor("#FF6D00");
    }else if(position == 3){
      return  HexColor("#D32F2F");
    }else{
      return  AppTheme.greyLighten2;
    }
  }


  void showDialogPeso(PesoCriterioController controller, RubricaEvaluacionUi? rubricaEvaluacionUi, CapacidadUi? capacidadUi) {

    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return PesoView(
            color: HexColor(controller.cursosUi.color2),
            selectedValue: (rubricaEvaluacionUi?.peso??0) == 0? RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO: (rubricaEvaluacionUi?.peso??0),
            onSaveInput: (peso) {
              Navigator.pop(context, peso);
            },
            onCloseButton: () {
              Navigator.pop(context, null);
            },
          );
        })
        .then((peso){
      if(peso != null){
        //controller.onSavePeso(peso, rubricaEvaluacionUi);
      }
    });
  }

}