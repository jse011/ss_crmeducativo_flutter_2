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
import 'package:shimmer/shimmer.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_not_expanded_custom.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/capacidad/evaluacion_capacidad_controller.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/presicion/peso_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/presicion/precision_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/presicion/teclado_precision_2_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/presicion/teclado_precision_view.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/preview_image_view.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_trasnformada_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_porcentaje_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_total_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';

class EvaluacionCapacidadView extends View{
  final EvaluacionCapacidadUi? evaluacionCapacidadUi;
  final CursosUi? cursosUi;
  final CalendarioPeriodoUI? calendarioPeriodoUI;

  EvaluacionCapacidadView(this.evaluacionCapacidadUi, this.cursosUi, this.calendarioPeriodoUI);

  @override
  _EvaluacionCapacidadViewState createState() => _EvaluacionCapacidadViewState(evaluacionCapacidadUi, cursosUi, calendarioPeriodoUI);

}

class _EvaluacionCapacidadViewState extends ViewState<EvaluacionCapacidadView, EvaluacionCapacidadController> with TickerProviderStateMixin{
  ScrollControllers crollControllers = ScrollControllers();

  _EvaluacionCapacidadViewState(evaluacionCapacidadUi, cursosUi, calendarioPeriodoUI) : super(EvaluacionCapacidadController(evaluacionCapacidadUi, cursosUi,calendarioPeriodoUI, MoorConfiguracionRepository(), MoorRubroRepository(), DeviceHttpDatosRepositorio()));

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
  Widget get view => ControlledWidgetBuilder<EvaluacionCapacidadController>(
      builder: (context, controller) {

        return WillPopScope(
            onWillPop: () async {
              bool?  se_a_modicado = await controller.onSave();
              print("se_a_modicado ${se_a_modicado}");
              if(se_a_modicado){
                Navigator.of(context).pop(1);//si devuelve un entero se actualiza toda la lista;
                return false;
              }else{
                Navigator.of(context).pop(true);
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
                    if(controller.showMsgAlumnoNoVigente)
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
                                        child: Icon(Icons.supervised_user_circle, size: 35, color: AppTheme.white,),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppTheme.colorAccent),
                                      ),
                                      Padding(padding: EdgeInsets.all(8)),
                                      Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(padding: EdgeInsets.all(4),),
                                              Text("Contrato no vigente", style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: AppTheme.fontTTNormsMedium
                                              ),),
                                              Padding(padding: EdgeInsets.all(8),),
                                              Text("El Contrato de ${controller.evaluacionCapacidadUi.personaUi?.nombreCompleto??""} no esta vigente.",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    height: 1.5
                                                ),),
                                              Padding(padding: EdgeInsets.all(16),),
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Container()
                                      ),
                                      Padding(padding: EdgeInsets.all(8)),
                                      Expanded(child: ElevatedButton(
                                        onPressed: () {
                                          //Navigator.of(context).pop(true);
                                          controller.hideMsgAlumnoNoVigente();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: AppTheme.colorAccent,
                                          onPrimary: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        child: Text('Salir'),
                                      )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                      ),
                    if(controller.showDialogClearEvaluacion)
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
                                        child: Icon(Icons.cleaning_services_rounded, size: 35, color: AppTheme.white,),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppTheme.colorAccent),
                                      ),
                                      Padding(padding: EdgeInsets.all(8)),
                                      Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(padding: EdgeInsets.all(4),),
                                              Text("Borrar todo y evaluar de nuevo", style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: AppTheme.fontTTNormsMedium
                                              ),),
                                              Padding(padding: EdgeInsets.all(4),),
                                              Text("¿Está seguro de volver a evaluar todo de nuevo?",
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
                                              controller.onClickCancelarClearEvaluacion();
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
                                        onPressed: () {
                                          controller.onClicClearEvaluacionAll();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                          onPrimary: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        child: Text('Borrar todo'),
                                      )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                      )
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
                child:   ControlledWidgetBuilder<EvaluacionCapacidadController>(
                  builder: (context, controller) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                            child:  IconButton(
                              icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                              onPressed: () async{
                                bool?  seamodicado = await controller.onSave();
                                if(seamodicado){
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
        ),
      ],
    );
  }

  Widget getMainTab() {


    return ControlledWidgetBuilder<EvaluacionCapacidadController>(
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

                            for(var column in controller.tableTipoNotaColumns){
                              if(column is ValorTipoNotaUi){
                                tableTipoNotacolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 40));
                              }else if(column is EvaluacionUi){
                                tableTipoNotacolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 65));
                              }else if(column is EvaluacionUi){
                                tableTipoNotacolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 65));
                              }else if(column is String){
                                if(column == "peso_criterio"){
                                  tableTipoNotacolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 70));
                                }else if(column == "total"){
                                  tableTipoNotacolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 70));
                                }else{
                                  tableTipoNotacolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 70));
                                }
                              }else{
                                tableTipoNotacolumnWidths.add(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 70));
                              }


                            }

                            double width_pantalla = MediaQuery.of(context).size.width;
                            double padding_left = ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 32);
                            double padding_right = ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 32);
                            double width_table = padding_left + padding_right + ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 180);
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
                                  padding: EdgeInsets.only(top: 32, left: padding_left, right: padding_right,),
                                  width: width,
                                  child:  Wrap(
                                    spacing: 10.0,
                                    runSpacing: 15.0,
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.start,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: ()=> controller.onClicPrecision(),
                                        child: Container(
                                          width: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 120),
                                          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 8)),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 6))),
                                              color:  controller.precision?HexColor(controller.cursosUi.color2) : AppTheme.greyLighten3
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(AppIcon.ic_presicion,
                                                color: controller.precision? AppTheme.white :AppTheme.greyDarken1,
                                                height: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 16),
                                                width: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 16)
                                              ),
                                              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 4)),),
                                              Text("Precisión",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    letterSpacing: 0.5,
                                                    color:  controller.precision? AppTheme.white :AppTheme.greyDarken1,
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 12) ,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        //onTap: ()=> controller.onClicPrecision(),
                                        child: Container(
                                          width: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 110),
                                          padding: EdgeInsets.only(
                                              left: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 16) ,
                                              right: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 16),
                                              top: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 8),
                                              bottom: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 8)),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 6))),
                                              color: HexColor(controller.cursosUi.color2)
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Ionicons.help_circle,
                                                color: AppTheme.white,
                                                size: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 16)
                                              ),
                                              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 2))),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text("Ayuda",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: AppTheme.fontTTNorms,
                                                      letterSpacing: 0.5,
                                                      color:AppTheme.white,
                                                      fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 12) ,
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
                                  margin: EdgeInsets.only(
                                      left: padding_left,
                                      right: padding_right,
                                      top: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 24)
                                  ),
                                  width: width - (padding_left + padding_right),
                                  color: HexColor(controller.cursosUi.color3).withOpacity(0.1),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                              TextSpan(text: 'EVALUA LOS CRITERIOS ASOCIADOS A LA CAPACIDAD '),
                                              //TextSpan(text: "${(controller.evaluacionCapacidadUi.personaUi?.nombreCompleto??"").toUpperCase()}"),
                                              TextSpan(text: '"${(controller.evaluacionCapacidadUi.capacidadUi?.nombre??"").toUpperCase()}"',
                                                  style: TextStyle(fontWeight: FontWeight.w900)),

                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: padding_left,
                                      right: padding_right
                                  ),
                                  width: width - (padding_left + padding_right),
                                  height: 1,
                                  color: HexColor(controller.cursosUi.color1),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: padding_left,
                                      right: padding_right,
                                      top: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 16)
                                  ),
                                  width: width,
                                  child:  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            Navigator.of(context).push(PreviewImageView.createRoute(controller.evaluacionCapacidadUi.personaUi?.foto));
                                          },
                                          child: Container(
                                            width:  ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 45),
                                            height:  ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 45),
                                            margin: EdgeInsets.only(
                                                right:  ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 16), left: 0, top: 0, bottom: 0),
                                            child: CachedNetworkImage(
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
                                              imageUrl: controller.evaluacionCapacidadUi.personaUi?.foto??"",
                                              errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded),
                                              imageBuilder: (context, imageProvider) =>
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child:  Text(
                                            controller.evaluacionCapacidadUi.personaUi?.nombreCompleto??"",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w700,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 16),
                                              height: 1.5,
                                              color: AppTheme.darkerText,
                                            ),
                                          ),
                                        )
                                      ]
                                  ),

                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 24)
                                    )
                                ),
                                Container(
                                  width: width,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 45),
                                        height: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 45),
                                        margin: EdgeInsets.only(bottom: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 8)),
                                        child: FDottedLine(
                                          color: AppTheme.greyLighten1,
                                          strokeWidth: 1.0,
                                          dottedLength: 5.0,
                                          space: 3.0,
                                          corner: FDottedLineCorner.all(8.0),
                                          child: Container(
                                            color: AppTheme.greyLighten2,
                                            child: _getTipoNota(controller.evaluacionCapacidadUi.valorTipoNotaUi, controller.tipoNotaUi,controller.evaluacionCapacidadUi.nota),
                                          ),

                                        ),
                                      ),
                                      Text(controller.evaluacionCapacidadUi.valorTipoNotaUi?.alias??"",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 12),
                                            color: AppTheme.darkerText,
                                          )
                                      ),
                                    ],
                                  ),
                                ) ,
                                Container(
                                  width: width,
                                  padding: EdgeInsets.only(
                                      left: padding_left,
                                      top:ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 24)
                                  ),
                                  child: showTableTipoNota(controller, tableTipoNotacolumnWidths),
                                ),
                                Container(
                                  width: width,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: width_table - ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 70) - ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 70) - padding_left,
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                                height: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 50),
                                                width: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 70),
                                                padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 4)),
                                                child: Center(
                                                  child:  Text("Promedio\nponderado",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: AppTheme.greyDarken3,
                                                          fontWeight: FontWeight.w900,
                                                          fontFamily: AppTheme.fontTTNorms,
                                                          fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 10)
                                                      )
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(color: AppTheme.greyLighten2),
                                                      left: BorderSide(color: AppTheme.greyLighten2),
                                                    ),
                                                    color: AppTheme.greyLighten4
                                                )
                                            ),
                                            Container(
                                                height: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 50),
                                                width: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 70),
                                                padding: EdgeInsets.all(8),
                                                child: Center(
                                                    child:  Text("${DomainTools.removeDecimalZeroFormat(controller.evaluacionCapacidadUi.nota,fractionDigits: 3)??"-"}",
                                                        style: TextStyle(
                                                          fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 12),
                                                          color: AppTheme.greyDarken3,
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: AppTheme.fontTTNorms,
                                                        )
                                                    )
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(color: AppTheme.greyLighten2),
                                                      left: BorderSide(color: AppTheme.greyLighten2),
                                                      right: BorderSide(color: AppTheme.greyLighten2),
                                                      top: BorderSide(color: Colors.transparent),
                                                    ),
                                                    color: AppTheme.greyLighten4
                                                )
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
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

  Widget showTableTipoNota(EvaluacionCapacidadController controller, List<double> tableTipoNotacolumnWidths) {
    return SingleChildScrollView(
      child: StickyHeadersTableNotExpandedCustom(
          cellDimensions: CellDimensions.variableColumnWidth(
              stickyLegendHeight: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 45),
              stickyLegendWidth: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 180),
              contentCellHeight: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 90),
              columnWidths: tableTipoNotacolumnWidths
          ),
          //cellAlignments: CellAlignments.,
          scrollControllers: crollControllers,
          columnsLength: controller.tableTipoNotaColumns.length,
          rowsLength: controller.rubricaEvaluacionList.length,
          columnsTitleBuilder: (i) {
            //#region columnsTitleBuilder
            var obj = controller.tableTipoNotaColumns[i];
              if(obj is String && obj == "peso_criterio"){
              return Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color:  AppTheme.greyLighten2),
                        ),
                        color: HexColor(controller.cursosUi.color2),
                      )
                  ),
                  Center(
                    child:  Text("Peso del criterio",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:  AppTheme.white,
                          fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 11),
                          fontFamily: AppTheme.fontTTNorms,
                          fontWeight: FontWeight.w700
                      )
                    ),
                  )
                ],
              );
            } else if(obj is String && obj == "total"){
              return Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(7)),
                        color: AppTheme.greyLighten2,
                      )
                  ),
                  Center(
                    child:  Text("Puntos logrados",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:  AppTheme.black,
                          fontFamily: AppTheme.fontTTNorms,
                          fontWeight: FontWeight.w700,
                          fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 11)
                      )
                    ),
                  )
                ],
              );
            }else if(obj is ValorTipoNotaUi){
              return InkWell(
                onDoubleTap: () {
                  if(controller.calendarioPeriodoUI?.habilitadoProceso==1){
                    controller.onClikShowDialogClearEvaluacion();
                  }
                } ,
                onLongPress: () {
                  if(controller.calendarioPeriodoUI?.habilitadoProceso==1){
                    controller.onClicEvaluacionAll(obj);
                  }

                },
                child: Stack(
                  children: [
                    _getTipoNotaCabecera(obj, controller,i)
                  ],
                ),
              );

            }else if(obj is EvaluacionUi){
              return Container(
                  constraints: BoxConstraints.expand(),
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child:  Text("Nota\nnúmerica",
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 10),
                          fontWeight: FontWeight.w700,
                          color: AppTheme.white
                      )
                    ),
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: HexColor(controller.cursosUi.color3)),
                        right: BorderSide(color: HexColor(controller.cursosUi.color3).withOpacity(0.3)),
                      ),
                    color: HexColor(controller.cursosUi.color2),
                  )
              );
            }else{
              return Container();
            }
            //#endregion
          },
          rowsTitleBuilder: (i) {
            RubricaEvaluacionUi rubricaEvaluacionUi = controller.rubricaEvaluacionList[i];

            bool rubrica =  (rubricaEvaluacionUi.tituloRubroCabecera??"").isNotEmpty;
            return InkWell(
              onTap: (){

              },
              child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 8),
                        right: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 4),
                        top: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 8)
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
                                      switch(controller.evaluacionCapacidadUi.capacidadUi?.competenciaUi?.tipoCompetenciaUi??TipoCompetenciaUi.BASE){
                                        case TipoCompetenciaUi.BASE:
                                          return CachedNetworkImage(
                                            height: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12),
                                            width: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12),
                                            imageUrl: controller.evaluacionCapacidadUi.capacidadUi?.competenciaUi?.url??"",
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
                                      switch(controller.evaluacionCapacidadUi.capacidadUi?.competenciaUi?.tipoCompetenciaUi??TipoCompetenciaUi.BASE){
                                        case TipoCompetenciaUi.BASE:
                                          return CachedNetworkImage(
                                            height: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12),
                                            width: ColumnCountProvider.aspectRatioForWidthTablePesoCriterio(context, 12),
                                            imageUrl: controller.evaluacionCapacidadUi.capacidadUi?.competenciaUi?.url??"",
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
                    color: ((rubricaEvaluacionUi.peso??0) > RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO && !(rubricaEvaluacionUi.ningunaEvalCalificada??false))?AppTheme.white:AppTheme.red.withOpacity(0.1),
                  )
              ),
            );
          },
          contentCellBuilder: (i, j){
            dynamic o = controller.tableTipoNotaCells[j][i];
            if(o is EvaluacionPorcentajeUi){
              return InkWell(
                onTap: (){
                  if(o.rubricaEvaluacionUi?.ningunaEvalCalificada??false){
                    _showEvaluacionSinNotas(context, o.rubricaEvaluacionUi);
                  }else{
                    //showDialogPeso(controller, o.rubricaEvaluacionUi, o.capacidadUi);
                  }
                },
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if((o.rubricaEvaluacionUi?.peso??0) > RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO)
                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 8))),
                      if((o.rubricaEvaluacionUi?.peso??0) > RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO && !(o.rubricaEvaluacionUi?.ningunaEvalCalificada??false))
                      Text("${DomainTools.removeDecimalZeroFormat((o.rubricaEvaluacionUi?.peso??0)/(o.capacidadUi?.total_peso??1)*100, fractionDigits: 3)}%",
                        style: TextStyle(
                          fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 12),
                          color: AppTheme.greyDarken3,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppTheme.fontTTNorms
                        )
                      ),
                      Padding(padding: EdgeInsets.all(2)),
                      Text((){
                        if(o.rubricaEvaluacionUi?.ningunaEvalCalificada??false)
                          return "Criterio sin\nevaluaciones";
                        if((o.rubricaEvaluacionUi?.peso??0) > RubricaEvaluacionUi.PESO_ALTO){
                          return "P. Desconocido";
                        }if(o.rubricaEvaluacionUi?.peso == RubricaEvaluacionUi.PESO_ALTO){
                          return "P. Alto";
                        }else if(o.rubricaEvaluacionUi?.peso == RubricaEvaluacionUi.PESO_NORMAL){
                          return "P. Estandar";
                        }else if(o.rubricaEvaluacionUi?.peso == RubricaEvaluacionUi.PESO_BAJO){
                          return "P. Bajo";
                        }else{
                          return "No usar\ncriterio";
                        }
                      }(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 9),
                            fontWeight: FontWeight.w700,
                            fontFamily: AppTheme.fontTTNorms,
                            letterSpacing: 0.5,
                            color: AppTheme.greyDarken3,
                        )
                      ),

                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppTheme.greyLighten2),
                      right: BorderSide(color: AppTheme.greyLighten2),
                      bottom: BorderSide(color: AppTheme.greyLighten2.withOpacity((controller.tableTipoNotaCells.length-1) <= j ? 1:0)),
                    ),
                    color:  ((o.rubricaEvaluacionUi?.peso??0) > RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO && !(o.rubricaEvaluacionUi?.ningunaEvalCalificada??false))
                        ?AppTheme.greyLighten5:AppTheme.red.withOpacity(0.1),
                  ),
                ),
              );
            }else if(o is RubricaEvaluacionTotalUi){
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${DomainTools.removeDecimalZeroFormat(o.total,fractionDigits: 3)??"-"}",
                      style: TextStyle(
                          fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 12),
                          color: AppTheme.greyDarken3,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppTheme.fontTTNorms
                      )
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.greyLighten2),
                    right: BorderSide(color: AppTheme.greyLighten2),
                    bottom: BorderSide(color: AppTheme.greyLighten2.withOpacity((controller.tableTipoNotaCells.length-1) <= j ? 1:0)),
                  ),
                  color: ((o.evaluacionUi?.rubroEvaluacionUi?.peso??0) > RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO && !(o.evaluacionUi?.rubroEvaluacionUi?.ningunaEvalCalificada??false))?
                  AppTheme.greyLighten4:AppTheme.red.withOpacity(0.1),
                ),
              );
            }else if(o is EvaluacionRubricaValorTipoNotaUi){
              return InkWell(
                onTap: () {
                  if(controller.calendarioPeriodoUI?.habilitadoProceso==1){
                    if((o.evaluacionTransformadaUi?.personaUi?.contratoVigente == true)){
                      if(controller.precision && (o.valorTipoNotaUi?.tipoNotaUi?.intervalo??false)){
                        showDialogPresicion(controller, o, i);
                      } else{
                        controller.onClicEvaluar(o);
                      }
                    }else{
                      controller.showControNoVigente();
                    }
                  }

                },
                onLongPress: (){
                  if(controller.calendarioPeriodoUI?.habilitadoProceso==1){
                    if((o.evaluacionTransformadaUi?.personaUi?.contratoVigente == true)){
                      if(o.valorTipoNotaUi?.tipoNotaUi?.intervalo??false){

                      }
                      else{
                        showDialogTecladoPrecicion(controller, controller.tipoNotaUi, o.evaluacionTransformadaUi);
                      }
                    }
                  }

                },
                child: Stack(
                  children: [
                    _getTipoNotaDetalle(o, controller,i, j),
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
            } else if(o is EvaluacionTransformadaUi){
              return InkWell(
                onTap: () {
                  if(controller.calendarioPeriodoUI?.habilitadoProceso==1){
                    showDialogTecladoPrecicion(controller, controller.tipoNotaUi, o);
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      constraints: BoxConstraints.expand(),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppTheme.greyLighten2),
                          right: BorderSide(color:  AppTheme.greyLighten2),
                          bottom: BorderSide(color: AppTheme.greyLighten2.withOpacity((controller.tableTipoNotaCells.length-1) <= j ? 1:0)),
                        ),
                          color: _getColorAlumnoBloqueados(o.personaUi, 0)
                      ),
                      child: Center(
                        child: _getTipoNota(null, controller.tipoNotaUi, o.nota),
                      ),
                    ),
                    (controller.calendarioPeriodoUI?.habilitadoProceso!=1)?
                    Positioned(
                        bottom: 4,
                        right: 4,
                        child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 14,)
                    ):Container(),
                  ],
                ),
              );
            }
            else{
              return Container(
                  child: Center(
                    child: Text(""),
                  ),
                  decoration: BoxDecoration(

                  )
              );
            }
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
                    children: [
                      Text("Criterios evaluados",
                          style: TextStyle(
                              color: AppTheme.white,
                              fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 11),
                              fontWeight: FontWeight.w700,
                              fontFamily: AppTheme.fontTTNorms
                          )
                      )
                    ],
                  ),
              )
            ],
          )
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  Color getColor(int position) {
    if(position == 0){
      return HexColor("#1976d2");
    }else if(position == 1){
      return HexColor("#388e3c");
    }else if(position == 2){
      return HexColor("#FF6D00");
    }else if(position == 3){
      return HexColor("#D32F2F");
    }else{
      return Colors.black;
    }

  }

  Color getColor2(int position){
    switch (position){
      case 0:
        return HexColor("#64B5F6");
      case 3:
        return HexColor("#E57373");
      case 2:
        return HexColor("#FFB74D");
      case 1:
        return HexColor("#81C784");
      default:
        return HexColor("#e0e0e0");

    }
  }

  Widget _getTipoNotaDetalle(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, EvaluacionCapacidadController controller, int positionX, int positionY) {
    Widget? widget;
    Color color_fondo;
    Color? color_texto;
    Color color_borde;

    if(positionX == 0){
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#1976d2");
        color_texto = AppTheme.white;
        color_borde = HexColor("#1976d2");
      }else{
        color_fondo = AppTheme.white;
        color_texto = HexColor("#1976d2");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 1){
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#388e3c");
        color_texto = AppTheme.white;
        color_borde = HexColor("#388e3c");
      }else{
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#388e3c");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 2){
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#FF6D00");
        color_texto = AppTheme.white;
        color_borde = HexColor("#FF6D00");
      }else{
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#FF6D00");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 3){
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#D32F2F");
        color_texto = AppTheme.white;
        color_borde = HexColor("#D32F2F");
      }else {
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#D32F2F");
        color_borde = AppTheme.greyLighten2;
      }
    }else{
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = AppTheme.greyLighten2;
        color_texto =  null;
        color_borde = AppTheme.greyLighten1;
      }else{
        color_fondo = AppTheme.white;
        color_texto = null;
        color_borde = AppTheme.greyLighten1;
      }
    }

    color_fondo = color_fondo.withOpacity(0.8);
    color_borde = AppTheme.greyLighten2.withOpacity(0.8);

    var tipo =TipoNotaTiposUi.VALOR_NUMERICO;
    if(!controller.precision) tipo = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO;
    switch(tipo){
      case TipoNotaTiposUi.SELECTOR_VALORES:
        widget = Center(
          child: Text("${ evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.titulo??"-"}",
              style: TextStyle(
                  fontFamily: AppTheme.fontTTNorms,
                  fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 14),
                  fontWeight: FontWeight.w700,
                  color: color_texto?.withOpacity((evaluacionRubricaValorTipoNotaUi.toggle??false)? 1 : 0.7)
              )),
        );
        break;
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        widget = Opacity(
          opacity: (evaluacionRubricaValorTipoNotaUi.toggle??false)? 1 : 0.5,
          child: Container(
            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 4)),
            child:  CachedNetworkImage(
              imageUrl: evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.icono??"",
              placeholder: (context, url) => Stack(
                children: [
                  CircularProgressIndicator(
                    backgroundColor: color_texto,
                  )
                ],
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        );
        break;
      case TipoNotaTiposUi.VALOR_ASISTENCIA:
      case TipoNotaTiposUi.VALOR_NUMERICO:
      case TipoNotaTiposUi.SELECTOR_NUMERICO:
        double? nota;
        if(evaluacionRubricaValorTipoNotaUi.toggle??false)nota = evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.nota;
        else nota = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorNumerico??0;
        widget = Center(
          child: Text("${nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
              fontFamily: AppTheme.fontTTNorms,
              fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 14),
              fontWeight: FontWeight.w700,
              color: color_texto?.withOpacity((evaluacionRubricaValorTipoNotaUi.toggle??false)? 1 : 0.7)
          ),),
        );
        break;
    }

    if(!(evaluacionRubricaValorTipoNotaUi.toggle??false)){
      if((evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.rubroEvaluacionUi?.peso ??0) <= RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO || (evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.rubroEvaluacionUi?.ningunaEvalCalificada??false)){
        color_fondo = AppTheme.red.withOpacity(0.1);
      }else{
        color_fondo = _getColorAlumnoBloqueados(evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.personaUi, 0);
      }
    }

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.greyLighten2),
          right: BorderSide(color:  color_borde),
          bottom:  BorderSide(color:  AppTheme.greyLighten2.withOpacity((controller.tableTipoNotaCells.length-1) <= positionY?1:0 )),
        ),
          color: color_fondo
      ),
      child: widget,
    );

  }

  Widget? _getTipoNota(ValorTipoNotaUi? valorTipoNotaUi, TipoNotaUi? tipoNotaUi ,double? nota) {

    nota = nota!=null?DomainTools.roundDouble(nota, 1): null;

    switch(valorTipoNotaUi?.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO){
      case TipoNotaTiposUi.SELECTOR_VALORES:
        Color color;
        if (("B" == (valorTipoNotaUi?.titulo??"") || "C" == (valorTipoNotaUi?.titulo??""))) {
          color = AppTheme.redDarken4;
        }else if (("AD" == (valorTipoNotaUi?.titulo??"")) || "A" == (valorTipoNotaUi?.titulo??"")) {
          color = AppTheme.blueDarken4;
        }else {
          color = AppTheme.black;
        }
        return Container(
          height: double.maxFinite,
          width: double.maxFinite,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(valorTipoNotaUi?.titulo??"",
                  style: TextStyle(
                    fontFamily: AppTheme.fontTTNorms,
                    fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 14),
                    fontWeight: FontWeight.w900,
                    color: color,
                  )),
              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 2)),),
              Text("${DomainTools.removeDecimalZeroFormat(nota, fractionDigits: 1)??"-"}",
                  style: TextStyle(
                    fontFamily: AppTheme.fontTTNorms,
                    fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 14),
                    fontWeight: FontWeight.w900,
                    color: color,
                  ))
            ],
          ),
        );
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        return Container(
          margin: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 4)),
          child:  CachedNetworkImage(
            imageUrl: valorTipoNotaUi?.icono??"",
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        );
      case TipoNotaTiposUi.VALOR_ASISTENCIA:
      case TipoNotaTiposUi.VALOR_NUMERICO:
      case TipoNotaTiposUi.SELECTOR_NUMERICO:
      Color color;
      if(tipoNotaUi?.escalavalorMaximo == 20){
        if ((nota??0) < 10.5) {
          color = AppTheme.redDarken4;
        }else if ( (nota??0) >= 10.5) {
          color = AppTheme.blueDarken4;
        }else {
          color = AppTheme.black;
        }
      }else if(tipoNotaUi?.escalavalorMaximo == 4){
        if ((nota??0) < 3) {
          color = AppTheme.redDarken4;
        }else if ( (nota??0) >= 3) {
          color = AppTheme.blueDarken4;
        }else {
          color = AppTheme.black;
        }
      }else if(tipoNotaUi?.escalavalorMaximo == 3){
        if ((nota??0) < 3) {
          color = AppTheme.redDarken4;
        }else if ( (nota??0) >= 3) {
          color = AppTheme.blueDarken4;
        }else {
          color = AppTheme.black;
        }
      }else{
        color = AppTheme.black;
      }

        return Center(
          child: Text("${DomainTools.removeDecimalZeroFormat(nota, fractionDigits: 1)??"-"}", style: TextStyle(
            fontFamily: AppTheme.fontTTNormsMedium,
            fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 11),
            fontWeight: FontWeight.w700,
            color: color,
          ),),
        );
    }
  }

  Widget _getTipoNotaCabecera(ValorTipoNotaUi? valorTipoNotaUi,EvaluacionCapacidadController controller, int position) {
    Widget? nota;
    Color color_fondo;
    Color? color_texto;
    if(position == 0){
      color_fondo = HexColor("#1976d2");
      color_texto = AppTheme.white;
    }else if(position == 1){
      color_fondo =  HexColor("#388e3c");
      color_texto = AppTheme.white;
    }else if(position == 2){
      color_fondo =  HexColor("#FF6D00");
      color_texto = AppTheme.white;
    }else if(position == 3){
      color_fondo =  HexColor("#D32F2F");
      color_texto = AppTheme.white;
    }else{
      color_fondo =  AppTheme.greyLighten2;
      color_texto = null;//defaul
    }

    var ver_detalle = false;
    //if(valorTipoNotaUi?.tipoNotaUi?.intervalo??false)
    ver_detalle = controller.precision;

    switch(valorTipoNotaUi?.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO) {
      case TipoNotaTiposUi.SELECTOR_VALORES:
        nota = Container(
          child: Center(
            child: Text(valorTipoNotaUi?.titulo ?? "",
                style: TextStyle(
                    fontFamily: AppTheme.fontTTNorms,
                    fontWeight: FontWeight.w700,
                    fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 14),
                    color: color_texto
                )),
          ),
        );
        break;
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        nota = Container(
          width: ver_detalle?35:45,
          height: ver_detalle?35:45,
          child: CachedNetworkImage(
            imageUrl: valorTipoNotaUi?.icono ?? "",
            placeholder: (context, url) => Stack(
              children: [
                CircularProgressIndicator(
                  backgroundColor: color_texto,
                )
              ],
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        );
        break;
      default:
        break;
    }

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: color_fondo),
          right: BorderSide(color:  color_fondo),
        ),
        color: color_fondo,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          nota??Container(),
          if(ver_detalle)
            Container(
              margin: EdgeInsets.only(top: 2),
              child: Text("${(valorTipoNotaUi?.valorNumerico??0).toStringAsFixed(1)}", style: TextStyle(
                  fontFamily: AppTheme.fontTTNorms,
                  fontWeight: FontWeight.w700,
                  fontSize: ColumnCountProvider.aspectRatioForWidthTableEvalCapacidad(context, 14),
                  color: color_texto
              ),),
            )
        ],
      ),
    );
  }


  void showDialogPresicion(EvaluacionCapacidadController controller, EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, int position) {
    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return PresicionView(
            valorTipoNotaUi: evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi,
            color: getPosition(position),
            personaUi: evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.personaUi,
            onSaveInput: (nota) {

              Navigator.pop(context, nota);
            },
            onCloseButton: () {
              Navigator.pop(context, null);
            },
          );
        })
        .then((nota){
      if(nota != null){
        controller.onClicEvaluarPresicion(evaluacionRubricaValorTipoNotaUi, nota);
      }
    });
  }

  void showDialogTecladoPrecicion(EvaluacionCapacidadController controller, TipoNotaUi? tipoNotaUi, EvaluacionTransformadaUi? evaluacionUi) {
    print("showDialogTecladoPrecicion");
    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return TecladoPresicionView2(
            valorMaximo: tipoNotaUi?.escalavalorMaximo,
            valorMinimo: tipoNotaUi?.escalavalorMinimo,
            valor: evaluacionUi?.nota??0,
            onSaveInput: (nota) {
              Navigator.pop(context, nota);
            },
            onCloseButton: () {
              Navigator.pop(context, null);
            },
          );
        })
        .then((nota){
      if(nota != null){
        controller.onSaveTecladoPresicion(nota, evaluacionUi);
      }
    });
  }

  void showDialogPeso(EvaluacionCapacidadController controller, RubricaEvaluacionUi? rubricaEvaluacionUi, CapacidadUi? capacidadUi) {

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
        controller.onSavePeso(peso, rubricaEvaluacionUi);
      }
    });
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

  Color _getColorAlumnoBloqueados(PersonaUi? personaUi, int intenciadad, {Color c_default = Colors.white}) {
    if(!(personaUi?.contratoVigente??false)){

      if(intenciadad == 0){
        return AppTheme.redLighten4;
      }else  if(intenciadad == 1){
        return AppTheme.redLighten3;
      }else  if(intenciadad == 2){
        return AppTheme.redLighten2;
      }else{
        return AppTheme.redLighten4;
      }
    }else if((personaUi?.soloApareceEnElCurso??false)){

      if(intenciadad == 0){
        return AppTheme.deepOrangeLighten4;
      }else  if(intenciadad == 1){
        return AppTheme.deepOrangeLighten3;
      }else  if(intenciadad == 2){
        return AppTheme.deepOrangeLighten2;
      }else{
        return AppTheme.deepOrangeLighten4;
      }
    }else{
      return c_default;
    }
  }

  Future<bool?> _showEvaluacionSinNotas(BuildContext context, RubricaEvaluacionUi? rubricaEvaluacionUi) async {
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
                            child: Icon(Icons.block, size: 35, color: AppTheme.white,),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.red),
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("Criterio sin evaluaciones", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppTheme.fontTTNormsMedium
                                  ),),
                                  Padding(padding: EdgeInsets.all(8),),
                                  Text('Por favor evalúe el criterio.',
                                    style: TextStyle(
                                        fontSize: 14,
                                        height: 1.5
                                    ),),
                                  Padding(padding: EdgeInsets.all(16),),
                                ],
                              )
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container()
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: AppTheme.colorAccent,
                              onPrimary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Salir'),
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              )
          );
        },
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.transparent,
        transitionDuration:
        const Duration(milliseconds: 150));
  }

}