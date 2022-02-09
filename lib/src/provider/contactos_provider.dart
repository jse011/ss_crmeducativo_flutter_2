import 'package:flutter/material.dart';


class ContactoProvider with ChangeNotifier {

  bool _progress = false;
  bool get progress => _progress;

  @override
  void hideProgres() {
    _progress = true;
  }

  @override
  void showProgress() {
    _progress = true;
  }

  @override
  void refreshUI() {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }


}
