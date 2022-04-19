import 'dart:io';

import 'dart:typed_data';

class PersonaUi{
  int? personaId;
  String? foto;
  String? nombreCompleto;
  String? nombres;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? apellidos;
  String? telefono;
  bool? contratoVigente;
  bool? soloApareceEnElCurso;
  PersonaUi? apoderadoUi;
  String? correo;
  String? fechaNacimiento;
  String? fechaNacimiento2;
  bool? progress;
  double? progressCount;
  bool? success;
  FileFoto? fileFoto;
}

class FileFoto{
  File? file;
  Uint8List? filebyte;
}