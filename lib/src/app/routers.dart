import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ss_crmeducativo_2/libs/sticky-headers-table/example/main.dart';
import 'package:ss_crmeducativo_2/src/app/page/curso/curso_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/eventos_agenda/agenda/agenda_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/eventos_agenda/crear_agenda/crear_agenda_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/eventos_agenda/informacion/evento_info_complejo_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/eventos_agenda/informacion/evento_info_simple_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/home/home_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/login/login_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/login/login_view_2.dart';
import 'package:ss_crmeducativo_2/src/app/page/login/login_view_3.dart';
import 'package:ss_crmeducativo_2/src/app/page/login/login_view_4.dart';
import 'package:ss_crmeducativo_2/src/app/page/login/login_view_5.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/capacidad/evaluacion_capacidad_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/indicador/individual/evaluacion_indicador_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/indicador/multiple/evaluacion_indicador_multiple_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/evaluacion/peso_criterio/peso_critero_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/portal/rubro_view_2.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/crear/rubro_crear_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/rubro/resultado/resultado_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/lista/sesion_lista_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/sesiones/portal/sesion_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/crear/tarea_crear_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/lista/tarea_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/lista/tarea_view_2.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/portal/portal_tarea_view.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/portal/portal_tarea_view_2.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/wrap_widget_demo.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evaluacion_capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_adjunto_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/evento_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';
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
  static final String EVALUACION_PESO_CRITERIO = 'Curso/Rubro/PesoCriterio';
  static final String EVALUACION_MULTIPLE = 'Curso/Rubro/EvaluacionMultiple';
  static final String EVALUACION_SIMPLE = 'Curso/Rubro/EvaluacionSimple';
  static final String TAREA_PORTAL = 'Curso/Tarea/Portal';
  static final String TAREA_CREAR = 'Curso/Tarea/Crear';
  static final String RESULTADO = 'Curso/Resultado';
  static final String EVENTO_INFO_SIMPLE = 'Evento/InfoSimple';
  static final String EVENTO_INFO_COMPLEJO = 'Evento/InfoComplejo';
  static final String CREAR_EVENTO = 'Evento/CrearEvento';
  static final String AGENDA_PORTAL = 'Evento/Agenda';


  static Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    LOGIN: (BuildContext context) => LoginView5(),
    HOME: (BuildContext context) => HomeView(),
    //CURSO:(BuildContext context) => CursoView(),
  };

  static dynamic? generateRoute(RouteSettings settings) {
    if (settings.name == CURSO) {
      final Map arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) {
          UsuarioUi? usuarioUi = arguments['usuarioUi'];
          CursosUi cursosUi = arguments['cursoUi'];

          return CursoView(cursosUi, usuarioUi);
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
          SesionUi? sesionUi = null;
          TareaUi? tareaUi = null;
          bool online = false;
          if(arguments.containsKey('rubroUi')){
            rubroUi  = arguments['rubroUi'];
          }
          if(arguments.containsKey('calendarioPeriodoUI')){
            calendarioPeriodoUI  = arguments['calendarioPeriodoUI'];
          }
          if(arguments.containsKey('sesionUi')){
            sesionUi = arguments['sesionUi'];
          }
          if(arguments.containsKey('tareaUi')){
            tareaUi = arguments['tareaUi'];
          }
          if(arguments.containsKey('online')){
            online = arguments['online'];
          }
          return RubroCrearView(cursosUi, calendarioPeriodoUI, rubroUi, sesionUi, tareaUi, online);
        },
      );
    }else if(settings.name == TAREA){
      final Map arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) {
          UsuarioUi? usuarioUi = arguments['usuarioUi'];
          CursosUi cursosUi = arguments['cursoUi'];
          return TareaView2(cursosUi, usuarioUi);
        },
      );
    }else if(settings.name == TAREA_CREAR){
      final Map arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) {
          UsuarioUi? usuarioUi = arguments['usuarioUi'];
          CursosUi? cursosUi = arguments['cursoUi'];
          TareaUi? tareaUi = arguments['tareaUi'];
          CalendarioPeriodoUI? calendarioPeriodoUI = arguments["calendarioPeriodoUI"];
          UnidadUi? unidadUi = arguments["unidadUi"];
          SesionUi? sesionUi = arguments["sesionAprendizajeId"];
          return TareaCrearView(usuarioUi, cursosUi, calendarioPeriodoUI, tareaUi, unidadUi, sesionUi);
        },
      );
    }else if(settings.name == SESION_LISTA){
      final Map arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) {
          UsuarioUi? usuarioUi = arguments['usuarioUi'];
          CursosUi? cursosUi = arguments['cursoUi'];
          return SesionListaView(cursosUi, usuarioUi);
        },
      );
    }else if(settings.name == SESION_PORTAL){
      final Map arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) {
          UsuarioUi usuarioUi = arguments['usuarioUi'];
          CursosUi cursosUi = arguments['cursoUi'];
          UnidadUi unidadUi = arguments['unidadUi'];
          SesionUi sesionUi = arguments['sesionUi'];
          CalendarioPeriodoUI calendarioPeriodoUI = arguments["calendarioPeriodoUI"];
          return SesionView(usuarioUi, cursosUi, unidadUi, sesionUi, calendarioPeriodoUI);
        },
      );
    }else if(settings.name == TAREA_PORTAL){
      final Map arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) {
          UsuarioUi? usuarioUi = arguments['usuarioUi'];
          CursosUi? cursosUi = arguments['cursoUi'];
          TareaUi? tareaUi = arguments['tareaUi'];
          CalendarioPeriodoUI? calendarioPeriodoUI = arguments["calendarioPeriodoUI"];
          UnidadUi? unidadUi = arguments["unidadUi"];
          SesionUi? sesionUi = arguments["sesionUi"];
          return PortalTareaView2(usuarioUi, cursosUi, tareaUi, calendarioPeriodoUI, unidadUi, sesionUi);
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
    }else if(settings.name == EVALUACION_PESO_CRITERIO){
      final Map arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) {
          CursosUi cursosUi = arguments['cursoUi'];
          CapacidadUi? capacidadUi  = arguments['capacidadUi'];
          return PesoCriterioView(capacidadUi, cursosUi);
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
          RubricaEvaluacionUi? rubricaEvaluacionUi = null;
          if(arguments.containsKey('rubricaEvaluacionUi')){
            rubricaEvaluacionUi  = arguments['rubricaEvaluacionUi'];
          }
          CalendarioPeriodoUI calendarioPeriodoUI = arguments['calendarioPeriodoUI'];
          return EvaluacionIndicadorView(rubricaEvaluacionUi, cursosUi, calendarioPeriodoUI);
        },
      );
    }else if(settings.name == RESULTADO){
      final Map arguments = settings.arguments as Map;

      return MaterialPageRoute(
        builder: (context) {
          CursosUi cursosUi = arguments['cursoUi'];
          CalendarioPeriodoUI? calendarioPeriodoUI = arguments['calendarioPeriodoUI'];
          return ResultadoView(cursosUi, calendarioPeriodoUI);
        },
      );
    }else if(settings.name == EVENTO_INFO_SIMPLE){
      final Map arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) {
          EventoUi eventoUi = arguments['eventoUi'];
          EventoAdjuntoUi? eventoAdjuntoUi = arguments['eventoAdjuntoUi'];
          return EventoInfoSimpleView(eventoUi, eventoAdjuntoUi);
        },
      );
    }else if(settings.name == EVENTO_INFO_COMPLEJO){
      EventoUi? eventoUi = settings.arguments as EventoUi;
      return MaterialPageRoute(
        builder: (context) {
          return EventoInfoComplejoView(eventoUi);
        },
      );
    }else if(settings.name == CREAR_EVENTO){
      final Map arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) {
          EventoUi? eventoUi = arguments['eventoUi'];
          CursosUi? cursosUi = arguments['cursosUi'];
          return CrearAgendaView(eventoUi, cursosUi);
        },
      );
    }else if(settings.name == AGENDA_PORTAL){
      final Map arguments = settings.arguments as Map;
      return MaterialPageRoute(
        builder: (context) {
          CursosUi? cursosUi = arguments['cursosUi'];
          return AgendaView(cursosUi);
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


  static void createRouteCursosRouter(BuildContext context, UsuarioUi? usuarioUi, CursosUi cursosUi) {
    Navigator.pushNamed(context,
        CURSO,
        arguments: {'usuarioUi': usuarioUi, 'cursoUi': cursosUi}
    );
  }

  static void createRouteRubrosRouter(BuildContext context, CursosUi cursosUi) {
    Navigator.pushNamed(context,
        RUBRO,
        arguments: cursosUi
    );
  }
  static void createRouteSesionListaRouter(BuildContext context, UsuarioUi? usuarioUi, CursosUi cursosUi) {
    Navigator.pushNamed(context,
        SESION_LISTA,
        arguments:  {'usuarioUi': usuarioUi, 'cursoUi': cursosUi}
    );
  }
  static void createRouteSesionPortalRouter(BuildContext context, UsuarioUi? usuarioUi, CursosUi? cursosUi, UnidadUi? unidadUi, SesionUi? sesionUi, CalendarioPeriodoUI? calendarioPeriodoUI) {
    Navigator.pushNamed(context,
        SESION_PORTAL,
        arguments:  {'usuarioUi': usuarioUi, 'cursoUi': cursosUi, 'unidadUi': unidadUi,'sesionUi':sesionUi, "calendarioPeriodoUI": calendarioPeriodoUI }
    );
  }
  static Future<dynamic> createRouteRubroCrearRouter(BuildContext context, CursosUi? cursosUi,CalendarioPeriodoUI? calendarioPeriodoUI, SesionUi? sesionUi,TareaUi? tareaUi ,RubricaEvaluacionUi? rubroUi, bool online) async{
   return await Navigator.pushNamed(context,
        RUBROCREAR,
        arguments: {'cursoUi': cursosUi, 'calendarioPeriodoUI':calendarioPeriodoUI ,'rubroUi': rubroUi, 'sesionUi': sesionUi, 'tareaUi':tareaUi, 'online': online}
    );
  }

  static createRouteTareaRouter(BuildContext context, UsuarioUi? usuarioUi, CursosUi cursosUi) {
    Navigator.pushNamed(context,
        TAREA,
        arguments: {'usuarioUi': usuarioUi, 'cursoUi': cursosUi}
    );
  }

  static Future<dynamic> createRouteEvaluacionCapacidad(BuildContext context, CursosUi? cursosUi, EvaluacionCapacidadUi? evaluacionCapacidadUi) async{
    return await Navigator.pushNamed(context,
        EVALUACION_CAPACIDAD,
        arguments: {'cursoUi': cursosUi, 'evaluacionCapacidadUi': evaluacionCapacidadUi, }
    );
  }

  static Future<dynamic> createRoutePesoCriterio(BuildContext context, CursosUi? cursosUi, CapacidadUi? capacidadUi) async{
    return await Navigator.pushNamed(context,
        EVALUACION_PESO_CRITERIO,
        arguments: {'cursoUi': cursosUi, 'capacidadUi': capacidadUi, }
    );
  }

  static Future<dynamic> createRouteEvaluacionMultiple(BuildContext context, CalendarioPeriodoUI? calendarioPeriodoUI ,CursosUi? cursosUi, String? rubroEvaluacionId) async{
   return await Navigator.pushNamed(context,
        EVALUACION_MULTIPLE,
        arguments: {'cursoUi': cursosUi, 'rubroEvaluacionId': rubroEvaluacionId, 'calendarioPeriodoUI': calendarioPeriodoUI}
    );
  }

  static Future<dynamic> createRouteEvaluacionSimple(BuildContext context, CursosUi? cursosUi, RubricaEvaluacionUi? rubricaEvaluacionUi, CalendarioPeriodoUI? calendarioPeriodoUI) async{
    return await Navigator.pushNamed(context,
        EVALUACION_SIMPLE,
        arguments: {'cursoUi': cursosUi, 'rubricaEvaluacionUi': rubricaEvaluacionUi, 'calendarioPeriodoUI':  calendarioPeriodoUI}
    );
  }

  static Future<dynamic> createRouteTareaPortalRouter(BuildContext context, UsuarioUi? usuarioUi, CursosUi? cursosUi, TareaUi? tareaUi, CalendarioPeriodoUI? calendarioPeriodoUI, UnidadUi? unidadUi, SesionUi? sesionUi) async{
    print("createRouteTareaPortalRouter: ${unidadUi}");
    return await Navigator.pushNamed(context,
        TAREA_PORTAL,
        arguments:  {'unidadUi': unidadUi, 'usuarioUi': usuarioUi, 'cursoUi': cursosUi, 'tareaUi':tareaUi, 'calendarioPeriodoUI': calendarioPeriodoUI, 'sesionUi': sesionUi }
    );
  }

  static Future<dynamic> createRouteTareaCrearRouter(BuildContext context, UsuarioUi? usuarioUi,CursosUi? cursosUi, TareaUi? tareaUi, CalendarioPeriodoUI? calendarioPeriodoUI, UnidadUi? unidadUi, SesionUi? sesionUi) async{
    print("createRouteTareaCrearRouter: ${unidadUi}");

    return await Navigator.pushNamed(context,
        TAREA_CREAR,
        arguments:  {'usuarioUi': usuarioUi,'cursoUi': cursosUi, 'tareaUi': tareaUi, 'calendarioPeriodoUI': calendarioPeriodoUI, "unidadUi": unidadUi, "sesionUi": sesionUi }
    );

  }

  static createRouteResultadoRouter(BuildContext context, CursosUi cursosUi, CalendarioPeriodoUI? calendarioPeriodoUI) {
    Navigator.pushNamed(context,
        RESULTADO,
        arguments: {'cursoUi': cursosUi,'calendarioPeriodoUI': calendarioPeriodoUI}
    );
  }

  static Future<dynamic> createEventoInfoSimpleRouter(BuildContext context, EventoUi? eventoUi, EventoAdjuntoUi? eventoAdjuntoUi) {
    return Navigator.pushNamed(context,
        EVENTO_INFO_SIMPLE,
        arguments: {'eventoUi': eventoUi,'eventoAdjuntoUi': eventoAdjuntoUi}
    );
  }

  static Future<dynamic> createEventoInfoComplejoRouter(BuildContext context, EventoUi? eventoUi) {
    return Navigator.pushNamed(context,
        EVENTO_INFO_COMPLEJO,
        arguments: eventoUi
    );
  }

  static Future<dynamic> createCrearEventoRouter(BuildContext context, EventoUi? eventoUi, CursosUi? cursosUi) {
    return Navigator.pushNamed(context,
        CREAR_EVENTO,
        arguments: {'eventoUi': eventoUi , 'cursosUi': cursosUi
    }
    );
  }


  static Future<dynamic> showAgendaPortalView(BuildContext context, CursosUi? cursosUi) {
    return Navigator.pushNamed(context,
        AGENDA_PORTAL,
        arguments: {'cursosUi': cursosUi
        }
    );
  }



}



