import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_valor_tipo_nota_presicion.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/validar_nota_teclado.dart';

class PesoView extends StatefulWidget {
  RubricaEvaluacionUi? rubricaEvaluacionUi;
  CapacidadUi? capacidadUi;
  final ValueSetter<double>? onSaveInput;
  final VoidCallback? onCloseButton;
  Color? color;
  PesoView({this.capacidadUi, this.rubricaEvaluacionUi, this.color, this.onSaveInput, this.onCloseButton});

  @override
  _PesoView createState() => _PesoView();
}

class _PesoView extends State<PesoView> {
  TextEditingController _controller = TextEditingController();
  void _SaveInputHandler(double peso) => widget.onSaveInput?.call(peso);
  void _onCloseButtonHandler() => widget.onCloseButton?.call();
  int _selectedValue = RubricaEvaluacionUi.PESO_NORMAL;

  _PesoView();

  @override
  Widget build(BuildContext context) {


    return Container(
      height: 230,
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
                  margin: const EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 70),
                  child: Center(
                    child: Text("Peso en la calificación".toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppTheme.fontTTNorms,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          letterSpacing: 0.8,
                          color: AppTheme.darkerText,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(8)),
          Row(
            children: [
              Padding(padding: EdgeInsets.all(16)),
              Text("Prioridad del criterio".toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppTheme.greyDarken1),),
            ],
          ),
          Padding(padding: EdgeInsets.all(8)),
          CupertinoSlidingSegmentedControl(
            //padding: EdgeInsets.only(left: 16, top: 16),
            groupValue: _selectedValue,
            thumbColor: CupertinoDynamicColor.withBrightness(
              color: (){
                if(_selectedValue==RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO){
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
                _selectedValue = value??0;
              });
              Future.delayed(const Duration(milliseconds: 600), () {
                _SaveInputHandler(0);
              });

            },
            children: {
              RubricaEvaluacionUi.PESO_ALTO:  Container(
                margin: EdgeInsets.all(8),
                child: Text("ALTA", style: TextStyle(color: _selectedValue==RubricaEvaluacionUi.PESO_ALTO?AppTheme.white:null)),

                //color: _selectedValue==RubricaEvaluacionUi.PESO_ALTO? Colors.blue[100] : Colors.white,
              ),
              RubricaEvaluacionUi.PESO_NORMAL:  Container(
                margin: EdgeInsets.all(8),
                child: Text("NORMAL", style: TextStyle(color:_selectedValue==RubricaEvaluacionUi.PESO_NORMAL?AppTheme.white:null)),

                //color: _selectedValue==RubricaEvaluacionUi.PESO_NORMAL? Colors.blue[100] : Colors.white,
              ),
              RubricaEvaluacionUi.PESO_BAJO: Container(
                margin: EdgeInsets.all(8),
                child: Text("BAJA", style: TextStyle(color: _selectedValue==RubricaEvaluacionUi.PESO_BAJO?AppTheme.white:null),),

                //color: Colors.blue[100] : Colors.white,
              ),
              RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO:  Container(
                margin: EdgeInsets.all(8),
                child: Text("NO USAR\nCRITERIO", style: TextStyle(color: _selectedValue==RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO?AppTheme.white:AppTheme.red, fontSize: 11, fontWeight: FontWeight.w700)),

                //color: _selectedValue==RubricaEvaluacionUi.PESO_RUBRO_EXCLUIDO? Colors.blue[100] : Colors.white,
              ),
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