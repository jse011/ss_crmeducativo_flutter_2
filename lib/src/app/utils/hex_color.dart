import 'dart:ui';

import 'package:flutter/material.dart';

class HexColor extends Color {
  HexColor(final String? hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String? hexColor) {

    try{
      if(hexColor!=null){
        hexColor = hexColor.toUpperCase().replaceAll('#', '');
        if (hexColor.length == 6) {
          hexColor = 'FF' + hexColor;
        }
        int i  = int.parse(hexColor, radix: 16);
        return i;
      }
    }catch(e){}
    return 0x00000000;//negro

  }
}