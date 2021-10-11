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
              child: Text("Lista vacía${controller.datosOffline?", revice su conexión a internet":""}", style: TextStyle(color: AppTheme.grey, fontStyle: FontStyle.italic, fontSize: 12),),
            )
          ],
        ):Container(),
        SingleChildScrollView(
          physics: ScrollPhysics(),
          child:  GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ColumnCountProvider.columnsForWidthTarea(context),
                mainAxisSpacing: 24.0,
                crossAxisSpacing: 24.0,
              ),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.tareaUiList.length,
              itemBuilder: (context, index){
                TareaUi o = controller.tareaUiList[index];
                return InkWell(
                  onTap: () async{
                    bool? result = await AppRouter.createRouteTareaPortalRouter(context,  controller.cursosUi, o, controller.calendarioPeriodoUI);
                    //controller.onClickTarea(o);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(14) // use instead of BorderRadius.all(Radius.circular(20))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: ColumnCountProvider.aspectRatioForWidthTarea(context, 14),
                              right: ColumnCountProvider.aspectRatioForWidthTarea(context, 16),
                              top: ColumnCountProvider.aspectRatioForWidthTarea(context, 16),
                              bottom: 0),
                          child: Row(
                            children: [
                              Icon(Icons.assignment,
                                color: HexColor(controller.cursosUi.color1),
                                size: ColumnCountProvider.aspectRatioForWidthTarea(context, 16),
                              ),
                              Padding(padding: EdgeInsets.all(2)),
                              Text("Tarea ${o.position??""}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      fontSize: ColumnCountProvider.aspectRatioForWidthTarea(context, 14),
                                      color: HexColor(controller.cursosUi.color1)
                                  )),
                              //Text("Tarea ${index}", style: TextStyle(color: HexColor(controller.cursosUi.color1), fontSize: 12, fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: ColumnCountProvider.aspectRatioForWidthTarea(context, 16),
                                    right: ColumnCountProvider.aspectRatioForWidthTarea(context, 16),
                                    top: ColumnCountProvider.aspectRatioForWidthTarea(context, 10),
                                    bottom: 0),
                                child: Text("${o.titulo}",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: AppTheme.black,
                                      fontSize: ColumnCountProvider.aspectRatioForWidthTarea(context, 13)
                                  ),),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: ColumnCountProvider.aspectRatioForWidthTarea(context, 10),
                                        left: ColumnCountProvider.aspectRatioForWidthTarea(context, 16),
                                        right: ColumnCountProvider.aspectRatioForWidthTarea(context, 16),
                                        bottom: 0),
                                    child: Text("${o.fechaEntrega??""}",
                                      style: TextStyle(
                                        fontSize: ColumnCountProvider.aspectRatioForWidthTarea(context, 12),
                                      ),),
                                  ),
                                  Expanded(child: Container()),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: ColumnCountProvider.aspectRatioForWidthTarea(context, 16),
                                      right: ColumnCountProvider.aspectRatioForWidthTarea(context, 16),
                                      bottom: ColumnCountProvider.aspectRatioForWidthTarea(context, 16),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child:
                                          Text((o.publicado??false)?"Publicado":"Sin Publicar",
                                            style:
                                            TextStyle(
                                              color: AppTheme.colorPrimary,
                                              fontSize: ColumnCountProvider.aspectRatioForWidthTarea(context, 14),
                                            ),
                                          ),
                                        ),
                                        Text("0/15",
                                          style: TextStyle(
                                            color: AppTheme.colorPrimary,
                                            fontSize: ColumnCountProvider.aspectRatioForWidthTarea(context, 14),
                                          ),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ),

                      ],
                    ),
                  ),
                );
              }
          )
        ),
      ],
    );
  }

}