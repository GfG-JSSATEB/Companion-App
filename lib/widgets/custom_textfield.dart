import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final bool validity;
  final String errorMessage;
  final bool obscureText;
  final IconData iconData;

  const CustomTextField({
    Key key,
    @required this.controller,
    @required this.title,
    @required this.validity,
    @required this.errorMessage,
    @required this.obscureText,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onSubmitted: (v) {
          FocusScope.of(context).requestFocus();
        },
        cursorColor: Theme.of(context).accentColor,
        obscureText: obscureText,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).accentColor.withOpacity(0.2),
          hintText: title,
          hintStyle:
              TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.6)),
          labelText: title,
          labelStyle:
              TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.6)),
          prefixIcon: Icon(iconData, color: Theme.of(context).accentColor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).accentColor.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).accentColor.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(20.0),
          ),
          errorText: validity ? null : errorMessage,
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.deepOrange,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.deepOrange,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
