import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';

class UpdateSessionAnioAcademico{

  ConfiguracionRepository repository;

  UpdateSessionAnioAcademico(this.repository);

  void execute(int anioAcademicoId){
    repository.updateSessionAnioAcademicoId(anioAcademicoId);
  }

}