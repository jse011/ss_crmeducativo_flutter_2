import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/src/app/page/editar_usuario/editar_usuario_controller.dart';
import 'package:ss_crmeducativo_2/src/app/routers.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_imagen.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/animation_view.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/image_picker/image_picker_handler.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';

class EditarUsuarioView extends View{
  UsuarioUi? usuarioUi;

  EditarUsuarioView(this.usuarioUi);

  @override
  EditarUsuarioViewState createState() => EditarUsuarioViewState(usuarioUi);

}

class EditarUsuarioViewState extends ViewState<EditarUsuarioView, EditarUsuarioController> with  TickerProviderStateMixin,ImagePickerListener {

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  late AnimationController _imagePickerAnimationcontroller;
  late ImagePickerHandler imagePicker;
  GlobalKey globalKey = GlobalKey();

  EditarUsuarioViewState(UsuarioUi? usuarioUi): super(EditarUsuarioController(usuarioUi, DeviceHttpDatosRepositorio(), MoorConfiguracionRepository()));

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



  void initDialog(){
    /*  ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    ArsProgressDialog customProgressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        loadingWidget: Container(
          width: 150,
          height: 150,
          color: Colors.red,
          child: CircularProgressIndicator(),
        ));*/
  }

  @override
  void dispose() {
    _imagePickerAnimationcontroller.dispose();
    super.dispose();
  }
  @override
  Widget get view =>
      ControlledWidgetBuilder<EditarUsuarioController>(
          builder: (context, controller) {
            return Container(
              key: globalKey,
              color: AppTheme.background,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: <Widget>[
                    getMainTab(),
                    getAppBarUI(),
                    controller.showDialog?ArsProgressWidget(
                        blur: 2,
                        backgroundColor: Color(0x33000000),
                        animationDuration: Duration(milliseconds: 500)
                    ):Container()
                  ],
                ),
              ),
            );
          }
      );

  int countView = 4;
  @override
  Widget getMainTab(){

    return ControlledWidgetBuilder<EditarUsuarioController>(
        builder: (context, controller) {

          if(controller.dissmis) {
            SchedulerBinding.instance?.addPostFrameCallback((_) {
              // fetch data
              AppRouter.createRouteMain(context);
            });
            controller.clearDissmis();
          }

          return Container(
              padding: EdgeInsets.only(
                top: AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top +
                    0,
              ),
              child: CustomScrollView(
                  controller: scrollController,
                  slivers: <Widget>[
                    if(controller.usuarioUi!=null)
                      SliverList(
                          delegate: SliverChildListDelegate([
                            Center(
                              child:  Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 90,right: 90),
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 48),
                                      height: 120,
                                      width: 120,
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppTheme.white,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(color: AppTheme.grey.withOpacity(0.6), offset: const Offset(2.0, 4.0), blurRadius: 8),
                                        ],
                                      ),
                                      child: GestureDetector(
                                          onTap: (){
                                            //controller.onChangeImageUsuario();
                                            imagePicker.showDialog(context,
                                                botonRemoverImagen:
                                                (controller.foto != null && !(controller.foto?.contains("default.png")??false))?
                                                    () async{
                                                  EditarUsuarioController controller =
                                                  FlutterCleanArchitecture.getController<EditarUsuarioController>(globalKey.currentContext!, listen: false);
                                                  await _showRemoverPersona(context, controller);
                                                }:null
                                            );
                                          },
                                          child:  controller.fotoFile!=null?Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                                  image: DecorationImage(
                                                    image: FileImage(controller.fotoFile!),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(color: AppTheme.grey.withOpacity(0.4), offset: const Offset(2.0, 2.0), blurRadius: 6),
                                                  ]
                                              )
                                          ):
                                          controller.foto==null?
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                                  image: DecorationImage(
                                                    image: AssetImage(AppImagen.usuario_default),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  boxShadow: <BoxShadow>[
                                                    BoxShadow(color: AppTheme.grey.withOpacity(0.4), offset: const Offset(2.0, 2.0), blurRadius: 6),
                                                  ]
                                              )
                                          ):
                                          CachedNetworkImage(
                                            placeholder: (context, url) => CircularProgressIndicator(),
                                            imageUrl: controller.foto??'',
                                            errorWidget: (context, url, error) =>  Icon(Icons.error_outline_rounded, size: 80,),
                                            imageBuilder: (context, imageProvider) => Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    boxShadow: <BoxShadow>[
                                                      BoxShadow(color: AppTheme.grey.withOpacity(0.4), offset: const Offset(2.0, 2.0), blurRadius: 6),
                                                    ]
                                                )
                                            ),
                                          )
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child:  Container(
                                      width: 85,
                                      height: 30,
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        color: AppTheme.deepPurpleAccent2,
                                      ),
                                      child: GestureDetector(
                                          onTap: (){
                                            //controller.onChangeImageUsuario();
                                            imagePicker.showDialog(context,
                                                botonRemoverImagen:
                                                (controller.foto != null && !(controller.foto?.contains("default.png")??false))?
                                                    () async{
                                                  EditarUsuarioController controller =
                                                  FlutterCleanArchitecture.getController<EditarUsuarioController>(globalKey.currentContext!, listen: false);
                                                  await _showRemoverPersona(context, controller);
                                                }:null
                                            );
                                          },
                                          child:  Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(19)),
                                              color: AppTheme.background,
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8, right: 4),
                                                  child: Icon(Icons.camera_alt_outlined, color: AppTheme.deepPurpleAccent2, size: 20,),
                                                ),
                                                Expanded(
                                                    child: Text("Editar", style: TextStyle(color: AppTheme.deepPurpleAccent2, fontFamily: AppTheme.fontTTNorms, fontWeight: FontWeight.w700),)
                                                )
                                              ],
                                            ),
                                          )
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Textform Field
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
                              child:  TextFormField(
                                key: Key("Nombre_${controller.usuarioUi?.personaUi?.personaId??""}"),
                                enabled: false,
                                maxLength: 50,
                                autofocus: false,
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black,
                                    fontFamily: AppTheme.fontTTNorms
                                ),
                                initialValue: controller.usuarioUi?.personaUi?.nombres??'',
                                //controller: accountController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: "Nombres",
                                  labelStyle: TextStyle(
                                    color:  AppTheme.deepPurpleAccent2,
                                    fontFamily: AppTheme.fontTTNorms
                                  ),
                                  helperText: "Desabiliado",
                                  contentPadding: EdgeInsets.all(15.0),
                                  prefixIcon: Icon(
                                    Icons.account_circle,
                                    color: AppTheme.deepPurpleAccent2,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.account_box,
                                    color: AppTheme.deepPurpleAccent2,
                                  ),
                                  errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  hintText: "Ingrese su nombre",
                                  hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  focusColor: AppTheme.colorAccent,
                                ),
                                onChanged: (str) {

                                },
                                onSaved: (str) {
                                  //  To do
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                              child:  TextFormField(
                                key: Key("Fecha_Nac_${controller.usuarioUi?.personaUi?.personaId??""}"),
                                enabled: false,
                                maxLength: 50,
                                autofocus: false,
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black,
                                    fontFamily: AppTheme.fontTTNorms
                                ),
                                initialValue: controller.usuarioUi?.personaUi?.fechaNacimiento2??'',
                                //controller: accountController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: "Fecha de nacimiento",
                                  labelStyle: TextStyle(
                                    color:  AppTheme.deepPurpleAccent2,
                                      fontFamily: AppTheme.fontTTNorms
                                  ),
                                  helperText: "Desabiliado",
                                  contentPadding: EdgeInsets.all(15.0),
                                  prefixIcon: Icon(
                                    Icons.account_circle,
                                    color: AppTheme.deepPurpleAccent2,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.today_outlined,
                                    color: AppTheme.deepPurpleAccent2,
                                  ),
                                  errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  hintText: "Ingrese su fecha de nacimiento",
                                  hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  focusColor: AppTheme.colorAccent,
                                ),
                                onChanged: (str) {
                                  // To do
                                },
                                onSaved: (str) {
                                  //  To do
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                              child:  TextFormField(
                                key: Key("Telefono_${controller.usuarioUi?.personaUi?.personaId??""}"),
                                enabled: true,
                                maxLength: 50,
                                autofocus: false,
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black,
                                    fontFamily: AppTheme.fontTTNorms
                                ),
                                initialValue: controller.usuarioUi?.personaUi?.telefono??'',
                                //controller: accountController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: "Número de telefono",
                                  labelStyle: TextStyle(
                                    color:  AppTheme.deepPurpleAccent2,
                                      fontFamily: AppTheme.fontTTNorms
                                  ),
                                  helperText: "Actualice su telefono",
                                  contentPadding: EdgeInsets.all(15.0),
                                  prefixIcon: Icon(
                                    Icons.account_circle,
                                    color: AppTheme.deepPurpleAccent2,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.call_end_outlined,
                                    color: AppTheme.deepPurpleAccent2,
                                  ),
                                  errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  hintText: "Ingrese su número de telefono",
                                  hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  focusColor: AppTheme.colorAccent,
                                ),
                                onChanged: (str) {
                                  controller.usuarioUi?.personaUi?.telefono = str;
                                },
                                onSaved: (str) {
                                  //  To do
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                              child:  TextFormField(
                                key: Key("Correo_${controller.usuarioUi?.personaUi?.personaId??""}"),
                                enabled: true,
                                maxLength: 50,
                                autofocus: false,
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black,
                                    fontFamily: AppTheme.fontTTNorms
                                ),
                                initialValue: controller.usuarioUi?.personaUi?.correo??'',
                                //controller: accountController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: "Correo",
                                  labelStyle: TextStyle(
                                    color:  AppTheme.deepPurpleAccent2,
                                      fontFamily: AppTheme.fontTTNorms
                                  ),
                                  helperText: "Actualice su correo",
                                  contentPadding: EdgeInsets.all(15.0),
                                  prefixIcon: Icon(
                                    Icons.account_circle,
                                    color: AppTheme.deepPurpleAccent2,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.email_outlined,
                                    color: AppTheme.deepPurpleAccent2,
                                  ),
                                  errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  hintText: "Ingrese su correo",
                                  hintStyle: Theme.of(context).textTheme.caption?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.deepPurpleAccent2,
                                    ),
                                  ),
                                  focusColor: AppTheme.colorAccent,
                                ),
                                onChanged: (str) {
                                  controller.usuarioUi?.personaUi?.correo = str;
                                },
                                onSaved: (str) {
                                  //  To do
                                },
                              ),
                            ),
                          ])
                      ),
                    SliverList(
                        delegate: SliverChildListDelegate([
                          Container(
                            height: 100,
                          )
                        ])
                    ),
                  ]
              )
          );
        });
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
                    right: 16,
                    top: 16 - 8.0 * topBarOpacity,
                    bottom: 12 - 8.0 * topBarOpacity),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Ionicons.arrow_back, color: AppTheme.nearlyBlack, size: 22 + 6 - 6 * topBarOpacity,),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Editar mi perfil',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: AppTheme.fontTTNorms,
                            fontWeight: FontWeight.w700,
                            fontSize: 18 + 6 - 6 * topBarOpacity,
                            color: AppTheme.darkerText,
                          ),
                        ),
                      ),
                    ),
                    ControlledWidgetBuilder<EditarUsuarioController>(
                      builder: (context, controller) {

                        if((controller.mensaje??"").isNotEmpty){
                          Fluttertoast.showToast(
                            msg: controller.mensaje??"",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                          );
                          controller.successMsg();
                        }

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                            splashColor: AppTheme.deepPurpleAccent2.withOpacity(0.4),
                            onTap: () {
                              //if(widget.cabecera){
                              //Navigator.pop(context, true);
                              //}
                              controller.onSave();
                            },
                            child:
                            Container(
                                padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8, right: 8),
                                child: Row(
                                  children: [
                                    Text("Guardar", style: TextStyle(fontSize: 16, fontFamily: AppTheme.fontTTNorms, color:  AppTheme.deepPurpleAccent2, fontWeight: FontWeight.w700),),
                                  ],
                                )
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  userImage(File? _image) {
    if(globalKey.currentContext!=null){
      EditarUsuarioController controller =
      FlutterCleanArchitecture.getController<EditarUsuarioController>(globalKey.currentContext!, listen: false);
      controller.updateImage(_image);

    }
  }

  @override
  userDocument(List<File?> _documents) {

  }

  Future<bool?> _showRemoverPersona(BuildContext context, EditarUsuarioController controller) async {
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
                                color: AppTheme.deepPurpleAccent2),
                          ),
                          Padding(padding: EdgeInsets.all(8)),
                          Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.all(8),
                                    child: Text("Remover su foto", style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: AppTheme.fontTTNormsMedium
                                    ),),
                                  ),
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("¿Seguro de remover su foto? ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        height: 1.5
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
                                child: Text('Cancelar'),
                                style: OutlinedButton.styleFrom(
                                  primary: AppTheme.deepPurpleAccent2,
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
                              await controller.onClickRemoverFoto();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: AppTheme.deepPurpleAccent2,
                              onPrimary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Padding(padding: EdgeInsets.all(4), child: Text('Aceptar'),),
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