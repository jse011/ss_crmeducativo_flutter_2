import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:ss_crmeducativo_2/src/app/page/editar_usuario/editar_usuario_presenter.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/personaUi.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/usuario_ui.dart';


class EditarUsuarioController extends Controller{
  bool _diabledSave = false;

  EditarUsuarioPresenter presenter;

  UsuarioUi? _usuarioUi;
  bool _showDialog = false;
  FileFoto? _fotoFile = null;
  FileFoto? get fotoFile => _fotoFile;
  String? _foto = null;
  String? get foto => _foto;
  bool get showDialog => _showDialog;
  bool _dissmis = false;
  bool get dissmis => _dissmis;
  UsuarioUi? get usuarioUi => _usuarioUi;
  String? _mensaje = null;
  String? get mensaje => _mensaje;
  bool _removerFoto = false;

  EditarUsuarioController(this._usuarioUi,httpRepo, usuarioConfRepo):
        this.presenter=EditarUsuarioPresenter(usuarioConfRepo, httpRepo);

  @override
  void initListeners() {
    /*
    presenter.updateFamiliaOnNext = (bool hayconexion) {


      if(hayconexion){
        _showDialog = true;
        _mensaje=null;
        _dissmis = true;
        refreshUI();
      }else{
      _showDialog = false;
      _diabledSave = false;
      _mensaje = "No hay Conexión a Internet...";
      refreshUI();
      }
    };*/
/*
    presenter.updateFamiliaOnError = (e){
      _showDialog = false;
      _diabledSave = false;
      _mensaje = "!Oops! Al parecer ocurrió un error involuntario.";
      refreshUI();
    };*/

    presenter.uploadPersonaOnProgress = (double? progress){

    };

    presenter.uploadPersonaOnSucces = (bool? sucess, PersonaUi? personaUi){
      _showDialog = false;
      if(sucess??false){
        usuarioUi?.personaUi = personaUi;
        _dissmis = true;
      }else{
        _diabledSave = false;
      }
      refreshUI();
    };

  }

  @override
  void onInitState() {
    super.onInitState();
    _foto = usuarioUi?.personaUi?.foto;
    refreshUI();
  }

  void onSave() {

    if(!_diabledSave){
      _showDialog = true;
      refreshUI();
      presenter.onUpdate(_usuarioUi?.personaUi, fotoFile, false, _removerFoto);
    }
    _diabledSave =true;
  }

  void successMsg() {
    _mensaje = null;
  }

  @override
  void onDisposed() {
    presenter.dispose();
    super.onDisposed();
  }

  void updateImage(File? image) {
    FileFoto fotoFile = FileFoto();
    fotoFile.file = image;
    _updateImage(fotoFile);
  }

  void _updateImage(FileFoto fileFoto) {
    _fotoFile = fileFoto;
    _removerFoto = false;
    refreshUI();
  }

  void clearDissmis() {
    _dissmis = false;
  }

  onClickRemoverFoto() {
    _fotoFile = null;
    _foto = null;
    _removerFoto = true;
    refreshUI();
  }

  void updateImageByte(Uint8List? image) {
    FileFoto fotoFile = FileFoto();
    fotoFile.filebyte = image;
    _updateImage(fotoFile);
  }


}