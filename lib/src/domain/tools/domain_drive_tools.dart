class DriveUrlParser
{
  static String? getDocumentId(String? docIDfull) {
    String? docID = null;
    try{
      int docIDstart = docIDfull?.indexOf("/d/")??0;
      int DocIDend = docIDfull?.indexOf('/', docIDstart + 3)??0;

      if (docIDstart == -1) {
        //Invalid URL readonly
        return null;
      }
      if (DocIDend == -1) {
        docID = docIDfull?.substring(docIDstart + 3);
      }
      else {
        docID = docIDfull?.substring(docIDstart + 3, DocIDend);
      }
    }catch(e){

    }

    return docID;
  }

  static String getUrlDownload(String? driveId){
    return "https://drive.google.com/uc?export=download&id=${driveId??""}";
  }



}
