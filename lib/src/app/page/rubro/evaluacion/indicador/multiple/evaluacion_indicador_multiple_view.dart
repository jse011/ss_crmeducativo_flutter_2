import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_not_expanded_custom.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/indicador/multiple/evaluacion_indicador_multiple_controller.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/presicion/precision_view.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_publicado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_formula_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';

class EvaluacionIndicadorMultipleView extends View{
  String? rubroEvaluacionId;
  CursosUi? cursosUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;

  EvaluacionIndicadorMultipleView(this.rubroEvaluacionId, this.cursosUi, this.calendarioPeriodoUI);

  @override
  _EvaluacionIndicadorMultiplePortalState createState() => _EvaluacionIndicadorMultiplePortalState(rubroEvaluacionId, cursosUi, calendarioPeriodoUI);

}

class _EvaluacionIndicadorMultiplePortalState extends ViewState<EvaluacionIndicadorMultipleView, EvaluacionIndicadorMultipleController> with TickerProviderStateMixin{
  ScrollControllers crollController = ScrollControllers();
  double? offset = 0.0;
  late final ScrollControllers scrollControllers = ScrollControllers();

  _EvaluacionIndicadorMultiplePortalState(rubroEvaluacionId, cursosUi,calendarioPeriodoUI) : super(EvaluacionIndicadorMultipleController(rubroEvaluacionId, cursosUi, calendarioPeriodoUI, MoorRubroRepository(), MoorConfiguracionRepository(), DeviceHttpDatosRepositorio()));
  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  Function()? statetDialogPresion;
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
  Widget get view => ControlledWidgetBuilder<EvaluacionIndicadorMultipleController>(
      builder: (context, controller) {
          return WillPopScope (
            onWillPop: () async {
              if(!controller.tipoMatriz){
                controller.onClicVolverMatriz();
                scrollController.jumpTo(offset??0.0);
                return false;
              }else{
                bool  se_a_modicado = await controller.onSave();
                if(se_a_modicado){
                  Navigator.of(context).pop(1);//si devuelve un entero se actualiza toda la lista;
                  return false;
                }else{
                  return true;
                }
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
                                                child: Text("Eliminar evaluación", style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: AppTheme.fontTTNormsMedium
                                                ),),
                                              ),
                                              Padding(padding: EdgeInsets.all(4),),
                                              Text("¿Esta seguro de eliminar la evaluación?. Recuerde que si elimina se borrará permanentemente las calificaciones.",
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
                                          await controller.onClickAceptarEliminar();
                                          Navigator.of(context).pop(1);//si devuelve un entero se actualiza toda la lista
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
                  ],
                ),
              ),
            ),
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
                        child:   ControlledWidgetBuilder<EvaluacionIndicadorMultipleController>(
                          builder: (context, controller) {
                            return Stack(
                              children: <Widget>[
                                Positioned(
                                    child:  IconButton(
                                      icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                                      onPressed: () async {
                                        if(!controller.tipoMatriz){
                                          controller.onClicVolverMatriz();
                                          scrollController.jumpTo(offset??0.0);
                                        }else{
                                          bool?  respuesta = await controller.onSave();
                                          Navigator.of(context).pop(1);//si devuelve un entero se actualiza toda la lista
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
                                              controller.rubroEvaluacionUi?.titulo??"",
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
    return ControlledWidgetBuilder<EvaluacionIndicadorMultipleController>(
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
                  padding: EdgeInsets.only(left: 8, right: 8, bottom: 16),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: EdgeInsets.only( top: 8, left: 16, right: 16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child:  Container(
                                          padding: EdgeInsets.all(8),
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
                                Padding(padding: EdgeInsets.all(4)),
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
                                        child:  Container(
                                          padding: EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Ionicons.pencil, color: AppTheme.colorAccent, size: 20,),
                                              Padding(padding: EdgeInsets.all(2),),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text("Modificar",
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
                                    Expanded(
                                        child: InkWell(
                                          onTap: (){
                                            controller.onClickEliminar();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(Ionicons.trash, color: AppTheme.colorAccent, size: 20,),
                                                Padding(padding: EdgeInsets.all(2),),
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text("Eliminar",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          letterSpacing: 0.5,
                                                          color: AppTheme.colorPrimary,
                                                          fontSize: 12
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                ),
                controller.tipoMatriz?
                SliverToBoxAdapter(
                  child: showTableRubrica(controller),
                ): SliverToBoxAdapter(
                  child: Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: (){

                        double width_pantalla = MediaQuery.of(context).size.width;
                        double padding_left = 32;
                        double padding_right = 32;
                        double width_table = padding_left + padding_right + 25;
                        for(double column_px in controller.tablecolumnWidths){
                          width_table += column_px;
                        }
                        double width = 0;
                        if(width_pantalla>width_table){
                          width = width_pantalla;
                        }else{
                          width = width_table;
                        }

                        return Container(
                          width: width,
                          child: ListView.builder
                            ( primary: false,
                              shrinkWrap: true,
                              itemCount: controller.alumnoCursoList.length,
                              itemBuilder: (BuildContext ctxt, int index){
                                PersonaUi personaUi = controller.alumnoCursoList[index];
                                EvaluacionUi? evaluacionGeneralUi = controller.getEvaluacionGeneralPersona(personaUi);

                                return Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: width,
                                        padding: EdgeInsets.only(left: padding_left, right: padding_right),
                                        child:  Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            CachedNetworkImage(
                                              placeholder: (context, url) => Container(
                                                child: CircularProgressIndicator(),
                                              ),
                                              imageUrl: personaUi.foto??"",
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
                                                child: Text((personaUi.nombreCompleto??"").toUpperCase(),
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
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 8)
                                      ),

                                      Container(
                                        width: width,
                                        padding: EdgeInsets.only(left: padding_left, right: padding_right),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  width: 55,
                                                  height: 55,
                                                  margin: EdgeInsets.only(bottom: 4),
                                                  child: FDottedLine(
                                                    color: AppTheme.greyLighten1,
                                                    strokeWidth: 1.0,
                                                    dottedLength: 5.0,
                                                    space: 3.0,
                                                    corner: FDottedLineCorner.all(30.0),
                                                    child: Container(
                                                      color: AppTheme.greyLighten2,
                                                      child: (){
                                                        //#region Nota
                                                        Color color;
                                                        if (("B" == (evaluacionGeneralUi?.valorTipoNotaUi?.titulo??"") || "C" == (evaluacionGeneralUi?.valorTipoNotaUi?.titulo??""))) {
                                                          color = AppTheme.redDarken4;
                                                        }else if (("AD" == (evaluacionGeneralUi?.valorTipoNotaUi?.titulo??"")) || "A" == (evaluacionGeneralUi?.valorTipoNotaUi?.titulo??"")) {
                                                          color = AppTheme.blueDarken4;
                                                        }else {
                                                          color = AppTheme.black;
                                                        }

                                                        switch(evaluacionGeneralUi?.valorTipoNotaUi?.tipoNotaUi?.tipoNotaTiposUi) {
                                                          case TipoNotaTiposUi.SELECTOR_VALORES:
                                                            return Container(
                                                              child: Center(
                                                                child: Text(evaluacionGeneralUi?.valorTipoNotaUi?.titulo ?? "",
                                                                    style: TextStyle(
                                                                        fontFamily: AppTheme.fontTTNormsMedium,
                                                                        fontSize: 22,
                                                                        color: color
                                                                    )),
                                                              ),
                                                            );
                                                          case TipoNotaTiposUi.SELECTOR_ICONOS:
                                                            return Container(
                                                              child: CachedNetworkImage(
                                                                imageUrl: evaluacionGeneralUi?.valorTipoNotaUi?.icono ?? "",
                                                                placeholder: (context, url) => Stack(
                                                                  children: [
                                                                    CircularProgressIndicator()
                                                                  ],
                                                                ),
                                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                                              ),
                                                            );
                                                          case TipoNotaTiposUi.SELECTOR_NUMERICO:
                                                          case TipoNotaTiposUi.VALOR_NUMERICO:
                                                          case TipoNotaTiposUi.VALOR_ASISTENCIA:
                                                            return Center(
                                                              child: Text("${(evaluacionGeneralUi?.valorTipoNotaUi?.valorNumerico??0).toStringAsFixed(1)}", style: TextStyle(
                                                                  fontFamily: AppTheme.fontTTNormsMedium,
                                                                  fontSize: 16,
                                                                  color: AppTheme.textGrey),
                                                              ),
                                                            );
                                                          default:
                                                            return Center(
                                                              child: Text("", style: TextStyle(
                                                                  fontFamily: AppTheme.fontTTNormsMedium,
                                                                  fontSize: 14,
                                                                  color: AppTheme.textGrey
                                                              ),),
                                                            );
                                                        }
                                                        //#endregion
                                                      }(),
                                                    ),

                                                  ),
                                                ),
                                                Text(evaluacionGeneralUi?.valorTipoNotaUi?.alias??"",
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
                                                child: Text("${evaluacionGeneralUi?.nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
                                                  fontFamily: AppTheme.fontTTNormsMedium,
                                                  fontSize: 24,
                                                  color: AppTheme.darkerText,
                                                ),),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                        Padding(
                                            padding: EdgeInsets.only(top: 16)
                                        ),
                                      Center(
                                        child: Container(
                                          width: width_table,
                                          padding: EdgeInsets.only(left: padding_left, right: padding_right),
                                          child:  showTableRubroDetalle(controller, personaUi),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 28)
                                      ),
                                      Container(
                                        width: width,
                                        padding: EdgeInsets.only(left: padding_left, right: padding_right),
                                        child: Text("Comentarios privados(Sólo lo ve el padre)",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: AppTheme.colorPrimary
                                            )
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 8)
                                      ),
                                      Container(
                                        width: width,
                                        padding: EdgeInsets.only(left: padding_left, right: padding_right),
                                        child: Row(
                                          children: [
                                            CachedNetworkImage(
                                              placeholder: (context, url) => Container(
                                                child: CircularProgressIndicator(),
                                              ),
                                              imageUrl: controller.usuarioUi?.foto??"",
                                              errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                              imageBuilder: (context, imageProvider) =>
                                                  Container(
                                                      width: 50,
                                                      height: 50,
                                                      margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(25)),
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                  ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child:  Container(
                                                        padding: EdgeInsets.only(left: 8, right: 8),
                                                        decoration: BoxDecoration(
                                                          color: AppTheme.greyLighten3,
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          border: Border.all(color: AppTheme.greyLighten1),
                                                        ),
                                                        child: TextField(
                                                          keyboardType: TextInputType.multiline,
                                                          maxLines: null,
                                                          decoration: InputDecoration(
                                                              hintText: "",
                                                              hintStyle: TextStyle( color: Colors.blueAccent),
                                                              border: InputBorder.none),
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      // You enter here what you want the button to do once the user interacts with it
                                                    },
                                                    icon: Icon(
                                                      Icons.send,
                                                      color: AppTheme.greyDarken1,
                                                    ),
                                                    iconSize: 20.0,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 16)
                                      ),
                                      Container(
                                        width: width,
                                        padding: EdgeInsets.only(left: padding_left, right: padding_right),
                                        child: Text("Evidencias (Sólo lo ve el padre)",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: AppTheme.colorPrimary
                                            )
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 8)
                                      ),
                                      Container(
                                        width: width,
                                        padding: EdgeInsets.only(left: padding_left, right: padding_right),
                                        child: Row(
                                          children: [
                                            FloatingActionButton(
                                              heroTag: "btn_${personaUi.personaId??""}",
                                              onPressed: () {},
                                              elevation: 0,
                                              child: Icon(Icons.add,),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 48)
                                      ),
                                    ],
                                  ),
                                );
                              }
                          ),
                        );
                      }(),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget showTableRubrica(EvaluacionIndicadorMultipleController controller) {
    List<double> tablecolumnWidths = [];
    for(dynamic s in controller.columnList2){
      if(s is ContactoUi){
        tablecolumnWidths.add(95.0);
      } else if(s is EvaluacionUi){
        tablecolumnWidths.add(50);
      }else if(s is EvaluacionPublicadoUi){
        tablecolumnWidths.add(40);
      }else{
        tablecolumnWidths.add(70.0);
      }
    }
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 8, ),
            child: SingleChildScrollView(
              child: StickyHeadersTableNotExpandedCustom(
                cellDimensions: CellDimensions.variableColumnWidth(
                    stickyLegendHeight:125,
                    stickyLegendWidth: 65,
                    contentCellHeight: 45,
                    columnWidths: tablecolumnWidths
                ),
                //cellAlignments: CellAlignments.,
                scrollControllers: scrollControllers,
                columnsLength: controller.columnList2.length,
                rowsLength: controller.rowList2.length,
                columnsTitleBuilder: (i) {
                  dynamic o = controller.columnList2[i];
                  if(o is ContactoUi){
                    return Container(
                        constraints: BoxConstraints.expand(),
                        child: Center(
                          child:  Text("Apellidos y\n Nombres", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.white ),),
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppTheme.lightBlueAccent4),
                              right: BorderSide(color:AppTheme.lightBlueAccent4),
                            ),
                            color: AppTheme.lightBlueAccent4
                        )
                    );
                  }else if(o is EvaluacionUi){
                    return Container(
                        constraints: BoxConstraints.expand(),
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child:  RotatedBox(
                            quarterTurns: -1,
                            child: Text("Nota Final", textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,color: AppTheme.darkText ),),
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppTheme.greyLighten2),
                              right: BorderSide(color: AppTheme.greyLighten2),
                            ),
                            color: AppTheme.greyLighten4
                        )
                    );
                  }else if(o is RubricaEvaluacionUi){
                    return Container(
                        constraints: BoxConstraints.expand(),
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child:  RotatedBox(
                            quarterTurns: -1,
                            child: Text(o.titulo??"", textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11,color:  AppTheme.lightBlueAccent4 ),),
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppTheme.greyLighten2),
                              right: BorderSide(color: AppTheme.greyLighten2),
                            ),
                            color: AppTheme.white
                        )
                    );
                  }else if(o is EvaluacionPublicadoUi){
                    return InkWell(
                      onTap: (){
                        controller.onClicPublicadoAll(o);


                      },
                      child: Container(
                          constraints: BoxConstraints.expand(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 8),
                                child: Icon(Ionicons.globe_outline, size: 30, color:o.publicado? AppTheme.colorAccent:AppTheme.grey ),
                              ),

                            ],
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppTheme.greyLighten2),
                                right: BorderSide(color: AppTheme.greyLighten2),
                              ),
                              color: AppTheme.white
                          )
                      ),
                    );
                  }else
                    return Container();
                },
                rowsTitleBuilder: (i) {
                  dynamic o = controller.rowList2[i];
                  if(o is PersonaUi){
                    return  Container(
                        constraints: BoxConstraints.expand(),
                        child: Row(
                          children: [
                            Padding(padding: EdgeInsets.all(4)),
                            Expanded(
                                child: Text((i+1).toString() + ".", style: TextStyle(color: AppTheme.darkText, fontSize: 12),)
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              margin: EdgeInsets.only(right: 3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.greyLighten2,
                              ),
                              child: true?
                              CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(),
                                ),
                                imageUrl: o.foto??"",
                                errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                    ),
                              ):
                              Container(),
                            ),
                            Padding(padding: EdgeInsets.all(1)),
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppTheme.greyLighten2),
                              right: BorderSide(color: AppTheme.greyLighten2),
                              left: BorderSide(color: AppTheme.greyLighten2),
                            ),
                            color: AppTheme.white
                        )
                    );
                  }else{
                    return  Container();
                  }
                },
                contentCellBuilder: (i, j){
                  dynamic o = controller.cellListList[j][i];
                  if(o is PersonaUi){
                    return Container(
                        constraints: BoxConstraints.expand(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(o.nombreCompleto??"", maxLines: 1, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppTheme.black),),
                            Text(o.apellidos??"", maxLines: 1, textAlign: TextAlign.center,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10),),
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppTheme.greyLighten2),
                              right: BorderSide(color:  AppTheme.greyLighten2),
                            ),
                            color: _getColorAlumnoBloqueados(o, 0)
                        )
                    );
                  }else if(o is EvaluacionUi && i == 1){
                    return InkWell(
                      onTap: () {
                        if(o.personaUi?.contratoVigente??true){
                          offset = scrollController.offset;
                          scrollController.jumpTo(0.0);
                          controller.onClicEvaluacionRubrica(o);
                        }else{
                          _showControNoVigente(context, o.personaUi);
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
                                ),
                                color: _getColorAlumnoBloqueados(o.personaUi, 0, c_default: AppTheme.greyLighten4)
                            ),
                            child: _getTipoNota(o, o.nota, controller),
                          ),
                          controller.calendarioPeriodoUI?.habilitado==1?Container():
                          Positioned(
                              bottom: 4,
                              right: 4,
                              child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 14,)
                          ),
                        ],
                      ),
                    );
                  }else if(o is EvaluacionUi){
                    return InkWell(
                      onTap: () {
                        if(o.personaUi?.contratoVigente??true){
                          offset = scrollController.offset;
                          scrollController.jumpTo(0.0);
                          controller.onClicEvaluacionRubrica(o);
                        }else{
                          _showControNoVigente(context, o.personaUi);
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
                                ),
                                color: _getColorAlumnoBloqueados(o.personaUi, 0)
                            ),
                            child: _getTipoNota(o, o.nota, controller),
                          ),
                          controller.calendarioPeriodoUI?.habilitado==1?Container():
                          Positioned(
                              bottom: 4,
                              right: 4,
                              child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 14,)
                          ),
                        ],
                      ),
                    );
                  }else if(o is EvaluacionPublicadoUi){
                    return InkWell(
                      onTap: (){
                        if(o.evaluacionUi?.personaUi?.contratoVigente??true){
                          controller.onClicPublicado(o);
                        }else{
                          _showControNoVigente(context, o.evaluacionUi?.personaUi);
                        }

                      },
                      child:  Container(
                        constraints: BoxConstraints.expand(),
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppTheme.greyLighten2),
                              right: BorderSide(color:  AppTheme.greyLighten2),
                            ),
                            color: _getColorAlumnoBloqueados(o.evaluacionUi?.personaUi, 0)
                        ),
                        child: Container(
                          child: Icon(Ionicons.globe_outline, size: 30, color:o.publicado? AppTheme.colorAccent:AppTheme.grey ),
                        ),
                      ),
                    );
                  }else{
                    return Container();
                  }

                },
                legendCell: Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: AppTheme.lightBlueAccent4,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(16))
                        )
                    ),
                    Container(
                        child: Center(
                          child: Text('N°', style: TextStyle(color: AppTheme.white, fontWeight: FontWeight.w700),),
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: AppTheme.lightBlueAccent4),
                          ),
                        )
                    ),

                  ],
                ),
              ),
            ),

          );
        }
      },
    );

  }

  Widget showTableRubroDetalle(EvaluacionIndicadorMultipleController controller, PersonaUi personaUi) {

    return SingleChildScrollView(
      child: StickyHeadersTableNotExpandedCustom(
        cellDimensions: CellDimensions.variableColumnWidth(
            stickyLegendHeight:45,
            stickyLegendWidth: 25,
            contentCellHeight: 45,
            columnWidths: controller.tablecolumnWidths
        ),
        //cellAlignments: CellAlignments.,
        scrollControllers: ScrollControllers() ,
        columnsLength: controller.mapColumnList[personaUi]?.length??0,
        rowsLength: controller.mapRowList[personaUi]?.length??0,
        columnsTitleBuilder: (i) {
          dynamic o = controller.mapColumnList[personaUi]![i];
          if(o is EvaluacionUi){
            return Container(
                constraints: BoxConstraints.expand(),
                padding: EdgeInsets.all(8),
                child: Center(
                  child:  RotatedBox(
                    quarterTurns: -1,
                    child: Text(" ", textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11,color: AppTheme.darkText ),),
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppTheme.greyLighten2),
                      right: BorderSide(color: AppTheme.greyLighten2),
                    ),
                    color: AppTheme.red
                )
            );
          }else if(o is ValorTipoNotaUi){
            return InkWell(
              onDoubleTap: () =>  controller.onClicClearEvaluacionAll(o, personaUi),
              onLongPress: () =>  controller.onClicEvaluacionAll(o, personaUi),
              child: Stack(
                children: [
                  _getTipoNotaCabeceraV2(o, controller)
                ],
              ),
            );
          }else if(o is RubricaEvaluacionUi){
            return Container(
                constraints: BoxConstraints.expand(),
                padding: EdgeInsets.all(0),
                child: Center(
                  child: Text("Indicadores",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 11,
                        color:  AppTheme.white
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.colorPrimary),
                    right: BorderSide(color: AppTheme.colorPrimary),
                  ),
                  color: AppTheme.colorPrimary,
                )
            );
          }else if(o is RubricaEvaluacionFormulaPesoUi){
            return Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: AppTheme.greyLighten2.withOpacity(0.5),
                        borderRadius: BorderRadius.only(topRight: Radius.circular(8))
                    )
                ),
                Container(
                    child: Center(
                      child: Text('%', style: TextStyle(color: AppTheme.darkerText, fontSize: 14),),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: AppTheme.greyLighten2),
                      ),
                    )
                ),

              ],
            );
          }else
            return Container();
        },
        rowsTitleBuilder: (i) {
          return  Container(
              constraints: BoxConstraints.expand(),
              child: Center(
                child: Text((i+1).toString() + ".", style: TextStyle(color: AppTheme.greyDarken1, fontSize: 12)),
              ),
              decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.greyLighten2),
                    right: BorderSide(color: AppTheme.greyLighten2),
                    left: BorderSide(color: AppTheme.greyLighten2),
                    bottom: BorderSide(color: AppTheme.greyLighten2.withOpacity((controller.mapRowList[personaUi]?.length??0)-1 == i?1:0)),
                  ),
                  color: AppTheme.white
              )
          );
        },
        contentCellBuilder: (i, j){
          dynamic o = controller.mapCellListList[personaUi]![j][i];
          if(o is RubricaEvaluacionUi){
            return Container(
                constraints: BoxConstraints.expand(),
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Center(
                    child: Text(o.titulo??"",
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 10,
                          color:  AppTheme.colorAccent,
                          height: 1.2
                      ),
                    )
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.greyLighten2),
                    right: BorderSide(color:  AppTheme.greyLighten2),
                    bottom:  BorderSide(color:  AppTheme.greyLighten2.withOpacity((controller.mapCellListList[personaUi]!.length-1) <= j ? 1:0)),
                  ),
                )
            );
          }else if(o is EvaluacionRubricaValorTipoNotaUi){
            return InkWell(
              onTap: () {
                if(o.evaluacionUi?.personaUi?.contratoVigente??true){
                  if(controller.precision && (o.valorTipoNotaUi?.tipoNotaUi?.intervalo??false))
                    showDialogPresicion(controller, o, i, personaUi);
                  else
                    controller.onClicEvaluar(o, personaUi);
                }else{
                  _showControNoVigente(context, o.evaluacionUi?.personaUi);
                }

              },
              child: Stack(
                children: [
                  _getTipoNotaV2(o, controller, controller.mapCellListList[personaUi]?.length,i, j),
                  controller.calendarioPeriodoUI?.habilitado==1?Container():
                  Positioned(
                      bottom: 4,
                      right: 4,
                      child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 14,)
                  ),
                ],
              ),
            );
          }else if(o is EvaluacionUi){
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
                          bottom:  BorderSide(color:  AppTheme.greyLighten2.withOpacity((controller.mapCellListList[personaUi]!.length-1) <= j ? 1:0)),
                        ),
                        color: _getColorAlumnoBloqueados(o.personaUi, 0)
                    ),
                    //child: _getTipoNota(o.valorTipoNotaUi, o.nota, i),
                  ),
                  controller.calendarioPeriodoUI?.habilitado==1?Container():
                  Positioned(
                      bottom: 4,
                      right: 4,
                      child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 14,)
                  ),
                ],
              ),
            );
          }else if(o is RubricaEvaluacionFormulaPesoUi){
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
                          bottom:  BorderSide(color:  AppTheme.greyLighten2.withOpacity((controller.mapCellListList[personaUi]!.length-1) <= j ? 1:0)),
                        ),
                        color: AppTheme.white
                    ),
                    child: Center(
                      child: Text("${(o.formula_peso).toStringAsFixed(0)}%", textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14,color:  AppTheme.greyDarken1 ),
                      ),
                    ),
                  ),
                  controller.calendarioPeriodoUI?.habilitado==1?Container():
                  Positioned(
                      bottom: 4,
                      right: 4,
                      child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 14,)
                  ),
                ],
              ),
            );
          }else
            return Container();
        },
        legendCell: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: AppTheme.colorPrimary,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8))
                )
            ),
            Container(
                child: Center(
                  child: Text('N°', style: TextStyle(color: AppTheme.white, fontSize: 11),),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: AppTheme.colorPrimary),
                  ),
                )
            ),

          ],
        ),
      ),
    );

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

  Widget? _getTipoNota(EvaluacionUi? evaluacionUi, double? nota, EvaluacionIndicadorMultipleController controller) {
    var tipo =TipoNotaTiposUi.VALOR_NUMERICO;
    if(!controller.precision) tipo = evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO;

    switch(tipo){
      case TipoNotaTiposUi.SELECTOR_VALORES:
        Color color;
        if (("B" == (evaluacionUi?.valorTipoNotaUi?.titulo??"") || "C" == (evaluacionUi?.valorTipoNotaUi?.titulo??""))) {
          color = AppTheme.redDarken4;
        }else if (("AD" == (evaluacionUi?.valorTipoNotaUi?.titulo??"")) || "A" == (evaluacionUi?.valorTipoNotaUi?.titulo??"")) {
          color = AppTheme.blueDarken4;
        }else {
          color = AppTheme.black;
        }
        return Center(
          child: Text(evaluacionUi?.valorTipoNotaUi?.titulo??"-",
              style: TextStyle(
                  fontFamily: AppTheme.fontTTNormsMedium,
                  fontSize: 14,
                  color: color
              )),
        );
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        if(evaluacionUi?.valorTipoNotaUi!=null){
          return Container(
            child:  CachedNetworkImage(
              imageUrl: evaluacionUi?.valorTipoNotaUi?.icono??"",
              placeholder: (context, url) => Stack(
                children: [
                  CircularProgressIndicator()
                ],
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        }else{
          return Center(
            child: Text("-",
                style: TextStyle(
                    fontFamily: AppTheme.fontTTNormsMedium,
                    fontSize: 14,
                    color: AppTheme.black
                )),
          );
        }

      case TipoNotaTiposUi.VALOR_ASISTENCIA:
      case TipoNotaTiposUi.VALOR_NUMERICO:
      case TipoNotaTiposUi.SELECTOR_NUMERICO:
        if(nota == 0){
          if(evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES ||
              evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
            if(evaluacionUi?.valorTipoNotaUi?.tipoNotaId == null){
              nota = null;
            }
          }
        }
        return Center(
          child: Text("${nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
              fontFamily: AppTheme.fontTTNormsMedium,
              fontSize: 14
          ),),
        );
    }

  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  Widget _getTipoNotaV2(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, EvaluacionIndicadorMultipleController controller,int? length ,int positionX, int positionY) {
    Widget? widget = null;

    Color color_fondo;
    Color? color_texto;
    Color color_borde;

    if(positionX == 1){
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#1976d2");
        color_texto = AppTheme.white;
        color_borde = HexColor("#1976d2");
      }else{
        color_fondo = AppTheme.white;
        color_texto = HexColor("#1976d2");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 2){
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#388e3c");
        color_texto = AppTheme.white;
        color_borde = HexColor("#388e3c");
      }else{
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#388e3c");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 3){
      if(evaluacionRubricaValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#FF6D00");
        color_texto = AppTheme.white;
        color_borde = HexColor("#FF6D00");
      }else{
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#FF6D00");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 4){
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
        color_borde = AppTheme.greyLighten2;
      }else{
        color_fondo = AppTheme.white;
        color_texto = null;
        color_borde = AppTheme.greyLighten2;
      }
    }

    color_fondo = color_fondo.withOpacity(0.8);
    color_borde = AppTheme.greyLighten2.withOpacity(0.8);

    var tipo =TipoNotaTiposUi.VALOR_NUMERICO;
    if(!controller.precision) tipo = evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO;
    switch(tipo){
      case TipoNotaTiposUi.SELECTOR_VALORES:
        widget = Center(
          child: Text(evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.titulo??"",
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
                  CircularProgressIndicator()
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
        if(evaluacionRubricaValorTipoNotaUi.toggle??false)nota = evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota;
        else nota = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorNumerico;

        if(nota == 0){
          if(evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES ||
              evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
            if(evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.tipoNotaId == null){
              nota = null;
            }
          }
        }
        widget = Center(
          child: Text("${nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
              fontFamily: AppTheme.fontTTNormsMedium,
              fontSize: 14,
              color: color_texto
          ),),
        );;
        break;
    }

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.greyLighten2),
            right: BorderSide(color:  color_borde),
            bottom:  BorderSide(color:  AppTheme.greyLighten2.withOpacity(((length??0)-1) <= positionY ? 1:0)),
          ),
          color: (evaluacionRubricaValorTipoNotaUi.toggle??false)?color_fondo:_getColorAlumnoBloqueados(evaluacionRubricaValorTipoNotaUi.evaluacionUi?.personaUi, 0)
      ),
      child: widget,
    );

  }

  Widget _getTipoNotaCabeceraV2(ValorTipoNotaUi? valorTipoNotaUi,EvaluacionIndicadorMultipleController controller) {
    Widget? nota = null;
    Color color_fondo;
    Color? color_texto;
    int position = 0;

    for(ValorTipoNotaUi item in valorTipoNotaUi?.tipoNotaUi?.valorTipoNotaList??[]){
      position++;
      if(valorTipoNotaUi?.valorTipoNotaId == item.valorTipoNotaId)break;
    }

    if(position == 1){
      color_fondo = HexColor("#1976d2");
      color_texto = AppTheme.white;
    }else if(position == 2){
      color_fondo =  HexColor("#388e3c");
      color_texto = AppTheme.white;
    }else if(position == 3){
      color_fondo =  HexColor("#FF6D00");
      color_texto = AppTheme.white;
    }else if(position == 4){
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
                CircularProgressIndicator()
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
              child: Text("${valorTipoNotaUi?.valorNumerico?.toStringAsFixed(1)??"-"}", style: TextStyle(
                  fontFamily: AppTheme.fontTTNormsMedium,
                  fontSize: 12,
                  color: color_texto
              ),),
            )
        ],
      ),
    );
  }

  void showDialogPresicion(EvaluacionIndicadorMultipleController controller, EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, int position, PersonaUi personaUi) {

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
            personaUi: evaluacionRubricaValorTipoNotaUi.evaluacionUi?.personaUi,
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
        controller.onClicEvaluarPresicion(evaluacionRubricaValorTipoNotaUi, personaUi, nota);
      }
    });
  }

  Color getPosition(int position){
    if(position == 1){
      return HexColor("#1976d2");
    }else if(position == 2){
      return  HexColor("#388e3c");
    }else if(position == 3){
      return   HexColor("#FF6D00");
    }else if(position == 4){
      return  HexColor("#D32F2F");
    }else{
      return  AppTheme.greyLighten2;
    }
  }

  Future<bool?> _showControNoVigente(BuildContext context, PersonaUi? personaUi) async {
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
                                  Text("El Contrato de ${personaUi?.nombreCompleto??""} no esta vigente.",
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

  /*
  * SliverPadding(
                  padding: EdgeInsets.only(left: 32, right: 0, top: 16),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index){
                            PersonaUi personaUi = controller.alumnoCursoList[index];
                            EvaluacionUi? evaluacionGeneralUi = controller.getEvaluacionGeneralPersona(personaUi);
                            return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      CachedNetworkImage(
                                        placeholder: (context, url) => Container(
                                          child: CircularProgressIndicator(),
                                        ),
                                        imageUrl: personaUi.foto??"",
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
                                          child: Text((personaUi.nombreCompleto??"").toUpperCase(),
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
                                  if(controller.precision)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: 55,
                                              height: 55,
                                              margin: EdgeInsets.only(bottom: 4),
                                              child: FDottedLine(
                                                color: AppTheme.greyLighten1,
                                                strokeWidth: 1.0,
                                                dottedLength: 5.0,
                                                space: 3.0,
                                                corner: FDottedLineCorner.all(30.0),
                                                child: Container(
                                                  color: AppTheme.greyLighten2,
                                                  child: (){
                                                    //#region Nota
                                                    Color color;
                                                    if (("B" == (evaluacionGeneralUi?.valorTipoNotaUi?.titulo??"") || "C" == (evaluacionGeneralUi?.valorTipoNotaUi?.titulo??""))) {
                                                      color = AppTheme.redDarken4;
                                                    }else if (("AD" == (evaluacionGeneralUi?.valorTipoNotaUi?.titulo??"")) || "A" == (evaluacionGeneralUi?.valorTipoNotaUi?.titulo??"")) {
                                                      color = AppTheme.blueDarken4;
                                                    }else {
                                                      color = AppTheme.black;
                                                    }

                                                    switch(evaluacionGeneralUi?.valorTipoNotaUi?.tipoNotaUi?.tipoNotaTiposUi) {
                                                      case TipoNotaTiposUi.SELECTOR_VALORES:
                                                        return Container(
                                                          child: Center(
                                                            child: Text(evaluacionGeneralUi?.valorTipoNotaUi?.titulo ?? "",
                                                                style: TextStyle(
                                                                    fontFamily: AppTheme.fontTTNormsMedium,
                                                                    fontSize: 22,
                                                                    color: color
                                                                )),
                                                          ),
                                                        );
                                                      case TipoNotaTiposUi.SELECTOR_ICONOS:
                                                        return Container(
                                                          child: CachedNetworkImage(
                                                            imageUrl: evaluacionGeneralUi?.valorTipoNotaUi?.icono ?? "",
                                                            placeholder: (context, url) => Stack(
                                                              children: [
                                                                CircularProgressIndicator()
                                                              ],
                                                            ),
                                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                                          ),
                                                        );
                                                      case TipoNotaTiposUi.SELECTOR_NUMERICO:
                                                      case TipoNotaTiposUi.VALOR_NUMERICO:
                                                      case TipoNotaTiposUi.VALOR_ASISTENCIA:
                                                        return Center(
                                                          child: Text("${(evaluacionGeneralUi?.valorTipoNotaUi?.valorNumerico??0).toStringAsFixed(1)}", style: TextStyle(
                                                              fontFamily: AppTheme.fontTTNormsMedium,
                                                              fontSize: 16,
                                                              color: AppTheme.textGrey),
                                                          ),
                                                        );
                                                      default:
                                                        return Center(
                                                          child: Text("", style: TextStyle(
                                                              fontFamily: AppTheme.fontTTNormsMedium,
                                                              fontSize: 14,
                                                              color: AppTheme.textGrey
                                                          ),),
                                                        );
                                                    }
                                                    //#endregion
                                                  }(),
                                                ),

                                              ),
                                            ),
                                            Text(evaluacionGeneralUi?.valorTipoNotaUi?.alias??"",
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
                                            child: Text("${evaluacionGeneralUi?.nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
                                              fontFamily: AppTheme.fontTTNormsMedium,
                                              fontSize: 24,
                                              color: AppTheme.darkerText,
                                            ),),
                                          ),
                                        )
                                      ],
                                    ),
                                  if(controller.precision)
                                  Padding(
                                      padding: EdgeInsets.only(top: 16)
                                  ),
                                  showTableRubroDetalle(controller, personaUi),
                                  Padding(
                                      padding: EdgeInsets.only(top: 28)
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Text("Comentarios privados(Sólo lo ve el padre)",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: AppTheme.colorPrimary
                                        )
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: 8)
                                  ),
                                  Row(
                                   children: [
                                     CachedNetworkImage(
                                       placeholder: (context, url) => Container(
                                         child: CircularProgressIndicator(),
                                       ),
                                       imageUrl: controller.usuarioUi?.foto??"",
                                       errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                       imageBuilder: (context, imageProvider) =>
                                           Container(
                                               width: 50,
                                               height: 50,
                                               margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
                                               decoration: BoxDecoration(
                                                 borderRadius: BorderRadius.all(Radius.circular(25)),
                                                 image: DecorationImage(
                                                   image: imageProvider,
                                                   fit: BoxFit.cover,
                                                 ),
                                               )
                                           ),
                                     ),
                                     Expanded(
                                       child: Row(
                                         children: [
                                          Expanded(
                                              child:  Container(
                                                padding: EdgeInsets.only(left: 8, right: 8),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.greyLighten3,
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  border: Border.all(color: AppTheme.greyLighten1),
                                                ),
                                                child: TextField(
                                                  keyboardType: TextInputType.multiline,
                                                  maxLines: null,
                                                  decoration: InputDecoration(
                                                      hintText: "",
                                                      hintStyle: TextStyle( color: Colors.blueAccent),
                                                      border: InputBorder.none),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              )
                                          ),
                                           IconButton(
                                             onPressed: () {
                                               // You enter here what you want the button to do once the user interacts with it
                                             },
                                             icon: Icon(
                                               Icons.send,
                                               color: AppTheme.greyDarken1,
                                             ),
                                             iconSize: 20.0,
                                           )
                                         ],
                                       ),
                                     )
                                   ],
                                 ),
                                  Padding(
                                      padding: EdgeInsets.only(top: 16)
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Text("Evidencias (Sólo lo ve el padre)",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: AppTheme.colorPrimary
                                        )
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: 8)
                                  ),
                                  Row(
                                    children: [
                                      FloatingActionButton(
                                        heroTag: "btn_${personaUi.personaId??""}",
                                        onPressed: () {},
                                        elevation: 0,
                                        child: Icon(Icons.add,),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                      )
                                    ],
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: 48)
                                  ),
                                ],
                              ),
                            );
                          },
                        childCount: controller.alumnoCursoList.length
                      )
                  ),
                )
  * */
}