import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../components/body_container.dart';
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

  bool validityEmail = true;
  bool validityPassword = true;

  bool _isLoading = false;

  void registerToFb() {
    setState(() {
      _isLoading = true;
    });
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      Navigator.pushReplacementNamed(context, HomePage.routeName);

      setState(() {
        _isLoading = false;
      });
    }).catchError(
      (err) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text('$err.message'),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ok"),
                )
              ],
            );
          },
        );
      },
    );
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
                height: MediaQuery.of(context).size.height * 0.32,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/sign_in.jpg'),
                      fit: BoxFit.fitHeight),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: nameController,
              title: 'Name',
              validity: true,
              errorMessage: '',
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
                onPressed: () {
                  setState(
                    () {
                      validityEmail = isValidEmail(emailController.text);
                      validityPassword =
                          isValidPassword(passwordController.text);
                    },
                  );
                  registerToFb();
                },
                color: Theme.of(context).accentColor,
                child: const Text(
                  "SIGN UP",
                  style: TextStyle(fontSize: 17.0, color: Colors.white),
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
