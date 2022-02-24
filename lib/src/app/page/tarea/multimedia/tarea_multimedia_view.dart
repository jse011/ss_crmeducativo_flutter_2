
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ss_crmeducativo_2/libs/fancy_shimer_image/fancy_shimmer_image.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_system_ui.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_youtube_tools.dart';
import 'package:video_player/video_player.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
//import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class TareaMultimediaView extends StatefulWidget{

  TareaMultimediaTipoArchivo? tipoArchivo;
  String? id;


  TareaMultimediaView(this.id, this.tipoArchivo);

  @override
  _TareaMultimediaViewState createState() => _TareaMultimediaViewState();


  static Future<dynamic?> showDialog(BuildContext context,  String? id, TareaMultimediaTipoArchivo? tipoArchivo){
    return showGeneralDialog(
      context: context,
      barrierColor: Colors.black12.withOpacity(0.6), // Background color
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      transitionDuration: Duration(milliseconds: 400), // How long it takes to popup dialog after button click
      pageBuilder: (context, animation, secondaryAnimation) {
        return SizedBox.expand(
          child: TareaMultimediaView(id, tipoArchivo),
        );
      },
    );
  }

}

class _TareaMultimediaViewState extends State<TareaMultimediaView>{

  VideoPlayerController? _videoPlayerController1;
  ChewieController? _chewieController;

  late YoutubePlayerController _youtubeController;



  @override
  void initState() {
    super.initState();
    if(widget.tipoArchivo == TareaMultimediaTipoArchivo.DRIVE){
      initializePlayer();
    }else{
      inizializaYourubePlayer();
    }
    /*SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]
    );*/
    if(Platform.isAndroid) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp
      ]);
    }
  }

  inizializaYourubePlayer(){
    _youtubeController = YoutubePlayerController (
      initialVideoId: widget.id??"",
      params: YoutubePlayerParams(
        //playlist: ['nPt8bK2gbaU', 'gQDByCdjUXw'], // Defining custom playlist
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        autoPlay: true,
        enableCaption: true,
        showVideoAnnotations: false,
        enableJavaScript: true,
        privacyEnhanced: true,
        useHybridComposition: true,
        playsInline: false,
      ),
    )..listen((value) {
      print(_youtubeController.value.position);
      if (value.isReady && !value.hasPlayed) {
        _youtubeController
          ..hidePauseOverlay()
          ..play()
          ..hideTopMenu();
      }
      if (value.hasPlayed) {
        //_youtubeController..hideEndScreen();
      }
    });

    _youtubeController.onEnterFullscreen = ()async{

      if(Platform.isAndroid){
        await Future.delayed(const Duration(milliseconds: 1000));
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
      }
    };

    _youtubeController.onExitFullscreen = () async{
      if(Platform.isAndroid) {
        await Future.delayed(const Duration(milliseconds: 300));
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.portraitDown,
          DeviceOrientation.portraitUp
        ]);
      }
    };

  }

  Future<void> initializePlayer() async {

    _videoPlayerController1 = VideoPlayerController.network(
        'https://drive.google.com/uc?export=download&id=${widget.id??""}');
    await Future.wait([
      _videoPlayerController1!.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    // final subtitles = [
    //     Subtitle(
    //       index: 0,
    //       start: Duration.zero,
    //       end: const Duration(seconds: 10),
    //       text: 'Hello from subtitles',
    //     ),
    //     Subtitle(
    //       index: 0,
    //       start: const Duration(seconds: 10),
    //       end: const Duration(seconds: 20),
    //       text: 'Whats up? :)',
    //     ),
    //   ];

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1!,
      autoPlay: true,
      looping: true,
      aspectRatio:  16/9,
      materialProgressColors: ChewieProgressColors(),
      cupertinoProgressColors: ChewieProgressColors(),
      showControls: true,
/*
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
          text: subtitle,
        )
            : Text(
          subtitle.toString(),
          style: const TextStyle(color: Colors.black),
        ),
      ),
*/
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.getSystemUiOverlayStyleClaro(),
      child:  Scaffold(
        extendBody: true,
        backgroundColor: AppTheme.black,
        body: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child:  widget.tipoArchivo == TareaMultimediaTipoArchivo.DRIVE?
                    Center(
                      child:  AspectRatio(
                        aspectRatio: 16/9,
                        child:  _chewieController != null &&
                            _chewieController!
                                .videoPlayerController.value.isInitialized
                            ? Chewie(
                          controller: _chewieController!,
                        )
                            : Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            CircularProgressIndicator(
                              color: AppTheme.red,
                            ),
                            SizedBox(height: 20),
                            Text('Cargando...', style: TextStyle(
                                color: AppTheme.white
                            ),),
                          ],
                        )),
                      ),
                    ) :
                    widget.tipoArchivo == TareaMultimediaTipoArchivo.YOUTUBE?
                    Center(
                      child: YoutubePlayerControllerProvider(
                        //key: UniqueKey(),
                        controller: _youtubeController,
                        child: YoutubePlayerIFrame(

                        ),
                      ),
                    ) :
                    FancyShimmerImage(
                      height: double.infinity,
                      width: double.infinity,
                      boxFit: BoxFit.contain,
                      imageUrl: YouTubeThumbnail.getUrlFromVideoId(widget.id, Quality.MEDIUM),
                      imageBuilder: (context, imageProvider) {
                        return PhotoView(
                          imageProvider: imageProvider,

                        );
                      },
                      errorWidget: Icon(Icons.warning_amber_rounded, color: AppTheme.white, size: 105,),
                    ),
                  ),
                  Container(
                    height: context.isLandscape?65:0,
                  )
                ],
              ),
              Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop(true);
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      child: Center(
                        child: Icon(Icons.arrow_back, color: AppTheme.white, size: 28,),
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }


@override
  void dispose() {

  //if (_videoPlayerController1.value.isPlaying) _videoPlayerController1.pause();
  _videoPlayerController1?.dispose();
  _chewieController?.dispose();
  super.dispose();
  //_youtubeController?.dis

  }



}

enum TareaMultimediaTipoArchivo{
  DRIVE, YOUTUBE
}