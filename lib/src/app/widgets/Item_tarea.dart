import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';

class ItemTarea extends StatefulWidget{
  late Color color1;
  late TareaUi tareaUi;
  OnTapCallback? onTap;
  ItemTarea({required this.color1, required this.tareaUi, this.onTap});

  @override
  ItemTareaState createState() => ItemTareaState();
}

class ItemTareaState extends State<ItemTarea>{
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        widget.onTap?.call();
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
                    color: widget.color1,
                    size: ColumnCountProvider.aspectRatioForWidthTarea(context, 16),
                  ),
                  Padding(padding: EdgeInsets.all(2)),
                  Text("Tarea ${widget.tareaUi.position??""}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: AppTheme.fontTTNorms,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          fontSize: ColumnCountProvider.aspectRatioForWidthTarea(context, 14),
                          color: widget.color1
                      )),
                  //Text("Tarea ${index}", style: TextStyle(color: widget.color1, fontSize: 12, fontWeight: FontWeight.w500),),
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
                    child: Text("${widget.tareaUi.titulo}",
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
                        child: Text("${widget.tareaUi.fechaEntrega??""}",
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
                              Text((widget.tareaUi.publicado??false)?"Publicado" : "Sin Publicar",
                                style:
                                TextStyle(
                                  color: AppTheme.colorPrimary,
                                  fontSize: ColumnCountProvider.aspectRatioForWidthTarea(context, 14),
                                ),
                              ),
                            ),
                            Text("",
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
}
typedef OnTapCallback = void Function();