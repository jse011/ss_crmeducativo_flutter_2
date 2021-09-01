import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_not_expanded_custom.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/capacidad/evaluacion_capacidad_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_peso_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';

class EvaluacionCapacidadView extends View{
  EvaluacionCapacidadUi? evaluacionCapacidadUi;
  CursosUi? cursosUi;

  EvaluacionCapacidadView(this.evaluacionCapacidadUi, this.cursosUi);

  @override
  _EvaluacionCapacidadViewState createState() => _EvaluacionCapacidadViewState(evaluacionCapacidadUi, cursosUi);

}

class _EvaluacionCapacidadViewState extends ViewState<EvaluacionCapacidadView, EvaluacionCapacidadController> with TickerProviderStateMixin{
  ScrollControllers crollControllers = ScrollControllers();

  _EvaluacionCapacidadViewState(evaluacionCapacidadUi, cursosUi) : super(EvaluacionCapacidadController(evaluacionCapacidadUi, cursosUi, MoorRubroRepository()));
  late Animation<double> topBarAnimation;
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  late AnimationController animationController;
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

    Future.delayed(const Duration(milliseconds: 200), () {
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
  Widget get view => Container(
    color: AppTheme.white,
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          getMainTab(),
          getAppBarUI(),
        ],
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
                            right: 8,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child:   ControlledWidgetBuilder<EvaluacionCapacidadController>(
                          builder: (context, controller) {
                            return Stack(
                              children: <Widget>[
                                Positioned(
                                    child:  IconButton(
                                      icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                                      onPressed: () {
                                        animationController.reverse().then<dynamic>((data) {
                                          if (!mounted) {
                                            return;
                                          }
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    )
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 32),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(AppIcon.ic_curso_evaluacion, height: 35 +  6 - 8 * topBarOpacity, width: 35 +  6 - 8 * topBarOpacity,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 12, top: 8),
                                        child: Text(
                                          'Evaluación',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16 + 6 - 6 * topBarOpacity,
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
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget getMainTab() {
    return ControlledWidgetBuilder<EvaluacionCapacidadController>(
        builder: (context, controller) {
          return Container(
            padding: EdgeInsets.only(
                top: AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top +
                    0,
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverPadding(
                    padding: EdgeInsets.only(left: 32, right: 32),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Padding(padding: EdgeInsets.only( top: 32)),
                            Text(controller.evaluacionCapacidadUi.capacidadUi?.nombre??"",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.colorAccent,
                                  fontFamily: AppTheme.fontTTNorms
                              ),
                            ),
                            Padding(padding: EdgeInsets.only( top: 16)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 75,
                                  width: 75,
                                  margin: EdgeInsets.only(right: 4),
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: HexColor("#EDEDED"),
                                  ),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    imageUrl: controller.evaluacionCapacidadUi.personaUi?.foto??"",
                                    errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(35)),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 24, right: 0, top: 0),
                                    child:  TextFormField(
                                      initialValue: controller.evaluacionCapacidadUi.personaUi?.nombreCompleto??"",
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context).textTheme.caption?.copyWith(
                                        fontFamily: AppTheme.fontName,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        labelText: "Alumno",
                                        labelStyle: TextStyle(
                                            color:  AppTheme.colorPrimary,
                                            fontFamily: AppTheme.fontTTNormsMedium
                                        ),
                                        contentPadding: EdgeInsets.all(15.0),
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
                                      },
                                      onSaved: (str) {
                                        //  To do
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(padding: EdgeInsets.only( top: 16)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                FDottedLine(
                                  color: HexColor("#ABABAB"),
                                  strokeWidth: 1.0,
                                  dottedLength: 3.0,
                                  space: 2.0,
                                  corner: FDottedLineCorner.all(45.0),
                                  /// add widget
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    color: HexColor("#EDEDED"),
                                    alignment: Alignment.center,
                                    child:  Container(
                                      height: 50,
                                      width: 50,
                                      child: _getTipoNota(controller.evaluacionCapacidadUi.valorTipoNotaUi, controller.evaluacionCapacidadUi.nota),
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only( left: 16)),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
                                    child:  TextFormField(
                                      initialValue: "Logro provisto",
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context).textTheme.caption?.copyWith(
                                        fontFamily: AppTheme.fontName,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        labelText: "Logro",
                                        labelStyle: TextStyle(
                                            color:  AppTheme.colorPrimary,
                                            fontFamily: AppTheme.fontTTNormsMedium
                                        ),
                                        contentPadding: EdgeInsets.all(15.0),
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
                                        hintText: "",
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusColor: AppTheme.colorAccent,
                                      ),
                                      onChanged: (str) {
                                      },
                                      onSaved: (str) {
                                        //  To do
                                      },
                                    ),
                                  ),
                                  flex: 7,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 24, right: 0, top: 0),
                                    child:  TextFormField(
                                      initialValue: "100%",
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context).textTheme.caption?.copyWith(
                                        fontFamily: AppTheme.fontName,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        labelText: "Desempeño",
                                        labelStyle: TextStyle(
                                            color:  AppTheme.colorPrimary,
                                            fontFamily: AppTheme.fontTTNormsMedium
                                        ),
                                        contentPadding: EdgeInsets.all(15.0),
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
                                        hintText: "",
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          borderSide: BorderSide(
                                            color: AppTheme.colorPrimary,
                                          ),
                                        ),
                                        focusColor: AppTheme.colorAccent,
                                      ),
                                      onChanged: (str) {
                                      },
                                      onSaved: (str) {
                                        //  To do
                                      },
                                    ),
                                  ),
                                  flex: 6,
                                ),
                              ],
                            )
                          ],
                        )
                    ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(left: 32, right: 32, top: 16),
                  sliver:  SliverToBoxAdapter(
                    child: showTableTipoNota(controller),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(padding: EdgeInsets.only(bottom: 64))
                    ])
                )
              ],
            ),
          );
        });
  }

  Widget showTableTipoNota(EvaluacionCapacidadController controller) {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            padding: EdgeInsets.only(top: 64),
           child:  Center(
               child: CircularProgressIndicator()
           ),
          );
        } else {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.colorPrimary.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: SingleChildScrollView(
                  child: StickyHeadersTableNotExpandedCustom(
                      cellDimensions: CellDimensions.variableColumnWidth(
                          stickyLegendHeight:45,
                          stickyLegendWidth: 20,
                          contentCellHeight: 55,
                          columnWidths: controller.tableTipoNotacolumnWidths
                      ),
                      //cellAlignments: CellAlignments.,
                      scrollControllers: crollControllers,
                      columnsLength: controller.tableTipoNotaColumns.length,
                      rowsLength: controller.rubricaEvaluacionList.length,
                      columnsTitleBuilder: (i) {
                        //#region columnsTitleBuilder
                        var obj = controller.tableTipoNotaColumns[i];
                        if(obj is String){
                          return Container(
                              padding: EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  Text(obj, style: TextStyle(color: AppTheme.white),),
                                ],
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: AppTheme.colorPrimary.withOpacity(0.5)),
                                ),
                                color: AppTheme.colorPrimary,
                              )
                          );
                        }else if(obj is bool){
                          return Container(
                              child: Center(
                                child:  SvgPicture.asset(AppIcon.ic_nivel_logro, width: 30, height: 30,),
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: AppTheme.colorPrimary.withOpacity(0.5))
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
                                            color: AppTheme.white,
                                          ),
                                        ),
                                        Text((obj.valorNumerico??0).toStringAsFixed(1),
                                          style: TextStyle(fontFamily: AppTheme.fontTTNormsMedium,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.white
                                          ),),
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(color: AppTheme.colorPrimary.withOpacity(0.5))
                                    ),
                                    color: getColor(i),
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
                                        right: BorderSide(color: AppTheme.colorPrimary.withOpacity(0.5))
                                    ),
                                  )
                              );
                            default:
                              return Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(color: AppTheme.colorPrimary.withOpacity(0.5))
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
                              top: BorderSide(color: AppTheme.colorPrimary.withOpacity(0.5)),
                              right: BorderSide(color: AppTheme.colorPrimary.withOpacity(0.5)),
                            ),
                          )
                      ),
                      contentCellBuilder: (i, j){
                        dynamic o = controller.tableTipoNotaCells[j][i];
                        if(o is RubricaEvaluacionUi){
                          return InkWell(
                            onTap: (){

                            },
                            child: Container(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8, right: 8),
                                  child: Center(
                                    child: Text((o.titulo??""), maxLines: 3, overflow: TextOverflow.ellipsis ,style: TextStyle(fontSize: 12),),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: AppTheme.colorPrimary.withOpacity(0.5)),
                                    right: BorderSide(color: AppTheme.colorPrimary.withOpacity(0.5)),
                                  ),
                                )
                            ),
                          );
                        }else if(o is RubricaPeso){
                          return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: (){
                                      switch(controller.evaluacionCapacidadUi.capacidadUi?.competenciaUi?.tipoCompetenciaUi??TipoCompetenciaUi.BASE){
                                        case TipoCompetenciaUi.BASE:
                                          return CachedNetworkImage(
                                            height: 18,
                                            width: 18,
                                            imageUrl: controller.evaluacionCapacidadUi.capacidadUi?.competenciaUi?.url??"",
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
                                  top: BorderSide(color: AppTheme.colorPrimary.withOpacity(0.5)),
                                  right: BorderSide(color: AppTheme.colorPrimary.withOpacity(0.5)),
                                ),
                              )
                          );
                        }else if(o is EvaluacionRubricaValorTipoNotaUi){
                          return Container(
                              child: Center(
                                child: Text("✓", style: TextStyle(color: AppTheme.white),),
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: AppTheme.colorPrimary.withOpacity(0.5)),
                                  right: BorderSide(color: AppTheme.colorPrimary.withOpacity(0.5)),
                                ),
                                color: (o.toggle??false)?getColor2(i):null
                              )
                          );
                        } else{
                          return Container(
                              child: Center(
                                child: Text(""),
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: AppTheme.colorPrimary.withOpacity(0.5)),
                                  right: BorderSide(color: AppTheme.colorPrimary.withOpacity(0.5)),
                                ),
                              )
                          );
                        }
                      },
                      legendCell: Stack(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: AppTheme.colorPrimary,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(7))
                              )
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 2),
                              child: Center(
                                child: Text('N°', style: TextStyle(color: AppTheme.white, fontSize: 12),),
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: AppTheme.colorPrimaryDark),
                                ),
                              )
                          ),

                        ],
                      )
                  ),
                )
            ),
          );
        }
      },
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
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

  Color getColor2(int position){
    switch (position){
      case 1:
        return HexColor("#64B5F6");
      case 4:
        return HexColor("#E57373");
      case 3:
        return HexColor("#FFB74D");
      case 2:
        return HexColor("#81C784");
      default:
        return HexColor("#e0e0e0");

    }
  }

  Widget? _getTipoNota(ValorTipoNotaUi? valorTipoNotaUi, double? nota) {

    switch(valorTipoNotaUi?.tipoNotaUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO){
      case TipoNotaTiposUi.SELECTOR_VALORES:
        Color color;
        if (("B" == (valorTipoNotaUi?.titulo??"") || "C" == (valorTipoNotaUi?.titulo??""))) {
          color = AppTheme.redDarken4;
        }else if (("AD" == (valorTipoNotaUi?.titulo??"")) || "A" == (valorTipoNotaUi?.titulo??"")) {
          color = AppTheme.blueDarken4;
        }else {
          color = AppTheme.black;
        }
        return Center(
          child: Text(valorTipoNotaUi?.titulo??"",
              style: TextStyle(
                fontFamily: AppTheme.fontTTNormsMedium,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              )),
        );
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        return Container(
          child:  CachedNetworkImage(
            imageUrl: valorTipoNotaUi?.icono??"",
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        );
      case TipoNotaTiposUi.VALOR_ASISTENCIA:
      case TipoNotaTiposUi.VALOR_NUMERICO:
      case TipoNotaTiposUi.SELECTOR_NUMERICO:
        Color color;
        if ((nota??0) < 10.5) {
          color = AppTheme.redDarken4;
        }else if ( (nota??0) >= 10.5) {
          color = AppTheme.blueDarken4;
        }else {
          color = AppTheme.black;
        }

        return Center(
          child: Text("${(nota??0).toStringAsFixed(1)}", style: TextStyle(
            fontFamily: AppTheme.fontTTNormsMedium,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),),
        );
    }
  }
}