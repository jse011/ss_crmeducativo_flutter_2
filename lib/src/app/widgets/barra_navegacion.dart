import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';

class DrawerUserController extends StatefulWidget {
  const DrawerUserController({
    Key? key,
    this.drawerWidth = 250,
    required this.screenView,
    this.animatedIconData = AnimatedIcons.arrow_menu,
    this.menuView,
    required this.menuListaView,
    required this.drawerIsOpen,
    required this.onTapImagePerfil,
    this.nameUser,
    this.photoUser,
    this.correo,
    required this.closeMenuCallback,
    required this.onClickCerrarCession
  }) : super(key: key);

  final double drawerWidth;
  final Widget screenView;
  final Function(bool) drawerIsOpen;
  final Function() onTapImagePerfil;
  final AnimatedIconData animatedIconData;
  final Widget? menuView;
  final String? nameUser;
  final String? photoUser;
  final String? correo;
  final Function onClickCerrarCession;
  final CloseSesionCallback closeMenuCallback;

  final Widget menuListaView;
  @override
  _DrawerUserControllerState createState() => _DrawerUserControllerState();
}

class _DrawerUserControllerState extends State<DrawerUserController> with TickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController iconAnimationController;
  late AnimationController animationController;
  GlobalKey menuScrollViewKey = GlobalKey();
  double scrolloffset = 0.0;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    iconAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 0));
    iconAnimationController..animateTo(1.0, duration: const Duration(milliseconds: 0), curve: Curves.fastOutSlowIn);
    scrollController = ScrollController(initialScrollOffset: widget.drawerWidth);

    scrollController
      ..addListener(() {
        if (scrollController.offset <= 0) {
          if (scrolloffset != 1.0) {
            setState(() {
              scrolloffset = 1.0;
              try {
                widget.drawerIsOpen(true);
              } catch (_) {}
            });
          }
          iconAnimationController.animateTo(0.0, duration: const Duration(milliseconds: 0), curve: Curves.fastOutSlowIn);
        } else if (scrollController.offset > 0 && scrollController.offset < widget.drawerWidth.floor()) {
          iconAnimationController.animateTo((scrollController.offset * 100 / (widget.drawerWidth)) / 100,
              duration: const Duration(milliseconds: 0), curve: Curves.fastOutSlowIn);
        } else {
          if (scrolloffset != 0.0) {
            setState(() {
              scrolloffset = 0.0;
              try {
                widget.drawerIsOpen(false);
              } catch (_) {}
            });
          }
          iconAnimationController.animateTo(1.0, duration: const Duration(milliseconds: 0), curve: Curves.fastOutSlowIn);
        }
      });

    widget.closeMenuCallback.call((){
      onDrawerClick();
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) => getInitState());
    super.initState();
  }

  Future<bool> getInitState() async {
    scrollController.jumpTo(
      widget.drawerWidth,
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return true;
        },
        child: SingleChildScrollView(
          key: menuScrollViewKey,
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          physics: PageScrollPhysics(parent: ClampingScrollPhysics()),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width + widget.drawerWidth,
            //we use with as screen width and add drawerWidth (from navigation_home_screen)
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: widget.drawerWidth,
                  //we divided first drawer Width with HomeDrawer and second full-screen Width with all home screen, we called screen View
                  height: MediaQuery.of(context).size.height,
                  child: AnimatedBuilder(
                    animation: iconAnimationController,
                    builder: (context, child) {
                      return Transform(
                        //transform we use for the stable drawer  we, not need to move with scroll view
                        transform: Matrix4.translationValues(scrollController.offset, 0.0, 0.0),
                        child: Scaffold(
                          backgroundColor: AppTheme.notWhite.withOpacity(0.4),
                          body: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(top: 40.0),
                                        child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              AnimatedBuilder(
                                                animation: iconAnimationController,
                                                builder: (BuildContext? context, Widget? child) {
                                                  return ScaleTransition(
                                                    scale: AlwaysStoppedAnimation<double>(1.0 - (iconAnimationController.value) * 0.2),
                                                    child: RotationTransition(
                                                      turns: AlwaysStoppedAnimation<double>(Tween<double>(begin: 0.0, end: 24.0)
                                                          .animate(CurvedAnimation(parent: iconAnimationController, curve: Curves.fastOutSlowIn))
                                                          .value /
                                                          360),
                                                      child: Center(
                                                        child: InkWell(
                                                          onTap: (){
                                                           widget.onTapImagePerfil.call();
                                                          },
                                                          child: Container(
                                                            height: 110,
                                                            width: 110,
                                                            padding: EdgeInsets.all(2),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: AppTheme.white,
                                                              boxShadow: <BoxShadow>[
                                                                BoxShadow(color: AppTheme.grey.withOpacity(0.6), offset: const Offset(2.0, 4.0), blurRadius: 8),
                                                              ],
                                                            ),
                                                            child: widget.photoUser!=null?
                                                            CachedNetworkImage(
                                                              placeholder: (context, url) => CircularProgressIndicator(),
                                                              imageUrl: widget.photoUser??'',
                                                              errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                                              imageBuilder: (context, imageProvider) => Container(
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    image: DecorationImage(
                                                                      image: imageProvider,
                                                                      fit: BoxFit.cover,
                                                                    ),

                                                                  )
                                                              ),
                                                            ):
                                                            Container(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8, left: 0),
                                                child: Center(
                                                  child: Text(
                                                    widget.nameUser??'',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontTTNorms,
                                                      fontWeight: FontWeight.w900,
                                                      color: AppTheme.darkerText,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              (widget.correo??"").isNotEmpty?
                                              Padding(
                                                padding: const EdgeInsets.only(top: 0, left: 0),
                                                child: Center(
                                                  child: Text(
                                                    widget.correo??"",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: AppTheme.grey,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ):Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Divider(
                                        height: 1,
                                        color: AppTheme.grey.withOpacity(0.6),
                                      ),
                                      widget.menuListaView,
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: AppTheme.grey.withOpacity(0.6),
                              ),
                              Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      'Cerrar Sesión',
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: AppTheme.darkText,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    trailing: Icon(
                                      Icons.power_settings_new,
                                      color: Colors.red,
                                    ),
                                    onTap: () {
                                      widget.onClickCerrarCession();
                                    },
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).padding.bottom,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  //full-screen Width with widget.screenView
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(color: AppTheme.grey.withOpacity(0.6), blurRadius: 24),
                      ],
                    ),
                    child: Stack(
                      children: <Widget>[
                        //this IgnorePointer we use as touch(user Interface) widget.screen View, for example scrolloffset == 1 means drawer is close we just allow touching all widget.screen View
                        IgnorePointer(
                          ignoring: scrolloffset == 1 || false,
                          child: widget.screenView,
                        ),
                        //alternative touch(user Interface) for widget.screen, for example, drawer is close we need to tap on a few home screen area and close the drawer
                        if (scrolloffset == 1.0)
                          InkWell(
                            onTap: () {
                              onDrawerClick();
                            },
                          ),
                        // this just menu and arrow icon animation
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, left: 8),
                          child: SizedBox(
                            width: AppBar().preferredSize.height - 8,
                            height: AppBar().preferredSize.height - 8,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
                                child: Center(
                                  // if you use your own menu view UI you add form initialization
                                  child: widget.menuView != null
                                      ? widget.menuView
                                      : AnimatedIcon(
                                      icon: widget.animatedIconData != null ? widget.animatedIconData : AnimatedIcons.arrow_menu,
                                      progress: iconAnimationController),
                                ),
                                onTap: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  onDrawerClick();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),),
    );
  }

  void onDrawerClick() {
    //if scrollcontroller.offset != 0.0 then we set to closed the drawer(with animation to offset zero position) if is not 1 then open the drawer
    if (scrollController.offset != 0.0) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      scrollController.animateTo(
        widget.drawerWidth,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    }
  }
}

typedef CloseSesionCallback = void Function(Function closeMenu);
