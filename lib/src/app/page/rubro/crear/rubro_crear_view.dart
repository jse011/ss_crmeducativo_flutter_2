import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_not_expanded_custom.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_not_scrolling.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/crear/rubro_crear_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/dropdown_formfield_2.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/criterio_valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/forma_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';

class RubroCrearView extends View{
  final CursosUi cursosUi;
  final RubricaEvaluacionUi? rubroUi;
  final CalendarioPeriodoUI? calendarioPeriodoUI;
  final SesionUi? sesionUi;
  final TareaUi? tareaUi;
  final bool online;

  RubroCrearView(this.cursosUi, this.calendarioPeriodoUI, this.rubroUi, this.sesionUi, this.tareaUi,this.online);

  @override
  RubroCrearViewState createState() => RubroCrearViewState(cursosUi, calendarioPeriodoUI, rubroUi, sesionUi, tareaUi,online);

}
class RubroCrearViewState extends ViewState<RubroCrearView, RubroCrearController> with TickerProviderStateMixin{

  late final ScrollController scrollController = ScrollController();
  late final ScrollController verticalscrollController = ScrollController();
  late final ScrollControllers crollControllers = ScrollControllers();
  late double topBarOpacity = 0.0;

  RubroCrearController? controller;

  RubroCrearViewState(cursosUi, calendarioPeriodoUI, rubroUi, SesionUi? sesionUi, TareaUi? tareaUi, bool online) : super(RubroCrearController(cursosUi, calendarioPeriodoUI, rubroUi, sesionUi, tareaUi, online,MoorRubroRepository(), MoorConfiguracionRepository(), DeviceHttpDatosRepositorio()));
  var _tiuloRubricacontroller = TextEditingController();
  var _tiuloCriteriocontroller = TextEditingController();

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

    if(widget.rubroUi!=null){
      _tiuloRubricacontroller.text = widget.rubroUi?.titulo??"";
    }else if((widget.tareaUi?.titulo??"").isNotEmpty){
      _tiuloRubricacontroller.text = widget.tareaUi?.titulo??"";
    }


  }

  @override
  Widget get view =>  ControlledWidgetBuilder<RubroCrearController>(
      builder: (context, controller) {
        if(controller.cerraryactualizar){
          if (mounted) {
           WidgetsBinding.instance?.addPostFrameCallback((_){
             Navigator.of(context).pop(controller.newRubroEvalid);
             controller.clearCerraryactualizar();
           });
          }
        }

        return WillPopScope(
          onWillPop: () async {
            bool? respuesta = await _showMaterialDialog(controller);
            return respuesta??false;
          },
          child:  Container(
            color: AppTheme.white,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: <Widget>[
                  getMainTab(),
                  getAppBarUI(),
                if(controller.showGuardarProgress)
                  ArsProgressWidget(
                      blur: 2,
                      backgroundColor: Color(0x33000000),
                      animationDuration: Duration(milliseconds: 500),
                      loadingWidget:  Container(
                        child: FutureBuilder<bool>(
                            future: progressDelay(),
                            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                              if (!snapshot.hasData) {
                                return Container(
                                  padding: EdgeInsets.all(10.0),
                                  height: 100.0,
                                  width: 100.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                );
                              } else {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: Container()),
                                        Padding(
                                          padding: EdgeInsets.only(right: 16, top: 16),
                                          child: InkWell(
                                            onTap: (){
                                              controller.cerrarProgress();
                                            },
                                            child:  Container(
                                              width: 45,
                                              height: 45,
                                              child:  Icon(Ionicons.close, size: 35, color: AppTheme.white,),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppTheme.black.withOpacity(0.5)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Expanded(
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: !controller.modoOnline?
                                              Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(16), // if you need this
                                                  side: BorderSide(
                                                    color: Colors.grey.withOpacity(0.2),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
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
                                                            child:  Padding(padding: EdgeInsets.all(10), child: Center(
                                                              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.white,),
                                                            ),),
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: getColorCurso(controller)),
                                                          ),
                                                          Padding(padding: EdgeInsets.all(8)),
                                                          Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Padding(padding: EdgeInsets.all(4),),
                                                                  Text(
                                                                    "El guardar está demorando más de lo previsto", style: TextStyle(
                                                                      fontSize: 18,
                                                                      fontWeight: FontWeight.w700,
                                                                      fontFamily: AppTheme.fontTTNormsMedium
                                                                  ),),
                                                                  Padding(padding: EdgeInsets.all(4),),
                                                                  Text("Guarde una copia en su dispositivo y siga trabajando ó espere hasta que se complete el guardar.",
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        height: 1.5
                                                                    ),),
                                                                  Padding(padding: EdgeInsets.all(8),),

                                                                ],
                                                              )
                                                          )
                                                        ],
                                                      ),
                                                      Padding(padding: EdgeInsets.only(bottom: 24)),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: OutlinedButton(
                                                                onPressed: () {
                                                                  controller.cerrarProgress();
                                                                },
                                                                child: Text('Atras',  style: TextStyle(fontSize: 14)),
                                                                style: OutlinedButton.styleFrom(
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(8),
                                                                  ),
                                                                  primary: AppTheme.darkText,
                                                                ),
                                                              )
                                                          ),
                                                          Padding(padding: EdgeInsets.all(8)),
                                                          Expanded(child: ElevatedButton(
                                                            onPressed: () {
                                                              controller.onClickGuardarVerMasTarde();
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              primary: HexColor("#e5faf3"),
                                                              onPrimary: Colors.white,
                                                              elevation: 0,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(8.0),
                                                              ),
                                                            ),
                                                            child: Padding(padding: EdgeInsets.all(8), child: Text('Guardar una copia en mi dispositivo', style: TextStyle(color:  HexColor("#00c985"), fontWeight: FontWeight.w700, fontSize: 14),),),
                                                          )),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ):Container(
                                                padding: EdgeInsets.all(10.0),
                                                height: 100.0,
                                                width: 100.0,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  color: Colors.white,
                                                ),
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                    ),
                                    Padding(padding: EdgeInsets.only(bottom: 60))
                                  ],
                                );
                              }

                            }),
                      ),
                  ),
                if(controller.dialogReintentar)
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
                          padding: EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
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
                                    child: Icon(Ionicons.cellular_outline, size: 28, color: AppTheme.white,),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: getColorCurso(controller)),
                                  ),
                                  Padding(padding: EdgeInsets.all(8)),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(padding: EdgeInsets.all(4),),
                                          Text(
                                            "Su conexión a internet está lenta${controller.errorServidor??false?" o nuestros servidores no responden":""}", style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: AppTheme.fontTTNormsMedium
                                          ),),
                                          Padding(padding: EdgeInsets.all(4),),
                                          Text("No pudimos guardar la evaluación${(controller.tareaUi?.titulo??"").isNotEmpty?" de su tarea":""}. Inténtalo de nuevo.",
                                            style: TextStyle(
                                                fontSize: 14,
                                                height: 1.5
                                            ),),
                                          Padding(padding: EdgeInsets.all(8),),
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
                                          controller.onClickAtrasReintentar();
                                        },
                                        child: Text('Atras',  style: TextStyle(fontSize: 14)),
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          primary: AppTheme.darkText,
                                        ),
                                      )
                                  ),
                                  Padding(padding: EdgeInsets.all(8)),
                                  Expanded(child: ElevatedButton(
                                    onPressed: () {
                                      controller.onClickReintentar();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: HexColor("#e5faf3"),
                                      onPrimary: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Padding(padding: EdgeInsets.all(8), child: Text('Inténtalo de nuevo', style: TextStyle(color:  HexColor("#00c985"), fontWeight: FontWeight.w700, fontSize: 14),),),
                                  )),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                  ),
                if(controller.dialogGuardarLocal)
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
                            padding: EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
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
                                      child: Icon(Ionicons.save, size: 28, color: AppTheme.white,),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: getColorCurso(controller)),
                                    ),
                                    Padding(padding: EdgeInsets.all(8)),
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(padding: EdgeInsets.all(4),),
                                            Text(
                                              "Su conexión a internet está lenta${controller.errorServidor??false?" o nuestros servidores no responden":""}", style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: AppTheme.fontTTNormsMedium
                                            ),),
                                            Padding(padding: EdgeInsets.all(4),),
                                            Text("No pudimos guardar su nueva evaluación. Guarde una copia en su dispositivo y siga trabajando.",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  height: 1.5
                                              ),),
                                            Padding(padding: EdgeInsets.all(8),),
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
                                            controller.onClickAtrasGuardarLocal();
                                          },
                                          child: Text('Atras',  style: TextStyle(fontSize: 14)),
                                          style: OutlinedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            primary: AppTheme.darkText,
                                          ),
                                        )
                                    ),
                                    Padding(padding: EdgeInsets.all(8)),
                                    Expanded(child: ElevatedButton(
                                      onPressed: () {
                                        controller.onClickGuardarVerMasTarde();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: HexColor("#e5faf3"),
                                        onPrimary: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: Padding(padding: EdgeInsets.all(8), child: Text('Guardar una copia en mi dispositivo', style: TextStyle(color:  HexColor("#00c985"), fontWeight: FontWeight.w700, fontSize: 14),),),
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
      });


  Future<bool> progressDelay() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 10000));
    return true;
  }


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
          child: ControlledWidgetBuilder<RubroCrearController>(
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
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              controller.rubricaEvaluacionUi==null?'Evaluación':'Editar Evaluación',
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
                          ),
                        ),
                        Material(
                          color: getColorCurso(controller),
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          child: InkWell(
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                            splashColor: AppTheme.grey.withOpacity(0.4),
                            onTap: ()  {
                              print("guardar");
                              controller.onSave();
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

    return ControlledWidgetBuilder<RubroCrearController>(
        builder: (context, controller) {
          return Container(
              padding: EdgeInsets.only(
                top: AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top +
                    0,
              ),
              child:  Form(
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
                                controller: _tiuloRubricacontroller,
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                  fontFamily: AppTheme.fontName,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Título de la rúbrica *",
                                  labelStyle: TextStyle(
                                      color:  getColorCurso(controller),
                                      fontFamily: AppTheme.fontTTNormsMedium
                                  ),
                                  helperText: " ",
                                  contentPadding: EdgeInsets.all(15.0),
                                  prefixIcon: Icon(
                                    Ionicons.apps_outline,
                                    color: getColorCurso(controller),
                                  ),

                                  suffixIcon:(controller.tituloRubrica?.isNotEmpty??false) ?
                                  IconButton(
                                    onPressed: (){
                                      controller.clearTitulo();
                                      _tiuloRubricacontroller.clear();
                                    },
                                    icon: Icon(
                                      Ionicons.close_circle,
                                      color: getColorCurso(controller),
                                    ),
                                  ):null,
                                  errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: getColorCurso(controller),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: getColorCurso(controller).withOpacity(0.5),
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: getColorCurso(controller)
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: getColorCurso(controller),
                                    ),
                                  ),
                                  hintText: "Ingrese un título",
                                  hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppTheme.fontTTNormsMedium,
                                    fontSize: 14,
                                    color: getColorCurso(controller).withOpacity(0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: getColorCurso(controller),
                                    ),
                                  ),
                                  focusColor: AppTheme.colorAccent,
                                ),
                                onChanged: (str) {
                                  controller.changeTituloRubrica(str);
                                },
                                onSaved: (str) {
                                  //  To do
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                              child: DropDownFormField2<FormaEvaluacionUi>(
                                inputDecoration: InputDecoration(
                                  labelText: "Forma de evaluación",
                                  labelStyle: TextStyle(
                                    color:  getColorCurso(controller),
                                    fontFamily: AppTheme.fontTTNormsMedium,
                                    fontSize: 14,
                                  ),
                                  helperText: " ",
                                  contentPadding: EdgeInsets.all(15.0),
                                  prefixIcon: Icon(
                                    Icons.people_alt_outlined,
                                    color: getColorCurso(controller),
                                  ),
                                  suffixIcon:  IconButton(
                                    onPressed: (){
                                      controller.clearTitulo();
                                      _tiuloRubricacontroller.clear();
                                    },
                                    icon: Icon(
                                      Ionicons.caret_down,
                                      color: controller.rubricaEvaluacionUi == null?
                                      getColorCurso(controller).withOpacity(0.5):
                                      AppTheme.background,
                                    ),
                                    iconSize: 15,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: getColorCurso(controller).withOpacity(0.5)
                                    ),
                                  ),
                                  hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppTheme.fontTTNormsMedium,
                                    fontSize: 14,
                                    color: getColorCurso(controller).withOpacity(0.5),
                                  ),
                                ),
                                onChanged: controller.rubricaEvaluacionUi==null?(item){
                                  controller.onSelectFormaEvaluacion(item);
                                }:null,
                                menuItems: controller.formaEvaluacionUiList.map<DropdownMenuItem<FormaEvaluacionUi>>((item) {
                                  return DropdownMenuItem<FormaEvaluacionUi>(child:
                                  Padding(
                                    padding: EdgeInsets.only(left: 32),
                                    child: Text(item.nombre??"", style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 15,
                                      color: Colors.black,),),
                                  )
                                    , value: item,);
                                }).toList(),
                                value: controller.formaEvaluacionUi,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                              child: DropDownFormField2<TipoEvaluacionUi>(
                                inputDecoration: InputDecoration(
                                  labelText: "Tipo de evaluación",
                                  labelStyle: TextStyle(
                                    color:  getColorCurso(controller),
                                    fontFamily: AppTheme.fontTTNormsMedium,
                                    fontSize: 14,
                                  ),
                                  helperText: " ",
                                  contentPadding: EdgeInsets.all(15.0),
                                  prefixIcon: Icon(
                                    Ionicons.apps_outline,
                                    color: getColorCurso(controller),
                                  ),

                                  suffixIcon:  IconButton(
                                    onPressed: (){
                                      controller.clearTitulo();
                                      _tiuloRubricacontroller.clear();
                                    },
                                    icon: Icon(
                                      Ionicons.caret_down,
                                      color: getColorCurso(controller).withOpacity(0.5)
                                    ),
                                    iconSize: 15,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: getColorCurso(controller).withOpacity(0.5),
                                    ),
                                  ),
                                  hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppTheme.fontTTNormsMedium,
                                    fontSize: 14,
                                    color: getColorCurso(controller).withOpacity(0.5),
                                  ),
                                ),
                                onChanged:(item){
                                  controller.onSelectTipoEvaluacion(item);
                                },
                                menuItems: controller.tipoEvaluacionUiList.map<DropdownMenuItem<TipoEvaluacionUi>>((item) {
                                  return DropdownMenuItem<TipoEvaluacionUi>(child:
                                  Padding(
                                    padding: EdgeInsets.only(left: 32),
                                    child: Text(item.nombre??"", style: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),),
                                  )
                                    , value: item,);
                                }).toList(),
                                value: controller.tipoEvaluacionUi,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(child: Container(),),
                                Padding(
                                  padding: EdgeInsets.only(left: 8, top: 4,right: 24),
                                  child: Icon(
                                    Ionicons.help_circle_outline,
                                    color: getColorCurso(controller),
                                  ),
                                )

                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 4),
                              child:  InkWell(
                                onTap: controller.rubricaEvaluacionUi==null?(){
                                  showDialogTipos(controller);
                                }:null,
                                child: InputDecorator(
                                  textAlign: TextAlign.start,
                                  decoration:  InputDecoration(
                                    labelText: "Promedio de logro",
                                    labelStyle: TextStyle(
                                      color:  getColorCurso(controller),
                                      fontFamily: AppTheme.fontTTNormsMedium,
                                      fontSize: 14,
                                    ),
                                    helperText: "Opcional, puede dar clic en la interrogación para conocer más del promedio de logro seleccionado.",
                                    helperMaxLines: 3,
                                    helperStyle: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontSize: 10,
                                    ),
                                    contentPadding: EdgeInsets.all(15.0),
                                    prefixIcon: Container(padding: EdgeInsets.all(12), height: 15, width:15, child: SvgPicture.asset(AppIcon.ic_evaluar, color: getColorCurso(controller)),),
                                    suffixIcon:  IconButton(
                                      onPressed: (){
                                        controller.clearTitulo();
                                        _tiuloRubricacontroller.clear();
                                      },
                                      icon: Icon(
                                        Ionicons.ellipsis_vertical,
                                        color: controller.rubricaEvaluacionUi == null?
                                        getColorCurso(controller).withOpacity(0.5):
                                        AppTheme.background,
                                      ),
                                      iconSize: 15,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: getColorCurso(controller).withOpacity(0.5),
                                      ),
                                    ),
                                    hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppTheme.fontTTNormsMedium,
                                      fontSize: 14,
                                      color: getColorCurso(controller).withOpacity(0.5),
                                    ),
                                  ),
                                  child: Text(controller.tipoNotaUi?.nombre??"", style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),),
                                ),
                              ),
                            ),
                            controller.rubricaEvaluacionUi==null?
                                Row(
                              children: [
                                Padding(padding: EdgeInsets.only(left: 24, top: 16),
                                  child:  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary: getColorCurso(controller), // background
                                      onPrimary: Colors.white, // foreground
                                    ),
                                    onPressed: () {
                                      showCamposAccion(controller);
                                    },
                                    icon: SvgPicture.asset(AppIcon.ic_velocimetro, color: AppTheme.white, width: 18, height: 18,),
                                    label: Text("AGREGAR CRITERIO"),
                                  ),
                                )
                              ],
                            ):
                                Container(),

                          ])
                      ),
                      SliverToBoxAdapter(
                        child: showTableTipoNota(controller),
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate([
                            Container(
                              height: 100,
                            )
                          ])
                      ),
                    ]
                ),
              )
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }


  void showDialogTipos(RubroCrearController controller) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height * 1,
            child: Container(
              padding: EdgeInsets.all(0),
              decoration: new BoxDecoration(
                color: AppTheme.background,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0),
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 16, top: 16, bottom: 0),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                          child:  IconButton(
                            icon: Icon(Icons.arrow_back_sharp),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8, left: 16, right: 0),
                          child: Text("Lista de niveles de logro", style: TextStyle(
                            fontFamily: AppTheme.fontTTNorms,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 60),
                    padding: EdgeInsets.only(left: 0, right: 0, top: 16, bottom: 0),
                    color: AppTheme.background,
                    child: CupertinoScrollbar(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const PageScrollPhysics(), //
                        controller: scrollController,
                        itemCount: controller.tipoNotaUiList.length,
                        itemBuilder: (context, index) {
                          TipoNotaUi tipoNotaUi = controller.tipoNotaUiList[index];

                          return InkWell(
                            onTap: (){
                              controller.onSelectedTipoNota(tipoNotaUi);
                              Navigator.pop(context);
                            },
                            child:  Container(
                              margin: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
                              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                              decoration: new BoxDecoration(
                                color: AppTheme.white,
                                borderRadius: new BorderRadius.all(Radius.circular(8.0)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tipoNotaUi.nombre??"",
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontTTNormsMedium,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),),
                                  Text("Escala: " +(tipoNotaUi.escalanombre??"") +" (" + (tipoNotaUi.escalavalorMinimo??0).toString() + " - " + (tipoNotaUi.escalavalorMaximo??0).toString() + ")"),
                                  Padding(padding: EdgeInsets.only(top: 8)),
                                  GridView.builder(
                                    shrinkWrap : true,
                                    physics: ClampingScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 4.0),
                                    itemBuilder: (_, index) {
                                      ValorTipoNotaUi valorTipoNotaUi = tipoNotaUi.valorTipoNotaList![index];

                                      switch(tipoNotaUi.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO){
                                        case TipoNotaTiposUi.SELECTOR_VALORES:
                                          return Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                        height: 3.5,
                                                        width: 3.5,
                                                        decoration: new BoxDecoration(
                                                          color: Colors.black,
                                                          shape: BoxShape.circle,
                                                        )
                                                    ),
                                                    Padding(padding: EdgeInsets.only(left: 8)),
                                                    Text(valorTipoNotaUi.titulo??"",
                                                        style: TextStyle(
                                                          fontFamily: AppTheme.fontTTNormsMedium,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.black,
                                                        )),
                                                    Padding(padding: EdgeInsets.only(left: 8)),
                                                    Expanded(child: Text(valorTipoNotaUi.alias??"",))
                                                  ],
                                                ),
                                                Padding(padding: EdgeInsets.only(left: 12),
                                                  child:  Text("Valor numérico: " + (valorTipoNotaUi.valorNumerico??0.0).toStringAsFixed(1),
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontName,
                                                        fontSize: 8,
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        case TipoNotaTiposUi.SELECTOR_ICONOS:
                                          return Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                        height: 3.5,
                                                        width: 3.5,
                                                        decoration: new BoxDecoration(
                                                          color: Colors.black,
                                                          shape: BoxShape.circle,
                                                        )
                                                    ),
                                                    Padding(padding: EdgeInsets.only(left: 8)),
                                                    Text(valorTipoNotaUi.titulo??"",
                                                        style: TextStyle(
                                                          fontFamily: AppTheme.fontTTNormsMedium,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.black,
                                                        )),
                                                    CachedNetworkImage(
                                                      height: 20,
                                                      width: 20,
                                                      imageUrl: valorTipoNotaUi.icono??"",
                                                      placeholder: (context, url) => CircularProgressIndicator(),
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                    ),
                                                    Padding(padding: EdgeInsets.only(left: 8)),
                                                    Expanded(child: Text(valorTipoNotaUi.alias??"",))
                                                  ],
                                                ),
                                                Padding(padding: EdgeInsets.only(left: 12),
                                                  child:  Text("Valor numérico: " + (valorTipoNotaUi.valorNumerico??0.0).toStringAsFixed(1),
                                                      style: TextStyle(
                                                        fontFamily: AppTheme.fontName,
                                                        fontSize: 8,
                                                      )
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        case TipoNotaTiposUi.VALOR_ASISTENCIA:
                                        case TipoNotaTiposUi.VALOR_NUMERICO:
                                        case TipoNotaTiposUi.SELECTOR_NUMERICO:
                                          return Container();
                                      }
                                    },
                                    itemCount: (tipoNotaUi.valorTipoNotaList??[]).length,
                                  ),
                                ],
                              ),
                            ),
                          );

                        },
                      )),
                    ),
                ],
              ),
            ),
          );
        });
  }

  Widget showTableTipoNota(RubroCrearController controller) {
    return controller.tipoNotaUi!=null?  FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return  Padding(
            padding: EdgeInsets.only(left: 0, right: 0, top: 16),
            child:  SingleChildScrollView(
              padding: EdgeInsets.only(left: 24, right: 0),
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  child: StickyHeadersTableNotExpandedNotScrolling(
                      cellDimensions: CellDimensions.variableColumnWidth(
                          stickyLegendHeight:35,
                          stickyLegendWidth: 135,
                          contentCellHeight: 60,
                          columnWidths: controller.tableTipoNotacolumnWidths
                      ),
                      //cellAlignments: CellAlignments.,
                      //scrollControllers: crollControllers,
                      columnsLength: controller.tableTipoNotaColumns.length,
                      rowsLength: controller.criterioUiList.length,

                      columnsTitleBuilder: (i) {
                        //#region columnsTitleBuilder
                        var obj = controller.tableTipoNotaColumns[i];
                        if(obj is String){
                          return Container(
                              padding: EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  Text(obj, style: TextStyle(color: getColorCurso(controller), fontSize: 12),),
                                ],
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: getColorCurso(controller)),
                                  top: BorderSide(color: getColorCurso(controller)),
                                  bottom: BorderSide(color: (controller.criterioUiList.isEmpty?getColorCurso(controller):AppTheme.white)),
                                ),
                              )
                          );
                        }else if(obj is bool){
                          return Stack(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: getColorCurso(controller),
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(7))
                                  )
                              ),
                              Container(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Center(
                                    child: Text("Peso", style: TextStyle(color: AppTheme.white, fontSize: 11),),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(color: getColorCurso(controller)),
                                      bottom: BorderSide(color: getColorCurso(controller)),
                                    ),
                                  )
                              ),
                            ],
                          );
                        }else if(obj is ValorTipoNotaUi){

                          switch(obj.tipoNotaUi?.tipoNotaTiposUi??MoorRubroRepository.TN_VALOR_NUMERICO){
                            case TipoNotaTiposUi.SELECTOR_VALORES:
                              return Container(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("${obj.titulo??""}".trim(),
                                          style: TextStyle(fontFamily: AppTheme.fontTTNormsMedium,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: getColor(i),
                                          ),
                                        ),
                                        Text((obj.valorNumerico??0).toStringAsFixed(1),
                                          style: TextStyle(fontFamily: AppTheme.fontTTNormsMedium,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: getColor(i)
                                          ),),
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(color: getColorCurso(controller)),
                                      top: BorderSide(color: getColorCurso(controller)),
                                      bottom: BorderSide(color: (controller.criterioUiList.isEmpty?getColorCurso(controller):AppTheme.white)),
                                    ),
                                  )
                              );
                            case TipoNotaTiposUi.SELECTOR_ICONOS:
                              return Container(
                                  child: Center(
                                    child:  CachedNetworkImage(
                                      height: 30,
                                      width: 30,
                                      imageUrl: obj.icono??"",
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(color: getColorCurso(controller)),
                                      top: BorderSide(color: getColorCurso(controller)),
                                      bottom: BorderSide(color: (controller.criterioUiList.isEmpty?getColorCurso(controller):AppTheme.white)),
                                    ),
                                  )
                              );
                            default:
                              return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(color: getColorCurso(controller)),
                                      top: BorderSide(color: getColorCurso(controller)),
                                      bottom: BorderSide(color: (controller.criterioUiList.isEmpty?getColorCurso(controller):AppTheme.white)),
                                    ),
                                  )
                              );

                          }
                        }else{
                          return Container();
                        }
                        //#endregion
                      },
                      rowsTitleBuilder: (i){
                        CriterioUi o = controller.criterioUiList[i];
                        return InkWell(
                            onTap: (){
                          showCriterioEdit(controller, o);
                          controller.showDialogEditCriterio(o);
                        },
                          child:  Container(
                              child:  Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8, right: 4),
                                        child: Text((o.icdTituloEditado??o.icdTituloEditado??o.icdTitulo??"") ,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 10)
                                        ),
                                      )
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4) ,
                                      color: getColorCurso(controller),// use instead of BorderRadius.all(Radius.circular(20))
                                    ),
                                    margin: EdgeInsets.only(left: 4, right: 4 , top: 4, bottom: 4),
                                    width: 12,
                                    child:  Center(
                                      child:  RotatedBox(
                                        quarterTurns: -1,
                                        child: Text("Modificar",
                                            textAlign: TextAlign.center,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: AppTheme.white,
                                                fontWeight: FontWeight.w500
                                            )
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: getColorCurso(controller)),
                                  right: BorderSide(color: getColorCurso(controller)),
                                  left: BorderSide(color: getColorCurso(controller)),
                                  bottom: BorderSide(color: (controller.criterioUiList.length -1 == i?getColorCurso(controller):AppTheme.white)),
                                ),
                              )
                          ),
                        );
                      },
                      contentCellBuilder: (i, j){
                        dynamic o = controller.tableTipoNotaCells[j][i];
                        if(o is CriterioUi){
                          return InkWell(
                            onTap: (){
                              showCriterioEdit(controller, o);
                              controller.showDialogEditCriterio(o);
                            },
                            child: Stack(
                              children: [
                                Container(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 8, right: 4),
                                              child: Text((o.icdTituloEditado??o.icdTituloEditado??o.icdTitulo??"") ,
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: 10)
                                              ),
                                            )
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4) ,
                                            color: getColorCurso(controller),// use instead of BorderRadius.all(Radius.circular(20))
                                          ),
                                          margin: EdgeInsets.only(left: 4, right: 4 , top: 4, bottom: 4),
                                          width: 12,
                                          child:  Center(
                                            child:  RotatedBox(
                                              quarterTurns: -1,
                                              child: Text("Modificar",
                                                  textAlign: TextAlign.center,
                                                  maxLines: 4,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 8,
                                                      color: AppTheme.white,
                                                      fontWeight: FontWeight.w500
                                                  )
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(color: getColorCurso(controller)),
                                        right: BorderSide(color: getColorCurso(controller)),
                                        bottom: BorderSide(color: (controller.tableTipoNotaCells.length - 1 == j?getColorCurso(controller):AppTheme.white)),
                                      ),
                                    )
                                ),

                              ],
                            ),
                          );
                        }else if(o is CriterioPesoUi){
                          return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: (){
                                      switch(o.criterioUi?.capacidadUi?.competenciaUi?.tipoCompetenciaUi??TipoCompetenciaUi.BASE){
                                        case TipoCompetenciaUi.BASE:
                                          return CachedNetworkImage(
                                            height: 16,
                                            width: 16,
                                            imageUrl: o.criterioUi?.url??"",
                                            placeholder: (context, url) => CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => SvgPicture.asset(AppIcon.ic_criterio_2, width: 16, height: 16,),
                                          );
                                        case TipoCompetenciaUi.TRANSVERSAL:
                                          return SvgPicture.asset(AppIcon.ic_transversal, width: 16, height: 16,);
                                        case TipoCompetenciaUi.ENFOQUE:
                                          return SvgPicture.asset(AppIcon.ic_enfoque, width: 16, height: 16,);
                                      }
                                    }(),
                                  ) ,
                                  Padding(padding: EdgeInsets.all(2)),
                                  Text((o.criterioUi?.peso??0).toString()+"%", style: TextStyle(fontSize: 11, color: AppTheme.black)),
                                ],
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: getColorCurso(controller)),
                                  right: BorderSide(color: getColorCurso(controller)),
                                  bottom: BorderSide(color: (controller.tableTipoNotaCells.length - 1 == j?getColorCurso(controller):AppTheme.white)),
                                ),
                                color: AppTheme.greyLighten4,
                              )
                          );
                        }else if(o is CriterioValorTipoNotaUi){
                          return Container(
                              child: Center(
                                child: Text(""),
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: getColorCurso(controller)),
                                  right: BorderSide(color: getColorCurso(controller)),
                                  bottom: BorderSide(color: (controller.tableTipoNotaCells.length - 1 == j?getColorCurso(controller):AppTheme.white)),
                                ),
                              )
                          );
                        }else{
                          return Container();
                        }
                      },
                      legendCell: Stack(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: getColorCurso(controller),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(7))
                              )
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 2),
                              child: Center(
                                child: Text('Criterios',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.white,
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12
                                    )
                                ),
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: getColorCurso(controller)),
                                ),
                              )
                          ),

                        ],
                      )
                  ),
                ),
              ),
            ),

          );
        }
      },
    ) : Container();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Color getColor(int position) {
     if(position == 1){
       return HexColor("#1976d2");
     }else if(position == 2){
       return HexColor("#388e3c");
     }else if(position == 3){
       return HexColor("#FF6D00");
     }else if(position == 4){
       return HexColor("#D32F2F");
     }else{
       return Colors.black;
     }

  }

  Color getColorCurso(RubroCrearController controller) {
    if(controller.sesionUi == null){
      return HexColor(controller.cursosUi?.color1);
    }else{
      return AppTheme.colorSesion;
    }

  }

  void showCamposAccion(RubroCrearController controller)  {
    controller.showCamposAccion();
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (context, dialogState) {
              return Container(
                height: MediaQuery.of(context).size.height * 1,
                child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: new BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(8.0),
                      topRight: const Radius.circular(8.0),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 8, right: 16, top: 16, bottom: 0),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                              child:  IconButton(
                                icon: Icon(Icons.arrow_back_sharp),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8, left: 16, right: 0),
                              child: Text("Agregrar criterios", style: TextStyle(
                                fontFamily: AppTheme.fontTTNorms,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 60),
                        padding: EdgeInsets.only(left: 0, right: 0, top: 16, bottom: 0),
                        color: Colors.transparent,
                        child: CupertinoScrollbar(
                          child: DefaultTabController(
                            length: 3,
                            child: SizedBox(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 24),
                                        right: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 24),
                                    ),
                                    child: TabBar(
                                      labelColor: AppTheme.dark_grey,
                                      indicatorColor: getColorCurso(controller),
                                      //physics: AlwaysScrollableScrollPhysics(),

                                      tabs: [
                                        Tab(text: "Base".toUpperCase(),),
                                        Tab(text: "Transversal".toUpperCase()),
                                        Tab(text: "Enfoque".toUpperCase()),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                        SingleChildScrollView(
                                          physics: ScrollPhysics(),
                                          child: ListView.builder(
                                              padding: EdgeInsets.only(
                                                  left: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 24),
                                                  right: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 24),
                                                  bottom: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 180),),
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: controller.competenciaUiBaseList.length,
                                              itemBuilder: (BuildContext ctxt, int index) {
                                                CompetenciaUi  competenciaUi = controller.competenciaUiBaseList[index];
                                                return getCompetencia('Competencias de base', index,competenciaUi, controller, dialogState);
                                              }
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          physics: ScrollPhysics(),
                                          child: ListView.builder(
                                              padding: EdgeInsets.only(
                                                left: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 24),
                                                right: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 24),
                                                bottom: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 180),),
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: controller.competenciaUiTransversalList.length,
                                              itemBuilder: (BuildContext ctxt, int index) {
                                                CompetenciaUi  competenciaUi = controller.competenciaUiTransversalList[index];
                                                return getCompetencia('Competencias transversales', index, competenciaUi, controller, dialogState);
                                              }
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          physics: ScrollPhysics(),
                                          child: ListView.builder(
                                              padding: EdgeInsets.only(
                                                left: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 24),
                                                right: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 24),
                                                bottom: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 180),),
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: controller.competenciaUiEnfoqueList.length,
                                              itemBuilder: (BuildContext ctxt, int index) {
                                                CompetenciaUi  competenciaUi = controller.competenciaUiEnfoqueList[index];
                                                return getCompetencia('Competencias de enfoque', index,competenciaUi, controller, dialogState);
                                              }
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
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }).whenComplete((){
            controller.retornoDialogCamposAccion();
        });



  }


  void showCriterioEdit(RubroCrearController controller, CriterioUi criterioUi) {
    FocusScope.of(context).unfocus();
    _tiuloCriteriocontroller.text = criterioUi.icdTituloEditado??criterioUi.icdTituloEditado??criterioUi.icdTitulo??"";
    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (context, dialogState) {
              return Container(
                height: MediaQuery.of(context).size.height * 1,
                child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: new BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                                child:  IconButton(
                                  icon: Icon(Icons.arrow_back_sharp),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 8, left: 16, right: 0),
                                  child: Text("Modificar criterio", style: TextStyle(
                                    fontFamily: AppTheme.fontTTNorms,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8, left: 0, right: 16),
                                child:  Material(
                                  color: getColorCurso(controller).withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                  child: InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                    splashColor: getColorCurso(controller).withOpacity(0.4),
                                    onTap: () {
                                      if(controller.onSaveCriterio(criterioUi)){
                                        Navigator.pop(context);
                                      }
                                    },
                                    child:
                                    Container(
                                        padding: const EdgeInsets.only(top: 10, left: 8, bottom: 8, right: 8),
                                        child: Row(
                                          children: [
                                            Text("GUARDAR",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: getColorCurso(controller),
                                                fontWeight: FontWeight.w600,
                                                fontFamily: AppTheme.fontName,
                                              ),),
                                          ],
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ),
                      Row(
                        children: [
                          Expanded(child: Container(),),
                          Padding(
                            padding: EdgeInsets.only(
                                left: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 8),
                                top: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 4),
                                right: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 24)),
                            child: Icon(
                              Ionicons.help_circle_outline,
                              color: getColorCurso(controller),
                              size: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 24),
                            ),
                          )

                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 24),
                            right: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 24),
                            top: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 8)),
                        child:  TextFormField(
                          controller: _tiuloCriteriocontroller,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.caption?.copyWith(
                            fontFamily: AppTheme.fontName,
                            fontSize: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 14),
                            color: Colors.black,
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: "Título del Criterio *",
                            labelStyle: TextStyle(
                                color:  getColorCurso(controller),
                                fontFamily: AppTheme.fontTTNormsMedium
                            ),
                            helperText: "Puede modificar el nombre del criterio o dar clic en el signo de interrigación para conocer más del criterio.",
                            helperMaxLines: 2,
                            helperStyle: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontSize: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 10),
                            ),
                            contentPadding: EdgeInsets.all(15.0),
                            prefixIcon: Container(
                              width: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 20),
                              height: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 20),
                              padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 12)),
                              child: SvgPicture.asset(AppIcon.ic_velocimetro, color: getColorCurso(controller),),
                            ),

                            suffixIcon:(controller.tituloCriterio?.isNotEmpty??false) ?
                            IconButton(
                              onPressed: (){
                                controller.clearTituloCriterio(criterioUi);
                                _tiuloCriteriocontroller.clear();
                              },
                              icon: Icon(
                                Ionicons.close_circle,
                                color: getColorCurso(controller),
                              ),
                            ):null,
                            errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: getColorCurso(controller),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: getColorCurso(controller).withOpacity(0.5),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: getColorCurso(controller),
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: getColorCurso(controller),
                              ),
                            ),
                            hintText: "Ingrese un título",
                            hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontFamily: AppTheme.fontTTNormsMedium,
                              fontSize: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 14),
                              color: getColorCurso(controller).withOpacity(0.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: getColorCurso(controller),
                              ),
                            ),
                            focusColor: AppTheme.colorAccent,
                          ),
                          onChanged: (str) {
                            dialogState((){
                              controller.changeCriterioTitulo(str, criterioUi);
                            });
                          },
                          onSaved: (str) {
                            //  To do
                          },
                        ),
                      ),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 0,
                                right: 0,
                                top: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 16),
                                bottom: 0
                            ),
                            decoration: new BoxDecoration(
                              color: getColorCurso(controller),
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(25.0),
                                topRight: const Radius.circular(25.0),
                              ),
                            ),
                            child: CustomScrollView(
                                controller: scrollController,
                                scrollDirection: Axis.vertical,
                                slivers: <Widget>[
                                  SliverList(
                                      delegate: SliverChildListDelegate([
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 24),
                                                  right: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 24),
                                                  top: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 024)
                                              ),
                                              child: Text("Campos acción", style:
                                              TextStyle(color: AppTheme.white,
                                                  fontSize: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 20),
                                                  fontFamily: AppTheme.fontTTNormsMedium),),
                                          ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 24),
                                              right: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 24),
                                              top: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 16)
                                          ),
                                          child: Container(
                                            color: AppTheme.white,
                                            height: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 40),
                                              right: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 24),
                                              top: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 8)
                                          ),
                                          child: Text("* Marque o desmarque los campos de acción que tendrá su criterio.",
                                            style: TextStyle(
                                                color: AppTheme.white,
                                                fontSize: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 12),
                                                fontStyle: FontStyle.italic
                                            )
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 16)),
                                        )
                                      ])
                                  ),
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                                      TemaCriterioUi temaCriterioUi = controller.temaCriterioEditList[index];
                                      if(controller.temaCriterioEditList.isNotEmpty){
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 24),
                                                  bottom: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 8)
                                              ),
                                              child:  Row(
                                                children: [
                                                  SvgPicture.asset(AppIcon.ic_tema_criterio,
                                                    width: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 22),
                                                    height: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 22),
                                                    color: AppTheme.white,),
                                                  Padding(padding: EdgeInsets.all(4),),
                                                  Expanded(child: Text(temaCriterioUi.titulo??"",style: TextStyle(
                                                      fontSize: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 14),
                                                      color: AppTheme.white
                                                  )))
                                                ],
                                              ),
                                            ),
                                            ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: temaCriterioUi.temaCriterioUiList?.length,
                                              itemBuilder: (context, index) {
                                                TemaCriterioUi childtemaCriterioUi = temaCriterioUi.temaCriterioUiList![index];

                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      left: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 58),
                                                      bottom: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 8)
                                                  ),
                                                  child:  InkWell(
                                                    onTap: (){
                                                      dialogState((){
                                                        if(controller.rubricaEvaluacionUi==null){
                                                          controller.onClickTemaCriterioEdit(childtemaCriterioUi);
                                                        }

                                                      });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          height:ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 24),
                                                          width: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 24),
                                                          child: Theme(
                                                            data: ThemeData(
                                                              primarySwatch: controller.rubricaEvaluacionUi==null?Colors.red:Colors.blueGrey,
                                                              unselectedWidgetColor: Colors.blueGrey, // Your color
                                                            ),
                                                            child: Checkbox(
                                                              value: childtemaCriterioUi.toogle??false,
                                                              onChanged: controller.rubricaEvaluacionUi==null?(bool? value) {
                                                                dialogState((){
                                                                  controller.onClickTemaCriterioEdit(childtemaCriterioUi);
                                                                });
                                                              }:null,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 4)),),
                                                        Expanded(child: Text(childtemaCriterioUi.titulo??"",
                                                            style: TextStyle(
                                                                fontSize: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 14),
                                                                color: AppTheme.white
                                                            )))
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          ],
                                        );
                                      }else{
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              left: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 57),
                                              bottom: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 8)),
                                          child:  InkWell(
                                            onTap: (){
                                              dialogState((){
                                                controller.onClickTemaCriterio(temaCriterioUi, criterioUi);
                                              });

                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(AppIcon.ic_tema_criterio,
                                                  width: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 22),
                                                  height: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 22),
                                                  color: AppTheme.greyDarken1,),
                                                Padding(padding: EdgeInsets.all(2),),
                                                SizedBox(
                                                  height: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 24),
                                                  width: ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 24),
                                                  child: Checkbox(
                                                    value: temaCriterioUi.toogle??false,
                                                    onChanged: (bool? value) {
                                                      dialogState((){
                                                        controller.onClickTemaCriterio(temaCriterioUi, criterioUi);
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthEditarCriterio(context, 4)),),
                                                Expanded(child: Text(temaCriterioUi.titulo??"",style: TextStyle(fontSize: 14)))
                                              ],
                                            ),
                                          ),
                                        );
                                      }


                                    },childCount: criterioUi.temaCriterioUiList?.length??0,),
                                  ),
                                  SliverList(
                                      delegate: SliverChildListDelegate([
                                        Container(
                                          height: 100,
                                        )
                                      ])
                                  ),
                                ]
                            ),
                          )
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  Future<bool?> _showMaterialDialog(RubroCrearController controller) async {
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
                                color: getColorCurso(controller)),
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("Salir sin guardar",
                                    style: TextStyle(
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
                                child: Text('Atras', style: TextStyle(fontSize: 14),),
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
                            child: Text('Salir sin guardar',
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


  Widget getCompetencia(String titulo,int index ,CompetenciaUi competenciaUi, RubroCrearController controller, StateSetter dialogState){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(index==0)
          Container(
            margin: EdgeInsets.only(
                top: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 24),
                bottom: 0
            ),
            alignment: Alignment.centerLeft,
            child: Text(titulo.toUpperCase(),
              style: TextStyle(
                  fontSize: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 18),
                  fontWeight: FontWeight.w800,
                  color: getColorCurso(controller)
              ),
            ),
          ),
        Container(
            padding: EdgeInsets.only(
                top: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 32),
                bottom: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 10),
                left: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 8)
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 8)
                  ),
                  color:  getColorCurso(controller),
                  height: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 2),
                  width: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 6),
                ),
                Padding(padding: EdgeInsets.only(
                    left: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 8)
                ),),
                Expanded(
                  child: Container(
                    child: Text("${competenciaUi.nombre??""}".toUpperCase(),
                        style: TextStyle(
                            fontSize: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 16),
                            fontWeight: FontWeight.w500,
                            color: getColorCurso(controller)
                        )
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(
                    left: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 8)
                ),),
                InkWell(
                  onTap:() {
                    dialogState((){
                      controller.onClickMostrarTodo(competenciaUi);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 4) ,
                        right: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 4),
                        top: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 4),
                        bottom: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 4)
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 20))),
                      color: getColorCurso(controller),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(competenciaUi.toogle??false? Ionicons.contract: Ionicons.expand,color: AppTheme.white,
                            size: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 18)),
                      ],
                    ),
                  ),
                )
              ],
            )
        ),
        (competenciaUi.capacidadUiList??[]).isNotEmpty?
        Row(
          children: [
            Expanded(child: Container()),

          ],
        ):Container(),
        ItemCompetencia(competenciaUi: competenciaUi, color: getColorCurso(controller),)
      ],
    );
  }

  void guardarRecursivo(RubroCrearController controller) async{
    /*int success = await controller.onSave(false);
    if(success > 0){
      Navigator.of(context).pop(1);
    }else if(success == 0){
      // No hacer nada
    }else{
      if(controller.modoOnline){
        bool? respuesta = await _showDialogErroGuardarOnline(context, controller);
        if(respuesta??false){
          guardarRecursivo(controller);
        }else{
          // No hacer nada
        }

      }else{

        bool reintentar = controller.isReintento();
        bool? respuesta = reintentar?
        await _showDialogErroGuardarOnline(context, controller):
        await _showDialogErroGuardar(context, controller);

        if(respuesta??false){
          if(reintentar){
            controller.onClickReintentar();
            guardarRecursivo(controller);
          }else{
            await controller.onSave(true);
            Navigator.of(context).pop(1);
          }
        }else{
          // No hacer nada
        }
      }
    }*/
  }
}

class ItemCompetencia extends StatefulWidget{
  final CompetenciaUi? competenciaUi;
  final Color? color;

  ItemCompetencia({this.competenciaUi, this.color});

  @override
  _ItemCompetenciaState createState() => _ItemCompetenciaState();

}

class _ItemCompetenciaState extends State<ItemCompetencia>{

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          padding: EdgeInsets.only(
              top: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 8),
              left: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 8)
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.competenciaUi?.capacidadUiList?.length,
          itemBuilder: (context, index) {
            CapacidadUi capacidadUi = (widget.competenciaUi?.capacidadUiList??[])[index];
            return  Container(
              padding: EdgeInsets.only(
                  top: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 16),
                  bottom: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: (){
                      setState((){
                        onClickCapacidad(capacidadUi, widget.competenciaUi);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft:     Radius.circular(ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 6)),
                            topRight:     Radius.circular(ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 6)),
                            bottomLeft:     Radius.circular(capacidadUi.toogle??false?0:ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 6)),
                            bottomRight:     Radius.circular(capacidadUi.toogle??false?0:ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 6))
                        ),
                        color: widget.color?.withOpacity(0.1),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            color: widget.color?.withOpacity(0.1),
                            child: Icon(capacidadUi.toogle??false?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
                                size: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 20),
                                color: widget.color
                            ),
                          ),
                          Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 16)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Capacidad".toUpperCase(), style: TextStyle(
                                      color: widget.color,
                                      fontSize: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 12),
                                      fontWeight: FontWeight.w600,

                                    ),),
                                    Text("${capacidadUi.nombre??""}".toUpperCase(), style: TextStyle(
                                        color: widget.color,
                                        fontSize: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 11),
                                        fontWeight: FontWeight.w400,
                                        height: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 1.5)
                                    ),),
                                  ],
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                  if(capacidadUi.toogle??false)
                    Container(
                      height: 1,
                      color: widget.color,
                    ),
                  if(capacidadUi.toogle??false)
                    Container(
                      padding: EdgeInsets.only(
                          top: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 24),
                          bottom: 0,
                          left: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 16)
                      ),
                      child: Text("* Marque o desmarque los campos acción de los criterios de evaluación.",
                          style: TextStyle(
                              color: AppTheme.greyDarken1,
                              fontSize: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 12),
                              fontFamily: AppTheme.fontName,
                              fontStyle: FontStyle.italic
                          )
                      ),
                    ),
                  if(capacidadUi.toogle??false)
                    ListView.builder(
                      padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 16)),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: capacidadUi.criterioUiList?.length,
                      itemBuilder: (context, index) {
                        CriterioUi criterioUi = capacidadUi.criterioUiList![index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  onClickCriterio(criterioUi);
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 0,
                                    bottom: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 8),
                                    left: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 16)
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 16),
                                      width:ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 16),
                                      child: Transform.scale(
                                        scale:  ColumnCountProvider.scaleCkeckForWidthAgregarCriterios(context),
                                        child:  Checkbox(
                                          activeColor: widget.color,
                                          value: criterioUi.toogle??false,
                                          onChanged: (bool? newchange){
                                            setState(() {
                                              onClickCriterio(criterioUi);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 6)),),
                                        (){
                                      switch(widget.competenciaUi?.tipoCompetenciaUi??TipoCompetenciaUi.BASE){
                                        case TipoCompetenciaUi.BASE:
                                          return CachedNetworkImage(
                                            height: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 18),
                                            width: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 18),
                                            imageUrl: criterioUi.url??"",
                                            placeholder: (context, url) => CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => SvgPicture.asset(AppIcon.ic_criterio_2,
                                              width: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 18),
                                              height:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 18),
                                            ),
                                          );
                                        case TipoCompetenciaUi.TRANSVERSAL:
                                          return SvgPicture.asset(AppIcon.ic_transversal,
                                            width:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 18),
                                            height:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 18),);
                                        case TipoCompetenciaUi.ENFOQUE:
                                          return SvgPicture.asset(AppIcon.ic_enfoque,
                                            width:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 18),
                                            height:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 18),);
                                      }
                                    }(),
                                    Padding(padding: EdgeInsets.all(6),),
                                    Expanded(child: Text("${criterioUi.icdTitulo??""}".trim(),style: TextStyle(fontSize:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 12))))
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                              padding: EdgeInsets.only(bottom:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 12)),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: criterioUi.temaCriterioUiList?.length,
                              itemBuilder: (context, index) {
                                TemaCriterioUi temaCriterioUi = criterioUi.temaCriterioUiList![index];
                                if((temaCriterioUi.temaCriterioUiList??[]).isNotEmpty){
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 72),
                                            bottom:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 8)),
                                        child:  Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(AppIcon.ic_tema_criterio,
                                              width:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 18),
                                              height:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 18),
                                              color: AppTheme.greyDarken1,),
                                            Padding(padding: EdgeInsets.all(6),),
                                            Expanded(child: Text((temaCriterioUi.titulo??"").trim(),style: TextStyle(fontSize: ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 12))))
                                          ],
                                        ),
                                      ),
                                      ListView.builder(
                                        padding: EdgeInsets.only(bottom: 0),
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: temaCriterioUi.temaCriterioUiList?.length,
                                        itemBuilder: (context, index) {
                                          TemaCriterioUi childtemaCriterioUi = temaCriterioUi.temaCriterioUiList![index];

                                          return InkWell(
                                              onTap: (){
                                                setState((){
                                                  onClickTemaCriterio(childtemaCriterioUi, criterioUi);
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 104),
                                                    bottom:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 12)
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      height:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 16),
                                                      width:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 16),
                                                      child: Transform.scale(
                                                        scale:  ColumnCountProvider.scaleCkeckForWidthAgregarCriterios(context),
                                                        child:  Checkbox(
                                                          activeColor: widget.color,
                                                          value: childtemaCriterioUi.toogle??false,
                                                          onChanged: (bool? value) {
                                                            setState((){
                                                              onClickTemaCriterio(childtemaCriterioUi, criterioUi);
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(padding: EdgeInsets.all( ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 4)),),
                                                    Expanded(child:
                                                    Text(childtemaCriterioUi.titulo??"",style: TextStyle(fontSize:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 12))))
                                                  ],
                                                ),
                                              )
                                          );
                                        },
                                      )
                                    ],
                                  );
                                }else{
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 40),
                                        bottom:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 12),
                                        top:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 8)),
                                    child:  InkWell(
                                      onTap: (){
                                        setState((){
                                          onClickTemaCriterio(temaCriterioUi, criterioUi);
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 16.0,
                                            width: 16.0,
                                            child: Transform.scale(
                                              scale:  ColumnCountProvider.scaleCkeckForWidthAgregarCriterios(context),
                                              child:  Checkbox(
                                                activeColor: widget.color,
                                                value: temaCriterioUi.toogle??false,
                                                onChanged: (bool? value) {
                                                  setState((){
                                                    onClickTemaCriterio(temaCriterioUi, criterioUi);
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(padding: EdgeInsets.all(6),),
                                          SvgPicture.asset(AppIcon.ic_tema_criterio,
                                            width:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 18),
                                            height:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 18),
                                            color: AppTheme.greyDarken1,),
                                          Padding(padding: EdgeInsets.all(6),),
                                          Expanded(child: Text(temaCriterioUi.titulo??"",style: TextStyle(fontSize:  ColumnCountProvider.aspectRatioForWidthAgregarCriterios(context, 12))))
                                        ],
                                      ),
                                    ),
                                  );
                                }


                              },
                            )

                          ],
                        );

                      },
                    )

                ],
              ),
            );
          },
        )
      ],
    );
  }

  void onClickCapacidad(CapacidadUi capacidadUi, CompetenciaUi? competenciaUi) {
    capacidadUi.toogle = !(capacidadUi.toogle??false);

    if(capacidadUi.toogle??false){
      bool selecionado = true;
      for(CapacidadUi capacidadUi in competenciaUi?.capacidadUiList??[]){
        if(!(capacidadUi.toogle??false)){
          selecionado = false;
          break;
        }
      }
      competenciaUi?.toogle = selecionado;
    }else{
      competenciaUi?.toogle = false;
    }
  }

  void onClickCriterio(CriterioUi criterioUi) {
    criterioUi.toogle = !(criterioUi.toogle??false);
    for(TemaCriterioUi item in criterioUi.temaCriterioUiList??[]){
      if((item.temaCriterioUiList??[]).isEmpty){
        item.toogle =  criterioUi.toogle;
      }else{
        for(TemaCriterioUi subitem in item.temaCriterioUiList??[]){
          subitem.toogle =  criterioUi.toogle;
        }
      }
    }
  }

  void onClickTemaCriterio(TemaCriterioUi childtemaCriterioUi, CriterioUi criterioUi) {
    childtemaCriterioUi.toogle = !(childtemaCriterioUi.toogle??false);
    bool todosTemasSelecionados = false;
    for(TemaCriterioUi item in criterioUi.temaCriterioUiList??[]){
      if((item.temaCriterioUiList??[]).isEmpty){
        if((item.toogle??false)){
          todosTemasSelecionados = true;
          break;
        }
      }else{
        for(TemaCriterioUi subitem in item.temaCriterioUiList??[]){
          if((subitem.toogle??false)){
            todosTemasSelecionados = true;
            break;
          }
        }
      }
    }
    criterioUi.toogle = todosTemasSelecionados;
  }



}
