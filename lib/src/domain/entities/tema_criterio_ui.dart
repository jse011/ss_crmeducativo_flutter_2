class TemaCriterioUi{
  int? campoTematicoId;
  String? titulo;
  String? descripcion;
  int? parentId;
  TemaCriterioUi? parent;
  List<TemaCriterioUi>? temaCriterioUiList;
  bool? toogle;

  /*Solo copia los campos primitivos*/
  static copy(TemaCriterioUi copy){
    TemaCriterioUi temaCriterioUi = TemaCriterioUi();
    temaCriterioUi.campoTematicoId = copy.campoTematicoId;
    temaCriterioUi.titulo = copy.titulo;
    temaCriterioUi.descripcion = copy.descripcion;
    temaCriterioUi.toogle = copy.toogle;
    temaCriterioUi.parentId = copy.parentId;
    return temaCriterioUi;
  }


}