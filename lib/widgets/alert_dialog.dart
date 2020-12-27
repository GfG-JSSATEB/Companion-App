import 'package:flutter/material.dart';

void customAlertDialog({
  @required BuildContext context,
  @required String title,
  @required Function onOK,
}) {
  final Widget cancelButton = FlatButton(
    onPressed: () => Navigator.pop(context),
    child: Text(
      "Cancel",
      textScaleFactor: 1.2,
      style: TextStyle(color: Theme.of(context).accentColor),
    ),
  );
  final Widget okButton = FlatButton(
    onPressed: () => onOK(),
    child: Text(
      "OK",
      textScaleFactor: 1.2,
      style: TextStyle(color: Theme.of(context).accentColor),
    ),
  );

  final AlertDialog alert = AlertDialog(
    backgroundColor: Theme.of(context).backgroundColor,
    title: Text(
      "Deleting $title!!!",
      textScaleFactor: 1.1,
      style: TextStyle(color: Theme.of(context).accentColor),
    ),
    content: Text(
      "Are you sure you want to delete the $title?",
      textScaleFactor: 1.1,
    ),
    actions: [
      cancelButton,
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
