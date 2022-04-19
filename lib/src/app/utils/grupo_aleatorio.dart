class GrupoAleatorio<T>{

  List<List<T>>? execute(List<T> list, int chunk){
    if (chunk <= 0 || list.length <  chunk) {
      return null;
    }

    int chunkSize = (list.length / chunk).toInt();

    List<List<T>> result = [];
    int salto = 0;
    for (int i = 0; i < chunk; i++) {
      result.add(list.sublist(salto,(salto + chunkSize >= list.length ? list.length : salto + chunkSize).toInt()));
      salto = salto + chunkSize;
    }

    if(salto <  list.length){
      int cantidaddfaltante = list.length - salto;
      int posicion = 0;
      for (int i = 0; i < cantidaddfaltante; i ++) {
        if(posicion > list.length)posicion = 0;
        List<T> tList = [];
        tList.addAll(result[posicion]);
        tList.add(list[salto + i]);
        result[posicion] = tList;
        posicion++;
      }
    }

    return result;
  }

}