import 'package:flutter/widgets.dart';

class ConexionProvider with ChangeNotifier {
  bool _conexion = false;

  online() {
    _conexion = true;
    notifyListeners();
  }

  ofline() {
    _conexion = false;
    notifyListeners();
  }

  get conexion => _conexion;
}
