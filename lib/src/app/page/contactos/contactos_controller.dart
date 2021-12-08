import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/contacto_ui.dart';

import 'contactos_presentar.dart';

class ContactosController extends Controller{
  ContactosPresenter presenter;

  List<dynamic> _companieroList = [];
  List<dynamic> get companieroList => _companieroList;
  List<dynamic> _directivosList = [];
  List<dynamic> get directivosList => _directivosList;
  List<dynamic> _doncentesList = [];
  List<dynamic> get doncentesList => _doncentesList;
  ContactoUi? _companiero = null;
  ContactoUi? get companiero => _companiero;
  bool _isLoading = false;
  get isLoading => _isLoading;

  ContactosController(confRepo):
        presenter = ContactosPresenter(confRepo);

@override
  void onInitState() {
    // TODO: implement onInitState
    super.onInitState();
    showProgress();
    refreshUI();
    presenter.getContactos();
  }


  @override
  void initListeners() {

    presenter.getContactosOnNext = (List<dynamic>? alumnosList, List<dynamic>? docentesList, List<dynamic>? directivosList){
      _companieroList=alumnosList??[];
      _doncentesList=docentesList??[];
      _directivosList = directivosList??[];
      hideProgress();
      refreshUI();
    };

    presenter.getContactosOnComplete = (){

    };

    presenter.getContactosOnError = (e){
      _companieroList= [];
      _doncentesList=[];
      _directivosList = [];
      hideProgress();
      refreshUI();
    };
  }

  void showProgress(){
    _isLoading = true;
  }

  void hideProgress(){
    _isLoading = false;
  }

}