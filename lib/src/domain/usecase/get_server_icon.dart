import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';

class GetServerIcono {

  ConfiguracionRepository configuracionRepository;


  GetServerIcono(this.configuracionRepository);

  Future<String?> execute() async{
    return configuracionRepository.getServerIcono();
  }


}