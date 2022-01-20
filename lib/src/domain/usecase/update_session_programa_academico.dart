import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';

class UpdateSessionProgramaAcademico{

  ConfiguracionRepository repository;

  UpdateSessionProgramaAcademico(this.repository);

  void execute(int programaAcademicoId){
    repository.updateSessionProgramaEducativoId(programaAcademicoId);
  }

}