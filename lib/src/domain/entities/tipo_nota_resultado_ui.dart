import 'package:ss_crmeducativo_2/src/domain/entities/tipo_nota_tipos_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_resultado_ui.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/valor_tipo_nota_ui.dart';

class TipoNotaResultadoUi{
  String? tipoNotaId;

  String? nombre;

  String? escalanombre;

  int? escalavalorMinimo;

  int? escalavalorMaximo;

  String? tiponombre;

  int? tipoId;

  TipoNotaTiposUi? tipoNotaTiposUi;

  bool? intervalo;

  List<ValorTipoNotaResultadoUi>? valorTipoNotaList;

}