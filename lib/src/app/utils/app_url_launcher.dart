import 'package:ss_crmeducativo_2/src/domain/tools/domain_drive_tools.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class AppUrlLauncher{
  static Future<void> openLink(String? url, {bool webview = false}) async{
    if((url??"").isNotEmpty){
      if (await canLaunch(url!.trim())) {
        print("$url");
        bool? forceSafariVC = null;
        if(Platform.isIOS){
          if(url.contains(DriveUrlParser.getUrlDownload(""))){
            forceSafariVC = false;
          }
        }
        await launch(url.trim(),
          forceWebView: webview,
          enableJavaScript: true,
          forceSafariVC: forceSafariVC,
        );
      }
    }
  }


}