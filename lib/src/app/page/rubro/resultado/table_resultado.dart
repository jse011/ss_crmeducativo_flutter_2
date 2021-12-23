import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_v2.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/matriz_resultado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/resultado_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/resultado_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/resultado_evaluacion.dart';
import 'package:collection/collection.dart';

class TableResultado extends StatefulWidget{
  CalendarioPeriodoUI? calendarioPeriodoUI;
  List<dynamic> rows = [];
  List<dynamic> columns = [];
  List<List<dynamic>> cells = [];
  bool? datosOffline;
  CursosUi? cursosUi;
  bool? precision;
  ScrollControllers? scrollControllers;
  double? scrollOffsetX;
  double? scrollOffsetY;
  late Function(double x, double y)? onEndScrolling;

  TableResultado({this.calendarioPeriodoUI, required this.rows, required this.columns, required this.cells,
    this.datosOffline, this.cursosUi, this.precision, this.scrollControllers, this.scrollOffsetX, this.scrollOffsetY, this.onEndScrolling});

  @override
  _TableResultadoState createState() => _TableResultadoState();
}

class _TableResultadoState extends State<TableResultado>{


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          widget.calendarioPeriodoUI==null||(widget.calendarioPeriodoUI??0)==0?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
              ),
              Padding(padding: EdgeInsets.all(4)),
              Center(
                child: Text("Seleciona un bimestre o trimestre", style: TextStyle(color: AppTheme.grey, fontStyle: FontStyle.italic, fontSize: 12),),
              )
            ],
          ): (widget.columns.length)<= 3?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
              ),
              Padding(padding: EdgeInsets.all(4)),
              Center(
                child: Text("Sin compentencias${widget.datosOffline??false?", revice su conexión a internet":""}", style: TextStyle(color: AppTheme.grey, fontStyle: FontStyle.italic, fontSize: 12),),
              )
            ],
          ):
          TableCompetencia(),
        ],
      ),
    );
  }

  Widget TableCompetencia() {
    if(widget.columns!=null){
      List<double> tablecolumnWidths = [];
      for(dynamic s in widget.columns){
        if(s is PersonaUi){
          tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 100));
        } else if(s is CalendarioPeriodoUI){
          tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 70)*3);
        }else if(s is ResultadoCapacidadUi){
          tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 70));
        }else{
          tablecolumnWidths.add(ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 70));
        }
      }

      return Padding(
        padding: const EdgeInsets.only(left: 8, right: 0, top: 16),
        child:  StickyHeadersTableV2(
          scrollControllers: widget.scrollControllers??ScrollControllers(),
          initialScrollOffsetX: widget.scrollOffsetX??0,
          initialScrollOffsetY: widget.scrollOffsetY??0,
          onEndScrolling: (scrollOffsetX, scrollOffsetY) {
            widget.scrollOffsetX = scrollOffsetX;
            widget.scrollOffsetY = scrollOffsetY;
            widget.onEndScrolling?.call(scrollOffsetX, scrollOffsetY);
          },
          cellDimensions: CellDimensions.variableColumnWidth(
              stickyLegendHeight:ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 145),
              stickyLegendWidth: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 50),
              contentCellHeight: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 40),
              columnWidths: tablecolumnWidths
          ),
          columnsLength: widget.columns.length,
          rowsLength: widget.rows.length,
          columnsTitleBuilder: (i) {
            dynamic o = widget.columns[i];
            if(o is PersonaUi){
              return Container(
                  constraints: BoxConstraints.expand(),
                  child: Center(
                    child:  Text("Apellidos y\n Nombres",
                      style: TextStyle(
                        color: AppTheme.greyDarken3,
                        fontWeight: FontWeight.w700,
                        fontSize: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 11),
                        fontFamily: AppTheme.fontTTNorms,
                      ),),
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                        right: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                        bottom: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                      ),
                      color: HexColor("#EFEDEE")
                  )
              );
            }else if(o is ResultadoCompetenciaUi){
              return Stack(
                children: [
                  Container(
                      constraints: BoxConstraints.expand(),
                      padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 8)),
                      child: Center(
                        child:  RotatedBox(
                          quarterTurns: -1,
                          child: Text(o.titulo??"",
                              textAlign: TextAlign.center,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppTheme.greyDarken3,
                                fontWeight: FontWeight.w700,
                                fontSize: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 11),
                                fontFamily: AppTheme.fontTTNorms,
                              )
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                            left: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                            right: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                            bottom: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                          ),
                          borderRadius: (widget.columns.length-2 == i)?BorderRadius.only(
                              topRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthTableRubro(context, 8))
                          ):null,
                          color: HexColor("#EFEDEE")
                      )
                  ),
                  Container(
                    width: 1,
                    color: HexColor("#EFEDEE"),
                    margin: EdgeInsets.only(top: 1, bottom: 1),
                  )
                ],
              );
            }else if(o is ResultadoCapacidadUi){
              return Container(
                  constraints: BoxConstraints.expand(),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 8),
                            top: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 8),
                            bottom: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 8),
                            right: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 8)
                        ),
                        child: Center(
                          child:  RotatedBox(
                            quarterTurns: -1,
                            child: Text(o.titulo??"",
                                textAlign: TextAlign.center,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppTheme.greyDarken3,
                                  fontWeight: FontWeight.w700,
                                  fontSize: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 11),
                                  fontFamily: AppTheme.fontTTNorms,
                                )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                        right: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                        left: BorderSide(color: (o.round??false)?HexColor(widget.cursosUi?.color3): Colors.white),
                        bottom: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                      ),
                      borderRadius: (o.round??false)?BorderRadius.only(
                          topLeft: Radius.circular(8)
                      ):null,
                      color: AppTheme.white
                  )
              );
            }else if(o is CalendarioPeriodoUI){
              return Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(ColumnCountProvider.aspectRatioForWidthTableRubro(context, 8))
                        ),
                        child: Container(
                            constraints: BoxConstraints.expand(),
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child:  RotatedBox(
                                quarterTurns: -1,
                                child: Text("Final ${o.nombre??""}",
                                    textAlign: TextAlign.center,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 11),
                                        color: AppTheme.black,
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontWeight: FontWeight.w700
                                    )),
                              ),
                            ),
                            decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                                  right: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                                  bottom: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                                ),
                                color: AppTheme.greyLighten1
                            )
                        ),
                      )
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                          constraints: BoxConstraints.expand(),
                          decoration: BoxDecoration(
                              border: Border(
                                //top: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                                //right: BorderSide(color:  HexColor(widget.cursosUi?.color3)),

                              ),
                              //color: HexColor("#EFEDEE")
                          )
                      )
                  )
                ],
              );
            }else{
              return Container();
            }

          },
          rowsTitleBuilder: (i) {
            dynamic o = widget.rows[i];
            if(o is PersonaUi){
              return  Container(
                  constraints: BoxConstraints.expand(),
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 4))),
                      Expanded(
                          child: Text((i+1).toString() + ".",
                              style: TextStyle(
                                color: AppTheme.white,
                                fontWeight: FontWeight.w700,
                                fontSize: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 11),
                                fontFamily: AppTheme.fontTTNorms,
                              )
                          )
                      ),
                      Container(
                        height: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 20),
                        width: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 20),
                        margin: EdgeInsets.only(
                            right: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 3)
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HexColor(widget.cursosUi?.color3),
                        ),
                        child: true?
                        CachedNetworkImage(
                          placeholder: (context, url) => CircularProgressIndicator(),
                          imageUrl: o.foto??"",
                          errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded,
                              size: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 80)
                          ),
                          imageBuilder: (context, imageProvider) =>
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              ),
                        ):
                        Container(),
                      ),
                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 1))),
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                        right: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                      ),
                      color: HexColor(widget.cursosUi?.color2)
                  )
              );
            }else{
              return  Container();
            }

          },
          contentCellBuilder: (i, j) {
            dynamic o = widget.cells[j][i];
            if(o is PersonaUi){
              return Container(
                  constraints: BoxConstraints.expand(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(o.apellidos??"",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.greyDarken3,
                            fontWeight: FontWeight.w700,
                            fontSize: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 10),
                            fontFamily: AppTheme.fontTTNorms,
                          )
                      ),
                      Text(o.nombres??"",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppTheme.greyDarken3,
                            fontWeight: FontWeight.w500,
                            fontSize: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 10),
                            fontFamily: AppTheme.fontTTNorms,
                          )
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                        right: BorderSide(color:  HexColor(widget.cursosUi?.color3)),
                      ),
                      color: _getColorAlumnoBloqueados(o, 0)
                  )
              );
            }else if(o is ResultadoEvaluacionUi){
              if(o.capacidadUi != null && o.competenciaUi != null){//Capacidad
                return Stack(
                  children: [
                    Container(
                      constraints: BoxConstraints.expand(),
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                            right: BorderSide(color:  HexColor(widget.cursosUi?.color3)),
                            left: BorderSide(color: (o.capacidadUi?.round??false)?HexColor(widget.cursosUi?.color3): Colors.white),
                          ),
                          color: _getColorAlumnoBloqueados(o.personaUi, 0)
                      ),
                      child: _getTipoNota(o, widget.precision),
                    ),
                    if(widget.calendarioPeriodoUI?.habilitado != 1)
                      Positioned(
                          bottom: 4,
                          right: 4,
                          child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 15,)
                      ),
                  ],
                );
              }else if(o.competenciaUi != null){//Competencia
                return Stack(
                  children: [
                    Container(
                      constraints: BoxConstraints.expand(),
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                            right: BorderSide(color:  HexColor(widget.cursosUi?.color3)),
                          ),
                          color: _getColorAlumnoBloqueados(o.personaUi, 1, c_default: HexColor("#EFEDEE"))
                      ),
                      child: _getTipoNota(o, widget.precision),
                    ),
                    if(widget.calendarioPeriodoUI?.habilitado != 1)
                      Positioned(
                          bottom: 4,
                          right: 4,
                          child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 15,)
                      ),
                  ],
                );
              }else{
                return Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Stack(
                          children: [
                            Container(
                              constraints: BoxConstraints.expand(),
                              decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                                    right: BorderSide(color:  HexColor(widget.cursosUi?.color3)),
                                  ),
                                  color: _getColorAlumnoBloqueados(o.personaUi, 2, c_default: AppTheme.greyLighten1)
                              ),
                              child:  _getTipoNota(o, widget.precision),
                            ),
                            if(widget.calendarioPeriodoUI?.habilitado != 1)
                              Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8), size: 18,)
                              ),
                          ],
                        )
                    ),
                    Expanded(
                        flex: 2,
                        child: Container(
                            constraints: BoxConstraints.expand(),
                            decoration: BoxDecoration(
                                border: Border(
                                  //right: BorderSide(color:  HexColor(widget.cursosUi?.color3)),
                                ),
                                //color: HexColor("#EFEDEE")
                            )
                        )
                    ),
                  ],
                );
              }

            }else{
              return Container();
            }

          },
          legendCell: Stack(
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: HexColor(widget.cursosUi?.color1),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(7))
                  )
              ),
              Container(
                  child: Center(
                    child: Text('N°',
                        style: TextStyle(
                          color: AppTheme.white,
                          fontWeight: FontWeight.w700,
                          fontSize: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 11),
                          fontFamily: AppTheme.fontTTNorms,
                        )
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: HexColor(widget.cursosUi?.color3)),
                    ),
                  )
              ),

            ],
          ),
        ),

      );
    }else{
      return Container();
    }
  }

  Color _getColorAlumnoBloqueados(PersonaUi? personaUi, int intenciadad, {Color c_default = Colors.white}) {
    if(!(personaUi?.contratoVigente??false)){
      if(intenciadad == 0){
        return AppTheme.redLighten4;
      }else  if(intenciadad == 1){
        return AppTheme.redLighten3;
      }else  if(intenciadad == 2){
        return AppTheme.redLighten2;
      }else{
        return AppTheme.redLighten4;
      }
    }else{
      return c_default;
    }
  }

  Widget? _getTipoNota(ResultadoEvaluacionUi? resultadoEvaluacionUi, bool? precision) {

    double? nota = resultadoEvaluacionUi?.nota!=null?DomainTools.roundDouble(resultadoEvaluacionUi?.nota??0, 1): null;

    var tipo = TipoNotaTiposUi.VALOR_NUMERICO;
    if(!(precision??false)) tipo = resultadoEvaluacionUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO;
    switch(tipo){
      case TipoNotaTiposUi.SELECTOR_VALORES:
        Color color;
        if (("B" == (resultadoEvaluacionUi?.tituloNota??"") || "C" == (resultadoEvaluacionUi?.tituloNota??""))) {
          color = AppTheme.redDarken4;
        }else if (("AD" == (resultadoEvaluacionUi?.tituloNota??"")) || "A" == (resultadoEvaluacionUi?.tituloNota??"")) {
          color = AppTheme.blueDarken4;
        }else {
          color = AppTheme.black;
        }
        print("#color: ${resultadoEvaluacionUi?.color}");
        return Center(
          child: Container(
            padding: EdgeInsets.only(left: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 4),),
            child: Text("${resultadoEvaluacionUi?.tituloNota??"-"}",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 11),
                  fontFamily: AppTheme.fontTTNorms,
                  color: color,
                )),
          ),
        );
      case TipoNotaTiposUi.SELECTOR_ICONOS:
        /*if(resultadoEvaluacionUi?.valorTipoNotaId!=null){
          return Container(
            padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 4)),
            child:  CachedNetworkImage(
              imageUrl: resultadoEvaluacionUi.??"",
              placeholder: (context, url) => Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                    height: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 20),
                    width: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 20),
                  )
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        }else{
          return Center(
            child: Text("-",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 11),
                  fontFamily: AppTheme.fontTTNorms,
                  color: AppTheme.black,
                )),
          );
        }*/
      case TipoNotaTiposUi.VALOR_ASISTENCIA:
      case TipoNotaTiposUi.VALOR_NUMERICO:
      case TipoNotaTiposUi.SELECTOR_NUMERICO:
      Color color;
      if(resultadoEvaluacionUi?.valorMaximo == 20){
        if ((nota??0) < 10.5) {
          color = AppTheme.redDarken4;
        }else if ( (nota??0) >= 10.5) {
          color = AppTheme.blueDarken4;
        }else {
          color = AppTheme.black;
        }
      }else if(resultadoEvaluacionUi?.valorMaximo == 4){
        if ((nota??0) < 3) {
          color = AppTheme.redDarken4;
        }else if ( (nota??0) >= 3) {
          color = AppTheme.blueDarken4;
        }else {
          color = AppTheme.black;
        }
      }else if(resultadoEvaluacionUi?.valorMaximo == 3){
        if ((nota??0) < 3) {
          color = AppTheme.redDarken4;
        }else if ( (nota??0) >= 3) {
          color = AppTheme.blueDarken4;
        }else {
          color = AppTheme.black;
        }
      }else{
        color = AppTheme.black;
      }
      String textoNota = "${nota?.toStringAsFixed(1)??"-"}";
      if((resultadoEvaluacionUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_VALORES ||
          resultadoEvaluacionUi?.tipoNotaTiposUi == TipoNotaTiposUi.SELECTOR_ICONOS) &&
          (resultadoEvaluacionUi?.valorTipoNotaId??"").isEmpty)textoNota = "-";

        return Center(
          child: Text(textoNota, style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 11),
            fontFamily: AppTheme.fontTTNorms,
            color: color,
          ),),
        );
    }
  }

/*
  _getTipoNota(ResultadoEvaluacionUi? resultadoEvaluacionUi, bool? precision) {
    double? nota = resultadoEvaluacionUi?.nota!=null?DomainTools.roundDouble(resultadoEvaluacionUi?.nota??0, 1): null;

    var tipo = TipoNotaTiposUi.VALOR_NUMERICO;
    if(!(precision??false)) tipo = resultadoEvaluacionUi?.tipoNotaTiposUi??TipoNotaTiposUi.VALOR_NUMERICO;
    switch(tipo){
      case TipoNotaTiposUi.SELECTOR_VALORES:
        Color color;
        if (("B" == (resultadoEvaluacionUi?.tituloNota??"") || "C" == (resultadoEvaluacionUi?.tituloNota??""))/* && (resultadoEvaluacionUi?.orden??0) > 1*/) {
          color = AppTheme.redDarken4;
        }else if (("AD" == (resultadoEvaluacionUi?.tituloNota??"")) || "A" == (resultadoEvaluacionUi?.tituloNota??"")/* && (resultadoEvaluacionUi?.orden??0) > 1*/) {
          color = AppTheme.blueDarken4;
        }else {
          color = AppTheme.black;
        }
        return Center(
          child: Container(
            padding: EdgeInsets.only(left: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 4),),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${ resultadoEvaluacionUi?.tituloNota??"-"}",
                    style: TextStyle(
                      fontFamily: AppTheme.fontTTNormsMedium,
                      fontSize: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 10),
                      fontWeight: FontWeight.w700,
                      color: color,
                    )),
                Text("${nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
                  fontFamily: AppTheme.fontTTNormsMedium,
                  fontSize: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 10),
                  fontWeight: FontWeight.w700,
                  color: color,
                ),)
              ],
            ),
          ),
        );
      case TipoNotaTiposUi.SELECTOR_NUMERICO:
        Color? color = null;
        if ((resultadoEvaluacionUi?.nota??0) < 10.5 /*&& (resultadoEvaluacionUi?.orden??0) > 1*/) {
          color = AppTheme.redDarken4;
        }else if ((resultadoEvaluacionUi?.nota??0) >= 10.5 /*&& (resultadoEvaluacionUi?.orden??0) > 1*/) {
          color = AppTheme.blueDarken4;
        }else {
          color = AppTheme.black;
        }

        return Center(
          child: Text("${nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
            fontFamily: AppTheme.fontTTNormsMedium,
            fontSize: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 10),
            fontWeight: FontWeight.w700,
            color: color,
          ),),
        );
      case TipoNotaTiposUi.SELECTOR_ICONOS:
      case TipoNotaTiposUi.VALOR_ASISTENCIA:
      case TipoNotaTiposUi.VALOR_NUMERICO:
        Color color = AppTheme.black;
        return Center(
          child: Text("${nota?.toStringAsFixed(1)??"-"}", style: TextStyle(
            fontFamily: AppTheme.fontTTNormsMedium,
            fontSize: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 10),
            fontWeight: FontWeight.w700,
            color: color,
          ),),
        );

    }
  }
  */
}


class TableResultadoUtils{
  static TableResultadoResult getTableResulData(MatrizResultadoUi? matrizResultadoUi, CalendarioPeriodoUI? calendarioPeriodoUI) {
    TableResultadoResult result = TableResultadoResult();
    List<dynamic> _rows = [];
    List<dynamic> _columns = [];
    List<List<dynamic>> _cells = [];

    _rows.addAll(matrizResultadoUi?.personaUiList??[]);
    _rows.add("");//Espacio
    _rows.add("");//Espacio
    _rows.add("");//Espacio


    _columns.add(PersonaUi());//Titulo alumno

    //Competencia Base
    for(ResultadoCompetenciaUi competenciaUi in matrizResultadoUi?.competenciaUiList??[]){
      if(competenciaUi.rubroformal == 1){//tipo Base
        for(ResultadoCapacidadUi capacidadUi in competenciaUi.resulCapacidadUiList??[]){
          _columns.add(capacidadUi);
        }
        _columns.add(competenciaUi);
      }
    }
    //Competencia Base

    _columns.add(calendarioPeriodoUI);

    //Competencia Enfoque Transversal
    bool round = false;//solo es visual para la redondera
    for(ResultadoCompetenciaUi competenciaUi in matrizResultadoUi?.competenciaUiList??[]){
      if(competenciaUi.rubroformal != 1){//tipo Transversal

        if(!round){
          if((competenciaUi.resulCapacidadUiList??[]).isNotEmpty){
            round = true;
            ResultadoCapacidadUi capacidadUi = competenciaUi.resulCapacidadUiList![0];
            capacidadUi.round = true;
          }
        }

        for(ResultadoCapacidadUi capacidadUi in competenciaUi.resulCapacidadUiList??[]){
          _columns.add(capacidadUi);
        }
        _columns.add(competenciaUi);
      }
    }
    //Competencia Enfoque Transversal

    _columns.add("");// espacio

    for(dynamic column in _rows){
      List<dynamic>  cellList = [];
      cellList.add(column);

      //Competencia Base
      for(ResultadoCompetenciaUi competenciaUi in matrizResultadoUi?.competenciaUiList??[]){

        if(competenciaUi.rubroformal == 1){//tipo Base
          if(column is PersonaUi){
            ResultadoEvaluacionUi? evaluacionCompetenciaUi = matrizResultadoUi?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == column.personaId && competenciaUi.rubroResultadoId == element.rubroEvalResultadoId);

            evaluacionCompetenciaUi?.competenciaUi = competenciaUi;
            evaluacionCompetenciaUi?.personaUi = column;
            for(ResultadoCapacidadUi capacidadUi in competenciaUi.resulCapacidadUiList??[]){
              ResultadoEvaluacionUi? evaluacionCapacidadUi = matrizResultadoUi?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == column.personaId && capacidadUi.rubroResultadoId == element.rubroEvalResultadoId);
              evaluacionCapacidadUi?.capacidadUi = capacidadUi;
              evaluacionCapacidadUi?.competenciaUi = competenciaUi;
              evaluacionCapacidadUi?.personaUi = column;
              cellList.add(evaluacionCapacidadUi);

            }

            cellList.add(evaluacionCompetenciaUi);
          }else{//si el row is un espacio
            for(ResultadoCapacidadUi capacidadUi in competenciaUi.resulCapacidadUiList??[]){
              cellList.add("");// esp
            }
            cellList.add("");// espacio
          }
        }
      }
      //Competencia Base
      //Nota Final
      if (column is PersonaUi){
        ResultadoCapacidadUi? resultadoFinal =  matrizResultadoUi?.capacidadUiList?.firstWhereOrNull((element)=> (element.competenciaId ??0) == 0);
        ResultadoEvaluacionUi? evaluacionCalendarioPeriodoUi = matrizResultadoUi?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == column.personaId && element.rubroEvalResultadoId == resultadoFinal?.rubroResultadoId);
        evaluacionCalendarioPeriodoUi?.personaUi = column;
        cellList.add(evaluacionCalendarioPeriodoUi);
      } else{//si el row is un espacio
        cellList.add("");// espacio
      }

      //Nota Final
      //Competencia Enfoque y Transversal
      for(ResultadoCompetenciaUi competenciaUi in matrizResultadoUi?.competenciaUiList??[]){
        if(competenciaUi.rubroformal != 1){//tipo Transversal
          if(column is PersonaUi){
            ResultadoEvaluacionUi? evaluacionCompetenciaUi = matrizResultadoUi?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == column.personaId && competenciaUi.rubroResultadoId == element.rubroEvalResultadoId);
            evaluacionCompetenciaUi?.personaUi = column;
            evaluacionCompetenciaUi?.competenciaUi = competenciaUi;
            for(ResultadoCapacidadUi capacidadUi in competenciaUi.resulCapacidadUiList??[]){
              ResultadoEvaluacionUi? evaluacionCapacidadUi = matrizResultadoUi?.evaluacionUiList?.firstWhereOrNull((element) => element.alumnoId == column.personaId && capacidadUi.rubroResultadoId == element.rubroEvalResultadoId);
              evaluacionCapacidadUi?.capacidadUi = capacidadUi;
              evaluacionCapacidadUi?.competenciaUi = competenciaUi;
              evaluacionCapacidadUi?.personaUi = column;
              cellList.add(evaluacionCapacidadUi);
            }
            cellList.add(evaluacionCompetenciaUi);
          }else{//si el row is un espacio
            for(ResultadoCapacidadUi capacidadUi in competenciaUi.resulCapacidadUiList??[]){
              cellList.add("");// espacio
            }
            cellList.add("");// espacio
          }
        }
      }
      //Competencia Enfoque y Transversal


      cellList.add("");// espacio
      _cells.add(cellList);

    }
    result.rows = _rows;
    result.columns = _columns;
    result.cells = _cells;
    return result;
  }
}

class TableResultadoResult{
  List<dynamic>? rows;
  List<dynamic>? columns;
  List<List<dynamic>>? cells;
}