import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/grupos/crear/grupo/grupo_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/equipo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_ui.dart';

class GrupoView extends View{
  CursosUi? cursosUi;
  GrupoUi? grupoUi;
  GrupoView(this.cursosUi, this.grupoUi);

  @override
  GruposViewState createState() => GruposViewState(this.cursosUi, this.grupoUi);

}

class GruposViewState extends ViewState<GrupoView, GrupoController> with TickerProviderStateMixin{
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;

  var _tiuloRubricacontroller = TextEditingController();
  
  GlobalKey globalKey = GlobalKey();
  GruposViewState(CursosUi? cursosUi, GrupoUi? grupoUi) : super(GrupoController(cursosUi, grupoUi));

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
    //initDialog();
  }

  @override
  Widget get view => ControlledWidgetBuilder<GrupoController>(
    builder: (context, controller) {

      return Scaffold(
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
              /*if(controller.mensaje!=null&&controller.mensaje!.isNotEmpty){
                Fluttertoast.showToast(
                  msg: controller.mensaje!,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                );
                controller.successMsg();
              }*/

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
                            /*bool? respuesta = await _showMaterialDialog(controller);
                            if(respuesta??false){
                              Navigator.of(context).pop(true);
                            }*/
                          },
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Grupo',
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
                          color: HexColor(controller.cursosUi?.color1),
                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                          child: InkWell(
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                            splashColor: AppTheme.grey.withOpacity(0.4),
                            onTap: ()  {
                              //print("guardar");
                             // controller.onSave();
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
                SingleChildScrollView(
                  controller: scrollController,
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
                          autofocus: false,
                          controller: _tiuloRubricacontroller,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.caption?.copyWith(
                            fontFamily: AppTheme.fontName,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            labelText: "Nombre del grupo *",
                            labelStyle: TextStyle(
                                color:  HexColor(controller.cursosUi?.color1),
                                fontFamily: AppTheme.fontTTNormsMedium
                            ),
                            helperText: " ",
                            contentPadding: EdgeInsets.all(15.0),
                            suffixIcon:(controller.tituloEvento?.isNotEmpty??false) ?
                            IconButton(
                              onPressed: (){
                                controller.clearTitulo();
                                _tiuloRubricacontroller.clear();
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
                                color: HexColor(controller.cursosUi?.color1).withOpacity(0.5),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                  color: HexColor(controller.cursosUi?.color1)
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: HexColor(controller.cursosUi?.color1),
                              ),
                            ),
                            hintText: "Ingrese un nombre",
                            hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontFamily: AppTheme.fontTTNormsMedium,
                              fontSize: 14,
                              color: HexColor(controller.cursosUi?.color1).withOpacity(0.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: HexColor(controller.cursosUi?.color1),
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
                      (controller.grupoUi?.modoAletorio??false)?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         Expanded(child:  Padding(
                           padding: EdgeInsets.only(
                               left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                               right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                               top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0)
                           ),
                           child:  TextFormField(
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
                               labelText: "Cantidad de equipos",
                               labelStyle: TextStyle(
                                   color:  HexColor(controller.cursosUi?.color1),
                                   fontFamily: AppTheme.fontTTNormsMedium
                               ),
                               helperText: " ",
                               contentPadding: EdgeInsets.all(15.0),
                               prefixIcon: Icon(
                                 Ionicons.people_circle_outline,
                                 color: HexColor(controller.cursosUi?.color1),
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
                                   color: HexColor(controller.cursosUi?.color1).withOpacity(0.5),
                                 ),
                               ),
                               focusedErrorBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(8.0),
                                 borderSide: BorderSide(
                                     color: HexColor(controller.cursosUi?.color1)
                                 ),
                               ),
                               errorBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(8.0),
                                 borderSide: BorderSide(
                                   color: HexColor(controller.cursosUi?.color1),
                                 ),
                               ),
                               hintText: "Ingrese la cantidad de equipos",
                               hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                 fontWeight: FontWeight.w500,
                                 fontFamily: AppTheme.fontTTNormsMedium,
                                 fontSize: 14,
                                 color: HexColor(controller.cursosUi?.color1).withOpacity(0.5),
                               ),
                               focusedBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(8.0),
                                 borderSide: BorderSide(
                                   color: HexColor(controller.cursosUi?.color1),
                                 ),
                               ),
                               focusColor: AppTheme.colorAccent,
                             ),
                             onChanged: (str) {
                               controller.changeNEquipos(str);
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
                               bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24)
                           ),
                           width: ColumnCountProvider.aspectRatioForWidthGrupos(context, 200),
                           child: ElevatedButton(
                             onPressed: () {
                               //Navigator.of(context).pop(true);
                             },
                             style: ElevatedButton.styleFrom(
                               primary: HexColor(controller.cursosUi?.color2),
                               elevation: 1,
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(8.0),
                               ),
                               padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))
                             ),
                             child: Text('Generar ${controller.numeroEquipos} Equipos'.toUpperCase(),
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                   fontSize: 12,
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
                      Container(
                        margin: EdgeInsets.only(
                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                        ),
                        child: Text("Equipos:",
                          style: TextStyle(
                              fontFamily: AppTheme.fontTTNorms,
                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 20),
                              fontWeight: FontWeight.w700
                          ),),
                      ),
                      (controller.grupoUi?.modoAletorio??false)?Container():
                      Container(
                        padding: EdgeInsets.only(
                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 48),
                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 48),
                        ),
                        child: InkWell(
                          onTap: () async{

                            dynamic respuesta = await AppRouter.showTiposCrearEquiposView(context, controller.cursosUi, null);
                            if(respuesta is int) controller.cambiosEquipos();
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
                                    Text("Crear nuevo equipo",
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
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                              left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 48),
                              right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 48),
                              bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.tealAccent4,
                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 16))
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                    left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                  ),
                                  child: Row(
                                    children: [
                                      Text("4.",
                                        style: TextStyle(
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.white
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                      Expanded(
                                        child: Container(
                                          child:  TextField(
                                            keyboardType: TextInputType.multiline,
                                            maxLines: null,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                              fontWeight: FontWeight.w700,
                                              color: AppTheme.white,
                                            ),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: ColumnCountProvider.aspectRatioForWidthGrupos(context, 4)),
                                              hintText: "",
                                            ),
                                          ),
                                          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                          decoration: BoxDecoration(
                                              color: AppTheme.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))
                                          ),
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                      ElevatedButton(
                                        onPressed: () {
                                          //Navigator.of(context).pop(true);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: AppTheme.redLighten5,
                                            elevation: 1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                            ),
                                            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))
                                        ),
                                        child: Text('Eliminar',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                              color: AppTheme.red,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: AppTheme.fontTTNorms
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                    left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                    bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                  ),
                                  child:  Container(
                                    padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                    decoration: BoxDecoration(
                                      color: AppTheme.tealDarken4.withOpacity(0.5),
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
                                        child: Text("Equipo sin alumnos",  style: TextStyle(
                                            fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                            fontWeight: FontWeight.w800,
                                            fontFamily: AppTheme.fontTTNorms,
                                            color: AppTheme.white
                                        ),),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                              left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 48),
                              right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 48),
                              bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                            ),
                            decoration: BoxDecoration(
                                color: AppTheme.purpleAccent4,
                                borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 16))
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                    left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                  ),
                                  child: Row(
                                    children: [
                                      Text("3.",
                                        style: TextStyle(
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.white
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                      Expanded(
                                        child: Container(
                                          child:  TextField(
                                            keyboardType: TextInputType.multiline,
                                            maxLines: null,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                              fontWeight: FontWeight.w700,
                                              color: AppTheme.white,
                                            ),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: ColumnCountProvider.aspectRatioForWidthGrupos(context, 4)),
                                              hintText: "",
                                            ),
                                          ),
                                          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                          decoration: BoxDecoration(
                                              color: AppTheme.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))
                                          ),
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                      ElevatedButton(
                                        onPressed: () {
                                          //Navigator.of(context).pop(true);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: AppTheme.redLighten5,
                                            elevation: 1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                            ),
                                            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))
                                        ),
                                        child: Text('Eliminar',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                              color: AppTheme.red,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: AppTheme.fontTTNorms
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                    left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 20),
                                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                    bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                        ),
                                        child: Row(
                                          children: [
                                            Text("-",
                                              style: TextStyle(
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                  fontWeight: FontWeight.w700,
                                                  color: AppTheme.white
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                            Expanded(
                                              child: Text("Arias Orezano Jose Francisco",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                    fontWeight: FontWeight.w700,
                                                    color: AppTheme.white
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                //Navigator.of(context).pop(true);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: AppTheme.purpleDarken4,
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                                  ),
                                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))
                                              ),
                                              child: Text('Mover',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                    color: AppTheme.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: AppTheme.fontTTNorms
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                        ),
                                        child: Row(
                                          children: [
                                            Text("-",
                                              style: TextStyle(
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                  fontWeight: FontWeight.w700,
                                                  color: AppTheme.white
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                            Expanded(
                                              child: Text("Arias Orezano Jose Francisco",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                    fontWeight: FontWeight.w700,
                                                    color: AppTheme.white
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                //Navigator.of(context).pop(true);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: AppTheme.purpleDarken4,
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                                  ),
                                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))
                                              ),
                                              child: Text('Mover',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                    color: AppTheme.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: AppTheme.fontTTNorms
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                        ),
                                        child: Row(
                                          children: [
                                            Text("-",
                                              style: TextStyle(
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                  fontWeight: FontWeight.w700,
                                                  color: AppTheme.white
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                            Expanded(
                                              child: Text("Arias Orezano Jose Francisco",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                    fontWeight: FontWeight.w700,
                                                    color: AppTheme.white
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                //Navigator.of(context).pop(true);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: AppTheme.purpleDarken4,
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                                  ),
                                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))
                                              ),
                                              child: Text('Mover',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                    color: AppTheme.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: AppTheme.fontTTNorms
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                              left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 48),
                              right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 48),
                              bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                            ),
                            decoration: BoxDecoration(
                                color: AppTheme.pinkAccent4,
                                borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 16))
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                    left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                  ),
                                  child: Row(
                                    children: [
                                      Text("3.",
                                        style: TextStyle(
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.white
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                      Expanded(
                                        child: Container(
                                          child:  TextField(
                                            keyboardType: TextInputType.multiline,
                                            maxLines: null,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                              fontWeight: FontWeight.w700,
                                              color: AppTheme.white,
                                            ),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: ColumnCountProvider.aspectRatioForWidthGrupos(context, 4)),
                                              hintText: "",
                                            ),
                                          ),
                                          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                          decoration: BoxDecoration(
                                              color: AppTheme.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))
                                          ),
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                      ElevatedButton(
                                        onPressed: () {
                                          //Navigator.of(context).pop(true);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: AppTheme.redLighten5,
                                            elevation: 1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                            ),
                                            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))
                                        ),
                                        child: Text('Eliminar',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                              color: AppTheme.red,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: AppTheme.fontTTNorms
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                    left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 20),
                                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                    bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                        ),
                                        child: Row(
                                          children: [
                                            Text("-",
                                              style: TextStyle(
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                  fontWeight: FontWeight.w700,
                                                  color: AppTheme.white
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                            Expanded(
                                              child: Text("Arias Orezano Jose Francisco",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                    fontWeight: FontWeight.w700,
                                                    color: AppTheme.white
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                //Navigator.of(context).pop(true);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: AppTheme.purpleDarken4,
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                                  ),
                                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))
                                              ),
                                              child: Text('Mover',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                    color: AppTheme.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: AppTheme.fontTTNorms
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                        ),
                                        child: Row(
                                          children: [
                                            Text("-",
                                              style: TextStyle(
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                  fontWeight: FontWeight.w700,
                                                  color: AppTheme.white
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                            Expanded(
                                              child: Text("Arias Orezano Jose Francisco",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                    fontWeight: FontWeight.w700,
                                                    color: AppTheme.white
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                //Navigator.of(context).pop(true);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: AppTheme.purpleDarken4,
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                                  ),
                                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))
                                              ),
                                              child: Text('Mover',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                    color: AppTheme.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: AppTheme.fontTTNorms
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                        ),
                                        child: Row(
                                          children: [
                                            Text("-",
                                              style: TextStyle(
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                  fontWeight: FontWeight.w700,
                                                  color: AppTheme.white
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                            Expanded(
                                              child: Text("Arias Orezano Jose Francisco",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                    fontWeight: FontWeight.w700,
                                                    color: AppTheme.white
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                //Navigator.of(context).pop(true);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: AppTheme.purpleDarken4,
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                                  ),
                                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))
                                              ),
                                              child: Text('Mover',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                    color: AppTheme.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: AppTheme.fontTTNorms
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                              left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 48),
                              right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 48),
                              bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                            ),
                            decoration: BoxDecoration(
                                color: AppTheme.purpleAccent4,
                                borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 16))
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                    left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                  ),
                                  child: Row(
                                    children: [
                                      Text("3.",
                                        style: TextStyle(
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.white
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                      Expanded(
                                        child: Container(
                                          child:  TextField(
                                            keyboardType: TextInputType.multiline,
                                            maxLines: null,
                                            style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                              fontWeight: FontWeight.w700,
                                              color: AppTheme.white,
                                            ),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: ColumnCountProvider.aspectRatioForWidthGrupos(context, 4)),
                                              hintText: "",
                                            ),
                                          ),
                                          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                          decoration: BoxDecoration(
                                              color: AppTheme.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))
                                          ),
                                        ),
                                      ),
                                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                      ElevatedButton(
                                        onPressed: () {
                                          //Navigator.of(context).pop(true);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: AppTheme.redLighten5,
                                            elevation: 1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                            ),
                                            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))
                                        ),
                                        child: Text('Eliminar',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                              color: AppTheme.red,
                                              fontWeight: FontWeight.w800,
                                              fontFamily: AppTheme.fontTTNorms
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                    left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 20),
                                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                    bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                        ),
                                        child: Row(
                                          children: [
                                            Text("-",
                                              style: TextStyle(
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                  fontWeight: FontWeight.w700,
                                                  color: AppTheme.white
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                            Expanded(
                                              child: Text("Arias Orezano Jose Francisco",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                    fontWeight: FontWeight.w700,
                                                    color: AppTheme.white
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                //Navigator.of(context).pop(true);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: AppTheme.purpleDarken4,
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                                  ),
                                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))
                                              ),
                                              child: Text('Mover',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                    color: AppTheme.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: AppTheme.fontTTNorms
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                        ),
                                        child: Row(
                                          children: [
                                            Text("-",
                                              style: TextStyle(
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                  fontWeight: FontWeight.w700,
                                                  color: AppTheme.white
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                            Expanded(
                                              child: Text("Arias Orezano Jose Francisco",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                    fontWeight: FontWeight.w700,
                                                    color: AppTheme.white
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                //Navigator.of(context).pop(true);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: AppTheme.purpleDarken4,
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                                  ),
                                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))
                                              ),
                                              child: Text('Mover',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                    color: AppTheme.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: AppTheme.fontTTNorms
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                        ),
                                        child: Row(
                                          children: [
                                            Text("-",
                                              style: TextStyle(
                                                  fontFamily: AppTheme.fontTTNorms,
                                                  fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                  fontWeight: FontWeight.w700,
                                                  color: AppTheme.white
                                              ),
                                            ),
                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                            Expanded(
                                              child: Text("Arias Orezano Jose Francisco",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                                    fontWeight: FontWeight.w700,
                                                    color: AppTheme.white
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                //Navigator.of(context).pop(true);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: AppTheme.purpleDarken4,
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                                  ),
                                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))
                                              ),
                                              child: Text('Mover',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                    color: AppTheme.white,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: AppTheme.fontTTNorms
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),



                        ],
                      ),
                      /*GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ColumnCountProvider.columnsForWidthGrupos(context),
                          mainAxisSpacing: 24.0,
                          crossAxisSpacing: 24.0,
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: 24,
                          left: 32,
                          right: 32,
                          bottom: 200
                        ),
                        shrinkWrap: true,
                        itemCount: controller.equiposUiList.length,
                        itemBuilder: (context, index) {
                          dynamic o =  controller.equiposUiList[index];

                          if(o is String){
                            return InkWell(
                              onTap: () async{
                                dynamic respuesta = await AppRouter.showTiposCrearEquiposView(context, controller.cursosUi, null);
                                if(respuesta is int) controller.cambiosEquipos();
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.colorGrupos,
                                  borderRadius: BorderRadius.circular(14), // use instead of BorderRadius.all(Radius.circular(20))
                                ),
                                child: FDottedLine(
                                  color: AppTheme.white,
                                  strokeWidth: 3.0,
                                  dottedLength: 10.0,
                                  space: 3.0,
                                  corner: FDottedLineCorner.all(14.0),

                                  /// add widget
                                  child: Container(
                                    alignment: Alignment.center,
                                    child:  Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Ionicons.add, color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthRubro(context, 40),),
                                        Padding(padding: EdgeInsets.only(top: 4)),
                                        Text("Crear\nequipo",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: ColumnCountProvider.aspectRatioForWidthRubro(context, 16),
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.5,
                                              color: AppTheme.white
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }else if (o is EquipoUi){
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 16))),
                              ),
                              padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${ controller.equiposUiList.length - index}. Los Tigres",
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontTTNorms,
                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 15),
                                    fontWeight: FontWeight.w700
                                  ),
                                  ),
                                  Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 6))),
                                  Flexible(
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 6)),
                                              child:  Row(
                                                children: [
                                                  Container(
                                                    width: ColumnCountProvider.aspectRatioForWidthGrupos(context, 20),
                                                    height: ColumnCountProvider.aspectRatioForWidthGrupos(context, 20),
                                                    decoration: BoxDecoration(
                                                        color: AppTheme.grey,
                                                        shape: BoxShape.circle
                                                    ),
                                                  ),
                                                  Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                                  Expanded(
                                                    child:  Text("1. Jose Arias",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontFamily: AppTheme.fontTTNorms,
                                                          fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                          fontWeight: FontWeight.w700
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 6)),
                                              child:  Row(
                                                children: [
                                                  Container(
                                                    width: ColumnCountProvider.aspectRatioForWidthGrupos(context, 19),
                                                    height: ColumnCountProvider.aspectRatioForWidthGrupos(context, 19),
                                                    decoration: BoxDecoration(
                                                        color: AppTheme.grey,
                                                        shape: BoxShape.circle
                                                    ),
                                                  ),
                                                  Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                                  Expanded(
                                                    child:  Text("1. Jose Arias",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontFamily: AppTheme.fontTTNorms,
                                                          fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                          fontWeight: FontWeight.w700
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 6)),
                                              child:  Row(
                                                children: [
                                                  Container(
                                                    width: ColumnCountProvider.aspectRatioForWidthGrupos(context, 19),
                                                    height: ColumnCountProvider.aspectRatioForWidthGrupos(context, 19),
                                                    decoration: BoxDecoration(
                                                        color: AppTheme.grey,
                                                        shape: BoxShape.circle
                                                    ),
                                                  ),
                                                  Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                                  Expanded(
                                                    child:  Text("1. Jose Arias",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontFamily: AppTheme.fontTTNorms,
                                                          fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                          fontWeight: FontWeight.w700
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 6)),
                                              child:  Row(
                                                children: [
                                                  Container(
                                                    width: ColumnCountProvider.aspectRatioForWidthGrupos(context, 19),
                                                    height: ColumnCountProvider.aspectRatioForWidthGrupos(context, 19),
                                                    decoration: BoxDecoration(
                                                        color: AppTheme.colorPrimary,
                                                        shape: BoxShape.circle
                                                    ),
                                                    child: Center(
                                                      child: Text("+5",
                                                        style: TextStyle(
                                                            color: AppTheme.white,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 10),
                                                            fontFamily: AppTheme.fontTTNorms
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                                  Expanded(
                                                    child:  Text("1. Jose Arias",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontFamily: AppTheme.fontTTNorms,
                                                          fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                          fontWeight: FontWeight.w700
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  )
                                ],
                              ),
                            );
                          }else{
                            return Container();
                          }
                        },
                      )*/
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }



}