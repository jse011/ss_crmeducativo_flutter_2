import 'package:url_launcher/url_launcher.dart';

class AppUrlLauncher{
  static Future<void> openLink(String? url, {bool webview = false}) async{
    if((url??"").isNotEmpty){
      if (await canLaunch(url!.trim())) {
        await launch(url.trim(),
        forceWebView: webview,
        enableJavaScript: webview
        );
      }
    }
  }


}