import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../services/database.dart';
import 'student.dart';

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

  Future<void> updateStudent(
      {@required String key, @required String value}) async {
    await DatabaseService.updateStudentField(
      id: student.id,
      key: key,
      value: value,
    );

    await _loadStudent();

    notifyListeners();
  }

  bool get isAdmin => _student.isAdmin;

  Student get student => _student;
}
