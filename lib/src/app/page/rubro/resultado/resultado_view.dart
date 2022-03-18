import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/libs/flutterOffline/src/main.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/table_sticky_headers_rubro.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/resultado/resultado_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_column_count.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_icon.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/utils/hex_color.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_calendario_periodo_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_resultado_repository.dart';
import 'package:ss_crmeducativo_2/src/device/repositories/http/device_http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';

import 'table_resultado.dart';

class ResultadoView extends View{
  CursosUi cursosUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;

  ResultadoView(this.cursosUi, this.calendarioPeriodoUI);

  @override
  _ResultadoState createState() => _ResultadoState(cursosUi, calendarioPeriodoUI, key: key);


}

class _ResultadoState extends ViewState<ResultadoView, ResultadoController> with TickerProviderStateMixin{

  late final ScrollController scrollController = ScrollController();
  late final ScrollControllers scrollControllers = ScrollControllers();
  Key? key;
  Function(bool connected)? _onChangeConnected;
  bool? _connected;

  _ResultadoState(CursosUi cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI, {this.key}) : super(ResultadoController(cursosUi, calendarioPeriodoUI, MoorConfiguracionRepository(), MoorCalendarioPeriodoRepository(), MoorResultadoRepository(), DeviceHttpDatosRepositorio()));

  @override
  void initState() {

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {

      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {

      } else if (scrollController.offset <= 0) {

      }
    });

    super.initState();
  }

  @override
  Widget get view => ControlledWidgetBuilder<ResultadoController>(
      builder: (context, controller) {
        return Scaffold(
          key: key,
          extendBody: true,
          backgroundColor: AppTheme.background,
          body: OfflineBuilder(
            connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
                ){
              bool connected = connectivity != ConnectivityResult.none;
              if(_connected!=null && connected != _connected){
                _onChangeConnected?.call(connected);
                if (mounted) {
                  WidgetsBinding.instance?.addPostFrameCallback((_){
                    controller.changeConnected(connected);
                  });
                }

              }
              _connected = connected;
              return Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  Positioned(
                    height: 32.0,
                    left: 0.0,
                    right: 0.0,
                    child: AnimatedOpacity(
                      opacity: !connected ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 3000),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        color: connected ?  Color(0xFF00EE44) : Color(0xFFEE4400),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: connected
                              ? Text('Conectado')
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text('Sin conexión'),
                              SizedBox(width: 8.0),
                              SizedBox(
                                width: 12.0,
                                height: 12.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            child: Stack(
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
          ),
        );
      });

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: AppTheme.white.withOpacity(0),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32.0),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: AppTheme.grey
                      .withOpacity(0.4 * 0),
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
                    left: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 8),
                    right: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 8),
                    top: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 16 - 8.0 ),
                    bottom: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 12 - 8.0)
                ),
                child: ControlledWidgetBuilder<ResultadoController>(
                  builder: (context, controller) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                            child:  IconButton(
                              icon: Icon(Ionicons.arrow_back,
                                  color: AppTheme.nearlyBlack,
                                  size: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 22 + 6 - 6)
                              ),
                              onPressed: () {
                                Navigator.of(this.context).pop();
                              },
                            )
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 8),
                              bottom: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 8),
                              left: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 52),
                              right: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 8)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppIcon.ic_curso_nota_final,
                                height: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 30),
                                width: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 30),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 12),
                                    top: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 0)
                                ),
                                child: Text(
                                  'Resultado',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontTTNorms,
                                    fontWeight: FontWeight.w700,
                                    fontSize: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 22) ,
                                    letterSpacing: 0.8,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 8),
                          right: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 10),
                          child:  InkWell(
                            onTap: ()=> controller.onClicPrecision(),
                            child: Container(
                              width: ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 95),
                              padding: EdgeInsets.all( ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 8)),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular( ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 6))),
                                  color:  controller.precision?HexColor(controller.cursosUi.color2) : AppTheme.greyLighten3
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AppIcon.ic_presicion,
                                    color: controller.precision? AppTheme.white :AppTheme.greyDarken1,
                                    height:  ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 14),
                                    width:  ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 14),
                                  ),
                                  Padding(padding: EdgeInsets.all( ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 2)),),
                                  Text("Precisión",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.5,
                                        color:  controller.precision? AppTheme.white :AppTheme.greyDarken1,
                                        fontSize:  ColumnCountProvider.aspectRatioForWidthButtonRubroResultado(context, 11),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        )
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
    return ControlledWidgetBuilder<ResultadoController>(
        builder: (context, controller) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: AppBar().preferredSize.height + 20,
                  left: 0, //24,
                  right: 0, //48
                ),
                child: Column(
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
                            top: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 24),
                            left: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 20),
                            right: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 20),
                          ),
                          decoration: BoxDecoration(
                              color: AppTheme.redLighten5,
                              borderRadius: BorderRadius.all(Radius.circular(ColumnCountProvider.aspectRatioForWidthTableRubro(context, 8)))
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 24),
                                  height: ColumnCountProvider.aspectRatioForWidthTableRubro(context, 24),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color:  Colors.red,
                                    ),
                                  )
                              ),
                              Padding(padding: EdgeInsets.all(ColumnCountProvider.aspectRatioForWidthTableRubro(context, 4))),
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
                    Expanded(
                        child: Center(
                      child: TableResultado(
                        calendarioPeriodoUI: controller.calendarioPeriodoUI,
                        rows: controller.rows,
                        cells: controller.cells,
                        headers: controller.headers,
                        columns: controller.columns,
                        datosOffline: !controller.conexion,
                        cursosUi: controller.cursosUi,
                        precision: controller.precision,
                        scrollControllers: scrollControllers,
                      ),
                    )
                    )
                  ],
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: Container(
                  width: 32,
                  padding: EdgeInsets.only(
                    top: AppBar().preferredSize.height +
                        MediaQuery
                            .of(context)
                            .padding
                            .top +
                        0,
                  ),
                  child: Center(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.calendarioPeriodoList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Center(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 0, left: 8, right: 0, bottom: 0),
                                decoration: BoxDecoration(
                                  color: controller.cursosUi.color3 != null
                                      ? HexColor(controller.cursosUi.color3)
                                      : AppTheme.colorAccent,
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    bottomLeft: const Radius.circular(10.0),
                                  ),
                                ),
                                child: Container(
                                  height: 110,
                                  margin: const EdgeInsets.only(
                                      top: 1, left: 1, right: 1, bottom: 1),
                                  decoration: BoxDecoration(
                                    color: controller
                                        .calendarioPeriodoList[index]
                                        .selected ?? false
                                        ? AppTheme.white
                                        : controller.cursosUi.color3 != null
                                        ? HexColor(controller.cursosUi.color3)
                                        : AppTheme.colorAccent,
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(10.0),
                                      bottomLeft: const Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      focusColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(9.0)),
                                      splashColor: AppTheme.black.withOpacity(
                                          0.1),
                                      onTap: () {
                                        controller.onSelectedCalendarioPeriodo(
                                            controller
                                                .calendarioPeriodoList[index]);
                                      },
                                      child: Center(
                                        child: RotatedBox(quarterTurns: 1,
                                            child: Text(controller
                                                .calendarioPeriodoList[index]
                                                .nombre ?? "".toUpperCase(),
                                              style: TextStyle(color: controller
                                                  .calendarioPeriodoList[index]
                                                  .selected ?? false
                                                  ? (controller.cursosUi
                                                  .color3 != null
                                                  ? HexColor(
                                                  controller.cursosUi.color3)
                                                  : AppTheme.colorAccent)
                                                  : AppTheme.white,
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 9),)
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          );
                        }
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

}


