import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/sesion_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_utils.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/competencia_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/desempenio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/icd_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tema_criterio_ui.dart';

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
        SliverPadding(
            padding: EdgeInsets.only(left: 24, right: 24),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    margin: EdgeInsets.only(top: 24, left: 0, right: 0),
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
                  ListView.builder(
                      padding: EdgeInsets.only(top: 0, bottom: 0),
                      itemCount: controller.competenciaUiList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                        CompetenciaUi competenciaUi = controller.competenciaUiList[index];
                        return Container(
                          decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.all(Radius.circular(6))
                          ),
                          margin: EdgeInsets.only(top: 16),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${competenciaUi.tipoCompetencia}",
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
                                      TextSpan(text: "${competenciaUi.nombre}"),
                                    ],
                                  ),
                                ),
                              ),
                              ListView.builder(
                                  padding: EdgeInsets.only(top: 0, bottom: 0),
                                  itemCount: competenciaUi.capacidadUiList?.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index){
                                    CapacidadUi capacidadUi = competenciaUi.capacidadUiList![index];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
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
                                                TextSpan(text: "${capacidadUi.nombre}"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ListView.builder(
                                            padding: EdgeInsets.only(top: 0, bottom: 0),
                                            itemCount: capacidadUi.desempenioUiList?.length,
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index){
                                              DesempenioUi desempenioUi = capacidadUi.desempenioUiList![index];
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
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
                                                                "${desempenioUi.desempenio}"
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
                                                          child: Container(
                                                            margin: EdgeInsets.only(left: 8),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                ListView.builder(
                                                                    padding: EdgeInsets.only(top: 0, bottom: 0),
                                                                    itemCount: desempenioUi.icdUiList?.length,
                                                                    shrinkWrap: true,
                                                                    physics: NeverScrollableScrollPhysics(),
                                                                    itemBuilder: (context, index){
                                                                      IcdUi icdUi = desempenioUi.icdUiList![index];
                                                                      return Column(
                                                                        children: [
                                                                          Container(
                                                                            child: Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text("${(index+1).toString().padLeft(2, '0')}. ",
                                                                                  style: TextStyle(
                                                                                    fontSize: 10.0,
                                                                                    color: AppTheme.darkerText,
                                                                                    height: 1.5,
                                                                                    fontWeight: FontWeight.w400,
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                    child: Text("${icdUi.titulo?.replaceAll("\n", " ").trim()??""}",
                                                                                      style: TextStyle(
                                                                                        fontSize: 10.0,
                                                                                        color: AppTheme.darkerText,
                                                                                        height: 1.5,
                                                                                        fontWeight: FontWeight.w400,
                                                                                      ),
                                                                                    )
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          ListView.builder(
                                                                              padding: EdgeInsets.only(top: 0, bottom: 0),
                                                                              itemCount: icdUi.temaCriterioUiList?.length,
                                                                              shrinkWrap: true,
                                                                              physics: NeverScrollableScrollPhysics(),
                                                                              itemBuilder: (context, index){
                                                                                TemaCriterioUi temaCriterioUi = icdUi.temaCriterioUiList![index];
                                                                                return Column(
                                                                                  children: [
                                                                                    Container(
                                                                                      margin: EdgeInsets.only(left: 20),
                                                                                      child: Row(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text("${AppUtils.indexAlfabetico(index)}. ",
                                                                                            style: TextStyle(
                                                                                              fontSize: 10.0,
                                                                                              color: AppTheme.darkerText,
                                                                                              height: 1.5,
                                                                                              fontWeight: FontWeight.w400,
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                              child: Text("${temaCriterioUi.titulo?.replaceAll("\n", " ")??""}",
                                                                                                style: TextStyle(
                                                                                                  fontSize: 10.0,
                                                                                                  color: AppTheme.darkerText,
                                                                                                  height: 1.5,
                                                                                                  fontWeight: FontWeight.w400,
                                                                                                ),
                                                                                              )
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    ListView.builder(
                                                                                        padding: EdgeInsets.only(top: 0, bottom: 0),
                                                                                        itemCount: temaCriterioUi.temaCriterioUiList?.length,
                                                                                        shrinkWrap: true,
                                                                                        physics: NeverScrollableScrollPhysics(),
                                                                                        itemBuilder: (context, index){
                                                                                          TemaCriterioUi temaCriHijoUi = temaCriterioUi.temaCriterioUiList![index];
                                                                                          return Column(
                                                                                            children: [
                                                                                              Container(
                                                                                                margin: EdgeInsets.only(left: 30),
                                                                                                child: Row(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Text("* ",
                                                                                                      style: TextStyle(
                                                                                                        fontSize: 10.0,
                                                                                                        color: AppTheme.darkerText,
                                                                                                        height: 1.5,
                                                                                                        fontWeight: FontWeight.w400,
                                                                                                      ),
                                                                                                    ),
                                                                                                    Expanded(
                                                                                                        child: Text("${temaCriHijoUi.titulo?.replaceAll("\n", " ").trim()??""}",
                                                                                                          style: TextStyle(
                                                                                                            fontSize: 10.0,
                                                                                                            color: AppTheme.darkerText,
                                                                                                            height: 1.5,
                                                                                                            fontWeight: FontWeight.w400,
                                                                                                          ),
                                                                                                        )
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          );
                                                                                        }
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              }
                                                                          ),
                                                                        ],
                                                                      );
                                                                    }
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              );
                                            }
                                        ),
                                      ],
                                    );
                                  }
                              ),

                            ],
                          ),
                        );
                      }
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
                          ListView.builder(
                              padding: EdgeInsets.only(top: 0, bottom: 0),
                              itemCount: controller.temaCriterioUiList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index){
                                TemaCriterioUi temaCriterioUi = controller.temaCriterioUiList[index];
                                return Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.add, size: 17,),
                                          Padding(padding: EdgeInsets.all(4)),
                                          Text("${(index+1).toString().padLeft(2, '0')}. ",
                                            style: TextStyle(
                                              fontSize: 11.0,
                                              color: AppTheme.darkerText,
                                              height: 1.5,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Expanded(
                                              child: Text("${temaCriterioUi.titulo?.replaceAll("\n", " ")??""}",
                                                style: TextStyle(
                                                  fontSize: 11.0,
                                                  color: AppTheme.darkerText,
                                                  height: 1.5,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )
                                          )
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                        padding: EdgeInsets.only(top: 0, bottom: 8),
                                        itemCount: temaCriterioUi.temaCriterioUiList?.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index){
                                          TemaCriterioUi temaCriHijoUi = temaCriterioUi.temaCriterioUiList![index];
                                          return Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: 30, bottom: 4, top: 2),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${AppUtils.indexAlfabetico(index)}. ",
                                                      style: TextStyle(
                                                        fontSize: 11.0,
                                                        color: AppTheme.darkerText,
                                                        height: 1.5,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Text("${temaCriHijoUi.titulo?.replaceAll("\n", " ").trim()??""}",
                                                          style: TextStyle(
                                                            fontSize: 11.0,
                                                            color: AppTheme.darkerText,
                                                            height: 1.5,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        )
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                    ),
                                  ],
                                );
                              }
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 200),)
                ])
            ),
        )
      ],
    );
  }


}