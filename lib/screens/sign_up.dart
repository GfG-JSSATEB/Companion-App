import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../components/body_container.dart';
import '../services/auth.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_textfield.dart';
import 'sign_in.dart';
import 'verify_screen.dart';

class SignUp extends StatefulWidget {
  static const String routeName = '/signUp';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usnController = TextEditingController();
  final TextEditingController otherCollegeController = TextEditingController();

  String _branch = 'Select branch';
  final List<String> _branches = [
    'CSE',
    'ISE',
    'ECE',
    'EIE',
    'ME',
    'CV',
    'IEM',
    'OTHER',
  ];

  String _year = 'Select year of graduation';
  List<String> years = [];

  String _college = CollegeDetails.noDetail;

  String _emailIdErrorMessage = '';
  String _passwordErrorMessage = '';
  String _nameErrorMessage = '';
  String _usnErrorMessage = '';
  String _otherCollegeErorMessage = '';

  bool _validityName = true;
  bool _validityEmail = true;
  bool _validityPassword = true;
  bool _validityUSN = true;
  bool _validityOtherCollege = true;

  bool _isLoading = false;

  Future<void> _signUp(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (_college == CollegeDetails.otherCollege) {
        _college = otherCollegeController.text.trim();
      }
      await context.read<AuthService>().signUpWithEmail(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            name: nameController.text.trim(),
            usn: usnController.text.trim(),
            college: _college,
            branch: _branch,
            year: _year,
          );
      await Navigator.pushReplacementNamed(context, VerifyScreen.routeName);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          setState(() {
            _validityEmail = false;
            _emailIdErrorMessage = e.message;
          });
          break;
        case 'weak-password':
          setState(() {
            _validityPassword = false;
            _passwordErrorMessage = e.message;
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
  void initState() {
    super.initState();
    DateTime start = DateTime(DateTime.now().year + 1);
    final DateTime end = DateTime(start.year + 4);
    while (start.isBefore(end)) {
      years.add(start.toString().split(' ').first.split('-').first);
      start = start.add(const Duration(days: 366));
    }
  }

  @override
  void dispose() {
    // Cleaning up controllers.
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    usnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: BodyContainer(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _logo(context),
              _greetings(),
              const SizedBox(height: 20),
              _inputForms(),
              const SizedBox(height: 10),
              _signUpButton(context),
              const SizedBox(height: 10),
              _signInRoute(context),
            ],
          ),
        ),
      ),
    );
  }

  Text _greetings() {
    return const Text(
      'Welcome',
      textScaleFactor: 2.5,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Column _signInRoute(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Already have an account?',
          textScaleFactor: 1.3,
        ),
        const SizedBox(height: 5.0),
        GestureDetector(
          onTap: () =>
              Navigator.pushReplacementNamed(context, SignIn.routeName),
          child: Text(
            'Sign In',
            textScaleFactor: 1.3,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              letterSpacing: 1.4,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 15.0),
      ],
    );
  }

  Column _inputForms() {
    return Column(
      children: [
        CustomTextField(
          controller: nameController,
          title: 'Name',
          validity: _validityName,
          errorMessage: _nameErrorMessage,
          obscureText: false,
          iconData: FontAwesomeIcons.solidUser,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: emailController,
          title: 'Email',
          validity: _validityEmail,
          errorMessage: _emailIdErrorMessage,
          obscureText: false,
          iconData: FontAwesomeIcons.solidEnvelope,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: passwordController,
          title: 'Password',
          validity: _validityPassword,
          errorMessage: _passwordErrorMessage,
          obscureText: true,
          iconData: FontAwesomeIcons.lock,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: usnController,
          title: 'USN',
          validity: _validityUSN,
          errorMessage: _usnErrorMessage,
          obscureText: false,
          iconData: FontAwesomeIcons.solidIdBadge,
        ),
        const SizedBox(height: 20),
        CustomDropdown(
          hint: _college,
          list: const [CollegeDetails.jssCollege, CollegeDetails.otherCollege],
          iconData: FontAwesomeIcons.school,
          onChanged: (String val) {
            setState(() {
              _college = val;
            });
          },
        ),
        if (_college == CollegeDetails.otherCollege)
          Column(
            children: [
              const SizedBox(height: 20),
              CustomTextField(
                controller: otherCollegeController,
                title: 'College Name',
                validity: _validityOtherCollege,
                errorMessage: _otherCollegeErorMessage,
                obscureText: false,
                iconData: FontAwesomeIcons.school,
              ),
            ],
          ),
        const SizedBox(height: 20),
        CustomDropdown(
          hint: _branch,
          list: _branches,
          iconData: FontAwesomeIcons.bookReader,
          onChanged: (String val) {
            setState(() {
              _branch = val;
            });
          },
        ),
        const SizedBox(height: 20),
        CustomDropdown(
          hint: _year,
          list: years,
          iconData: FontAwesomeIcons.graduationCap,
          onChanged: (String val) {
            setState(() {
              _year = val;
            });
          },
        ),
      ],
    );
  }

  Widget _logo(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50.0, bottom: 20.0),
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

  Padding _signUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MaterialButton(
        height: MediaQuery.of(context).size.height * 0.08,
        minWidth: MediaQuery.of(context).size.width,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () async {
          setState(() {
            _validityEmail = _isValidEmail(emailController.text.trim());
            _validityPassword = _isValidPassword(passwordController.text);
            _validityName = _isValidName(nameController.text.trim());
            _validityUSN = _isValidUSN(usnController.text.trim());
            if (_college == CollegeDetails.otherCollege) {
              _validityOtherCollege =
                  _isValidOtherCollege(otherCollegeController.text.trim());
            }
          });
          if (_validityEmail &&
              _validityPassword &&
              _validityName &&
              _validityUSN &&
              _branch != 'Select branch' &&
              _year != 'Select year of graduation' &&
              _college != CollegeDetails.noDetail) {
            if (_college == CollegeDetails.otherCollege &&
                _validityOtherCollege) {
              await _signUp(context);
            } else if (_college == CollegeDetails.jssCollege) {
              await _signUp(context);
            }
          }
        },
        color: Theme.of(context).accentColor,
        child: const Text(
          'SIGN UP',
          textScaleFactor: 1.4,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  bool _isValidName(String name) {
    if (name.length < 3) {
      _nameErrorMessage = 'Name too short';
      return false;
    } else {
      return true;
    }
  }

  bool _isValidUSN(String usn) {
    if (usn.length < 10) {
      _usnErrorMessage = 'USN too short';
      return false;
    } else {
      return true;
    }
  }

  bool _isValidOtherCollege(String collegeName) {
    if (collegeName.length < 3) {
      _otherCollegeErorMessage = 'College Name too short';
      return false;
    } else {
      return true;
    }
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

  bool _isValidPassword(String password) {
    //Function that VALIDATES ENTERED PASSWORD
    const String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    final RegExp regExp = RegExp(pattern);
    if (password.isEmpty) {
      //assigning error message to String variable passwordErrorMessage
      _passwordErrorMessage = 'Please enter Password';
      return false;
    } else if (password.length < 8) {
      //assigning error message to String variable passwordErrorMessage
      _passwordErrorMessage = 'Password must contain at least 8 characters';
      return false;
    } else if (!regExp.hasMatch(password)) {
      //assigning error message to String variable passwordErrorMessage
      _passwordErrorMessage =
          'Password must contain \n at least 1 upper case alphabet,\nat least one number \nand at least one special character \nalong with lowercase alphabets';
      return false;
    } else {
      return true;
    }
  }
}

mixin CollegeDetails {
  static const String noDetail = 'Select College';
  static const String jssCollege = 'JSSATEB';
  static const String otherCollege = 'OTHER';
}
