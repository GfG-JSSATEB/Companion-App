import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final dynamic message;
  const ErrorMessage({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            size: 100,
            color: Colors.red,
          ),
          Text(
            "$message",
            textScaleFactor: 1.2,
            textAlign: TextAlign.center,
            style: const TextStyle(// color: kTextColor,
                ),
          ),
        ],
      ),
    );
  }
}
