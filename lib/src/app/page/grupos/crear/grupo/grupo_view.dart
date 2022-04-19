import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/grupos/crear/grupo/grupo_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_grupo_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/integrante_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/lista_grupo_ui.dart';

class GrupoView extends View{
  CursosUi? cursosUi;
  ListaGrupoUi? grupoUi;
  GrupoView(this.cursosUi, this.grupoUi);

  @override
  GruposViewState createState() => GruposViewState(this.cursosUi, this.grupoUi);

}

class GruposViewState extends ViewState<GrupoView, GrupoController> with TickerProviderStateMixin{
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late final FocusNode _focusNombre;
  late final FocusNode _focusNode;
  var _tiuloRubricacontroller = TextEditingController();
  late final formKey = new GlobalKey<FormState>();

  GlobalKey globalKey = GlobalKey();
  GruposViewState(CursosUi? cursosUi, ListaGrupoUi? grupoUi) : super(GrupoController(cursosUi, grupoUi, MoorConfiguracionRepository(), MoorGrupoRepository(), DeviceHttpDatosRepositorio()));

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


    _focusNode = FocusNode();
    _focusNombre = FocusNode();
    _tiuloRubricacontroller.text = widget.grupoUi?.nombre??"";
    super.initState();
    //initDialog();
  }

  @override
  Widget get view => ControlledWidgetBuilder<GrupoController>(
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
      child: Scaffold(
        key: globalKey,
        backgroundColor: AppTheme.background,
        body: Stack(
          children: [
            getMainTab(),
            controller.progress?  ArsProgressWidget(
              blur: 2,
              backgroundColor: Color(0x33000000),
              animationDuration: Duration(milliseconds: 500),
              dismissable: true,
              onDismiss: (backgraund){
                if(!backgraund){
                  Navigator.of(this.context).pop();
                }

              },
            ):Container(),
            getAppBarUI(),

          ],
        ),
      ),
      );
    },
  );

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
          child: ControlledWidgetBuilder<GrupoController>(
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
                            if(await _showMaterialDialog(controller)??false){
                              Navigator.of(this.context).pop(false);
                            }
                          },
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Lista de grupos',
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
                        if((controller.listaGrupoUi?.editar??false))
                        Material(
                          color: HexColor(controller.listaGrupoUi?.color1),
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          child: InkWell(
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                            splashColor: AppTheme.grey.withOpacity(0.4),
                            onTap: ()  async{
                              _focusNombre.unfocus();
                              _focusNode.unfocus();
                             bool? success = await _showDialogEliminar(controller);
                              if(success??false){
                                dynamic? response = await controller.onDelete();
                                if(response is bool){
                                  if(response){
                                    Navigator.of(this.context).pop(true);
                                  }
                                }
                              }else{
                                //Navigator.of(this.context).pop(true);
                              }

                            },
                            child:
                            Container(
                                padding: const EdgeInsets.only(top: 10, left: 8, bottom: 8, right: 8),
                                child: Row(
                                  children: [
                                    Text("ELIMINAR",
                                      style: TextStyle(
                                        fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                        color: AppTheme.white,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppTheme.fontTTNorms,
                                      ),),
                                  ],
                                )
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(8)),
                        if((controller.listaGrupoUi?.editar??false))
                        Material(
                          color: HexColor(controller.listaGrupoUi?.color1),
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          child: InkWell(
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                            splashColor: AppTheme.grey.withOpacity(0.4),
                            onTap: ()  async{
                              _focusNombre.unfocus();
                              _focusNode.unfocus();
                              dynamic? response = await controller.onSave(true);
                              print("response ${response.toString()}");
                              if(response is bool){
                                if(response){
                                  Navigator.of(this.context).pop(true);
                                }
                              }else if(response is int){
                                if(await _showDialogAlumnosFaltantes(controller, response)??false){
                                  dynamic? response = await controller.onSave(false);
                                  if(response is bool){
                                    if(response){
                                      Navigator.of(this.context).pop(true);
                                    }
                                  }
                                }
                              }

                            },
                            child:
                            Container(
                                padding: const EdgeInsets.only(top: 10, left: 8, bottom: 8, right: 8),
                                child: Row(
                                  children: [
                                    Text("GUARDAR",
                                      style: TextStyle(
                                        fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                        color: AppTheme.white,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppTheme.fontTTNorms,
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



  Widget getMainTab() {
    return ControlledWidgetBuilder<GrupoController>(
        builder: (context, controller) {
          return  Container(
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  0,
              left: 0,//24,
              right: 0,//48
            ),
            child: Stack(
              children: [
                (controller.listaGrupoUi?.editar??false)?
                ReorderableListView(
                  scrollController: scrollController,
                  onReorder: (int oldIndex, int newIndex) {
                    print("onReorder: ${oldIndex}");
                    reorderData(oldIndex, newIndex, controller);
                  },
                  children: listContent(controller),
                ):ListView(
                  padding: EdgeInsets.all(0),
                  controller: scrollController,
                  children: listContent(controller),
                )
              ],
            ),
          );
        });

  }

   listContent (GrupoController controller){
    return [
      AbsorbPointer(
        absorbing: false,
        key: ValueKey(GrupoUi()),
        child: (controller.listaGrupoUi?.editar??false)?
        Form(key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                      right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                      top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32)
                  ),
                  child:  TextFormField(
                    focusNode: _focusNombre,
                    autofocus: false,
                    controller: _tiuloRubricacontroller,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.caption?.copyWith(
                      fontFamily: AppTheme.fontName,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: "Nombre de la lista de grupos *",
                      labelStyle: TextStyle(
                          color:  HexColor(controller.listaGrupoUi?.color1),
                          fontFamily: AppTheme.fontTTNormsMedium
                      ),
                      helperText: " ",
                      contentPadding: EdgeInsets.all(15.0),
                      suffixIcon:(controller.nombreListaGrupos?.isNotEmpty??false) ?
                      IconButton(
                        onPressed: (){
                          controller.clearTitulo();
                          _tiuloRubricacontroller.clear();
                        },
                        icon: Icon(
                          Ionicons.close_circle,
                          color: HexColor(controller.listaGrupoUi?.color1),
                        ),
                      ):null,
                      errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w700,
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: HexColor(controller.listaGrupoUi?.color1),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: HexColor(controller.listaGrupoUi?.color1).withOpacity(0.5),
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: HexColor(controller.listaGrupoUi?.color1)
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: HexColor(controller.listaGrupoUi?.color1),
                        ),
                      ),
                      hintText: "Ingrese un nombre",
                      hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontFamily: AppTheme.fontTTNormsMedium,
                        fontSize: 14,
                        color: HexColor(controller.listaGrupoUi?.color1).withOpacity(0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: HexColor(controller.listaGrupoUi?.color1),
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
                ((controller.listaGrupoUi?.modoAletorio??false)&&!(controller.listaGrupoUi?.grupoEquipoId?.isNotEmpty??false))?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child:  Padding(
                      padding: EdgeInsets.only(
                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                          bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0)
                      ),
                      child:  TextFormField(
                        focusNode: _focusNode,
                        initialValue: controller.numeroEquipos.toString(),
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.caption?.copyWith(
                          fontFamily: AppTheme.fontName,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          labelText: "¿Cuantos grupos quiere hacer?",
                          labelStyle: TextStyle(
                              color:  controller.validateGenerarGrupos?HexColor(controller.listaGrupoUi?.color1):AppTheme.red,
                              fontFamily: AppTheme.fontTTNormsMedium
                          ),
                          errorStyle: TextStyle(
                            color:  AppTheme.red,
                            fontFamily: AppTheme.fontTTNormsMedium,
                            fontSize: 12,
                          ),
                          errorMaxLines: 2,
                          helperText: " ",
                          contentPadding: EdgeInsets.all(15.0),
                          prefixIcon: Icon(
                            Ionicons.people_circle_outline,
                            color: HexColor(controller.listaGrupoUi?.color1),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: HexColor(controller.listaGrupoUi?.color1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: HexColor(controller.listaGrupoUi?.color1).withOpacity(0.5),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color:  AppTheme.red
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: AppTheme.red,
                            ),
                          ),
                          hintText: "Ingrese la cantidad de grupos",
                          hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontFamily: AppTheme.fontTTNormsMedium,
                            fontSize: 14,
                            color: HexColor(controller.listaGrupoUi?.color1).withOpacity(0.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: HexColor(controller.listaGrupoUi?.color1),
                            ),
                          ),
                          focusColor: AppTheme.colorAccent,
                        ),
                        onChanged: (str) {
                          final form = formKey.currentState;
                          controller.onValidateGenerarGrupos(form?.validate());

                          controller.changeNEquipos(str);
                        },
                        autocorrect: true,
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return 'Este campo es obligatorio.';
                          }else {
                            int numero = int.tryParse(value)??-1;
                            if(numero<0){
                              return "Tiene que ser número entero positivo y mayor o igual que 2.";
                            }else if(numero<2){
                              return "Tiene que ser mayor o igual que 2.";
                            }else if(numero>40){
                              return "Tiene que ser menor  o igual que 40.";
                            }
                          }
                          return null;
                        },
                        onSaved: (str) {
                          //  To do
                        },
                      ),
                    ),),
                    Container(
                      padding: EdgeInsets.only(
                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                          bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 40)
                      ),
                      width: ColumnCountProvider.aspectRatioForWidthGrupos(context, 150),
                      child: ElevatedButton(
                        onPressed: controller.validateGenerarGrupos?() {
                          _focusNode.unfocus();
                          _focusNombre.unfocus();
                          //controller.onClickGenerarGrupos();
                          _showDialogGeneraGrupo(controller);
                        }:null,
                        style: ElevatedButton.styleFrom(
                            primary: HexColor(controller.listaGrupoUi?.color1),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))
                        ),
                        child: Text('Generar Grupos'.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                              color: AppTheme.white,
                              fontWeight: FontWeight.w700,
                              fontFamily: AppTheme.fontTTNorms
                          ),
                        ),
                      ),
                    )
                  ],
                ):Container(),
                Container(
                  height: 1,
                  color: AppTheme.colorLine,
                ),
/*                      Container(
                        margin: EdgeInsets.only(
                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                        ),
                        child: Text("Grupos:",
                          style: TextStyle(
                              fontFamily: AppTheme.fontTTNorms,
                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 20),
                              fontWeight: FontWeight.w700
                          ),),
                      ),*/
                ((controller.listaGrupoUi?.modoAletorio??false)||(controller.listaGrupoUi?.grupoEquipoId?.isNotEmpty??false))?Container():
                Container(
                  padding: EdgeInsets.only(
                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                    left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 48),
                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 48),
                  ),
                  child: InkWell(
                    onTap: () async{
                      _focusNombre.unfocus();
                      dynamic respuesta = await AppRouter.showTiposCrearEquiposView(context, controller.cursosUi, null, controller.listaGrupoUi);
                      controller.cambiosEquipos();
                    },
                    child: Container(
                      padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                      decoration: BoxDecoration(
                        color: HexColor(controller.cursosUi?.color2),
                        borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)), // use instead of BorderRadius.all(Radius.circular(20))
                      ),
                      child: FDottedLine(
                        color: AppTheme.white,
                        strokeWidth: 2.0,
                        dottedLength: 10.0,
                        space: 2.0,
                        corner: FDottedLineCorner.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 7)),
                        /// add widget
                        child: Container(
                          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthRubro(context, 16)),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Ionicons.add, color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthRubro(context, 25),),
                              Padding(padding: EdgeInsets.only(top: 4)),
                              Text("Crear un grupo",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthRubro(context, 16),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppTheme.fontTTNorms,
                                    letterSpacing: 0.5,
                                    color: AppTheme.white
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding( padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4)),),
              ],
            )
        ):
        Container(
          child: Column(
            children: [
              Center(
                child: Container(
                    constraints: BoxConstraints(
                      //minWidth: 200.0,
                      maxWidth: 600.0,
                    ),
                    margin: EdgeInsets.only(
                      top: ColumnCountProvider.aspectRatioForWidthSesion(context, 16),
                      left: ColumnCountProvider.aspectRatioForWidthSesion(context, 20),
                      right: ColumnCountProvider.aspectRatioForWidthSesion(context, 20),
                      bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                    ),
                    padding: EdgeInsets.only(
                        left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                        right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24)
                    ),
                    decoration: BoxDecoration(
                        color: AppTheme.yellowLighten3,
                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthSesion(context, 8)))
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: ColumnCountProvider.aspectRatioForWidthSesion(context, 24),
                            height: ColumnCountProvider.aspectRatioForWidthSesion(context, 24),
                            child: Center(
                              child: Icon(Icons.group, color: AppTheme.black,),
                            )
                        ),
                        Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthSesion(context, 4))),
                        Expanded(child:  Container(
                          padding: EdgeInsets.all(8),
                          child: Text('Lista de grupo para ${controller.cursosUi?.gradoSeccion2??""} creado por otro docente.',
                              style: TextStyle(
                                  color:  Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  fontFamily: AppTheme.fontTTNorms
                              )
                          ),
                        )),
                      ],
                    )
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32)
                ),
                child: Stack(
                  children: [
                    InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Nombre de la lista de grupos *",
                        labelStyle: TextStyle(
                            color:  HexColor(controller.listaGrupoUi?.color1),
                            fontFamily: AppTheme.fontTTNormsMedium
                        ),
                        helperText: " ",
                        contentPadding: EdgeInsets.all(15.0),
                        suffixIcon: null,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: HexColor(controller.listaGrupoUi?.color1).withOpacity(0.5),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: HexColor(controller.listaGrupoUi?.color1),
                          ),
                        ),
                        hintText: "Ingrese un nombre",
                        hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontFamily: AppTheme.fontTTNormsMedium,
                          fontSize: 14,
                          color: HexColor(controller.listaGrupoUi?.color1).withOpacity(0.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: HexColor(controller.listaGrupoUi?.color1),
                          ),
                        ),
                        focusColor: AppTheme.colorAccent,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                        left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                      ),
                      child: Text("${controller.listaGrupoUi?.nombre}",
                        style: Theme.of(context).textTheme.caption?.copyWith(
                          fontFamily: AppTheme.fontName,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 1,
                color: AppTheme.colorLine,
              ),
              Padding( padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4)),),
            ],
          ),
        ),
      ),
      if(controller.listaGrupoUi?.grupoUiList?.isNotEmpty??false)
        for (var index = 0; index < (controller.listaGrupoUi?.grupoUiList?.length??0); index++)(){
          GrupoUi? grupoUi =  controller.listaGrupoUi?.grupoUiList?[index];
          grupoUi?.posicion = index+1;
          return Container(
            key: ValueKey(grupoUi),
            margin: EdgeInsets.only(
              top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
              left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
              right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
              bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
            ),
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 16)),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                    bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                    left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                  ),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      (controller.listaGrupoUi?.editar??false)?
                      Icon(Icons.drag_indicator, color: AppTheme.colorLine,):
                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),)),
                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),)),
                      Expanded(
                        child: Text("G${grupoUi?.posicion??0}:  ${grupoUi?.nombre??"Grupo sin nombres"}",
                          style: TextStyle(
                            fontFamily: AppTheme.fontTTNorms,
                            fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, (grupoUi?.nombre??"").isNotEmpty?16:14),
                            fontWeight: FontWeight.w700,
                            color:  (grupoUi?.nombre??"").isEmpty?AppTheme.grey:HexColor(controller.listaGrupoUi?.color1),
                          ),
                        ),
                      ),
                      if((controller.listaGrupoUi?.editar??false))
                        InkWell(
                          onTap: () async{
                            _focusNombre.unfocus();
                            _focusNode.unfocus();
                            dynamic respuesta = await AppRouter.showTiposCrearEquiposView(context, controller.cursosUi, grupoUi, controller.listaGrupoUi);
                            controller.cambiosEquipos();
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8) ,
                                right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8),
                                top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6),
                                bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                color: HexColor(controller.listaGrupoUi?.color1)
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.edit ,color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,12), ),
                                Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,4)),),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text("Editar",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppTheme.fontTTNorms,
                                        letterSpacing: 0.5,
                                        color:AppTheme.white,
                                        fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,10),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Padding(padding: EdgeInsets.only(
                          left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,16)
                      )),
                      if((controller.listaGrupoUi?.editar??false))
                        InkWell(
                          onTap: () async{
                            _focusNombre.unfocus();
                            _focusNode.unfocus();
                            bool? eliminar = await _showDialogEliminarGrupo(controller, grupoUi);
                            if(eliminar??false){
                              controller.elminarGrupo(grupoUi);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8) ,
                                right: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8),
                                top: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6),
                                bottom: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6)
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,6))),
                                color: HexColor(controller.listaGrupoUi?.color1)
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Ionicons.trash ,color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,12)),
                                Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthPortalTarea(context,4)),),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text("Eliminar",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppTheme.fontTTNorms,
                                        letterSpacing: 0.5,
                                        color:AppTheme.white,
                                        fontSize: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,10),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Padding(padding: EdgeInsets.only(
                          left: ColumnCountProvider.aspectRatioForWidthPortalTarea(context,8)
                      )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 4),
                    left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                    bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 4),
                  ),
                  //padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                  decoration: BoxDecoration(
                    //color: AppTheme.white,
                    //borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 14)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24)
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: grupoUi?.integranteUiList?.length??0,
                          itemBuilder: (context, index) {
                            IntegranteGrupoUi? integranteUi =  grupoUi?.integranteUiList?[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: (integranteUi?.showMore??false)?AppTheme.grey.withOpacity(0.2):null,
                                borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                              ),
                              padding: EdgeInsets.only(
                                  top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                                  bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                                  left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                                  right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)
                              ),
                              margin: EdgeInsets.only(
                                  left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                  bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, (integranteUi?.showMore??false)?16:0)
                              ),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: (controller.listaGrupoUi?.editar??false)?(){
                                      controller.onClickIntegrante(grupoUi, integranteUi);
                                    }:null,
                                    child:  Row(
                                      children: [
                                        Text("${index+1}.",
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          width: ColumnCountProvider.aspectRatioForWidthGrupos(context, 30),
                                          height: ColumnCountProvider.aspectRatioForWidthGrupos(context, 30),
                                          margin: EdgeInsets.only(
                                              left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)
                                          ),
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
                                            imageUrl: integranteUi?.personaUi?.foto??"",
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
                                        ),
                                        Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                        Expanded(
                                          child: Text("${integranteUi?.personaUi?.nombreCompleto??""}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        if((controller.listaGrupoUi?.editar??false))
                                          Icon(!(integranteUi?.showMore??false)?Icons.expand_more:Icons.expand_less,
                                            size: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                            color: HexColor(controller.listaGrupoUi?.color1),
                                          )
                                      ],
                                    ),
                                  ),
                                  ((integranteUi?.showMore??false)&&(controller.listaGrupoUi?.editar??false))?
                                  Container(
                                    child: Row(
                                      children: [
                                        Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                        TextButton.icon(
                                          icon: Icon(Icons.login, color: HexColor(controller.listaGrupoUi?.color1),),
                                          label: Text('Mover a',
                                            style: TextStyle(
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                                fontWeight: FontWeight.w700,
                                                color: HexColor(controller.listaGrupoUi?.color1)
                                            ),
                                          ),
                                          onPressed: () async{
                                            GrupoUi? newGrupoUi = await _showDialogMoverGrupo(controller, grupoUi, integranteUi);
                                            if(newGrupoUi!=null){
                                              controller.onSelectedMoverGrupo(integranteUi, newGrupoUi, grupoUi);
                                            }
                                          },
                                        ),
                                        Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                        TextButton.icon(
                                          icon: Icon(Icons.sync_alt, color: HexColor(controller.listaGrupoUi?.color1),),
                                          label: Text('Intercambiar',
                                            style: TextStyle(
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                                fontWeight: FontWeight.w700,
                                                color: HexColor(controller.listaGrupoUi?.color1)
                                            ),
                                          ),
                                          onPressed: () async{
                                            IntegranteGrupoUi? newIntegranteGrupoUi = await _showDialogIntercambiar(controller, grupoUi, integranteUi);
                                            if(newIntegranteGrupoUi !=null){
                                              controller.onSelectedTransferirAlumno(integranteUi, newIntegranteGrupoUi);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ):Container()
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                  ),
                  height: 1,
                  color: AppTheme.colorLine,
                ),
              ],
            ),
          );
        }()
      else
        AbsorbPointer(
          absorbing: false,
          key: ValueKey(GrupoUi()),
          child:  Container(
            margin: EdgeInsets.only(
              top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 54),
              left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
              right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
                ),
                Padding(padding: EdgeInsets.all(4)),
                Center(
                  child: Text("Lista de grupos vacía.\n${(controller.listaGrupoUi?.modoAletorio??false)?"Genera un grupo.":"Crea una grupo."}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppTheme.grey,
                          fontSize: 12,
                          fontFamily: AppTheme.fontTTNorms
                      )
                  ),
                )
              ],
            ),
          ),
        ),
    ];
  }

  void reorderData(int oldindex, int newindex, GrupoController controller){
    if(oldindex != 0 && newindex != 0){
      setState(() {
        newindex = newindex-1;
        oldindex = oldindex-1;
        if(newindex>oldindex){
          newindex-=1;
        }
        final items = controller.listaGrupoUi?.grupoUiList?.removeAt(oldindex);
        if(items!=null){
          controller.listaGrupoUi?.grupoUiList?.insert(newindex, items);
        }
      });
    }

  }

  Future<bool?> _showMaterialDialog(GrupoController controller) async {
    if((controller.listaGrupoUi?.editar??false)){
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
                                  color: HexColor(controller.listaGrupoUi?.color1)),
                            ),
                            Padding(padding: EdgeInsets.all(8)),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsets.all(4),),
                                    Text("Salir sin guardar", style: TextStyle(
                                        fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppTheme.fontTTNorms
                                    ),),
                                    Padding(padding: EdgeInsets.all(8),),
                                    Text("¿Está seguro que quiere salir?",
                                      style: TextStyle(
                                          fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: AppTheme.fontTTNorms
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
                                  child: Text('Cancelar', style: TextStyle(
                                      color: HexColor(controller.listaGrupoUi?.color1),
                                      fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 13),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppTheme.fontTTNorms
                                  )
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
                              },
                              style: ElevatedButton.styleFrom(
                                primary: HexColor(controller.listaGrupoUi?.color1),
                                onPrimary: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text('Salir sin guardar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 13),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppTheme.fontTTNorms
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
    }else{
      return true;
    }

  }

  Future<bool?> _showDialogEliminar(GrupoController controller) async {
    return await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return  ArsProgressWidget(
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
                                color: HexColor(controller.cursosUi?.color1)),
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.all(8),
                                    child: Text("Eliminar la lista de grupos", style: TextStyle(
                                        fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppTheme.fontTTNorms
                                    ),),
                                  ),
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("¿Está seguro de eliminar la lista de grupos?",
                                    style: TextStyle(
                                        fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppTheme.fontTTNorms
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
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Cancelar'),
                                style: OutlinedButton.styleFrom(
                                  primary: HexColor(controller.cursosUi?.color1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop(true);
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
          );
        },
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.transparent,
        transitionDuration:
        const Duration(milliseconds: 150));
  }

  Future<bool?> _showDialogAlumnosFaltantes(GrupoController controller, int? cantAlumnosSinGrupo) async {
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
                            child: Icon(Icons.group_add, size: 35, color: AppTheme.white,),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HexColor(controller.listaGrupoUi?.color1)),
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("Existen ${cantAlumnosSinGrupo==1?"un alumno":"${cantAlumnosSinGrupo} alumnos"} que no pertence a ningún grupo", style: TextStyle(
                                      fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppTheme.fontTTNorms
                                  ),),
                                  Padding(padding: EdgeInsets.all(8),),
                                  Text("¿Está seguro que quiere guardar la lista de grupos? A un puede agregar más alumnos editando un grupo${(controller.listaGrupoUi?.modoAletorio??false)?"":" ó creando un grupo más"}.",
                                    style: TextStyle(
                                        fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppTheme.fontTTNorms
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
                                child: Text('Cancelar', style: TextStyle(
                                    color: HexColor(controller.listaGrupoUi?.color1),
                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 13),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppTheme.fontTTNorms
                                )
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
                            },
                            style: ElevatedButton.styleFrom(
                              primary: HexColor(controller.listaGrupoUi?.color1),
                              onPrimary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Guardar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 13),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppTheme.fontTTNorms
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

  Future<bool?> _showDialogEliminarGrupo(GrupoController controller, GrupoUi? grupoUi) async {
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
                            child: Icon(Ionicons.trash, size: 35, color: AppTheme.white,),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HexColor(controller.listaGrupoUi?.color1)),
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("Eliminar al grupo ${grupoUi?.nombre??""}", style: TextStyle(
                                      fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppTheme.fontTTNorms
                                  ),),
                                  Padding(padding: EdgeInsets.all(8),),
                                  Text("¿Está seguro que quiere eliminar al grupo ${grupoUi?.nombre??""}?",
                                    style: TextStyle(
                                        fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppTheme.fontTTNorms
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
                                child: Text('Cancelar', style: TextStyle(
                                    color: HexColor(controller.listaGrupoUi?.color1),
                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 13),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppTheme.fontTTNorms
                                )
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
                            },
                            style: ElevatedButton.styleFrom(
                              primary: HexColor(controller.listaGrupoUi?.color1),
                              onPrimary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Eliminar grupo',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 13),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppTheme.fontTTNorms
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

  int? val = 1;

  Future<bool?> _showDialogGeneraGrupo(GrupoController controller) async {

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
                child: StatefulBuilder(builder: (context, setState) {
                  return Container(
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
                              child: Icon(Ionicons.list, size: 35, color: AppTheme.white,),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: HexColor(controller.listaGrupoUi?.color1)),
                            ),
                            Padding(padding: EdgeInsets.all(8)),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsets.all(4),),
                                    Text("Generar grupos con nombres de:", style: TextStyle(
                                        fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppTheme.fontTTNorms
                                    ),),
                                    Padding(padding: EdgeInsets.all(8),),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Radio<int>(
                                                value: 1,
                                                groupValue: val,
                                                onChanged: (index) {
                                                  setState(() {
                                                    val = index;
                                                  });
                                                },
                                              activeColor: HexColor(controller.listaGrupoUi?.color1),
                                            ),
                                            InkWell(
                                              onTap: (){
                                                setState(() {
                                                  val = 1;
                                                });
                                              },
                                              child: Text('Animales',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: AppTheme.fontTTNorms
                                                  )
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Radio<int>(
                                                value: 2,
                                                groupValue: val,
                                                onChanged: (index) {
                                                  setState(() {
                                                    val = index;
                                                  });
                                                },
                                              activeColor: HexColor(controller.listaGrupoUi?.color1),
                                            ),
                                            InkWell(
                                              onTap: (){
                                                setState(() {
                                                  val = 2;
                                                });
                                              },
                                              child: Text('Colores',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: AppTheme.fontTTNorms
                                                  )
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Radio<int>(
                                                value: 3,
                                                groupValue: val,
                                                onChanged: (index) {
                                                  setState(() {
                                                    val = index;
                                                  });
                                                },
                                              activeColor: HexColor(controller.listaGrupoUi?.color1),
                                            ),
                                            InkWell(
                                              onTap: (){
                                                setState(() {
                                                  val = 3;
                                                });
                                              },
                                              child: Text('Países',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      fontFamily: AppTheme.fontTTNorms
                                                  )
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Radio<int>(
                                                value: 4,
                                                groupValue: val,
                                                onChanged: (index) {
                                                  setState(() {
                                                    val = index;
                                                  });
                                                },
                                              activeColor: HexColor(controller.listaGrupoUi?.color1),
                                            ),
                                            InkWell(
                                              onTap: (){
                                                setState(() {
                                                  val = 4;
                                                });
                                              },
                                              child: Text('Grupos sin nombres',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: AppTheme.fontTTNorms
                                                )
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
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
                                  child: Text('Cancelar', style: TextStyle(
                                      color: HexColor(controller.listaGrupoUi?.color1),
                                      fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 13),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppTheme.fontTTNorms
                                  )
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
                                controller.onClickGenerarGrupos(val??1);
                                Navigator.of(context).pop(true);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: HexColor(controller.listaGrupoUi?.color1),
                                onPrimary: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text('Generar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 13),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppTheme.fontTTNorms
                                ),
                              ),
                            )),
                          ],
                        )
                      ],
                    ),
                  );
                }),
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

  Future<GrupoUi?> _showDialogMoverGrupo(GrupoController controller, GrupoUi? _grupoUi, IntegranteGrupoUi? integranteGrupoUi) async {
    GrupoUi? grupoUiSelected = null;
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
                child: StatefulBuilder(builder: (context, setState) {
                  return Container(
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
                              child: Icon(Icons.login, size: 30, color: AppTheme.white,),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: HexColor(controller.listaGrupoUi?.color1)),
                            ),
                            Padding(padding: EdgeInsets.all(8)),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(padding: EdgeInsets.all(4),),
                                    Text("Mover a ${integranteGrupoUi?.personaUi?.nombreCompleto??""} al grupo: ", style: TextStyle(
                                        fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppTheme.fontTTNorms
                                    ),),
                                    Padding(padding: EdgeInsets.all(8),),
                                  ],
                                )
                            )
                          ],
                        ),
                        (_grupoUi?.integranteUiList??[]).length < 2?
                        Container(
                          padding: EdgeInsets.only(
                            top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                            left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                            right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                            bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                          ),
                          child:  Container(
                            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                            decoration: BoxDecoration(
                              color: HexColor(controller.cursosUi?.color2).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)), // use instead of BorderRadius.all(Radius.circular(20))
                            ),
                            child: FDottedLine(
                              color: AppTheme.white,
                              strokeWidth: 2.0,
                              dottedLength: 10.0,
                              space: 2.0,
                              corner: FDottedLineCorner.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 7)),
                              /// add widget
                              child: Container(
                                padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 16)),
                                alignment: Alignment.center,
                                child: Text('El grupo "${integranteGrupoUi?.grupoUi?.nombre}" no puede quedar sin integrantes, por favor intercambie al alumno o agregue más integrantes editando al grupo',  style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                    fontWeight: FontWeight.w800,
                                    fontFamily: AppTheme.fontTTNorms,
                                    color: AppTheme.white
                                ),),
                              ),
                            ),
                          ),
                        ):Container(),
                        (controller.listaGrupoUi?.grupoUiList??[]).length < 2?
                        Container(
                          height: ColumnCountProvider.aspectRatioForWidthGrupos(context, 100),
                          padding: EdgeInsets.only(
                            top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                            left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                            right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                            bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                          ),
                          child:  Container(
                            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                            decoration: BoxDecoration(
                              color: HexColor(controller.cursosUi?.color2).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)), // use instead of BorderRadius.all(Radius.circular(20))
                            ),
                            child: FDottedLine(
                              color: AppTheme.white,
                              strokeWidth: 2.0,
                              dottedLength: 10.0,
                              space: 2.0,
                              corner: FDottedLineCorner.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 7)),
                              /// add widget
                              child: Container(
                                padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 16)),
                                alignment: Alignment.center,
                                child: Text("No existe otro grupo para mover al alumno",  style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                    fontWeight: FontWeight.w800,
                                    fontFamily: AppTheme.fontTTNorms,
                                    color: AppTheme.white
                                ),),
                              ),
                            ),
                          ),
                        ):Container(),
                        if((controller.listaGrupoUi?.grupoUiList??[]).length > 1 && (_grupoUi?.integranteUiList??[]).length > 1)
                        Flexible(
                            child: ListView.builder(
                              padding: EdgeInsets.only(
                                left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                              ),
                              shrinkWrap: true,
                              itemCount: controller.listaGrupoUi?.grupoUiList?.length??0,
                              itemBuilder: (context, index) {
                                GrupoUi? grupoUi =  controller.listaGrupoUi?.grupoUiList?[index];
                                if(grupoUi==_grupoUi){
                                  return Container();
                                }else{
                                  return Container(
                                    child: Row(
                                      children: [
                                        Radio<GrupoUi?>(
                                          value: grupoUi,
                                          groupValue: grupoUiSelected,
                                          onChanged: (GrupoUi? value) {
                                            setState(() {
                                              grupoUiSelected = value;
                                            });
                                          },
                                          activeColor: HexColor(controller.listaGrupoUi?.color1),
                                        ),
                                        Expanded(
                                            child: InkWell(
                                              onTap: (){
                                                setState(() {
                                                  grupoUiSelected = grupoUi;

                                                });
                                              },
                                              child:  Text("${grupoUi?.nombre}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: AppTheme.fontTTNorms,
                                                ),
                                              ),
                                            )
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                            )
                        ),
                        Padding(padding: EdgeInsets.all(8),),
                        Row(
                          children: [
                            Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(null);
                                  },
                                  child: Text('Cancelar', style: TextStyle(
                                      color: HexColor(controller.listaGrupoUi?.color1),
                                      fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 13),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppTheme.fontTTNorms
                                  )
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                )
                            ),
                            if((controller.listaGrupoUi?.grupoUiList??[]).length > 1 && (_grupoUi?.integranteUiList??[]).length > 1)
                              Padding(padding: EdgeInsets.all(8)),
                            if((controller.listaGrupoUi?.grupoUiList??[]).length > 1 && (_grupoUi?.integranteUiList??[]).length > 1)
                              Expanded(child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(grupoUiSelected);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: HexColor(controller.listaGrupoUi?.color1),
                                onPrimary: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text('Aceptar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 13),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppTheme.fontTTNorms
                                ),
                              ),
                            )),
                          ],
                        )
                      ],
                    ),
                  );
                }),
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

  Future<IntegranteGrupoUi?> _showDialogIntercambiar(GrupoController controller, GrupoUi? _grupoUi, IntegranteGrupoUi? _integranteGrupoUi) async {
    IntegranteGrupoUi? integranteGrupoUiSelected = null;
    int i = 0;
    for(GrupoUi grupoUi in controller.listaGrupoUi?.grupoUiList??[]){
      if(_grupoUi==grupoUi)continue;
      if(i == 0){
        grupoUi.showMore = true;
      }else{
        grupoUi.showMore = false;
      }
      i++;
    }
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
                child: StatefulBuilder(builder: (context, setState) {
                  return Container(
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
                              child: Icon(Icons.sync_alt, size: 30, color: AppTheme.white,),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: HexColor(controller.listaGrupoUi?.color1)),
                            ),
                            Padding(padding: EdgeInsets.all(8)),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(padding: EdgeInsets.all(4),),
                                    Text("Intercambiar a ${_integranteGrupoUi?.personaUi?.nombreCompleto??""} con el alumno: ", style: TextStyle(
                                        fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppTheme.fontTTNorms
                                    ),),
                                    Padding(padding: EdgeInsets.all(8),),
                                  ],
                                )
                            )
                          ],
                        ),
                        (controller.listaGrupoUi?.grupoUiList??[]).length < 2?
                        Container(
                          height: ColumnCountProvider.aspectRatioForWidthGrupos(context, 100),
                          padding: EdgeInsets.only(
                            top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                            left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                            right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                            bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                          ),
                          child:  Container(
                            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                            decoration: BoxDecoration(
                              color: HexColor(controller.cursosUi?.color2).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)), // use instead of BorderRadius.all(Radius.circular(20))
                            ),
                            child: FDottedLine(
                              color: AppTheme.white,
                              strokeWidth: 2.0,
                              dottedLength: 10.0,
                              space: 2.0,
                              corner: FDottedLineCorner.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 7)),
                              /// add widget
                              child: Container(
                                padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 16)),
                                alignment: Alignment.center,
                                child: Text("No existe otro grupo para intercambiar al alumno",  style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                    fontWeight: FontWeight.w800,
                                    fontFamily: AppTheme.fontTTNorms,
                                    color: AppTheme.white
                                ),),
                              ),
                            ),
                          ),
                        ):
                        Flexible(
                            child: ListView.builder(
                              padding: EdgeInsets.only(
                                left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                              ),
                              shrinkWrap: true,
                              itemCount: controller.listaGrupoUi?.grupoUiList?.length??0,
                              itemBuilder: (context, index) {
                                GrupoUi? grupoUi =  controller.listaGrupoUi?.grupoUiList?[index];
                                if(grupoUi==_grupoUi){
                                  return Container();
                                }else{
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          setState((){
                                            controller.onClickVerMasGrupo(grupoUi);
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                            left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                            right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                            bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(child: Text("${grupoUi?.nombre??""}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: AppTheme.fontTTNorms,
                                                ),
                                              ),),
                                              Icon(!(grupoUi?.showMore??false)?Icons.expand_more:Icons.expand_less, size: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),)
                                            ],
                                          ),
                                        ),
                                      ),
                                      (grupoUi?.showMore??false)?
                                      ListView.builder(
                                        padding: EdgeInsets.only(
                                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                          bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                        ),
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: grupoUi?.integranteUiList?.length??0,
                                        itemBuilder: (context, index) {
                                          IntegranteGrupoUi? integranteUi =  grupoUi?.integranteUiList?[index];
                                          return Container(
                                            child: Row(
                                              children: [
                                                Radio<IntegranteGrupoUi?>(
                                                  value: integranteUi,
                                                  groupValue: integranteGrupoUiSelected,
                                                  onChanged: (IntegranteGrupoUi? value) {
                                                    setState(() {
                                                      integranteGrupoUiSelected = value;
                                                    });
                                                  },
                                                  activeColor: HexColor(controller.listaGrupoUi?.color1),
                                                ),
                                                Expanded(
                                                    child: InkWell(
                                                      onTap: (){
                                                        setState(() {
                                                          integranteGrupoUiSelected = integranteUi;
                                                        });
                                                      },
                                                      child: Text("${integranteUi?.personaUi?.nombreCompleto??""}",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          fontFamily: AppTheme.fontTTNorms,
                                                        ),
                                                      ),
                                                    )
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ):Container()
                                    ],
                                  );
                                }
                              },
                            )
                        ),
                        Padding(padding: EdgeInsets.all(8),),
                        Row(
                          children: [
                            Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(null);
                                  },
                                  child: Text('Cancelar', style: TextStyle(
                                      color: HexColor(controller.listaGrupoUi?.color1),
                                      fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 13),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppTheme.fontTTNorms
                                  )
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                )
                            ),
                            if((controller.listaGrupoUi?.grupoUiList??[]).length > 1)
                              Padding(padding: EdgeInsets.all(8)),
                            if((controller.listaGrupoUi?.grupoUiList??[]).length > 1)
                              Expanded(child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(integranteGrupoUiSelected);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: HexColor(controller.listaGrupoUi?.color1),
                                onPrimary: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text('Aceptar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 13),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppTheme.fontTTNorms
                                ),
                              ),
                            )),
                          ],
                        )
                      ],
                    ),
                  );
                }),
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
  void dispose() {
    scrollController.dispose();
    _focusNode.dispose();
    _focusNombre.dispose();
    super.dispose();
  }


}