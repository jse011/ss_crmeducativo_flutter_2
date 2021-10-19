import 'package:ss_crmeducativo_2/src/domain/entities/matriz_resultado_ui.dart';

abstract class ResultadoRepository {
  MatrizResultadoUi transformarMatrizResultado(Map<String, dynamic> matrizResultado);



}