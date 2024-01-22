import 'package:flutter/material.dart';
import '../../common/constants.dart';
import '../../main.dart';

class Alert {
  static void alertDialog(String message) {
    showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(30),
            contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 350,
                    alignment: Alignment.center,
                    child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: COLOR_SUB1),)
                ),
              ],
            ),
            actions: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                height: 60,
                width: double.infinity,
                child: ElevatedButton(onPressed: () {
                  Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                        color: COLOR_SUB,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: COLOR_BOOK5,
                      shadowColor: Colors.transparent
                  ),
                  child: const Text("확인", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: Colors.white),),
                ),
              ),
            ],
          );
        });
  }

  static void alertActionDialog(BuildContext context, String title, String message, Function() action) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(30),
            contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(title, style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, fontWeight: FontWeight.bold, color: COLOR_SUB1),),
                const SizedBox(height: 17,),
                Container(
                    width: 350,
                    alignment: Alignment.center,
                    child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: COLOR_SUB1),)
                ),
              ],
            ),
            actions: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                height: 60,
                width: double.infinity,
                child: ElevatedButton(onPressed: () {
                  Navigator.pop(context);
                  action();
                },
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                        color: COLOR_SUB,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: COLOR_BOOK5,
                      shadowColor: Colors.transparent
                  ),
                  child: const Text("확인", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: Colors.white),),
                ),
              ),
            ],
          );
        });
  }

  static void confirmDialog(BuildContext context, String title, String message, String confirmBtnText, Function() confirmAction) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(30),
            contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title:
              title.isNotEmpty ?
              Center(child: Text(title, style: const TextStyle(fontFamily: FONT_APPLESD, fontWeight: FontWeight.bold, fontSize: 18, color: COLOR_SUB1),),) :
              const SizedBox.shrink(),
            content: message.isNotEmpty ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 350,
                    height: 70,
                    alignment: Alignment.center,
                    child: Text(message, textAlign: TextAlign.center, style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: COLOR_SUB1),)
                ),
              ],
            ) : const SizedBox.shrink(),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 5, 10),
                    height: 60,
                    child: ElevatedButton(onPressed: () {
                      Navigator.pop(context);
                    },
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                            color: COLOR_SUB,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: Colors.white,
                          shadowColor: Colors.transparent
                      ),
                      child: const Text("취소", style: TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: Colors.black),),
                    ),
                  ),),
                  Expanded(child: Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 10, 10),
                    height: 60,
                    child: ElevatedButton(onPressed: () {
                      Navigator.pop(context);
                      confirmAction();
                    },
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(
                            color: COLOR_SUB,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: COLOR_BOOK5,
                          shadowColor: Colors.transparent
                      ),
                      child: Text(confirmBtnText, style: const TextStyle(fontFamily: FONT_APPLESD, fontSize: 18, color: Colors.white),),
                    ),
                  ),),
                ],
              ),
            ],
          );
        });
  }
}
