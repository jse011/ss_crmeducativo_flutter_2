import 'package:ss_crmeducativo_2/src/domain/repositories/rubro_repository.dart';

class GetRubrosNoEnviadosAlServidor{
  RubroRepository repository;

  GetRubrosNoEnviadosAlServidor(this.repository);

 Future< List<Map<String,dynamic>>> execute() async{
    return repository.getRubroEvalNoEnviadosServidorSerialAll();
  }
}