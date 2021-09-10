import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';

class PesoView extends StatefulWidget {
  late int selectedValue;
  final ValueSetter<int>? onSaveInput;
  final VoidCallback? onCloseButton;
  Color? color;
  PesoView({ required this.selectedValue, this.color, this.onSaveInput, this.onCloseButton});

  @override
  _PesoView createState() => _PesoView();
}

class _PesoView extends State<PesoView> {
  TextEditingController _controller = TextEditingController();
  void _SaveInputHandler(int peso) => widget.onSaveInput?.call(peso);
  void _onCloseButtonHandler() => widget.onCloseButton?.call();

  _PesoView();

  @override
  Widget build(BuildContext context) {


    return Container(
      height: 310,
      decoration: new BoxDecoration(
        color: AppTheme.white,
        borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 10,
                  child: ClipOval(
                    child: Material(
                      color: AppTheme.colorPrimary.withOpacity(0.1), // button color
                      child: InkWell(
                        splashColor: AppTheme.colorPrimary, // inkwell color
                        child: SizedBox(width: 43 + 6, height: 43 + 6,
                          child: Icon(Ionicons.close, size: 24 + 6,color: AppTheme.colorPrimary, ),
                        ),
                        onTap: () {
                          _onCloseButtonHandler();
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 0, left: 28, right: 70),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Text("Peso en la calificación".toUpperCase(),
                         maxLines: 2,
                         overflow: TextOverflow.ellipsis,
                         style: TextStyle(
                           fontFamily: AppTheme.fontTTNorms,
                           fontWeight: FontWeight.w800,
                           fontSize: 18,
                           letterSpacing: 0.8,
                           color: AppTheme.darkerText,
                         )),
                   ],
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(4)),
          Row(
            children: [
              Padding(padding: EdgeInsets.all(16)),
              Text("Prioridad del criterio".toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.greyDarken1),),
            ],
          ),
          Padding(padding: EdgeInsets.all(8)),
          CupertinoSlidingSegmentedControl(
            //padding: EdgeInsets.only(left: 16, top: 16),
            groupValue: widget.selectedValue,
            thumbColor: CupertinoDynamicColor.withBrightness(
              color: (){
                if(widget.selectedValue==RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO){
                  return AppTheme.red;
                }else{
                  return widget.color??AppTheme.colorAccent.withOpacity(0.2);
                }
              }(),
              darkColor: AppTheme.red,
            ),
            padding: EdgeInsets.all(4),
            onValueChanged: (int? value) {
              //print("onValueChanged");
              setState(() {
                widget.selectedValue = value??0;
              });

            },
            children: {
              RubricaEvaluacionUi.PESO_ALTO:  Container(
                margin: EdgeInsets.all(8),
                child: Text("ALTA", style: TextStyle(color: widget.selectedValue==RubricaEvaluacionUi.PESO_ALTO?AppTheme.white:null)),

                //color: _selectedValue==RubricaEvaluacionUi.PESO_ALTO? Colors.blue[100] : Colors.white,
              ),
              RubricaEvaluacionUi.PESO_NORMAL:  Container(
                margin: EdgeInsets.all(8),
                child: Text("NORMAL", style: TextStyle(color:widget.selectedValue==RubricaEvaluacionUi.PESO_NORMAL?AppTheme.white:null)),

                //color: _selectedValue==RubricaEvaluacionUi.PESO_NORMAL? Colors.blue[100] : Colors.white,
              ),
              RubricaEvaluacionUi.PESO_BAJO: Container(
                margin: EdgeInsets.all(8),
                child: Text("BAJA", style: TextStyle(color: widget.selectedValue==RubricaEvaluacionUi.PESO_BAJO?AppTheme.white:null),),

                //color: Colors.blue[100] : Colors.white,
              ),
              RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO:  Container(
                margin: EdgeInsets.all(8),
                child: Text("NO USAR\nCRITERIO", style: TextStyle(color: widget.selectedValue==RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO?AppTheme.white:AppTheme.red, fontSize: 11, fontWeight: FontWeight.w700)),

                //color: _selectedValue==RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO? Colors.blue[100] : Colors.white,
              ),
            },
          ),
          Padding(padding: EdgeInsets.all(4)),
          Row(
            children: [
              Padding(padding: EdgeInsets.all(8)),
              Expanded(child: Text("Seleccione que tipo de prioridad tendrá el criterio. El peso en la calificación depende del tipo de prioridad.", style: TextStyle(fontSize: 12, color: AppTheme.colorAccent, fontStyle: FontStyle.italic),),)
            ],
          ),
          Padding(padding: EdgeInsets.all(16)),
          CupertinoButton(
            color: widget.color??AppTheme.colorAccent.withOpacity(0.2),
            child: Text('Guardar'.toUpperCase()),
            onPressed: () {
              _SaveInputHandler(widget.selectedValue);
            },
          )
        ],
      ),
    );

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}