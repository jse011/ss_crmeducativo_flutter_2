import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/sesion_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';

class TabAprendizaje extends StatefulWidget{
  @override
  _TabAprendizajeState createState() => _TabAprendizajeState();

}

class _TabAprendizajeState extends State<TabAprendizaje>{

  @override
  Widget build(BuildContext context) {
    SesionController controller =
    FlutterCleanArchitecture.getController<SesionController>(context, listen: false);
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
              Container(
                margin: EdgeInsets.only(top: 24),
                height: 170,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16))
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppTheme.colorSesion,
                          borderRadius: BorderRadius.all(Radius.circular(12))
                      ),
                      constraints: BoxConstraints.expand(),
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Expanded(
                            child: Container(),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text("${controller.sesionUi.titulo}",
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppTheme.white.withOpacity(0.9),
                                  fontSize: 22,
                                  fontFamily: AppTheme.fontTTNorms,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                          )

                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(16),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${controller.sesionUi.titulo}",
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppTheme.darkText,
                            fontSize: 14,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 16)),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                              fontSize: 12.0,
                              color: AppTheme.darkText,
                              height: 1.5
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Propósito: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: controller.sesionUi.proposito??""),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(16),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Competencia Base",
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppTheme.darkText,
                            fontSize: 14,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 16)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: HexColor("#3AB174"),
                            padding: EdgeInsets.all(8),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: AppTheme.white,
                                    height: 1.5,
                                    fontWeight: FontWeight.w400
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Competencia:  ', style: new TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: "Explica el mundo físico basándose en conocimientos sobre los seres vivos, materia y energía, biodiversidad, tierra y universo."),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: AppTheme.white,
                            padding: EdgeInsets.all(8),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: AppTheme.darkerText,
                                    height: 1.5,
                                    fontWeight: FontWeight.w400
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Capacidad:  ', style: new TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: "Comprende y usa conocimientos sobre los seres vivos, materia y energía, biodiversidad, Tierra y universo"),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: AppTheme.grey,
                            height: 0.5,
                          ),
                          Container(
                            color: HexColor("#EDECEC"),
                            height: 35,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text("Desempeño",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppTheme.darkerText,
                                            height: 1.5,
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),
                                    )
                                ),
                                Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text("ICDs",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppTheme.darkerText,
                                            height: 1.5,
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: AppTheme.grey,
                            height: 0.5,
                          ),
                          Container(
                            color: AppTheme.white,
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 8),
                                    child: Text(
                                        "Explica que el suelo está formado por seres vivos y no vivos. Ejemplo: El estudiante distingue lo que hay dentro del suelo, tierra, gusanos, rocas, objetos plásticos, etc Justifica por qué el agua, el aire y el suelo son importantes para los seres vivos. (CN 2017: P1-CT-C25-D5) Explica que un sistema puede describirse en términos de sus interacciones. ¿Cómo te relacionas con los demás? ¿Cómo debemos"
                                        ,style: TextStyle(
                                      fontSize: 10.0,
                                      color: AppTheme.darkerText,
                                      height: 1.5,
                                      fontWeight: FontWeight.w400,
                                    ),
                                        textAlign: TextAlign.justify
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text("01. Explica que el suelo",
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            color: AppTheme.darkerText,
                                            height: 1.5,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text("a. ECOSISTEMAS: INTERACCIONES, ENERGÍA, Y DINÁMICA",
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            color: AppTheme.darkerText,
                                            height: 1.5,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 30),
                                        child: Text("* Nuestra necesidades básicas.",
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            color: AppTheme.darkerText,
                                            height: 1.5,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text("01. Explica que el suelo",
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            color: AppTheme.darkerText,
                                            height: 1.5,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text("a. ECOSISTEMAS: INTERACCIONES, ENERGÍA, Y DINÁMICA",
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            color: AppTheme.darkerText,
                                            height: 1.5,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 30),
                                        child: Text("* Nuestra necesidades básicas.",
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            color: AppTheme.darkerText,
                                            height: 1.5,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(16),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Competencia Transversal",
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppTheme.darkText,
                            fontSize: 14,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 16)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: HexColor("#3AB174"),
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppTheme.white,
                                            height: 1.5,
                                            fontWeight: FontWeight.w400
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(text: 'Competencia:  ', style: new TextStyle(fontWeight: FontWeight.bold)),
                                          TextSpan(text: "Servicio Cristiano (Orientación al Bien Común)"),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: AppTheme.white,
                            padding: EdgeInsets.all(8),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: AppTheme.darkerText,
                                    height: 1.5,
                                    fontWeight: FontWeight.w400
                                ),
                                children: <TextSpan>[
                                  TextSpan(text: 'Capacidad:  ', style: new TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: "Demostrar Empatía - Servicio/Convivencia"),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            color: AppTheme.grey,
                            height: 0.5,
                          ),
                          Container(
                            color: HexColor("#EDECEC"),
                            height: 35,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text("Desempeño",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppTheme.darkerText,
                                            height: 1.5,
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),
                                    )
                                ),
                                Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text("ICDs",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppTheme.darkerText,
                                            height: 1.5,
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: AppTheme.grey,
                            height: 0.5,
                          ),
                          Container(
                            color: AppTheme.white,
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 8),
                                    child: Text(
                                        "Identificación afectiva con los sentimientos del otro y disposición para apoyar y comprender sus circunstancias. Se demuestra por ejemplo cuando los docentes identifican, valoran y destacan continuamente actos espontáneos de los estudiantes en beneficio de otros, dirigidos a procurar o restaurar su bienestar en situaciones que lo requieran."
                                        ,style: TextStyle(
                                      fontSize: 12.0,
                                      color: AppTheme.darkerText,
                                      height: 1.5,
                                      fontWeight: FontWeight.w400,
                                    ),
                                        textAlign: TextAlign.justify
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text("01. Disposición a escuchar, comprender y ayudar afectivamente problemas de otras personas",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppTheme.darkerText,
                                            height: 1.5,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text("a. Valores",
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppTheme.darkerText,
                                            height: 1.5,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 30),
                                        child: Text("Empatía",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppTheme.darkerText,
                                            height: 1.5,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.all(Radius.circular(6))
                ),
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(16),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Campos Temáticos",
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppTheme.darkText,
                            fontSize: 14,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 16)),
                      Row(
                        children: [
                          Icon(Icons.add),
                          Padding(padding: EdgeInsets.all(4)),
                          Expanded(
                            child: Text(
                                "1. ECOSISTEMAS: INTERACCIONES, ENERGÍA, Y DINÁMICA",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: AppTheme.darkerText,
                                  height: 1.5,
                                  fontWeight: FontWeight.w400,
                                )
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.add),
                          Padding(padding: EdgeInsets.all(4)),
                          Expanded(
                            child: Text(
                                "1. ECOSISTEMAS: INTERACCIONES, ENERGÍA, Y DINÁMICA",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: AppTheme.darkerText,
                                  height: 1.5,
                                  fontWeight: FontWeight.w400,
                                )
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.add),
                          Padding(padding: EdgeInsets.all(4)),
                          Expanded(
                            child: Text(
                                "1. ECOSISTEMAS: INTERACCIONES, ENERGÍA, Y DINÁMICA",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: AppTheme.darkerText,
                                  height: 1.5,
                                  fontWeight: FontWeight.w400,
                                )
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 200),)
            ])
        ),
      ],
    );
  }


}