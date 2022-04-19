import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';

class DomainTools {
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
      var vobj_days = [ "Lun", "Mart", "Mié", "Jue", "Vie", "Sáb","Dom"];//Solo para flutter el dom es 7
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
    print('fecha: $fecha');
    print('hora: $hora');
    try {
      String day = "01";
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
          (fecha != null ? fecha : "") + " " + (hora != null ? hora : "")+ " ${e.toString()}");
    }

    return parsedDate;
  }

  static DateTime convertDateTimePtBR2(int? fecha, String? hora) {
    DateTime parsedDate = DateTime.parse('0001-11-30 00:00:00.000');
    try {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(fecha ?? 1995);

      String day = dateTime.day.toString();
      String month = "${(dateTime.month>9)?"":"0"}${dateTime.month}";
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

  static String dataTimeHourMinute(DateTime dateTime){
    return "${dateTime.hour}:${dateTime.minute}";
  }

  static String tiempoFechaCreacionAgenda(DateTime? fecha) {
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
                changeTime12Hour(hora, minuto);
          }
        } else if (anhio == anhoActual) {
          if (hora == 0 && minuto == 0) {
            return "para el " + f_fecha_letras(fecha);
          } else {
            return "para el " + f_fecha_letras(fecha) + " " +
                changeTime12Hour(hora, minuto);
          }
        } else {
          if (hora == 0 && minuto == 0) {
            return "para el " + getFechaDiaMesAnho(fecha);
          } else {
            return "para el " + getFechaDiaMesAnho(fecha) + " " +
                changeTime12Hour(hora, minuto);
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
    //print("tiempoFechaCreacionTarea: ${hr} ${min}");
    String format_min = "";
    if(min<10){
      format_min = "0${min}";
    }else {
      format_min =  "${min}";
    }
    String s =  "${hr==12?"12":hr%12}:${format_min} ${((hr>=12) ? "p.m." : "a.m.")}";

    return s;
  }

  static String changeTime12HourSecons(int hr, int min, int secons) {
    String format_min = "";
    String format_secons = "";
    if(min<10){
      format_min = "0${min}";
    }else {
      format_min =  "${min}";
    }
    if(secons<10){
      format_secons = "0${secons}";
    }else {
      format_secons =  "${secons}";
    }
    String s =  "${hr==12?"12":hr%12}:${format_min}:${format_secons} ${((hr>=12) ? "p.m." : "a.m.")}";

    return s;
  }

  static String tiempoFechaCreacionTarea(DateTime? fecha) {
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
          if ((hora == 0) && minuto == 0) {
            return "Para hoy";
          } else {
            return "Para hoy a las " + changeTime12Hour(hora, minuto);
          }
        } else
        if (anhio == anioManiana && mesManiana == mes && dia == diaManiana) {
          if ((hora == 0) && minuto == 0) {
            return "Para mañana";
          } else {
            return "Para mañana a las " +
                changeTime12Hour(hora, minuto);
          }
        } else if (anhio == anhoActual) {
          if ((hora == 0) && minuto == 0) {
            return "Para el " + f_fecha_letras(fecha);
          } else {
            return "Para el " + f_fecha_letras(fecha) +" " +
                changeTime12Hour(hora, minuto);
          }
        } else {
          if ((hora == 0) && minuto == 0) {
            return "Para el " + getFechaDiaMesAnho(fecha);
          } else {
            return "Para el " + getFechaDiaMesAnho(fecha) +" " +
                changeTime12Hour(hora, minuto);
          }
        }
      } catch (e) {
        return "";
      }
    } else {
      return "";
    }
  }

  static String getFechaDiaMesAnho(DateTime? fecha) {
    return fecha != null ? DateFormat("d MMM yyyy").format(fecha) : "";
  }

  static String getFechaDiaMesAnhoSimple(DateTime? fecha) {
    return fecha != null ? DateFormat("dd/MM/yyyy").format(fecha) : "";
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
  static double? transformacionInvariante(double a, double b, double? x, double c, double d) {
    if(x == null)return null;
    try {
      double t = (1 - ((b - x) / (b - a))) * (d - c);
      //Log.d(TAG, "notaTransformada: " + "1 - ((" + b + "-" + x + ")/(" + b + "-" + a + "))) * (" + d + " - " + c + ") = " + t);
      return t;
    } catch (e) {
      return null;
    }
  }

  static double roundDouble(double value, int places) {
    //num mod = math.pow(10.0, places+1);
    //value = ((value * mod).round().toDouble() / mod);
    //return ((value * mod).round().toDouble() / mod);
    //return value.toPrecision(places);
    //return _roundToDecimals(value, places);
    //return double.parse((value).toStringAsFixed(places));
    return _roundDouble(_roundDouble(value, places+1), places);
  }

  static double _roundDouble(double value, int places) {
    num mod = math.pow(10.0, places);
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
      sum += math.pow( notas[i]- promedio, 2);
    }
    return math.sqrt(sum / n);
  }

  static String? removeDecimalZeroFormat(double? n, {int fractionDigits = 1}) {
    if(fractionDigits==1){
      print("nota decimal: ${n}");
    }
    n = (n != null? roundDouble(n,fractionDigits) : null);

    if(fractionDigits == 1){
      print("nota decimal round: ${n}");
    }
    //n = (n != null? double.parse(n.toStringAsFixed(fractionDigits)) : null);
    RegExp regex = RegExp(r"([.]*0)(?!.*\d)");
    return n != null ? n.toString().replaceAll(regex, "") : null;

  }

   static String? getDocumentId(String docIDfull) {
    int docIDstart = docIDfull.indexOf("/d/");
    int DocIDend = docIDfull.indexOf('/', docIDstart + 3);
    String? docID = null;
    if (docIDstart == -1) {
      //Invalid URL readonly
      return null;
    }
    if (DocIDend == -1) {
      docID = docIDfull.substring(docIDstart + 3);
    }
    else {
      docID = docIDfull.substring(docIDstart + 3, DocIDend);
    }

    return docID;
  }

  static TipoRecursosUi getType(String? path){
    String extencion = path?.toLowerCase()??"";
    if (extencion.contains(".doc") || extencion.contains(".docx")) {
      // Word document
      return TipoRecursosUi.TIPO_DOCUMENTO;
    } else if (extencion.contains(".pdf")) {
      // PDF file
      return TipoRecursosUi.TIPO_PDF;
    } else if (extencion.contains(".ppt") || extencion.contains(".pptx")) {
      // Powerpoint file
      return TipoRecursosUi.TIPO_DIAPOSITIVA;
    } else if (extencion.contains(".xls") || extencion.contains(".xlsx")||extencion.contains(".csv")) {
      // Excel file
      return TipoRecursosUi.TIPO_HOJA_CALCULO;
    } else if (extencion.contains(".zip") || extencion.contains(".rar")) {
      // WAV audio file
      return TipoRecursosUi.TIPO_RECURSO;
    } else if (extencion.contains(".rtf")) {
      // RTF file
      return TipoRecursosUi.TIPO_RECURSO;
    } else if (extencion.contains(".wav") || extencion.contains(".mp3")) {
      // WAV audio file
      return TipoRecursosUi.TIPO_AUDIO;
    } else if (extencion.contains(".gif")) {
      // GIF file
      return TipoRecursosUi.TIPO_IMAGEN;
    } else if (extencion.contains(".jpg") || extencion.contains(".jpeg") || extencion.contains(".png")) {
      // JPG file
      return TipoRecursosUi.TIPO_IMAGEN;
    } else if (extencion.contains(".txt")) {
      // Text file
      return TipoRecursosUi.TIPO_DOCUMENTO;
    } else if (extencion.contains(".3gp") || extencion.contains(".mpg") || extencion.contains(".mpeg") || extencion.contains(".mpe") || extencion.contains(".mp4") || extencion.contains(".avi")) {
      // Video files
      return TipoRecursosUi.TIPO_VIDEO;
    } else {
      // Other files
      return TipoRecursosUi.TIPO_RECURSO;
    }
  }

  static Map<String, dynamic> removeNull(Map<String, dynamic> map) {
    map.removeWhere((key, value) => key == null || value == null);
    return map;
  }

  static bool esValidaUrl(String? value) {
    String pattern = r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = new RegExp(pattern);
    if ((value?.length??0) == 0) {
      return false;
    }
    else if (!regExp.hasMatch(value!)) {
      return false;
    }
    return true;
  }

  static String? getNombreDia(int? day) {
    var vobj_days = ["Dom", "Lun", "Mart", "Mié", "Jue", "Vie", "Sáb"];
    try{
      return vobj_days[(day??0)-1];
    } catch(e){
      return null;
    }

  }

  static String? getNombreMes(int? month) {
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

    try{
      return vobj_Meses[(month??0)-1];
    } catch(e){
      return null;
    }
  }

}
