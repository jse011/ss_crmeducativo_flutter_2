import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/sesion_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/Item_rubro.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/Item_tarea.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';

class TabRubros extends StatefulWidget{
  @override
  _TabRubrosState createState() => _TabRubrosState();

}

class _TabRubrosState extends State<TabRubros>{
  @override
  Widget build(BuildContext context) {
    SesionController controller =
    FlutterCleanArchitecture.getController<SesionController>(context, listen: false);


    return  Stack(
      children: [
        controller.calendarioPeriodoUI==null || (controller.calendarioPeriodoUI.habilitadoProceso??0)==1?
        Container():
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top:16, bottom: 16, right: 24, left: 24),
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          decoration: BoxDecoration(
            color: AppTheme.redLighten1,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text("El ${controller.calendarioPeriodoUI.nombre??"período"} no se encuentra vigente.", textAlign: TextAlign.center,style: TextStyle(color: AppTheme.white, fontSize: 14),),
        ),

       controller.progressEvaluacion?
          Padding(padding: EdgeInsets.only(top: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16)
              ),
              child: ArsProgressWidget(
                blur: 2,
                backgroundColor: Color(0x33000000),
                animationDuration: Duration(milliseconds: 500),
              ),
            ),
          ):
        controller.rubricaEvaluacionUiList.isEmpty?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
            ),
            Padding(padding: EdgeInsets.all(4)),
            Center(
              child: Text("Lista vacía${!controller.conexionRubro?", revice su conexión a internet":""}",
                style: TextStyle(
                    color: AppTheme.grey,
                    fontSize: 12,
                    fontFamily: AppTheme.fontTTNorms
                ),),
            )
          ],
        ):Container(),
        Column(
          children: [
            Padding(padding: EdgeInsets.only(top: controller.calendarioPeriodoUI==null || (controller.calendarioPeriodoUI.habilitadoProceso??0)==1?24:88)),
            Expanded(child: CustomScrollView(
              //controller: scrollController,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(top: 0, right: 24, left: 24),
                    sliver:  SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: ColumnCountProvider.columnsForWidthRubro(context),
                        mainAxisSpacing: 24.0,
                        crossAxisSpacing: 24.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index){
                            dynamic o =  controller.rubricaEvaluacionUiList[index];

                            if(o is String){
                              return InkWell(
                                onTap: () async{
                                  _guardarRubroyRetornar(context, controller);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.colorSesion,
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
                                          Text("Crear\nevaluación",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: ColumnCountProvider.aspectRatioForWidthRubro(context, 16),
                                                fontWeight: FontWeight.w700,
                                                fontFamily: AppTheme.fontTTNorms,
                                                color: AppTheme.white
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }else if(o is RubricaEvaluacionUi){
                              //int position = (controller.rubricaEvaluacionUiList?.length??0) - index;
                              return ItemRubro(rubricaEvalProcesoUi: o,
                                calendarioPeriodoUI: controller.calendarioPeriodoUI,
                                cursosUi: controller.cursosUi,
                                onTap: (){
                                  if((o.cantidadRubroDetalle??0) > 1){
                                    _evaluacionMultipleRetornar(context, controller, o);
                                  }else{
                                    _evaluacionSimpleRetornar(context, controller, o, controller.calendarioPeriodoUI);
                                  }
                                },
                              );;
                            }
                          },
                          childCount: controller.rubricaEvaluacionUiList.length
                      ),
                    ),
                  )
                ]))
          ],
        ),
      ],
    );
  }

  void _evaluacionMultipleRetornar(BuildContext context, SesionController controller, RubricaEvaluacionUi rubricaEvaluacionUi) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    dynamic response = await AppRouter.createRouteEvaluacionMultiple(context, controller.calendarioPeriodoUI,controller.cursosUi, rubricaEvaluacionUi.rubroEvaluacionId);
    if(response is int) controller.respuestaEvaluacion();
  }

  void _evaluacionSimpleRetornar(BuildContext context, SesionController controller, RubricaEvaluacionUi rubricaEvaluacionUi, CalendarioPeriodoUI? calendarioPeriodoUI) async{
    dynamic response = await AppRouter.createRouteEvaluacionSimple(context, controller.cursosUi, rubricaEvaluacionUi, calendarioPeriodoUI);
    if(response is int) controller.respuestaEvaluacion();
  }

  void _guardarRubroyRetornar(BuildContext context, SesionController controller) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    dynamic response = await AppRouter.createRouteRubroCrearRouter(context, controller.cursosUi, controller.calendarioPeriodoUI, controller.sesionUi, null,null, false);
    if(response is String) controller.respuestaFormularioCrearRubro();
  }


}