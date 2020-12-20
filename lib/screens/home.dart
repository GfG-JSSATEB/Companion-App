import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gfg_jssateb/components/app_bar.dart';
import 'package:gfg_jssateb/screens/sign_in.dart';
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

  Future<void> signOut() async {
    await context.read<AuthService>().signOut();
    Navigator.pushReplacementNamed(context, SignIn.routeName);
  }

  @override
  void initState() {
    studentFuture =
        DatabaseService.getStudent(FirebaseAuth.instance.currentUser.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBarDesign(
          title: 'Home',
        ),
      ),
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
                onPressed: () => signOut(),
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
