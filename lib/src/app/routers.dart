import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/example/main.dart';
import 'package:ss_crmeducativo_2/src/app/page/curso/curso_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/home/home_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/login/login_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/capacidad/evaluacion_capacidad_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/indicador/individual/evaluacion_indicador_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/indicador/multiple/evaluacion_indicador_multiple_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/portal/rubro_view_2.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/crear/rubro_crear_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/lista/sesion_lista_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/sesion_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/lista/tarea_view.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/wrap_widget_demo.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
class AppRouter {
  AppRouter._();

  static final String HOME = '/home';
  static final String LOGIN = '/login';
  static final String CURSO = '/Curso';
  static final String RUBRO = 'Curso/Rubro';
  static final String SESION_LISTA = 'Curso/Sesion';
  static final String SESION_PORTAL = 'Curso/Sesion/Portal';
  static final String TAREA = 'Curso/Tarea';
  static final String RUBROCREAR = 'Curso/Rubro/Crear';
  static final String EVALUACION_CAPACIDAD = 'Curso/Rubro/EvaluacionCapacidad';
  static final String EVALUACION_MULTIPLE = 'Curso/Rubro/EvaluacionMultiple';
  static final String EVALUACION_SIMPLE = 'Curso/Rubro/EvaluacionSimple';

  static Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    LOGIN: (BuildContext context) => LoginView(),
    HOME: (BuildContext context) => HomeView(),
    //CURSO:(BuildContext context) => CursoView(),
  };

  static dynamic? generateRoute(RouteSettings settings) {
    if (settings.name == CURSO) {
      final CursosUi cursosUi = settings.arguments as CursosUi;
      return MaterialPageRoute(
        builder: (context) {
          return CursoView(cursosUi);
        },
      );
    }else if (settings.name == RUBRO) {
      final CursosUi cursosUi = settings.arguments as CursosUi;
      return MaterialPageRoute(
        builder: (context) {
          //return RubroView2(cursosUi);
          return RubroView2(cursosUi);
        },
      );
    }else if(settings.name == RUBROCREAR){
      final Map arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) {
          CursosUi cursosUi = arguments['cursoUi'];
          RubricaEvaluacionUi? rubroUi = null;
          CalendarioPeriodoUI? calendarioPeriodoUI = null;
          if(arguments.containsKey('rubroUi')){
            rubroUi  = arguments['rubroUi'];
          }
          if(arguments.containsKey('calendarioPeriodoUI')){
            calendarioPeriodoUI  = arguments['calendarioPeriodoUI'];
          }
          return RubroCrearView(cursosUi, calendarioPeriodoUI, rubroUi);
        },
      );
    }else if(settings.name == TAREA){
      final CursosUi cursosUi = settings.arguments as CursosUi;
      return MaterialPageRoute(
        builder: (context) {
          return TareaView(cursosUi);
        },
      );
    }else if(settings.name == SESION_LISTA){
      final CursosUi cursosUi = settings.arguments as CursosUi;
      return MaterialPageRoute(
        builder: (context) {
          return SesionListaView(cursosUi);
        },
      );
    }else if(settings.name == SESION_PORTAL){
      final Map arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) {
          CursosUi cursosUi = arguments['cursoUi'];
          SesionUi sesionUi = arguments['sesionUi'];
          return SesionView(cursosUi, sesionUi);
        },
      );
    }else if(settings.name == EVALUACION_CAPACIDAD){
      final Map arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) {
          CursosUi cursosUi = arguments['cursoUi'];
          EvaluacionCapacidadUi? evaluacionCapacidadUi = null;
          if(arguments.containsKey('evaluacionCapacidadUi')){
            evaluacionCapacidadUi  = arguments['evaluacionCapacidadUi'];
          }
          return EvaluacionCapacidadView(evaluacionCapacidadUi, cursosUi);
        },
      );
    }else if(settings.name == EVALUACION_MULTIPLE){
      final Map arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) {
          CursosUi cursosUi = arguments['cursoUi'];
          String rubroEvaluacionId  = arguments['rubroEvaluacionId'];
          CalendarioPeriodoUI calendarioPeriodoUI = arguments['calendarioPeriodoUI'];
          return EvaluacionIndicadorMultipleView(rubroEvaluacionId, cursosUi, calendarioPeriodoUI);
        },
      );
    }else if(settings.name == EVALUACION_SIMPLE){
      final Map arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) {
          CursosUi cursosUi = arguments['cursoUi'];
          String? rubroEvaluacionId = null;
          if(arguments.containsKey('rubroEvaluacionId')){
            rubroEvaluacionId  = arguments['rubroEvaluacionId'];
          }
          CalendarioPeriodoUI calendarioPeriodoUI = arguments['calendarioPeriodoUI'];
          return EvaluacionIndicadorView(rubroEvaluacionId, cursosUi, calendarioPeriodoUI);
        },
      );
    }
  }

  static void createRouteHomeRemoveAll(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        HOME, (Route<dynamic> route) => false);
    //Navigator.of(context).pushReplacementNamed('/home');
    //Navigator.of(context).pushReplacement();


    /*return new MaterialPageRoute(
      builder: (BuildContext context) => new LoginView(),
    );*/
  }

  static void createRouteLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        LOGIN, (Route<dynamic> route) => false);
    //Navigator.of(context).pushReplacementNamed('/login');
    //Navigator.of(context).pushReplacement();


    /*return new MaterialPageRoute(
      builder: (BuildContext context) => new LoginView(),
    );*/
  }


  static void createRouteCursosRouter(BuildContext context, CursosUi cursosUi) {
    Navigator.pushNamed(context,
        CURSO,
        arguments: cursosUi
    );
  }

  static void createRouteRubrosRouter(BuildContext context, CursosUi cursosUi) {
    Navigator.pushNamed(context,
        RUBRO,
        arguments: cursosUi
    );
  }
  static void createRouteSesionListaRouter(BuildContext context, CursosUi cursosUi) {
    Navigator.pushNamed(context,
        SESION_LISTA,
        arguments: cursosUi
    );
  }
  static void createRouteSesionPortalRouter(BuildContext context, CursosUi cursosUi, SesionUi sesionUi) {
    Navigator.pushNamed(context,
        SESION_PORTAL,
        arguments:  {'cursoUi': cursosUi, 'sesionUi':sesionUi}
    );
  }
  static Future<void> createRouteRubroCrearRouter(BuildContext context, CursosUi? cursosUi,CalendarioPeriodoUI? calendarioPeriodoUI, RubricaEvaluacionUi? rubroUi) async{
   await Navigator.pushNamed(context,
        RUBROCREAR,
        arguments: {'cursoUi': cursosUi, 'calendarioPeriodoUI':calendarioPeriodoUI ,'rubroUi': rubroUi}
    );
  }

  static createRouteTareaRouter(BuildContext context, CursosUi cursosUi) {
    Navigator.pushNamed(context,
        TAREA,
        arguments: cursosUi
    );
  }

  static createRouteEvaluacionCapacidad(BuildContext context, CursosUi? cursosUi, EvaluacionCapacidadUi? evaluacionCapacidadUi) async{
    dynamic? object = await Navigator.pushNamed(context,
        EVALUACION_CAPACIDAD,
        arguments: {'cursoUi': cursosUi, 'evaluacionCapacidadUi': evaluacionCapacidadUi, }
    );
  }

  static createRouteEvaluacionMultiple(BuildContext context, CalendarioPeriodoUI? calendarioPeriodoUI ,CursosUi? cursosUi, String? rubroEvaluacionId) async{
    dynamic? object = await Navigator.pushNamed(context,
        EVALUACION_MULTIPLE,
        arguments: {'cursoUi': cursosUi, 'rubroEvaluacionId': rubroEvaluacionId, 'calendarioPeriodoUI': calendarioPeriodoUI}
    );
  }

  static createRouteEvaluacionSimple(BuildContext context, CursosUi? cursosUi, String? rubroEvaluacionId, CalendarioPeriodoUI? calendarioPeriodoUI) async{
    dynamic? object = await Navigator.pushNamed(context,
        EVALUACION_SIMPLE,
        arguments: {'cursoUi': cursosUi, 'rubroEvaluacionId': rubroEvaluacionId, 'calendarioPeriodoUI':  calendarioPeriodoUI}
    );
  }




}



