import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth;
  AuthService(this._auth);

  Stream<User> get authStateChanges => _auth.authStateChanges();

  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {}
  }

  Future<String> signInWithEmail(
      {@required String email, @required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Signed In';
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return e.message;
    }
  }

  Future<String> signUpWithEmail({
    @required String email,
    @required String password,
    //   @required name
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'Signed up';
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return e.message;
    }
  }

  Future<void> logoutUser() async {
    return await _auth.signOut();
  }
}
