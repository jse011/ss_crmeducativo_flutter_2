import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/unidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/unidad_tarea_repository.dart';

class GetUnidadTarea extends UseCase<GetUnidadTareaResponse, GetUnidadTareaParams>{
  UnidadTareaRepository  unidadTareaRepository;


  GetUnidadTarea(this.unidadTareaRepository, );

  @override
  Future<Stream<GetUnidadTareaResponse?>> buildUseCaseStream(GetUnidadTareaParams? params) async{
    final controller = StreamController<GetUnidadTareaResponse>();
    List<UnidadUi> eventoUIList = await unidadTareaRepository.getUnidadTarea( params?.calendarioPeridoId??0,  params?.silaboEventoId??0);
    try{
    controller.add(GetUnidadTareaResponse(eventoUIList));
    controller.close();

    } catch (e) {
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetUnidadTareaParams {
  int? calendarioPeridoId;
  int? silaboEventoId;

  GetUnidadTareaParams(this.calendarioPeridoId, this.silaboEventoId);

}

class GetUnidadTareaResponse {
  List<UnidadUi>? eventoUIList;

  GetUnidadTareaResponse(
      this.eventoUIList);
}
