import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/image_picker/image_picker_dialog.dart';

class ImagePickerHandler {
  late ImagePickerDialog imagePicker;
  AnimationController _controller;
  ImagePickerListener _listener;
  final picker = ImagePicker();
  bool? cropScuared;

  ImagePickerHandler(this._listener, this._controller, this.cropScuared);

  openCamera() async {
    imagePicker.dismissDialog();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    final File image = File(pickedFile?.path??"");
    if(cropScuared??false){
      cropImage(image);
    }else{
      _listener.userImage(image);
    }
  }

  openGallery() async {
    imagePicker.dismissDialog();
    final  pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final File image = File(pickedFile?.path??"");
    if(cropScuared??false){
      cropImage(image);
    }else{
      _listener.userImage(image);
    }
  }

  void init({documento}) {
    imagePicker = new ImagePickerDialog(this, _controller,  documento: documento);
    imagePicker.initState();
  }

  Future cropImage(File image) async {
    File? croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      //ratioX: 1.0,
      //ratioY: 1.0,
      aspectRatioPresets: [
        CropAspectRatioPreset.square
      ],
      maxWidth: 2300,
      maxHeight: 2300,
    );
      _listener.userImage(croppedFile);
  }

  showDialog(BuildContext context, {botonRemoverImagen}) {
    imagePicker.getImage(context, botonRemoverImagen: botonRemoverImagen);
  }

  openDocument() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<File?> files = result.paths.map((path) => path!=null?File(path):null).toList();
      _listener.userDocument(files);
    } else {
      // User canceled the picker
    }
  }
}

abstract class ImagePickerListener {
  userImage(File? _image);
  userDocument( List<File?> _documents);
}