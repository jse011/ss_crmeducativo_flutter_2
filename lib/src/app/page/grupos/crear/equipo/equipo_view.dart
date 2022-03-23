import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/grupos/crear/equipo/equipo_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/equipo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';

class EquipoView extends View{
  CursosUi? cursosUi;
  EquipoUi? equipoUi;
  EquipoView(this.cursosUi, this.equipoUi);

  @override
  GruposViewState createState() => GruposViewState(this.cursosUi, this.equipoUi);

}

class GruposViewState extends ViewState<EquipoView, EquipoController> with TickerProviderStateMixin{
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;

  var _tiuloRubricacontroller = TextEditingController();
  
  GlobalKey globalKey = GlobalKey();
  GruposViewState(CursosUi? cursosUi, EquipoUi? equipoUi) : super(EquipoController(cursosUi, equipoUi));

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
  Widget get view => ControlledWidgetBuilder<EquipoController>(
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
          child: ControlledWidgetBuilder<EquipoController>(
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
                              'Equipo',
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
    return ControlledWidgetBuilder<EquipoController>(
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
                            labelText: "Nombre del equipo *",
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
                      Container(
                        height: 1,
                        color: AppTheme.colorLine,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                        ),
                        child: Text("Alumnos del equipos:",
                          style: TextStyle(
                              fontFamily: AppTheme.fontTTNorms,
                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 20),
                              fontWeight: FontWeight.w700
                          ),),
                      ),
                      Container(
                       height: ColumnCountProvider.aspectRatioForWidthGrupos(context, 160),
                       child:  Scrollbar(
                         isAlwaysShown: true,
                         child: ListView.builder(
                           padding: EdgeInsets.only(
                             left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                             right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                           ),
                           scrollDirection: Axis.horizontal,
                           itemCount: controller.personaList.length,
                           itemBuilder: (context, index) {
                             PersonaUi personaUi =  controller.personaList[index];
                             return Container(
                               width: ColumnCountProvider.aspectRatioForWidthGrupos(context, 150),
                               height: ColumnCountProvider.aspectRatioForWidthGrupos(context, 150),
                               decoration: BoxDecoration(
                                   color: Colors.white,
                                   borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 16))),
                                   shape: BoxShape.rectangle
                               ),
                               padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 12)),
                               margin: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 12)),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text("${ controller.personaList.length - (index)}.",
                                     maxLines: 2,
                                     overflow: TextOverflow.ellipsis,
                                     style: TextStyle(
                                         fontFamily: AppTheme.fontTTNorms,
                                         fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                         fontWeight: FontWeight.w700
                                     ),
                                   ),
                                   Expanded(child:  Container(
                                     decoration: BoxDecoration(
                                         color: AppTheme.grey,
                                         shape: BoxShape.circle
                                     ),
                                   )
                                   ),
                                   Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                   Text("Arias Orezano Jose Francisco",
                                     maxLines: 2,
                                     overflow: TextOverflow.ellipsis,
                                     textAlign: TextAlign.center,
                                     style: TextStyle(
                                         fontFamily: AppTheme.fontTTNorms,
                                         fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                         fontWeight: FontWeight.w700
                                     ),
                                   ),

                                 ],
                               ),
                             );
                           },
                         ),
                       ),
                     ),
                      Container(
                        margin: EdgeInsets.only(
                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 26),
                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                        ),
                        child: Text("Alumnos:",
                          style: TextStyle(
                              fontFamily: AppTheme.fontTTNorms,
                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 20),
                              fontWeight: FontWeight.w700
                          ),),
                      ),
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ColumnCountProvider.columnsForWidthGrupos(context),
                          mainAxisSpacing: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                          crossAxisSpacing: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                        ),
                        shrinkWrap: true,
                        itemCount: controller.personaList.length,
                        itemBuilder: (context, index) {
                          PersonaUi personaUi =  controller.personaList[index];
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 16))),
                                ),
                                padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 12)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child:  Container(
                                      decoration: BoxDecoration(
                                          color: AppTheme.grey,
                                          shape: BoxShape.circle
                                      ),
                                    )
                                    ),
                                    Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                    Text("Arias Orezano Jose Francisco",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                          fontWeight: FontWeight.w700
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Positioned(
                                top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                                right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                                child: Image.asset(AppImagen.imagen_checked,
                                  height: ColumnCountProvider.aspectRatioForWidthGrupos(context, 25),
                                  width: ColumnCountProvider.aspectRatioForWidthGrupos(context, 25),
                                ),
                              ),

                            ],
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 26),
                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                        ),
                        child: Text("Alumnos de otros equipos:",
                          style: TextStyle(
                              fontFamily: AppTheme.fontTTNorms,
                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 20),
                              fontWeight: FontWeight.w700
                          ),),
                      ),
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ColumnCountProvider.columnsForWidthGrupos(context),
                          mainAxisSpacing: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                          crossAxisSpacing: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                        ),
                        shrinkWrap: true,
                        itemCount: controller.personaList.length,
                        itemBuilder: (context, index) {
                          PersonaUi personaUi =  controller.personaList[index];
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 16))),
                                ),
                                padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 12)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child:  Container(
                                      decoration: BoxDecoration(
                                          color: AppTheme.grey,
                                          shape: BoxShape.circle
                                      ),
                                    )
                                    ),
                                    Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                    Text("Arias Orezano Jose Francisco",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: AppTheme.fontTTNorms,
                                          fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                          fontWeight: FontWeight.w700
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8))),
                                            color: AppTheme.colorGrupos
                                        ),
                                        padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4)),
                                        child:  Text("Alchones",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 10),
                                              fontWeight: FontWeight.w700,
                                              color: AppTheme.white
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                                right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                                child: Image.asset(AppImagen.imagen_checked,
                                  height: ColumnCountProvider.aspectRatioForWidthGrupos(context, 25),
                                  width: ColumnCountProvider.aspectRatioForWidthGrupos(context, 25),
                                ),
                              ),

                            ],
                          );
                        },
                      ),
                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 100)))
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }


}