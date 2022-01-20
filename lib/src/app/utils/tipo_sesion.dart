import 'package:flutter/material.dart';
import 'package:ss_crmeducativo_2/src/domain/entities/sesion_ui.dart';

class TipoSession{
  late String nombre;
  late Color color;

  TipoSession(SesionEstado? sesionEstado){
    switch(sesionEstado??SesionEstado.CREADO){
      case SesionEstado.CREADO:
        nombre = "Creado";
        color = Color(0XFF1E88E5);
        break;
      case SesionEstado.PROGRAMADO:
        nombre = "Programado";
        color = Color(0XFFFB8C00);
        break;
      case SesionEstado.HECHO:
        nombre = "Hecho";
        color = Color(0XFF4caf50);
        break;
      case SesionEstado.PENDIENTE:
        nombre = "Pendiente";
        color = Color(0XFFF44336);
        break;
    }
  }
}