class AppFormatNumber{


  static String? getFormatCelular(String? number){
    if((number??"").isEmpty)return null;
    number = number?.replaceAll("+51", "");
    return number?.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'), (Match m) => "+51 ${m[1]} ${m[2]} ${m[3]}");
  }

}

