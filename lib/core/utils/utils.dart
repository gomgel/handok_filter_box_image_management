import 'package:flutter/material.dart';

enum SnackBarType {standard, error}

class CommonUtils {
  static final CommonUtils instance = CommonUtils._internal();
  factory CommonUtils() => instance;
  CommonUtils._internal();

  SnackBar alertSnackBar({required BuildContext context, required SnackBarType type, required String message}) {
    return SnackBar(
      // SnackBar의 배경색
      backgroundColor: type == SnackBarType.standard ? Colors.blueAccent : Colors.red[400],

      duration: Duration(seconds: 3),
      content: Text(message, overflow: TextOverflow.ellipsis,),
      action: SnackBarAction(
        label: type == SnackBarType.standard ? "done" : "detail",
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          if (type != SnackBarType.standard) {
            showDialog<void>(
              context: context,
              //barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('detailed message', style: TextStyle(fontSize: 22.0),),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(message),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('ok'),
                      onPressed: () {
                        Navigator.of(context).pop<String>("Y");
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}