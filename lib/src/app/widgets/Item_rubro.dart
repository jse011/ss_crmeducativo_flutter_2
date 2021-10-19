import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/origen_rubro_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';

class ItemRubro extends StatefulWidget{
  late CursosUi cursosUi;
  late CalendarioPeriodoUI? calendarioPeriodoUI;
  late RubricaEvaluacionUi rubricaEvalProcesoUi;
  OnTapCallback? onTap;
  ItemRubro({required this.cursosUi, required this.rubricaEvalProcesoUi, required this.calendarioPeriodoUI, this.onTap});

  @override
  ItemRubroState createState() => ItemRubroState();
}

class ItemRubroState extends State<ItemRubro>{
  @override
  Widget build(BuildContext context) {

    String origen = "";
    switch(widget.rubricaEvalProcesoUi.origenRubroUi??OrigenRubroUi.CREADO_DOCENTE){
      case OrigenRubroUi.GENERADO_INSTRUMENTO:
        origen = "Instrumento";
        break;
      case OrigenRubroUi.GENERADO_TAREA:
        origen = "Tarea";
        break;
      case OrigenRubroUi.GENERADO_PREGUNTA:
        origen = "Pregunta";
        break;
      case OrigenRubroUi.CREADO_DOCENTE:
        origen = "";
        break;
      case OrigenRubroUi.TODOS:
        origen = "";
        break;
    }

    String origen2 = "";
    if((widget.rubricaEvalProcesoUi.sesionAprendizajeId??0) > 0){
      origen2 =  "Sesion";
    }else{
      origen2 =  "Rúbrica";
    }
    
    return InkWell(
      onTap: (){
        widget.onTap?.call();
      },
      child:  Container(
        decoration: BoxDecoration(
            color: HexColor(widget.cursosUi.color1??"#FEFAE2").withOpacity(0.05),
            borderRadius: BorderRadius.circular(14) // use instead of BorderRadius.all(Radius.circular(20))
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: ColumnCountProvider.aspectRatioForWidthRubro(context, 16),
                right: ColumnCountProvider.aspectRatioForWidthRubro(context, 10),
                top: ColumnCountProvider.aspectRatioForWidthRubro(context, 12),
                bottom: ColumnCountProvider.aspectRatioForWidthRubro(context, 8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text("${widget.rubricaEvalProcesoUi.position}. Rúbrica",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: AppTheme.fontTTNorms,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                fontSize: ColumnCountProvider.aspectRatioForWidthRubro(context, 12),
                                color: (widget.rubricaEvalProcesoUi.guardadoLocal??false)?AppTheme.red:AppTheme.darkerText,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text("Media: ${widget.rubricaEvalProcesoUi.mediaDesvicion}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: ColumnCountProvider.aspectRatioForWidthRubro(context, 10),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: AppTheme.darkerText.withOpacity(0.6),
                              )

                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)) // use instead of BorderRadius.all(Radius.circular(20))
                    ),
                  ),
                  widget.calendarioPeriodoUI?.habilitado==1?Container():
                  Positioned(
                      bottom: 8,
                      right: 8,
                      child: Icon(Icons.block, color: AppTheme.redLighten1.withOpacity(0.8),)
                  ),
                  _getListRubricaDetalle(widget.rubricaEvalProcesoUi),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: ColumnCountProvider.aspectRatioForWidthRubro(context, 12),
                            top: ColumnCountProvider.aspectRatioForWidthRubro(context, 12),
                            right: ColumnCountProvider.aspectRatioForWidthRubro(context, 12)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Ionicons.time, color: HexColor("#45D8B8"),
                                size: ColumnCountProvider.aspectRatioForWidthRubro(context, 12)
                            ),
                            Padding(padding: EdgeInsets.only(left: 4)),
                            Expanded(
                              child: Text(widget.rubricaEvalProcesoUi.efechaCreacion??"",
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: ColumnCountProvider.aspectRatioForWidthRubro(context, 10),
                                    letterSpacing: 0.5,
                                    color: AppTheme.darkerText.withOpacity(0.6),
                                  )
                              ),
                            ),
                            if(widget.rubricaEvalProcesoUi.rubroGrupal??false)
                              Icon(Ionicons.people, color: HexColor(widget.cursosUi.color2??"#8767EB"),
                                  size: ColumnCountProvider.aspectRatioForWidthRubro(context, 12)
                              ),
                            Padding(padding: EdgeInsets.only(left: 4)),
                            if(widget.rubricaEvalProcesoUi.publicado??false)
                              Icon(Ionicons.earth, color: HexColor(widget.cursosUi.color2??"#8767EB"),
                                  size: ColumnCountProvider.aspectRatioForWidthRubro(context, 12)
                              )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                            padding: EdgeInsets.only(
                              left: ColumnCountProvider.aspectRatioForWidthRubro(context, 14),
                              top: ColumnCountProvider.aspectRatioForWidthRubro(context, 8),
                              bottom: ColumnCountProvider.aspectRatioForWidthRubro(context, 8),
                              right: ColumnCountProvider.aspectRatioForWidthRubro(context, 14),
                            ),
                            child: Text(widget.rubricaEvalProcesoUi.titulo??"",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: ColumnCountProvider.aspectRatioForWidthRubro(context, 12),
                                  letterSpacing: 0.5,
                                  color: AppTheme.darkerText,
                                )
                            )
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getListRubricaDetalle(RubricaEvaluacionUi rubricaEvaluacionUi){
    return Positioned(
        bottom: ColumnCountProvider.aspectRatioForWidthRubro(context, 8),
        right: ColumnCountProvider.aspectRatioForWidthRubro(context, 12),
        left: ColumnCountProvider.aspectRatioForWidthRubro(context, 12),
        child: Row(
          children: [
            if((rubricaEvaluacionUi.cantidadRubroDetalle??0) >= 0)
              Container(
                height: ColumnCountProvider.aspectRatioForWidthRubro(context, 16),
                width: ColumnCountProvider.aspectRatioForWidthRubro(context, 16),
                decoration: new BoxDecoration(
                  color: HexColor(widget.cursosUi.color2).withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                margin: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthRubro(context, 4)),
                child: Center(
                  child: Text("1", textAlign: TextAlign.center,style: TextStyle(fontSize: ColumnCountProvider.aspectRatioForWidthRubro(context, 10), color: AppTheme.white),),
                ),
              ),
            if((rubricaEvaluacionUi.cantidadRubroDetalle??0) > 1)
              Container(
                height: ColumnCountProvider.aspectRatioForWidthRubro(context, 16),
                width: ColumnCountProvider.aspectRatioForWidthRubro(context, 16),
                decoration: new BoxDecoration(
                  color: HexColor(widget.cursosUi.color2).withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                margin: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthRubro(context, 4)),
                child: Center(
                  child: Text("2", textAlign: TextAlign.center,style: TextStyle(fontSize: ColumnCountProvider.aspectRatioForWidthRubro(context, 10), color: AppTheme.white),),
                ),
              ),
            if((rubricaEvaluacionUi.cantidadRubroDetalle??0) > 2)
              Container(
                height: ColumnCountProvider.aspectRatioForWidthRubro(context, 16),
                width: ColumnCountProvider.aspectRatioForWidthRubro(context, 16),
                decoration: new BoxDecoration(
                  color: HexColor(widget.cursosUi.color2).withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                margin: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthRubro(context, 4)),
                child: Center(
                  child: Text("3", textAlign: TextAlign.center,style: TextStyle(fontSize: ColumnCountProvider.aspectRatioForWidthRubro(context, 12), color: AppTheme.white),),
                ),
              ),
            if((rubricaEvaluacionUi.cantidadRubroDetalle??0) > 3)
              Container(
                height: ColumnCountProvider.aspectRatioForWidthRubro(context, 16),
                width: ColumnCountProvider.aspectRatioForWidthRubro(context, 16),
                decoration: new BoxDecoration(
                  color: HexColor(widget.cursosUi.color2).withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                margin: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthRubro(context, 4)),
                child: Center(
                  child: Text("4", textAlign: TextAlign.center,style: TextStyle(fontSize: ColumnCountProvider.aspectRatioForWidthRubro(context, 10), color: AppTheme.white),),
                ),
              ),
            if((rubricaEvaluacionUi.cantidadRubroDetalle??0) > 4)
              Container(
                height: ColumnCountProvider.aspectRatioForWidthRubro(context, 16),
                width: ColumnCountProvider.aspectRatioForWidthRubro(context, 16),
                decoration: new BoxDecoration(
                  color: HexColor(widget.cursosUi.color2).withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                margin: EdgeInsets.only(right: ColumnCountProvider.aspectRatioForWidthRubro(context, 4)),
                child: Center(
                  child: Text(((rubricaEvaluacionUi.cantidadRubroDetalle??0)>5?"+":"")+ "5", textAlign: TextAlign.center,style: TextStyle(fontSize: ColumnCountProvider.aspectRatioForWidthRubro(context, 10), color: AppTheme.white),),
                ),
              ),
          ],
        )
    );
  }

}
typedef OnTapCallback = void Function();