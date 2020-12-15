import 'package:flutter/material.dart';

import '../components/body_container.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const BodyContainer(
      child: Text('HOME'),
    );
  }
}
