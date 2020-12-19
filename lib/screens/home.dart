import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/student.dart';
import '../services/auth.dart';
import '../services/database.dart';
import '../widgets/error_message.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Student> studentFuture;

  @override
  void initState() {
    studentFuture =
        DatabaseService.getStudent(FirebaseAuth.instance.currentUser.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: studentFuture,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return ErrorMessage(
                message: snapshot.error,
              );
            } else if (snapshot.hasData) {
              final Student student = snapshot.data as Student;
              return FlatButton(
                onPressed: () => context.read<AuthService>().signOut(),
                child: Text(student.email),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
