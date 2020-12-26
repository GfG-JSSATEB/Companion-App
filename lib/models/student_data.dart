import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gfg_jssateb/models/student.dart';
import 'package:gfg_jssateb/services/database.dart';

class StudentData extends ChangeNotifier {
  Student _student;

  StudentData() {
    _loadStudent();
  }

  Future<void> _loadStudent() async {
    _student =
        await DatabaseService.getStudent(FirebaseAuth.instance.currentUser.uid);
    notifyListeners();
  }

  bool get isAdmin => _student.isAdmin;

  String get id => _student.id;

  String get email => _student.id;
}
