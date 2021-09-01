import 'package:intl/intl.dart';
import 'dart:math';

class AppTools {
  static String capitalize(String texto) {
    try {
      StringBuffer result = new StringBuffer();
      int count = 0;
      for (String ws in texto.split(" ")) {
        count++;
        if (count > 1) result.write(" ");
        if (ws.length < 2) {
          result.write(ws);
        } else {
          result.write(ws.substring(0, 1).toUpperCase());
          result.write(ws.substring(1).toLowerCase());
        }
      }

      return result.toString();
    } catch (e) {
      return '';
    }
  }

  static String f_fecha_letras(DateTime? timesTamp) {
    String mstr_fecha = "";
    if (timesTamp != null) {
      var vobj_days = ["Dom", "Lun", "Mart", "Mié", "Jue", "Vie", "Sáb"];
      var vobj_Meses = [
        "Ene.",
        "Feb.",
        "Mar.",
        "Abr.",
        "May.",
        "Jun.",
        "Jul.",
        "Ago.",
        "Sept.",
        "Oct.",
        "Nov.",
        "Dic."
      ];

      int year = timesTamp.year;
      int month = timesTamp.month; // Jan = 0, dec = 11
      int dayOfMonth = timesTamp.day;
      int dayOfWeek = timesTamp.weekday;
      mstr_fecha =
          vobj_days[dayOfWeek - 1] + " " + dayOfMonth.toString() + " de " +
              vobj_Meses[month - 1];
    }
    return mstr_fecha;
  }

  static DateTime convertDateTimePtBR(String? fecha, String? hora) {
    DateTime parsedDate = DateTime.parse('0001-11-30 00:00:00.000');
    try {
      String day = "0001";
      String month = "11";
      String year = "30";

      List<String>? validadeSplit = fecha?.split('/');

      if (validadeSplit != null && validadeSplit.length > 1) {
        day = validadeSplit[0].toString();
        month = validadeSplit[1].toString();
        year = validadeSplit[2].toString();
      }

      if (hora != null && hora.length > 0) {
        parsedDate = DateTime.parse('$year-$month-$day $hora');
      } else {
        parsedDate = DateTime.parse('$year-$month-$day 00:00:00.000');
      }
    } catch (e) {
      print("Error al convertir string to DateTime" +
          (fecha != null ? fecha : "") + " " + (hora != null ? hora : ""));
    }

    return parsedDate;
  }

  static DateTime convertDateTimePtBR2(int? fecha, String? hora) {
    DateTime parsedDate = DateTime.parse('0001-11-30 00:00:00.000');
    try {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(fecha ?? 1995);

      String day = dateTime.day.toString();
      String month = dateTime.month.toString();
      String year = dateTime.year.toString();

      if (hora != null && hora.length > 0) {
        parsedDate = DateTime.parse('$year-$month-$day $hora');
      } else {
        parsedDate = dateTime;
      }
    } catch (e) {
      print("Error al convertir string to DateTime ${fecha ?? 0} " +
          (hora != null ? hora : ""));
    }

    return parsedDate;
  }

  static String tiempoFechaCreacion(DateTime? fecha) {
    if (fecha != null) {
      try {
        DateTime calendarActual = DateTime.now();
        int anhoActual = calendarActual.year;
        int mesActual = calendarActual.month;
        int diaActual = calendarActual.day;

        int anhio = fecha.year;
        int mes = fecha.month;
        int dia = fecha.day;
        int hora = fecha.hour;
        int minuto = fecha.minute;

        calendarActual.add(new Duration(days: 1));


        int anioManiana = calendarActual.year;
        int mesManiana = calendarActual.month;
        int diaManiana = calendarActual.day;

        if (anhio == anhoActual && mesActual == mes && dia == diaActual) {
          if (hora == 0 && minuto == 0) {
            return "para hoy";
          } else {
            return "para hoy a las " + changeTime12Hour(hora, minuto);
          }
        } else
        if (anhio == anioManiana && mesManiana == mes && dia == diaManiana) {
          if (hora == 0 && minuto == 0) {
            return "para mañana";
          } else {
            return "para mañana a las " +
                changeTime12Hour(fecha.hour, fecha.minute);
          }
        } else if (anhio == anhoActual) {
          if (hora == 0 && minuto == 0) {
            return "para el " + f_fecha_letras(fecha);
          } else {
            return "para el " + f_fecha_letras(fecha) + " " +
                changeTime12Hour(fecha.day, fecha.minute);
          }
        } else {
          if (hora == 0 && minuto == 0) {
            return "para el " + getFechaDiaMesAnho(fecha);
          } else {
            return "para el " + getFechaDiaMesAnho(fecha) + " " +
                changeTime12Hour(fecha.day, fecha.minute);
          }
        }
      } catch (e) {
        return "";
      }
    } else {
      return "";
    }
  }

  static String changeTime12Hour(int hr, int min) {
    return "${hr % 12}:${min} ${((hr >= 12) ? "PM" : "AM")}";
  }

  static String getFechaDiaMesAnho(DateTime? fecha) {
    return fecha != null ? DateFormat("d MMM yyyy").format(fecha) : "";
  }

  static int calcularEdad(DateTime? fecha) {
    DateTime hoy = DateTime.now();
    DateTime cumpleanos = fecha ?? DateTime(1900);
    var edad = hoy.year - cumpleanos.year;
    var m = hoy.month - cumpleanos.month;

    if (m < 0 || (m == 0 && hoy.day < cumpleanos.day)) {
      edad--;
    }

    return edad;
  }

  static String f_fecha_anio_mes_letras(DateTime? timesTamp) {
    String mstr_fecha = "";
    timesTamp = timesTamp ?? DateTime(1900);
    var vobj_Meses = [
      "enero",
      "febrero",
      "marzo",
      "abril",
      "Mayo",
      "Junio",
      "Julio",
      "Agosto",
      "Septiembre",
      "Octubre",
      "Noviembre",
      "Diciembre"
    ];

    int year = timesTamp.year;
    int month = timesTamp.month; // Jan = 0, dec = 11
    int dayOfMonth = timesTamp.day;
    int dayOfWeek = timesTamp.weekday;
    mstr_fecha = dayOfMonth.toString() + " de " + vobj_Meses[month - 1] + " " +
        timesTamp.year.toString();
    //47 años (19 de noviembre 1970)
    return mstr_fecha;
  }

  /**
   * a = valor minimo del origen
   * b = valor maximo del origen
   * x = valor a transformar
   * c = valor minimo transformado
   * d = valor maximo transformado
   */
  static double transformacionInvariante(double a, double b, double x, double c,
      double d) {
    try {
      double t = (1 - ((b - x) / (b - a))) * (d - c);
      //Log.d(TAG, "notaTransformada: " + "1 - ((" + b + "-" + x + ")/(" + b + "-" + a + "))) * (" + d + " - " + c + ") = " + t);
      return t;
    } catch (e) {
      return 0.0;
    }
  }

  static double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }


  static double promedio(List<double> notas){
    double promedio = 0.0;
    for(double nota in notas){
      promedio += nota/notas.length;
    }
    return promedio;
  }

  static double desviacionEstandar(List<double> notas){
    double promedio = 0.0;
    for(double nota in notas){
      promedio += nota/notas.length;
    }
    double sum = 0.0;
    int i;
    int n = notas.length;
    for (i = 0; i < n; i++){
      sum += pow( notas[i]- promedio, 2);
    }
    return sqrt(sum / n);
  }

}