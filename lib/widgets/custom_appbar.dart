import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final Widget leading;

  const CustomAppBar({Key key, @required this.title, this.leading})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: leading,
      iconTheme: IconThemeData(color: Theme.of(context).accentColor, size: 30),
      title: Text(
        title,
        textScaleFactor: 1.7,
        style: TextStyle(
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }
}
