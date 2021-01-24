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

  final TextEditingController _emailController = TextEditingController();

  bool _validityEmail = true;

  String _emailIdErrorMessage = '';

  bool _isLoading = false;

  Future<void> _resetPassword(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await context
          .read<AuthService>()
          .resetPassword(email: _emailController.text.trim());

      _scaffoldKey.currentState.showSnackBar(const SnackBar(
          content: Text('Password Reset Mail sent successfully')));

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _validityEmail = false;
        _emailIdErrorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                _logo(context),
                _greetings(),
                const SizedBox(height: 20.0),
                _inputForm(),
                const SizedBox(height: 5.0),
                _signInButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text _greetings() {
    return const Text(
      'Forgot Password?',
      textScaleFactor: 2.3,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Column _inputForm() {
    return Column(
      children: [
        CustomTextField(
          controller: _emailController,
          title: 'Email',
          validity: _validityEmail,
          errorMessage: _emailIdErrorMessage,
          obscureText: false,
          iconData: FontAwesomeIcons.solidEnvelope,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Padding _signInButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: MaterialButton(
        height: MediaQuery.of(context).size.height * 0.08,
        minWidth: MediaQuery.of(context).size.width,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () async {
          setState(() {
            _validityEmail = _isValidEmail(_emailController.text.trim());
          });
          if (_validityEmail) {
            await _resetPassword(context);
          }
        },
        color: Theme.of(context).accentColor,
        child: const Text(
          'Reset Passowrd!',
          textScaleFactor: 1.4,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _logo(BuildContext context) {
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

  bool _isValidEmail(String email) {
    const String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regExp = RegExp(p);
    if (email.isEmpty) {
      //assigning error message to String variable emailIdErrorMessage
      _emailIdErrorMessage = 'Please enter a Email-id';
      return false;
    } else if (!regExp.hasMatch(email)) {
      //assigning error message to String variable emailIdErrorMessage
      _emailIdErrorMessage = 'Please enter a valid Email Address';
      return false;
    } else {
      return true;
    }
  }
}
