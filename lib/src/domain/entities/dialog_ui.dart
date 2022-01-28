class DialogUi{
  String? titulo;
  String? mensaje;

  static errorServidor(){
    DialogUi dialogUi = DialogUi();
    dialogUi.titulo = "Error interno del servidor";
    dialogUi.mensaje = "Error desconocido por favor inténtealo de nuevo.";
    return dialogUi;
  }

  static errorInternet(){
    DialogUi dialogUi = DialogUi();
    dialogUi.titulo = "Sin conexión a internet";
    dialogUi.mensaje = "Por favor, asegúrete de su conexión a internet e inténtealo de nuevo.";
    return dialogUi;
  }
}