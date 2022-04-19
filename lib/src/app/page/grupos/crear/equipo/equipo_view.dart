import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/grupos/crear/equipo/equipo_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/integrante_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/lista_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';

class EquipoView extends View{
  CursosUi? cursosUi;
  GrupoUi? equipoUi;
  ListaGrupoUi? listaGrupoUi;
  EquipoView(this.cursosUi, this.equipoUi, this.listaGrupoUi);

  @override
  GruposViewState createState() => GruposViewState(this.cursosUi, this.equipoUi, this.listaGrupoUi);

}

class GruposViewState extends ViewState<EquipoView, EquipoController> with TickerProviderStateMixin{
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late final FocusNode _focusNombre = FocusNode();
  var _tiuloRubricacontroller = TextEditingController();
  
  GlobalKey globalKey = GlobalKey();
  GruposViewState(CursosUi? cursosUi, GrupoUi? equipoUi, ListaGrupoUi? listaGrupoUi) : super(EquipoController(cursosUi, equipoUi, listaGrupoUi, MoorConfiguracionRepository()));

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


    _tiuloRubricacontroller.text = widget.equipoUi?.nombre??"";
    super.initState();
    //initDialog();
  }

  @override
  Widget get view => ControlledWidgetBuilder<EquipoController>(
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
                            bool? respuesta = await _showMaterialDialog(controller);
                            if(respuesta??false){
                              Navigator.of(context).pop(true);
                            }
                          },
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
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
                            onTap: ()  async{
                              //print("guardar");
                              _focusNombre.unfocus();
                             bool success = await controller.onSave();
                             if(success){
                               Navigator.of(this.context).pop();
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
                  scrollDirection: Axis.vertical,
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
                            labelText: "Nombre del grupo *",
                            labelStyle: TextStyle(
                                color:  HexColor(controller.cursosUi?.color1),
                                fontFamily: AppTheme.fontTTNormsMedium
                            ),
                            helperText: " ",
                            contentPadding: EdgeInsets.all(15.0),
                            suffixIcon:(controller.nombreGrupo?.isNotEmpty??false) ?
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
                        decoration: BoxDecoration(
                            color: HexColor(controller.cursosUi?.color1),
                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)))
                        ),
                        margin: EdgeInsets.only(
                            left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                            right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                            bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16)
                        ),
                        padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                        child: Row(
                          children: [
                            Expanded(child: Text("${controller.alumnosSinGrupos<1?"Todos los alumnos tienen un grupo":"${controller.alumnosSinGrupos==1?"Un alumno":"${controller.alumnosSinGrupos} alumnos"} no tienen grupo."}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppTheme.fontTTNorms,
                                    color: AppTheme.white
                                )
                            ))
                          ],
                        ),
                      ),
                      (controller.integranteUiListSelect.isNotEmpty)?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: ColumnCountProvider.aspectRatioForWidthGrupos(context, 100),
                            child:  ListView.builder(
                              padding: EdgeInsets.only(
                                left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.integranteUiListSelect.length,
                              itemBuilder: (context, index) {
                                IntegranteGrupoUi integranteGrupoUi =  controller.integranteUiListSelect[index];
                                return Stack(
                                  children: [
                                    Container(
                                      width: ColumnCountProvider.aspectRatioForWidthGrupos(context, 120),
                                      height: ColumnCountProvider.aspectRatioForWidthGrupos(context, 120),
                                      padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 10)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: ColumnCountProvider.aspectRatioForWidthGrupos(context, 50),
                                            height: ColumnCountProvider.aspectRatioForWidthGrupos(context, 50),
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
                                              imageUrl: integranteGrupoUi.personaUi?.foto??"",
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
                                          Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                          Text("${integranteGrupoUi.personaUi?.nombreCompleto}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                        right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                        child:  InkWell(
                                          onTap: (){
                                            controller.onClickRemoverIntegrante(integranteGrupoUi);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                                                right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16)
                                            ),
                                            child: Icon(Icons.cancel, color: HexColor(controller.cursosUi?.color2).withOpacity(1)),
                                          ),
                                        )
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16)
                            ),
                            child: Text("${controller.alumnosSeleccionados} de ${controller.integranteUiList.length} seleccionados${controller.alumnosSeleccionadosOtrosGrupos>0?", más ${controller.alumnosSeleccionadosOtrosGrupos==1?"1 alumno selecionado de otro grupo":"${controller.alumnosSeleccionadosOtrosGrupos} alumnos selecionados de otro grupo"} ":""}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppTheme.fontTTNorms,
                                )
                            ),
                          ),
                        ],
                      ):
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
                              child: Text("Selecione a los integrantes del grupo",  style: TextStyle(
                                  fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                  fontWeight: FontWeight.w800,
                                  fontFamily: AppTheme.fontTTNorms,
                                  color: AppTheme.white
                              ),),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        color: AppTheme.colorLine,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                        ),
                        child: Text("Alumnos:",
                          style: TextStyle(
                              fontFamily: AppTheme.fontTTNorms,
                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 20),
                              fontWeight: FontWeight.w700
                          ),),
                      ),
                      controller.integranteUiList.isEmpty&& controller.integranteUiListOrtrosEquipos.isNotEmpty?
                      Container(
                        margin: EdgeInsets.only(
                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
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
                              child: Text("Todos los alumno estan en un grupo.",
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
                      ):
                      controller.integranteUiList.isEmpty?
                      Container(
                        margin: EdgeInsets.only(
                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
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
                              child: Text("Lista de alumnos vacía.",
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
                      ):
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
                        itemCount: controller.integranteUiList.length,
                        itemBuilder: (context, index) {
                          IntegranteGrupoUi integranteGrupoUi =  controller.integranteUiList[index];
                          return InkWell(
                            onTap: (){
                              controller.onClickIntegrante(integranteGrupoUi);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: (integranteGrupoUi.personaUi?.contratoVigente??false)?Colors.white:Colors.red.withOpacity(0.8),
                                    borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 16))),
                                  ),
                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 12)),
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
                                              imageUrl: integranteGrupoUi.personaUi?.foto??"",
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
                                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                      Text("${integranteGrupoUi.personaUi?.nombreCompleto}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                if(integranteGrupoUi.toogle??false)
                                  Positioned(
                                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                                    child: Image.asset(AppImagen.imagen_checked,
                                      height: ColumnCountProvider.aspectRatioForWidthGrupos(context, 25),
                                      width: ColumnCountProvider.aspectRatioForWidthGrupos(context, 25),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                      controller.integranteUiListOrtrosEquipos.isNotEmpty?
                      Container(
                        margin: EdgeInsets.only(
                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 26),
                          left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                          bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                        ),
                        child: Text("Alumnos de otros grupos:",
                          style: TextStyle(
                              fontFamily: AppTheme.fontTTNorms,
                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 20),
                              fontWeight: FontWeight.w700
                          ),),
                      ):Container(),
                      controller.integranteUiListOrtrosEquipos.isNotEmpty?
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
                        itemCount: controller.integranteUiListOrtrosEquipos.length,
                        itemBuilder: (context, index) {
                          IntegranteGrupoUi integranteGrupoUi =  controller.integranteUiListOrtrosEquipos[index];
                          return InkWell(
                            onTap: () async{
                              if(integranteGrupoUi.toogle??false){
                                controller.traerAlumnoAEsteGrupo(integranteGrupoUi);
                              }else{
                                bool? agregar = await _showDialogAlumnosOtrosGrupos(controller, integranteGrupoUi);
                                if(agregar??false){
                                  controller.traerAlumnoAEsteGrupo(integranteGrupoUi);
                                }
                              }

                            },
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: (integranteGrupoUi.personaUi?.contratoVigente??false)?Colors.white:Colors.red.withOpacity(0.8),
                                    borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 16))),
                                  ),
                                  padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 12)),
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
                                              imageUrl: integranteGrupoUi.personaUi?.foto??"",
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
                                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                      Text("${integranteGrupoUi.personaUi?.nombreCompleto}",
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
                                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                              color: HexColor(controller.cursosUi?.color3)
                                          ),
                                          constraints: BoxConstraints(
                                              minWidth:ColumnCountProvider.aspectRatioForWidthGrupos(context, 80)
                                          ),
                                          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4)),
                                          child:  Text("${integranteGrupoUi.grupoUi?.nombre??""}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
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
                                if(integranteGrupoUi.toogle??false)
                                  Positioned(
                                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8),
                                    child: Image.asset(AppImagen.imagen_checked,
                                      height: ColumnCountProvider.aspectRatioForWidthGrupos(context, 25),
                                      width: ColumnCountProvider.aspectRatioForWidthGrupos(context, 25),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ):Container(),
                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 100)))
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<bool?> _showMaterialDialog(EquipoController controller) async {
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
                                    color: HexColor(controller.cursosUi?.color1),
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



  Future<bool?> _showDialogAlumnosOtrosGrupos(EquipoController controller, IntegranteGrupoUi? integranteGrupoUi) async {
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
                            child: Icon(Icons.login, color: AppTheme.white,),
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
                                  Text('Mover a este grupo al alumno ${integranteGrupoUi?.personaUi?.nombreCompleto??""}', style: TextStyle(
                                      fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppTheme.fontTTNorms
                                  ),),
                                  Padding(padding: EdgeInsets.all(8),),
                                  if((integranteGrupoUi?.grupoUi?.integranteUiList??[]).length - controller.alumnosSeleccionadosGrupo(integranteGrupoUi?.grupoUi) > 1)
                                  Text('¿Está seguro que quiere mover a este grupo a ${integranteGrupoUi?.personaUi?.nombreCompleto??""} del grupo "${integranteGrupoUi?.grupoUi?.nombre??""}"?',
                                    style: TextStyle(
                                        fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppTheme.fontTTNorms
                                    ),),
                                  if((integranteGrupoUi?.grupoUi?.integranteUiList??[]).length - controller.alumnosSeleccionadosGrupo(integranteGrupoUi?.grupoUi) > 1)
                                  Padding(padding: EdgeInsets.all(16),),
                                ],
                              )
                          )
                        ],
                      ),
                      (integranteGrupoUi?.grupoUi?.integranteUiList??[]).length - controller.alumnosSeleccionadosGrupo(integranteGrupoUi?.grupoUi) < 2?
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
                              child: Text('El grupo "${integranteGrupoUi?.grupoUi?.nombre}" no puede quedar sin integrantes',  style: TextStyle(
                                  fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                  fontWeight: FontWeight.w800,
                                  fontFamily: AppTheme.fontTTNorms,
                                  color: AppTheme.white
                              ),),
                            ),
                          ),
                        ),
                      ):Container(),
                      Row(
                        children: [
                          Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Cancelar', style: TextStyle(
                                    color: HexColor(controller.cursosUi?.color1),
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
                          if((integranteGrupoUi?.grupoUi?.integranteUiList??[]).length - controller.alumnosSeleccionadosGrupo(integranteGrupoUi?.grupoUi) > 1)
                          Padding(padding: EdgeInsets.all(8)),
                          if((integranteGrupoUi?.grupoUi?.integranteUiList??[]).length - controller.alumnosSeleccionadosGrupo(integranteGrupoUi?.grupoUi) > 1)
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
  void dispose() {
    scrollController.dispose();
    _focusNombre.dispose();
    super.dispose();
  }
}