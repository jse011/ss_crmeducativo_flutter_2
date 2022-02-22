

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/example/main.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_not_expanded_custom.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/sesion_controller.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/crear/tarea_crear_controller.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/multimedia/tarea_multimedia_view.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_url_launcher.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_utils.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/dropdown_formfield_2.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/image_picker/image_picker_handler.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/progress_bar.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_unidad_tarea_repositoy.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/forma_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_drive_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_youtube_tools.dart';

class TareaCrearView extends View{
  CursosUi? cursosUi;
  TareaUi? tareaUi;
  UsuarioUi? usuarioUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;
  UnidadUi? unidadUi;
  SesionUi? sesionUi;

  TareaCrearView(this.usuarioUi,this.cursosUi, this.calendarioPeriodoUI, this.tareaUi, this.unidadUi, this.sesionUi);

  @override
  TareaCrearViewState createState() => TareaCrearViewState(usuarioUi, cursosUi, calendarioPeriodoUI, tareaUi, unidadUi, sesionUi);

}
class TareaCrearViewState extends ViewState<TareaCrearView, TareaCrearController> with TickerProviderStateMixin, ImagePickerListener{

  late final ScrollController scrollController = ScrollController();
  late final ScrollController verticalscrollController = ScrollController();
  late final ScrollControllers crollControllers = ScrollControllers();
  late double topBarOpacity = 0.0;
  final format = DateFormat("dd/MM/yyyy");
  final formatHour = DateFormat("hh:mm a");
  late AnimationController _imagePickerAnimationcontroller;
  late ImagePickerHandler imagePicker;
  GlobalKey globalKey = GlobalKey();


  TareaCrearViewState(usuarioUi, cursosUi, calendarioPeriodoUI, tareaUi, unidadUi, sesionUi) :
        super(TareaCrearController(usuarioUi, cursosUi, calendarioPeriodoUI, tareaUi, unidadUi, sesionUi, DeviceHttpDatosRepositorio(), MoorConfiguracionRepository(), MoorUnidadTareaRepository()));
  var _tiuloTareacontroller = TextEditingController();
  var _Instrucionescontroller = TextEditingController();
  var _Horacontroller = TextEditingController();
  TextEditingController linktController = TextEditingController();

  int? selectedRow;
  int? selectedColumn;

  Color getContentColor(int i, int j) {
    if (i == selectedRow && j == selectedColumn) {
      return Colors.amber;
    } else if (i == selectedRow || j == selectedColumn) {
      return Colors.amberAccent;
    } else {
      return Colors.transparent;
    }
  }

  void clearState() => setState(() {
    selectedRow = null;
    selectedColumn = null;
  });

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
    _tiuloTareacontroller.text = widget.tareaUi?.titulo??"";
    _Instrucionescontroller.text = widget.tareaUi?.instrucciones??"";
    _Horacontroller.text = widget.tareaUi?.horaTarea??"";

    _imagePickerAnimationcontroller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker=new ImagePickerHandler(this,_imagePickerAnimationcontroller, false);
    imagePicker.init(documento: true);
  }


  @override
  Widget get view => ControlledWidgetBuilder<TareaCrearController>(
      builder: (context, controller) {

        if(controller.mensaje!=null&&controller.mensaje!.isNotEmpty){
          Fluttertoast.showToast(
            msg: controller.mensaje!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
          controller.successMsg();
        }

        return WillPopScope(
          onWillPop: () async {

            bool? respuesta = await _showMaterialDialog(controller);
            return respuesta??false;
          },
          child:  Container(
            key: globalKey,
            color: AppTheme.background,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: <Widget>[
                  getMainTab(),
                  getAppBarUI(),
                  controller.progress?
                  ArsProgressWidget(
                      blur: 2,
                      backgroundColor: Color(0x33000000),
                      animationDuration: Duration(milliseconds: 500)):
                  Container(),
                ],
              ),
            ),
          ),
        );
      });

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
          child: ControlledWidgetBuilder<TareaCrearController>(
            builder: (context, controller) {
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 8,
                        right: 24,
                        top: 16 - 8.0 * topBarOpacity,
                        bottom: 12 - 8.0 * topBarOpacity),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                          onPressed: () async {
                            bool? respuesta = await _showMaterialDialog(controller);
                            if(respuesta??false){
                              Navigator.of(context).pop(true);
                            }
                          },
                        ),
                        Expanded(
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //SvgPicture.asset(AppIcon.ic_curso_tarea, height: 32 +  6 - 10 * topBarOpacity , width: 35 +  6 - 10 * topBarOpacity ,),
                              Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Tarea',
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontTTNormsMedium,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16 + 6 - 6 * topBarOpacity,
                                        letterSpacing: 1.2,
                                        color: AppTheme.darkerText,
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),Row(
                          children: [
                            Material(
                              color: HexColor(controller.cursosUi?.color1).withOpacity(0.1),
                              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                              child: InkWell(
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                splashColor: AppTheme.colorPrimary.withOpacity(0.4),
                                onTap: () async {
                                  bool succes = await controller.onClickPublicarTarea();
                                  if(succes)Navigator.of(context).pop(1);
                                },
                                child:
                                Container(
                                    padding: const EdgeInsets.only(top: 10, left: 8, bottom: 8, right: 8),
                                    child: Row(
                                      children: [
                                        Text("PUBLICAR",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: HexColor(controller.cursosUi?.color1),
                                            fontWeight: FontWeight.w600,
                                            fontFamily: AppTheme.fontName,
                                          ),),
                                      ],
                                    )
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(6)),
                            Material(
                              color: HexColor(controller.cursosUi?.color1),
                              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                              child: InkWell(
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                splashColor: AppTheme.colorPrimary.withOpacity(0.4),
                                onTap: () async {
                                  print("guardar");
                                  bool succes = await controller.onClickGuardarTarea();
                                  if(succes)Navigator.of(context).pop(1);
                                },
                                child:
                                Container(
                                    padding: const EdgeInsets.only(top: 10, left: 8, bottom: 8, right: 8),
                                    child: Row(
                                      children: [
                                        Text("GUARDAR",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.white,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: AppTheme.fontName,
                                          ),),
                                      ],
                                    )
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        )
      ],
    );
  }


  int countView = 4;
  @override
  Widget getMainTab(){

    return ControlledWidgetBuilder<TareaCrearController>(
        builder: (context, controller) {

          return Container(
              padding: EdgeInsets.only(
                top: AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top +
                    0,
              ),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: CustomScrollView(
                    controller: scrollController,
                    slivers: <Widget>[
                      SliverList(
                          delegate: SliverChildListDelegate([
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                              child:  TextFormField(
                                autofocus: false,
                                controller: _tiuloTareacontroller,
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                maxLines: null,
                                decoration: InputDecoration(
                                  labelText: "Título *",
                                  labelStyle: TextStyle(
                                      color:  HexColor(controller.cursosUi?.color1),
                                      fontFamily: AppTheme.fontTTNormsMedium,
                                      fontSize: 18
                                  ),
                                  helperText: " ",
                                  contentPadding: EdgeInsets.all(15.0),
                                  suffixIcon:(controller.tituloTarea?.isNotEmpty??false) ?
                                  IconButton(
                                    onPressed: (){
                                      controller.clearTitulo();
                                      _tiuloTareacontroller.clear();
                                    },
                                    icon: Icon(
                                      Ionicons.close_circle,
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ):null,
                                  errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ),
                                  hintText: "Ingrese un título",
                                  hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppTheme.greyLighten1,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color2),
                                    ),
                                  ),
                                  focusColor: AppTheme.colorAccent,
                                ),
                                onChanged: (str) {
                                  controller.changeTituloTarea(str);
                                },
                                onSaved: (str) {
                                  //  To do
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                              child:  TextFormField(
                                autofocus: false,
                                controller: _Instrucionescontroller,
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                maxLines: null,
                                decoration: InputDecoration(
                                  labelText: "Instrucciones (Opcional)",
                                  labelStyle: TextStyle(
                                      color:  HexColor(controller.cursosUi?.color1),
                                      fontFamily: AppTheme.fontTTNormsMedium,
                                      fontSize: 18
                                  ),
                                  helperText: " ",
                                  contentPadding: EdgeInsets.all(15.0),
                                  suffixIcon:(controller.instruccionesTarea?.isNotEmpty??false) ?
                                  IconButton(
                                    onPressed: (){
                                      controller.clearInstruciones();
                                      _Instrucionescontroller.clear();
                                    },
                                    icon: Icon(
                                      Ionicons.close_circle,
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ):null,
                                  errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ),
                                  hintText: "",
                                  hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppTheme.colorPrimary.withOpacity(0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color2),
                                    ),
                                  ),
                                  focusColor: AppTheme.colorAccent,
                                ),
                                onChanged: (str) {
                                  controller.changeInstrucciones(str);
                                },
                                onSaved: (str) {
                                  //  To do
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                              child: DateTimeField(
                                initialValue: controller.fechaTarea,
                                format: format,
                                autofocus: false,
                                textAlign: TextAlign.start,
                                resetIcon: Icon(
                                  Ionicons.close_circle,
                                  color: HexColor(controller.cursosUi?.color1),
                                ),
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Fecha de entrega",
                                  labelStyle: TextStyle(
                                      color: HexColor(controller.cursosUi?.color1),
                                      fontFamily: AppTheme.fontTTNormsMedium,
                                      fontSize: 18
                                  ),
                                  helperText: " ",
                                  contentPadding: EdgeInsets.all(15.0),
                                  prefixIcon: Icon(
                                    Icons.web_asset_rounded,
                                    color: HexColor(controller.cursosUi?.color1),
                                  ),
                                  errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ),
                                  hintText: "",
                                  hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppTheme.colorPrimary.withOpacity(0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color2),
                                    ),
                                  ),
                                  focusColor: AppTheme.colorAccent,
                                ),
                                onChanged: (DateTime? value){
                                  controller.changeFecha(value);
                                },
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate: currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                              child: DateTimeField(
                                initialValue: (controller.horaTarea??"").isNotEmpty?DateTimeField.convert(AppUtils.horaTimeOfDay(controller.horaTarea)):null,
                                format: formatHour,
                                autofocus: false,
                                textAlign: TextAlign.start,
                                resetIcon: Icon(
                                  Ionicons.close_circle,
                                  color: HexColor(controller.cursosUi?.color1),
                                ),
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Hora de entrega",
                                  labelStyle: TextStyle(
                                      color: HexColor(controller.cursosUi?.color1),
                                      fontFamily: AppTheme.fontTTNormsMedium,
                                      fontSize: 18
                                  ),
                                  helperText: " ",
                                  contentPadding: EdgeInsets.all(15.0),
                                  prefixIcon: Icon(
                                    Icons.alarm,
                                    color: HexColor(controller.cursosUi?.color1),
                                  ),
                                  errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color1),
                                    ),
                                  ),
                                  hintText: "",
                                  hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppTheme.colorPrimary.withOpacity(0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: HexColor(controller.cursosUi?.color2),
                                    ),
                                  ),
                                  focusColor: AppTheme.colorAccent,
                                ),
                                onChanged: (DateTime? value){
                                  if(value!=null){
                                    controller.changeHora(DomainTools.dataTimeHourMinute(value));
                                  }else{
                                    controller.changeHora(null);
                                  }
                                },
                                onShowPicker: (context, currentValue) async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                  );
                                  return DateTimeField.convert(time);
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                              child: Text("Recursos",
                                style: TextStyle(fontSize: 16, color: AppTheme.black, fontWeight: FontWeight.w500),),
                            ),

                            Container(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 16,),
                              child: Stack(
                                children: [
                                  Center(
                                    child: InkWell(
                                      onTap: () async{
                                        imagePicker.showDialog(context, botonLink: () async{
                                          linktController.text = "";
                                          await _showDialogEnlace(controller);
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: HexColor(controller.cursosUi?.color2).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8), // use instead of BorderRadius.all(Radius.circular(20))
                                        ),
                                        width: 450,
                                        height: 60,
                                        child: FDottedLine(
                                          color: HexColor(controller.cursosUi?.color1).withOpacity(0.6),
                                          strokeWidth: 2.0,
                                          dottedLength: 10.0,
                                          space: 2.0,
                                          corner: FDottedLineCorner.all(14.0),

                                          /// add widget
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text("Agregar recurso",  style: TextStyle(
                                                fontSize: 16,
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
                                padding: EdgeInsets.only(left: 24, right: 24, top: 16.0, bottom: 0),
                                itemCount: controller.tareaRecursoList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index){
                                  TareaRecusoUi tareaRecursoUi = controller.tareaRecursoList[index];

                                  return Stack(
                                    children: [
                                      Center(
                                        child: InkWell(
                                          onTap: () async {
                                            switch(tareaRecursoUi.tipoRecurso){
                                              case TipoRecursosUi.TIPO_DOCUMENTO:
                                              case TipoRecursosUi.TIPO_IMAGEN:
                                              case TipoRecursosUi.TIPO_AUDIO:
                                              case TipoRecursosUi.TIPO_HOJA_CALCULO:
                                              case TipoRecursosUi.TIPO_DIAPOSITIVA:
                                              case TipoRecursosUi.TIPO_PDF:
                                                await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(tareaRecursoUi.driveId), webview: false);
                                                break;
                                              case TipoRecursosUi.TIPO_VINCULO:
                                                await AppUrlLauncher.openLink(tareaRecursoUi.url??tareaRecursoUi.descripcion, webview: false);
                                                break;
                                              case TipoRecursosUi.TIPO_ENCUESTA:
                                                await AppUrlLauncher.openLink(tareaRecursoUi.url??tareaRecursoUi.descripcion, webview: false);
                                                break;
                                              case TipoRecursosUi.TIPO_VINCULO_DRIVE:
                                              //await AppUrlLauncher.openLink(tareaRecursoUi.url, webview: false);
                                                await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(tareaRecursoUi.driveId), webview: false);
                                                break;
                                              case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
                                                print("youtube: ${tareaRecursoUi.url}");
                                                TareaMultimediaView.showDialog(context, YouTubeUrlParser.getYoutubeVideoId(tareaRecursoUi.url), TareaMultimediaTipoArchivo.YOUTUBE);
                                                break;
                                              case TipoRecursosUi.TIPO_RECURSO:
                                              //await AppUrlLauncher.openLink(tareaRecursoUi.url, webview: false);

                                                break;
                                              default:
                                                await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(tareaRecursoUi.driveId), webview: false);
                                                break;
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8), // use instead of BorderRadius.all(Radius.circular(20))
                                                border:  Border.all(
                                                    width: 1,
                                                    color: HexColor(controller.cursosUi?.color1)
                                                ),
                                                color: tareaRecursoUi.success == false? AppTheme.red.withOpacity(0.1):AppTheme.white
                                            ),
                                            margin: EdgeInsets.only(bottom: 8),
                                            width: 450,
                                            height: 50,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(right: 16),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                            bottomLeft: Radius.circular(8),
                                                            topLeft: Radius.circular(8),
                                                          ), // use instead of BorderRadius.all(Radius.circular(20))
                                                          color: AppTheme.greyLighten2,
                                                        ),
                                                        width: 50,
                                                        child: Center(
                                                          child: Image.asset(getImagen(tareaRecursoUi.tipoRecurso),
                                                            height: 30.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            tareaRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO_YOUTUBE || tareaRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO_DRIVE || tareaRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO?
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Padding(padding: EdgeInsets.all(4)),
                                                                Text("${(tareaRecursoUi.url??"").isNotEmpty?tareaRecursoUi.url?.trim(): tareaRecursoUi.descripcion?.trim()}", maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(color: AppTheme.blue, fontSize: 12)),
                                                                Padding(padding: EdgeInsets.all(4)),
                                                              ],
                                                            ):Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text("${tareaRecursoUi.titulo??""}", style: TextStyle(color: AppTheme.greyDarken3, fontSize: 12),),
                                                                Padding(padding: EdgeInsets.all(2)),
                                                                Text("${(tareaRecursoUi.descripcion??"").isNotEmpty?tareaRecursoUi.descripcion: getDescripcion(tareaRecursoUi.tipoRecurso)}", maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(color: AppTheme.grey, fontSize: 10)),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      tareaRecursoUi.success == false?
                                                      InkWell(
                                                        onTap: (){
                                                          controller.refreshTareaRecursoUi(tareaRecursoUi);
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(right: 16),
                                                          child: Icon(Icons.refresh),
                                                        ),
                                                      ):Container(),
                                                      InkWell(
                                                        onTap: (){
                                                          controller.removeTareaRecurso(tareaRecursoUi);
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(right: 16),
                                                          child: Icon(Icons.close),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                !(tareaRecursoUi.success != null)&&(tareaRecursoUi.progress??0)>0?
                                                Column(
                                                  children: [
                                                    Expanded(child: Container()),
                                                    ProgressBar(
                                                      current: tareaRecursoUi.progress??0,
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
                            Container(
                              padding: EdgeInsets.only(bottom: 100),
                            )
                          ])
                      ),
                    ]
                ),
              )
          );
        });
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

  selectDate(BuildContext context,TareaCrearController controller) async {
    DateTime? selectedDate = controller.fechaTarea;
    if(selectedDate==null) selectedDate = DateTime.now();

     DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),

    );
    if (selected != null && selected != selectedDate)
      controller.changeFecha(selected);
  }

  @override
  void dispose() {
    super.dispose();
    _imagePickerAnimationcontroller.dispose();
    linktController.dispose();
    _tiuloTareacontroller.dispose();
    _Instrucionescontroller.dispose();
   _Horacontroller.dispose();
  }

  Future<bool?> _showMaterialDialog(TareaCrearController controller) async {
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
                                  Text("Salir sin guardar", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppTheme.fontTTNormsMedium
                                  ),),
                                  Padding(padding: EdgeInsets.all(8),),
                                  Text("¿Esta seguro que quiere salir?",
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
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Cancelar', style: TextStyle(color: HexColor(controller.cursosUi?.color1), fontSize: 13),),
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
                              Navigator.of(context).pop(true);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: HexColor(controller.cursosUi?.color1),
                              onPrimary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Salir sin guardar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13
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

  Future<bool?> _showDialogEnlace(TareaCrearController controller) async {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.all(8),),
                      TextFormField(
                        autofocus: true,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        autovalidateMode: AutovalidateMode.disabled,
                        validator: (val) => '' ,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.caption?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: AppTheme.fontTTNorms,
                          color: Colors.black,
                        ),
                        controller: linktController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: "Agregar enlace",
                          labelStyle: TextStyle(
                            color:  HexColor(controller.cursosUi?.color1),
                            fontFamily: AppTheme.fontTTNorms,
                            fontWeight: FontWeight.w600,
                          ),
                          contentPadding: EdgeInsets.all(15.0),
                          prefixIcon: Icon(
                            Icons.link,
                            color: HexColor(controller.cursosUi?.color1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: HexColor(controller.cursosUi?.color1),
                            ),
                          ),
                          hintText: "",
                          hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTheme.fontTTNorms,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: HexColor(controller.cursosUi?.color1),
                            ),
                          ),
                          focusColor: AppTheme.colorAccent,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(child: ElevatedButton(
                            onPressed: () {
                              FlutterClipboard.paste().then((value) {
                                linktController.text = value;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: HexColor(controller.cursosUi?.color1),
                              onPrimary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Ionicons.clipboard_outline,
                                  size: 16,
                                ),
                                Padding(padding: EdgeInsets.all(2),),
                                Text('PEGAR',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w700
                                  ),
                                )
                              ],
                            ),
                          )),
                        ],
                      ),
                      Padding(padding: EdgeInsets.all(8),),
                      Row(
                        children: [
                          Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Cancelar',
                                  style: TextStyle(
                                      color: HexColor(controller.cursosUi?.color1),
                                      fontSize: 13,
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
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
                              Navigator.of(context).pop(true);
                              controller.addLink(linktController.text);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: HexColor(controller.cursosUi?.color1),
                              onPrimary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Guardar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13,
                                fontFamily: AppTheme.fontTTNorms,
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

  @override
  userImage(File? _image, String? newName) {
    if(globalKey.currentContext!=null&&(_image?.path??"").isNotEmpty){
      TareaCrearController controller =
      FlutterCleanArchitecture.getController<TareaCrearController>(globalKey.currentContext!, listen: false);
      List<File?> files = [];
      files.add(_image);
      controller.addTareaRecursos(files,newName);
      print("image ${_image?.path}");
    }

  }

  @override
  userDocument(List<File?> _documents) {
    if(globalKey.currentContext!=null){
      print("document ${_documents.length}");
      TareaCrearController controller =
      FlutterCleanArchitecture.getController<TareaCrearController>(globalKey.currentContext!, listen: false);
      controller.addTareaRecursos(_documents, null);

    }
  }

}
