
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/indicador/individual/evaluacion_indicador_controller.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/presicion/precision_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/presicion/teclado_precision_2_view.dart';
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
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_publicado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubro_evidencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';

class EvaluacionIndicadorView extends View{
  RubricaEvaluacionUi? rubroEvaluacionUi;
  CursosUi? cursosUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;


  EvaluacionIndicadorView(this.rubroEvaluacionUi, this.cursosUi, this.calendarioPeriodoUI);

  @override
  EvaluacionIndicadorState createState() => EvaluacionIndicadorState(rubroEvaluacionUi, cursosUi, calendarioPeriodoUI);

}

class EvaluacionIndicadorState extends ViewState<EvaluacionIndicadorView, EvaluacionIndicadorController> with TickerProviderStateMixin, ImagePickerListener{

  EvaluacionIndicadorState(rubroEvaluacionUi, cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI) : super(EvaluacionIndicadorController(rubroEvaluacionUi, cursosUi, calendarioPeriodoUI, MoorRubroRepository(), MoorConfiguracionRepository(), DeviceHttpDatosRepositorio()));

  TextEditingController _controllerComentario = TextEditingController();
  late final ScrollController scrollController = ScrollController();
  late final ScrollControllers crollControllers = ScrollControllers();
  late double topBarOpacity = 0.0;

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
    _imagePickerAnimationcontroller.dispose();
    _controllerComentario.dispose();
    super.dispose();
  }

  @override
  Widget get view => ControlledWidgetBuilder<EvaluacionIndicadorController>(
      builder: (context, controller) {
        return WillPopScope(
          key: globalKey,
          onWillPop: () async {
            bool?  se_a_modicado = await controller.onSave();
            if(se_a_modicado??false){
              Navigator.of(context).pop(1);//si devuelve un entero se actualiza toda la lista;
              await Future.delayed(Duration(seconds: 1));
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
                  getMainTab(controller),
                  getAppBarUI(controller),
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
                                        await Future.delayed(const Duration(milliseconds: 300), () {
                                          Navigator.of(context).pop(-1);//si devuelve un entero se actualiza toda la lista. -1 si se elimino la rubrica
                                        });

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
                    ),
                  if(controller.showDialogComentario)
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
                          padding: EdgeInsets.all(32),
                          constraints: BoxConstraints(minWidth: 100, maxWidth: 400),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text("Comentarios privados (Sólo lo ve el padre)",
                                              style: TextStyle(
                                                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12),
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
                                            var rubroComentarioUi =  controller.evaluacionUiSelected!.comentarios![index];
                                            return Container(
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
                                                              color: HexColor(controller.cursosUi?.color2),
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
                                                              Text("${DomainTools.f_fecha_letras(rubroComentarioUi.fechaCreacion)}",
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
                                                            child: Text("${rubroComentarioUi.comentario??""}",
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
                                                        controller.eliminarComentario(rubroComentarioUi, controller.evaluacionUiSelected);
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
                                          itemCount: controller.evaluacionUiSelected?.comentarios?.length??0,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8))
                                        ),
                                        Container(
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
                                                          color: HexColor(controller.cursosUi?.color2),
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
                                                        controller.saveComentario(_controllerComentario.text, controller.evaluacionUiSelected);
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
                                          child: Text("Evidencias (Sólo lo ve el padre)",
                                              style: TextStyle(
                                                color: AppTheme.colorPrimary,
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontWeight: FontWeight.w700,
                                                fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12),
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
                                                    imagePicker.showDialog(context);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: HexColor(controller.cursosUi?.color2).withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(8), // use instead of BorderRadius.all(Radius.circular(20))
                                                    ),
                                                    width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 450),
                                                    height: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 60),
                                                    child: FDottedLine(
                                                      color: HexColor(controller.cursosUi?.color1).withOpacity(0.6),
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
                                                            color: HexColor(controller.cursosUi?.color1).withOpacity(0.8)
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
                                                bottom: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16)),
                                            itemCount: controller.evaluacionUiSelected?.evidencias?.length??0,
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index){
                                              RubroEvidenciaUi rubroEvidenciaUi =  controller.evaluacionUiSelected!.evidencias![index];

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
                                                                color: HexColor(controller.cursosUi?.color1)
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
                                                                        controller.removeRubroEvidencia(rubroEvidenciaUi);
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
                                                                  color: HexColor(controller.cursosUi?.color2),
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
                                      ],
                                    ),
                                  )
                              ),
                              Container(
                                height: 1,
                              width: double.infinity,
                                color: AppTheme.greyLighten1,
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8))
                              ),
                              Row(
                                children: [

                                  Padding(padding: EdgeInsets.all(8)),
                                  Expanded(child: OutlinedButton(
                                    onPressed: () {
                                      controller.onhideDialogComentario();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: AppTheme.colorPrimary,
                                      onPrimary: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text('Atras',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontSize:  ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14)
                                      ),
                                    ),
                                  )),
                                ],
                              )
                            ],
                          )
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

  Widget getAppBarUI(EvaluacionIndicadorController controller) {
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
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        child:  IconButton(
                          icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                          onPressed: () async {
                            bool? respuesta = await controller.onSave();
                            if(respuesta??false){
                              Navigator.of(context).pop(1);//si devuelve un entero se actualiza toda la lista
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
                                      color: HexColor(controller.cursosUi?.color2)
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

  Widget getMainTab(EvaluacionIndicadorController controller) {
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
                                      color:  controller.precision?HexColor(controller.cursosUi?.color2) : AppTheme.greyLighten2
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
                                onTap: (){
                                  if(controller.rubroEvaluacionUi!=null){
                                    AppRouter.createRouteRubroCrearRouter(context, controller.cursosUi, controller.calendarioPeriodoUI, null, null, controller.rubroEvaluacionUi, false);
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
                                      color:HexColor(controller.cursosUi?.color2)
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
                                onTap: (){
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
                            color: HexColor(controller.cursosUi?.color3).withOpacity(0.1),
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
                                        color: HexColor(controller.cursosUi?.color1),
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
                            color: HexColor(controller.cursosUi?.color1),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ),
          SliverToBoxAdapter(
            child: showTableRubrica(controller),
          ),
        ],
      ),
    );
  }

  Widget showTableRubrica(EvaluacionIndicadorController controller) {
    List<double> tablecolumnWidths = [];
    for(dynamic s in controller.columnList2){
      if(s is ContactoUi){
        tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 90));
      } else if(s is EvaluacionUi){
        tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 65));
      } else if(s is RubroEvidenciaUi){
        tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50));
      } else if(s is EvaluacionPublicadoUi){
        tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50));
      }else{
        tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 55));
      }
    }

    return  FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: MediaQuery.of(context).size.height/2,
          child: Stack(
            children: [
              Center(
                child: CircularProgressIndicator(strokeWidth: 2,),
              )
            ],
          ),
          );
        } else {
          return  Padding(
            padding: EdgeInsets.only(
              top: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 24),
              left: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16)
            ),
            child: SingleChildScrollView(
              child: StickyHeadersTableNotExpandedCustom(
                cellDimensions: CellDimensions.variableColumnWidth(
                    stickyLegendHeight: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 65),
                    stickyLegendWidth: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50),
                    contentCellHeight: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 50),
                    columnWidths: tablecolumnWidths
                ),
                //cellAlignments: CellAlignments.,
                scrollControllers: crollControllers,
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
                                fontWeight: FontWeight.w500,
                                fontFamily: AppTheme.fontTTNorms,
                                color: AppTheme.white
                            )
                          ),
                        ),
                        decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: HexColor(controller.cursosUi?.color1)),
                              right: BorderSide(color: HexColor(controller.cursosUi?.color1)),
                            ),
                            color: HexColor(controller.cursosUi?.color1)
                        )
                    );
                  }else if(o is EvaluacionUi){
                    return Container(
                        constraints: BoxConstraints.expand(),
                        padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)),
                        child: Center(
                          child:  Text("Nota",
                            textAlign: TextAlign.center,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12),
                                color: AppTheme.darkText,
                                fontWeight: FontWeight.w900,
                                fontFamily: AppTheme.fontTTNorms
                            )
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
                  }if(o is ValorTipoNotaUi){
                    return InkWell(
                      onDoubleTap: () =>  controller.onClikShowDialogClearEvaluacion(),
                      onLongPress: () => controller.onClicEvaluacionAll(o),
                      child: Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(i == controller.columnList2.length-1 - 3?8:0)
                              ),
                              child:_getTipoNotaCabecera(o, controller,i)
                          ),

                        ],
                      ),
                    );
                  }else if(o is EvaluacionPublicadoUi){
                    return InkWell(
                      onTap: (){
                        controller.onClicPublicarAll(o);
                      },
                      child: Container(
                        child: Icon(Ionicons.globe_outline,
                          size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 30),
                          color: o.publicado? AppTheme.colorAccent:AppTheme.grey
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
                              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 3))),
                              Expanded(
                                  child: Text((i+1).toString() + ".",
                                    style: TextStyle(
                                        color: AppTheme.darkText,
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontWeight: FontWeight.w700,
                                        fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 10)
                                    ),)
                              ),
                              Container(
                                height: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 22),
                                width: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 22),
                                margin: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 3)),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.greyLighten2,
                                ),
                                child:  CachedNetworkImage(
                                  placeholder: (context, url) =>  SizedBox(
                                    child: Shimmer.fromColors(
                                      baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                      highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                      child: Container(
                                        padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)),
                                        decoration: BoxDecoration(
                                            color: HexColor(controller.cursosUi?.color2),
                                            shape: BoxShape.circle
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                  imageUrl: o.foto??"",
                                  errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 20,),
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
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(1)),
                            ],
                          ),
                          decoration: BoxDecoration(
                              border: (controller.cellListList.length-4) <= i ? Border(
                                top: BorderSide(color: AppTheme.greyLighten2),
                                right: BorderSide(color:  AppTheme.greyLighten2),
                                left: BorderSide(color:  AppTheme.greyLighten2),
                                bottom:  BorderSide(color:  AppTheme.greyLighten2),
                              ):Border(
                                top: BorderSide(color: AppTheme.greyLighten2),
                                right: BorderSide(color:  AppTheme.greyLighten2),
                                left: BorderSide(color:  AppTheme.greyLighten2),
                              ),
                              color: AppTheme.white
                          )
                      ),
                    );
                  }else {
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
                            border: (controller.cellListList.length-4) <= j ? Border(
                              top: BorderSide(color: AppTheme.greyLighten2),
                              right: BorderSide(color:  AppTheme.greyLighten2),
                              bottom:  BorderSide(color:  AppTheme.greyLighten2),
                            ):Border(
                              top: BorderSide(color: AppTheme.greyLighten2),
                              right: BorderSide(color:  AppTheme.greyLighten2),
                            ),
                            color: _getColorAlumnoBloqueados(o, 0)
                        )
                    );
                  }else if(o is EvaluacionRubricaValorTipoNotaUi){
                    return InkWell(
                      onTap: () {
                        if((o.evaluacionUi?.personaUi?.contratoVigente == true)){
                          if(controller.precision && (o.valorTipoNotaUi?.tipoNotaUi?.intervalo??false))
                            showDialogPresicion(context, o, i);
                          else
                            controller.onClicEvaluar(o);
                        }else{
                          _showControNoVigente(context, o.evaluacionUi?.personaUi);
                        }
                      },
                      child: Stack(
                        children: [
                          _getTipoNota(o, controller,i, j),
                          controller.calendarioPeriodoUI?.habilitadoProceso != 1?
                          Positioned(
                              bottom: 4,
                              right: 4,
                              child: Icon(Icons.block, color: AppTheme.redLighten1, size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),)
                          ):Container(),
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
                                ),
                                color: _getColorAlumnoBloqueados(o.personaUi, 0)
                            ),
                            child: Center(
                              child: Text("${o.nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
                                  fontFamily: AppTheme.fontTTNorms,
                                  fontWeight: FontWeight.w700,
                                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12),
                              ),),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if(o is RubroEvidenciaUi){
                    return InkWell(
                      onTap: (){
                        controller.onClickComentario(o.evaluacionUi);
                      },
                      child: Container(
                        child: Icon(Ionicons.chatbox_ellipses_outline,
                          size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 30),
                          color: AppTheme.tealDarken4,),
                      ),
                    );
                  }else if(o is EvaluacionPublicadoUi){//publicado
                    return InkWell(
                      onTap: (){
                        if(o.evaluacionUi?.personaUi?.contratoVigente??true){
                          controller.onClicPublicado(o);
                        }else{
                          _showControNoVigente(context, o.evaluacionUi?.personaUi);
                        }

                      },
                      child: Container(
                        //color: _getColorAlumnoBloqueados(o.evaluacionUi?.personaUi, 0),
                        child: Icon(Ionicons.globe_outline,
                            size: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 30),
                            color:o.publicado? AppTheme.colorAccent:AppTheme.grey
                        ),
                      ),
                    );
                  }else {
                    return Container();
                  }

                },
                legendCell: Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: HexColor(controller.cursosUi?.color1),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 8)))
                        )
                    ),
                    Container(
                        child: Center(
                          child: Text('N°',
                            style: TextStyle(
                                color: AppTheme.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppTheme.fontTTNorms,
                                fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 12)
                            )
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: HexColor(controller.cursosUi?.color1)),
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

  Widget _getTipoNotaCabecera(ValorTipoNotaUi? valorTipoNotaUi,EvaluacionIndicadorController controller, int position) {
    Widget? nota = null;
    Color color_fondo;
    Color? color_texto;
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
                    fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 16),
                    color: color_texto
                )),
          ),
        );
        break;
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        nota = Container(
          margin: EdgeInsets.only(top: ver_detalle?4:0),
          width: ver_detalle?
          ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 35):
          ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 45),
          height: ver_detalle?
          ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 35):
          ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 45),
          decoration: BoxDecoration(
              color: AppTheme.white.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4)))
          ),
          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 0)),
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
                      color: HexColor(controller.cursosUi?.color2),
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
              child: Text("${(valorTipoNotaUi?.valorNumerico??0).toStringAsFixed(1)}", style: TextStyle(
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

  Widget _getTipoNota(EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, EvaluacionIndicadorController controller, int positionX, int positionY) {
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
    if(!controller.precision) tipo = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO;
    switch(tipo){
      case TipoNotaTiposUi.SELECTOR_VALORES:
        widget = Center(
          child: Text(evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.titulo??"",
              style: TextStyle(
                  fontFamily: AppTheme.fontTTNormsMedium,
                  fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14),
                  color: color_texto
              )),
        );
        break;
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        widget = Opacity(
          opacity: (evaluacionRubricaValorTipoNotaUi.toggle??false)? 1 : 0.7,
          child: Container(
            decoration: BoxDecoration(
                color: AppTheme.white.withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4)))
            ),
            margin: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 4)),
            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 0)),
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
                        color: HexColor(controller.cursosUi?.color2),
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
        var nota = 0.0;
        if(evaluacionRubricaValorTipoNotaUi.toggle??false)nota = evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota??0;
        else nota = evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorNumerico??0;
      widget = Center(
        child: Text("${nota.toStringAsFixed(1)}", style: TextStyle(
            fontFamily: AppTheme.fontTTNorms,
            fontWeight: FontWeight.w900,
            fontSize: ColumnCountProvider.aspectRatioForWidthEvaluacionRubrica(context, 14),
            color: color_texto?.withOpacity((evaluacionRubricaValorTipoNotaUi.toggle??false)? 1 : 0.6)
        ),),
      );;
      break;
    }

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          border: (controller.cellListList.length-4) <= positionY ? Border(
            top: BorderSide(color: AppTheme.greyLighten2),
            right: BorderSide(color:  color_borde),
            bottom:  BorderSide(color:  AppTheme.greyLighten2),
          ):Border(
            top: BorderSide(color: AppTheme.greyLighten2),
            right: BorderSide(color:  color_borde),
          ),
          color: (evaluacionRubricaValorTipoNotaUi.toggle??false)?color_fondo:_getColorAlumnoBloqueados(evaluacionRubricaValorTipoNotaUi.evaluacionUi?.personaUi, 0)
      ),
      child: widget,
    );

  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
    return true;
  }

  void showDialogPresicion(BuildContext context, EvaluacionRubricaValorTipoNotaUi evaluacionRubricaValorTipoNotaUi, int position) {
    EvaluacionIndicadorController controller =
    FlutterCleanArchitecture.getController<EvaluacionIndicadorController>(context, listen: false);


    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return TecladoPresicionView2(
            valorMaximo: evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi?.escalavalorMaximo,
            valorMinimo: evaluacionRubricaValorTipoNotaUi.rubricaEvaluacionUi?.tipoNotaUi?.escalavalorMinimo,
            valor: (evaluacionRubricaValorTipoNotaUi.evaluacionUi?.valorTipoNotaUi)!=null?
              evaluacionRubricaValorTipoNotaUi.evaluacionUi?.nota:
            evaluacionRubricaValorTipoNotaUi.valorTipoNotaUi?.valorNumerico,
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

  void showDialogTecladoNumerico(EvaluacionIndicadorController controller, EvaluacionUi? evaluacionUi) {

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

  Future<bool?> _showDialogEliminarComentario(EvaluacionIndicadorController controller) async {
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
                                color: HexColor(controller.cursosUi?.color1)),
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

  Future<bool?> _showDialogEliminarEvidencia(EvaluacionIndicadorController controller) async {
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
                                color: HexColor(controller.cursosUi?.color1)),
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
      EvaluacionIndicadorController controller =
      FlutterCleanArchitecture.getController<EvaluacionIndicadorController>(globalKey.currentContext!, listen: false);
      controller.addEvidencia(_documents, null);

    }
  }

  @override
  userImage(File? _image, String? newName) {
    if(globalKey.currentContext!=null&&(_image?.path??"").isNotEmpty){
      EvaluacionIndicadorController controller =
      FlutterCleanArchitecture.getController<EvaluacionIndicadorController>(globalKey.currentContext!, listen: false);
      List<File?> files = [];
      files.add(_image);
      controller.addEvidencia(files,newName);
      print("image ${_image?.path}");
    }
  }

}
