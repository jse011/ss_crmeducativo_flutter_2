import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/foto_alumno/foto_alumno_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/dropdown_formfield_2.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/image_picker/image_picker_handler.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';

class FotoAlumnoView extends View{
  CursosUi? cursosUi;

  FotoAlumnoView(this.cursosUi);

  @override
  FotoAlumnoViewState createState() => FotoAlumnoViewState(cursosUi);

}

class FotoAlumnoViewState extends ViewState<FotoAlumnoView, FotoAlumnoController> with TickerProviderStateMixin, ImagePickerListener{
  late final ScrollController scrollController = ScrollController();
  late double topBarOpacity = 0.0;
  final _debouncer = Debouncer(milliseconds: 500);
  List<dynamic>? filteredUsers = null;
  GlobalKey globalKey = GlobalKey();
  late AnimationController _imagePickerAnimationcontroller;
  late ImagePickerHandler imagePicker;

  FotoAlumnoViewState(CursosUi? cursosUi) : super(FotoAlumnoController(cursosUi, MoorConfiguracionRepository(), DeviceHttpDatosRepositorio()));

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


    _imagePickerAnimationcontroller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );


    imagePicker=new ImagePickerHandler(this,_imagePickerAnimationcontroller, true);
    imagePicker.init();

    super.initState();
    //initDialog();
  }

  @override
  Widget get view => ControlledWidgetBuilder<FotoAlumnoController>(
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

      return Scaffold(
        key: globalKey,
        backgroundColor: AppTheme.background,
        body: Stack(
          children: [
            getMainTab(),
            controller.progress?  ArsProgressWidget(
              blur: 2,
              backgroundColor: Color(0x33000000),
              animationDuration: Duration(milliseconds: 500),
              dismissable: true,
              onDismiss: (backgraund){
                if(!backgraund){
                  Navigator.of(this.context).pop();
                }

              },
            ):Container(),
            getAppBarUI(),
          ],
        ),
      );
    },
  );

  Future<bool> progressDelay() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 10000));
    return true;
  }

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
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: 16 - 8.0 * topBarOpacity,
                    bottom: 12 - 8.0 * topBarOpacity),
                child: ControlledWidgetBuilder<FotoAlumnoController>(
                  builder: (context, controller) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                            child:  IconButton(
                              icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                              onPressed: () {
                                Navigator.of(this.context).pop();
                              },
                            )
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppIcon.ic_curso_foto_alumno, height: 35 +  6 - 10 * topBarOpacity, width: 35 +  6 - 10 * topBarOpacity,),
                              Padding(
                                padding: EdgeInsets.only(left: 12, top: 8),
                                child: Text(
                                  'Alumnos',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontTTNorms,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 0.8,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget getMainTab() {
    return ControlledWidgetBuilder<FotoAlumnoController>(
        builder: (context, controller) {
          return  Container(
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  0,
              left: 0,//24,
              right: 0,//48
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (!controller.conexion && !controller.progress)?
                  Center(
                    child: Container(
                        constraints: BoxConstraints(
                          //minWidth: 200.0,
                          maxWidth: 600.0,
                        ),
                        height: 45,
                        margin: EdgeInsets.only(
                          top: 24,
                          left: 20,
                          right: 20,
                        ),
                        decoration: BoxDecoration(
                            color: AppTheme.redLighten5,
                            borderRadius: BorderRadius.all(Radius.circular(8))
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width:24,
                                height: 24,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color:  Colors.red,
                                  ),
                                )
                            ),
                            Padding(padding: EdgeInsets.all(4)),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Text('Sin conexión',
                                  style: TextStyle(
                                      color:  Colors.red,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      fontFamily: AppTheme.fontTTNorms
                                  )
                              ),
                            ),
                          ],
                        )
                    ),
                  ): Container(),
                  controller.cursosUiList.isNotEmpty?
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                        child:   Text("Cambiar la foto de mis alumnos de",
                            style: TextStyle(
                                color: AppTheme.darkText,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppTheme.fontTTNorms
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                        child: DropDownFormField2<CursosUi>(
                          inputDecoration: InputDecoration(
                            labelText: "",
                            labelStyle: TextStyle(
                              color:  AppTheme.colorPrimary,
                              fontFamily: AppTheme.fontTTNorms,
                              fontSize: 14,
                            ),
                            contentPadding: EdgeInsets.all(15.0),
                            suffixIcon:  IconButton(
                              onPressed: (){

                              },
                              icon: Icon(
                                Ionicons.caret_down,
                                color: AppTheme.colorPrimary,
                              ),
                              iconSize: 15,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: Color(0XFFF26FC2).withOpacity(0.5),
                              ),
                            ),
                          ),
                          onChanged: (item){
                            controller.onSelectCursoUi(item);
                          },
                          menuItems: controller.cursosUiList.map<DropdownMenuItem<CursosUi>>((e){
                            return  DropdownMenuItem<CursosUi>(
                              child: Padding(
                                padding: EdgeInsets.only(left: 0),
                                child: Text("${e.nombreCurso??""} ${e.gradoSeccion??""} ${e.nivelAcademico??""}", style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontSize: 14,
                                    color: Colors.black
                                )
                                ),
                              ),
                              value: e,
                            );
                          }).toList(),
                          value: controller.cursosUiSelected,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8, left: 24, right: 24, bottom: 8),
                        child: Row(
                          children: [
                            Text("Buscar:",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppTheme.fontTTNorms
                                )),
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
                                                  focusNode: null,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                                                      hintText: "Digite un nombre",
                                                      hintStyle: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: AppTheme.fontTTNorms
                                                      ),
                                                      border: InputBorder.none),
                                                  onChanged: (string) {
                                                    _debouncer.run(() {
                                                      setState(() {
                                                        if(string.isEmpty){
                                                          filteredUsers = null;
                                                        }else{
                                                          filteredUsers = controller.personasUiList
                                                              .where((u){
                                                            if(u is PersonaUi){
                                                              return u.nombreCompleto?.toLowerCase().contains(string.toLowerCase())??false;
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
                        color: AppTheme.colorLine,
                      ),
                      ListView.builder(
                        padding: EdgeInsets.only(top: 0, bottom: 64, left: 0, right: 0),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index){
                          PersonaUi o =  filteredUsers!=null?filteredUsers![index]: controller.personasUiList[index];
                          return Container(
                            //margin: EdgeInsets.only(bottom: 0, top: 16),
                            padding: EdgeInsets.only(bottom: 16, top: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppTheme.colorLine,
                                  width: 1
                                )
                              )
                            ),
                            child: Row(
                              children: [
                                Padding(padding: EdgeInsets.all(16)),
                                Container(
                                    width: 48,
                                    height: 48,
                                    margin: EdgeInsets.only(right: 0, left: 0, top: 0, bottom: 0),
                                    child:    CachedNetworkImage(
                                      placeholder: (context, url) => SizedBox(
                                        child: Shimmer.fromColors(
                                          baseColor: Color.fromRGBO(217, 217, 217, 0.5),
                                          highlightColor: Color.fromRGBO(166, 166, 166, 0.3),
                                          child: Container(
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                                color: AppTheme.grey,
                                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                      imageUrl: o.foto??"",
                                      errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 38,),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                          ),
                                    ),
                                ),
                                Padding(padding: EdgeInsets.all(8)),
                                InkWell(
                                  onTap: (){
                                    if(!(o.progress??false)){
                                      controller.onClickEditarFotoAlumno(o);
                                      imagePicker.showDialog(context,
                                          botonRemoverImagen:
                                          (o.foto != null && !(o.foto?.contains("default.png")??false))?
                                              () async{
                                            FotoAlumnoController controller =
                                            FlutterCleanArchitecture.getController<FotoAlumnoController>(globalKey.currentContext!, listen: false);
                                            await _showRemoverPersona(context, controller, controller.personaUiSelected);
                                          }:null
                                      );
                                    }
                                  },
                                  child: (o.progress??false)?
                                  Stack(
                                    children: [
                                      Container(
                                        height: 56,
                                        width: 56,
                                        child:  CircularProgressIndicator(
                                          color: Color(0XFFF26FC2),
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      Container(
                                        height: 56,
                                        width: 56,
                                        alignment: Alignment.center,
                                        child: Text("${o.progressCount?.toInt()??100}%",
                                          style: TextStyle(
                                              color: Color(0XFFF26FC2),
                                              fontSize: 12,
                                              fontFamily: AppTheme.fontTTNorms,
                                              fontWeight: FontWeight.w700
                                          ),
                                        ),
                                      )
                                    ],
                                  ):FDottedLine(
                                    color: Color(0XFFF26FC2),
                                    strokeWidth: 2.0,
                                    dottedLength: 10.0,
                                    space: 2.0,
                                    corner: FDottedLineCorner.all(14.0),
                                    /// add widget
                                    child: Container(
                                      height: 45,
                                      width: 45,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 0, right: 0),
                                                  child: Icon(Icons.camera_alt_outlined,
                                                    color: Color(0XFFF26FC2),
                                                    size: 18,),
                                                ),
                                                Text("Editar", style: TextStyle(
                                                    color: Color(0XFFF26FC2),
                                                    fontFamily: AppTheme.fontTTNorms,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 10
                                                )
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(8),),
                                Expanded(child: Text("${o.nombreCompleto}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppTheme.fontTTNorms,
                                        color: (o.success == false)? AppTheme.red: null,
                                    )
                                )),
                                if(o.success==false)
                                Padding(padding: EdgeInsets.all(8)),
                                if(o.success==false)
                                InkWell(
                                  onTap: (){
                                    controller.reintentarSubirFoto(o);
                                  },
                                  child: Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(16)),
                                        color: Colors.white
                                      ),
                                      child: Icon(Icons.refresh),
                                  ),
                                ),
                                if(isDefaulFoto(o))
                                Padding(padding: EdgeInsets.all(8)),
                                if(isDefaulFoto(o))
                                InkWell(
                                  onTap: (){
                                    _showRemoverPersona(context, controller,o);
                                  },
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(16)),
                                        color: Colors.white
                                    ),
                                    child: Icon(Ionicons.close),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(16)),
                              ],
                            ),
                          );
                        },
                        itemCount: filteredUsers!=null? filteredUsers?.length :controller.personasUiList.length,
                      )
                    ],
                  ): Container(
                    padding: EdgeInsets.only(top: 150),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: SvgPicture.asset(AppIcon.ic_lista_vacia, width: 150, height: 150,),
                        ),
                        Padding(padding: EdgeInsets.all(4)),
                        Center(
                          child: Text("No se le asigno como responsable\nde ninguna sección.\n ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppTheme.grey,
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                                fontFamily: AppTheme.fontTTNorms
                            ),),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            ),
          );
        });
  }

  @override
  userDocument(List<File?> _documents) {

  }


  bool isDefaulFoto(PersonaUi personaUi){
    return (personaUi.foto != null && !(personaUi.foto?.contains("default.png")??false));
  }

  @override
  userImage(File? _image, String? newname) {
    if(globalKey.currentContext!=null){
      FotoAlumnoController controller =
      FlutterCleanArchitecture.getController<FotoAlumnoController>(globalKey.currentContext!, listen: false);
      controller.updateImage(_image);

    }
  }


  Future<bool?> _showRemoverPersona(BuildContext context, FotoAlumnoController controller, PersonaUi? personaUi) async {
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
                            width: 50,
                            height: 50,
                            child: Icon(Ionicons.trash, size: 35, color: AppTheme.white,),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0XFFF26FC2)),
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.all(8),
                                    child: Text("Borrar la foto de ${personaUi?.nombreCompleto ??""}", style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppTheme.fontTTNorms
                                    ),),
                                  ),
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("¿Seguro de borrar la foto de ${personaUi?.nombreCompleto??""}? ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: AppTheme.fontTTNorms
                                    ),),
                                  Padding(padding: EdgeInsets.all(4),),
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
                                  Navigator.of(context).pop(true);
                                },
                                child: Text('Cancelar' , style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: AppTheme.fontTTNorms
                                ),),
                                style: OutlinedButton.styleFrom(
                                  primary: Color(0XFFF26FC2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop(true);
                               controller.onClickRemoverFotoPersona(personaUi);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0XFFF26FC2),
                              onPrimary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Padding(padding: EdgeInsets.all(4), child: Text('Aceptar', style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: AppTheme.fontTTNorms
                            )),),
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