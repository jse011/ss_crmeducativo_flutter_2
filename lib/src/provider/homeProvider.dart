import 'package:flutter/cupertino.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';

class HomeProvider with ChangeNotifier {
  //เป็นคลาสแรงจะเข้ามาเมื่อเรียก provider
  bool _progress = false;
  List<EventoUi> _eventoUiList = [];

  bool get progress => _progress;
  List<EventoUi> get eventoUiList => _eventoUiList;

  HomeProvider() {
  }

  changeEventos(List<EventoUi>? eventoUiList,bool progress) {
    _eventoUiList = eventoUiList??[];
    _progress = progress;
    notifyListeners();
  }

}
