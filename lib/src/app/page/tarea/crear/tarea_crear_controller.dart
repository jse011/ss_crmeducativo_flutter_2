import 'dart:io';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/tarea/crear/tarea_crear_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/calendario_periodio_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tareaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/tarea_recurso_ui.dart';
import 'package:path/path.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/domain_tools.dart';
import 'package:ss_crmeducativo_2/src/domain/tools/id_generator.dart';

class TareaCrearController extends Controller{

  TareaCrearPresenter presenter;
  CursosUi? cursosUi;
  CalendarioPeriodoUI? calendarioPeriodoUI;
  TareaUi? tareaUi;
  String? _tituloTarea = null;
  String? get tituloTarea => _tituloTarea;
  String? _instruccionesTarea = null;
  String? get instruccionesTarea => _instruccionesTarea;
  DateTime? _fechaTarea = null;
  DateTime? get fechaTarea => _fechaTarea;
  String? _horaTarea = null;
  String? get horaTarea => _horaTarea;
  List<TareaRecusoUi> get tareaRecursoList => _tareaRecursoList;
  List<TareaRecusoUi> _tareaRecursoList = [];
  String? _mensaje = null;
  String? get mensaje => _mensaje;
  bool _progress = false;
  bool get progress => _progress;
  String newTareaId = IdGenerator.generateId();
  int? unidadEventoId;
  int? sesionAprendizajeId;

  Map<TareaRecusoUi, HttpStream?> mapRecurso = Map();

  TareaCrearController(this.cursosUi, this.calendarioPeriodoUI, this.tareaUi, this.unidadEventoId, this.sesionAprendizajeId,
      HttpDatosRepository httpDatosRepo, ConfiguracionRepository configuracionRepo, UnidadTareaRepository unidadTareaRepo):
        presenter = new TareaCrearPresenter(httpDatosRepo, configuracionRepo, unidadTareaRepo);

  @override
  void initListeners() {
      presenter.getCalendarioPeridoOnProgress = (double? progress,  TareaRecusoUi? tareaRecusoUi){
        tareaRecusoUi?.progress = progress;
        refreshUI();
      };

      presenter.getCalendarioPeridoOnSucces = (bool success, TareaRecusoUi? tareaRecusoUi){
        tareaRecusoUi?.success = success;
        refreshUI();
      };

      presenter.saveTareaOnMessage = (bool offline){

      };
  }

  List<int> getPercentPartsV2(int? totalPeso, int? cantidad) {
    if (cantidad == null||cantidad == 0) return [];
    List<int> percentParts = [];

    int subtotalPeso =  ((totalPeso??0)/cantidad).toInt();
    int diferencia = (totalPeso??0) - (subtotalPeso * cantidad);

    for (int i = 0; i < cantidad; i++) {
      percentParts.add(subtotalPeso);
    }

    for (int i = 0; i < diferencia; i++) {
      percentParts[i]+=1;
    }

    return percentParts;
  }


  @override
  void onInitState() {

    super.onInitState();
  }

  void clearTitulo() {
    _tituloTarea = null;
    refreshUI();
  }

  void changeTituloTarea(String str) {
    _tituloTarea = str;
    refreshUI();
  }

  void clearInstruciones() {
    _instruccionesTarea = null;
    refreshUI();
  }

  void changeInstrucciones(String str) {
    _instruccionesTarea = str;
    refreshUI();
  }

  void changeFecha(DateTime? dateTime) {
    _fechaTarea = dateTime;
  }

  void changeHora(String? str) {
    _horaTarea = str;
    print(_horaTarea);
  }

  void addTareaRecursos(List<File?> files) async {
   for(File? file in files){
     if(file!=null){
       TareaRecusoUi tareaRecusoUi = TareaRecusoUi();
       tareaRecusoUi.recursoDidacticoId = null;
       tareaRecusoUi.titulo = basename(file.path);
       tareaRecusoUi.tipoRecurso = DomainTools.getType(file.path);
       tareaRecusoUi.file = file;
       tareaRecusoUi.silaboEventoId = cursosUi?.silaboEventoId;
       _tareaRecursoList.add(tareaRecusoUi);

       HttpStream? httpStream = await presenter.uploadTareaRecurso(tareaRecusoUi, cursosUi);
       mapRecurso[tareaRecusoUi] = httpStream;
     }
     refreshUI();
   }


  }

  void removeTareaRecurso(TareaRecusoUi tareaRecursoUi) {
    if(tareaRecursoUi.success == null){
      if(mapRecurso.containsKey(tareaRecursoUi)){
        HttpStream? httpStream = mapRecurso[tareaRecursoUi];
        httpStream?.cancel();
        mapRecurso.remove(tareaRecursoUi);
      }
    }
    _tareaRecursoList.remove(tareaRecursoUi);

    refreshUI();
  }

  Future<bool> onClickPublicarTarea() async{
    return guardarTarea(false);
  }

  Future<bool> onClickGuardarTarea() async {
    return guardarTarea(true);
  }

  Future<bool> guardarTarea(bool publicar) async{

    if((_tituloTarea??"").isEmpty){
      _mensaje = "Digite un título";
      refreshUI();
      return false;
    }


    bool subiendo_archivos = false;
    for(var archivos in mapRecurso.entries){
      HttpStream? httpStream = archivos.value;
      subiendo_archivos = httpStream!=null && !httpStream.isFinished();
    }
    if(subiendo_archivos){
      _mensaje = "Subida de recursos en progreso";
      refreshUI();
      return false;
    }

    if(tareaUi==null){
        TareaUi tareaUi = TareaUi();
        tareaUi.tareaId = newTareaId;
        tareaUi.titulo = tituloTarea;
        tareaUi.instrucciones = instruccionesTarea;
        tareaUi.publicado = publicar;
        tareaUi.unidadAprendizajeId = unidadEventoId;
        tareaUi.sesionAprendizajeId = sesionAprendizajeId;
        tareaUi.fechaEntregaTime = fechaTarea;
        tareaUi.horaTarea = horaTarea;
        tareaUi.recursos = tareaRecursoList;
        _progress = true;
        refreshUI();

        bool respuesta = await presenter.saveTareaDocente(tareaUi);
        if(!respuesta)_mensaje = "Error al guardar";
        _progress = false;
        refreshUI();
        return respuesta;

    }else{

      return true;
    }



  }

  void successMsg() {
    _mensaje = null;
  }

}