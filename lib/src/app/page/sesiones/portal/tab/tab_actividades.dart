import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/fdottedline/fdottedline.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/sesion_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';

import 'package:ss_crmeducativo_2/libs/flutter-sized-context/sized_context.dart';

class TabActividades extends StatefulWidget{
  @override
  _TabActividadesSatate createState() => _TabActividadesSatate();

}
class _TabActividadesSatate extends State<TabActividades>{
  Function()? statetDialogActividad;

  @override
  Widget build(BuildContext context) {
    SesionController controller =
    FlutterCleanArchitecture.getController<SesionController>(context, listen: false);
    return CustomScrollView(
      slivers: [

        SliverPadding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 8),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
                  GestureDetector(
                    onTap: () =>  {
                      showActivdadDocente(context)
                    },
                    child: Container(
                      height: 90,
                      margin: EdgeInsets.only(top: 16,left: 0, right: 0, bottom: 20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                              width: 2
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: HexColor(controller.cursosUi.color3).withOpacity(0.1)
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8, left: 16, top: 8, bottom: 8),
                            decoration: BoxDecoration(
                                color: HexColor(controller.cursosUi.color1).withOpacity(1),
                                borderRadius: BorderRadius.all(Radius.circular(16))
                            ),
                            width: 65,
                            height: 65,
                            child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_tipo_actividad_conecta),),
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("CONECTA TU MENTE",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: AppTheme.fontTTNorms,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        letterSpacing: 0.8,
                                        color: AppTheme.darkerText,
                                      )),
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("Inicio",
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 0.8,
                                        color: AppTheme.darkerText,
                                      ))
                                ],
                              )
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: true
                                    ? Icon(
                                  Icons.check_outlined,
                                  size: 25.0,
                                  color: HexColor(controller.cursosUi.color1),
                                )
                                    : Container(width: 25, height: 25,),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>  {
                      showActivdadDocente(context)
                    },
                    child: Container(
                      height: 90,
                      margin: EdgeInsets.only(top: 4,left: 0, right: 0, bottom: 20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                              width: 2
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: HexColor(controller.cursosUi.color3).withOpacity(0.1)
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8, left: 16, top: 8, bottom: 8),
                            decoration: BoxDecoration(
                                color: HexColor(controller.cursosUi.color1).withOpacity(1),
                                borderRadius: BorderRadius.all(Radius.circular(16))
                            ),
                            width: 65,
                            height: 65,
                            child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_tipo_actividad_conecta),),
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("EXPLORANDO Y EXPLICANDO",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      letterSpacing: 0.8,
                                      color: AppTheme.darkerText,
                                    ),),
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("Desarrollo",
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 0.8,
                                        color: AppTheme.darkerText,
                                      ))
                                ],
                              )
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: true
                                    ? Icon(
                                  Icons.check_outlined,
                                  size: 25.0,
                                  color: HexColor(controller.cursosUi.color1),
                                )
                                    : Container(width: 25, height: 25,),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>  {
                      showActivdadDocente(context)
                    },
                    child: Container(
                      height: 90,
                      margin: EdgeInsets.only(top: 8,left: 0, right: 0, bottom: 20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: HexColor(controller.cursosUi.color1).withOpacity(0.5),
                              width: 2
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: HexColor(controller.cursosUi.color2).withOpacity(0.5)
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8, left: 16, top: 8, bottom: 8),
                            decoration: BoxDecoration(
                                color: HexColor(controller.cursosUi.color1).withOpacity(1),
                                borderRadius: BorderRadius.all(Radius.circular(16))
                            ),
                            width: 65,
                            height: 65,
                            child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_tipo_actividad_conecta),),
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("APLICA/REFLEXIONA",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      letterSpacing: 0.8,
                                      color: AppTheme.darkerText,
                                    ),),
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("Desarrollo",
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 0.8,
                                        color: AppTheme.darkerText,
                                      ))
                                ],
                              )
                          ),
                          Container(
                            margin: EdgeInsets.all(1),
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                border: Border.all(
                                    color: HexColor(controller.cursosUi.color1).withOpacity(0.5),
                                    width: 2
                                ),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: true
                                    ? Icon(
                                  Icons.check_outlined,
                                  size: 25.0,
                                  color: HexColor(controller.cursosUi.color1),
                                )
                                    : Icon(
                                  Icons.check_box_outline_blank,
                                  size: 20.0,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>  {
                      showActivdadDocente(context)
                    },
                    child: Container(
                      height: 90,
                      margin: EdgeInsets.only(top: 8,left: 0, right: 0, bottom: 20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                              width: 2
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: HexColor(controller.cursosUi.color3).withOpacity(0.1)
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8, left: 16, top: 8, bottom: 8),
                            decoration: BoxDecoration(
                                color: HexColor(controller.cursosUi.color1).withOpacity(1),
                                borderRadius: BorderRadius.all(Radius.circular(16))
                            ),
                            width: 65,
                            height: 65,
                            child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_tipo_actividad_conecta),),
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("INSTRUMENTO DE EVALUACIÓN",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      letterSpacing: 0.8,
                                      color: AppTheme.darkerText,
                                    ),),
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("Desarrollo",
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 0.8,
                                        color: AppTheme.darkerText,
                                      ))
                                ],
                              )
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: false
                                    ? Icon(
                                  Icons.check_outlined,
                                  size: 25.0,
                                  color: HexColor(controller.cursosUi.color1),
                                )
                                    : Container(width: 25, height: 25,),
                              ),
                            ),

                          ),

                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>  {
                      showActivdadDocente(context)
                    },
                    child: Container(
                      height: 90,
                      margin: EdgeInsets.only(top: 8,left: 0, right: 0, bottom: 20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: HexColor(controller.cursosUi.color1).withOpacity(0.1),
                              width: 2
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: HexColor(controller.cursosUi.color3).withOpacity(0.1)
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8, left: 16, top: 8, bottom: 8),
                            decoration: BoxDecoration(
                                color: HexColor(controller.cursosUi.color1).withOpacity(1),
                                borderRadius: BorderRadius.all(Radius.circular(16))
                            ),
                            width: 65,
                            height: 65,
                            child: Padding(padding: EdgeInsets.all(10), child: SvgPicture.asset(AppIcon.ic_tipo_actividad_conecta),),
                          ),
                          Padding(padding: EdgeInsets.only(left: 8)),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("EVALUACIÓN",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: AppTheme.fontTTNorms,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      letterSpacing: 0.8,
                                      color: AppTheme.darkerText,
                                    ),),
                                  Padding(padding: EdgeInsets.all(4),),
                                  Text("Cierre",
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: 0.8,
                                        color: AppTheme.darkerText,
                                      ))
                                ],
                              )
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: false
                                    ? Icon(
                                  Icons.check_outlined,
                                  size: 25.0,
                                  color: HexColor(controller.cursosUi.color1),
                                )
                                    : Container(width: 25, height: 25,),
                              ),
                            ),

                          ),

                        ],
                      ),
                    ),
                  ),
                ])
            ),
        ),
        SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(padding: EdgeInsets.only( top: 150)),
              ],
            )
        ),
      ],
    );
  }

  void showActivdadDocente(BuildContext context) {
    SesionController controller =
    FlutterCleanArchitecture.getController<SesionController>(context, listen: false);

    showModalBottomSheet(
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {

          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              statetDialogActividad = (){
                setState((){});
              };
              controller.addListener(statetDialogActividad!);
              bool isLandscape = context.isLandscape;
              return Container(
                height: MediaQuery.of(context).size.height * (isLandscape?1:0.7),
                child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: new BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: Container(
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(this.context).padding.top,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                  top: 16 - 8.0,
                                  bottom: 12 - 8.0),
                              child:   Stack(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(top: 0, bottom: 8, left: 8, right: 32),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 8, left: 16, top: 0, bottom: 8),
                                          decoration: BoxDecoration(
                                              color: HexColor(controller.cursosUi.color1).withOpacity(1),
                                              borderRadius: BorderRadius.all(Radius.circular(16))
                                          ),
                                          width: 50,
                                          height: 50,
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: SvgPicture.asset(AppIcon.ic_tipo_actividad_conecta),
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 12, top: 8),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("CONECTA TU MENTE",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: AppTheme.fontTTNorms,
                                                      fontWeight: FontWeight.w800,
                                                      fontSize: 14,
                                                      letterSpacing: 0.8,
                                                      color: AppTheme.darkerText,
                                                    )),
                                                Padding(padding: EdgeInsets.all(4),),
                                                Text("Inicio - 10 min.",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      letterSpacing: 0.8,
                                                      color: AppTheme.darkerText,
                                                    ))
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 10,
                                    child: ClipOval(
                                      child: Material(
                                        color: AppTheme.colorPrimary.withOpacity(0.1), // button color
                                        child: InkWell(
                                          splashColor: AppTheme.colorPrimary, // inkwell color
                                          child: SizedBox(width: 43 + 6, height: 43 + 6,
                                            child: Icon(Ionicons.close, size: 24 + 6,color: AppTheme.colorPrimary, ),
                                          ),
                                          onTap: () {

                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: CustomScrollView(
                                  scrollDirection: Axis.vertical,
                                  slivers: <Widget>[
                                    SliverPadding(
                                      padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
                                      sliver: SliverList(
                                          delegate: SliverChildListDelegate([
                                            Text("Bienvenido apreciado estudiante a la PLATAFORMA EDUCAR; iniciaremos conectándonos primero con nuestro padre celestial y meditando en las enseñanzas bíblicas. ",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  height: 1.4
                                              ),
                                            ),
                                          ])
                                      ),
                                    ),
                                    SliverPadding(
                                      padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
                                      sliver: SliverList(
                                          delegate: SliverChildListDelegate([
                                            Stack(
                                              children: [
                                                Positioned(
                                                  child:  Text("1.1",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          height: 1.4,
                                                          fontWeight: FontWeight.bold
                                                      )
                                                  ),
                                                ),
                                                Positioned(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(left: 40),
                                                      child: Text("GUÍA AUTÓNOMA: Te invito a revisar la:  que es la parte TEÓRICA que como maestro te daré para esta clase virtual. Revisa los conceptos y ejemplos que te daré en la video conferencia, que han sido especialmente diseñadas para apoyar tu aprendizaje. Tienes que estar muy atento y listo para responder las preguntas que haré en el chat virtual de la de la PLATAFORMA EDUCAR. Te ánimo a comunicar tus dudas e inquietudes.    ",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            height: 1.4
                                                        ),),
                                                    )
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 24),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    child:  Text("1.2",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            height: 1.4,
                                                            fontWeight: FontWeight.bold
                                                        )
                                                    ),
                                                  ),
                                                  Positioned(
                                                      child: Padding(
                                                        padding: EdgeInsets.only(left: 40),
                                                        child: Text("PRACTICA DIRIGIDA: Descarga la ficha de trabajo, si es posible imprime:  y escribe la solución en la Ficha de acuerdo a lo que se indique en el desarrollo de la clase y de la explicación en la videoconferencia que la puedes volver a ver si deseas en la grabación.      ",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              height: 1.4
                                                          ),),
                                                      )
                                                  )
                                                ],
                                              ),
                                            )
                                          ])
                                      ),
                                    ),
                                    SliverPadding(
                                      padding: EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 16),
                                      sliver: SliverList(
                                          delegate: SliverChildListDelegate([
                                            Padding(
                                              padding: EdgeInsets.only(top: 0),
                                              child: Row(
                                                children: [
                                                  Padding(padding: EdgeInsets.all(4),),
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      primary: Colors.blue,
                                                    ),
                                                    onPressed: () { },
                                                    child: Text('Atras'),
                                                  ),
                                                  Expanded(child: Container())
                                                  ,TextButton(
                                                    style: TextButton.styleFrom(
                                                      primary: Colors.blue,
                                                    ),
                                                    onPressed: () { },
                                                    child: Text('Siguiente'),
                                                  )
                                                ],
                                              ),
                                            )
                                          ])
                                      ),
                                    ),
                                  ]
                              ),
                            )
                          ],
                        ),
                        if(true)
                          Center(
                            child: CircularProgressIndicator(),
                          )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        })
        .then((value) => {
      if(statetDialogActividad!=null)controller.removeListener(statetDialogActividad!), statetDialogActividad = null
    });
  }
}