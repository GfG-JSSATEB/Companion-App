import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../components/body_container.dart';
import '../services/auth.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_textfield.dart';
import 'home.dart';
import 'sign_in.dart';

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
  TextEditingController usnController = TextEditingController();
  TextEditingController otherCollegeController = TextEditingController();

  String branch = 'Select branch';
  List<String> branches = [
    'CSE',
    'ISE',
    'ECE',
    'EIE',
    'ME',
    'CV',
    'IEM',
    'OTHER',
  ];

  String year = 'Select year of graduation';
  List<String> years = [];

  String college = 'Select College';

  String emailIdErrorMessage = "";
  String passwordErrorMessage = "";
  String nameErrorMessage = "";
  String usnErrorMessage = "";
  String otherCollegeErorMessage = "";

  bool validityName = true;
  bool validityEmail = true;
  bool validityPassword = true;
  bool validityUSN = true;
  bool validityOtherCollege = true;

  bool _isLoading = false;

  Future<void> signUp(BuildContext context) async {
    try {
      if (college == 'OTHER') {
        college = otherCollegeController.text.trim();
      }
      await context.read<AuthService>().signUpWithEmail(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            name: nameController.text.trim(),
            usn: usnController.text.trim(),
            college: college,
            branch: branch,
            year: year,
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
              logo(context),
              const SizedBox(height: 20),
              inputForms(),
              const SizedBox(height: 10),
              signUpButton(context),
              signInRoute(context),
            ],
          ),
        ),
      ),
    );
  }

  Column signInRoute(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Already have an account yet?",
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
    );
  }

  Column inputForms() {
    return Column(
      children: [
        CustomTextField(
          controller: nameController,
          title: 'Name',
          validity: validityName,
          errorMessage: nameErrorMessage,
          obscureText: false,
          iconData: Icons.person,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: emailController,
          title: 'Email',
          validity: validityEmail,
          errorMessage: emailIdErrorMessage,
          obscureText: false,
          iconData: Icons.mail,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: passwordController,
          title: 'Password',
          validity: validityPassword,
          errorMessage: passwordErrorMessage,
          obscureText: true,
          iconData: Icons.lock,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          controller: usnController,
          title: 'USN',
          validity: validityUSN,
          errorMessage: usnErrorMessage,
          obscureText: false,
          iconData: Icons.recent_actors_rounded,
        ),
        const SizedBox(height: 20),
        CustomDropdown(
          hint: college,
          list: const ['JSSATEB', 'OTHER'],
          iconData: Icons.business,
          onChanged: (String val) {
            setState(() {
              college = val;
            });
          },
        ),
        if (college == 'OTHER')
          Column(
            children: [
              const SizedBox(height: 20),
              CustomTextField(
                controller: otherCollegeController,
                title: 'College Name',
                validity: validityOtherCollege,
                errorMessage: otherCollegeErorMessage,
                obscureText: false,
                iconData: Icons.business,
              ),
            ],
          ),
        const SizedBox(height: 20),
        CustomDropdown(
          hint: branch,
          list: branches,
          iconData: Icons.local_library,
          onChanged: (String val) {
            setState(() {
              branch = val;
            });
          },
        ),
        const SizedBox(height: 20),
        CustomDropdown(
          hint: year,
          list: years,
          iconData: Icons.school,
          onChanged: (String val) {
            setState(() {
              year = val;
            });
          },
        ),
      ],
    );
  }

  Widget logo(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50.0, bottom: 20.0),
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

  Padding signUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MaterialButton(
        height: MediaQuery.of(context).size.height * 0.08,
        minWidth: MediaQuery.of(context).size.width,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () async {
          setState(() {
            validityEmail = isValidEmail(emailController.text.trim());
            validityPassword = isValidPassword(passwordController.text);
            validityName = isValidName(nameController.text.trim());
            validityUSN = isValidUSN(usnController.text.trim());
            if (college == 'OTHER') {
              validityOtherCollege =
                  isValidOtherCollege(otherCollegeController.text.trim());
            }
            _isLoading = true;
          });
          if (validityEmail &&
              validityPassword &&
              validityName &&
              validityUSN &&
              branch != 'Select branch' &&
              year != 'Select year of graduation' &&
              college != 'Select College') {
            if (college == 'OTHER' && validityOtherCollege) {
              await signUp(context);
            } else if (college == 'JSSATEB') {
              await signUp(context);
            }
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
    );
  }

  bool isValidName(String name) {
    if (name.length < 3) {
      nameErrorMessage = 'Name too short';
      return false;
    } else {
      return true;
    }
  }

  bool isValidUSN(String usn) {
    if (usn.length < 10) {
      usnErrorMessage = 'USN too short';
      return false;
    } else {
      return true;
    }
  }

  bool isValidOtherCollege(String collegeName) {
    if (collegeName.length < 3) {
      otherCollegeErorMessage = 'College Name too short';
      return false;
    } else {
      return true;
    }
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
