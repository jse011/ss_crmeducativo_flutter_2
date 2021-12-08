import 'package:flutter/material.dart';

class AppUtils {

  static TimeOfDay horaTimeOfDay(String? hora_minuto){
    int hour = 0;
    int minuto = 0;
    try{

      List<String>? list = hora_minuto?.split(":");
      if(list?.isEmpty??false){
        hour = int.parse(list![0]);

        if(list.length>1){
          minuto = int.parse(list[1]);
        }

      }
    }catch(e){

    }
    return TimeOfDay(hour: hour, minute: minuto);
  }

  static DateTime timeOfDayDateTime(TimeOfDay timeOfDay){
    final now = new DateTime.now();
    return new DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }

  static indexAlfabetico(index){
    if(index>24)index = 0;// falta validar numeros mayores a 24
    var vobj_abc = [
     "a","b","c","d","e","f","g","h","i",
     "j","k","m","n","ñ","o","p","q",
     "r","s","t","u","v","w","x","y","z",
    ];

    return vobj_abc[index];

  }


}