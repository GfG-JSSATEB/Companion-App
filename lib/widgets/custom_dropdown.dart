import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final List<String> list;
  final Function onChanged;

  const CustomDropdown(
      {Key key,
      @required this.hint,
      @required this.list,
      @required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: DropdownButton<String>(
        hint: Text(
          hint,
          textScaleFactor: 1.1,
          style: TextStyle(
            color: Theme.of(context).backgroundColor,
          ),
        ),
        items: list.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String val) {
          FocusScope.of(context).requestFocus(FocusNode());
          onChanged(val);
        },
      ),
    );
  }
}
