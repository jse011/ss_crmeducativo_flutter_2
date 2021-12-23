import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

class TecladoPresicionView extends StatefulWidget {

  final ValueSetter<double>? onSaveInput;
  final VoidCallback? onCloseButton;
  int? valorMaximo;
  int? valorMinimo;
  TecladoPresicionView({this.valorMaximo, this.valorMinimo,this.onSaveInput, this.onCloseButton});

  @override
  _TecladoPresicionView createState() => _TecladoPresicionView();
}

class _TecladoPresicionView extends State<TecladoPresicionView> {
  TextEditingController _controller = TextEditingController();
  bool _readOnly = true;
  String? _msg_error_nota = null;
  void _SaveInputHandler(double nota) => widget.onSaveInput?.call(nota);
  void _onCloseButtonHandler() => widget.onCloseButton?.call();


  _TecladoPresicionView();

  @override
  Widget build(BuildContext context) {


    return Container(
      height: MediaQuery.of(context).size.height * (context.isLandscape?0.85:0.7),
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
                    child: Text("Teclado numérico".toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ColumnCountProvider.aspectRatioForWidthTecladoNumerico(context, 18),
                          color:  AppTheme.darkText,
                          fontFamily: AppTheme.fontTTNorms,
                          fontWeight: FontWeight.w800,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: AppTheme.white,
                          ),
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              hintText: "Digite una nota entre ${widget.valorMinimo??"0"} a ${widget.valorMaximo??"0"}.",
                            ),
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            autofocus: true,
                            showCursor: true,
                            readOnly: _readOnly,
                          ),
                        ),
                        if(_msg_error_nota!=null)
                          Positioned(
                              right: 16,
                              bottom: 12,
                              child: Text(_msg_error_nota??"",
                                style: TextStyle(
                                  color: AppTheme.red,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                ),)
                          )
                      ],
                    ),
                    /*IconButton(
                                        icon: Icon(Icons.keyboard),
                                        onPressed: () {
                                          setState(() {
                                            _readOnly = !_readOnly;
                                          });
                                        },
                                      ),*/
                    Expanded(
                      child: CustomKeyboard(
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
                          try{
                            double nota = double.parse(_controller.text);
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
                        },
                      ),
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
    myText = myText.replaceAll("•", ".");

    final text = _controller.text;
    final textSelection = _controller.selection;
    final newText = text.replaceRange(
      textSelection.start,
      textSelection.end,
      myText,
    );
    final myTextLength = myText.length;
    _controller.text = newText;
    _controller.selection = textSelection.copyWith(
      baseOffset: textSelection.start + myTextLength,
      extentOffset: textSelection.start + myTextLength,
    );
  }

  void _backspace() {
    final text = _controller.text;
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
    );
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
  void _aceptarHandler() => onAceptar?.call();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor("#394349"),
      child: Column(
        children: [
          buildRowOne(),
          buildRowTwo(),
          buildRowThree(),
        ],
      ),
    );
  }

  Expanded buildRowOne() {
    return Expanded(
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
          TextKey(
            text: '4',
            onTextInput: _textInputHandler,
          ),
          TextKey(
            text: '5',
            onTextInput: _textInputHandler,
          ),
        ],
      ),
    );
  }

  Expanded buildRowTwo() {
    return Expanded(
      child: Row(
        children: [
          TextKey(
            text: '6',
            onTextInput: _textInputHandler,
          ),
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
          TextKey(
            text: '0',
            onTextInput: _textInputHandler,
          ),
        ],
      ),
    );
  }

  Expanded buildRowThree() {
    return Expanded(
      child: Row(
        children: [
          Expanded(
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
          ),

          TextKey(
            text: '•',
            flex: 1,
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
        padding: const EdgeInsets.all(1.0),
        child: Material(
          color: HexColor("#394349"),
          child: InkWell(
            onTap: () {
              onTextInput?.call(text);
            },
            child: Container(
              child: Center(child: Text(text, style: TextStyle(color: AppTheme.white, fontSize: 16,fontFamily: AppTheme.fontGotham),)),
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
        padding: const EdgeInsets.all(1.0),
        child: Material(
          color: HexColor("#394349"),
          child: InkWell(
            onTap: () {
              onBackspace?.call();
            },
            child: Container(
              child: Center(
                child: Icon(Icons.backspace, color: AppTheme.white,),
              ),
            ),
          ),
        ),
      ),
    );
  }
}