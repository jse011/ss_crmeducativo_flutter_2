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
import 'package:lottie/lottie.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/example/main.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_not_expanded_custom.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/crear/rubro_crear_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
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
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/forma_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class RubroCrearView extends View{
  CursosUi cursosUi;
  RubricaEvaluacionUi? rubroUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;

  RubroCrearView(this.cursosUi, this.calendarioPeriodoUI, this.rubroUi);

  @override
  RubroCrearViewState createState() => RubroCrearViewState(cursosUi, calendarioPeriodoUI, rubroUi);

}
class RubroCrearViewState extends ViewState<RubroCrearView, RubroCrearController> with TickerProviderStateMixin{
  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late final ScrollController verticalscrollController = ScrollController();
  late final ScrollControllers crollControllers = ScrollControllers();
  late double topBarOpacity = 0.0;
  late AnimationController animationController;

  RubroCrearViewState(cursosUi, calendarioPeriodoUI, rubroUi) : super(RubroCrearController(cursosUi, calendarioPeriodoUI, rubroUi, MoorRubroRepository(), MoorConfiguracionRepository(), DeviceHttpDatosRepositorio()));
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

    Future.delayed(const Duration(milliseconds: 500), () {
// Here you can write your code
      setState(() {
        animationController.forward();
      });}

    );

    super.initState();

  }

  @override
  Widget get view => WillPopScope(
    onWillPop: () async {

      bool? respuesta = await _showMaterialDialog(context);
      return respuesta??false;
    },
    child:  Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainTab(),
            getAppBarUI(),
            ControlledWidgetBuilder<RubroCrearController>(
                builder: (context, controller) {
                  if(controller.showDialog){
                    return  ArsProgressWidget(
                        blur: 2,
                        backgroundColor: Color(0x33000000),
                        animationDuration: Duration(milliseconds: 500));
                  }else{
                    return Container();
                  }
                })
          ],
        ),
      ),
    ),
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
                            right: 24,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                              onPressed: () async {
                                bool? respuesta = await _showMaterialDialog(context);
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
                                  'Crear evaluación',
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
                            ControlledWidgetBuilder<RubroCrearController>(
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

                                return Material(
                                  color: AppTheme.colorPrimary.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                  child: InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                    splashColor: AppTheme.colorPrimary.withOpacity(0.4),
                                    onTap: () async {
                                        print("guardar");
                                        int success = await controller.onSave();
                                        if(success != 0){
                                          Navigator.of(context).pop(true);
                                        }


                                        /*if(success == 1|| success == -2){

                                        }else if(success == -1){
                                          bool? respuesta = await _showDialogErroGuardar(context, success);
                                          if(respuesta??false){
                                            Navigator.of(context).pop(true);
                                          }
                                        }*/
                                    },
                                    child:
                                    Container(
                                        padding: const EdgeInsets.only(top: 10, left: 8, bottom: 8, right: 8),
                                        child: Row(
                                          children: [
                                            Text("GUARDAR",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppTheme.colorPrimary,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: AppTheme.fontName,
                                              ),),
                                          ],
                                        )
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
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
              child:  AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext? context, Widget? child) {
                  return FadeTransition(
                    opacity: topBarAnimation,
                    child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
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
                                        style: Theme.of(context!).textTheme.caption?.copyWith(
                                          fontFamily: AppTheme.fontName,
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: "Título de la rubica *",
                                          labelStyle: TextStyle(
                                              color:  AppTheme.colorPrimary,
                                              fontFamily: AppTheme.fontTTNormsMedium
                                          ),
                                          helperText: " ",
                                          contentPadding: EdgeInsets.all(15.0),
                                          prefixIcon: Icon(
                                            Ionicons.apps_outline,
                                            color: AppTheme.colorPrimary,
                                          ),

                                          suffixIcon:(controller.tituloRubrica?.isNotEmpty??false) ?
                                          IconButton(
                                            onPressed: (){
                                              controller.clearTitulo();
                                              _tiuloRubricacontroller.clear();
                                            },
                                            icon: Icon(
                                              Ionicons.close_circle,
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ):null,
                                          errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary.withOpacity(0.5),
                                            ),
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
                                            ),
                                          ),
                                          hintText: "Ingrese un título",
                                          hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppTheme.fontTTNormsMedium,
                                            fontSize: 14,
                                            color: AppTheme.colorPrimary.withOpacity(0.5),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary,
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
                                            color:  AppTheme.colorPrimary,
                                            fontFamily: AppTheme.fontTTNormsMedium,
                                            fontSize: 14,
                                          ),
                                          helperText: " ",
                                          contentPadding: EdgeInsets.all(15.0),
                                          prefixIcon: Icon(
                                            Icons.people_alt_outlined,
                                            color: AppTheme.colorPrimary,
                                          ),

                                          suffixIcon:  IconButton(
                                            onPressed: (){
                                              controller.clearTitulo();
                                              _tiuloRubricacontroller.clear();
                                            },
                                            icon: Icon(
                                              Ionicons.caret_down,
                                              color: AppTheme.colorPrimary,
                                            ),
                                            iconSize: 15,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary.withOpacity(0.5),
                                            ),
                                          ),
                                          hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppTheme.fontTTNormsMedium,
                                            fontSize: 14,
                                            color: AppTheme.colorPrimary.withOpacity(0.5),
                                          ),
                                        ),
                                        onChanged: (item){
                                          controller.onSelectFormaEvaluacion(item);
                                        },
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
                                            color:  AppTheme.colorPrimary,
                                            fontFamily: AppTheme.fontTTNormsMedium,
                                            fontSize: 14,
                                          ),
                                          helperText: " ",
                                          contentPadding: EdgeInsets.all(15.0),
                                          prefixIcon: Icon(
                                            Ionicons.apps_outline,
                                            color: AppTheme.colorPrimary,
                                          ),

                                          suffixIcon:  IconButton(
                                            onPressed: (){
                                              controller.clearTitulo();
                                              _tiuloRubricacontroller.clear();
                                            },
                                            icon: Icon(
                                              Ionicons.caret_down,
                                              color: AppTheme.colorPrimary,
                                            ),
                                            iconSize: 15,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: AppTheme.colorPrimary.withOpacity(0.5),
                                            ),
                                          ),
                                          hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontFamily: AppTheme.fontTTNormsMedium,
                                            fontSize: 14,
                                            color: AppTheme.colorPrimary.withOpacity(0.5),
                                          ),
                                        ),
                                        onChanged: (item){
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
                                            color: AppTheme.colorPrimary,
                                          ),
                                        )

                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 24, right: 24, top: 4),
                                      child:  InkWell(
                                        onTap: (){
                                          showDialogTipos(controller);
                                        },
                                        child: InputDecorator(
                                          textAlign: TextAlign.start,
                                          decoration:  InputDecoration(
                                            labelText: "Promedio de logro",
                                            labelStyle: TextStyle(
                                              color:  AppTheme.colorPrimary,
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
                                            prefixIcon: Container(padding: EdgeInsets.all(12), height: 15, width:15, child: SvgPicture.asset(AppIcon.ic_evaluar, color: AppTheme.colorPrimary),),
                                            suffixIcon:  IconButton(
                                              onPressed: (){
                                                controller.clearTitulo();
                                                _tiuloRubricacontroller.clear();
                                              },
                                              icon: Icon(
                                                Ionicons.ellipsis_vertical,
                                                color: AppTheme.colorPrimary,
                                              ),
                                              iconSize: 15,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                              borderSide: BorderSide(
                                                color: AppTheme.colorPrimary.withOpacity(0.5),
                                              ),
                                            ),
                                            hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontFamily: AppTheme.fontTTNormsMedium,
                                              fontSize: 14,
                                              color: AppTheme.colorPrimary.withOpacity(0.5),
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
                                    Row(
                                      children: [
                                        Padding(padding: EdgeInsets.only(left: 24, top: 16),
                                          child:  ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              primary: AppTheme.colorPrimary, // background
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
                                    ),

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
                      ),
                    ),
                  );
                },
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
            padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
            child:  Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.colorPrimary,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: SingleChildScrollView(
                    child: StickyHeadersTableNotExpandedCustom(
                        cellDimensions: CellDimensions.variableColumnWidth(
                            stickyLegendHeight:45,
                            stickyLegendWidth: 20,
                            contentCellHeight: 45,
                            columnWidths: controller.tableTipoNotacolumnWidths
                        ),
                        //cellAlignments: CellAlignments.,
                        scrollControllers: crollControllers,
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
                                    Text(obj, style: TextStyle(color: AppTheme.colorPrimary),),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(color: AppTheme.colorPrimary)
                                  ),
                                )
                            );
                          }else if(obj is bool){
                            return Container(
                                child: Center(
                                  child:  SvgPicture.asset(AppIcon.ic_nivel_logro, width: 30, height: 30,),
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(color: AppTheme.colorPrimary)
                                  ),
                                )
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
                                          Text(obj.titulo??"",
                                            style: TextStyle(fontFamily: AppTheme.fontTTNormsMedium,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: getColor(i),
                                            ),
                                          ),
                                          Text((obj.valorNumerico??0).toStringAsFixed(1),
                                            style: TextStyle(fontFamily: AppTheme.fontTTNormsMedium,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: getColor(i)
                                            ),),
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(color: AppTheme.colorPrimary)
                                      ),
                                    )
                                );
                              case TipoNotaTiposUi.SELECTOR_ICONOS:
                                return Container(
                                    child: Center(
                                      child:  CachedNetworkImage(
                                        height: 35,
                                        width: 35,
                                        imageUrl: obj.icono??"",
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(color: AppTheme.colorPrimary)
                                      ),
                                    )
                                );
                              default:
                                return Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(color: AppTheme.colorPrimary)
                                      ),
                                    )
                                );

                            }
                          }else{
                            return Container();
                          }
                          //#endregion
                        },
                        rowsTitleBuilder: (i) => Container(
                            child: Center(
                              child:  Text((i+1).toString() + "."),
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppTheme.colorPrimary),
                                right: BorderSide(color: AppTheme.colorPrimary),
                              ),
                            )
                        ),
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
                                                padding: EdgeInsets.only(left: 8, right: 8),
                                                child: Text((o.icdTituloEditado??o.icdTituloEditado??o.icdTitulo??"") , style: TextStyle(fontSize: 12),),
                                              )
                                          ),
                                          Container(
                                            width: 10,
                                            color: AppTheme.colorPrimary,
                                          )
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(color: AppTheme.colorPrimary),
                                          right: BorderSide(color: AppTheme.colorPrimary),
                                        ),
                                      )
                                  ),
                                  Positioned(
                                      top: 0,
                                      bottom: 0,
                                      right: 2,
                                      child: Icon(Icons.edit, color: AppTheme.white, size: 8,)
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
                                               height: 18,
                                               width: 18,
                                               imageUrl: o.criterioUi?.url??"",
                                               placeholder: (context, url) => CircularProgressIndicator(),
                                               errorWidget: (context, url, error) => SvgPicture.asset(AppIcon.ic_criterio_2, width: 25, height: 25,),
                                             );
                                           case TipoCompetenciaUi.TRANSVERSAL:
                                             return SvgPicture.asset(AppIcon.ic_transversal, width: 25, height: 25,);
                                           case TipoCompetenciaUi.ENFOQUE:
                                             return SvgPicture.asset(AppIcon.ic_enfoque, width: 25, height: 25,);
                                         }
                                       }(),
                                     ) ,
                                    Padding(padding: EdgeInsets.all(2)),
                                    Text((o.peso??0).toString()+"%", style: TextStyle(fontSize: 10),),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: AppTheme.colorPrimary),
                                    right: BorderSide(color: AppTheme.colorPrimary),
                                  ),
                                )
                            );
                          }else{
                            return Container(
                                child: Center(
                                  child: Text(""),
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: AppTheme.colorPrimary),
                                    right: BorderSide(color: AppTheme.colorPrimary),
                                  ),
                                )
                            );
                          }
                        },
                        legendCell: Stack(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: HexColor("#e9ebee"),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(7))
                                )
                            ),
                            Container(
                                child: Center(
                                  child: Text('N°'),
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(color: AppTheme.colorPrimary),
                                  ),
                                )
                            ),

                          ],
                        )
                    ),
                  )
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

  void showCamposAccion(RubroCrearController controller) {
    FocusScope.of(context).unfocus();
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
                        color: AppTheme.white,
                        child: CupertinoScrollbar(
                          child: DefaultTabController(
                            length: 3,
                            child: SizedBox(
                              child: Column(
                                children: <Widget>[
                                  TabBar(
                                    labelColor: AppTheme.dark_grey,
                                    //physics: AlwaysScrollableScrollPhysics(),
                                    tabs: [
                                      Tab(text: "Base",),
                                      Tab(text: "Transversal"),
                                      Tab(text: "Enfoque"),
                                    ],
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      children: [
                                        SingleChildScrollView(
                                          physics: ScrollPhysics(),
                                          child: ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: controller.competenciaUiBaseList.length,
                                              itemBuilder: (BuildContext ctxt, int index) {
                                                CompetenciaUi  competenciaUi = controller.competenciaUiBaseList[index];
                                                return getCompetencia(competenciaUi, controller, dialogState);
                                              }
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          physics: ScrollPhysics(),
                                          child: ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: controller.competenciaUiTransversalList.length,
                                              itemBuilder: (BuildContext ctxt, int index) {
                                                CompetenciaUi  competenciaUi = controller.competenciaUiTransversalList[index];
                                                return getCompetencia(competenciaUi, controller, dialogState);
                                              }
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          physics: ScrollPhysics(),
                                          child: ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: controller.competenciaUiEnfoqueList.length,
                                              itemBuilder: (BuildContext ctxt, int index) {
                                                CompetenciaUi  competenciaUi = controller.competenciaUiEnfoqueList[index];
                                                return getCompetencia(competenciaUi, controller, dialogState);
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
        });
  }

  Widget getCompetencia(CompetenciaUi competenciaUi, RubroCrearController controller, StateSetter dialogState){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: 8, left: 24, right: 24, bottom: 8),
          child: Text(competenciaUi.nombre??"",style: TextStyle(color: AppTheme.colorAccent, fontSize: 17, fontWeight: FontWeight.w700)),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: competenciaUi.capacidadUiList?.length,
          itemBuilder: (context, index) {
            CapacidadUi capacidadUi = competenciaUi.capacidadUiList![index];
            return  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 8),
                  child: Text(capacidadUi.nombre??"",style: TextStyle(fontSize: 17,color: AppTheme.greyDarken1)),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: capacidadUi.criterioUiList?.length,
                  itemBuilder: (context, index) {
                    CriterioUi criterioUi = capacidadUi.criterioUiList![index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              (){
                              switch(competenciaUi.tipoCompetenciaUi??TipoCompetenciaUi.BASE){
                                case TipoCompetenciaUi.BASE:
                                  return CachedNetworkImage(
                                    height: 25,
                                    width: 25,
                                    imageUrl: criterioUi.url??"",
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => SvgPicture.asset(AppIcon.ic_criterio_2, width: 25, height: 25,),
                                  );
                                case TipoCompetenciaUi.TRANSVERSAL:
                                  return SvgPicture.asset(AppIcon.ic_transversal, width: 25, height: 25,);
                                case TipoCompetenciaUi.ENFOQUE:
                                  return SvgPicture.asset(AppIcon.ic_enfoque, width: 25, height: 25,);
                              }
                              }(),
                              Padding(padding: EdgeInsets.all(4),),
                              SizedBox(
                                height: 24.0,
                                width: 24.0,
                                child: Checkbox(
                                  value: criterioUi.toogle??false,
                                  onChanged: (bool? value) {
                                    dialogState(() {
                                      controller.onClickCriterio(criterioUi);
                                    });
                                  },
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(4),),
                              Expanded(child: Text(criterioUi.icdTitulo??"",style: TextStyle(fontSize: 14)))
                            ],
                          ),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: criterioUi.temaCriterioUiList?.length,
                          itemBuilder: (context, index) {
                            TemaCriterioUi temaCriterioUi = criterioUi.temaCriterioUiList![index];
                            if((temaCriterioUi.temaCriterioUiList??[]).isNotEmpty){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 58, bottom: 8),
                                    child:  Row(
                                      children: [
                                        SvgPicture.asset(AppIcon.ic_tema_criterio, width: 22, height: 22, color: AppTheme.greyDarken1,),
                                        Padding(padding: EdgeInsets.all(4),),
                                        Expanded(child: Text(temaCriterioUi.titulo??"",style: TextStyle(fontSize: 14)))
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
                                        padding: EdgeInsets.only(left: 86, bottom: 8),
                                        child:  Row(
                                          children: [
                                            SizedBox(
                                              height: 24.0,
                                              width: 24.0,
                                              child: Checkbox(
                                                value: childtemaCriterioUi.toogle??false,
                                                onChanged: (bool? value) {
                                                    dialogState((){
                                                      controller.onClickTemaCriterio(childtemaCriterioUi, criterioUi);
                                                    });
                                                },
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.all(4),),
                                            Expanded(child: Text(childtemaCriterioUi.titulo??"",style: TextStyle(fontSize: 14)))
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                ],
                              );
                            }else{
                              return Padding(
                                padding: EdgeInsets.only(left: 58, bottom: 8),
                                child:  Row(
                                  children: [
                                    SvgPicture.asset(AppIcon.ic_tema_criterio, width: 22, height: 22, color: AppTheme.greyDarken1,),
                                    Padding(padding: EdgeInsets.all(2),),
                                    SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: Checkbox(
                                        value: temaCriterioUi.toogle??false,
                                        onChanged: (bool? value) {
                                          dialogState((){
                                            controller.onClickTemaCriterio(temaCriterioUi, criterioUi);
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(4),),
                                    Expanded(child: Text(temaCriterioUi.titulo??"",style: TextStyle(fontSize: 14)))
                                  ],
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
            );
          },
        )
      ],
    );
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
                                  child: Text("Editar criterio", style: TextStyle(
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
                                  color: AppTheme.colorPrimary.withOpacity(0.1),
                                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                  child: InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                    splashColor: AppTheme.colorPrimary.withOpacity(0.4),
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
                                                color: AppTheme.colorPrimary,
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
                            padding: EdgeInsets.only(left: 8, top: 4,right: 24),
                            child: Icon(
                              Ionicons.help_circle_outline,
                              color: AppTheme.colorPrimary,
                            ),
                          )

                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                        child:  TextFormField(
                          controller: _tiuloCriteriocontroller,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.caption?.copyWith(
                            fontFamily: AppTheme.fontName,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: "Título del Criterio *",
                            labelStyle: TextStyle(
                                color:  AppTheme.colorPrimary,
                                fontFamily: AppTheme.fontTTNormsMedium
                            ),
                            helperText: "Puede modificar el nombre del criterio o dar clic en el signo de interrigación para conocer más del criterio.",
                            helperMaxLines: 2,
                            helperStyle: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontSize: 10,
                            ),
                            contentPadding: EdgeInsets.all(15.0),
                            prefixIcon: Container(
                              width: 20, height: 20,
                              padding: EdgeInsets.all(12),
                              child: SvgPicture.asset(AppIcon.ic_velocimetro, color: AppTheme.colorPrimary,),
                            ),

                            suffixIcon:(controller.tituloCriterio?.isNotEmpty??false) ?
                            IconButton(
                              onPressed: (){
                                controller.clearTituloCriterio(criterioUi);
                                _tiuloCriteriocontroller.clear();
                              },
                              icon: Icon(
                                Ionicons.close_circle,
                                color: AppTheme.colorPrimary,
                              ),
                            ):null,
                            errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: AppTheme.colorPrimary,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: AppTheme.colorPrimary.withOpacity(0.5),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: AppTheme.colorPrimary,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: AppTheme.colorPrimary,
                              ),
                            ),
                            hintText: "Ingrese un título",
                            hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontFamily: AppTheme.fontTTNormsMedium,
                              fontSize: 14,
                              color: AppTheme.colorPrimary.withOpacity(0.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: AppTheme.colorPrimary,
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
                            margin: EdgeInsets.only(left: 0, right: 0, top: 16, bottom: 0),
                            decoration: new BoxDecoration(
                              color: AppTheme.colorPrimary,
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
                                              padding: EdgeInsets.only(left: 24, right: 24, top: 24),
                                              child: Text("Campos acción", style: TextStyle(color: AppTheme.white, fontSize: 20, fontFamily: AppTheme.fontTTNormsMedium),),
                                          ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 24, right: 24, top: 16),
                                          child: Container(
                                            color: AppTheme.white,
                                            height: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 40, right: 24, top: 8),
                                          child: Text("Marque o desmarque los campos de acción que tendrá su criterio.", style: TextStyle(color: AppTheme.white, fontSize: 12, fontFamily: AppTheme.fontName),),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 16),
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
                                              padding: EdgeInsets.only(left: 24, bottom: 8),
                                              child:  Row(
                                                children: [
                                                  SvgPicture.asset(AppIcon.ic_tema_criterio, width: 22, height: 22, color: AppTheme.white,),
                                                  Padding(padding: EdgeInsets.all(4),),
                                                  Expanded(child: Text(temaCriterioUi.titulo??"",style: TextStyle(fontSize: 14, color: AppTheme.white)))
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
                                                  padding: EdgeInsets.only(left: 58, bottom: 8),
                                                  child:  Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 24.0,
                                                        width: 24.0,
                                                        child: Theme(
                                                          data: ThemeData(
                                                            primarySwatch: Colors.red,
                                                            unselectedWidgetColor: Colors.blueGrey, // Your color
                                                          ),
                                                          child: Checkbox(
                                                            value: childtemaCriterioUi.toogle??false,
                                                            onChanged: (bool? value) {
                                                              dialogState((){
                                                                controller.onClickTemaCriterioEdit(childtemaCriterioUi);
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(padding: EdgeInsets.all(4),),
                                                      Expanded(child: Text(childtemaCriterioUi.titulo??"",style: TextStyle(fontSize: 14,  color: AppTheme.white)))
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          ],
                                        );
                                      }else{
                                        return Padding(
                                          padding: EdgeInsets.only(left: 58, bottom: 8),
                                          child:  Row(
                                            children: [
                                              SvgPicture.asset(AppIcon.ic_tema_criterio, width: 22, height: 22, color: AppTheme.greyDarken1,),
                                              Padding(padding: EdgeInsets.all(2),),
                                              SizedBox(
                                                height: 24.0,
                                                width: 24.0,
                                                child: Checkbox(
                                                  value: temaCriterioUi.toogle??false,
                                                  onChanged: (bool? value) {
                                                    dialogState((){
                                                      controller.onClickTemaCriterio(temaCriterioUi, criterioUi);
                                                    });
                                                  },
                                                ),
                                              ),
                                              Padding(padding: EdgeInsets.all(4),),
                                              Expanded(child: Text(temaCriterioUi.titulo??"",style: TextStyle(fontSize: 14)))
                                            ],
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

  Future<bool?> _showMaterialDialog(BuildContext context) async {
    RubroCrearController controller =
    FlutterCleanArchitecture.getController<RubroCrearController>(context, listen: false);
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
                            child: Icon(Ionicons.close, size: 35, color: AppTheme.white,),
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
                              Navigator.of(context).pop(true);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: AppTheme.red,
                              onPrimary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Salir sin guardar'),
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

  Future<bool?> _showDialogErroGuardar(BuildContext context, int tipoError) async {
    RubroCrearController controller =
    FlutterCleanArchitecture.getController<RubroCrearController>(context, listen: false);
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
                            child: Icon(Ionicons.cellular_outline, size: 35, color: AppTheme.white,),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.yellowDarken3),
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text(
                                  "Su conexión a internet esta lenta o nuestros servidores no responden.", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppTheme.fontTTNormsMedium
                                  ),),
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("No pudimos guardar su nueva evaluación. Si desea puede guardar una copia de la evaluación en su dispositivo y seguir trabajando.",
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
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Atras'),
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
                              primary: AppTheme.red,
                              onPrimary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Padding(padding: EdgeInsets.all(4), child: Text('Guardar más tarde y trabajar con una copia'),),
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