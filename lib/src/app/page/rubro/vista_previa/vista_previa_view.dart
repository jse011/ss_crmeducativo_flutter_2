import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/vista_previa/vista_previa_controller.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/data/repositories/moor/moor_rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';

class VistaPreviaView extends View {
  CursosUi? cursosUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;

  VistaPreviaView(this.cursosUi, this.calendarioPeriodoUI);

  @override
  VistaPreviaState createState() => VistaPreviaState(this.cursosUi, this.calendarioPeriodoUI);

}

class VistaPreviaState extends ViewState<VistaPreviaView, VistaPreviaController> with SingleTickerProviderStateMixin {

  VistaPreviaState(CursosUi? cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI) :
        super(VistaPreviaController(cursosUi, calendarioPeriodoUI, MoorRubroRepository(), MoorConfiguracionRepository()));

  @override
  Widget get view =>
      ControlledWidgetBuilder<VistaPreviaController>(
          builder: (context, controller) {
            double stickyLegendWidth = 150;
            double stickyLegendHeight = 45;
            return Scaffold(
              backgroundColor: AppTheme.background,
              extendBody: true,
              body: Center(
                child: InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(20.0),
                  minScale: 0.1,
                  maxScale: 1.6,
                  constrained: false, // Se
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Container(
                              width: stickyLegendWidth,
                              height: stickyLegendHeight,
                              child: Container(
                                color: AppTheme.colorPrimary,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                controller.columnList2.length,
                                    (i) {

                                  return Container(
                                    width: 60,
                                    height: stickyLegendHeight,
                                    child: Container(
                                      color: AppTheme.yellow,
                                      child: Text("${i}", style: TextStyle(color: AppTheme.white),),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // STICKY COLUMN
                            Column(
                              children: List.generate(
                                controller.rowList2.length,
                                    (i) {

                                  return Container(
                                    width: stickyLegendWidth,
                                    height: 60,
                                    child: Container(
                                      color: AppTheme.brown,
                                      child: Text("${i}", style: TextStyle(color: AppTheme.white),),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // CONTENT
                            Column(
                              children: List.generate(
                                controller.rowList2.length,
                                    (int rowIdx) => Row(
                                  children: List.generate(
                                    controller.columnList2.length,
                                        (int columnIdx) {
                                      return Container(
                                        width: 60,
                                        height: 60,
                                        child:  Container(
                                          color: AppTheme.orange,
                                          child: Text("${rowIdx},${columnIdx}", style: TextStyle(color: AppTheme.white),),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });



}


