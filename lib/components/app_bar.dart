import 'package:flutter/material.dart';

class AppBarDesign extends StatelessWidget {
  final String title;

  const AppBarDesign({Key key, @required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      title: Text(
        title,
        textScaleFactor: 1.3,
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
