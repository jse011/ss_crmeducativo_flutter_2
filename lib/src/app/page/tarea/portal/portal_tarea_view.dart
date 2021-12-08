import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/portal/portal_tarea_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_url_launcher.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_unidad_tarea_repositoy.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_archivo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_alumno_ui.dart';
import 'dart:math';

import 'package:ss_crmeducativo_2/src/domain/entities/tarea_recurso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart'; // for max function
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_drive_tools.dart';
import 'package:url_launcher/url_launcher.dart';

class PortalTareaView extends View{
  CursosUi? cursosUi;
  TareaUi? tareaUi;
  UnidadUi? unidadUi;
  SesionUi? sesionUi;
  UsuarioUi? usuarioUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;
  PortalTareaView(this.cursosUi, this.tareaUi, this.calendarioPeriodoUI);

  @override
  _PortalTareaViewState createState() => _PortalTareaViewState(usuarioUi, cursosUi, tareaUi, calendarioPeriodoUI, unidadUi, sesionUi);

}

class _PortalTareaViewState extends ViewState<PortalTareaView, PortalTareaController> with TickerProviderStateMixin{

  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late bool isExpandedSlidingSheet = false;
  late AnimationController animationController;
  late SheetController _sheetController = SheetController();
  _PortalTareaViewState(usuarioUi, cursosUi, tareaUi, calendarioPeriodoUI, unidadUi, sesionUi) : super(PortalTareaController(usuarioUi, cursosUi, tareaUi, calendarioPeriodoUI, unidadUi, sesionUi, DeviceHttpDatosRepositorio(), MoorUnidadTareaRepository(), MoorConfiguracionRepository(), MoorRubroRepository()));

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
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget get view => WillPopScope(
      onWillPop: () async {
        if(_sheetController.state?.isExpanded??false){
          _sheetController.collapse();
          return false;
        } else{
          return true;
        }
      },
    child: Scaffold(
      extendBody: true,
      backgroundColor: AppTheme.background,
      body: SlidingSheet(
        elevation: isExpandedSlidingSheet?0:2,
        cornerRadius: isExpandedSlidingSheet?0:16,
        listener: (state) {
          if(state.isExpanded != isExpandedSlidingSheet){
            setState(() {
              isExpandedSlidingSheet = state.isExpanded;
            });
          }

          print("state.isAtTop: ${state.isAtTop}");
        },
        controller: _sheetController,
        snapSpec: SnapSpec(
          // Enable snapping. This is true by default.
          snap: true,
          // Set custom snapping points.
          //snappings: [0.2, 0.5, 1.0],
          // Define to what the snappings relate to. In this case,
          // the total available space that the sheet can expand to.
          //positioning: SnapPositioning.relativeToAvailableSpace,
          //initialSnap: 0.2
          snappings: [
            150 + (MediaQuery.of(context).padding.top  + 65),
            double.infinity
          ],
          positioning: SnapPositioning.pixelOffset,
        ),
        // The body widget will be displayed under the SlidingSheet
        // and a parallax effect can be applied to it.
        body: Stack(
          children: [
            getMainTab(),
            getAppBarUI(),
          ],
        ),
        margin: EdgeInsets.only(top: (MediaQuery.of(context).padding.top  + 65)),
        minHeight: MediaQuery.of(context).size.height,
        builder: (context, state){
          // This is the content of the sheet that will get
          // scrolled, if the content is bigger than the available
          // height of the sheet.
          return SheetListenerBuilder(
            // buildWhen can be used to only rebuild the widget when needed.
            //buildWhen: (oldState, newState) => oldState.isExpanded != newState.isExpanded || oldState.isCollapsed != newState.isCollapsed,
            builder: (context, state) {
              return ControlledWidgetBuilder<PortalTareaController>(
                  builder: (context, controller) {
                    return CustomScrollView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverList(
                            delegate: SliverChildListDelegate([
                              if(!state.isExpanded)
                                Stack(
                                  children: [
                                    Center(
                                      child: Icon(!state.isExpanded ? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down, size: 32,),
                                    )
                                  ],
                                ),
                              if(!state.isCollapsed)
                                Container(
                                  margin: EdgeInsets.only(top: 24, left: 24, right: 24),
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if(true)
                                        InkWell(
                                          //onTap: ()=> controller.onClicPrecision(),
                                          child: Container(
                                            padding: EdgeInsets.only(left: 16 , right: 16, top: 8, bottom: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                                color: HexColor(controller.cursosUi?.color2)
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.add ,color: AppTheme.white, size: 15, ),
                                                Padding(padding: EdgeInsets.all(2),),
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text("Crear rubro",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        letterSpacing: 0.5,
                                                        color:AppTheme.white,
                                                        fontSize: 11,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      if(true)
                                        Container(
                                          padding: EdgeInsets.only(left: 8, right: 8),
                                          child: Text("ó", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),),
                                        ),
                                      if(true)
                                        InkWell(
                                          //onTap: ()=> controller.onClicPrecision(),
                                          child: Container(
                                            padding: EdgeInsets.only(left: 16 , right: 16, top: 8, bottom: 8),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                                color: HexColor(controller.cursosUi?.color2)
                                            ),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.add ,color: AppTheme.white, size: 15, ),
                                                Padding(padding: EdgeInsets.all(2),),
                                                FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text("Crear rúbrica",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        letterSpacing: 0.5,
                                                        color:AppTheme.white,
                                                        fontSize: 11,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      false?
                                      InkWell(
                                        //onTap: ()=> controller.onClicPrecision(),
                                        child: Container(
                                          padding: EdgeInsets.only(left: 16 , right: 16, top: 8, bottom: 8),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                              color: HexColor(controller.cursosUi?.color2)
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Ionicons.trash ,color: AppTheme.white, size: 14),
                                              Padding(padding: EdgeInsets.all(2),),
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text("Eliminar rúbrica",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      letterSpacing: 0.5,
                                                      color:AppTheme.white,
                                                      fontSize: 11,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ):Container(),
                                    ],
                                  ),
                                ),
                              Container(
                                padding: EdgeInsets.only(top: state.isCollapsed?8:24,left: 24, right: 24),
                                child: Row(
                                  children: [
                                    Text("Trabajo de los estudiantes", style: TextStyle(color: HexColor(controller.cursosUi?.color1), fontSize: 24),),
                                    Expanded(child: Container()),
                                    //Text("Tarea publicado",  style: TextStyle(color: AppTheme.colorPrimaryDark, fontSize: 14, fontWeight: FontWeight.w700),),
                                  ],
                                ),
                              ),
                              if(state.isCollapsed)
                                InkWell(
                                  onTap: (){
                                    _sheetController.expand();
                                  },
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(left: 24, right: 24, top: 16),
                                    height: 70,
                                    child: Row(
                                      children: [
                                        Icon(Icons.message_outlined, size: 20,),
                                        Padding(padding: EdgeInsets.all(4)),
                                        Expanded(
                                            child: Text("Calificar los trabajos o agregar un comentario privado", style: TextStyle(),)
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              Container(
                                margin: EdgeInsets.only(top: 24, left: 24, right: 24),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text("20", style: TextStyle(color: HexColor(controller.cursosUi?.color1), fontSize: 20, fontWeight: FontWeight.w500),),
                                              Text("Evaluados", style: TextStyle(color: AppTheme.greyDarken1, fontSize: 10))
                                            ],
                                          ),
                                        )
                                    ),
                                    Container(
                                      color: AppTheme.greyLighten1,
                                      height: 40,
                                      width: 1,
                                    ),
                                    Expanded(
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text("0", style: TextStyle(color: HexColor(controller.cursosUi?.color1), fontSize: 20, fontWeight: FontWeight.w500),),
                                              Text("Sin evaluar", style: TextStyle(color: AppTheme.greyDarken1, fontSize: 10))
                                            ],
                                          ),
                                        )
                                    ),
                                    InkWell(
                                      onTap: ()=> controller.onClickMostrarTodo(),
                                      child: Container(
                                        padding: EdgeInsets.only(left: 4 , right: 4, top: 4, bottom: 4),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                            color: HexColor(controller.cursosUi?.color2)
                                        ),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(controller.toogleGeneral?Ionicons.contract: Ionicons.expand,color: AppTheme.white, size: 16),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ])
                        ),
                        if(!state.isCollapsed)
                          SliverToBoxAdapter(
                            child: ListView.builder(
                              padding: EdgeInsets.only(top: 24),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index){
                                TareaAlumnoUi tareaAlumnoUi = controller.tareaAlumnoUiList[index];
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        controller.onClickTareaAlumno(tareaAlumnoUi);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: 24, right: 24),
                                        padding: EdgeInsets.all(4),
                                        color: HexColor(controller.cursosUi?.color2).withOpacity(0.1),
                                        child: Row(
                                          children: [
                                            Container(
                                              color: HexColor(controller.cursosUi?.color2).withOpacity(0.1),
                                              child: Icon(Icons.keyboard_arrow_up, size: 20,color: HexColor(controller.cursosUi?.color1)),
                                            ),
                                            Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 4),
                                                  child: Text("${(tareaAlumnoUi.personaUi?.nombreCompleto??"").toUpperCase()}", style: TextStyle(color: HexColor(controller.cursosUi?.color1), fontSize: 10, fontWeight: FontWeight.w500),),
                                                )
                                            ),
                                            (tareaAlumnoUi.entregado??false)?
                                            Container(
                                              padding: EdgeInsets.only(left: 4 , right: 4, top: 4, bottom: 4),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(2)),
                                                  color: HexColor(controller.cursosUi?.color2)
                                              ),
                                              alignment: Alignment.center,
                                              child: Text((tareaAlumnoUi.entregado_retraso??false) ? "Entregado\ncon retrazo": "Entregado",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color:AppTheme.white,
                                                    fontSize: 10,
                                                  )),
                                            ):Container(),
                                            Padding(padding: EdgeInsets.all(4)),
                                            ((tareaAlumnoUi.valorTipoNotaId??"").isNotEmpty)?
                                            Container(
                                              padding: EdgeInsets.only(left: 4 , right: 4, top: 4, bottom: 4),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(2)),
                                                  color: HexColor(controller.cursosUi?.color2)
                                              ),
                                              alignment: Alignment.center,
                                              child: Text("Evaluado",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color:AppTheme.white,
                                                    fontSize: 10,
                                                  )),
                                            ):Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                    (tareaAlumnoUi.toogle??false)?
                                    Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 24, right: 24),
                                          height: 1,
                                          color: HexColor(controller.cursosUi?.color1),
                                        ),
                                        true?
                                        Container(
                                          margin: EdgeInsets.only(top:  16, left: 24, right: 24),
                                          color: AppTheme.brownDarken4,
                                          height: 100,
                                          width: 200,
                                        ): Container(),
                                        Container(
                                          margin: EdgeInsets.only(left: 24, right: 24, top: 8),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.only(top: 0),
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: tareaAlumnoUi.archivos?.length??0,
                                              itemBuilder: (context, index){
                                                TareaAlumnoArchivoUi tareaAlumnoArchivoUi = tareaAlumnoUi.archivos![index];
                                                return  Stack(
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(4), // use instead of BorderRadius.all(Radius.circular(20))
                                                            border:  Border.all(
                                                                width: 1,
                                                                color: AppTheme.greyLighten2
                                                            ),
                                                            color: AppTheme.white
                                                        ),
                                                        margin: EdgeInsets.only(top: 8),
                                                        width: 450,
                                                        height: 50,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.only(right: 16),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                    bottomLeft: Radius.circular(4),
                                                                    topLeft: Radius.circular(4),
                                                                  ), // use instead of BorderRadius.all(Radius.circular(20))
                                                                  color: AppTheme.greyLighten3
                                                              ),
                                                              width: 50,
                                                              child: Center(
                                                                child: Image.asset(
                                                                  getImagen(tareaAlumnoArchivoUi.tipoRecurso),
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
                                                                  Text("${tareaAlumnoArchivoUi.nombre??""}", style: TextStyle(color: AppTheme.greyDarken3, fontSize: 12),),
                                                                  Padding(padding: EdgeInsets.all(2)),
                                                                  (tareaAlumnoArchivoUi.repositorio??false)?
                                                                  Text("${getDescripcion(tareaAlumnoArchivoUi.tipoRecurso)}", maxLines: 1, overflow: TextOverflow.ellipsis ,style: TextStyle(color: AppTheme.grey, fontSize: 10)):
                                                                  Text("${tareaAlumnoArchivoUi.url??""}", maxLines: 1, overflow: TextOverflow.ellipsis ,style: TextStyle(color: AppTheme.blue, fontSize: 10))
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top:  24, left: 24, right: 24),
                                          alignment: Alignment.centerLeft,
                                          child: Text("Comentarios privados (Sólo los ve le alumno)", style: TextStyle(color: AppTheme.colorPrimary, fontSize: 10),),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top:  4, left: 24, right: 24),
                                          child: Row(
                                            children: [
                                              CachedNetworkImage(
                                                placeholder: (context, url) => Container(
                                                  child: CircularProgressIndicator(),
                                                ),
                                                imageUrl: "https://cdn.domestika.org/c_fill,dpr_1.0,f_auto,h_1200,pg_1,t_base_params,w_1200/v1589759117/project-covers/000/721/921/721921-original.png?1589759117",
                                                errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                                imageBuilder: (context, imageProvider) =>
                                                    Container(
                                                        width: 40,
                                                        height: 40,
                                                        margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
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
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: 65,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: AppTheme.greyLighten3,
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                  border: Border.all(color: AppTheme.greyLighten2),
                                                                ),
                                                                padding: EdgeInsets.all(8),
                                                                child: Row(
                                                                  children: <Widget>[
                                                                    Expanded(
                                                                      child: TextField(
                                                                        maxLines: null,
                                                                        keyboardType: TextInputType.multiline,
                                                                        style: TextStyle(
                                                                          fontSize: 12,

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
                                                        // You enter here what you want the button to do once the user interacts with it
                                                      },
                                                      icon: Icon(
                                                        Icons.send,
                                                        color: AppTheme.greyDarken1,
                                                      ),
                                                      iconSize: 20.0,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top:  4, left: 24, right: 24, bottom: 16),
                                          child: Row(
                                            children: [
                                              CachedNetworkImage(
                                                placeholder: (context, url) => Container(
                                                  child: CircularProgressIndicator(),
                                                ),
                                                imageUrl: "https://cdn.domestika.org/c_fill,dpr_1.0,f_auto,h_1200,pg_1,t_base_params,w_1200/v1589759117/project-covers/000/721/921/721921-original.png?1589759117",
                                                errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                                imageBuilder: (context, imageProvider) =>
                                                    Container(
                                                        width: 40,
                                                        height: 40,
                                                        margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
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
                                                  padding: EdgeInsets.all(8),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: Container(
                                                                  padding: EdgeInsets.only(right: 8),
                                                                  child: Text("Velasquez Vilma Gregoria",
                                                                      style: TextStyle(
                                                                          fontSize: 10,
                                                                          fontWeight: FontWeight.w700
                                                                      ))
                                                              )
                                                          ),
                                                          Text("Vie 03 de set. - 13:37",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: AppTheme.greyDarken1
                                                              )
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(padding: EdgeInsets.all(2)),
                                                      Container(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text("Miss mil disculpas no cargo el video por eso lo enviamos al whassap", style: TextStyle(fontSize: 10),),
                                                      ),
                                                      Padding(padding: EdgeInsets.all(2)),
                                                      Container(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text("Responder",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: AppTheme.greyDarken1
                                                            )
                                                        ),
                                                      )

                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ):Container(padding: EdgeInsets.only(bottom: 8),)
                                  ],
                                );
                              },
                              itemCount: controller.tareaAlumnoUiList.length,
                            ),
                          ),
                      ],
                    );
                  });
            },
          );
        },
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
                    color: isExpandedSlidingSheet? AppTheme.white : AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey
                              .withOpacity(0.4 * topBarOpacity * (isExpandedSlidingSheet?0:1)),
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
                            right: 8,
                            top: 16 - 8.0 * topBarOpacity * (isExpandedSlidingSheet?0:1),
                            bottom: 12 - 8.0 * topBarOpacity * (isExpandedSlidingSheet?0:1)),
                        child: ControlledWidgetBuilder<PortalTareaController>(
                          builder: (context, controller) {
                            return Stack(
                              children: <Widget>[
                                Positioned(
                                    child:  IconButton(
                                      icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity * (isExpandedSlidingSheet?0:1),),
                                      onPressed: () {

                                        if(_sheetController.state?.isExpanded??false){
                                          _sheetController.collapse();

                                        } else{
                                          animationController.reverse().then<dynamic>((data) {
                                            if (!mounted) {
                                              return;
                                            }
                                            Navigator.of(this.context).pop();
                                          });
                                        }
                                        return;

                                      },
                                    )
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 52),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(AppIcon.ic_curso_tarea, height: 32 +  6 - 10 * topBarOpacity * (isExpandedSlidingSheet?0:1), width: 35 +  6 - 10 * topBarOpacity * (isExpandedSlidingSheet?0:1),),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8, top: 8),
                                        child: Text(
                                          'Tarea ${controller.tareaUi?.position??""}',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14 + 6 - 6 * topBarOpacity * (isExpandedSlidingSheet?0:1),
                                            letterSpacing: 0.8,
                                            color: AppTheme.darkerText,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  bottom: 0,
                                  right: 16,
                                  child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        //onTap: ()=> controller.onClicPrecision(),
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: isExpandedSlidingSheet? AppTheme.greyLighten3 : topBarOpacity==0 ?AppTheme.white : AppTheme.greyLighten3 ,
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text("Sin publicar",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      letterSpacing: 0.5,
                                                      color:AppTheme.greyDarken1,
                                                      fontSize: 5 + 6 - 1 * topBarOpacity * (isExpandedSlidingSheet?0:1),
                                                    )),
                                              ),
                                              Padding(padding: EdgeInsets.all(2),),
                                              Icon(Ionicons.earth ,color: AppTheme.greyDarken1, size: 9 + 6 - 2 * topBarOpacity * (isExpandedSlidingSheet?0:1), ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
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

  Widget getMainTab() {
    return  AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext? context, Widget? child) {
        return FadeTransition(
          opacity: topBarAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
            child: ControlledWidgetBuilder<PortalTareaController>(
                builder: (context, controller) {
                  return Container(
                      padding: EdgeInsets.only(
                          top: AppBar().preferredSize.height +
                              MediaQuery.of(context).padding.top +
                              0,
                          left: 24,
                          right: 24
                      ),
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        SliverList(
                            delegate: SliverChildListDelegate([
                              Container(
                                margin: EdgeInsets.only(top: 32),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      //onTap: ()=> controller.onClicPrecision(),
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(6)),
                                            color: AppTheme.white
                                        ),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Ionicons.earth ,color: AppTheme.greyDarken1, size: 9 + 6 - 2 * topBarOpacity * (isExpandedSlidingSheet?0:1), ),
                                            Padding(padding: EdgeInsets.all(2),),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text("Publicar Tarea",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
                                                    color:AppTheme.greyDarken1,
                                                    fontSize: 5 + 6 - 1 * topBarOpacity * (isExpandedSlidingSheet?0:1),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(6),),
                                    InkWell(
                                      //onTap: ()=> controller.onClicPrecision(),
                                      child: Container(
                                        padding: EdgeInsets.only(left: 16 , right: 16, top: 8, bottom: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(6)),
                                          color: HexColor(controller.cursosUi?.color2)
                                        ),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Ionicons.pencil ,color: AppTheme.white, size: 9 + 6 - 2 * topBarOpacity * (isExpandedSlidingSheet?0:1), ),
                                            Padding(padding: EdgeInsets.all(2),),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text("Modificar",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
                                                    color:AppTheme.white,
                                                    fontSize: 5 + 6 - 1 * topBarOpacity * (isExpandedSlidingSheet?0:1),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.all(6),),
                                    InkWell(
                                      //onTap: ()=> controller.onClicPrecision(),
                                      child: Container(
                                        padding: EdgeInsets.only(left: 16 , right: 16, top: 8, bottom: 8),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(6)),
                                            color: HexColor(controller.cursosUi?.color2)
                                        ),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Ionicons.trash ,color: AppTheme.white, size: 9 + 6 - 2 * topBarOpacity * (isExpandedSlidingSheet?0:1), ),
                                            Padding(padding: EdgeInsets.all(2),),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text("Eliminar",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5,
                                                    color:AppTheme.white,
                                                    fontSize: 5 + 6 - 1 * topBarOpacity * (isExpandedSlidingSheet?0:1),
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
                                margin: EdgeInsets.only(top: 32),
                                child: Text("Fecha de entrega: ${(controller.tareaUi?.fechaEntrega??"").replaceAll("\n", "")}", style: TextStyle(fontSize: 12),),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: Text("${controller.tareaUi?.titulo}", style: TextStyle(color: HexColor(controller.cursosUi?.color1) , fontSize: 18),),
                              ),
                              /*Container(
                                margin: EdgeInsets.only(top: 12),
                                child: Row(
                                  children: [
                                    Icon(Icons.message_outlined, size: 20,),
                                    Padding(padding: EdgeInsets.all(4)),
                                    Text("Agregar un comentario de la clase", style: TextStyle(fontSize: 14),)
                                  ],
                                ),
                              ),*/
                              Container(
                                margin: EdgeInsets.only(top: 16),
                                height: 1,
                                color: HexColor(controller.cursosUi?.color1),
                              ),
                              (controller.tareaUi?.instrucciones??"").isNotEmpty?
                              Container(
                                margin: EdgeInsets.only(top: 24),
                                child: Text("${controller.tareaUi?.instrucciones}",
                                  style: TextStyle(fontSize: 14, height: 1.5),),
                              ):Container(),
                              controller.tareaRecursoUiList.isNotEmpty?
                              Container(
                                margin: EdgeInsets.only(top: 24),
                                child: Text("Recursos",
                                  style: TextStyle(fontSize: 14, color: AppTheme.black, fontWeight: FontWeight.w500),),
                              ):Container(),
                              ListView.builder(
                                  padding: EdgeInsets.only(top: 8.0, bottom: 0),
                                  itemCount: controller.tareaRecursoUiList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index){
                                    TareaRecusoUi tareaRecursoUi = controller.tareaRecursoUiList[index];

                                    return Stack(
                                      children: [
                                        Center(
                                          child: InkWell(
                                            onTap: () async {
                                              await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(tareaRecursoUi.driveId), webview: false);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8), // use instead of BorderRadius.all(Radius.circular(20))
                                                  border:  Border.all(
                                                      width: 1,
                                                      color: HexColor(controller.cursosUi?.color1)
                                                  ),
                                                  color: AppTheme.white
                                              ),
                                              margin: EdgeInsets.only(bottom: 8),
                                              width: 450,
                                              height: 50,
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
                                                        Text("${tareaRecursoUi.titulo??""}", style: TextStyle(color: AppTheme.greyDarken3, fontSize: 12),),
                                                        Padding(padding: EdgeInsets.all(2)),
                                                        tareaRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO_YOUTUBE || tareaRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO_DRIVE || tareaRecursoUi.tipoRecurso == TipoRecursosUi.TIPO_VINCULO?
                                                        Text("${(tareaRecursoUi.url??"").isNotEmpty?tareaRecursoUi.url: tareaRecursoUi.descripcion}", maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(color: AppTheme.blue, fontSize: 10)):
                                                        Text("${(tareaRecursoUi.descripcion??"").isNotEmpty?tareaRecursoUi.descripcion: getDescripcion(tareaRecursoUi.tipoRecurso)}", maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(color: AppTheme.grey, fontSize: 10)),
                                                      ],
                                                    ),
                                                  )
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
                               padding: EdgeInsets.only(top: 8),
                               child:  Stack(
                                 children: [
                                   Center(
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
                                               fontSize: 14,
                                               fontWeight: FontWeight.w500,
                                               color: HexColor(controller.cursosUi?.color1).withOpacity(0.8)
                                           ),),
                                         ),
                                       ),
                                     ),
                                   )
                                 ],
                               ),
                             ),
                              controller.tareaRecursoUiList.isNotEmpty?
                              Container(
                                margin: EdgeInsets.only(top: 32),
                                height: 1,
                                color: AppTheme.greyLighten1,
                              ):Container(),
                              Container(
                                margin: EdgeInsets.only(top: 16),
                                child: Text("Comentario de clase",
                                  style: TextStyle(fontSize: 14, color: AppTheme.black, fontWeight: FontWeight.w500),),
                              ),
                              Container(
                                margin: EdgeInsets.only(top:  4),
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(),
                                      ),
                                      imageUrl: "https://cdn.domestika.org/c_fill,dpr_1.0,f_auto,h_1200,pg_1,t_base_params,w_1200/v1589759117/project-covers/000/721/921/721921-original.png?1589759117",
                                      errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                              width: 40,
                                              height: 40,
                                              margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
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
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 65,
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: AppTheme.greyLighten3,
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        border: Border.all(color: AppTheme.greyLighten2),
                                                      ),
                                                      padding: EdgeInsets.all(8),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: TextField(
                                                              maxLines: null,
                                                              keyboardType: TextInputType.multiline,
                                                              style: TextStyle(
                                                                fontSize: 12,

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
                                              // You enter here what you want the button to do once the user interacts with it
                                            },
                                            icon: Icon(
                                              Icons.send,
                                              color: AppTheme.greyDarken1,
                                            ),
                                            iconSize: 20.0,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top:  4, bottom: 16),
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(),
                                      ),
                                      imageUrl: "https://cdn.domestika.org/c_fill,dpr_1.0,f_auto,h_1200,pg_1,t_base_params,w_1200/v1589759117/project-covers/000/721/921/721921-original.png?1589759117",
                                      errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                              width: 40,
                                              height: 40,
                                              margin: EdgeInsets.only(right: 16, left: 0, top: 0, bottom: 8),
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
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: Container(
                                                        padding: EdgeInsets.only(right: 8),
                                                        child: Text("Velasquez Vilma Gregoria",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w700
                                                            ))
                                                    )
                                                ),
                                                Text("Vie 03 de set. - 13:37",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: AppTheme.greyDarken1
                                                    )
                                                ),
                                              ],
                                            ),
                                            Padding(padding: EdgeInsets.all(2)),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text("Miss mil disculpas no cargo el video por eso lo enviamos al whassap", style: TextStyle(fontSize: 10),),
                                            ),
                                            Padding(padding: EdgeInsets.all(2)),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text("Responder",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: AppTheme.greyDarken1
                                                  )
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 200))
                            ])
                        ),
                      ],
                    ),
                  );
                }),
          ),
        );
      },
    );
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
    }
  }


}