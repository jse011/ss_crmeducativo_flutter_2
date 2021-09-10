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
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_not_expanded_custom.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/capacidad/evaluacion_capacidad_controller.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/presicion/peso_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/presicion/precision_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/presicion/teclado_precision_view.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_trasnformada_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_formula_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_porcentaje_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_total_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/app_tools.dart';

class EvaluacionCapacidadView extends View{
  EvaluacionCapacidadUi? evaluacionCapacidadUi;
  CursosUi? cursosUi;

  EvaluacionCapacidadView(this.evaluacionCapacidadUi, this.cursosUi);

  @override
  _EvaluacionCapacidadViewState createState() => _EvaluacionCapacidadViewState(evaluacionCapacidadUi, cursosUi);

}

class _EvaluacionCapacidadViewState extends ViewState<EvaluacionCapacidadView, EvaluacionCapacidadController> with TickerProviderStateMixin{
  ScrollControllers crollControllers = ScrollControllers();

  _EvaluacionCapacidadViewState(evaluacionCapacidadUi, cursosUi) : super(EvaluacionCapacidadController(evaluacionCapacidadUi, cursosUi, MoorConfiguracionRepository(), MoorRubroRepository(), DeviceHttpDatosRepositorio()));
  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late AnimationController animationController;
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

    Future.delayed(const Duration(milliseconds: 200), () {
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
  Widget get view => ControlledWidgetBuilder<EvaluacionCapacidadController>(
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
              color: AppTheme.white,
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
                                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 54, right: 32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(AppIcon.ic_curso_evaluacion, height: 25 +  6 - 8 * topBarOpacity, width: 35 +  6 - 8 * topBarOpacity,),
                                      Padding(padding: EdgeInsets.only(left: 16)),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text(
                                            controller.evaluacionCapacidadUi.capacidadUi?.nombre??"",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12 + 6 - 6 * topBarOpacity,
                                              letterSpacing: 0.8,
                                              color: AppTheme.darkerText,
                                            ),
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
                SliverPadding(
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 16, top: 24),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: EdgeInsets.only( top: 16, left: 16, right: 16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: ()=> controller.onClicPrecision(),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              color: controller.precision?AppTheme.colorAccent:null
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Ionicons.apps, color:controller.precision?AppTheme.white:AppTheme.colorAccent, size: 20, ),
                                              Padding(padding: EdgeInsets.all(2),),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text("Precisión",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: 0.5,
                                                        color:  controller.precision?AppTheme.white:AppTheme.colorPrimary,
                                                        fontSize: 12
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Container()
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: CupertinoButton (
                                          onPressed: (){},
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Ionicons.help_circle, color: AppTheme.colorAccent, size: 20,),
                                              Padding(padding: EdgeInsets.all(2),),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text("Ayuda",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        letterSpacing: 0.5,
                                                        fontWeight: FontWeight.bold,
                                                        color: AppTheme.colorPrimary,
                                                        fontSize: 12
                                                    )),
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                ),
                SliverToBoxAdapter(
                    child: Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: (){
                            double width_pantalla = MediaQuery.of(context).size.width;
                            double padding_left = 32;
                            double padding_right = 32;
                            double width_table = padding_left + padding_right + 125;
                            for(double column_px in controller.tableTipoNotacolumnWidths){
                              width_table += column_px;
                            }
                            double width = 0;
                            if(width_pantalla>width_table){
                              width = width_pantalla;
                            }else{
                              width = width_table;
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                  Container(
                                    padding: EdgeInsets.only(left: padding_left, right: padding_right),
                                    width: width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          placeholder: (context, url) => Container(
                                            child: CircularProgressIndicator(),
                                          ),
                                          imageUrl: controller.evaluacionCapacidadUi.personaUi?.foto??"",
                                          errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                          imageBuilder: (context, imageProvider) =>
                                              Container(
                                                  width: 35,
                                                  height: 35,
                                                  margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(16)),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                              ),
                                        ),
                                        Expanded(child: Text((controller.evaluacionCapacidadUi.personaUi?.nombreCompleto??"").toUpperCase(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 12,
                                              letterSpacing: 0.8,
                                              color: AppTheme.darkerText,
                                            ))),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                      padding: EdgeInsets.only(top: 8)
                                  ),
                                if(controller.precision)
                                Container(
                                  width: width,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 85,
                                        height: 85,
                                        margin: EdgeInsets.only(bottom: 8),
                                        child: FDottedLine(
                                          color: AppTheme.greyLighten1,
                                          strokeWidth: 1.0,
                                          dottedLength: 5.0,
                                          space: 3.0,
                                          corner: FDottedLineCorner.all(30.0),
                                          child: Container(
                                            color: AppTheme.greyLighten2,
                                            child: _getTipoNota(controller.evaluacionCapacidadUi.valorTipoNotaUi, controller.tipoNotaUi,controller.evaluacionCapacidadUi.nota),
                                          ),

                                        ),
                                      ),
                                      Text(controller.evaluacionCapacidadUi.valorTipoNotaUi?.alias??"",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                            color: AppTheme.darkerText,
                                          )
                                      ),
                                    ],
                                  ),
                                ) ,
                                Container(
                                  width: width,
                                  padding: EdgeInsets.only(left: padding_left, top:24),
                                  child: showTableTipoNota(controller),
                                ),
                                Container(
                                  width: width_table - padding_right,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          height: 50,
                                          width: 80,
                                          padding: EdgeInsets.all(8),
                                          child: Center(
                                            child:  Text("Promedio ponderado", textAlign: TextAlign.center, style: TextStyle(color: AppTheme.darkText, fontWeight: FontWeight.w700, fontSize: 12 ),),
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(color: AppTheme.greyLighten2),
                                                left: BorderSide(color: AppTheme.greyLighten2),
                                              ),
                                              color: HexColor(controller.cursosUi.color1).withOpacity(0.1)
                                          )
                                      ),
                                      Container(
                                          height: 50,
                                          width: 71,
                                          padding: EdgeInsets.all(8),
                                          child: Center(
                                            child:  Text("${controller.evaluacionCapacidadUi.nota?.toStringAsFixed(1)??"-"}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),),
                                          ),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(color: AppTheme.greyLighten2),
                                                left: BorderSide(color: AppTheme.greyLighten2),
                                                right: BorderSide(color: AppTheme.greyLighten2),
                                                top: BorderSide(color: Colors.transparent),
                                              ),

                                              color:HexColor(controller.cursosUi.color1).withOpacity(0.1)
                                          )
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );

                          }(),
                        )
                    )
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(padding: EdgeInsets.only(bottom: 80))
                    ])
                ),/*
                SliverPadding(
                  padding: EdgeInsets.only(left: 24, right: 24),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(padding: EdgeInsets.only( top: 32)),
                          Text("${controller.cursosUi.nombreCurso??""} ${controller.cursosUi.gradoSeccion??""} - ${controller.cursosUi.nivelAcademico??""}", style: TextStyle( color: HexColor("#4B4D7D"),fontFamily: AppTheme.fontTTNorms, fontSize: 16, fontWeight: FontWeight.bold),),
                          Padding(padding: EdgeInsets.only( top: 16)),
                          Stack(
                            children: [
                              Container(
                                height: width/2.5,
                                decoration: BoxDecoration(
                                    color: HexColor(controller.cursosUi.color2),
                                    borderRadius: BorderRadius.circular(24) // use instead of BorderRadius.all(Radius.circular(20))
                                ),
                                child:  Padding(
                                  padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
                                  child:   Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${controller.evaluacionCapacidadUi.personaUi?.nombreCompleto?.toUpperCase()??""}",
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontTTNormsMedium,
                                                fontWeight: FontWeight.w700,
                                                fontSize: width/22,
                                                letterSpacing: 0.5,
                                                color: AppTheme.white,
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.only(top: 8)),
                                            Text(controller.evaluacionCapacidadUi.capacidadUi?.nombre??"",
                                              style: TextStyle(
                                                fontFamily: AppTheme.fontTTNormsLigth,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                                letterSpacing: 0.5,
                                                color: AppTheme.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.only(left: 16)),
                                      Expanded(
                                        flex: 2,
                                        child: Stack(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                AspectRatio(
                                                  aspectRatio: 1,
                                                  child: Container(
                                                    width: double.infinity,
                                                    child: Container(
                                                      padding: EdgeInsets.all(width/16),
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color:  HexColor(controller.cursosUi.color1).withOpacity(0.5)),
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text("AD",
                                                              style: TextStyle(
                                                                fontFamily: AppTheme.fontTTNormsMedium,
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: width/20,
                                                                letterSpacing: 0.5,
                                                                color: AppTheme.white,
                                                              ),
                                                            ),
                                                            Text("4.0",
                                                              style: TextStyle(
                                                                fontFamily: AppTheme.fontTTNormsMedium,
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: width/30,
                                                                letterSpacing: 0.5,
                                                                color: AppTheme.white,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color:  HexColor(controller.cursosUi.color2)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                AspectRatio(
                                                  aspectRatio: 1,
                                                  child: Container(
                                                    width: double.infinity,
                                                    child: CircularProgressIndicator(
                                                      value: 0.62,
                                                      backgroundColor: HexColor(controller.cursosUi.color3),
                                                      semanticsLabel: 'Linear progress indicator',
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                  right: 8,
                                  top: 0,
                                  bottom: 0,
                                  child: Container(
                                    height: width/2.8,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Container(
                                        width: double.infinity,
                                        child: Transform.rotate(
                                          angle: (62*3.6) * math.pi / 180,
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: width/22,
                                                  width: width/22,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.white, width: 2),
                                                      shape: BoxShape.circle,
                                                      color:  HexColor(controller.cursosUi.color3)),
                                                ),
                                                Expanded(child: Container())
                                              ],
                                            ),

                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.only( top: 200)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(),
                                ),
                                imageUrl: controller.evaluacionCapacidadUi.personaUi?.foto??"",
                                errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                        width: 35,
                                        height: 35,
                                        margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(16)),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                    ),
                              ),
                              Expanded(
                                  child: Text((controller.evaluacionCapacidadUi.personaUi?.nombreCompleto??"").toUpperCase(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                        letterSpacing: 0.8,
                                        color: AppTheme.darkerText,
                                      ))
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 8)
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 85,
                                    height: 85,
                                    margin: EdgeInsets.only(bottom: 4),
                                    child: FDottedLine(
                                      color: AppTheme.greyLighten1,
                                      strokeWidth: 1.0,
                                      dottedLength: 5.0,
                                      space: 3.0,
                                      corner: FDottedLineCorner.all(30.0),
                                      child: Container(
                                        color: AppTheme.greyLighten2,
                                        child: _getTipoNota(controller.evaluacionCapacidadUi.valorTipoNotaUi, controller.evaluacionCapacidadUi.nota),
                                      ),

                                    ),
                                  ),
                                  Text(controller.evaluacionCapacidadUi.valorTipoNotaUi?.alias??"",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        color: AppTheme.darkerText,
                                      )
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8, right: 0),
                                height: 65,
                                width: 2,
                              ),
                              Container(
                                width: 75,
                                height: 60,
                                child: Center(
                                  child: Text("${controller.evaluacionCapacidadUi.nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
                                    fontFamily: AppTheme.fontTTNormsMedium,
                                    fontSize: 24,
                                    color: AppTheme.darkerText,
                                  ),),
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                  ),
                ),*/
              ],
            ),
          );
        });
  }

  Widget showTableTipoNota(EvaluacionCapacidadController controller) {
    return SingleChildScrollView(
      child: StickyHeadersTableNotExpandedCustom(
          cellDimensions: CellDimensions.variableColumnWidth(
              stickyLegendHeight:45,
              stickyLegendWidth: 125,
              contentCellHeight: 75,
              columnWidths: controller.tableTipoNotacolumnWidths
          ),
          //cellAlignments: CellAlignments.,
          scrollControllers: crollControllers,
          columnsLength: controller.tableTipoNotaColumns.length,
          rowsLength: controller.rubricaEvaluacionList.length,
          columnsTitleBuilder: (i) {
            //#region columnsTitleBuilder
            var obj = controller.tableTipoNotaColumns[i];
              if(obj is String && obj == "peso"){
              return Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color:  AppTheme.greyLighten2),
                        ),
                        color: HexColor(controller.cursosUi.color1),
                      )
                  ),
                  Center(
                    child:  Text("Peso en la calificación", textAlign: TextAlign.center, style: TextStyle(color:  AppTheme.white, fontSize: 12, fontWeight: FontWeight.w700),),
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
                    child:  Text("Valor", textAlign: TextAlign.center, style: TextStyle(color:  AppTheme.textGrey, fontSize: 12, fontWeight: FontWeight.w700),),
                  )
                ],
              );
            }else if(obj is ValorTipoNotaUi){
              return InkWell(
                onDoubleTap: () =>  controller.onClikShowDialogClearEvaluacion(),
                onLongPress: () => controller.onClicEvaluacionAll(obj),
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
                    child:  Text("Nota", textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11,color: AppTheme.darkText ),),
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppTheme.greyLighten2),
                        right: BorderSide(color: AppTheme.greyLighten2),
                      ),
                      color: AppTheme.white
                  )
              );
            }else{
              return Container();
            }
            //#endregion
          },
          rowsTitleBuilder: (i) {
            RubricaEvaluacionUi rubricaEvaluacionUi = controller.rubricaEvaluacionList[i];

            return InkWell(
              onTap: (){

              },
              child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8, right: 4, top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text((rubricaEvaluacionUi.tituloRubroCabecera??rubricaEvaluacionUi.titulo?.trim()??""), maxLines: 2, overflow: TextOverflow.ellipsis ,style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 6),
                                  child:  (){
                                    switch(controller.evaluacionCapacidadUi.capacidadUi?.competenciaUi?.tipoCompetenciaUi??TipoCompetenciaUi.BASE){
                                      case TipoCompetenciaUi.BASE:
                                        return CachedNetworkImage(
                                          height: 12,
                                          width: 12,
                                          imageUrl: controller.evaluacionCapacidadUi.capacidadUi?.competenciaUi?.url??"",
                                          placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => SvgPicture.asset(AppIcon.ic_criterio_2, width: 12, height: 12,),
                                        );
                                      case TipoCompetenciaUi.TRANSVERSAL:
                                        return SvgPicture.asset(AppIcon.ic_transversal, width: 10, height: 10,);
                                      case TipoCompetenciaUi.ENFOQUE:
                                        return SvgPicture.asset(AppIcon.ic_enfoque, width: 10, height: 10,);
                                    }
                                  }(),
                                ),
                                Expanded(
                                  child: Text((rubricaEvaluacionUi.criterioUi?.icdTitulo?.trim()??""), maxLines: 3, overflow: TextOverflow.ellipsis ,style: TextStyle(fontSize: 10, color: AppTheme.textGrey),),
                                )
                              ],
                            ),
                          ),
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
                    color: ((rubricaEvaluacionUi.peso??0) > RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO)?null:AppTheme.red.withOpacity(0.1),
                  )
              ),
            );


          },
          contentCellBuilder: (i, j){
            dynamic o = controller.tableTipoNotaCells[j][i];
            if(o is EvaluacionPorcentajeUi){
              return InkWell(
                onTap: (){
                  showDialogPeso(controller, o.rubricaEvaluacionUi, o.capacidadUi);
                },
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if((o.rubricaEvaluacionUi?.peso??0) > RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO)
                      Padding(padding: EdgeInsets.all(8)),
                      if((o.rubricaEvaluacionUi?.peso??0) > RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO)
                      Text("${AppTools.removeDecimalZeroFormat((o.rubricaEvaluacionUi?.peso??0)/(o.capacidadUi?.total_peso??1)*100, fractionDigits: 2)}%", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: AppTheme.fontTTNormsMedium,),),
                      Padding(padding: EdgeInsets.all(2)),
                      Text((){
                        if((o.rubricaEvaluacionUi?.peso??0) > RubricaEvaluacionUi.PESO_ALTO){
                          return "P. Desconocido";
                        }if(o.rubricaEvaluacionUi?.peso == RubricaEvaluacionUi.PESO_ALTO){
                          return "P. Alto";
                        }else if(o.rubricaEvaluacionUi?.peso == RubricaEvaluacionUi.PESO_NORMAL){
                          return "P. Normal";
                        }else if(o.rubricaEvaluacionUi?.peso == RubricaEvaluacionUi.PESO_BAJO){
                          return "P. Bajo";
                        }else{
                          return "No usar\ncriterio";
                        }
                      }(),  textAlign: TextAlign.center,style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),),

                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppTheme.greyLighten2),
                      right: BorderSide(color: AppTheme.greyLighten2),
                      bottom: BorderSide(color: AppTheme.greyLighten2.withOpacity((controller.tableTipoNotaCells.length-1) <= j ? 1:0)),
                    ),
                    color:  ((o.rubricaEvaluacionUi?.peso??0) > RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO)?HexColor(controller.cursosUi.color2).withOpacity(0.1):AppTheme.red.withOpacity(0.1),
                  ),
                ),
              );
            }else if(o is RubricaEvaluacionTotalUi){
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${AppTools.removeDecimalZeroFormat(o.total,fractionDigits: 3)??"-"}", style: TextStyle(fontSize: 14, color: AppTheme.textGrey, fontWeight: FontWeight.w400, fontFamily: AppTheme.fontTTNormsMedium,),),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.greyLighten2),
                    right: BorderSide(color: AppTheme.greyLighten2),
                    bottom: BorderSide(color: AppTheme.greyLighten2.withOpacity((controller.tableTipoNotaCells.length-1) <= j ? 1:0)),
                  ),
                  color: ((o.evaluacionUi?.rubroEvaluacionUi?.peso??0) > RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO)?AppTheme.greyLighten4:AppTheme.red.withOpacity(0.1),
                ),
              );
            }else if(o is EvaluacionRubricaValorTipoNotaUi){
              return InkWell(
                onTap: () {

                  if((o.evaluacionTransformadaUi?.personaUi?.contratoVigente == true)){
                    if(controller.precision && (o.valorTipoNotaUi?.tipoNotaUi?.intervalo??false)){
                      showDialogPresicion(controller, o, i);
                    } else{
                      controller.onClicEvaluar(o); 
                    }
                  }else{
                    controller.showControNoVigente();
                  }
                },
                onLongPress: (){
                  if((o.evaluacionTransformadaUi?.personaUi?.contratoVigente == true)){
                    if(o.valorTipoNotaUi?.tipoNotaUi?.intervalo??false){

                    }
                    else{
                      showDialogTecladoPrecicion(controller, controller.tipoNotaUi, o.evaluacionTransformadaUi);
                    }
                  }
                },
                child: Stack(
                  children: [
                    _getTipoNotaDetalle(o, controller,i, j),
                    Positioned(
                        bottom: 4,
                        right: 4,
                        child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 14,)
                    ),
                  ],
                ),
              );
            } else if(o is EvaluacionTransformadaUi){
              return InkWell(
                //onTap: () => _evaluacionCapacidadRetornar(context, controller, o),
                child: Stack(
                  children: [
                    Container(
                      constraints: BoxConstraints.expand(),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppTheme.greyLighten2),
                          right: BorderSide(color:  AppTheme.greyLighten2),
                        ),
                          color: _getColorAlumnoBloqueados(o.personaUi, 0)
                      ),
                      child: Center(
                        child: Text("${o.nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
                          fontFamily: AppTheme.fontTTNormsMedium,
                          fontSize: 14,
                        ),),
                      ),
                    ),
                    Positioned(
                        bottom: 4,
                        right: 4,
                        child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 14,)
                    ),
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
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Criterios evaluados", style: TextStyle(color: AppTheme.white, fontSize: 12, fontWeight: FontWeight.w700))
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
    Widget? widget = null;
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
                  fontFamily: AppTheme.fontTTNormsMedium,
                  fontSize: 14,
                  color: color_texto
              )),
        );
        break;
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        widget = Opacity(
          opacity: (evaluacionRubricaValorTipoNotaUi.toggle??false)? 1 : 0.5,
          child: Container(
            padding: EdgeInsets.all(4),
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
        double? nota = null;
        if(evaluacionRubricaValorTipoNotaUi.toggle??false)nota = evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.nota;
        else nota = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorNumerico??0;
        widget = Center(
          child: Text("${nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
              fontFamily: AppTheme.fontTTNormsMedium,
              fontSize: 14,
              color: color_texto
          ),),
        );
        break;
    }

    if(!(evaluacionRubricaValorTipoNotaUi.toggle??false)){
      if((evaluacionRubricaValorTipoNotaUi.evaluacionTransformadaUi?.rubroEvaluacionUi?.peso ??0) <= RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO){
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
                    fontFamily: AppTheme.fontTTNormsMedium,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color,
                  )),
              Padding(padding: EdgeInsets.all(2),),
              Text("${(nota??0).toStringAsFixed(1)}",
                  style: TextStyle(
                    fontFamily: AppTheme.fontTTNormsMedium,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ))
            ],
          ),
        );
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        return Container(
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
          child: Text("${(nota??0).toStringAsFixed(1)}", style: TextStyle(
            fontFamily: AppTheme.fontTTNormsMedium,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),),
        );
    }
  }

  Widget _getTipoNotaCabecera(ValorTipoNotaUi? valorTipoNotaUi,EvaluacionCapacidadController controller, int position) {
    Widget? nota = null;
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
                    fontFamily: AppTheme.fontTTNormsMedium,
                    fontSize: 16,
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
              margin: EdgeInsets.only(top: 4),
              child: Text("${(valorTipoNotaUi?.valorNumerico??0).toStringAsFixed(1)}", style: TextStyle(
                  fontFamily: AppTheme.fontTTNormsMedium,
                  fontSize: 12,
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

    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return TecladoPresicionView(
            valorMaximo: tipoNotaUi?.escalavalorMaximo,
            valorMinimo: tipoNotaUi?.escalavalorMinimo,
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
            selectedValue: rubricaEvaluacionUi?.peso??RubricaEvaluacionUi.PESO_NORMAL,
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

}