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
import 'package:ss_crmeducativo_2/src/app/widgets/Item_tarea.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';

class TabTareas extends StatefulWidget{
  @override
  _TabTareasState createState() => _TabTareasState();

}

class _TabTareasState extends State<TabTareas>{
  @override
  Widget build(BuildContext context) {
    SesionController controller =
    FlutterCleanArchitecture.getController<SesionController>(context, listen: false);


    return  Stack(
      children: [
        controller.tareaUiList.isEmpty?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
            ),
            Padding(padding: EdgeInsets.all(4)),
            Center(
              child: Text("Lista vacía${!controller.conexionTareaUnidad?", revice su conexión a internet":""}",
                  style: TextStyle(
                      color: AppTheme.grey,
                      fontSize: 12,
                      fontFamily: AppTheme.fontTTNorms
                  )),
            )
          ],
        ):Container(),
        if(controller.progressTarea)
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
          ),
        SingleChildScrollView(
          physics: ScrollPhysics(),
          child:  GridView.builder(
              padding: EdgeInsets.only(left: 24, right: 24, top: 24),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ColumnCountProvider.columnsForWidthTarea(context),
                mainAxisSpacing: 24.0,
                crossAxisSpacing: 24.0,
              ),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.tareaUiList.length,
              itemBuilder: (context, index){
                dynamic o = controller.tareaUiList[index];
                if(o is TareaUi){
                  return ItemTarea(
                      color1: HexColor(controller.cursosUi.color1),
                      color2: HexColor(controller.cursosUi.color2),
                      tareaUi: o, onTap: () async{
                    dynamic? result = await AppRouter.createRouteTareaPortalRouter(context, controller.usuarioUi, controller.cursosUi, o, controller.calendarioPeriodoUI, controller.unidadUi, controller.sesionUi);
                    if(result is int) controller.refrescarListTarea();
                  });
                }else{
                  return InkWell(
                    onTap: () async{
                      dynamic? result = await AppRouter.createRouteTareaCrearRouter(context, controller.usuarioUi, controller.cursosUi, null, controller.calendarioPeriodoUI, controller.unidadUi, controller.sesionUi);
                      if(result is int) controller.refrescarListTarea();
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: HexColor(controller.cursosUi.color2),
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
                              Icon(Ionicons.add, color: AppTheme.white, size: ColumnCountProvider.aspectRatioForWidthTarea(context, 40),),
                              Padding(padding: EdgeInsets.only(top: 4)),
                              Text("Crear tarea",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: ColumnCountProvider.aspectRatioForWidthTarea(context, 16),
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

                }
              }
          )
        ),
      ],
    );
  }

}