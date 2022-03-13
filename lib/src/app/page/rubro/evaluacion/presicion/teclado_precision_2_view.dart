import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_rubrica_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_valor_tipo_nota_presicion.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/validar_nota_teclado.dart';

class TecladoPresicionView2 extends StatefulWidget {

  final ValueSetter<double>? onSaveInput;
  final VoidCallback? onCloseButton;
  int? valorMaximo;
  int? valorMinimo;
  double? valor;

  TecladoPresicionView2({this.valorMaximo, this.valorMinimo,this.onSaveInput, this.onCloseButton, this.valor}){
   //this.valorMaximo = 10;
  }

  @override
  _TecladoPresicionView2 createState() => _TecladoPresicionView2(this.valor, this.valorMaximo);
}

class _TecladoPresicionView2 extends State<TecladoPresicionView2> {
  //TextEditingController _controller = TextEditingController();
  bool _readOnly = true;
  String? _msg_error_nota = null;
  void _SaveInputHandler(double nota) => widget.onSaveInput?.call(nota);
  void _onCloseButtonHandler() => widget.onCloseButton?.call();
  int numeroDecena = 0;
  int numeroUnidad = 0;
  int numeroDecimal = 0;
  
  bool selectedDecena = true;
  bool selectedUnidad = false;
  bool selectedDecimal = false;

  _TecladoPresicionView2(double? valor, int? valorMaximo){
    valor = valor??0;
    List<String> substr = valor.toString().split('.');
    String entero = substr[0];
    if(entero.length>1){
      numeroDecena = int.parse(entero[0]);
      numeroUnidad = int.parse(entero[1]);

    }else{
      numeroUnidad = int.parse(entero[0]);

    }

    int decimals = 0;
    if (substr.length > 0) decimals = int.parse(substr[1]);
    if(decimals.toString().length>0){
      numeroDecimal = int.parse(decimals.toString()[0]);
    }

    if((valorMaximo??0)<=9){
      selectedDecena = false;
      selectedUnidad = true;
    }
  }

  @override
  Widget build(BuildContext context) {

    Widget buttons = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              primary: AppTheme.colorPrimary
          ),
          child: Text('Guardar',
            style: TextStyle(
              fontSize: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 16),
              color:  AppTheme.white,
              fontFamily: AppTheme.fontTTNorms,
              fontWeight: FontWeight.w700,
            ),),
          onPressed: () {
            _onSaveButtomHandler();
          },
        ),
        Padding(
          padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 8)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              primary: AppTheme.colorPrimary
          ),
          child: Text('Salir',
            style: TextStyle(
              fontSize: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 16),
              color:  AppTheme.white,
              fontFamily: AppTheme.fontTTNorms,
              fontWeight: FontWeight.w700,
            ),),
          onPressed: () {
            _onCloseButtonHandler();
          },
        ),
      ],
    );

    return Container(
      height: MediaQuery.of(context).size.height * (context.isLandscape?1:0.85),
      decoration: new BoxDecoration(
        color: AppTheme.background,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Container(
                padding: EdgeInsets.only(
                  right: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 16),
                  top: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 8),
                ),
                child:  ClipOval(
                  child: Material(
                    color: AppTheme.colorPrimary.withOpacity(0.1), // button color
                    child: InkWell(
                      splashColor: AppTheme.colorPrimary, // inkwell color
                      child: SizedBox(
                        width: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 43 + 6),
                        height: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 43 + 6),
                        child: Icon(
                          Ionicons.close,
                          size: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 24 + 6),
                          color: AppTheme.colorPrimary, ),
                      ),
                      onTap: () {
                        _onCloseButtonHandler();
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
          Expanded(
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 8),
                                  bottom: 0,
                                  left: 0,
                                  right: 0
                              ),
                              child: Center(
                                child: Text("Teclado numérico",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 18),
                                      color:  AppTheme.darkText,
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w900,
                                    )),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 4),
                                  bottom: 0,
                                  left: 0,
                                  right: 0
                              ),
                              child: Center(
                                child: Text("Digite una nota entre ${widget.valorMinimo??"0"} y ${widget.valorMaximo??"0"}.",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 14),
                                      color:  AppTheme.darkText,
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 30)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (widget.valorMaximo??0)>9?
                                  Card(
                                      elevation: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 60)),
                                      ),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            selectedDecena = true;
                                            selectedUnidad = false;
                                            selectedDecimal = false;
                                          });
                                        },
                                        child: Container(
                                          width: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 60),
                                          height: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 60),
                                          decoration: BoxDecoration(
                                            // The child of a round Card should be in round shape
                                            shape: BoxShape.circle,
                                            color: AppTheme.white,
                                            border: Border.all(
                                              color: AppTheme.colorPrimary.withOpacity(selectedDecena?1:0),
                                              width: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 4),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text("${numeroDecena}",
                                              style: TextStyle(
                                                fontSize: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 24),
                                                color:  AppTheme.darkText,
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  ):Container(),
                                  Padding(
                                    padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 2)),
                                  ),
                                  Card(
                                      elevation: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 60)),
                                      ),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            selectedDecena = false;
                                            selectedUnidad = true;
                                            selectedDecimal = false;
                                          });
                                        },
                                        child: Container(
                                          width: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 60),
                                          height: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 60),
                                          decoration: BoxDecoration(
                                            // The child of a round Card should be in round shape
                                            shape: BoxShape.circle,
                                            color: AppTheme.white,
                                            border: Border.all(
                                              color: AppTheme.colorPrimary.withOpacity(selectedUnidad?1:0),
                                              width: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 4),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text("${numeroUnidad}",
                                              style: TextStyle(
                                                fontSize: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 24),
                                                color:  AppTheme.darkText,
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 2)),
                                  ),
                                  Container(
                                    height: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 75),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("•",
                                            style: TextStyle(
                                                color: AppTheme.colorPrimary,
                                                fontSize: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 24),
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontWeight: FontWeight.w900
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 2)),
                                  ),
                                  Card(
                                      elevation: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 60)),
                                      ),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            selectedDecena = false;
                                            selectedUnidad = false;
                                            selectedDecimal = true;
                                          });
                                        },
                                        child: Container(
                                          width: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 60),
                                          height: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 60),
                                          decoration: BoxDecoration(
                                            // The child of a round Card should be in round shape
                                            shape: BoxShape.circle,
                                            color: AppTheme.white,
                                            border: Border.all(
                                              color: AppTheme.colorPrimary.withOpacity(selectedDecimal?1:0),
                                              width: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 4),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text("${numeroDecimal}",
                                              style: TextStyle(
                                                fontSize: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 24),
                                                color:  AppTheme.darkText,
                                                fontFamily: AppTheme.fontTTNorms,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  context.isLandscape?
                                  Padding(
                                    padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 16)),
                                  ):Container(),
                                  context.isLandscape?
                                  buttons:Container(),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 4),
                                  bottom: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 4),
                                  left: 0,
                                  right: 0
                              ),
                              child: Center(
                                child: Text(_msg_error_nota??"",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 14),
                                      color:  AppTheme.red,
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                            ),
                            !context.isLandscape?
                            buttons:Container(),
                          ],
                        )
                    ),
                    CustomKeyboard(
                      onTextInput: (myText) {
                        _insertText(myText);
                        setState(() {
                          _msg_error_nota = null;
                        });
                      },
                      onBackspace: () {
                        _backspace();
                        setState(() {
                          _msg_error_nota = null;
                        });
                      },
                      onAceptar: (){

                      },
                    )
                  ],
                ) ,
              )
          )
        ],
      ),
    );

  }

  Widget chipNotaPresicion(int nota, Color? color) {
    return Container(
      //margin: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
      height: 60,
      width: 60,
      decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          splashColor: AppTheme.greyDarken4.withOpacity(0.8),
          onTap: () {
            _SaveInputHandler(nota.toDouble());
          },
          child: Column(
            //alignment: AlignmentDirectional.center,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 4,left: 8, right: 8),
                child: Text("${nota}", textAlign: TextAlign.center , style: TextStyle(color: AppTheme.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: AppTheme.fontGotham)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _insertText(String myText) {
    if(myText == "•"){
      setState(() {
        selectedDecena = false;
        selectedUnidad = false;
        selectedDecimal = true;
      });
    }else if(selectedDecena){
      setState(() {
        numeroDecena = int.parse(myText);
        selectedDecena = false;
        selectedUnidad = true;
        selectedDecimal = false;
      });
    }else if(selectedUnidad){
      setState(() {
        numeroUnidad = int.parse(myText);
        selectedDecena = false;
        selectedUnidad = false;
        selectedDecimal = true;
      });
    }else if(selectedDecimal){
      setState(() {
        numeroDecimal = int.parse(myText);
        if((widget.valorMaximo??0)<=9){
          selectedDecena = false;
          selectedUnidad = true;
          selectedDecimal = false;
        }else{
          selectedDecena = true;
          selectedUnidad = false;
          selectedDecimal = false;
        }

      });
    }

  }

  void _backspace() {

    if(selectedDecena){
      setState(() {
        numeroDecimal = 0;
        selectedDecena = false;
        selectedUnidad = false;
        selectedDecimal = true;
      });
    }else if(selectedUnidad){
      setState(() {
        if((widget.valorMaximo??0)<=9){
          numeroDecimal = 0;
          selectedDecena = false;
          selectedUnidad = false;
          selectedDecimal = true;
        }else{
          numeroDecena = 0;
          selectedDecena = true;
          selectedUnidad = false;
          selectedDecimal = false;
        }

      });
    }else if(selectedDecimal){
      setState(() {
        numeroUnidad = 0;
        selectedDecena = false;
        selectedUnidad = true;
        selectedDecimal = false;
      });
    }

    /*final text = _controller.text;
    final textSelection = _controller.selection;
    final selectionLength = textSelection.end - textSelection.start;

    // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      _controller.text = newText;
      _controller.selection = textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      return;
    }

    // The cursor is at the beginning.
    if (textSelection.start == 0) {
      return;
    }

    // Delete the previous character
    final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
    final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
    final newStart = textSelection.start - offset;
    final newEnd = textSelection.start;
    final newText = text.replaceRange(
      newStart,
      newEnd,
      '',
    );
    _controller.text = newText;
    _controller.selection = textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
    );*/
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onSaveButtomHandler() {
    try{
      double nota = double.parse("${numeroDecena}${numeroUnidad}.${numeroDecimal}");
      if(nota >= (widget.valorMinimo??0) && nota <= (widget.valorMaximo??0)){
        _SaveInputHandler(nota);
      }else{
        _msg_error_nota = "Digite una nota entre ${widget.valorMinimo??"0"} y ${widget.valorMaximo??"0"}.";
        setState(() {

        });
      }
    }catch(e){
      _msg_error_nota = "Digite una nota valida.";
      setState(() {

      });
      Fluttertoast.showToast(
        msg: _msg_error_nota??"",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );

    }
  }

}


class CustomKeyboard extends StatelessWidget {
  CustomKeyboard({
    Key? key,
    this.onTextInput,
    this.onBackspace,
    this.onAceptar,
  }) : super(key: key);

  final ValueSetter<String>? onTextInput;
  final VoidCallback? onBackspace;
  final VoidCallback? onAceptar;

  void _textInputHandler(String text) => onTextInput?.call(text);

  void _backspaceHandler() => onBackspace?.call();
  //void _aceptarHandler() => onAceptar?.call();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: Column(
        children: [
          buildRowOne(),
          buildRowTwo(),
          buildRowThree(),
          buildRowFour()
        ],
      ),
    );
  }

  Widget buildRowOne() {
    return Container(
      child: Row(
        children: [
          TextKey(
            text: '1',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '2',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '3',
            onTextInput: _textInputHandler,
          ),
        ],
      ),
    );
  }

  Widget buildRowTwo() {
    return Container(
      child: Row(
        children: [
          TextKey(
            text: '4',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '5',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '6',
            onTextInput: _textInputHandler,
          ),
        ],
      ),
    );
  }

  Widget buildRowThree() {
    return Container(
      child: Row(
        children: [
          TextKey(
            text: '7',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '8',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '9',
            onTextInput: _textInputHandler,
          ),
        ],
      ),
    );
  }

  Widget buildRowFour() {
    return Container(
      child: Row(
        children: [
          /*Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Material(
                color: HexColor("#394349"),
                child: InkWell(
                  onTap: () {
                    _aceptarHandler();
                  },
                  child: Container(
                    child: Center(child: Text('Guardar', style: TextStyle(color: AppTheme.white, fontFamily: AppTheme.fontGotham),)),
                  ),
                ),
              ),
            ),
          ),*/
          TextKey(
            text: '0',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '•',
            onTextInput: _textInputHandler,
          ),
          BackspaceKey(
            onBackspace: _backspaceHandler,
          ),
        ],
      ),
    );
  }
}

class TextKey extends StatelessWidget {
  const TextKey({
    Key? key,
    required this.text,
    this.onTextInput,
    this.flex = 1,
  }) : super(key: key);

  final String text;
  final ValueSetter<String>? onTextInput;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.all(0),
        child: Material(
          color: AppTheme.white,
          child: InkWell(
            onTap: () {
              onTextInput?.call(text);
            },
            child: Container(
              padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 18)),
              child: Center(
                  child: Text(text,
                style: TextStyle(
                    color: AppTheme.colorPrimary,
                    fontSize: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 18),
                    fontFamily: AppTheme.fontTTNorms,
                    fontWeight: FontWeight.w900
                )
              )
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BackspaceKey extends StatelessWidget {
  const BackspaceKey({
    Key? key,
    this.onBackspace,
    this.flex = 1,
  }) : super(key: key);

  final VoidCallback? onBackspace;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding:  EdgeInsets.all(0),
        child: Material(
          color: AppTheme.white,
          child: InkWell(
            onTap: () {
              onBackspace?.call();
            },
            child: Container(
              //padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 16)),
              child: Center(
                child: Icon(Icons.backspace, color: AppTheme.colorPrimary,),
              ),
            ),
          ),
        ),
      ),
    );
  }
}