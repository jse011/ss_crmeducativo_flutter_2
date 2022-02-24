
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ionicons/ionicons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:ss_crmeducativo_2/libs/fancy_shimer_image/fancy_shimmer_image.dart';
import 'package:ss_crmeducativo_2/src/app/page/eventos_agenda/informacion/evento_informacion_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_system_ui.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_adjunto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:video_player/video_player.dart';
import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
//import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

class EventoInfoSimpleView extends View{
  EventoUi? eventoUi;
  EventoAdjuntoUi? eventoAdjuntoUi;
  EventoInfoSimpleView(this.eventoUi, this.eventoAdjuntoUi);

  @override
  _EventoInfoSimpleState createState() => _EventoInfoSimpleState(eventoUi, eventoAdjuntoUi);

  
}

class _EventoInfoSimpleState extends ViewState<EventoInfoSimpleView, EventoInformacionController>{

  VideoPlayerController? _videoPlayerController1;
  ChewieController? _chewieController;

  late YoutubePlayerController _youtubeController;

  _EventoInfoSimpleState(EventoUi? eventoUi, EventoAdjuntoUi? eventoAdjuntoUi) : super(EventoInformacionController(eventoUi, eventoAdjuntoUi));

  @override
  void initState() {
    super.initState();
    if(widget.eventoAdjuntoUi?.tipoRecursosUi == TipoRecursosUi.TIPO_VIDEO){
      initializePlayer();
    }else if(widget.eventoAdjuntoUi?.tipoRecursosUi == TipoRecursosUi.TIPO_VINCULO_YOUTUBE){
      inizializaYourubePlayer();
    }

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
      initialVideoId: widget.eventoAdjuntoUi?.yotubeId??"",
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
      if (value.isFullScreen) {
        //_youtubeController..hideEndScreen();


      }else{

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
        'https://drive.google.com/uc?export=download&id=${widget.eventoAdjuntoUi?.driveId??""}');
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
  Widget get view => AnnotatedRegion<SystemUiOverlayStyle>(
    value: AppSystemUi.getSystemUiOverlayStyleClaro(),
    child:  ControlledWidgetBuilder<EventoInformacionController>(
        builder: (context, controller) {
          return  Scaffold(
            extendBody: true,
            backgroundColor: AppTheme.black,
            body: Container(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                          child:  controller.eventoAdjuntoUi?.tipoRecursosUi == TipoRecursosUi.TIPO_VIDEO?
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
                          controller.eventoAdjuntoUi?.tipoRecursosUi == TipoRecursosUi.TIPO_VINCULO_YOUTUBE?
                          Center(
                            child: YoutubePlayerControllerProvider(
                                //key: UniqueKey(),
                                controller: _youtubeController,
                                child: YoutubePlayerIFrame(
                                  //aspectRatio: 16 / 9,
                                ),
                            ),
                          ) :
                          FancyShimmerImage(
                            height: double.infinity,
                            width: double.infinity,
                            boxFit: BoxFit.contain,
                            imageUrl: controller.eventoAdjuntoUi?.imagePreview??"",
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
                  Column(
                    children: [
                      Expanded(child: Container()),
                      Container(
                        margin: EdgeInsets.only(top: 8, left: 16, right: 0, bottom: 0),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 0, left: 0, right: 8, bottom: 0),
                              child: Image.asset(AppIcon.img_evento_megusta_1, width: 18, height: 18,),
                            ),
                                (){
                              String megusta = "me gusta";
                              if((controller.eventoUi?.cantLike??0)!=0){
                                megusta =  "${controller.eventoUi?.cantLike??""} me gusta";
                              }else if((controller.eventoUi?.cantLike??0)>1000){
                                megusta += "1k me gusta" ;
                              }
                              return Text(megusta, style: TextStyle( fontSize: 12, color: AppTheme.white),);
                            }(),
                            Expanded(
                              child: Container(),
                            ),
                            Text(controller.eventoUi?.nombreEntidad??'', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle( fontSize: 12, color: AppTheme.white, fontStyle: FontStyle.italic),),
                            Padding(padding: const EdgeInsets.only(right: 16))
                          ],
                        ),
                      ),
                      Container(
                        margin:  const EdgeInsets.only(top: 8, bottom: 0),
                        color: AppTheme.white,
                        height: 1,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                splashColor: AppTheme.nearlyDarkBlue.withOpacity(0.2),
                                onTap: () {

                                },
                                child:
                                Container(
                                  padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 0),
                                  height: 55,
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
                                        child: Image.asset(AppIcon.img_evento_megusta, width: 24, height: 24, color: AppTheme.white,),
                                      ),
                                      Text("Me gusta", style: TextStyle( fontSize: 14, color: AppTheme.white),),
                                    ],
                                  ),
                                )
                            ),
                          ),
                          Expanded(child: Container()),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                splashColor: AppTheme.nearlyDarkBlue.withOpacity(0.2),
                                onTap: () {
                                  if(controller.eventoUi?.fotoEntidad!=null && (controller.eventoUi?.fotoEntidad??"").isNotEmpty){
                                    //_shareImageFromUrl(eventoUi);
                                  }else{
                                    //_shareText(eventoUi);
                                  }
                                },
                                child:
                                Container(
                                  padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 0),
                                  height: 55,
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 0),
                                        child: Image.asset(AppIcon.img_evento_compartir,  width:24, height:24, color: AppTheme.white,),
                                      ),
                                      Text("Compartir", style: TextStyle( fontSize: 14, color: AppTheme.white), ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                        ],
                      ),

                    ],
                  )
                ],
              ),
            ),
          );
        }),
  );

@override
  void dispose() {
  if(Platform.isAndroid){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
  }

  //if (_videoPlayerController1.value.isPlaying) _videoPlayerController1.pause();
  _videoPlayerController1?.dispose();
  _chewieController?.dispose();
  super.dispose();
  //_youtubeController?.dis

  }

}