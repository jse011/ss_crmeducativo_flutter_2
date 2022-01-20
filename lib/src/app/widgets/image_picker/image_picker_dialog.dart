import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/image_picker/image_picker_handler.dart';

class ImagePickerDialog extends StatelessWidget {

  ImagePickerHandler _listener;
  late AnimationController _controller;
  late BuildContext context;
  bool? documento;
  Function? botonRemoverImagen;
  ImagePickerDialog(this._listener, this._controller,{ this.documento});

  late Animation<double> _drawerContentsOpacity;
  late Animation<Offset> _drawerDetailsPosition;

  void initState() {
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = new Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  getImage(BuildContext context, {botonRemoverImagen}) {
    if (_controller == null ||
        _drawerDetailsPosition == null ||
        _drawerContentsOpacity == null) {
      return;
    }
    this.botonRemoverImagen = botonRemoverImagen;
    _controller.forward();
    showDialog(
      context: context,
      builder: (BuildContext context) => new SlideTransition(
        position: _drawerDetailsPosition,
        child: new FadeTransition(
          opacity: new ReverseAnimation(_drawerContentsOpacity),
          child: this,
        ),
      ),
    );
  }

  void dispose() {
    _controller.dispose();
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context);
  }

  dismissDialog() {
    _controller.reverse();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Material(
        type: MaterialType.transparency,
        child: new Opacity(
          opacity: 1.0,
          child: new Container(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _listener.openCamera(),
                  child: roundedButton(
                      Icons.camera,
                      "Camara",
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      AppTheme.colorPrimary,
                      const Color(0xFFFFFFFF)),
                ),
                GestureDetector(
                  onTap: () => _listener.openGallery(),
                  child: roundedButton(
                      Icons.add_photo_alternate_outlined,
                      "Galería",
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      AppTheme.colorPrimary,
                      const Color(0xFFFFFFFF)),
                ),
                documento??false?
                GestureDetector(
                  onTap: () => _listener.openDocument(),
                  child: roundedButton(
                      Icons.article,
                      "Documento",
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      AppTheme.colorPrimary,
                      const Color(0xFFFFFFFF)),
                ):Container(),
                botonRemoverImagen!=null?
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    botonRemoverImagen?.call();
                  },
                  child: roundedButton(
                      Icons.delete_forever,
                      "Remover imagen",
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      AppTheme.colorPrimary,
                      const Color(0xFFFFFFFF)),
                ):Container(),
                SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () => dismissDialog(),
                  child: new Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                    child: roundedButton(
                        null,
                        "Salir",
                        EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        AppTheme.colorPrimary,
                        const Color(0xFFFFFFFF)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget roundedButton(
      IconData? icono,String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(15.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(25.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(icono!=null)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Icon(icono, color: AppTheme.white, ),
            ),
          Text(
            buttonLabel,
            style: new TextStyle(
                color: textColor, fontSize: 20.0, fontFamily: AppTheme.fontTTNorms,fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
    return loginBtn;
  }

}
