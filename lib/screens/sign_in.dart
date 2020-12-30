import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../components/body_container.dart';
import '../services/auth.dart';
import '../widgets/custom_textfield.dart';
import 'forgot_password.dart';
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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _validityEmail = true;
  bool _validityPassword = true;

  String _emailIdErrorMessage = "";
  String _passwordErrorMessage = "";

  bool _isLoading = false;

  Future<void> _signIn(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final User user = await context.read<AuthService>().signInWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
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
            _validityEmail = false;
            _emailIdErrorMessage = e.message;
          });
          break;
        case 'wrong-password':
          setState(() {
            _validityPassword = false;
            _passwordErrorMessage = e.message;
          });
          break;
        case 'user-disabled':
          setState(() {
            _validityEmail = false;
            _emailIdErrorMessage = e.message;
          });
          break;
        default:
          setState(() {
            _validityEmail = false;
            _emailIdErrorMessage = e.message;
          });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                _buildForgotPassword(),
                const SizedBox(height: 12.0),
                _signInButton(context),
                const SizedBox(height: 10.0),
                _signUpRoute(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildForgotPassword() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, ForgotPassword.routeName),
          child: const Text(
            'Forgot Password?',
            textScaleFactor: 1.1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Text _greetings() {
    return const Text(
      'GfG JSSATEB',
      textScaleFactor: 2.5,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Column _signUpRoute(BuildContext context) {
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
        CustomTextField(
          controller: _passwordController,
          title: 'Password',
          validity: _validityPassword,
          errorMessage: _passwordErrorMessage,
          obscureText: true,
          iconData: FontAwesomeIcons.lock,
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
            _validityPassword = _isValidPassword(_passwordController.text);
          });
          if (_validityEmail && _validityPassword) {
            await _signIn(context);
          }
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
      _emailIdErrorMessage = "Please enter a Email-id";
      return false;
    } else if (!regExp.hasMatch(email)) {
      //assigning error message to String variable emailIdErrorMessage
      _emailIdErrorMessage = "Please enter a valid Email Address";
      return false;
    } else {
      return true;
    }
  }

  bool _isValidPassword(String password) {
    //Function that VALIDATES ENTERED PASSWORD
    const String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    final RegExp regExp = RegExp(pattern);
    if (password.isEmpty) {
      //assigning error message to String variable passwordErrorMessage
      _passwordErrorMessage = "Please enter Password";
      return false;
    } else if (password.length < 8) {
      //assigning error message to String variable passwordErrorMessage
      _passwordErrorMessage = "Password must contain at least 8 characters";
      return false;
    } else if (!regExp.hasMatch(password)) {
      //assigning error message to String variable passwordErrorMessage
      _passwordErrorMessage =
          "Password must contain \n at least 1 upper case alphabet,\nat least one number \nand at least one special character \nalong with lowercase alphabets";
      return false;
    } else {
      return true;
    }
  }
}
