import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gfg_jssateb/screens/sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../components/body_container.dart';
import '../services/auth.dart';
import '../widgets/custom_textfield.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/signUp';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String emailIdErrorMessage = "";
  String passwordErrorMessage = "";
  String nameErrorMessage = "";

  bool validityName = true;
  bool validityEmail = true;
  bool validityPassword = true;

  bool _isLoading = false;

  Future<void> signUp(BuildContext context) async {
    try {
      await context.read<AuthService>().signUpWithEmail(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            name: nameController.text.trim(),
          );
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          setState(() {
            validityEmail = false;
            emailIdErrorMessage = e.message;
          });
          break;
        case 'weak-password':
          setState(() {
            validityPassword = false;
            passwordErrorMessage = e.message;
          });
          break;
        default:
          setState(() {
            validityEmail = false;
            emailIdErrorMessage = e.message;
          });
      }
    }
  }

  @override
  void dispose() {
    // Cleaning up controllers.
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: BodyContainer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: const EdgeInsets.only(top: 50.0),
                height: MediaQuery.of(context).size.height * 0.2,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo.jpg'),
                      fit: BoxFit.fitHeight),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: nameController,
              title: 'Name',
              validity: validityName,
              errorMessage: nameErrorMessage,
              obscureText: false,
              iconData: Icons.person,
            ),
            CustomTextField(
              controller: emailController,
              title: 'Email',
              validity: validityEmail,
              errorMessage: emailIdErrorMessage,
              obscureText: false,
              iconData: Icons.mail,
            ),
            CustomTextField(
              controller: passwordController,
              title: 'Password',
              validity: validityPassword,
              errorMessage: passwordErrorMessage,
              obscureText: true,
              iconData: Icons.lock,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MaterialButton(
                height: MediaQuery.of(context).size.height * 0.08,
                minWidth: MediaQuery.of(context).size.width,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () async {
                  setState(() {
                    validityEmail = isValidEmail(emailController.text);
                    validityPassword = isValidPassword(passwordController.text);
                    if (nameController.text.trim().length < 3) {
                      validityName = false;
                      nameErrorMessage = 'Name too short';
                    } else {
                      validityName = true;
                    }
                    _isLoading = true;
                  });
                  if (validityEmail && validityPassword && validityName) {
                    await signUp(context);
                  }
                  setState(() {
                    _isLoading = false;
                  });
                },
                color: Theme.of(context).accentColor,
                child: const Text(
                  "SIGN UP",
                  textScaleFactor: 1.4,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const Text(
              "Already have a account yet?",
              textScaleFactor: 1.3,
            ),
            const SizedBox(width: 10.0),
            GestureDetector(
              onTap: () =>
                  Navigator.pushReplacementNamed(context, SignIn.routeName),
              child: Text(
                'Sign In',
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    const String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regExp = RegExp(p);
    if (email.isEmpty) {
      //assigning error message to String variable emailIdErrorMessage
      emailIdErrorMessage = "Please enter a Email-id";
      return false;
    } else if (!regExp.hasMatch(email)) {
      //assigning error message to String variable emailIdErrorMessage
      emailIdErrorMessage = "Please enter a valid Email Address";
      return false;
    } else {
      return true;
    }
  }

  bool isValidPassword(String password) {
    //Function that VALIDATES ENTERED PASSWORD
    const String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    final RegExp regExp = RegExp(pattern);
    if (password.isEmpty) {
      //assigning error message to String variable passwordErrorMessage
      passwordErrorMessage = "Please enter Password";
      return false;
    } else if (password.length < 8) {
      //assigning error message to String variable passwordErrorMessage
      passwordErrorMessage = "Password must contain at least 8 characters";
      return false;
    } else if (!regExp.hasMatch(password)) {
      //assigning error message to String variable passwordErrorMessage
      passwordErrorMessage =
          "Password must contain \n at least 1 upper case alphabet,\nat least one number \nand at least one special character \nalong with lowercase alphabets";
      return false;
    } else {
      return true;
    }
  }
}
