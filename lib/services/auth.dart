import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/database.dart';

class AuthService {
  final FirebaseAuth _auth;
  AuthService(this._auth);

  Stream<User> get authStateChanges => _auth.authStateChanges();

  Future<void> signInWithEmail(
      {@required String email, @required String password}) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUpWithEmail({
    @required String email,
    @required String password,
    @required String name,
    @required String usn,
    @required String college,
    @required String branch,
    @required String year,
  }) async {
    final UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      DatabaseService.addStudent(
        email: email,
        name: name,
        usn: usn,
        college: college,
        branch: branch,
        year: year,
        id: userCredential.user.uid,
      );
    }
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
