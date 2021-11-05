
class Init{

  static Future initialize() async {
    await _registerServices();
    await _loadSettings();
  }

  static _registerServices() async {
    print("starting registering services Firebase");
    //await Firebase.initializeApp();
    //firebaseApp.
    await Future.delayed(Duration(seconds: 1));
    print("finished registering services");
  }

  static Future _loadSettings() async {
    print("starting loading settings");
    /*
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print(e); // TODO: show dialog with error
    }*/
    await Future.delayed(Duration(seconds: 3));
    print("finished loading settings");
  }
}
