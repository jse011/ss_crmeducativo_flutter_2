import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/close_sesion.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_format_number.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/animation_view.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/custom_expansion_tile.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/search_bar.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'contactos_controller.dart';

class ContactosView extends View{
  final AnimationController animationController;
  final MenuBuilder? menuBuilder;
  final CloseSession closeSessionHandler;

  ContactosView({required this.animationController, this.menuBuilder, required this.closeSessionHandler});

  @override
  _ContactosViewState createState() => _ContactosViewState();

}

class _ContactosViewState extends ViewState<ContactosView, ContactosController> with SingleTickerProviderStateMixin{
  late Animation<double> topBarAnimation;
  final ScrollController scrollController = ScrollController();
  ValueNotifier<Key?> _expanded = ValueNotifier(null);
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  GlobalKey search = GlobalKey();

  final _debouncer = Debouncer(milliseconds: 500);
  List<dynamic>? filteredAlumnos = null;
  List<dynamic>? filteredDocentes = null;
  List<dynamic>? filteredDirectivos = null;

  _ContactosViewState() : super(ContactosController(MoorConfiguracionRepository()));

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));


    widget.animationController.reset();

    Future.delayed(const Duration(milliseconds: 300), () {
// Here you can write your code
      setState(() {
        widget.animationController.forward();
      });}

      );

    super.initState();
    _controller = TextEditingController()..addListener(_onTextChanged);
    _focusNode = FocusNode();
  }

  @override
  Widget get view => ControlledWidgetBuilder<ContactosController>(
      builder: (context, controller){
        SchedulerBinding.instance?.addPostFrameCallback((_) {
          widget.menuBuilder?.call(getMenuView(controller));
        });
        return  WillPopScope(
            onWillPop: () async {
          return await widget.closeSessionHandler.closeSession()??false;
        },
          child: Container(
            color: AppTheme.background,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: <Widget>[
                  getAppBarUI(),
                  getMainTab(),
                  ControlledWidgetBuilder<ContactosController>(
                      builder: (context, controller){
                        return Container();
                      }
                  )
                ],
              ),
            ),
          ),
        );
      });

  Widget getAppBarUI() {
    return Container(
      color: AppTheme.white,
      child: Column(
        children: <Widget>[
          AnimatedBuilder(
            animation: widget.animationController,
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: topBarAnimation,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(0.0),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppTheme.grey
                                .withOpacity(0),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 550
                            ),
                            child:  Column(
                              children: <Widget>[
                                SizedBox(
                                  height: MediaQuery.of(context).padding.top,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 48,
                                      right: 24,
                                      top: 8 ,
                                      bottom: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'Contactos',
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: AppTheme.fontTTNorms,
                                            fontWeight: FontWeight.w900,
                                            fontSize: ColumnCountProvider.aspectRatioForWidthContactos(context, 16),
                                            letterSpacing: 1.2,
                                            color: AppTheme.darkerText,
                                          ),
                                        ),
                                      ),
                                      Expanded(child: _buildSearchBox())
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget getMainTab() {
    return   AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: topBarAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
            child: ControlledWidgetBuilder<ContactosController>(
                builder: (context, controller){
                  return  Stack(
                    children: [
                      Container(
                          padding: EdgeInsets.only(
                            top:
                            AppBar().preferredSize.height +
                                MediaQuery.of(context).padding.top +
                                0,
                          ),
                          child: DefaultTabController(
                            length: 3,
                            child: SizedBox(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 550
                                    ),
                                    color: AppTheme.white,
                                    padding: EdgeInsets.only(
                                        left: ColumnCountProvider.aspectRatioForWidthContactos(context, 24),
                                        right: ColumnCountProvider.aspectRatioForWidthContactos(context, 24)
                                    ),
                                    height: ColumnCountProvider.aspectRatioForWidthContactos(context, 50),
                                    child: TabBar(
                                      labelColor: AppTheme.colorPrimary,
                                      //physics: AlwaysScrollableScrollPhysics(),
                                      indicatorColor: AppTheme.colorPrimary,
                                      indicatorWeight: 1,
                                      tabs: [
                                        Tab(child: Text("Alumnos", style: TextStyle(fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w700, fontSize: ColumnCountProvider.aspectRatioForWidthContactos(context, 16))),),
                                        Tab(child: Text("Profesores", style: TextStyle(fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w700, fontSize: ColumnCountProvider.aspectRatioForWidthContactos(context, 16)))),
                                        Tab(child: Text("Directivos", style: TextStyle(fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w700, fontSize: ColumnCountProvider.aspectRatioForWidthContactos(context, 16))),),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: AppTheme.white.withOpacity(0.5),
                                      child: TabBarView(
                                        children: [
                                          ListView.builder(
                                              padding: EdgeInsets.only(top: 4, bottom: 180),
                                              itemCount: filteredAlumnos!=null?filteredAlumnos?.length:controller.companieroList.length,
                                              itemBuilder: (BuildContext ctxt, int index) {
                                                dynamic o = filteredAlumnos!=null?filteredAlumnos![index]:controller.companieroList[index];
                                                if(o is String){
                                                  return Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 550
                                                    ),
                                                    padding: const EdgeInsets.only(left: 24, right: 0, top: 8, bottom: 8),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 0, right: 5, top: 0),
                                                          child: Text(o,
                                                              style: TextStyle(
                                                                  color: AppTheme.colorPrimary,
                                                                  fontSize: 14,
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  fontWeight: FontWeight.w900
                                                              )
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets.only(left: 8, right: 32),
                                                              color: AppTheme.colorPrimary,
                                                              height: 0.5,
                                                            )
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }else if(o is ContactoUi){
                                                  ContactoUi contactoUi = o;
                                                  return Theme(
                                                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                                    child: CustomExpansionTile(
                                                      expandedItem: _expanded,
                                                      key: Key("${contactoUi.personaUi?.personaId}"),
                                                      title: Container(
                                                        constraints: BoxConstraints(
                                                            maxWidth: 550
                                                        ),
                                                        padding: EdgeInsets.only(left: 16, right: 0, top: 0, bottom: 0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(contactoUi.personaUi?.nombreCompleto??"",
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                    fontSize: ColumnCountProvider.aspectRatioForWidthContactos(context, 15),
                                                                    color: AppTheme.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontFamily: AppTheme.fontTTNorms
                                                                )
                                                            ),
                                                            Padding(padding: EdgeInsets.all(2)),
                                                            Text("${AppFormatNumber.getFormatCelular((contactoUi.personaUi?.telefono??"").isEmpty?contactoUi.apoderadoTelfono:contactoUi.personaUi?.telefono)??"Sin número celular o teléfono"}",
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                    fontSize: ColumnCountProvider.aspectRatioForWidthContactos(context, 14),
                                                                    color: AppTheme.colorPrimary,
                                                                    fontWeight: FontWeight.w400
                                                                )
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      trailing: Container(
                                                        height: 10,
                                                        width: 10,
                                                      ),
                                                      leading: CachedNetworkImage(
                                                          height: ColumnCountProvider.aspectRatioForWidthContactos(context, 50),
                                                          width: ColumnCountProvider.aspectRatioForWidthContactos(context, 50),
                                                          placeholder: (context, url) => Center(
                                                            child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.colorPrimary),
                                                          ),
                                                          imageUrl: contactoUi.personaUi?.foto??'',
                                                          imageBuilder: (context, imageProvider) =>
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                                                    image: DecorationImage(
                                                                      image: imageProvider,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  )
                                                              )
                                                      ),
                                                      children: [
                                                        Container(
                                                          height: 60,
                                                          color: AppTheme.background,
                                                          padding: const EdgeInsets.only(left:  40, right: 28),
                                                          child: Row(
                                                            children: [
                                                              if((contactoUi.personaUi?.telefono??"").isNotEmpty)
                                                                Expanded(
                                                                    child: Material(
                                                                      color: Colors.transparent,
                                                                      child: InkWell(
                                                                          focusColor: Colors.transparent,
                                                                          highlightColor: Colors.transparent,
                                                                          hoverColor: Colors.transparent,
                                                                          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                                          splashColor: AppTheme.colorPrimary.withOpacity(0.2),
                                                                          onTap: () {
                                                                            if((contactoUi.personaUi?.telefono??"").isNotEmpty){
                                                                              launch("tel://${contactoUi.personaUi?.telefono}");
                                                                            }else{
                                                                              Fluttertoast.showToast(
                                                                                  msg: "Compañero sin número",
                                                                                  toastLength: Toast.LENGTH_SHORT,
                                                                                  gravity: ToastGravity.BOTTOM,
                                                                                  timeInSecForIosWeb: 1
                                                                              );
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                            child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Icon(Icons.call, size: 24, color: Color(0xFF6FBD53),),
                                                                                Text("Alumno",
                                                                                    style: TextStyle(
                                                                                        color: AppTheme.lightText,
                                                                                        fontSize: 10,
                                                                                        fontFamily: AppTheme.fontTTNorms,
                                                                                        fontWeight: FontWeight.w500
                                                                                    )
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          )
                                                                      ),
                                                                    )
                                                                ),
                                                              Expanded(
                                                                  child: Container(
                                                                    child: Material(
                                                                      color: Colors.transparent,
                                                                      child: InkWell(
                                                                        focusColor: Colors.transparent,
                                                                        highlightColor: Colors.transparent,
                                                                        hoverColor: Colors.transparent,
                                                                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                                        splashColor: AppTheme.colorPrimary.withOpacity(0.2),
                                                                        onTap: () {
                                                                          if((contactoUi.apoderadoTelfono??"").isNotEmpty){
                                                                            launch("tel://${contactoUi.apoderadoTelfono}");
                                                                          }else{
                                                                            Fluttertoast.showToast(
                                                                                msg: "Apoderado sin número",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                gravity: ToastGravity.BOTTOM,
                                                                                timeInSecForIosWeb: 1
                                                                            );
                                                                          }
                                                                        },
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.call, size: 24, color: Color(0xFF6FBD53),),
                                                                            Text("Apoderado",
                                                                                style: TextStyle(
                                                                                    color: AppTheme.lightText,
                                                                                    fontFamily: AppTheme.fontTTNorms,
                                                                                    fontSize: 10,
                                                                                    fontWeight: FontWeight.w500
                                                                                )
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                              Expanded(
                                                                  child: Material(
                                                                    color: Colors.transparent,
                                                                    child: InkWell(
                                                                      focusColor: Colors.transparent,
                                                                      highlightColor: Colors.transparent,
                                                                      hoverColor: Colors.transparent,
                                                                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                                      splashColor: AppTheme.colorPrimary.withOpacity(0.2),
                                                                      onTap: () {

                                                                      },
                                                                      child: Container(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.insert_comment_outlined, size: 24, color: Color(0XFF52B1D3),),
                                                                            Text("Mensaje",
                                                                                style: TextStyle(
                                                                                    color: AppTheme.lightText,
                                                                                    fontFamily: AppTheme.fontTTNorms,
                                                                                    fontSize: 10,
                                                                                    fontWeight: FontWeight.w500
                                                                                )
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                              Expanded(
                                                                  child: Material(
                                                                    color: Colors.transparent,
                                                                    child: InkWell(
                                                                      focusColor: Colors.transparent,
                                                                      highlightColor: Colors.transparent,
                                                                      hoverColor: Colors.transparent,
                                                                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                                      splashColor: AppTheme.colorPrimary.withOpacity(0.2),
                                                                      onTap: () {

                                                                      },
                                                                      child: Container(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.supervised_user_circle_outlined, size: 24, color: Color(0xFF929292),),
                                                                            Text("Información",
                                                                                style: TextStyle(
                                                                                    color: AppTheme.lightText,
                                                                                    fontFamily: AppTheme.fontTTNorms,
                                                                                    fontSize: 10,
                                                                                    fontWeight: FontWeight.w500
                                                                                )
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }else{
                                                  return Container();
                                                }
                                              }
                                          ),
                                          ListView.builder(
                                              padding: EdgeInsets.only(top: 4, bottom: 100),
                                              itemCount: filteredDocentes!=null?filteredDocentes?.length:controller.doncentesList.length,
                                              itemBuilder: (BuildContext ctxt, int index) {
                                                dynamic o = filteredDocentes!=null?filteredDocentes![index]:controller.doncentesList[index];
                                                if(o is String){
                                                  return Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 550
                                                    ),
                                                    padding: const EdgeInsets.only(left: 24, right: 0, top: 8, bottom: 8),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 0, right: 5, top: 0),
                                                          child: Text(o,
                                                              style: TextStyle(
                                                                  color: AppTheme.colorPrimary,
                                                                  fontSize: 14,
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  fontWeight: FontWeight.w900
                                                              )
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets.only(left: 8, right: 32),
                                                              color: AppTheme.colorPrimary,
                                                              height: 0.5,
                                                            )
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }else if(o is ContactoUi){
                                                  ContactoUi contactoUi = o;
                                                  return Theme(
                                                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                                    child: CustomExpansionTile(
                                                      expandedItem: _expanded,
                                                      key: Key("${contactoUi.personaUi?.personaId}"),
                                                      title: Container(
                                                        constraints: BoxConstraints(
                                                            maxWidth: 550
                                                        ),
                                                        padding: EdgeInsets.only(left: 16, right: 0, top: 0, bottom: 0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(contactoUi.personaUi?.nombreCompleto??"",
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                    fontSize: ColumnCountProvider.aspectRatioForWidthContactos(context, 15),
                                                                    color: AppTheme.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontFamily: AppTheme.fontTTNorms
                                                                )
                                                            ),
                                                            Padding(padding: EdgeInsets.all(2)),
                                                            Text("${AppFormatNumber.getFormatCelular((contactoUi.personaUi?.telefono??"").isEmpty?contactoUi.apoderadoTelfono:contactoUi.personaUi?.telefono)??"Sin número celular o teléfono"}",
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                    fontSize: ColumnCountProvider.aspectRatioForWidthContactos(context, 14),
                                                                    color: AppTheme.colorPrimary,
                                                                    fontWeight: FontWeight.w400
                                                                )
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      trailing: Container(
                                                        height: 10,
                                                        width: 10,
                                                      ),
                                                      leading: CachedNetworkImage(
                                                          height: ColumnCountProvider.aspectRatioForWidthContactos(context, 50),
                                                          width: ColumnCountProvider.aspectRatioForWidthContactos(context, 50),
                                                          placeholder: (context, url) => Center(
                                                            child: CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color: AppTheme.colorPrimary
                                                            ),
                                                          ),
                                                          imageUrl: contactoUi.personaUi?.foto??'',
                                                          imageBuilder: (context, imageProvider) =>
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                                                    image: DecorationImage(
                                                                      image: imageProvider,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  )
                                                              )
                                                      ),
                                                      children: [
                                                        Container(
                                                          height: 60,
                                                          color: Color(0xFFF6F6F6),
                                                          padding: const EdgeInsets.only(left:  40, right: 28),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child: Material(
                                                                    color: Colors.transparent,
                                                                    child: InkWell(
                                                                      focusColor: Colors.transparent,
                                                                      highlightColor: Colors.transparent,
                                                                      hoverColor: Colors.transparent,
                                                                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                                      splashColor: AppTheme.colorPrimary.withOpacity(0.2),
                                                                      onTap: () {
                                                                        if((contactoUi.personaUi?.telefono??"").isNotEmpty){
                                                                          launch("tel://${contactoUi.personaUi?.telefono}");
                                                                        }else{
                                                                          Fluttertoast.showToast(
                                                                              msg: "Docente sin número",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.BOTTOM,
                                                                              timeInSecForIosWeb: 1
                                                                          );
                                                                        }
                                                                      },
                                                                      child: Container(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.call, size: 24, color: Color(0xFF6FBD53),),
                                                                            Text("Llamar", style: TextStyle(color: AppTheme.lightText, fontFamily: AppTheme.fontTTNorms, fontSize: 10, fontWeight: FontWeight.w500),),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                              Expanded(
                                                                  child: Material(
                                                                    color: Colors.transparent,
                                                                    child: InkWell(
                                                                      focusColor: Colors.transparent,
                                                                      highlightColor: Colors.transparent,
                                                                      hoverColor: Colors.transparent,
                                                                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                                      splashColor: AppTheme.colorPrimary.withOpacity(0.2),
                                                                      onTap: () {

                                                                      },
                                                                      child: Container(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.insert_comment_outlined, size: 24, color: Color(0XFF52B1D3),),
                                                                            Text("Mensaje", style: TextStyle(color: AppTheme.lightText, fontFamily: AppTheme.fontTTNorms, fontSize: 10, fontWeight: FontWeight.w500),),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                              Expanded(
                                                                  child: Material(
                                                                    color: Colors.transparent,
                                                                    child: InkWell(
                                                                      focusColor: Colors.transparent,
                                                                      highlightColor: Colors.transparent,
                                                                      hoverColor: Colors.transparent,
                                                                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                                      splashColor: AppTheme.colorPrimary.withOpacity(0.2),
                                                                      onTap: () {

                                                                      },
                                                                      child: Container(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.supervised_user_circle_outlined, size: 24, color: Color(0xFF929292),),
                                                                            Text("Información", style: TextStyle(color: AppTheme.lightText, fontFamily: AppTheme.fontTTNorms, fontSize: 10, fontWeight: FontWeight.w500),),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }else{
                                                  return Container();
                                                }
                                              }
                                          ),
                                          ListView.builder(
                                              padding: EdgeInsets.only(top: 4, bottom: 100),
                                              itemCount: filteredDirectivos!=null?filteredDirectivos?.length:controller.directivosList.length,
                                              itemBuilder: (BuildContext ctxt, int index) {
                                                dynamic o = filteredDirectivos!=null?filteredDirectivos![index]:controller.directivosList[index];
                                                if(o is String){
                                                  return Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 550
                                                    ),
                                                    padding: const EdgeInsets.only(left: 24, right: 0, top: 8, bottom: 8),
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 0, right: 5, top: 0),
                                                          child: Text(o,
                                                              style: TextStyle(
                                                                  color: AppTheme.colorPrimary,
                                                                  fontSize: 14,
                                                                  fontFamily: AppTheme.fontTTNorms,
                                                                  fontWeight: FontWeight.w900
                                                              )
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets.only(left: 8, right: 32),
                                                              color: AppTheme.colorPrimary,
                                                              height: 0.5,
                                                            )
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }else if(o is ContactoUi){
                                                  ContactoUi contactoUi = o;
                                                  return Theme(
                                                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                                    child: CustomExpansionTile(
                                                      expandedItem: _expanded,
                                                      key: Key("${contactoUi.personaUi?.personaId}"),
                                                      title: Container(
                                                        constraints: BoxConstraints(
                                                            maxWidth: 550
                                                        ),
                                                        padding: EdgeInsets.only(left: 16, right: 0, top: 0, bottom: 0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(contactoUi.personaUi?.nombreCompleto??"",
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                    fontSize: ColumnCountProvider.aspectRatioForWidthContactos(context, 15),
                                                                    color: AppTheme.black,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontFamily: AppTheme.fontTTNorms
                                                                )
                                                            ),
                                                            Padding(padding: EdgeInsets.all(0)),
                                                            Text("${contactoUi.relacion}",
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                    fontSize: ColumnCountProvider.aspectRatioForWidthContactos(context, 12),
                                                                    color: AppTheme.colorPrimary,
                                                                    fontWeight: FontWeight.w400
                                                                )
                                                            ),
                                                            Padding(padding: EdgeInsets.all(2)),
                                                            Text("${AppFormatNumber.getFormatCelular((contactoUi.personaUi?.telefono??"").isEmpty?contactoUi.apoderadoTelfono:contactoUi.personaUi?.telefono)??"Sin número celular o teléfono"}",
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(
                                                                    fontSize: ColumnCountProvider.aspectRatioForWidthContactos(context, 14),
                                                                    color: AppTheme.colorPrimary,
                                                                    fontWeight: FontWeight.w400
                                                                )
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      trailing: Container(
                                                        height: 10,
                                                        width: 10,
                                                      ),
                                                      leading: CachedNetworkImage(
                                                          height: ColumnCountProvider.aspectRatioForWidthContactos(context, 50),
                                                          width: ColumnCountProvider.aspectRatioForWidthContactos(context, 50),
                                                          placeholder: (context, url) => Center(
                                                            child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.colorPrimary),
                                                          ),
                                                          imageUrl: contactoUi.personaUi?.foto??'',
                                                          imageBuilder: (context, imageProvider) =>
                                                              Container(
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                                                    image: DecorationImage(
                                                                      image: imageProvider,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  )
                                                              )
                                                      ),
                                                      children: [
                                                        Container(
                                                          height: 60,
                                                          color: Color(0xFFF6F6F6),
                                                          padding: const EdgeInsets.only(left:  40, right: 28),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child: Material(
                                                                    color: Colors.transparent,
                                                                    child: InkWell(
                                                                      focusColor: Colors.transparent,
                                                                      highlightColor: Colors.transparent,
                                                                      hoverColor: Colors.transparent,
                                                                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                                      splashColor: AppTheme.colorPrimary.withOpacity(0.2),
                                                                      onTap: () {
                                                                        if((contactoUi.personaUi?.telefono??"").isNotEmpty){
                                                                          launch("tel://${contactoUi.personaUi?.telefono}");
                                                                        }else{
                                                                          Fluttertoast.showToast(
                                                                              msg: "Directivo sin número",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.BOTTOM,
                                                                              timeInSecForIosWeb: 1
                                                                          );
                                                                        }
                                                                      },
                                                                      child: Container(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.call, size: 24, color: Color(0xFF6FBD53),),
                                                                            Text("Llamar", style: TextStyle(color: AppTheme.lightText, fontFamily: AppTheme.fontTTNorms, fontSize: 10, fontWeight: FontWeight.w500),),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                              Expanded(
                                                                  child: Material(
                                                                    color: Colors.transparent,
                                                                    child: InkWell(
                                                                      focusColor: Colors.transparent,
                                                                      highlightColor: Colors.transparent,
                                                                      hoverColor: Colors.transparent,
                                                                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                                      splashColor: AppTheme.colorPrimary.withOpacity(0.2),
                                                                      onTap: () {

                                                                      },
                                                                      child: Container(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.insert_comment_outlined, size: 24, color: Color(0XFF52B1D3),),
                                                                            Text("Mensaje", style: TextStyle(color: AppTheme.lightText,fontFamily: AppTheme.fontTTNorms,  fontSize: 10, fontWeight: FontWeight.w500),),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                              ),
                                                              Expanded(
                                                                  child: Material(
                                                                    color: Colors.transparent,
                                                                    child: InkWell(
                                                                      focusColor: Colors.transparent,
                                                                      highlightColor: Colors.transparent,
                                                                      hoverColor: Colors.transparent,
                                                                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                                                      splashColor: AppTheme.colorPrimary.withOpacity(0.2),
                                                                      onTap: () {

                                                                      },
                                                                      child: Container(
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.supervised_user_circle_outlined, size: 24, color: Color(0xFF929292),),
                                                                            Text("Información", style: TextStyle(color: AppTheme.lightText, fontFamily: AppTheme.fontTTNorms, fontSize: 10, fontWeight: FontWeight.w500),),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }else{
                                                  return Container();
                                                }
                                              }
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                      ),
                      controller.isLoading ?  Container(child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.colorPrimary),
                      )): Container(),
                    ],
                  );

                }),
          ),
        );
      },
    );
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: SearchBar(
        key: search,
        controller: _controller,
        focusNode: _focusNode,
      ),
    );
  }

  void _onTextChanged() {
    String string = _controller.text;
    ContactosController contactosController = FlutterCleanArchitecture.getController<ContactosController>(search.currentContext!, listen: false);
    _debouncer.run(() {
      setState(() {
        if(string.isEmpty){
          filteredAlumnos = null;
          filteredDocentes = null;
          filteredDirectivos = null;
        }else{
          filteredAlumnos = contactosController.companieroList
              .where((u){
            if(u is ContactoUi){
              return u.personaUi?.nombreCompleto?.toLowerCase().contains(string.toLowerCase())??false;
            }else{
              return false;
            }
          }).toList();
          filteredDocentes = contactosController.doncentesList
              .where((u){
            if(u is ContactoUi){
              return u.personaUi?.nombreCompleto?.toLowerCase().contains(string.toLowerCase())??false;
            }else{
              return false;
            }
          }).toList();
          filteredDirectivos = contactosController.directivosList
              .where((u){
            if(u is ContactoUi){
              return u.personaUi?.nombreCompleto?.toLowerCase().contains(string.toLowerCase())??false;
            }else{
              return false;
            }
          }).toList();
        }

      });
    });

  }

@override
  void dispose() {
  _focusNode.dispose();
  _controller.dispose();
    super.dispose();
  }

  Widget getMenuView(ContactosController controller) {
    return Container(
      margin: EdgeInsets.only(
          top: 16,
          left: 24,
          right: 24,
          bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.colorPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14), // use instead of BorderRadius.all(Radius.circular(20))
            ),
            child: FDottedLine(
              color: AppTheme.white,
              strokeWidth: 3.0,
              dottedLength: 10.0,
              space: 3.0,
              corner: FDottedLineCorner.all(14.0),
              /// add widget
              child: Container(
                padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 16),
                alignment: Alignment.center,
                child: Text("Sin opciones",  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontFamily: AppTheme.fontTTNorms,
                    color: AppTheme.white
                ),),
              ),
            ),
          )
        ],
      ),
    );
  }

}
typedef MenuBuilder = void Function(Widget menuView);
class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }


}