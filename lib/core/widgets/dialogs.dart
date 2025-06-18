import 'package:flutter/material.dart';

Future showSimpleDialog_02({required BuildContext context, String title = "HANDOK PDA", required String message}) async{
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text(title, style: TextStyle(fontSize: 24.0),),
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
          TextButton(
            child: const Text('cancel'),
            onPressed: () {
              Navigator.of(context).pop<String>("N");
            },
          ),
        ],
      );
    },
  );
}