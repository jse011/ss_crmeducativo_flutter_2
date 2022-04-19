import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as editImg;
//import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/image_picker/image_picker_dialog.dart';

class ImagePickerHandler {
  late ImagePickerDialog imagePicker;
  AnimationController _controller;
  ImagePickerListener _listener;
  final picker = ImagePicker();
  bool? cropScuared;
  static const String prefiImage = "IMG-";
  ImagePickerHandler(this._listener, this._controller, this.cropScuared);

  openCamera() async {
    imagePicker.dismissDialog();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    final File image = File(pickedFile?.path??"");
    final dateformat = DateFormat('yyyy-MM-dd-hh-mm');
    if(cropScuared??false){
      cropImage(image, prefiImage+ dateformat.format(DateTime.now())+".jpg");
    }else{
      _listener.userImage(image, prefiImage+ dateformat.format(DateTime.now())+".jpg");
    }
  }

  openGallery() async {
    imagePicker.dismissDialog();
    final  pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final File image = File(pickedFile?.path??"");

    final dateformat = DateFormat('yyyy-MM-dd-hh-mm');
    var ext = image.path.split(".").last;
    String? name;
    if(ext.isNotEmpty){
      name = "${prefiImage+ dateformat.format(DateTime.now())}.${ext}";
    }else{
      name = null;
    }
    if(cropScuared??false){
      cropImage(image, name);
    }else{
      _listener.userImage(image, name);
    }
  }

  void init({documento}) {
    imagePicker = new ImagePickerDialog(this, _controller,  documento: documento);
    imagePicker.initState();
  }

  Future cropImage(File file, String? name) async {
    /*File? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      //ratioX: 1.0,
      //ratioY: 1.0,
      aspectRatioPresets: [
        CropAspectRatioPreset.square
      ],
      maxWidth: 2300,
      maxHeight: 2300,
      androidUiSettings: AndroidUiSettings()
    );*/

    editImg.Image? image = editImg.decodeImage(file.readAsBytesSync());
    if(image != null){
      editImg.Image rize = editImg.copyResizeCropSquare(image, 800);
      _listener.userCrop(Uint8List.fromList(editImg.encodeJpg(rize, quality: 70)),name);
    }

  }


  showDialog(BuildContext context, {botonRemoverImagen, botonLink}) {
    imagePicker.getImage(context, botonRemoverImagen: botonRemoverImagen, botonLink: botonLink);
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
  userCrop(Uint8List? _image, String? newName);
  userImage(File? _image, String? newName);
  userDocument( List<File?> _documents);
}