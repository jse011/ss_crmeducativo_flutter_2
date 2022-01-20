import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ss_crmeducativo_2/src/app/utils/app_theme.dart';
import 'package:ss_crmeducativo_2/src/app/widgets/ars_progress.dart';

class ErrorHandler {
  //Error Dialogs
  Future<dynamic>? errorDialog(BuildContext context, String? mensaje) async {
    var sp = mensaje?.split("|");
    print("errorDialog ${sp}");
     return await showGeneralDialog(
         context: context,
         pageBuilder: (BuildContext buildContext,
             Animation<double> animation,
             Animation<double> secondaryAnimation) {
           return ArsProgressWidget(
               blur: 2,
               backgroundColor: Color(0x33000000),
               animationDuration: Duration(milliseconds: 500),
               loadingWidget: Card(
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(16), // if you need this
                   side: BorderSide(
                     color: Colors.grey.withOpacity(0.2),
                     width: 1,
                   ),
                 ),
                 child: Container(
                   padding: EdgeInsets.all(16),
                   constraints: BoxConstraints(minWidth: 100, maxWidth: 400),
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Container(
                             margin: EdgeInsets.only(top: 8),
                             width: 45,
                             height: 45,
                             child: Icon(Ionicons.person, size: 25, color: AppTheme.white,),
                             decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: AppTheme.nearlyDarkBlue),
                           ),
                           Padding(padding: EdgeInsets.all(8)),
                           Expanded(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Padding(padding: EdgeInsets.all(4),),
                                   Text("${sp?[0]??""}",//
                                     style: TextStyle(
                                         fontSize: 18,
                                         fontWeight: FontWeight.w700,
                                         fontFamily: AppTheme.fontTTNormsMedium
                                     ),),
                                   Padding(padding: EdgeInsets.all(4),),
                                   Text("${(sp?.length??0)>1?sp![1]:"Por favor, asegúrete que sus datos sean los correctos e inténtealo de nuevo."}",
                                     style: TextStyle(
                                         fontSize: 14,
                                         height: 1.5
                                     ),),
                                   Padding(padding: EdgeInsets.all(16),),
                                 ],
                               )
                           )
                         ],
                       ),
                       Row(
                         children: [
                           Expanded(
                               child: Container()
                           ),
                           Padding(padding: EdgeInsets.all(8)),
                           Expanded(child: ElevatedButton(
                             onPressed: () {
                               Navigator.of(context).pop(true);
                             },
                             style: ElevatedButton.styleFrom(
                               primary: AppTheme.nearlyDarkBlue,
                               elevation: 0,
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(8.0),
                               ),
                             ),
                             child: Text('Cerrar',
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                   fontSize: 14,
                                   color: AppTheme.white,
                                   fontWeight: FontWeight.w700
                               ),
                             ),
                           )),
                         ],
                       )
                     ],
                   ),
                 ),
               )
           );
         },
         barrierDismissible: true,
         barrierLabel: MaterialLocalizations.of(context)
             .modalBarrierDismissLabel,
         barrierColor: Colors.transparent,
         transitionDuration:
         const Duration(milliseconds: 150));;
  }
}
