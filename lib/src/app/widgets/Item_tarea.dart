import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';

class ItemTarea extends StatefulWidget{
  late Color color1;
  late Color color2;
  late TareaUi tareaUi;
  OnTapCallback? onTap;
  ItemTarea({required this.color1,required this.color2, required this.tareaUi, this.onTap});

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
            borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthTarea(context, 14)) // use instead of BorderRadius.all(Radius.circular(20))
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: ColumnCountProvider.aspectRatioForWidthTarea(context, 12),
                      right: ColumnCountProvider.aspectRatioForWidthTarea(context, 12),
                      top: ColumnCountProvider.aspectRatioForWidthTarea(context, 12),
                      bottom: 0),
                  child: Row(
                    children: [
                      Icon(Icons.assignment,
                        color: widget.color1,
                        size: ColumnCountProvider.aspectRatioForWidthTarea(context, 14),
                      ),
                      Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTarea(context, 2))),
                      Text("Tarea ${widget.tareaUi.position??""}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: AppTheme.fontTTNorms,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              fontSize: ColumnCountProvider.aspectRatioForWidthTarea(context, 12),
                              color: widget.color1
                          )),
                      //Text("Tarea ${index}", style: TextStyle(color: widget.color1, fontSize: 12, fontWeight: FontWeight.w500),),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: ColumnCountProvider.aspectRatioForWidthTarea(context, 12),
                      right: ColumnCountProvider.aspectRatioForWidthTarea(context, 12),
                      top: ColumnCountProvider.aspectRatioForWidthTarea(context, 8),
                      bottom: 0),
                  child: Text("${widget.tareaUi.titulo}",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: AppTheme.fontTTNorms,
                        color: AppTheme.black,
                        fontSize: ColumnCountProvider.aspectRatioForWidthSesion(context, 11)
                    ),),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: ColumnCountProvider.aspectRatioForWidthTarea(context, 8),
                      left: ColumnCountProvider.aspectRatioForWidthTarea(context, 12),
                      right: ColumnCountProvider.aspectRatioForWidthTarea(context, 12),
                      bottom: 0),
                  child: Text("${widget.tareaUi.fechaEntrega??""}",
                    style: TextStyle(
                      fontSize: ColumnCountProvider.aspectRatioForWidthTarea(context, 10),
                      fontFamily: AppTheme.fontTTNorms,
                      fontWeight: FontWeight.w400,
                    ),),
                ),
                /*Expanded(child: Container()),
            Container(
              padding: EdgeInsets.only(
                left: ColumnCountProvider.aspectRatioForWidthTarea(context, 12),
                right: ColumnCountProvider.aspectRatioForWidthTarea(context, 12),
                bottom: ColumnCountProvider.aspectRatioForWidthTarea(context, 10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child:
                    Text((widget.tareaUi.publicado??false)?"Publicado" : "Sin Publicar",
                      style:
                      TextStyle(
                        color: AppTheme.colorPrimary,
                        fontSize: ColumnCountProvider.aspectRatioForWidthTarea(context, 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
              ],
            ),
            Positioned(
              bottom: ColumnCountProvider.aspectRatioForWidthSesion(context, 8),
              right: ColumnCountProvider.aspectRatioForWidthSesion(context, 12),
              child: Material(
                //color: widget.color2.withOpacity(0.8),
                borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthSesion(context, 8))),
                child: Container(
                  margin: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                      color: !(widget.tareaUi.publicado??false)?AppTheme.white:widget.color2,
                      borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthSesion(context, 7)) // use instead of BorderRadius.all(Radius.circular(20))
                  ),
                  child: InkWell(
                    onTap: () {

                    },
                    child:
                    Container(
                        padding: EdgeInsets.only(
                            top: ColumnCountProvider.aspectRatioForWidthSesion(context, 4),
                            left: ColumnCountProvider.aspectRatioForWidthSesion(context, 4),
                            bottom: ColumnCountProvider.aspectRatioForWidthSesion(context, 4),
                            right: ColumnCountProvider.aspectRatioForWidthSesion(context, 4)),
                        child: Text((widget.tareaUi.publicado??false)?"Publicado" : "Sin Publicar",
                          style: TextStyle(
                              fontSize: ColumnCountProvider.aspectRatioForWidthSesion(context, 9),
                              color: !(widget.tareaUi.publicado??false)?widget.color2.withOpacity(0.9):AppTheme.white,
                              fontFamily: AppTheme.fontTTNorms,
                              fontWeight: FontWeight.w700
                          ),)
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
typedef OnTapCallback = void Function();