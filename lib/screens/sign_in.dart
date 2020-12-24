import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../components/body_container.dart';
import '../services/auth.dart';
import '../widgets/custom_textfield.dart';
import 'home.dart';
import 'sign_up.dart';
import 'verify_screen.dart';

class SignIn extends StatefulWidget {
  static const routeName = '/signIn';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool validityEmail = true;
  bool validityPassword = true;

  String emailIdErrorMessage = "";
  String passwordErrorMessage = "";

  bool _isLoading = false;

  Future<void> signIn(BuildContext context) async {
    try {
      final User user = await context.read<AuthService>().signInWithEmail(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
      if (user.emailVerified) {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      } else {
        Navigator.pushReplacementNamed(context, VerifyScreen.routeName);
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          setState(() {
            validityEmail = false;
            emailIdErrorMessage = e.message;
          });
          break;
        case 'wrong-password':
          setState(() {
            validityPassword = false;
            passwordErrorMessage = e.message;
          });
          break;
        case 'user-disabled':
          setState(() {
            validityEmail = false;
            emailIdErrorMessage = e.message;
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        key: _scaffoldKey,
        body: BodyContainer(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                logo(context),
                greetings(),
                const SizedBox(height: 20.0),
                inputForm(),
                signInButton(context),
                const SizedBox(height: 10.0),
                signUpRoute(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text greetings() {
    return const Text(
      'GfG JSSATEB',
      textScaleFactor: 2.5,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Column signUpRoute(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Don't have an account yet?",
          textScaleFactor: 1.3,
        ),
        const SizedBox(height: 5.0),
        GestureDetector(
          onTap: () =>
              Navigator.pushReplacementNamed(context, SignUp.routeName),
          child: Text(
            'Register Now!',
            textScaleFactor: 1.3,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              letterSpacing: 1.4,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Column inputForm() {
    return Column(
      children: [
        CustomTextField(
          controller: emailController,
          title: 'Email',
          validity: validityEmail,
          errorMessage: emailIdErrorMessage,
          obscureText: false,
          iconData: FontAwesomeIcons.solidEnvelope,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: passwordController,
          title: 'Password',
          validity: validityPassword,
          errorMessage: passwordErrorMessage,
          obscureText: true,
          iconData: FontAwesomeIcons.lock,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Padding signInButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: MaterialButton(
        height: MediaQuery.of(context).size.height * 0.08,
        minWidth: MediaQuery.of(context).size.width,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () async {
          setState(() {
            validityEmail = isValidEmail(emailController.text.trim());
            validityPassword = isValidPassword(passwordController.text);
            _isLoading = true;
          });
          if (validityEmail && validityPassword) {
            await signIn(context);
          }
          setState(() {
            _isLoading = false;
          });
        },
        color: Theme.of(context).accentColor,
        child: const Text(
          "SIGN IN",
          textScaleFactor: 1.4,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget logo(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50.0, bottom: 30.0),
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/images/logo.jpg'),
          fit: BoxFit.fitHeight,
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
