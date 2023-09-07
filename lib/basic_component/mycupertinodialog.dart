import 'dart:ui';

import 'package:flutter/cupertino.dart';

class MyCupertinoDialog {
  Future createCupertinoDialog(Color colorTitle, String title, String content,
      BuildContext context) async {
    return await showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: TextStyle(
                fontFamily: 'Roboto bold', fontSize: 22, color: colorTitle),
          ),
          content: Text(
            content,
            style: TextStyle(
              fontFamily: 'Roboto bold',
              fontSize: 20,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            CupertinoDialogAction(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
