import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_not_expanded_custom.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/indicador/multiple/evaluacion_indicador_multiple_controller.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/presicion/precision_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/presicion/teclado_precision_2_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/presicion/teclado_precision_view.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_url_launcher.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/image_picker/image_picker_handler.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/preview_image_view.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/progress_bar.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_equipo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_publicado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_grupo_valor_tipo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/integrante_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_eval_equipo_integrante_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_equipo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_formula_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_comentario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_evidencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';

class EvaluacionIndicadorMultipleView extends View{
  String? rubroEvaluacionId;
  CursosUi? cursosUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;

  EvaluacionIndicadorMultipleView(this.rubroEvaluacionId, this.cursosUi, this.calendarioPeriodoUI);

  @override
  _EvaluacionIndicadorMultiplePortalState createState() => _EvaluacionIndicadorMultiplePortalState(rubroEvaluacionId, cursosUi, calendarioPeriodoUI);

}

class _EvaluacionIndicadorMultiplePortalState extends ViewState<EvaluacionIndicadorMultipleView, EvaluacionIndicadorMultipleController> with TickerProviderStateMixin, ImagePickerListener{
  ScrollControllers crollController = ScrollControllers();
  double? offset = 0.0;
  late final ScrollControllers scrollControllers = ScrollControllers();


  _EvaluacionIndicadorMultiplePortalState(rubroEvaluacionId, cursosUi,calendarioPeriodoUI) : super(EvaluacionIndicadorMultipleController(rubroEvaluacionId, cursosUi, calendarioPeriodoUI, MoorRubroRepository(), MoorConfiguracionRepository(), DeviceHttpDatosRepositorio()));

  late final ScrollController scrollController = ScrollController();
  Function()? statetDialogPresion;
  late double topBarOpacity = 0.0;

  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  Tween<Offset> _tweenGrupo = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  late AnimationController _controller = AnimationController(vsync: this, duration: _duration);
  late AnimationController _controllerGrupo = AnimationController(vsync: this, duration: _duration);
  Duration _duration = Duration(milliseconds: 200);
  TextEditingController _controllerComentario = TextEditingController();

  late AnimationController _imagePickerAnimationcontroller;
  late ImagePickerHandler imagePicker;
  GlobalKey globalKey = GlobalKey();

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
    _imagePickerAnimationcontroller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker=new ImagePickerHandler(this,_imagePickerAnimationcontroller, false);
    imagePicker.init(documento: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    _imagePickerAnimationcontroller.dispose();
    _controllerComentario.dispose();
    super.dispose();
  }

  @override
  Widget get view => ControlledWidgetBuilder<EvaluacionIndicadorMultipleController>(
      builder: (context, controller) {
          return WillPopScope (
            key: globalKey,
            onWillPop: () async {
              if(_controller.isCompleted){
                _controller.reverse();
                return false;
              }else{
                bool  se_a_modicado = await controller.onSave();
                if(se_a_modicado){
                  try{
                    Navigator.of(context).pop(1);//si devuelve un entero se actualiza toda la lista;
                  }catch(e){

                  }
                  return false;
                }else{
                  return true;
                }
              }

            },
            child: Container(
              color: AppTheme.background,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: <Widget>[

                    getMainTab(),
                    getAppBarUI(controller),
                    SizedBox.expand(
                      child: SlideTransition(
                        position: _tween.animate(_controller),
                        child: Container(
                          //height: MediaQuery.of(context).size.height,
                          decoration: new BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.only(
                              topLeft:  Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                            ),
                          ),
                          child: Container(
                            child: Column(
                              children: [
                                Expanded(child:  SingleChildScrollView(
                                  child: Container(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: (){
                                        if(controller.personaUiSelected == null){
                                          return Container();
                                        }

                                        List<double> tablecolumnWidths = [];
                                        /*Calular el tamaño*/
                                        if(controller.alumnoCursoList.isNotEmpty){
                                          for(dynamic s in controller.mapColumnList[controller.alumnoCursoList[0]]??[]){
                                            if(s is ValorTipoNotaUi){
                                              tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 45));
                                            } else if(s is RubricaEvaluacionUi){
                                              tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 85));
                                            } else if(s is EvaluacionUi){
                                              tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 60));
                                            }else if(s is RubricaEvaluacionFormulaPesoUi){
                                              tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 45));
                                            }else{
                                              tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50));
                                            }
                                          }
                                        }

                                        double width_pantalla = MediaQuery.of(context).size.width;
                                        double padding_left = ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 24);
                                        double padding_right = ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 24);
                                        double width_table = padding_left + padding_right + ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 120);
                                        for(double column_px in tablecolumnWidths){
                                          width_table += column_px;
                                        }
                                        double width = 0;
                                        if(width_pantalla>width_table){
                                          width = width_pantalla;
                                        }else{
                                          width = width_table;
                                        }

                                        EvaluacionUi? evaluacionGeneralUi = controller.getEvaluacionGeneralPersona(controller.personaUiSelected);

                                        return Container(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context).padding.top +
                                                  0,
                                              left: padding_left,
                                              right: padding_right
                                          ),
                                          width: width,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16))
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 20)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: ()=> controller.onClicPrecision(),
                                                      child: Container(
                                                        width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 110),
                                                        padding: EdgeInsets.only(
                                                            left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                                            right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                                            top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8),
                                                            bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)
                                                        ),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 6))),
                                                            color:  controller.precision?HexColor(controller.cursosUi.color2) : AppTheme.greyLighten2
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Icon(Ionicons.apps ,
                                                                color:  controller.precision? AppTheme.white :AppTheme.greyDarken1,
                                                                size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 9 + 6 - 2 * topBarOpacity)
                                                            ),
                                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 2))),
                                                            FittedBox(
                                                              fit: BoxFit.scaleDown,
                                                              child: Text("Precisión",
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w700,
                                                                      letterSpacing: 0.5,
                                                                      color:  controller.precision? AppTheme.white :AppTheme.greyDarken1,
                                                                      fontFamily: AppTheme.fontTTNorms,
                                                                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 5 + 6 - 1 * topBarOpacity)
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              (){
                                                RubricaEvaluacionEquipoUi? rubricaEvaluacionEquipoUi = controller.getRubricaEvaluacionEquipoUiCabecera(evaluacionGeneralUi);
                                                if(rubricaEvaluacionEquipoUi!=null){
                                                  return  Container(
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text("${rubricaEvaluacionEquipoUi.nombreEquipo??""}",
                                                                  style: TextStyle(
                                                                      fontFamily: AppTheme.fontTTNorms,
                                                                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 20),
                                                                      fontWeight: FontWeight.w900
                                                                  ),
                                                                ),
                                                                Text("Grupo ${rubricaEvaluacionEquipoUi.orden??0}",
                                                                  style: TextStyle(
                                                                      fontFamily: AppTheme.fontTTNorms,
                                                                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                                                      fontWeight: FontWeight.w700
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                        ),
                                                        Padding(
                                                            padding: EdgeInsets.only(
                                                              right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50),
                                                            )
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }else{
                                                  return Container();
                                                }

                                              }(),

                                              Padding(
                                                  padding: EdgeInsets.only(
                                                    right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 10),
                                                  )
                                              ),
                                              Container(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: (){
                                                        Navigator.of(context).push(PreviewImageView.createRoute(controller.personaUiSelected?.foto));
                                                      },
                                                      child: Container(
                                                        width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50),
                                                        height: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50),
                                                        child: CachedNetworkImage(
                                                          placeholder: (context, url) => SizedBox(
                                                            child: Shimmer.fromColors(
                                                              baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                                              highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                                              child: Container(
                                                                padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                                decoration: BoxDecoration(
                                                                    color: HexColor(controller.cursosUi.color2),
                                                                    shape: BoxShape.circle
                                                                ),
                                                                alignment: Alignment.center,
                                                              ),
                                                            ),
                                                          ),
                                                          imageUrl: controller.personaUiSelected?.foto??"",
                                                          errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 45),),
                                                          imageBuilder: (context, imageProvider) =>
                                                              Container(
                                                                  margin: EdgeInsets.only(
                                                                      right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 0),
                                                                      left: 0,
                                                                      top: 0,
                                                                      bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 0)
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                    image: DecorationImage(
                                                                      image: imageProvider,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                    shape: BoxShape.circle
                                                                  )
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text("${controller.personaUiSelected?.apellidos}",
                                                              style: TextStyle(
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 20),
                                                                  fontWeight: FontWeight.w900
                                                              ),
                                                            ),
                                                            Text("${controller.personaUiSelected?.nombres}",
                                                              style: TextStyle(
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                          right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50),
                                                        )
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12))),
                                              Container(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [

                                                    Container(
                                                      width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 55),
                                                      height: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 55),
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
                                                                            fontFamily: AppTheme.fontTTNorms,
                                                                            fontWeight: FontWeight.w700,
                                                                            fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 20),
                                                                            color: color
                                                                        )),
                                                                  ),
                                                                );
                                                              case TipoNotaTiposUi.SELECTOR_ICONOS:
                                                                return Container(
                                                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4)),
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
                                                                      fontFamily: AppTheme.fontTTNorms,
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                                                      color: AppTheme.textGrey),
                                                                  ),
                                                                );
                                                              default:
                                                                return Center(
                                                                  child: Text("", style: TextStyle(
                                                                      fontFamily: AppTheme.fontTTNorms,
                                                                      fontWeight: FontWeight.w700,
                                                                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14),
                                                                      color: AppTheme.textGrey
                                                                  ),),
                                                                );
                                                            }
                                                            //#endregion
                                                          }(),
                                                        ),

                                                      ),
                                                    ),
                                                    Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16))),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8))),
                                                        color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                                                      ),
                                                      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                                      child: Column(
                                                        children: [
                                                          Text("Nota", style: TextStyle(
                                                              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                                                              fontFamily: AppTheme.fontTTNorms,
                                                              fontWeight: FontWeight.w700,
                                                              color: HexColor(controller.cursosUi.color1)
                                                          )
                                                          ),
                                                          Text("${evaluacionGeneralUi?.nota?.toStringAsFixed(1)??"-"}", style: TextStyle(fontSize: 14, fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w700)),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16))),
                                                    (evaluacionGeneralUi?.valorTipoNotaUi?.alias??"").isNotEmpty?
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8))),
                                                        color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                                                      ),
                                                      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                                      child: Column(
                                                        children: [
                                                          Text("Logro",
                                                              style: TextStyle(
                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  fontWeight: FontWeight.w700,
                                                                  color: HexColor(controller.cursosUi.color1)
                                                              )
                                                          ),
                                                          Text("${evaluacionGeneralUi?.valorTipoNotaUi?.alias??""}", style: TextStyle(fontSize: 14, fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w700)),
                                                        ],
                                                      ),
                                                    ):Container(),

                                                  ],
                                                ),
                                              ),
                                              Padding(padding: EdgeInsets.all(10)),
                                              Center(
                                                child: Container(
                                                  width: width_table,
                                                  child:  showTableRubroDetalle(controller, controller.personaUiSelected, tablecolumnWidths),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 28))
                                              ),
                                              Container(
                                                width: width,
                                                child: Text("Comentarios privados (Sólo lo ve el padre)",
                                                    style: TextStyle(
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                                                        color: AppTheme.colorPrimary,
                                                        fontFamily: AppTheme.fontTTNorms,
                                                        fontWeight: FontWeight.w700
                                                    )
                                                ),
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics: NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.only(top: 0),
                                                itemBuilder: (context, index) {
                                                  var rubroComentarioUi =  evaluacionGeneralUi?.comentarios![index];
                                                  return Container(
                                                    width: width,
                                                    margin: EdgeInsets.only(top:  ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16)),
                                                    //padding: EdgeInsets.only( right: padding_right),
                                                    child: Row(
                                                      children: [
                                                        CachedNetworkImage(
                                                          placeholder: (context, url) => SizedBox(
                                                            child: Shimmer.fromColors(
                                                              baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                                              highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                                              child: Container(
                                                                padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                                decoration: BoxDecoration(
                                                                    color: HexColor(controller.cursosUi.color2),
                                                                    shape: BoxShape.circle
                                                                ),
                                                                alignment: Alignment.center,
                                                              ),
                                                            ),
                                                          ),
                                                          imageUrl: controller.usuarioUi?.personaUi?.foto??"",
                                                          errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 40),),
                                                          imageBuilder: (context, imageProvider) =>
                                                              Container(
                                                                  width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 40),
                                                                  height: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 40),
                                                                  margin: EdgeInsets.only(
                                                                      right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                                                      left: 0,
                                                                      top: 0,
                                                                      bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)),
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
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: AppTheme.greyLighten3,
                                                              borderRadius: BorderRadius.circular(8.0),
                                                              border: Border.all(color: AppTheme.greyLighten2),
                                                            ),
                                                            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: Container(
                                                                            padding: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)),
                                                                            child: Text("${controller.usuarioUi?.personaUi?.nombreCompleto}",
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(
                                                                                    fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 10),
                                                                                    fontFamily: AppTheme.fontTTNorms,
                                                                                    fontWeight: FontWeight.w700
                                                                                ))
                                                                        )
                                                                    ),
                                                                    Text("${DomainTools.f_fecha_letras(rubroComentarioUi?.fechaCreacion)}",
                                                                        style: TextStyle(
                                                                            fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 10),
                                                                            color: AppTheme.greyDarken1,
                                                                            fontFamily: AppTheme.fontTTNorms,
                                                                            fontWeight: FontWeight.w700
                                                                        )
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 2))),
                                                                Container(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Text("${rubroComentarioUi?.comentario??""}",
                                                                    style: TextStyle(
                                                                        fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                                                                        fontFamily: AppTheme.fontTTNorms,
                                                                        fontWeight: FontWeight.w600
                                                                    ),),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        IconButton(
                                                          onPressed: ()async {
                                                            bool succes = await _showDialogEliminarComentario(controller)??false;
                                                            if(succes){
                                                              controller.eliminarComentario(rubroComentarioUi, evaluacionGeneralUi);
                                                            }
                                                          },
                                                          icon: Icon(
                                                            Icons.close,
                                                            color: AppTheme.greyDarken1,
                                                          ),
                                                          iconSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 20),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                                itemCount: evaluacionGeneralUi?.comentarios?.length??0,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8))
                                              ),
                                              Container(
                                                width: width,
                                                child: Row(
                                                  children: [
                                                    CachedNetworkImage(
                                                      placeholder: (context, url) => SizedBox(
                                                        child: Shimmer.fromColors(
                                                          baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                                          highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                                          child: Container(
                                                            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                            decoration: BoxDecoration(
                                                                color: HexColor(controller.cursosUi.color2),
                                                                shape: BoxShape.circle
                                                            ),
                                                            alignment: Alignment.center,
                                                          ),
                                                        ),
                                                      ),
                                                      imageUrl: controller.usuarioUi?.personaUi?.foto??"",
                                                      errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 40),),
                                                      imageBuilder: (context, imageProvider) =>
                                                          Container(
                                                              width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 40),
                                                              height: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 40),
                                                              margin: EdgeInsets.only(
                                                                  right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                                                  left: 0,
                                                                  top: 0,
                                                                  bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 25))),
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
                                                            child: Container(
                                                              height: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 65),
                                                              child: Row(
                                                                children: <Widget>[
                                                                  Expanded(
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppTheme.greyLighten3,
                                                                        borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)),
                                                                        border: Border.all(color: AppTheme.greyLighten2),
                                                                      ),
                                                                      padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)),
                                                                      child: Row(
                                                                        children: <Widget>[
                                                                          Expanded(
                                                                            child: TextField(
                                                                              controller: _controllerComentario,
                                                                              maxLines: null,
                                                                              keyboardType: TextInputType.multiline,
                                                                              style: TextStyle(
                                                                                fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12),

                                                                              ),
                                                                              decoration: InputDecoration(
                                                                                  isDense: true,
                                                                                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                                                                                  hintText: "",
                                                                                  border: InputBorder.none),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          IconButton(
                                                            onPressed: () {
                                                              controller.saveComentario(_controllerComentario.text, evaluacionGeneralUi);
                                                              _controllerComentario.text = "";
                                                            },
                                                            icon: Icon(
                                                              Icons.send,
                                                              color: AppTheme.greyDarken1,
                                                            ),
                                                            iconSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 20),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16))
                                              ),
                                              Container(
                                                width: width,
                                                child: Text("Evidencias (Sólo lo ve el padre)",
                                                    style: TextStyle(
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                                                        color: AppTheme.colorPrimary,
                                                        fontFamily: AppTheme.fontTTNorms,
                                                        fontWeight: FontWeight.w700
                                                    )
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8))
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                  left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 24),
                                                  right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 24),
                                                  top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8),),
                                                child: Stack(
                                                  children: [
                                                    Center(
                                                      child: InkWell(
                                                        onTap: () async{
                                                          controller.onSelectedEvaluacionGeneral(evaluacionGeneralUi);
                                                          imagePicker.showDialog(context);
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.all(8),
                                                          decoration: BoxDecoration(
                                                            color: HexColor(controller.cursosUi.color2).withOpacity(0.1),
                                                            borderRadius: BorderRadius.circular(8), // use instead of BorderRadius.all(Radius.circular(20))
                                                          ),
                                                          width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 450),
                                                          height: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 60),
                                                          child: FDottedLine(
                                                            color: HexColor(controller.cursosUi.color1).withOpacity(0.6),
                                                            strokeWidth: 2.0,
                                                            dottedLength: 10.0,
                                                            space: 2.0,
                                                            corner: FDottedLineCorner.all(14.0),

                                                            /// add widget
                                                            child: Container(
                                                              alignment: Alignment.center,
                                                              child: Text("Agregar evidencia",  style: TextStyle(
                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                                                  fontWeight: FontWeight.w500,
                                                                  color: HexColor(controller.cursosUi.color1).withOpacity(0.8)
                                                              ),),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              ListView.builder(
                                                  padding: EdgeInsets.only(
                                                      left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 24),
                                                      right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 24),
                                                      top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                                      bottom: 0),
                                                  itemCount: evaluacionGeneralUi?.evidencias?.length??0,
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index){
                                                    RubroEvidenciaUi rubroEvidenciaUi =  evaluacionGeneralUi!.evidencias![index];

                                                    return Stack(
                                                      children: [
                                                        Center(
                                                          child: InkWell(
                                                            onTap: () async{
                                                              print("Click a");
                                                              if(rubroEvidenciaUi.tipoRecurso == TipoRecursosUi.TIPO_IMAGEN){
                                                                Navigator.of(context).push(PreviewImageView.createRoute(rubroEvidenciaUi.url));
                                                              }else{
                                                                await AppUrlLauncher.openLink(rubroEvidenciaUi.url, webview: false);
                                                              }
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)), // use instead of BorderRadius.all(Radius.circular(20))
                                                                  border:  Border.all(
                                                                      width: 1,
                                                                      color: HexColor(controller.cursosUi.color1)
                                                                  ),
                                                                  color: rubroEvidenciaUi.success == false? AppTheme.red.withOpacity(0.1):AppTheme.white
                                                              ),
                                                              margin: EdgeInsets.only(bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16)),
                                                              width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 450),
                                                              height: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50),
                                                              child: Stack(
                                                                children: [
                                                                  Container(
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          margin: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16)),
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.only(
                                                                              bottomLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)),
                                                                              topLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)),
                                                                            ), // use instead of BorderRadius.all(Radius.circular(20))
                                                                            color: AppTheme.greyLighten2,
                                                                          ),
                                                                          width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50),
                                                                          child: Center(
                                                                            child: Image.asset(getImagen(rubroEvidenciaUi.tipoRecurso),
                                                                              height: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 30),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text("${rubroEvidenciaUi.titulo??""}",
                                                                                  style: TextStyle(
                                                                                      color: AppTheme.greyDarken3,
                                                                                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12),
                                                                                      fontFamily: AppTheme.fontTTNorms,
                                                                                      fontWeight: FontWeight.w600,
                                                                                  )),
                                                                              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 2))),
                                                                              Text("${getDescripcion(rubroEvidenciaUi.tipoRecurso)}", maxLines: 1, overflow: TextOverflow.ellipsis,
                                                                                  style: TextStyle(
                                                                                      color: AppTheme.blue,
                                                                                      fontFamily: AppTheme.fontTTNorms,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 10)
                                                                                  )),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        rubroEvidenciaUi.success == false?
                                                                        InkWell(
                                                                          onTap: (){
                                                                            controller.refreshRubroEvidenciaUi(rubroEvidenciaUi);
                                                                          },
                                                                          child: Container(
                                                                            margin: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16)),
                                                                            child: Icon(Icons.refresh),
                                                                          ),
                                                                        ):Container(),
                                                                        InkWell(
                                                                          onTap: () async{
                                                                            bool? success = await _showDialogEliminarEvidencia(controller);
                                                                            if(success??false){
                                                                              controller.removeRubroEvidencia(rubroEvidenciaUi, evaluacionGeneralUi);
                                                                            }

                                                                          },
                                                                          child: Container(
                                                                            margin: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16)),
                                                                            child: Icon(Icons.close),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  !(rubroEvidenciaUi.success != null)&&(rubroEvidenciaUi.progress??0)>0?
                                                                  Column(
                                                                    children: [
                                                                      Expanded(child: Container()),
                                                                      ProgressBar(
                                                                        current: rubroEvidenciaUi.progress??0,
                                                                        max: 100,

                                                                        borderRadiusGeometry:BorderRadius.only(bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
                                                                        color: HexColor(controller.cursosUi.color2),
                                                                      )
                                                                    ],
                                                                  ):Container()
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(48)
                                              ),
                                            ],
                                          ),
                                        );

                                      }(),
                                    ),
                                  ),
                                )),
                                Container(
                                  color: AppTheme.white,
                                  margin: EdgeInsets.only(
                                    right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16)
                                  ),
                                  padding: EdgeInsets.only(
                                    top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8),
                                    bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8),
                                    left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8),
                                    right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(child: Container()),
                                      if(controller.atras)
                                        TextButton(
                                          onPressed: () {
                                            controller.onClickAtrasEvaluacion();
                                            _controllerComentario.text = "";
                                          },
                                          style: TextButton.styleFrom(
                                            primary: HexColor(controller.cursosUi.color2),
                                          ),
                                          child: Text(
                                            'Atrás'.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
                                            ),
                                          ),
                                        ),
                                      if(controller.siguiente)
                                        TextButton(
                                          onPressed: () {
                                            controller.onClickSiguienteEvaluacion();
                                            _controllerComentario.text = "";
                                          },
                                          style: TextButton.styleFrom(
                                            primary: HexColor(controller.cursosUi.color2),
                                          ),
                                          child: Text(
                                            'Siguiente'.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
                                            ),
                                          ),
                                        ),
                                      TextButton(
                                        onPressed: () async{
                                          await _controller.reverse();
                                          _controllerComentario.text = "";
                                          controller.onClickFinalizarEvaluacion();
                                        },
                                        style: TextButton.styleFrom(
                                          primary: HexColor(controller.cursosUi.color2),
                                        ),
                                        child: Text(
                                          'Finalizar'.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14),
                                              fontWeight: FontWeight.w700
                                              ,fontFamily:  AppTheme.fontTTNorms
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox.expand(
                      child: SlideTransition(
                        position: _tweenGrupo.animate(_controllerGrupo),
                        child: Container(
                          //height: MediaQuery.of(context).size.height,
                          decoration: new BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.only(
                              topLeft:  Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                            ),
                          ),
                          child: Container(
                            child: Column(
                              children: [
                                Expanded(child:  SingleChildScrollView(
                                  child: Container(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: (){
                                        if(controller.rubricaEvaluacionEquipoUiSelected == null){
                                          return Container();
                                        }

                                        List<double> tablecolumnWidths = [];
                                        /*Calular el tamaño*/
                                        if(controller.rubricaEvaluacionEquipoUiList.isNotEmpty){
                                          for(dynamic s in controller.mapColumnEquipoList[controller.rubricaEvaluacionEquipoUiList[0].equipoId]??[]){
                                            if(s is ValorTipoNotaUi){
                                              tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 45));
                                            } else if(s is RubricaEvaluacionUi){
                                              tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 85));
                                            } else if(s is RubricaEvaluacionEquipoUi){
                                              tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 60));
                                            }else{
                                              tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50));
                                            }
                                          }
                                        }

                                        double width_pantalla = MediaQuery.of(context).size.width;
                                        double padding_left = ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 24);
                                        double padding_right = ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 24);
                                        double width_table = padding_left + padding_right + ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 120);
                                        for(double column_px in tablecolumnWidths){
                                          width_table += column_px;
                                        }
                                        double width = 0;
                                        if(width_pantalla>width_table){
                                          width = width_pantalla;
                                        }else{
                                          width = width_table;
                                        }

                                        RubricaEvaluacionEquipoUi? rubricaEvaluacionEquipoUiGeneral = controller.getEvaluacionGeneralEquipo(controller.rubricaEvaluacionEquipoUiSelected);

                                        return Container(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context).padding.top +
                                                  0,
                                              left: padding_left,
                                              right: padding_right
                                          ),
                                          width: width,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16))
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 20)),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: ()=> controller.onClicPrecision(),
                                                      child: Container(
                                                        width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 110),
                                                        padding: EdgeInsets.only(
                                                            left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                                            right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                                            top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8),
                                                            bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)
                                                        ),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 6))),
                                                            color:  controller.precision?HexColor(controller.cursosUi.color2) : AppTheme.greyLighten2
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Icon(Ionicons.apps ,
                                                                color:  controller.precision? AppTheme.white :AppTheme.greyDarken1,
                                                                size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 9 + 6 - 2 * topBarOpacity)
                                                            ),
                                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 2))),
                                                            FittedBox(
                                                              fit: BoxFit.scaleDown,
                                                              child: Text("Precisión",
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.w700,
                                                                      letterSpacing: 0.5,
                                                                      color:  controller.precision? AppTheme.white :AppTheme.greyDarken1,
                                                                      fontFamily: AppTheme.fontTTNorms,
                                                                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 5 + 6 - 1 * topBarOpacity)
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
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text("${(rubricaEvaluacionEquipoUiGeneral?.nombreEquipo??"").isNotEmpty?rubricaEvaluacionEquipoUiGeneral?.nombreEquipo:"Grupo ${rubricaEvaluacionEquipoUiGeneral?.orden??0}"}",
                                                              style: TextStyle(
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 20),
                                                                  fontWeight: FontWeight.w900
                                                              ),
                                                            ),
                                                            if((rubricaEvaluacionEquipoUiGeneral?.nombreEquipo??"").isNotEmpty)
                                                            Text("Grupo ${rubricaEvaluacionEquipoUiGeneral?.orden??0}",
                                                              style: TextStyle(
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                                                  fontWeight: FontWeight.w700
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                          right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50),
                                                        )
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12))),
                                              Container(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [

                                                    Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8))),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8))),
                                                        color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                                                      ),
                                                      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                                      child: Column(
                                                        children: [
                                                          Text("Nota", style: TextStyle(
                                                              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                                                              fontFamily: AppTheme.fontTTNorms,
                                                              fontWeight: FontWeight.w700,
                                                              color: HexColor(controller.cursosUi.color1)
                                                          )
                                                          ),
                                                          Text("${rubricaEvaluacionEquipoUiGeneral?.evaluacionEquipoUi?.nota?.toStringAsFixed(1)??"-"}", style: TextStyle(fontSize: 14, fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w700)),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16))),
                                                    (rubricaEvaluacionEquipoUiGeneral?.evaluacionEquipoUi?.valorTipoNotaUi?.alias??"").isNotEmpty?
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8))),
                                                        color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                                                      ),
                                                      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                                      child: Column(
                                                        children: [
                                                          Text("Logro",
                                                              style: TextStyle(
                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  fontWeight: FontWeight.w700,
                                                                  color: HexColor(controller.cursosUi.color1)
                                                              )
                                                          ),
                                                          Text("${rubricaEvaluacionEquipoUiGeneral?.evaluacionEquipoUi?.valorTipoNotaUi?.alias??""}", style: TextStyle(fontSize: 14, fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w700)),
                                                        ],
                                                      ),
                                                    ):Container(),

                                                  ],
                                                ),
                                              ),
                                              Padding(padding: EdgeInsets.all(10)),
                                              Center(
                                                child: Container(
                                                  width: width_table,
                                                  child:  showTableRubroEquipoDetalle(controller, controller.rubricaEvaluacionEquipoUiSelected, tablecolumnWidths),
                                                ),
                                              ),
                                              Padding(padding: EdgeInsets.all(10)),
                                              Container(
                                                width: width,
                                                child: Text("Integrantes de ${(controller.rubricaEvaluacionEquipoUiSelected?.nombreEquipo??"").isNotEmpty?controller.rubricaEvaluacionEquipoUiSelected?.nombreEquipo:"Grupo ${controller.rubricaEvaluacionEquipoUiSelected?.orden??0}"}",
                                                    style: TextStyle(
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                                                        color: AppTheme.colorPrimary,
                                                        fontFamily: AppTheme.fontTTNorms,
                                                        fontWeight: FontWeight.w700
                                                    )
                                                ),
                                              ),
                                              Container(
                                                width: width,
                                                child: GridView.builder(
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: ColumnCountProvider.columnsForWidthRubroEquipo(context),
                                                    mainAxisSpacing: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 24),
                                                    crossAxisSpacing: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 24),
                                                  ),
                                                  physics: NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.only(
                                                    top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 24),
                                                    left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 32),
                                                    right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 32),
                                                    bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 0),
                                                  ),
                                                  shrinkWrap: true,
                                                  itemCount: rubricaEvaluacionEquipoUiGeneral?.integrantesUiList?.length??0,
                                                  itemBuilder: (context, index) {
                                                    RubricaEvalEquipoIntegranteUi? integanteUi =  rubricaEvaluacionEquipoUiGeneral?.integrantesUiList?[index];
                                                    return InkWell(
                                                      onTap: (){

                                                      },
                                                      child:  Container(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Expanded(
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    color: AppTheme.grey,
                                                                  ),
                                                                  child: CachedNetworkImage(
                                                                    placeholder: (context, url) => SizedBox(
                                                                      child: Shimmer.fromColors(
                                                                        baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                                                        highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                                                        child: Container(
                                                                          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                                                          decoration: BoxDecoration(
                                                                              color: AppTheme.grey,
                                                                              shape: BoxShape.circle
                                                                          ),
                                                                          alignment: Alignment.center,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    imageUrl: integanteUi?.personaUi?.foto??"",
                                                                    errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded),
                                                                    imageBuilder: (context, imageProvider) =>
                                                                        Container(
                                                                            decoration: BoxDecoration(
                                                                              shape: BoxShape.circle,
                                                                              image: DecorationImage(
                                                                                image: imageProvider,
                                                                                fit: BoxFit.scaleDown,
                                                                              ),
                                                                            )
                                                                        ),
                                                                  ),
                                                                )
                                                            ),
                                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4))),
                                                            Text("${integanteUi?.personaUi?.nombreCompleto}",
                                                              maxLines: 2,
                                                              overflow: TextOverflow.ellipsis,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                                                                  fontWeight: FontWeight.w500
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 28))
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(48)
                                              ),
                                            ],
                                          ),
                                        );

                                      }(),
                                    ),
                                  ),
                                )),
                                Container(
                                  color: AppTheme.white,
                                  margin: EdgeInsets.only(
                                      right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16)
                                  ),
                                  padding: EdgeInsets.only(
                                      top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8),
                                      bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8),
                                      left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8),
                                      right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(child: Container()),

                                      if(controller.atrasGrupo)
                                        TextButton(
                                          onPressed: () {
                                           controller.onClickAtrasEvalEquipo();
                                          },
                                          style: TextButton.styleFrom(
                                            primary: HexColor(controller.cursosUi.color2),
                                          ),
                                          child: Text(
                                            'Atrás'.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
                                            ),
                                          ),
                                        ),
                                      if(controller.siguienteGrupo)
                                        TextButton(
                                          onPressed: () {
                                            controller.onClickSiguienteEvalEquipo();
                                          },
                                          style: TextButton.styleFrom(
                                            primary: HexColor(controller.cursosUi.color2),
                                          ),
                                          child: Text(
                                            'Siguiente'.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
                                            ),
                                          ),
                                        ),
                                      TextButton(
                                        onPressed: () async{
                                          await _controllerGrupo.reverse();
                                          controller.onClickFinalizarEvalEquipo();
                                        },
                                        style: TextButton.styleFrom(
                                          primary: HexColor(controller.cursosUi.color2),
                                        ),
                                        child: Text(
                                          'Finalizar'.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14),
                                              fontWeight: FontWeight.w700
                                              ,fontFamily:  AppTheme.fontTTNorms
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if(controller.showDialog)
                      ArsProgressWidget(
                          blur: 2,
                          backgroundColor: Color(0x33000000),
                          animationDuration: Duration(milliseconds: 500)),
                    if(controller.showDialog)
                      Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 200),
                            child: ClipOval(
                              child: Material(
                                color: Colors.white, // button color
                                child: InkWell(
                                  splashColor: Colors.black.withOpacity(0.2), // inkwell color
                                  child: SizedBox(width:50, height: 50,
                                      child: Icon(Ionicons.close, size: 30,
                                          color: Colors.blue
                                      )
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop(1);//si devuelve un entero se actualiza toda la lista;
                                  },
                                ),
                              ),
                            ),
                          )
                      ),
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
                                              Text("¿Está seguro de eliminar la evaluación? Recuerde que si elimina se borrará permanentemente las calificaciones.",
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
                                          if (mounted) {
                                            WidgetsBinding.instance?.addPostFrameCallback((_){
                                              Navigator.of(context).pop(-1);//si devuelve un entero se actualiza toda la lista. -1 si se elimino la rubrica
                                            });
                                          }
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

  Widget getAppBarUI(EvaluacionIndicadorMultipleController controller) {
    return Column(
      children: [
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
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        child:  IconButton(
                          icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                          onPressed: () async {
                            /*if(!controller.tipoMatriz){
                                      controller.onClicVolverMatriz();
                                      scrollController.jumpTo(offset??0.0);
                                    }else{

                                    }*/


                            bool?  modificado = await controller.onSave();
                            if(modificado){

                              if (mounted) {
                                WidgetsBinding.instance?.addPostFrameCallback((_){
                                  try{
                                    Navigator.of(context).pop(1);//si devuelve un entero se actualiza toda la lista
                                  }catch(e){

                                  }

                                });
                              }
                            }else{
                              Navigator.of(context).pop(false);
                            }


                          },
                        )
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child:  Container(
                              margin: EdgeInsets.only(top: 0 + 8 * topBarOpacity, bottom: 8, left: 40, right: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AppIcon.ic_curso_evaluacion, height: 35 +  6 - 8 * topBarOpacity, width: 35 +  6 - 8 * topBarOpacity,),
                                  Padding(padding: EdgeInsets.only(left: 4)),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Evaluación',
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
                          ),
                          Container(
                              margin: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16)),
                              child:InkWell(
                                //onTap: ()=> controller.onClicPrecision(),
                                child: Container(
                                  width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 80 - 20 * topBarOpacity),
                                  padding: EdgeInsets.only(
                                      left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8 - 2 * topBarOpacity) ,
                                      right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8 - 2 * topBarOpacity),
                                      top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8 - 2 * topBarOpacity),
                                      bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8  - 2 * topBarOpacity)
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 6))),
                                      color: HexColor(controller.cursosUi.color2)
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Ionicons.help_circle,
                                          color: AppTheme.white,
                                          size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8 + 6 - 2 * topBarOpacity)
                                      ),
                                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 2))),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text("Ayuda",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.5,
                                              color:AppTheme.white,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 5 + 6 - 1 * topBarOpacity),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          )
                        ],
                      ),
                    ),


                  ],
                ),
              ),

            ],
          ),
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
                    //MediaQuery.of(context).padding.top +
                    0,
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 16,
                      left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                      right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16)
                  ),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: ()=> controller.onClicPrecision(),
                                      child: Container(
                                        width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 110),
                                        padding: EdgeInsets.only(
                                            left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                            right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                            top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8),
                                            bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 6))),
                                            color:  controller.precision?HexColor(controller.cursosUi.color2) : AppTheme.greyLighten2
                                        ),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Ionicons.apps ,
                                                color:  controller.precision? AppTheme.white :AppTheme.greyDarken1,
                                                size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 9 + 6 - 2 * topBarOpacity)
                                            ),
                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 2))),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text("Precisión",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      letterSpacing: 0.5,
                                                      color:  controller.precision? AppTheme.white :AppTheme.greyDarken1,
                                                      fontFamily: AppTheme.fontTTNorms,
                                                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 5 + 6 - 1 * topBarOpacity)
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4))),
                                    InkWell(
                                      onTap: () async{
                                        if(controller.rubroEvaluacionUi!=null){
                                          dynamic response = await AppRouter.createRouteRubroCrearRouter(context, controller.cursosUi, controller.calendarioPeriodoUI, null, null, controller.rubroEvaluacionUi, false);
                                          if(response is String)controller.respuestaFormularioCrearRubro();
                                        }
                                      },
                                      child: Container(
                                        width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 110),
                                        padding: EdgeInsets.only(
                                            left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                            right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                            top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8),
                                            bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 6))),
                                            color:HexColor(controller.cursosUi.color2)
                                        ),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Ionicons.pencil ,
                                                color: AppTheme.white,
                                                size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 9 + 6 - 2 * topBarOpacity)
                                            ),
                                            Padding(padding: EdgeInsets.all(2),),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text("Editar",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0.5,
                                                    color: AppTheme.white,
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 5 + 6 - 1 * topBarOpacity),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4))),
                                    InkWell(
                                      onTap: () {
                                        if(controller.rubroEvaluacionUi!=null){
                                          controller.onClickEliminar();
                                        }
                                      },
                                      child: Container(
                                        width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 110),
                                        padding: EdgeInsets.only(
                                            left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                            right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                                            top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8),
                                            bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 6))),
                                            color:  controller.isCalendarioDesactivo()?AppTheme.greyLighten2:AppTheme.red
                                        ),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Ionicons.trash ,
                                                color: controller.isCalendarioDesactivo()?AppTheme.greyDarken1:AppTheme.white,
                                                size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 9 + 6 - 2 * topBarOpacity)
                                            ),
                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 2)),),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text("Eliminar",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0.5,
                                                    color:  controller.isCalendarioDesactivo()?AppTheme.greyDarken1:AppTheme.white,
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 5 + 6 - 1 * topBarOpacity),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16))),
                                Container(
                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)),
                                  color: HexColor(controller.cursosUi.color3).withOpacity(0.1),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12),
                                              height: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 1.5),
                                              letterSpacing: 0.3,
                                              color: HexColor(controller.cursosUi.color1),
                                            ),
                                            children: [
                                              TextSpan(text: 'EVALUA LA RÚBRICA '),
                                              //TextSpan(text: "${(controller.evaluacionCapacidadUi.personaUi?.nombreCompleto??"").toUpperCase()}"),
                                              TextSpan(text: '"${(controller.rubroEvaluacionUi?.titulo??"").toUpperCase()}"', style: TextStyle(fontWeight: FontWeight.w900)),

                                            ]
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  color: HexColor(controller.cursosUi.color1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                ),
                SliverPadding(
                    padding: EdgeInsets.only(
                      top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 24),
                    ),
                    sliver: SliverToBoxAdapter(
                      child: showTableRubrica(controller),
                    ),
                )
              ],
            ),
          );
        });
  }

  Widget showTableRubrica(EvaluacionIndicadorMultipleController controller) {
    List<double> tablecolumnWidths = [];
    for(dynamic s in controller.columnList2){
      if(s is ContactoUi){
        tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 100));
      } else if(s is EvaluacionUi){
        tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 45));
      }else if(s is EvaluacionPublicadoUi){
        tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 60));
      }else{
        tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 70));
      }
    }
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return Padding(
            padding: EdgeInsets.only(left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16)),
            child: SingleChildScrollView(
              child: StickyHeadersTableNotExpandedCustom(
                cellDimensions: CellDimensions.variableColumnWidth(
                    stickyLegendHeight: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 150),
                    stickyLegendWidth: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50),
                    contentCellHeight: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50),
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
                          child:  Text("Apellidos y\n Nombres",
                            style: TextStyle(
                                fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12),
                                fontWeight: FontWeight.w600,
                                fontFamily: AppTheme.fontTTNorms,
                                color: AppTheme.white
                            )
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: HexColor(controller.cursosUi.color1)),
                              right: BorderSide(color: HexColor(controller.cursosUi.color1)),
                            ),
                            color: HexColor(controller.cursosUi.color1)
                        )
                    );
                  }else if(o is EvaluacionUi){
                    return ClipRRect(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8))),
                      child: Container(
                          constraints: BoxConstraints.expand(),
                          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)),
                          child: Center(
                            child:  RotatedBox(
                              quarterTurns: -1,
                              child: Text("Nota Final",
                                  textAlign: TextAlign.center,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppTheme.fontTTNorms,
                                      color: AppTheme.darkText
                                  )
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppTheme.greyLighten2),
                                right: BorderSide(color: AppTheme.greyLighten2),
                              ),
                              color: AppTheme.greyLighten4
                          )
                      ),
                    );
                  }else if(o is RubricaEvaluacionUi){
                    return Container(
                        constraints: BoxConstraints.expand(),
                        padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)),
                        child: Center(
                          child:  RotatedBox(
                            quarterTurns: -1,
                            child: Text(o.titulo??"",
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12),
                                  fontFamily: AppTheme.fontTTNorms,
                                  fontWeight: FontWeight.w700,
                              )
                            ),
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
                                padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)),
                                child: Icon(Ionicons.globe_outline,
                                    size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 30),
                                    color:o.publicado? AppTheme.colorAccent:AppTheme.grey
                                ),
                              ),

                            ],
                          ),
                      ),
                    );
                  }else
                    return Container();
                },
                rowsTitleBuilder: (i) {
                  dynamic o = controller.rowList2[i];
                  if(o is PersonaUi){
                    return  InkWell(
                      onTap: (){
                        Navigator.of(context).push(PreviewImageView.createRoute(o.foto));
                      },
                      child: Container(
                          constraints: BoxConstraints.expand(),
                          child: Row(
                            children: [
                              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4))),
                              Expanded(
                                  child: Text((i+1).toString() + ".",
                                      style: TextStyle(
                                          color: AppTheme.darkText,
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontWeight: FontWeight.w700,
                                          fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 10)
                                      )
                                  )
                              ),
                              Container(
                                height: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 22),
                                width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 22),
                                margin: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 3)),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.greyLighten2,
                                ),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => SizedBox(
                                    child: Shimmer.fromColors(
                                      baseColor: Color.fromRGBO(217, 217, 217, 0.3),
                                      highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                      child: Container(
                                        padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                        decoration: BoxDecoration(
                                            color: HexColor(controller.cursosUi.color2),
                                            shape: BoxShape.circle
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                  imageUrl: o.foto??"",
                                  errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 25),),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 15))),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                      ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 1))),
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
                      ),
                    );
                  }else if(o is RubricaEvalEquipoIntegranteUi){
                    return  InkWell(
                      onTap: (){
                        Navigator.of(context).push(PreviewImageView.createRoute(o.personaUi?.foto));
                      },
                      child: Container(
                          constraints: BoxConstraints.expand(),
                          child: Row(
                            children: [
                              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4))),
                              Expanded(
                                  child: Text( "${o.posicion??0}.",
                                      style: TextStyle(
                                          color: AppTheme.darkText,
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontWeight: FontWeight.w700,
                                          fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 10)
                                      )
                                  )
                              ),
                              Container(
                                height: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 22),
                                width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 22),
                                margin: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 3)),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.greyLighten2,
                                ),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => SizedBox(
                                    child: Shimmer.fromColors(
                                      baseColor: Color.fromRGBO(217, 217, 217, 0.3),
                                      highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                      child: Container(
                                        padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                        decoration: BoxDecoration(
                                            color: HexColor(controller.cursosUi.color2),
                                            shape: BoxShape.circle
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                  imageUrl: o.personaUi?.foto??"",
                                  errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 25),),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 15))),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                      ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 1))),
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
                      ),
                    );
                  }else if(o is RubricaEvaluacionEquipoUi){
                    return  Container(
                      child: Center(
                        child: Text("G. ${o.orden??0}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                                color: AppTheme.black,
                                fontFamily: AppTheme.fontTTNorms,
                                fontWeight: FontWeight.w800
                            )
                        ),
                      ),
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppTheme.greyLighten2),
                              right: BorderSide(color: AppTheme.greyLighten2),
                              left: BorderSide(color: AppTheme.greyLighten2),
                            ),
                            color: HexColor(controller.cursosUi.color3).withOpacity(0.3)
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
                            Text(o.apellidos??"",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 10),
                                  color: AppTheme.black,
                                  fontFamily: AppTheme.fontTTNorms,
                                  fontWeight: FontWeight.w700
                              )
                            ),
                            Text(o.nombres??"",
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 10),
                                  fontFamily: AppTheme.fontTTNorms,
                                  fontWeight: FontWeight.w500
                              )
                            ),
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
                  }else if(o is RubricaEvalEquipoIntegranteUi){
                    return Container(
                        constraints: BoxConstraints.expand(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(o.personaUi?.apellidos??"",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 10),
                                    color: AppTheme.black,
                                    fontFamily: AppTheme.fontTTNorms,
                                    fontWeight: FontWeight.w700
                                )
                            ),
                            Text(o.personaUi?.nombres??"",
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 10),
                                    fontFamily: AppTheme.fontTTNorms,
                                    fontWeight: FontWeight.w500
                                )
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppTheme.greyLighten2),
                              right: BorderSide(color:  AppTheme.greyLighten2),
                            ),
                            color: _getColorAlumnoBloqueados(o.personaUi, 0)
                        )
                    );
                  }else if(o is EvaluacionUi && i == controller.columnList2.length-3){
                    return InkWell(
                      onTap: () {
                        if(o.personaUi?.contratoVigente??true){
                          //offset = scrollController.offset;
                          //scrollController.jumpTo(0.0);
                          //showDialogEvaluacionAlumno(controller, o);
                          controller.onClicEvaluacionRubrica(o);
                          //if (_controller.isDismissed){
                            _controller.forward();
                         // } else if (_controller.isCompleted){
                           // _controller.reverse();
                          //}
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
                         !controller.isCalendarioDesactivo()?Container():
                          Positioned(
                              bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                              right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                              child: Icon(Icons.block,
                                color: AppTheme.redLighten1.withOpacity(0.8),
                                size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
                              )
                          ),
                        ],
                      ),
                    );
                  }else if(o is EvaluacionUi){
                    return InkWell(
                      onTap: () {
                        if(o.personaUi?.contratoVigente??true){
                          //offset = scrollController.offset;
                          //scrollController.jumpTo(0.0);
                          //showDialogEvaluacionAlumno(controller, o);
                          controller.onClicEvaluacionRubrica(o);
                          //if (_controller.isDismissed){
                            _controller.forward();
                          //} else if (_controller.isCompleted){
                           // _controller.reverse();
                          //}
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
                         !controller.isCalendarioDesactivo()?Container():
                          Positioned(
                              bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                              right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                              child: Icon(Icons.block,
                                color: AppTheme.redLighten1.withOpacity(0.8),
                                size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
                              )
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
                        child: Container(
                          child: Icon(Ionicons.globe_outline,
                              size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 30),
                              color:o.publicado? AppTheme.colorAccent:AppTheme.grey
                          ),
                        ),
                      ),
                    );
                  }else if(o is RubricaEvaluacionEquipoUi){
                    return Container(
                        constraints: BoxConstraints.expand(),
                        child: Center(
                          child: Text("${(o.nombreEquipo??"").isNotEmpty?o.nombreEquipo:"Grupo ${o.orden??0}"}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                                  color: AppTheme.black,
                                  fontFamily: AppTheme.fontTTNorms,
                                  fontWeight: FontWeight.w700
                              )
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppTheme.greyLighten2),
                              right: BorderSide(color:  AppTheme.greyLighten2),
                            ),
                            color:  HexColor(controller.cursosUi.color3).withOpacity(0.3)
                        )
                    );
                  }else if(o is EvaluacionEquipoUi && i == controller.columnList2.length-3){
                    if((o.equipoEvaluacionProcesoId??"").isNotEmpty){
                      return InkWell(
                        onTap: (){
                          controller.onClicEvaluacionRubricaEquipo(o);
                          _controllerGrupo.forward();
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
                                color:HexColor(controller.cursosUi.color3).withOpacity(0.4),
                              ),
                              child: _getGrupoTipoNota(o, o.nota, controller),
                            ),
                            !controller.isCalendarioDesactivo()?Container():
                            Positioned(
                                bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                                right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                                child: Icon(Icons.block,
                                    color: AppTheme.redLighten1.withOpacity(0.8),
                                    size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
                                )
                            ),
                          ],
                        ),
                      );
                    }else{
                      return   Container(
                        constraints: BoxConstraints.expand(),
                        decoration: BoxDecoration(
                          color:HexColor(controller.cursosUi.color3).withOpacity(0.3),
                        ),
                      );
                    }

                  }else if(o is EvaluacionEquipoUi){
                    if((o.equipoEvaluacionProcesoId??"").isNotEmpty){
                      return InkWell(
                        onTap: (){
                          controller.onClicEvaluacionRubricaEquipo(o);
                          _controllerGrupo.forward();
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
                                  color:  HexColor(controller.cursosUi.color3).withOpacity(0.3)
                              ),
                              child: _getGrupoTipoNota(o, o.nota, controller),
                            ),
                            !controller.isCalendarioDesactivo()?Container():
                            Positioned(
                                bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                                right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                                child: Icon(Icons.block,
                                    color: AppTheme.redLighten1.withOpacity(0.8),
                                    size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
                                )
                            ),
                          ],
                        ),
                      );
                    }else{
                      return   Container(
                        constraints: BoxConstraints.expand(),
                        decoration: BoxDecoration(
                          color:HexColor(controller.cursosUi.color3).withOpacity(0.3),
                        ),
                      );
                    }

                  }else{
                    return Container();
                  }

                },
                legendCell: Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: HexColor(controller.cursosUi.color1),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16)))
                        )
                    ),
                    Container(
                        child: Center(
                          child: Text('N°',
                            style: TextStyle(
                                color: AppTheme.white,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppTheme.fontTTNorms,
                                fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12)
                            )
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: AppTheme.greyLighten1),
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

  Widget showTableRubroDetalle(EvaluacionIndicadorMultipleController controller, PersonaUi? personaUi, List<double> tablecolumnWidths) {
    return SingleChildScrollView(
      child: StickyHeadersTableNotExpandedCustom(
        cellDimensions: CellDimensions.variableColumnWidth(
            stickyLegendHeight: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50),
            stickyLegendWidth: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 120),
            contentCellHeight: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 55),
            columnWidths: tablecolumnWidths
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
                padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)),
                child: Center(
                  child: Text("Nota",
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 13),
                        color:  AppTheme.darkText,
                        fontFamily: AppTheme.fontTTNorms,
                        fontWeight: FontWeight.w800,
                      )
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppTheme.greyLighten2),
                      right: BorderSide(color: AppTheme.greyLighten2),
                    ),
                )
            );
          }else if(o is ValorTipoNotaUi){
            return InkWell(
              onDoubleTap: () =>  controller.onClicClearEvaluacionAll(o, personaUi),
              onLongPress: () =>  controller.onClicEvaluacionAll(o, personaUi),
              child: Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(i == controller.mapColumnList[personaUi]!.length-1 - 0?8:0)
                      ),
                      child: _getTipoNotaCabeceraV2(o, controller)
                  ),
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
                        fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                        color:  AppTheme.white,
                        fontFamily: AppTheme.fontTTNorms,
                        fontWeight: FontWeight.w600,
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
                        borderRadius: BorderRadius.only(topRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)))
                    )
                ),
                Container(
                    child: Center(
                      child: Text('%',
                        style: TextStyle(
                            color: AppTheme.darkerText,
                            fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
                        )
                      ),
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
            return Container(

            );
        },
        rowsTitleBuilder: (i) {

          RubricaEvaluacionUi rubricaEvaluacionUi = controller.mapRowList[personaUi]![i];
          return  Container(
              constraints: BoxConstraints.expand(),
              padding: EdgeInsets.only(
                  left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8),
                  right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4)
              ),
              child: Center(
                  child: Text(rubricaEvaluacionUi.titulo??"",
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                        color:  AppTheme.colorAccent,
                        fontFamily: AppTheme.fontTTNorms,
                        fontWeight: FontWeight.w600,
                    ),
                  )
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
                padding: EdgeInsets.only(
                    left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                    right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4)
                ),
                child: Center(
                    child: Text(o.titulo??"",
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 10),
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
                  if(controller.precision && (o.valorTipoNotaUi?.tipoNotaUi?.intervalo??false)){
                    if(!controller.isCalendarioDesactivo()){
                      showDialogPresicion(controller, o, i, personaUi);
                    }
                  }else{
                    controller.onClicEvaluar(o, personaUi);
                  }
                }else{
                  _showControNoVigente(context, o.evaluacionUi?.personaUi);
                }

              },
              child: Stack(
                children: [
                  _getTipoNotaV2(o, controller, controller.mapCellListList[personaUi]?.length,i, j),
                 !controller.isCalendarioDesactivo()?Container():
                  Positioned(
                      bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                      right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                      child: Icon(Icons.block,
                          color: AppTheme.redLighten1.withOpacity(0.8),
                        size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
                      )
                  ),
                ],
              ),
            );
          }else if(o is EvaluacionUi){
            return InkWell(
              onTap: () => showDialogTecladoNumerico(controller, o),
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
                    child: _getTipoNota(o, o.nota, controller),
                  ),
                 !controller.isCalendarioDesactivo()?Container():
                  Positioned(
                      bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                      right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                      child: Icon(Icons.block,
                          color: AppTheme.redLighten1.withOpacity(0.8),
                        size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14))
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
                      child: Text("${(o.formula_peso).toStringAsFixed(0)}%",
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14),
                            color:  AppTheme.greyDarken1
                        ),
                      ),
                    ),
                  ),
                 !controller.isCalendarioDesactivo()?Container():
                  Positioned(
                      bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                      right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                      child: Icon(Icons.block,
                        color: AppTheme.redLighten1.withOpacity(0.8),
                        size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
                      )
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
                    color: HexColor(controller.cursosUi.color1),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)))
                )
            ),
            Container(
                child: Center(
                  child: Text('Criterios',
                    style: TextStyle(
                        color: AppTheme.white,
                        fontFamily: AppTheme.fontTTNorms,
                        fontWeight: FontWeight.w700,
                        fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12)
                    )
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: HexColor(controller.cursosUi.color1),),
                  ),
                )
            ),

          ],
        ),
      ),
    );

  }

  Widget showTableRubroEquipoDetalle(EvaluacionIndicadorMultipleController controller, RubricaEvaluacionEquipoUi? rubricaEvaluacionEquipoUi, List<double> tablecolumnWidths) {

    return SingleChildScrollView(
      child: StickyHeadersTableNotExpandedCustom(
        cellDimensions: CellDimensions.variableColumnWidth(
            stickyLegendHeight: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50),
            stickyLegendWidth: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 120),
            contentCellHeight: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 55),
            columnWidths: tablecolumnWidths
        ),
        //cellAlignments: CellAlignments.,
        scrollControllers: ScrollControllers() ,
        columnsLength: controller.mapColumnEquipoList[rubricaEvaluacionEquipoUi?.equipoId]?.length??0,
        rowsLength: controller.mapRowEquipoList[rubricaEvaluacionEquipoUi?.equipoId]?.length??0,
        columnsTitleBuilder: (i) {
          dynamic o = controller.mapColumnEquipoList[rubricaEvaluacionEquipoUi?.equipoId]![i];
          if(o is RubricaEvaluacionEquipoUi){
            return Container(
                constraints: BoxConstraints.expand(),
                padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)),
                child: Center(
                  child: Text("Nota",
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 13),
                        color:  AppTheme.darkText,
                        fontFamily: AppTheme.fontTTNorms,
                        fontWeight: FontWeight.w800,
                      )
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.greyLighten2),
                    right: BorderSide(color: AppTheme.greyLighten2),
                  ),
                )
            );
          }else if(o is ValorTipoNotaUi){
            return InkWell(
              onDoubleTap: () =>  controller.onClicClearEvaluacionAllEquipo(o, rubricaEvaluacionEquipoUi),
              onLongPress: () =>  controller.onClicEvaluacionAllEquipo(o, rubricaEvaluacionEquipoUi),
              child: Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(i == controller.mapColumnEquipoList[rubricaEvaluacionEquipoUi?.equipoId]!.length-1 - 0?8:0)
                      ),
                      child: _getTipoNotaCabeceraV2(o, controller)
                  ),
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
                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                      color:  AppTheme.white,
                      fontFamily: AppTheme.fontTTNorms,
                      fontWeight: FontWeight.w600,
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
                        borderRadius: BorderRadius.only(topRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)))
                    )
                ),
                Container(
                    child: Center(
                      child: Text('%',
                          style: TextStyle(
                              color: AppTheme.darkerText,
                              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
                          )
                      ),
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
            return Container(

            );
        },
        rowsTitleBuilder: (i) {

          RubricaEvaluacionUi rubricaEvaluacionUi = controller.mapRowEquipoList[rubricaEvaluacionEquipoUi?.equipoId]![i];
          return  Container(
              constraints: BoxConstraints.expand(),
              padding: EdgeInsets.only(
                  left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8),
                  right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4)
              ),
              child: Center(
                  child: Text(rubricaEvaluacionUi.titulo??"",
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                      color:  AppTheme.colorAccent,
                      fontFamily: AppTheme.fontTTNorms,
                      fontWeight: FontWeight.w600,
                    ),
                  )
              ),
              decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.greyLighten2),
                    right: BorderSide(color: AppTheme.greyLighten2),
                    left: BorderSide(color: AppTheme.greyLighten2),
                    bottom: BorderSide(color: AppTheme.greyLighten2.withOpacity((controller.mapRowEquipoList[rubricaEvaluacionEquipoUi?.equipoId]?.length??0)-1 == i?1:0)),
                  ),
                  color: AppTheme.white
              )
          );
        },
        contentCellBuilder: (i, j){
          dynamic o = controller.mapCellListEquipoList[rubricaEvaluacionEquipoUi?.equipoId]![j][i];
          if(o is RubricaEvaluacionUi){
            return Container(
                constraints: BoxConstraints.expand(),
                padding: EdgeInsets.only(
                    left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                    right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4)
                ),
                child: Center(
                    child: Text(o.titulo??"",
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 10),
                          color:  AppTheme.colorAccent,
                          height: 1.2
                      ),
                    )
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.greyLighten2),
                    right: BorderSide(color:  AppTheme.greyLighten2),
                    bottom:  BorderSide(color:  AppTheme.greyLighten2.withOpacity((controller.mapCellListEquipoList[rubricaEvaluacionEquipoUi?.equipoId]!.length-1) <= j ? 1:0)),
                  ),
                )
            );
          }else if(o is EvaluacionRubricaGrupoValorTipoNotaUi){
            return InkWell(
              onTap: () {
                if(controller.precision && (o.valorTipoNotaUi?.tipoNotaUi?.intervalo??false)){
                  if(!controller.isCalendarioDesactivo()){
                    showDialogPresicionEquipo(controller, o, i);
                  }
                }else{
                  controller.onClicEvaluarEquipo(o, rubricaEvaluacionEquipoUi);
                }
              },
              child: Stack(
                children: [
                  _getTipoNotaV2Equipo(o, controller, controller.mapCellListList[rubricaEvaluacionEquipoUi]?.length,i, j),
                  !controller.isCalendarioDesactivo()?Container():
                  Positioned(
                      bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                      right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                      child: Icon(Icons.block,
                          color: AppTheme.redLighten1.withOpacity(0.8),
                          size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
                      )
                  ),
                ],
              ),
            );
          }else if(o is RubricaEvaluacionEquipoUi){
            return InkWell(
              onTap: () => showDialogTecladoNumericoEquipo(controller, o),
              child: Stack(
                children: [
                  Container(
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppTheme.greyLighten2),
                          right: BorderSide(color:  AppTheme.greyLighten2),
                          bottom:  BorderSide(color:  AppTheme.greyLighten2.withOpacity((controller.mapCellListEquipoList[rubricaEvaluacionEquipoUi?.equipoId]!.length-1) <= j ? 1:0)),
                        ),
                        color: AppTheme.white
                    ),
                    child: _getTipoNotaEquipo(o, controller),
                  ),
                  !controller.isCalendarioDesactivo()?Container():
                  Positioned(
                      bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                      right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                      child: Icon(Icons.block,
                          color: AppTheme.redLighten1.withOpacity(0.8),
                          size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14))
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
                          bottom:  BorderSide(color:  AppTheme.greyLighten2.withOpacity((controller.mapCellListEquipoList[rubricaEvaluacionEquipoUi?.equipoId]!.length-1) <= j ? 1:0)),
                        ),
                        color: AppTheme.white
                    ),
                    child: Center(
                      child: Text("${(o.formula_peso).toStringAsFixed(0)}%",
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14),
                            color:  AppTheme.greyDarken1
                        ),
                      ),
                    ),
                  ),
                  !controller.isCalendarioDesactivo()?Container():
                  Positioned(
                      bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                      right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4),
                      child: Icon(Icons.block,
                          color: AppTheme.redLighten1.withOpacity(0.8),
                          size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
                      )
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
                    color: HexColor(controller.cursosUi.color1),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)))
                )
            ),
            Container(
                child: Center(
                  child: Text('Criterios',
                      style: TextStyle(
                          color: AppTheme.white,
                          fontFamily: AppTheme.fontTTNorms,
                          fontWeight: FontWeight.w700,
                          fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12)
                      )
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: HexColor(controller.cursosUi.color1),),
                  ),
                )
            ),

          ],
        ),
      ),
    );

  }

  Color _getColorAlumnoBloqueados(PersonaUi? personaUi, int intenciadad, {Color c_default = Colors.white}) {
    if(!(personaUi?.contratoVigente??true)){
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
                  fontFamily: AppTheme.fontTTNorms,
                  fontWeight: FontWeight.w600,
                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14),
                  color: color
              )),
        );
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        if(evaluacionUi?.valorTipoNotaUi!=null){
          return Container(
            margin: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 6)),
            child:  CachedNetworkImage(
              imageUrl: evaluacionUi?.valorTipoNotaUi?.icono??"",
              placeholder: (context, url) => SizedBox(
                child: Shimmer.fromColors(
                  baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                  highlightColor: Color.fromRGBO(166, 166, 166, 0.5),
                  child: Container(
                    padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                        color: HexColor(controller.cursosUi.color2),
                        shape: BoxShape.rectangle
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        }else{
          return Center(
            child: Text("-",
                style: TextStyle(
                    fontFamily: AppTheme.fontTTNorms,
                    fontWeight: FontWeight.w600,
                    fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14),
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
              fontFamily: AppTheme.fontTTNorms,
              fontWeight: FontWeight.w600,
              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
          ),),
        );
    }

  }

  Widget? _getTipoNotaEquipo(RubricaEvaluacionEquipoUi? rubricaEvaluacionEquipoUi, EvaluacionIndicadorMultipleController controller) {
    var tipo =TipoNotaTiposUi.VALOR_NUMERICO;
    if(!controller.precision) tipo = rubricaEvaluacionEquipoUi?.rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO;
    double? nota = rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.nota;
    switch(tipo){
      case TipoNotaTiposUi.SELECTOR_VALORES:
        Color color;
        if (("B" == (rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi?.titulo??"") || "C" == (rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi?.titulo??""))) {
          color = AppTheme.redDarken4;
        }else if (("AD" == (rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi?.titulo??"")) || "A" == (rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi?.titulo??"")) {
          color = AppTheme.blueDarken4;
        }else {
          color = AppTheme.black;
        }
        return Center(
          child: Text(rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi?.titulo??"-",
              style: TextStyle(
                  fontFamily: AppTheme.fontTTNorms,
                  fontWeight: FontWeight.w600,
                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14),
                  color: color
              )),
        );
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        if(rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi!=null){
          return Container(
            margin: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 6)),
            child:  CachedNetworkImage(
              imageUrl: rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi?.icono??"",
              placeholder: (context, url) => SizedBox(
                child: Shimmer.fromColors(
                  baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                  highlightColor: Color.fromRGBO(166, 166, 166, 0.5),
                  child: Container(
                    padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                        color: HexColor(controller.cursosUi.color2),
                        shape: BoxShape.rectangle
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        }else{
          return Center(
            child: Text("-",
                style: TextStyle(
                    fontFamily: AppTheme.fontTTNorms,
                    fontWeight: FontWeight.w600,
                    fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14),
                    color: AppTheme.black
                )),
          );
        }

      case TipoNotaTiposUi.VALOR_ASISTENCIA:
      case TipoNotaTiposUi.VALOR_NUMERICO:
      case TipoNotaTiposUi.SELECTOR_NUMERICO:
        if(nota == 0){
          if(rubricaEvaluacionEquipoUi?.rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES ||
              rubricaEvaluacionEquipoUi?.rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
            if(rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.valorTipoNotaUi?.tipoNotaId == null){
              nota = null;
            }
          }
        }
        return Center(
          child: Text("${nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
              fontFamily: AppTheme.fontTTNorms,
              fontWeight: FontWeight.w600,
              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
          ),),
        );
    }

  }

  Widget? _getGrupoTipoNota(EvaluacionEquipoUi? evaluacionUi, double? nota, EvaluacionIndicadorMultipleController controller) {
    var tipo =TipoNotaTiposUi.VALOR_NUMERICO;
    if(!controller.precision) tipo = evaluacionUi?.rubricaEvaluacionEquipoUi?.rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO;

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
                  fontFamily: AppTheme.fontTTNorms,
                  fontWeight: FontWeight.w600,
                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14),
                  color: color
              )),
        );
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        if(evaluacionUi?.valorTipoNotaUi!=null){
          return Container(
            margin: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 6)),
            child:  CachedNetworkImage(
              imageUrl: evaluacionUi?.valorTipoNotaUi?.icono??"",
              placeholder: (context, url) => SizedBox(
                child: Shimmer.fromColors(
                  baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                  highlightColor: Color.fromRGBO(166, 166, 166, 0.5),
                  child: Container(
                    padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                        color: HexColor(controller.cursosUi.color2),
                        shape: BoxShape.rectangle
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        }else{
          return Center(
            child: Text("-",
                style: TextStyle(
                    fontFamily: AppTheme.fontTTNorms,
                    fontWeight: FontWeight.w600,
                    fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14),
                    color: AppTheme.black
                )),
          );
        }

      case TipoNotaTiposUi.VALOR_ASISTENCIA:
      case TipoNotaTiposUi.VALOR_NUMERICO:
      case TipoNotaTiposUi.SELECTOR_NUMERICO:
        if(nota == 0){
          if(evaluacionUi?.rubricaEvaluacionEquipoUi?.rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES ||
              evaluacionUi?.rubricaEvaluacionEquipoUi?.rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
            if(evaluacionUi?.valorTipoNotaUi?.tipoNotaId == null){
              nota = null;
            }
          }
        }
        return Center(
          child: Text("${nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
              fontFamily: AppTheme.fontTTNorms,
              fontWeight: FontWeight.w600,
              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
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
                  fontFamily: AppTheme.fontTTNorms,
                  fontWeight: FontWeight.w900,
                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                  color: color_texto?.withOpacity((evaluacionRubricaValorTipoNotaUi.toggle??false)? 1 : 0.7)
              )),
        );
        break;
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        widget = Opacity(
          opacity: (evaluacionRubricaValorTipoNotaUi.toggle??false)? 1 : 0.7,
          child: Container(
            margin: EdgeInsets.all( ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4)),
            decoration: BoxDecoration(
                color: AppTheme.white.withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4)))
            ),
            child:  CachedNetworkImage(
              imageUrl: evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.icono??"",
              placeholder: (context, url) => SizedBox(
                child: Shimmer.fromColors(
                  baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                  highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                  child: Container(
                    padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                        color: HexColor(controller.cursosUi.color2),
                        shape: BoxShape.rectangle
                    ),
                    alignment: Alignment.center,
                  ),
                ),
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
              fontFamily: AppTheme.fontTTNorms,
              fontWeight: FontWeight.w900,
              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12),
              color: color_texto
          ),),
        );
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

  Widget _getTipoNotaV2Equipo(EvaluacionRubricaGrupoValorTipoNotaUi evaluacionRubricaGrupoValorTipoNotaUi, EvaluacionIndicadorMultipleController controller,int? length ,int positionX, int positionY) {
    Widget? widget = null;

    Color color_fondo;
    Color? color_texto;
    Color color_borde;

    if(positionX == 0){
      if(evaluacionRubricaGrupoValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#1976d2");
        color_texto = AppTheme.white;
        color_borde = HexColor("#1976d2");
      }else{
        color_fondo = AppTheme.white;
        color_texto = HexColor("#1976d2");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 1){
      if(evaluacionRubricaGrupoValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#388e3c");
        color_texto = AppTheme.white;
        color_borde = HexColor("#388e3c");
      }else{
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#388e3c");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 2){
      if(evaluacionRubricaGrupoValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#FF6D00");
        color_texto = AppTheme.white;
        color_borde = HexColor("#FF6D00");
      }else{
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#FF6D00");
        color_borde = AppTheme.greyLighten2;
      }
    }else if(positionX == 3){
      if(evaluacionRubricaGrupoValorTipoNotaUi.toggle??false){
        color_fondo = HexColor("#D32F2F");
        color_texto = AppTheme.white;
        color_borde = HexColor("#D32F2F");
      }else {
        color_fondo = AppTheme.white;
        color_texto =  HexColor("#D32F2F");
        color_borde = AppTheme.greyLighten2;
      }
    }else{
      if(evaluacionRubricaGrupoValorTipoNotaUi.toggle??false){
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
    if(!controller.precision) tipo = evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO;
    switch(tipo){
      case TipoNotaTiposUi.SELECTOR_VALORES:
        widget = Center(
          child: Text(evaluacionRubricaGrupoValorTipoNotaUi.valorTipoNotaUi?.titulo??"",
              style: TextStyle(
                  fontFamily: AppTheme.fontTTNorms,
                  fontWeight: FontWeight.w900,
                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                  color: color_texto?.withOpacity((evaluacionRubricaGrupoValorTipoNotaUi.toggle??false)? 1 : 0.7)
              )),
        );
        break;
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        widget = Opacity(
          opacity: (evaluacionRubricaGrupoValorTipoNotaUi.toggle??false)? 1 : 0.7,
          child: Container(
            margin: EdgeInsets.all( ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4)),
            decoration: BoxDecoration(
                color: AppTheme.white.withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4)))
            ),
            child:  CachedNetworkImage(
              imageUrl: evaluacionRubricaGrupoValorTipoNotaUi.valorTipoNotaUi?.icono??"",
              placeholder: (context, url) => SizedBox(
                child: Shimmer.fromColors(
                  baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                  highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                  child: Container(
                    padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                        color: HexColor(controller.cursosUi.color2),
                        shape: BoxShape.rectangle
                    ),
                    alignment: Alignment.center,
                  ),
                ),
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
        if(evaluacionRubricaGrupoValorTipoNotaUi.toggle??false)nota = evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.nota;
        else nota = evaluacionRubricaGrupoValorTipoNotaUi.valorTipoNotaUi?.valorNumerico;

        if(nota == 0){
          if(evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES ||
              evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES){
            if(evaluacionRubricaGrupoValorTipoNotaUi.valorTipoNotaUi?.tipoNotaId == null){
              nota = null;
            }
          }
        }
        widget = Center(
          child: Text("${nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
              fontFamily: AppTheme.fontTTNorms,
              fontWeight: FontWeight.w900,
              fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12),
              color: color_texto
          ),),
        );
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
          color: (evaluacionRubricaGrupoValorTipoNotaUi.toggle??false)?color_fondo: AppTheme.white
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
                    fontFamily: AppTheme.fontTTNorms,
                    fontWeight: FontWeight.w900,
                    fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 11),
                    color: color_texto
                )),
          ),
        );
        break;
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        nota = Container(
          width: ver_detalle?
          ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 23):
          ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 35),
          height: ver_detalle?
          ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 23):
          ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 35),
          decoration: BoxDecoration(
              color: AppTheme.white.withOpacity(0.2),
              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4)))
          ),
          child: CachedNetworkImage(
            imageUrl: valorTipoNotaUi?.icono ?? "",
            placeholder: (context, url) => SizedBox(
              child: Shimmer.fromColors(
                baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                child: Container(
                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                      color: HexColor(controller.cursosUi.color2),
                      shape: BoxShape.rectangle
                  ),
                  alignment: Alignment.center,
                ),
              ),
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
                  fontFamily: AppTheme.fontTTNorms,
                  fontWeight: FontWeight.w900,
                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12),
                  color: color_texto
              ),),
            )
        ],
      ),
    );
  }

  void showDialogPresicion(EvaluacionIndicadorMultipleController controller, EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, int position, PersonaUi? personaUi) {

    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return TecladoPresicionView2(
            //valorTipoNotaUi: evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi,
            //color: getPosition(position),
            //personaUi: evaluacionRubricaValorTipoNotaUi.evaluacionUi?.personaUi,
            valor: evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota,
            valorMaximo: evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi?.escalavalorMaximo,
            valorMinimo: evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi?.escalavalorMinimo,
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

  void showDialogPresicionEquipo(EvaluacionIndicadorMultipleController controller, EvaluacionRubricaGrupoValorTipoNotaUi evaluacionRubricaGrupoValorTipoNotaUi, int position) {

    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return TecladoPresicionView2(
            //valorTipoNotaUi: evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi,
            //color: getPosition(position),
            //personaUi: evaluacionRubricaValorTipoNotaUi.evaluacionUi?.personaUi,
            valor: evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.nota,
            valorMaximo: evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi?.escalavalorMaximo,
            valorMinimo: evaluacionRubricaGrupoValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi?.escalavalorMinimo,
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
        controller.onClicEvaluarPresicionEquipo(evaluacionRubricaGrupoValorTipoNotaUi, nota);
      }
    });
  }

  void showDialogTecladoNumerico(EvaluacionIndicadorMultipleController controller, EvaluacionUi? evaluacionUi) {

    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return TecladoPresicionView2(
            valorMaximo: evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi?.escalavalorMaximo,
            valorMinimo:  evaluacionUi?.rubroEvaluacionUi?.tipoNotaUi?.escalavalorMinimo,
            valor: evaluacionUi?.nota,
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

  void showDialogTecladoNumericoEquipo(EvaluacionIndicadorMultipleController controller, RubricaEvaluacionEquipoUi? rubricaEvaluacionEquipoUi) {

    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return TecladoPresicionView2(
            valorMaximo: rubricaEvaluacionEquipoUi?.rubricaEvaluacionUi?.tipoNotaUi?.escalavalorMaximo,
            valorMinimo:  rubricaEvaluacionEquipoUi?.rubricaEvaluacionUi?.tipoNotaUi?.escalavalorMinimo,
            valor: rubricaEvaluacionEquipoUi?.evaluacionEquipoUi?.nota,
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
        controller.onSaveTecladoPresicionEquipo(nota, rubricaEvaluacionEquipoUi);
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
      return  AppTheme.greyDarken1;
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

  Future<bool?> _showDialogEliminarComentario(EvaluacionIndicadorMultipleController controller) async {
    /*RubroCrearController controller =
    FlutterCleanArchitecture.getController<RubroCrearController>(context, listen: false);*/
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
                            width: 45,
                            height: 45,
                            child: Icon(Ionicons.close, size: 35, color: AppTheme.white,),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HexColor(controller.cursosUi.color1)),
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("Eliminar comentario",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppTheme.fontTTNormsMedium
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
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Cancelar', style: TextStyle(fontSize: 14),),
                                style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    primary: AppTheme.darkText
                                ),
                              )
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: AppTheme.redLighten4,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Aceptar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.red,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
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

  Future<bool?> _showDialogEliminarEvidencia(EvaluacionIndicadorMultipleController controller) async {
    /*RubroCrearController controller =
    FlutterCleanArchitecture.getController<RubroCrearController>(context, listen: false);*/
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
                            width: 45,
                            height: 45,
                            child: Icon(Ionicons.close, size: 35, color: AppTheme.white,),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HexColor(controller.cursosUi.color1)),
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("Eliminar evidencia",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppTheme.fontTTNormsMedium
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
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Cancelar', style: TextStyle(fontSize: 14),),
                                style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    primary: AppTheme.darkText
                                ),
                              )
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: AppTheme.redLighten4,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Aceptar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.red,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
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
        break;
    }
  }

  @override
  userDocument(List<File?> _documents) {
    if(globalKey.currentContext!=null){
      print("document ${_documents.length}");
      EvaluacionIndicadorMultipleController controller =
      FlutterCleanArchitecture.getController<EvaluacionIndicadorMultipleController>(globalKey.currentContext!, listen: false);
      controller.addEvidencia(_documents, null);
    }
  }

  @override
  userImage(File? _image, String? newName) {
     if(globalKey.currentContext!=null&&(_image?.path??"").isNotEmpty){
      EvaluacionIndicadorMultipleController controller =
      FlutterCleanArchitecture.getController<EvaluacionIndicadorMultipleController>(globalKey.currentContext!, listen: false);
      List<File?> files = [];
      files.add(_image);
      controller.addEvidencia(files,newName);
      print("image ${_image?.path}");
    }
  }

  @override
  userCrop(Uint8List? _image, String? newName) {

  }
}
