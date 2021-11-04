import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';

class CerrarSession {
  ConfiguracionRepository repository;

  CerrarSession(this.repository);

  Future<bool> execute(){
    return repository.cerrrarSession();
  }
}