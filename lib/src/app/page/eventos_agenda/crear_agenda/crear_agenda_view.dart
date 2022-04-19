import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/eventos_agenda/crear_agenda/crear_agenda_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_url_launcher.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_utils.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/dropdown_formfield_2.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/image_picker/image_picker_handler.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/progress_bar.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_agenda_evento_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_adjunto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_lista_envio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tipo_recursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_drive_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';

class CrearAgendaView extends View{
  EventoUi? eventoUi;
  CursosUi? cursosUi;

  CrearAgendaView(this.eventoUi, this.cursosUi);

  @override
  _CrearAgendaViewState createState() => _CrearAgendaViewState(eventoUi, cursosUi);

}

class _CrearAgendaViewState extends ViewState<CrearAgendaView, CrearAgendaController> with TickerProviderStateMixin, ImagePickerListener{

  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  final Color colorTipoAgenda = AppTheme.colorPrimaryDark;
  
  var _TituloEventocontroller = TextEditingController();
  var _Informacioncontroller = TextEditingController();
  var _Horacontroller = TextEditingController();
  final format = DateFormat("dd/MM/yyyy");
  final formatHour = DateFormat("hh:mm a");
  late SheetController _sheetController = SheetController();
  late bool isExpandedSlidingSheet = false;
  late bool isCollapsedSlidingSheet = true;
  final _debouncer = Debouncer(milliseconds: 500);
  List<dynamic>? filteredUsers = null;
  late AnimationController _imagePickerAnimationcontroller;
  late ImagePickerHandler imagePicker;
  GlobalKey globalKey = GlobalKey();

  _CrearAgendaViewState(EventoUi? eventoUi, CursosUi? cursosUi) : super(CrearAgendaController(eventoUi, cursosUi, MoorConfiguracionRepository(), MoorAgendaEventoRepository(), DeviceHttpDatosRepositorio()));

  @override
  void initState() {

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });

    super.initState();
    _TituloEventocontroller.text = widget.eventoUi?.titulo??"";
    _Informacioncontroller.text = widget.eventoUi?.descripcion??"";
    _Horacontroller.text = widget.eventoUi?.horaEvento??"";

    _imagePickerAnimationcontroller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker=new ImagePickerHandler(this,_imagePickerAnimationcontroller, false);
    imagePicker.init(documento: true);

  }



  @override
  Widget get view => ControlledWidgetBuilder<CrearAgendaController>(
      builder: (context, controller) {
        if(controller.mensaje!=null&&controller.mensaje!.isNotEmpty){
          Fluttertoast.showToast(
            msg: controller.mensaje!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
          controller.successMsg();
        }
        double minExtent = 140 + (MediaQuery.of(context).padding.top  + 65);
        return WillPopScope(
          onWillPop: () async {
            if(_sheetController.state?.isExpanded??false){
              _sheetController.collapse();
              FocusScope.of(context).unfocus();
              return false;
            } else{
              return await _showMaterialDialog()??false;
            }
          },
          child: Stack(
            key: globalKey,
            children: [
              Scaffold(
                extendBody: true,
                backgroundColor: AppTheme.white,
                body: SlidingSheet(
                  cornerRadius: isExpandedSlidingSheet?0:16,
                  border: Border.all(color: colorTipoAgenda),
                  listener: (state) {
                    if(state.isExpanded != isExpandedSlidingSheet){
                      setState(() {
                        isExpandedSlidingSheet = state.isExpanded;
                      });
                      FocusScope.of(context).unfocus();
                      filteredUsers= null;
                    }
                  },
                  controller: _sheetController,
                  snapSpec: SnapSpec(
                    // Enable snapping. This is true by default.
                    snap: true,
                    // Set custom snapping points.
                    //snappings: [0.2, 0.5, 1.0],
                    // Define to what the snappings relate to. In this case,
                    // the total available space that the sheet can expand to.
                    //positioning: SnapPositioning.relativeToAvailableSpace,
                    //initialSnap: 0.2
                    snappings: [
                      minExtent,
                      double.infinity
                    ],
                    positioning: SnapPositioning.pixelOffset,
                  ),
                  // The body widget will be displayed under the SlidingSheet
                  // and a parallax effect can be applied to it.
                  body: Stack(
                    children: [
                      getMainTab(),
                      getAppBarUI(),
                    ],
                  ),
                  margin: EdgeInsets.only(top: (MediaQuery.of(context).padding.top  + 65)),
                  minHeight: MediaQuery.of(context).size.height,
                  builder: (context, state){
                    // This is the content of the sheet that will get
                    // scrolled, if the content is bigger than the available
                    // height of the sheet.
                    return SheetListenerBuilder(
                      // buildWhen can be used to only rebuild the widget when needed.
                      //buildWhen: (oldState, newState) => oldState.isExpanded != newState.isExpanded || oldState.isCollapsed != newState.isCollapsed,
                      builder: (context, state) {
                        return ControlledWidgetBuilder<CrearAgendaController>(
                            builder: (context, controller) {
                              return CustomScrollView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                slivers: [
                                  if(!state.isCollapsed)
                                    SliverToBoxAdapter(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if(filteredUsers==null)
                                            Container(
                                              margin: EdgeInsets.only(bottom: 0, top: 10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(left: 24, right: 16),
                                                    child: SizedBox(
                                                      height: 16,
                                                      width: 16,
                                                      child: Transform.scale(
                                                        scale: 1,
                                                        child:  Checkbox(
                                                          activeColor: colorTipoAgenda,
                                                          value: controller.todosPadres,
                                                          onChanged: (bool? value) {
                                                            setState((){
                                                              controller.onClickTodosPadres();
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(bottom: 4),
                                                    child: FDottedLine(
                                                      color: AppTheme.greyLighten1,
                                                      strokeWidth: 1.0,
                                                      dottedLength: 5.0,
                                                      space: 3.0,
                                                      corner: FDottedLineCorner.all(30.0),
                                                      child: Container(
                                                        color: AppTheme.greyLighten2,
                                                        child: Container(
                                                          width: 32,
                                                          height: 32,
                                                          child: Icon(Ionicons.people , size: 18, color: colorTipoAgenda,),
                                                        ),
                                                      ),

                                                    ),
                                                  ),
                                                  Padding(padding: EdgeInsets.all(4),),
                                                  Expanded(child:
                                                  Text("Enviar a todos los padres",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)))
                                                ],
                                              ),
                                            ),
                                          if(filteredUsers==null)
                                            Container(
                                              margin: EdgeInsets.only(bottom: 0, top: 8),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(left: 24, right: 16),
                                                    child: SizedBox(
                                                      height: 16,
                                                      width: 16,
                                                      child: Transform.scale(
                                                        scale: 1,
                                                        child:  Checkbox(
                                                          activeColor: colorTipoAgenda,
                                                          value: controller.todosAlumnos,
                                                          onChanged: (bool? value) {
                                                            setState((){
                                                              controller.onClickTodoAlumnos();
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(bottom: 4),
                                                    child: FDottedLine(
                                                      color: AppTheme.greyLighten1,
                                                      strokeWidth: 1.0,
                                                      dottedLength: 5.0,
                                                      space: 3.0,
                                                      corner: FDottedLineCorner.all(30.0),
                                                      child: Container(
                                                        color: AppTheme.greyLighten2,
                                                        child: Container(
                                                          width: 32,
                                                          height: 32,
                                                          child: Icon(Ionicons.people , size: 18, color: colorTipoAgenda,),
                                                        ),
                                                      ),

                                                    ),
                                                  ),
                                                  Padding(padding: EdgeInsets.all(4),),
                                                  Expanded(child:
                                                  Text("Enviar a todos los alumnos",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)))
                                                ],
                                              ),
                                            ),
                                          ListView.builder(
                                            padding: EdgeInsets.only(top: 0, bottom: 64),
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index){
                                              dynamic o =  filteredUsers!=null?filteredUsers![index]: controller.personasUiList[index];
                                              if(o is EventoPersonaUi){
                                                return Container(
                                                  margin: EdgeInsets.only(bottom: 0, top: 16),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left: 24, right: 16),
                                                        child: SizedBox(
                                                          height: 16,
                                                          width: 16,
                                                          child: Transform.scale(
                                                            scale: 1,
                                                            child:  Checkbox(
                                                              activeColor: colorTipoAgenda,
                                                              value: (o.selectedPadre??false)||(o.selectedAlumno??false),
                                                              onChanged: (bool? value) {
                                                                controller.onClickAlumnoPadre(o);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      CachedNetworkImage(
                                                        placeholder: (context, url) => Container(
                                                          child: CircularProgressIndicator(),
                                                        ),
                                                        imageUrl: o.personaUi?.foto??"",
                                                        errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 38,),
                                                        imageBuilder: (context, imageProvider) =>
                                                            Container(
                                                                width: 38,
                                                                height: 38,
                                                                margin: EdgeInsets.only(right: 0, left: 0, top: 0, bottom: 0),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                                                  image: DecorationImage(
                                                                    image: imageProvider,
                                                                    fit: BoxFit.cover,
                                                                  ),
                                                                )
                                                            ),
                                                      ),
                                                      Padding(padding: EdgeInsets.all(8),),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("${o.personaUi?.nombreCompleto}",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                                          Padding(padding: EdgeInsets.all(4),),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets.only(left: 0, right: 8),
                                                                child: SizedBox(
                                                                  height: 20,
                                                                  width: 20,
                                                                  child: Transform.scale(
                                                                    scale: 0.9,
                                                                    child:  Checkbox(
                                                                      activeColor: colorTipoAgenda,
                                                                      value: o.selectedPadre??false,
                                                                      onChanged: (bool? value) {
                                                                        controller.onClickAlumnoSoloPadres(o);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text("Padres",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
                                                              Padding(padding: EdgeInsets.all(8),),
                                                              Container(
                                                                margin: EdgeInsets.only(left: 0, right: 8),
                                                                child: SizedBox(
                                                                  height: 20,
                                                                  width: 20,
                                                                  child: Transform.scale(
                                                                    scale: 0.9,
                                                                    child:  Checkbox(
                                                                      activeColor: colorTipoAgenda,
                                                                      value: o.selectedAlumno??false,
                                                                      onChanged: (bool? value) {
                                                                        controller.onClickAlumnoSoloAlumno(o);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Text("Alumno",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400))
                                                            ],
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }
                                              else if(o is String){
                                                return Container(
                                                  margin: EdgeInsets.only(top: 16,left: 24, bottom: 0),
                                                  child: Text("Lista de ${o}", style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w700,
                                                      color: AppTheme.greyDarken1
                                                  ),),
                                                );
                                              }else {
                                                return Container();
                                              }
                                            },
                                            itemCount: filteredUsers!=null? filteredUsers?.length :controller.personasUiList.length,
                                          )
                                        ],
                                      ),
                                    ),
                                ],
                              );
                            });
                      },
                    );
                  },
                  headerBuilder: (context, state) {
                    return Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: (){
                              if(!state.isExpanded){
                                _sheetController.expand();
                              }else{
                                _sheetController.collapse();
                              }
                            },
                            child:  Stack(
                              children: [
                                Center(
                                  child: Icon(!state.isExpanded ? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down, size: 32, color: colorTipoAgenda,),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              if(!state.isExpanded){
                                _sheetController.expand();
                              }else{
                                _sheetController.collapse();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(top: 8,left: 24, right: 24),
                              child: Row(
                                children: [
                                  Text("¿A quién va dirigido?", style: TextStyle(color: colorTipoAgenda, fontSize: 24),),
                                  Expanded(child: Container()),
                                  Icon(Icons.supervised_user_circle_rounded, size: 24, color: colorTipoAgenda,)
                                ],
                              ),
                            ),
                          ),
                          if (state.isCollapsed)
                            InkWell(
                              onTap: (){
                                _sheetController.expand();
                              },
                              child: Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 24, right: 24, top: 16),
                                height: 70,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Para:", style: TextStyle(color: AppTheme.black, fontWeight: FontWeight.w500, fontSize: 14),),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 4, top: 2),
                                        child: controller.nombresSelected.isEmpty?Text("Sin participantes", style: TextStyle(fontSize: 12)):
                                        Text("${controller.nombresSelected}", maxLines:3, overflow: TextOverflow.ellipsis ,style: TextStyle(fontSize: 12, color: AppTheme.colorAccent),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ) else Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                                child: DropDownFormField2<EventosListaEnvioUi>(
                                  inputDecoration: InputDecoration(
                                    labelText: "",
                                    labelStyle: TextStyle(
                                      color:  colorTipoAgenda,
                                      fontFamily: AppTheme.fontTTNormsMedium,
                                      fontSize: 14,
                                    ),
                                    contentPadding: EdgeInsets.all(15.0),
                                    suffixIcon:  IconButton(
                                      onPressed: (){
                                        controller.clearTitulo();
                                        //_tiuloRubricacontroller.clear();
                                      },
                                      icon: Icon(
                                        Ionicons.caret_down,
                                        color: colorTipoAgenda,
                                      ),
                                      iconSize: 15,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                        color: colorTipoAgenda.withOpacity(0.5),
                                      ),
                                    ),
                                    hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppTheme.fontTTNormsMedium,
                                      fontSize: 14,
                                      color: colorTipoAgenda.withOpacity(0.5),
                                    ),
                                  ),
                                  onChanged: (item){
                                    controller.onSelectListaEnvio(item);
                                  },
                                  menuItems: controller.eventosListaEnvioUiList.map<DropdownMenuItem<EventosListaEnvioUi>>((e){
                                    return  DropdownMenuItem<EventosListaEnvioUi>(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 0),
                                        child: Text("${e.nombre??""}", style: TextStyle(
                                          fontFamily: AppTheme.fontName,
                                          fontSize: 15,
                                          color: Colors.black,),),
                                      ),
                                      value: e,
                                    );
                                  }).toList(),
                                  value: controller.eventosListaEnvioUi,
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 8, left: 24, right: 24),
                                child: Row(
                                  children: [
                                    Text("Buscar:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                    Expanded(
                                      child: Container(
                                        height: 45,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: TextField(
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                          decoration: InputDecoration(
                                                              isDense: true,
                                                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                                                              hintText: "Digite un nombre",
                                                              border: InputBorder.none),
                                                          onChanged: (string) {
                                                            _debouncer.run(() {
                                                              setState(() {
                                                                if(string.isEmpty){
                                                                  filteredUsers = null;
                                                                }else{
                                                                  filteredUsers = controller.personasUiList
                                                                      .where((u){

                                                                    if(u is EventoPersonaUi){
                                                                      return u.personaUi?.nombreCompleto?.toLowerCase().contains(string.toLowerCase())??false;
                                                                    }else{
                                                                      return false;
                                                                    }

                                                                  }).toList();
                                                                }

                                                              });
                                                            });
                                                          }
                                                      ),

                                                    ),
                                                  ],
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

                              Container(
                                height: 1,
                                color: AppTheme.grey,
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              controller.progress?
              ArsProgressWidget(
                  blur: 2,
                  backgroundColor: Color(0x33000000),
                  animationDuration: Duration(milliseconds: 500)):
              Container(),
            ],
          ),
        );
      });

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: AppTheme.white.withOpacity(topBarOpacity),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32.0),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: AppTheme.grey
                      .withOpacity(0.4 * topBarOpacity),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: ControlledWidgetBuilder<CrearAgendaController>(
            builder: (context, controller) {
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).padding.top,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 8,
                        right: 24,
                        top: 16 - 8.0 * topBarOpacity,
                        bottom: 12 - 8.0 * topBarOpacity),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                          onPressed: () async {
                            if(_sheetController.state?.isExpanded??false){
                              FocusScope.of(context).unfocus();
                              _sheetController.collapse();
                            } else{
                              bool? respuesta = await _showMaterialDialog();
                              if(respuesta??false){
                                Navigator.of(context).pop(true);
                              }
                            }

                          },
                        ),
                        Expanded(
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //SvgPicture.asset(AppIcon.ic_curso_tarea, height: 32 +  6 - 10 * topBarOpacity , width: 35 +  6 - 10 * topBarOpacity ,),
                              Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Evento',
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontTTNormsMedium,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16 + 6 - 6 * topBarOpacity,
                                        letterSpacing: 1.2,
                                        color: AppTheme.darkerText,
                                      ),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),Row(
                          children: [
                            Material(
                              color: colorTipoAgenda.withOpacity(0.1),
                              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                              child: InkWell(
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                splashColor: AppTheme.colorPrimary.withOpacity(0.4),
                                onTap: () async {
                                  dynamic succes = await controller.onClickPublicarEvento();
                                  if(succes is int){
                                    print("show");
                                    if(succes == 1){
                                      _sheetController.expand();
                                    }else{
                                      _sheetController.collapse();
                                    }
                                  }else{
                                    if(succes)Navigator.of(context).pop(1);
                                  }
                                },
                                child:
                                Container(
                                    padding: const EdgeInsets.only(top: 10, left: 8, bottom: 8, right: 8),
                                    child: Row(
                                      children: [
                                        Text("PUBLICAR",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorTipoAgenda,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: AppTheme.fontName,
                                          ),),
                                      ],
                                    )
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(6)),
                            Material(
                              color:colorTipoAgenda,
                              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                              child: InkWell(
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                splashColor: AppTheme.colorPrimary.withOpacity(0.4),
                                onTap: () async {
                                  print("guardar");
                                  dynamic succes = await controller.onClickGuardarEvento();
                                  if(succes is int){
                                    print("show");
                                    if(succes == 1){
                                      _sheetController.expand();
                                    }else{
                                      _sheetController.collapse();
                                    }
                                  }else{
                                    if(succes)Navigator.of(context).pop(1);
                                  }
                                },
                                child:
                                Container(
                                    padding: const EdgeInsets.only(top: 10, left: 8, bottom: 8, right: 8),
                                    child: Row(
                                      children: [
                                        Text("GUARDAR",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.white,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: AppTheme.fontName,
                                          ),),
                                      ],
                                    )
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        )
      ],
    );
  }

  Widget getMainTab() {
    return ControlledWidgetBuilder<CrearAgendaController>(
        builder: (context, controller) {

          return Container(
              padding: EdgeInsets.only(
                top: AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top +
                    0,
              ),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: CustomScrollView(
                    controller: scrollController,
                    slivers: <Widget>[
                      SliverList(
                          delegate: SliverChildListDelegate([
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                              child:  TextFormField(
                                autofocus: false,
                                controller: _TituloEventocontroller,
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                maxLines: null,
                                decoration: InputDecoration(
                                  labelText: "Título *",
                                  labelStyle: TextStyle(
                                      color:  colorTipoAgenda,
                                      fontFamily: AppTheme.fontTTNormsMedium,
                                      fontSize: 18
                                  ),
                                  helperText: " ",
                                  contentPadding: EdgeInsets.all(15.0),
                                  suffixIcon:(controller.tituloEvento?.isNotEmpty??false) ?
                                  IconButton(
                                    onPressed: (){
                                      controller.clearTitulo();
                                      _TituloEventocontroller.clear();
                                    },
                                    icon: Icon(
                                      Ionicons.close_circle,
                                      color: colorTipoAgenda,
                                    ),
                                  ):null,
                                  errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  hintText: "Ingrese un título",
                                  hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppTheme.greyLighten1,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  focusColor: AppTheme.colorAccent,
                                ),
                                onChanged: (str) {
                                  controller.changeTitulo(str);
                                },
                                onSaved: (str) {
                                  //  To do
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                              child:  TextFormField(
                                autofocus: false,
                                controller: _Informacioncontroller,
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                maxLines: null,
                                decoration: InputDecoration(
                                  labelText: "Información (Opcional)",
                                  labelStyle: TextStyle(
                                      color:  colorTipoAgenda,
                                      fontFamily: AppTheme.fontTTNormsMedium,
                                      fontSize: 18
                                  ),
                                  helperText: " ",
                                  contentPadding: EdgeInsets.all(15.0),
                                  suffixIcon:(controller.informacion?.isNotEmpty??false) ?
                                  IconButton(
                                    onPressed: (){
                                      controller.clearInformacion();
                                      _Informacioncontroller.clear();
                                    },
                                    icon: Icon(
                                      Ionicons.close_circle,
                                      color: colorTipoAgenda,
                                    ),
                                  ):null,
                                  errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  hintText: "",
                                  hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppTheme.colorPrimary.withOpacity(0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  focusColor: AppTheme.colorAccent,
                                ),
                                onChanged: (str) {
                                  controller.changeInformacion(str);
                                },
                                onSaved: (str) {
                                  //  To do
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                              child: DateTimeField(
                                initialValue: controller.fechaEvento,
                                format: format,
                                autofocus: false,
                                textAlign: TextAlign.start,
                                resetIcon: Icon(
                                  Ionicons.close_circle,
                                  color: colorTipoAgenda,
                                ),
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Fecha del evento",
                                  labelStyle: TextStyle(
                                      color: colorTipoAgenda,
                                      fontFamily: AppTheme.fontTTNormsMedium,
                                      fontSize: 18
                                  ),
                                  helperText: " ",
                                  contentPadding: EdgeInsets.all(15.0),
                                  prefixIcon: Icon(
                                    Icons.web_asset_rounded,
                                    color: colorTipoAgenda,
                                  ),
                                  errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  hintText: "",
                                  hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppTheme.colorPrimary.withOpacity(0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  focusColor: AppTheme.colorAccent,
                                ),
                                onChanged: (DateTime? value){
                                  controller.changeFecha(value);
                                },
                                onShowPicker: (context, currentValue) {
                                  return showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1900),
                                      initialDate: currentValue ?? DateTime.now(),
                                      lastDate: DateTime(2100));
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                              child: DateTimeField(
                                initialValue: (controller.horaEvento??"").isNotEmpty?DateTimeField.convert(AppUtils.horaTimeOfDay(controller.horaEvento)):null,
                                format: formatHour,
                                autofocus: false,
                                textAlign: TextAlign.start,
                                resetIcon: Icon(
                                  Ionicons.close_circle,
                                  color: colorTipoAgenda,
                                ),
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Hora del evento",
                                  labelStyle: TextStyle(
                                      color: colorTipoAgenda,
                                      fontFamily: AppTheme.fontTTNormsMedium,
                                      fontSize: 18
                                  ),
                                  helperText: " ",
                                  contentPadding: EdgeInsets.all(15.0),
                                  prefixIcon: Icon(
                                    Icons.alarm,
                                    color: colorTipoAgenda,
                                  ),
                                  errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  hintText: "",
                                  hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppTheme.colorPrimary.withOpacity(0.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: colorTipoAgenda,
                                    ),
                                  ),
                                  focusColor: AppTheme.colorAccent,
                                ),
                                onChanged: (DateTime? value){
                                  if(value!=null){
                                    controller.changeHora(DomainTools.dataTimeHourMinute(value));
                                  }else{
                                    controller.changeHora(null);
                                  }
                                },
                                onShowPicker: (context, currentValue) async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                  );
                                  return DateTimeField.convert(time);
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                              child: Text("Adjuntar",
                                style: TextStyle(fontSize: 16, color: AppTheme.black, fontWeight: FontWeight.w500),),
                            ),

                            Container(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 16,),
                              child: Stack(
                                children: [
                                  Center(
                                    child: InkWell(
                                      onTap: () async{
                                        imagePicker.showDialog(context);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: colorTipoAgenda.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8), // use instead of BorderRadius.all(Radius.circular(20))
                                        ),
                                        width: 450,
                                        height: 60,
                                        child: FDottedLine(
                                          color: colorTipoAgenda.withOpacity(0.6),
                                          strokeWidth: 2.0,
                                          dottedLength: 10.0,
                                          space: 2.0,
                                          corner: FDottedLineCorner.all(14.0),

                                          /// add widget
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text("Adjuntar archivo",  style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: colorTipoAgenda.withOpacity(0.8)
                                            ),),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ListView.builder(
                                padding: EdgeInsets.only(left: 24, right: 24, top: 16.0, bottom: 110),
                                itemCount: controller.eventoAdjuntoUiList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index){
                                  EventoAdjuntoUi eventoAdjuntoUi = controller.eventoAdjuntoUiList[index];
                                  return Stack(
                                    children: [
                                      Center(
                                        child: InkWell(
                                          onTap: () async{
                                            if(eventoAdjuntoUi.tipoRecursosUi == TipoRecursosUi.TIPO_VINCULO ||
                                                eventoAdjuntoUi.tipoRecursosUi == TipoRecursosUi.TIPO_VINCULO_YOUTUBE){
                                              await AppUrlLauncher.openLink(eventoAdjuntoUi.titulo, webview: false);
                                            }else{
                                              await AppUrlLauncher.openLink(DriveUrlParser.getUrlDownload(eventoAdjuntoUi.driveId), webview: false);
                                            }
                                          },
                                          child:  Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8), // use instead of BorderRadius.all(Radius.circular(20))
                                                border:  Border.all(
                                                    width: 1,
                                                    color: colorTipoAgenda
                                                ),
                                                color: eventoAdjuntoUi.success == false? AppTheme.red.withOpacity(0.1):AppTheme.white
                                            ),
                                            margin: EdgeInsets.only(bottom: 8),
                                            width: 450,
                                            height: 50,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(right: 16),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                            bottomLeft: Radius.circular(8),
                                                            topLeft: Radius.circular(8),
                                                          ), // use instead of BorderRadius.all(Radius.circular(20))
                                                          color: AppTheme.greyLighten2,
                                                        ),
                                                        width: 50,
                                                        child: Center(
                                                          child: Image.asset(getImagen(eventoAdjuntoUi)??"",
                                                            height: 30.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("${eventoAdjuntoUi.titulo??""}", style: TextStyle(color: AppTheme.greyDarken3, fontSize: 12),),
                                                          ],
                                                        ),
                                                      ),
                                                      eventoAdjuntoUi.success == false?
                                                      InkWell(
                                                        onTap: (){
                                                          controller.refreshEventoAdjuntoUi(eventoAdjuntoUi);
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(right: 16),
                                                          child: Icon(Icons.refresh),
                                                        ),
                                                      ):Container(),
                                                      InkWell(
                                                        onTap: (){
                                                          controller.removeEventoAdjuntoUi(eventoAdjuntoUi);
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets.only(right: 16),
                                                          child: Icon(Icons.close),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                !(eventoAdjuntoUi.success != null)&&(eventoAdjuntoUi.progress??0)>0?
                                                Column(
                                                  children: [
                                                    Expanded(child: Container()),
                                                    ProgressBar(
                                                      current: eventoAdjuntoUi.progress??0,
                                                      max: 100,
                                                      borderRadiusGeometry:BorderRadius.only(bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
                                                      color: colorTipoAgenda,
                                                    )
                                                  ],
                                                ):Container()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 100),
                            )
                          ])
                      ),
                    ]
                ),
              )
          );
        });

  }

  String? getImagen(EventoAdjuntoUi? eventoAdjuntoUi){
    switch(eventoAdjuntoUi?.tipoRecursosUi??TipoRecursosUi.TIPO_VINCULO){
      case TipoRecursosUi.TIPO_VIDEO:
        return AppImagen.archivo_video;
      case TipoRecursosUi.TIPO_VINCULO:
        return AppImagen.archivo_link;
      case TipoRecursosUi.TIPO_DOCUMENTO:
        return AppImagen.archivo_documento;
      case TipoRecursosUi.TIPO_IMAGEN:
        return AppImagen.archivo_imagen;
      case TipoRecursosUi.TIPO_AUDIO:
        return AppImagen.archivo_audio;
      case TipoRecursosUi.TIPO_HOJA_CALCULO:
        return AppImagen.archivo_hoja_calculo;
      case TipoRecursosUi.TIPO_DIAPOSITIVA:
        return AppImagen.archivo_diapositiva;
      case TipoRecursosUi.TIPO_PDF:
        return AppImagen.archivo_pdf;
      case TipoRecursosUi.TIPO_VINCULO_YOUTUBE:
        return AppImagen.archivo_youtube;
      case TipoRecursosUi.TIPO_VINCULO_DRIVE:
        return AppImagen.archivo_drive;
      case TipoRecursosUi.TIPO_RECURSO:
        return AppImagen.archivo_recurso;
      case TipoRecursosUi.TIPO_ENCUESTA:
        return AppImagen.archivo_recurso;
    }
  }

  Future<bool?> _showMaterialDialog() async {
    return await showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return ArsProgressWidget(
              blur: 2,
              backgroundColor: Color(0x33000000),
              animationDuration: Duration(milliseconds: 500),
              loadingWidget: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // if you need this
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            child: Icon(Ionicons.close, size: 35, color: AppTheme.white,),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorTipoAgenda),
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("Salir sin guardar", style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: AppTheme.fontTTNormsMedium
                                  ),),
                                  Padding(padding: EdgeInsets.all(8),),
                                  Text("¿Está seguro que quiere salir?",
                                    style: TextStyle(
                                        fontSize: 14,
                                        height: 1.5
                                    ),),
                                  Padding(padding: EdgeInsets.all(16),),
                                ],
                              )
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Cancelar', style: TextStyle(color: colorTipoAgenda, fontSize: 13),),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            style: ElevatedButton.styleFrom(
                              primary:colorTipoAgenda,
                              onPrimary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Salir sin guardar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13
                              ),
                            ),
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              )
          );
        },
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        barrierColor: Colors.transparent,
        transitionDuration:
        const Duration(milliseconds: 150));
  }

  @override
  userImage(File? _image, String? newname) {
    if(globalKey.currentContext!=null&&(_image?.path??"").isNotEmpty){
      CrearAgendaController controller =
      FlutterCleanArchitecture.getController<CrearAgendaController>(globalKey.currentContext!, listen: false);
      List<File?> files = [];
      files.add(_image);
      controller.addEventoAdjunto(files, newname);

    }

  }

  @override
  userDocument(List<File?> _documents) {
    if(globalKey.currentContext!=null){
      CrearAgendaController controller =
      FlutterCleanArchitecture.getController<CrearAgendaController>(globalKey.currentContext!, listen: false);
      controller.addEventoAdjunto(_documents, null);

    }
  }

  @override
  userCrop(Uint8List? _image, String? newName) {

  }

}

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