import 'package:flutter/material.dart';

class StreamBuilderFirebaseView extends StatefulWidget{

  @override
  _StreamBuilderFirebaseState createState() => _StreamBuilderFirebaseState();

}

class _StreamBuilderFirebaseState extends State<StreamBuilderFirebaseView>{

  bool? loginIn;

  @override
  void initState() {
    // Assign listener after the SDK is initialized successfully
    //FirebaseAuth.instance.authStateChanges().listen((User? user) {
      /*if (user == null)
       setState(() {
         loginIn = true;
       });
      else
        setState(() {
          loginIn = false;
        });
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }


}