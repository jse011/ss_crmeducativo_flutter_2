import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/repositories/configuracion_repository.dart';
import 'package:ss_crmeducativo_2/src/domain/usecase/get_contactos.dart';

class ContactosPresenter extends Presenter{
  GetContactos _getContactos;
  late Function getContactosOnNext, getContactosOnComplete, getContactosOnError;

  ContactosPresenter(ConfiguracionRepository configuracionRepository):
        _getContactos = GetContactos(configuracionRepository);


  @override
  void dispose() {
    _getContactos.dispose();
  }


  void getContactos(){
    _getContactos.execute(_GetContactosCase(this), GetContactosCaseParams());
  }

}

class _GetContactosCase extends Observer<GetContactosCaseResponse>{
  final ContactosPresenter presenter;
  _GetContactosCase(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getContactosOnComplete != null);
    presenter.getContactosOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getContactosOnError != null);

    presenter.getContactosOnError(e);
  }

  @override
  void onNext(GetContactosCaseResponse? response) {
    assert(presenter.getContactosOnNext != null);
    presenter.getContactosOnNext(response?.alumnosList, response?.docentesList, response?.directivosList);
  }

}