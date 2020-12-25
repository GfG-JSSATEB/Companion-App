import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../components/body_container.dart';
import '../services/auth.dart';
import '../widgets/custom_textfield.dart';

class ForgotPassword extends StatefulWidget {
  static const routeName = '/forgotPassword';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final emailController = TextEditingController();

  bool validityEmail = true;

  String emailIdErrorMessage = "";

  bool _isLoading = false;

  Future<void> resetPassword(BuildContext context) async {
    try {
      await context
          .read<AuthService>()
          .resetPassword(email: emailController.text.trim());
      // TODO: Snack Bar
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        validityEmail = false;
        emailIdErrorMessage = e.message;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
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
                const SizedBox(height: 5.0),
                signInButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text greetings() {
    return const Text(
      'Forgot Password?',
      textScaleFactor: 2.3,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
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
            _isLoading = true;
          });
          if (validityEmail) {
            await resetPassword(context);
          }
          setState(() {
            _isLoading = false;
          });
        },
        color: Theme.of(context).accentColor,
        child: const Text(
          "Reset Passowrd!",
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
          image: AssetImage('assets/images/logo.png'),
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
}
