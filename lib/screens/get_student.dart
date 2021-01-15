import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../models/student.dart';
import '../services/database.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_textfield.dart';

class GetStudent extends StatefulWidget {
  static const routeName = '/getStudent';

  @override
  _GetStudentState createState() => _GetStudentState();
}

class _GetStudentState extends State<GetStudent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _emailController = TextEditingController();

  bool _validityEmail = true;

  String _emailIdErrorMessage = "";

  bool _isLoading = false;

  Student _student;

  Future<void> _getUser(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      _student = await DatabaseService.getStudentByEmail(
        email: _emailController.text.trim(),
      );
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('$e')));
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
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: CustomAppBar(
            title: 'Get Student',
          ),
        ),
        drawer: CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  _inputForm(),
                  const SizedBox(height: 5.0),
                  _signInButton(context),
                  if (_student != null) ...[
                    _buildDetails(key: 'Name', value: _student.name),
                    _buildDetails(key: 'College', value: _student.college),
                    _buildDetails(key: 'USN', value: _student.usn),
                    _buildDetails(key: 'Branch', value: _student.branch),
                    _buildDetails(key: 'id', value: _student.id),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListTile _buildDetails({@required String key, @required String value}) =>
      ListTile(leading: Text(key), title: Text(value));

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
        height: MediaQuery.of(context).size.height * 0.06,
        minWidth: MediaQuery.of(context).size.width * 0.45,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () async {
          setState(() {
            _validityEmail = isValidEmail(_emailController.text.trim());
          });
          if (_validityEmail) {
            await _getUser(context);
          }
        },
        color: Theme.of(context).accentColor,
        child: const Text(
          "Get User",
          textScaleFactor: 1.4,
          style: TextStyle(color: Colors.white),
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
}
