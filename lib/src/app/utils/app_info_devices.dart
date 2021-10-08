import 'package:flutter/widgets.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';

class AppInfoDevices {

  static Appevices? getDevice(BuildContext context){
    double width = context.widthPx;
    double height = context.heightPx;
    Size sizeInInches = context.sizeInches;
    print("width: ${width}");
    print("height: ${height}");

    print("sizeInInches: ${sizeInInches.aspectRatio}");
    if((width == 1440 || height == 1440) && (height == 2960 || width == 2960) && sizeInInches.aspectRatio == 6.2){
      return Appevices.SANSUNG_S_8_plus;
    }
    return null;


  }

}

enum Appevices{
  SANSUNG_S_8_plus, SANSUNG_A71,
}