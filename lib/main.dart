import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GfG JSSATEB',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: const Color(0xFF2F8D46),
        backgroundColor: const Color(0xFFEEEEEE),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}
