import 'package:flutter/widgets.dart';

class RubroProvider with ChangeNotifier {
  String _text = "";

  settext() {
    _text = "Show haha";
    //ทำงานเหมือน setstate เวลาใช้ให้ใช้แค่ตัวทำงานท้ายสุดเท่านั้น
    notifyListeners();
  }

  cleartext() {
    _text = "";
    notifyListeners();
  }

  get text => _text;
}
