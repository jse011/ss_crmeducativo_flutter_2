import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/capacidad_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/cursos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/rubrica_evaluacion_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/http_datos_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_cursos.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_tipo_nota_resultado.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_evaluacion.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_evaluacion_capacidad.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_peso_rubro.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/update_server_evaluacion_capacidad.dart';

class PesoCriterioPresenter extends Presenter {
  GetTipoNotaResultado _getTipoNotaResultado;
  late Function getTipoNotaResultadoOnNext, getTipoNotaResultadoEvalOnError;
  UpdatePesoRubro _updatePesoRubro;
  UpdateServerEvaluacionCompetencia _updateServerEvaluacionCompetencia;

  PesoCriterioPresenter( ConfiguracionRepository configuracionRepo, RubroRepository rubroRepo, HttpDatosRepository httpDatosRepo)
      : _updatePesoRubro = UpdatePesoRubro(rubroRepo, configuracionRepo),
        _getTipoNotaResultado = GetTipoNotaResultado(rubroRepo),
        _updateServerEvaluacionCompetencia = UpdateServerEvaluacionCompetencia(configuracionRepo, httpDatosRepo, rubroRepo);

  @override
  void dispose() {
    _getTipoNotaResultado.dispose();
  }

  Future<void> updatePesoRubroEvaluacion(RubricaEvaluacionUi? rubricaEvaluacionUi) {
    return _updatePesoRubro.execute(rubricaEvaluacionUi);
  }


  Future<void> updateServer(List<String> rubroEvaluacionIdList) {
    return _updateServerEvaluacionCompetencia.execute(UpdateServerEvaluacionRubroParms(rubroEvaluacionIdList));
  }


}
