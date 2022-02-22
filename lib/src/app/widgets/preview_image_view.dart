import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
//import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
//import 'package:smart_text_view/smart_text_view.dart';
import 'package:url_launcher/url_launcher.dart';

class PreviewImageView extends StatefulWidget {
  final String? image;

  PreviewImageView(this.image);

  @override
  _PreviewImageViewState createState() => _PreviewImageViewState();

  static Route createRoute(String? image) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PreviewImageView(image),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class _PreviewImageViewState extends State<PreviewImageView> {
  bool widgetImage = false;
  bool showContent = true;
  @override
  Widget build(BuildContext context) {
    //Widget widgetImage = Container();
    return Container(
        color: Colors.black.withOpacity(0.7),
        child: Scaffold(
            backgroundColor: Colors.transparent,
          body:  Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                if((widget.image??"").isNotEmpty)
                  PhotoView(
                  imageProvider: CachedNetworkImageProvider(widget.image??''),
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),

                ),
                Positioned(
                  top: 8,
                  left: 16,
                  child: InkWell(
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.arrow_back, color: AppTheme.white,),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.black.withOpacity(0.4)),
                    ),
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                  ),
                )

              ],
            ),
          ),
        )
    );
  }



}

