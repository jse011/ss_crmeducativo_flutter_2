import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/grupos/lista/lista_grupos_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_grupo_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/lista_grupo_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';

class ListaGruposView extends View{
  CursosUi? cursosUi;
  Function(ListaGrupoUi listaGruposUi)? onCallback;

  ListaGruposView(this.cursosUi, {this.onCallback});

  @override
  ListaGruposViewState createState() => ListaGruposViewState(this.cursosUi);

}

class ListaGruposViewState extends ViewState<ListaGruposView, ListaGruposController> with TickerProviderStateMixin{
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  PageController _pageController = PageController();

  GlobalKey globalKey = GlobalKey();
  ListaGruposViewState(CursosUi? cursosUi) : super(ListaGruposController(cursosUi, MoorGrupoRepository(), MoorConfiguracionRepository(), DeviceHttpDatosRepositorio()));

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
  Widget get view => ControlledWidgetBuilder<ListaGruposController>(
    builder: (context, controller) {

      return Scaffold(
        key: globalKey,
        backgroundColor: AppTheme.background,
        extendBody: true,
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
            if(widget.onCallback == null)
            getAppBarUI(),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(100),
                    topLeft: Radius.circular(100),
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, spreadRadius: 0, blurRadius: 10),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.0),
                    topRight: Radius.circular(100.0),
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100)),
                child: BottomNavigationBar(
                  selectedItemColor: Theme.of(context).primaryColor,
                  unselectedItemColor: Colors.grey[500],
                  selectedLabelStyle: TextStyle( fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: TextStyle( fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w700),
                  items: [
                    BottomNavigationBarItem(
                        icon: Container(),
                        //title: Text('Rúbrica', style: TextStyle( fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w700),)
                        label: 'Mis listas'
                    ),
                    BottomNavigationBarItem(
                        icon: Container(),
                        label: 'Otras listas'
                      //title: Text('Registro', style: TextStyle( fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w700))
                    ),
                  ],
                  currentIndex: controller.seletedItem,
                  onTap: (index) {
                    controller.onChangeTab(index);
                    _pageController.jumpToPage(controller.seletedItem);
                  },
                ),
              )),
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
                child: ControlledWidgetBuilder<ListaGruposController>(
                  builder: (context, controller) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                            child:  IconButton(
                              icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                              onPressed: () {
                                Navigator.of(this.context).pop();
                              },
                            )
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppIcon.ic_curso_grupo, height: 35 +  6 - 10 * topBarOpacity, width: 35 +  6 - 10 * topBarOpacity,),
                              Padding(
                                padding: EdgeInsets.only(left: 12, top: 8),
                                child: Text(
                                  controller.seletedItem!=1?"Mis listas de Grupos":'Otras listas de Grupos',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontTTNorms,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 0.8,
                                    color: AppTheme.darkerText,
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
        )
      ],
    );
  }

  Widget getMainTab() {
    return ControlledWidgetBuilder<ListaGruposController>(
        builder: (context, controller) {
          return  Container(
            padding: EdgeInsets.only(
              top: (widget.onCallback == null)?AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  0:0,
              left: 0,//24,
              right: 0,//48
            ),
            child: PageView(
              //scrollDirection: Axis.vertical,
              children: [
                Stack(
                  children: [
                    if(controller.misGrupoUiList.isEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
                          ),
                          Padding(padding: EdgeInsets.all(4)),
                          Center(
                            child: Text("Lista vacía${!(controller.conexion)?", revice su conexión a internet":""}", style: TextStyle(color: AppTheme.grey, fontStyle: FontStyle.italic, fontSize: 12),),
                          )
                        ],
                      ),
                    CustomScrollView(
                      controller: scrollController,
                      slivers: <Widget>[
                        (!controller.conexion && !controller.progress)?
                        SliverList(
                            delegate: SliverChildListDelegate([
                              Container(
                                padding: EdgeInsets.only(
                                  left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                  right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                  top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                  bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                          constraints: BoxConstraints(
                                            //minWidth: 200.0,
                                            maxWidth: 600.0,
                                          ),
                                          height: 45,
                                          margin: EdgeInsets.only(
                                            top: ColumnCountProvider.aspectRatioForWidthTarea(context, 24),
                                            left: ColumnCountProvider.aspectRatioForWidthTarea(context, 20),
                                            right: ColumnCountProvider.aspectRatioForWidthTarea(context, 20),
                                          ),
                                          decoration: BoxDecoration(
                                              color: AppTheme.redLighten5,
                                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthTarea(context, 8)))
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  width: ColumnCountProvider.aspectRatioForWidthTarea(context, 24),
                                                  height: ColumnCountProvider.aspectRatioForWidthTarea(context, 24),
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color:  Colors.red,
                                                    ),
                                                  )
                                              ),
                                              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTarea(context, 4))),
                                              Container(
                                                padding: EdgeInsets.all(8),
                                                child: Text('Sin conexión',
                                                    style: TextStyle(
                                                        color:  Colors.red,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 14,
                                                        fontFamily: AppTheme.fontTTNorms
                                                    )
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ])
                        ):
                        SliverList(
                            delegate: SliverChildListDelegate([
                              Container(
                                padding: EdgeInsets.only(
                                  top: ColumnCountProvider.aspectRatioForWidthGrupos(context,  widget.onCallback == null?24:0),
                                ),
                              ),
                            ])
                        ),
                        SliverList(
                            delegate: SliverChildListDelegate([
                              controller.cursosUi!=null?
                              Container(
                                padding: EdgeInsets.only(
                                  left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                  right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                  top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                  bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              /*Text((controller.cursosUi?.nombreCurso??""),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                                color: AppTheme.darkText,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: AppTheme.fontTTNorms
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 4))
                                          ),*/
                                              if(widget.onCallback == null)
                                                Text("${controller.cursosUi?.gradoSeccion??""}",
                                                    style: TextStyle(
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                                        color: AppTheme.darkText,
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: AppTheme.fontTTNorms
                                                    )
                                                ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ):Container(
                                  padding: EdgeInsets.only(
                                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                  )
                              ),
                            ])
                        ),
                        SliverPadding(
                          padding: EdgeInsets.only(
                            top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                            left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                            right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                            bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                          ),
                          sliver: SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: ColumnCountProvider.columnsForWidthListaGrupos(context),
                              mainAxisSpacing: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                              crossAxisSpacing: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                            ),
                            delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index){
                                  dynamic o = controller.misGrupoUiList[index];

                                  if(o is String){
                                    return InkWell(
                                      onTap: () async{
                                        await _showCrearGrupo(context, controller);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: HexColor(controller.cursosUi?.color2),
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
                                                Icon(Ionicons.add, color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthGrupos(context, 40),),
                                                Padding(padding: EdgeInsets.only(top: 4)),
                                                Text("Crear una lista de grupos",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
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
                                    );
                                  }else {
                                    ListaGrupoUi listaGrupoUi = o;
                                    return  InkWell(
                                      onTap: () async{
                                        if(widget.onCallback == null){
                                          await AppRouter.showTiposCrearGruposView(context, controller.cursosUi, listaGrupoUi);
                                          controller.cambiosGrupos();
                                        }else{
                                          widget.onCallback?.call(listaGrupoUi);
                                          Navigator.of(this.context).pop();
                                        }

                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppTheme.white,
                                          borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 16))),
                                          /*image: DecorationImage(
                                        image: AssetImage(AppImagen.imagen_lista_grupos),
                                        fit: BoxFit.cover,
                                      )*/
                                        ),
                                        padding: EdgeInsets.only(
                                          top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                          bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                                  right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18)
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                      child: Text("${(listaGrupoUi.nombre??"").isNotEmpty?listaGrupoUi.nombre:" Sin nombre"}",
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                                            fontFamily: AppTheme.fontTTNorms,
                                                            fontWeight: FontWeight.w700,
                                                            color: HexColor(listaGrupoUi.color1)
                                                        ),
                                                      )
                                                  ),
                                                  Text("${listaGrupoUi.grupoUiList?.length??0}",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                                        fontFamily: AppTheme.fontTTNorms,
                                                        fontWeight: FontWeight.w800,
                                                        color: HexColor(listaGrupoUi.color1)
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                    left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18)
                                                ),
                                                child: ListView.builder(
                                                  physics: NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.only(
                                                      top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16)
                                                  ),
                                                  itemBuilder: (context, index) {
                                                    GrupoUi grupoUi = listaGrupoUi.grupoUiList![index];
                                                    return Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 6)
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Icon(Icons.group,
                                                            size: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                                            color: HexColor(listaGrupoUi.color1),
                                                          ),
                                                          Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                                          Expanded(
                                                              child: Text("${(grupoUi.nombre??"").isNotEmpty?grupoUi.nombre:"Grupo ${grupoUi.posicion??0}"}",
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              )
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  itemCount: listaGrupoUi.grupoUiList?.length??0,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18)
                                                ),
                                                child:  Row(
                                                  children: [
                                                    Expanded(child: Container(
                                                      decoration: BoxDecoration(
                                                        color: HexColor(listaGrupoUi.color1),
                                                        borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                                      ),
                                                      padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 6)),
                                                      child: Center(
                                                          child: Text("${listaGrupoUi.nombreCurso??""}",
                                                            style: TextStyle(
                                                                fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                                fontFamily: AppTheme.fontTTNorms,
                                                                fontWeight: FontWeight.w700,
                                                                color: AppTheme.white
                                                            ),
                                                          )
                                                      ),
                                                    ),),
                                                    if(widget.onCallback != null)
                                                      InkWell(
                                                        onTap: () async{
                                                          await AppRouter.showTiposCrearGruposView(context, controller.cursosUi, listaGrupoUi);
                                                          controller.cambiosGrupos();
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)
                                                          ),
                                                          decoration: BoxDecoration(
                                                            color: HexColor(listaGrupoUi.color1),
                                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                                          ),
                                                          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                                          child: Icon(Icons.edit, color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),),
                                                        ),
                                                      ),
                                                  ],
                                                )
                                            ),

                                          ],
                                        ),
                                      ),
                                    );
                                  }


                                },
                                childCount: controller.misGrupoUiList.length
                            ),
                          ),
                        ),
                        SliverList(
                            delegate: SliverChildListDelegate(
                                [
                                  Container(
                                    height: 100,
                                  )
                                ])
                        ),
                      ],
                    ),
                    if(widget.onCallback != null)
                      Container(
                        color: AppTheme.colorLine,
                        height: 1,
                      ),
                  ],
                ),
                //progress(tabRubroSesiones3(controller, count)),
                Stack(
                  children: [
                    if(controller.otrosGrupoUiList.isEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
                          ),
                          Padding(padding: EdgeInsets.all(4)),
                          Center(
                            child: Text("Ningún otro docente creo una lista\n de grupos para este salón${!(controller.conexion)?", revice su conexión a internet":""}",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppTheme.grey, fontSize: 12, fontFamily: AppTheme.fontTTNorms),),
                          )
                        ],
                      ),
                    CustomScrollView(
                      controller: scrollController,
                      slivers: <Widget>[
                        (!controller.conexion && !controller.progress)?
                        SliverList(
                            delegate: SliverChildListDelegate([
                              Container(
                                padding: EdgeInsets.only(
                                  left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                  right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                  top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                  bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                          constraints: BoxConstraints(
                                            //minWidth: 200.0,
                                            maxWidth: 600.0,
                                          ),
                                          height: 45,
                                          margin: EdgeInsets.only(
                                            top: ColumnCountProvider.aspectRatioForWidthTarea(context, 24),
                                            left: ColumnCountProvider.aspectRatioForWidthTarea(context, 20),
                                            right: ColumnCountProvider.aspectRatioForWidthTarea(context, 20),
                                          ),
                                          decoration: BoxDecoration(
                                              color: AppTheme.redLighten5,
                                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthTarea(context, 8)))
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  width: ColumnCountProvider.aspectRatioForWidthTarea(context, 24),
                                                  height: ColumnCountProvider.aspectRatioForWidthTarea(context, 24),
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color:  Colors.red,
                                                    ),
                                                  )
                                              ),
                                              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTarea(context, 4))),
                                              Container(
                                                padding: EdgeInsets.all(8),
                                                child: Text('Sin conexión',
                                                    style: TextStyle(
                                                        color:  Colors.red,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 14,
                                                        fontFamily: AppTheme.fontTTNorms
                                                    )
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ])
                        ):
                        SliverList(
                            delegate: SliverChildListDelegate([
                              Container(
                                padding: EdgeInsets.only(
                                  top: ColumnCountProvider.aspectRatioForWidthGrupos(context,  widget.onCallback == null?24:0),
                                ),
                              ),
                            ])
                        ),
                        SliverList(
                            delegate: SliverChildListDelegate([
                              controller.cursosUi!=null?
                              Container(
                                padding: EdgeInsets.only(
                                  left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                  right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                  top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                                  bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              /*Text((controller.cursosUi?.nombreCurso??""),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                                color: AppTheme.darkText,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: AppTheme.fontTTNorms
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 4))
                                          ),*/
                                              if(widget.onCallback == null)
                                                Text("${controller.cursosUi?.gradoSeccion??""}",
                                                    style: TextStyle(
                                                        fontSize: ColumnCountProvider.aspectRatioForWidthListaCurso(context, 20),
                                                        color: AppTheme.darkText,
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: AppTheme.fontTTNorms
                                                    )
                                                ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ):Container(
                                  padding: EdgeInsets.only(
                                    top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                                  )
                              ),
                            ])
                        ),
                        SliverPadding(
                          padding: EdgeInsets.only(
                            top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                            left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                            right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 32),
                            bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 0),
                          ),
                          sliver: SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: ColumnCountProvider.columnsForWidthListaGrupos(context),
                              mainAxisSpacing: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                              crossAxisSpacing: ColumnCountProvider.aspectRatioForWidthGrupos(context, 24),
                            ),
                            delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index){
                                      ListaGrupoUi listaGrupoUi = controller.otrosGrupoUiList[index];

                                      return  InkWell(
                                        onTap: () async{
                                          if(widget.onCallback == null){
                                            await AppRouter.showTiposCrearGruposView(context, controller.cursosUi, listaGrupoUi);
                                            controller.cambiosGrupos();
                                          }else{
                                            widget.onCallback?.call(listaGrupoUi);
                                            Navigator.of(this.context).pop();
                                          }

                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.white,
                                            borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 16))),
                                            /*image: DecorationImage(
                                        image: AssetImage(AppImagen.imagen_lista_grupos),
                                        fit: BoxFit.cover,
                                      )*/
                                          ),
                                          padding: EdgeInsets.only(
                                            top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                            bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                                    right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18)
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        child: Text("${(listaGrupoUi.nombre??"").isNotEmpty?listaGrupoUi.nombre:" Sin nombre"}",
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                                              fontFamily: AppTheme.fontTTNorms,
                                                              fontWeight: FontWeight.w700,
                                                              color: HexColor(listaGrupoUi.color1)
                                                          ),
                                                        )
                                                    ),
                                                    Text("${listaGrupoUi.grupoUiList?.length??0}",
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                                          fontFamily: AppTheme.fontTTNorms,
                                                          fontWeight: FontWeight.w800,
                                                          color: HexColor(listaGrupoUi.color1)
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                                      right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18)
                                                  ),
                                                  child: ListView.builder(
                                                    physics: NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.only(
                                                        top: ColumnCountProvider.aspectRatioForWidthGrupos(context, 16)
                                                    ),
                                                    itemBuilder: (context, index) {
                                                      GrupoUi grupoUi = listaGrupoUi.grupoUiList![index];
                                                      return Container(
                                                        padding: EdgeInsets.only(
                                                            bottom: ColumnCountProvider.aspectRatioForWidthGrupos(context, 6)
                                                        ),
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Icon(Icons.group,
                                                              size: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),
                                                              color: HexColor(listaGrupoUi.color1),
                                                            ),
                                                            Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                                            Expanded(
                                                                child: Text("${(grupoUi.nombre??"").isNotEmpty?grupoUi.nombre:"Grupo ${grupoUi.posicion??0}"}",
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                    fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                                    fontFamily: AppTheme.fontTTNorms,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                )
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    itemCount: listaGrupoUi.grupoUiList?.length??0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18),
                                                      right: ColumnCountProvider.aspectRatioForWidthGrupos(context, 18)
                                                  ),
                                                  child:  Row(
                                                    children: [
                                                      Expanded(child: Container(
                                                        decoration: BoxDecoration(
                                                          color: HexColor(listaGrupoUi.color1),
                                                          borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                                        ),
                                                        padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 6)),
                                                        child: Center(
                                                            child: Text("${listaGrupoUi.nombreCurso??""}",
                                                              style: TextStyle(
                                                                  fontSize: ColumnCountProvider.aspectRatioForWidthGrupos(context, 12),
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  fontWeight: FontWeight.w700,
                                                                  color: AppTheme.white
                                                              ),
                                                            )
                                                        ),
                                                      ),),
                                                      if(widget.onCallback != null)
                                                        InkWell(
                                                          onTap: () async{
                                                            await AppRouter.showTiposCrearGruposView(context, controller.cursosUi, listaGrupoUi);
                                                            controller.cambiosGrupos();
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.only(
                                                                left: ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)
                                                            ),
                                                            decoration: BoxDecoration(
                                                              color: HexColor(listaGrupoUi.color1),
                                                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthGrupos(context, 4))),
                                                            ),
                                                            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthGrupos(context, 8)),
                                                            child: Icon(Icons.edit, color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthGrupos(context, 14),),
                                                          ),
                                                        ),
                                                    ],
                                                  )
                                              ),

                                            ],
                                          ),
                                        ),
                                      );


                                },
                                childCount: controller.otrosGrupoUiList.length
                            ),
                          ),
                        ),
                        SliverList(
                            delegate: SliverChildListDelegate(
                                [
                                  Container(
                                    height: 100,
                                  )
                                ])
                        ),
                      ],
                    ),
                    if(widget.onCallback != null)
                      Container(
                        color: AppTheme.colorLine,
                        height: 1,
                      ),
                  ],
                ),
              ],
              onPageChanged: (index) {
                topBarOpacity = 0;
                controller.onChangeTab(index);
              },
              controller: _pageController,
            ),
          );
        });
  }

  Future<bool?> _showCrearGrupo(BuildContext context, ListaGruposController controller) async {
    return await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return StatefulBuilder(
              builder: (BuildContext context, setState) {
                return ArsProgressWidget(
                    blur: 2,
                    backgroundColor: Color(0x33000000),
                    animationDuration: Duration(milliseconds: 500),
                    dismissable: true,
                    onDismiss: (tipo){
                      Navigator.of(context).pop(true);
                    },
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
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(AppIcon.ic_curso_grupo, height: 35 , width: 35,)
                                    ],
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(0)),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(padding: EdgeInsets.all(8),
                                          child: Text("Crear una lista de grupos", style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: AppTheme.fontTTNormsMedium
                                          ),),
                                        ),
                                        Padding(padding: EdgeInsets.all(4),),
                                      ],
                                    )
                                )
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(4)),
                            Flexible(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.only(
                                      left: 8,
                                      right: 8
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(padding: EdgeInsets.all(0),),
                                      Row(
                                        children: [
                                          Expanded(child: ElevatedButton(
                                            onPressed: () async {
                                              ListaGrupoUi grupoUi = ListaGrupoUi();
                                              grupoUi.modoAletorio = true;
                                              grupoUi.editar = true;
                                               await AppRouter.showTiposCrearGruposView(context, controller.cursosUi, grupoUi);
                                              controller.cambiosGrupos();
                                              Navigator.of(context).pop(true);

                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: HexColor(controller.cursosUi?.color2),
                                              onPrimary: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            child: Padding(padding: EdgeInsets.all(4), child: Text( 'Crear de manera aleatoria'.toUpperCase()),),
                                          )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(child: ElevatedButton(
                                            onPressed: () async {
                                              ListaGrupoUi grupoUi = ListaGrupoUi();
                                              grupoUi.modoAletorio = false;
                                              grupoUi.editar = true;
                                              await AppRouter.showTiposCrearGruposView(context, controller.cursosUi, grupoUi);
                                             controller.cambiosGrupos();
                                              Navigator.of(context).pop(true);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: HexColor(controller.cursosUi?.color2),
                                              onPrimary: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            child: Padding(padding: EdgeInsets.all(4), child: Text( 'Crear manualmente'.toUpperCase()),),
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                            ),
                            Padding(padding: EdgeInsets.all(8)),
                            Row(
                              children: [
                                Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text('Cancelar'),
                                      style: OutlinedButton.styleFrom(
                                        primary: AppTheme.colorSesion,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                );
              });
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
    _pageController.dispose();
    super.dispose();
  }
}