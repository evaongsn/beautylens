import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
class Dialogs{
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white70,
                  contentPadding: EdgeInsets.all(20),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  children: <Widget>[
                    Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingRotating.square(
                              borderColor: Colors.indigo[300],
                              backgroundColor: Colors.indigo[300],
                              size: 30.0,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              "Please Wait....",
                              style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 16.0,
                              ),
                            )
                          ]),
                    )
                  ]));
        });
  }
}