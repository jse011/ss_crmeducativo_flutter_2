

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/src/app/page/asistencia_qr/buscar/asistencia_qr_buscar_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_debouncer.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/error_handler.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_asistencia_qr_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/asistencia_ui.dart';

import '../../../widgets/search_bar.dart';

class AsistenciaQRBuscarView extends View{

  AsistenciaQRBuscarView();

  @override
  AsistenciaQRBuscarViewState createState() => AsistenciaQRBuscarViewState();

}

class AsistenciaQRBuscarViewState extends ViewState<AsistenciaQRBuscarView, AsistenciaQRBuscarController> with  TickerProviderStateMixin {

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  //GlobalKey globalKey = GlobalKey();
  final format = DateFormat("dd/MM/yyyy");

  late TextEditingController _buscarEventocontroller;

  //FocusNode _focusNode = FocusNode();

  final _debouncer = AppDebouncer(milliseconds: 500);

  AsistenciaQRBuscarViewState() : super(AsistenciaQRBuscarController(MoorConfiguracionRepository(), DeviceHttpDatosRepositorio(), MoorAsistenciaQRRepository()));

  @override
  void initState() {
    _buscarEventocontroller = TextEditingController()..addListener(_onTextChanged);
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
    //initDialog();
  }


  void initDialog() {
    /*  ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    ArsProgressDialog customProgressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        loadingWidget: Container(
          width: 150,
          height: 150,
          color: Colors.red,
          child: CircularProgressIndicator(),
        ));*/
  }

  @override
  void dispose() {
    //_focusNode.dispose();
    super.dispose();
  }

  @override
  Widget get view =>
      ControlledWidgetBuilder<AsistenciaQRBuscarController>(
          builder: (context, controller) {

            if(controller.dialogUi!=null){
              SchedulerBinding.instance?.addPostFrameCallback((_) {
                // fetch data

                ErrorHandler().errorDialog(context,ErrorData(
                    message: controller.dialogUi?.mensaje,
                    title: controller.dialogUi?.titulo,
                    icon: Ionicons.cloud_offline,
                    callback: (){
                      //controller.closeDialogo();
                    }
                ));
                controller.clearDialog();
              });

            }

            return Container(
              //key: globalKey,
              child: Scaffold(
                extendBody: true,
                backgroundColor: AppTheme.white,
                body: Stack(
                  children: <Widget>[
                    getMainTab(),
                    getAppBarUI(),
                  ],
                ),
              ),
            );
          }
      );

  int countView = 4;

  @override
  Widget getMainTab() {
    return ControlledWidgetBuilder<AsistenciaQRBuscarController>(
        builder: (context, controller) {
          double columnWidth = 40;
          double columnHeight = 80;
          double columnWidthAlumno = 500;
          double columnWidthApoderado = 400;
          double columnWidthIngreso = 200;
          double columnWidthSalida = 200;
          double rowHeight = 40;
          double width = columnWidth + columnWidthAlumno + columnWidthApoderado + columnWidthIngreso + columnWidthSalida;

          return Container(
              padding: EdgeInsets.only(
                top: AppBar().preferredSize.height +
                    MediaQuery
                        .of(context)
                        .padding
                        .top + 0,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: scrollController,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 64,
                      left: 32,
                      bottom: 32,
                      right: 32,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: width,
                          child: Row(
                            children: [
                              Container(
                                width: 250,
                                padding: EdgeInsets.only(left: 24, right: 24, top: 8),
                                child: TextFormField(
                                  autofocus: false,
                                  controller: _buscarEventocontroller,
                                  //focusNode: _focusNode,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.caption?.copyWith(
                                    fontFamily: AppTheme.fontName,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Buscar",
                                    labelStyle: TextStyle(
                                        color: AppTheme.colorPrimary,
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14
                                    ),
                                    helperText: " ",
                                    contentPadding: EdgeInsets.all(15.0),
                                    prefixIcon: Icon(
                                      Ionicons.search,
                                      color: AppTheme.colorPrimary,
                                    ),

                                    suffixIcon:(controller.search?.isNotEmpty??false) ?
                                    IconButton(
                                      onPressed: (){
                                        controller.clearSearch();
                                        _buscarEventocontroller.clear();
                                        //_focusNode.unfocus();
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
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: AppTheme.colorPrimary
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: AppTheme.colorPrimary,
                                      ),
                                    ),
                                    hintText: "",
                                    hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppTheme.fontTTNormsMedium,
                                      fontSize: 14,
                                      color: AppTheme.colorPrimary,
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
                                    controller.changeTitulo(str);
                                  },
                                  onSaved: (str) {
                                    //  To do
                                  },
                                ),
                              ),
                              Container(
                                width: 250,
                                padding: EdgeInsets.only(left: 24, right: 24, top: 8),
                                child: DateTimeField(
                                  initialValue: controller.fechaIncio,
                                  format: format,
                                  autofocus: false,
                                  textAlign: TextAlign.start,
                                  resetIcon: Icon(
                                    Ionicons.close_circle,
                                    color: AppTheme.colorPrimary,
                                  ),
                                  style: Theme.of(context).textTheme.caption?.copyWith(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontFamily: AppTheme.fontTTNorms,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Fecha inicio",
                                    labelStyle: TextStyle(
                                        color: AppTheme.colorPrimary,
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14
                                    ),
                                    helperText: " ",
                                    contentPadding: EdgeInsets.all(15.0),
                                    prefixIcon: Icon(
                                      Icons.web_asset_rounded,
                                      color: AppTheme.colorPrimary,
                                    ),
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
                                        color: AppTheme.colorPrimary,
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
                                    hintText: "",
                                    hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
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
                                  onChanged: (DateTime? value){
                                    controller.changeFechaInicio(value);
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
                              Container(
                                width: 250,
                                padding: EdgeInsets.only(left: 24, right: 24, top: 8),
                                child: DateTimeField(
                                  initialValue: controller.fechaFin,
                                  format: format,
                                  autofocus: false,
                                  textAlign: TextAlign.start,
                                  resetIcon: Icon(
                                    Ionicons.close_circle,
                                    color: AppTheme.colorPrimary,
                                  ),
                                  style: Theme.of(context).textTheme.caption?.copyWith(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontFamily: AppTheme.fontTTNorms,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Fecha fin",
                                    labelStyle: TextStyle(
                                      color: AppTheme.colorPrimary,
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    helperText: " ",
                                    contentPadding: EdgeInsets.all(15.0),
                                    prefixIcon: Icon(
                                      Icons.web_asset_rounded,
                                      color: AppTheme.colorPrimary,
                                    ),
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
                                        color: AppTheme.colorPrimary,
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
                                    hintText: "",
                                    hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
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
                                  onChanged: (DateTime? value){
                                    controller.changeFechaFin(value);
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
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: columnWidth,
                              height: columnHeight,
                              decoration: BoxDecoration(
                                  color: AppTheme.colorPrimary,
                                  border: Border(
                                    bottom: BorderSide( //                   <--- left side
                                      color: Colors.white,
                                    ),
                                  )
                              ),
                              child: Center(
                                child: Text("#",
                                  style: TextStyle(color: AppTheme.white),),
                              ),
                            ),
                            Container(
                              width: columnWidthAlumno,
                              height: columnHeight,
                              child: Column(
                                children: [
                                  geColumn("Información del Alumno"),
                                  Expanded(
                                      child: Row(
                                        children: [
                                          geColumn("Nivel", flex: 2),
                                          geColumn("Grado", flex: 2),
                                          geColumn("Sección"),
                                          geColumn(
                                              "Apellidos y Nombres", flex: 4),
                                        ],
                                      )
                                  )

                                ],
                              ),
                            ),
                            Container(
                              width: columnWidthApoderado,
                              height: columnHeight,
                              child: Column(
                                children: [
                                  geColumn("Información del Apoderado"),
                                  Expanded(
                                      child: Row(
                                        children: [
                                          geColumn(
                                              "Apellidos y Nombres", flex: 4),
                                          geColumn("Celular", flex: 3),
                                          //geColumn("Correo", flex: 2),
                                        ],
                                      )
                                  )

                                ],
                              ),
                            ),
                            Container(
                              width: columnWidthIngreso,
                              height: columnHeight,
                              child: Column(
                                children: [
                                  geColumn("Ingreso"),
                                  Expanded(
                                      child: Row(
                                        children: [
                                          geColumn("Hora", flex: 4),
                                          geColumn("Estado", flex: 3),
                                          //geColumn("Correo", flex: 2),
                                        ],
                                      )
                                  )

                                ],
                              ),
                            ),
                            Container(
                              width: columnWidthSalida,
                              height: columnHeight,
                              child: Column(
                                children: [
                                  geColumn("Salida"),
                                  Expanded(
                                      child: Row(
                                        children: [
                                          geColumn("Hora", flex: 4),
                                          geColumn("Estado", flex: 3),
                                          //geColumn("Correo", flex: 2),
                                        ],
                                      )
                                  )

                                ],
                              ),
                            )
                          ],
                        ),
                        Stack(
                          children: [
                            controller.list.isNotEmpty?Column(
                              children: [
                                for (var index = 0; index < controller.list.length; index++)
                                      (){
                                    AsistenciaUi asistenciaUi = controller.list[index];
                                    return  Row(
                                      children: [
                                        getRow(columnWidth, rowHeight, "${ (controller.min + 1)+ index}.", index),
                                        Container(
                                          width: columnWidthAlumno,
                                          height: rowHeight,
                                          child: Row(
                                            children: [
                                              getCell("${asistenciaUi.nombreNivelAcademico}", index,flex: 2),
                                              getCell("${asistenciaUi.nombrePeriodo}", index,flex: 2),
                                              getCell("${asistenciaUi.nombreGrupo}", index,),
                                              getCell(
                                                  "${asistenciaUi.nombre}", index, flex: 4),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: columnWidthApoderado,
                                          height: rowHeight,
                                          child: Row(
                                            children: [
                                              getCell(
                                                  "${asistenciaUi.nombreApoderado}", index, flex: 4),
                                              getCell("${asistenciaUi.celularApoderado}", index,flex: 3),
                                              //geColumn("Correo", flex: 2),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: columnWidthIngreso,
                                          height: rowHeight,
                                          child: Row(
                                            children: [
                                              getCell("${asistenciaUi.horaIngreso??""}", index,flex: 4),
                                              getCell("${asistenciaUi.estadoIngreso??""}", index,flex: 3),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: columnWidthSalida,
                                          height: rowHeight,
                                          child: Row(
                                            children: [
                                              getCell("00:00:00", index,flex: 4),
                                              getCell("", index,flex: 3),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  }(),
                              ],
                            ):
                            Container(
                              width: width,
                              color: AppTheme.white,
                              padding: EdgeInsets.only(top: 24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
                                  ),
                                  Padding(padding: EdgeInsets.all(4)),
                                  Center(
                                    child: Text("Lista asistencia vacía",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: AppTheme.grey,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12,
                                          fontFamily: AppTheme.fontTTNorms
                                      ),),
                                  ),
                                  Padding(padding: EdgeInsets.all(24)),
                                ],
                              ),
                            ),
                            controller.progress ?
                            Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: AppTheme.black.withOpacity(0.4),
                                child: Center(
                                  child: Container(
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
                                ),
                              ),
                            ):Container(),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          width: width,
                          child: Row(
                            children: [
                              controller.paginaActual != 1?
                              getCircular("1",1, false, controller):Container(),
                              InkWell(
                                onTap: (){
                                  controller.onClickPreviusPagina();
                                },
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      shape: BoxShape.circle
                                  ),
                                  child: Center(
                                      child: Icon(Icons.arrow_left, color: AppTheme.colorPrimary,)
                                  ),
                                ),
                              ),
                              for (var index = 0; index < controller.circulos.length; index++)
                                    (){
                                  int pagina = controller.circulos[index];
                                  return getCircular("${pagina}", pagina, controller.paginaActual == pagina, controller);
                                }(),
                              InkWell(
                                onTap: (){
                                  controller.onClickNextPagina();
                                },
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      shape: BoxShape.circle
                                  ),
                                  child: Center(
                                      child: Icon(Icons.arrow_right, color: AppTheme.colorPrimary,)
                                  ),
                                ),
                              ),
                              (controller.paginaActual != controller.maxpaginas && controller.maxpaginas != 0)?
                              getCircular("${controller.maxpaginas}",controller.maxpaginas, false, controller):Container(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
          );
        });
  }

  getCircular(titulo, int pagina, bool? activo, AsistenciaQRBuscarController controller){
    return InkWell(
      onTap: (){
        controller.onClickPagina(pagina);
      },
      child: Container(
        margin: EdgeInsets.all(8),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
            color: (activo??false)?AppTheme.colorPrimary:AppTheme.white,
            shape: BoxShape.circle
        ),
        child: Center(
          child: Text("${titulo}", style: TextStyle(
              color: (activo??false)?AppTheme.white:AppTheme.colorPrimary,
              fontFamily: AppTheme.fontTTNorms,
              fontSize: 14,
              fontWeight: FontWeight.w700),),
        ),
      ),
    );
  }

  getRow(columnWidth, rowHeight, String? titulo, int position) {
    Color color;
    if (position % 2 != 1) {
      color = Color(0XFFF4F4F4);
    } else {
      color = Colors.white;
    }
    return Container(
      width: columnWidth,
      height: rowHeight,
      color: color,
      child: Center(
        child: Text("${titulo}", style: TextStyle( color: AppTheme.black,
            fontFamily: AppTheme.fontTTNorms,
            fontSize: 11,
            fontWeight: FontWeight.w700),),
      ),
    );
  }

  getCell(String? titulo, int position, {flex}) {
    Color color;
    if (position % 2 != 1) {
      color = Color(0XFFF4F4F4);
    } else {
      color = Colors.white;
    }
    return Expanded(
        flex: flex ?? 1,
        child: Container(
          decoration: BoxDecoration(
              color: color,
          ),
          child: Center(
            child: Text("${titulo}", style: TextStyle(
                color: AppTheme.black,
                fontFamily: AppTheme.fontTTNorms,
                fontSize: 11,
                fontWeight: FontWeight.w700),),
          ),
        )
    );
  }

  geColumn(String? titulo,{flex}){
    return  Expanded(
      flex: flex??1,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.colorPrimary,
            border: Border(
              left: BorderSide( //                   <--- left side
                color: Colors.white,
              ),
              bottom: BorderSide( //                   <--- left side
                color: Colors.white,
              ),
            )
          ),
          child:  Center(
            child:  Text("${titulo}", style: TextStyle(color: AppTheme.white, fontFamily: AppTheme.fontTTNorms, fontSize: 11, fontWeight: FontWeight.w700),),
          ),
        )
    );
  }

  _onTextChanged() {
    String string = _buscarEventocontroller.text;
    AsistenciaQRBuscarController contactosController = FlutterCleanArchitecture.getController<AsistenciaQRBuscarController>(globalKey.currentContext!, listen: false);
    _debouncer.run(() {
      setState(() {
        /*if(string.isEmpty){

        }else{

        }*/
        contactosController.searchTitulo();

      });
    });

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
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 8,
                    right: 16,
                    top: 16 - 8.0 * topBarOpacity,
                    bottom: 12 - 8.0 * topBarOpacity),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Buscar asistencia',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: AppTheme.fontTTNorms,
                            fontWeight: FontWeight.w700,
                            fontSize: 18 + 6 - 6 * topBarOpacity,
                            color: AppTheme.darkerText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }



}

