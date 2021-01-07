import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../models/student.dart';
import '../models/student_data.dart';
import '../services/auth.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_textfield.dart';
import 'events.dart';
import 'sign_in.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Student _student;

  bool _isLoading = false;

  final TextEditingController _textController = TextEditingController();
  String _errorMessage = "";
  bool _validityName = true;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _student = Provider.of<StudentData>(context).student;

    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: CustomAppBar(
            leading: IconButton(
              icon: const Icon(
                FontAwesomeIcons.chevronLeft,
                size: 30,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: 'Profile',
          ),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ProfileTile(
                    title: _student.name,
                    icon: FontAwesomeIcons.solidUser,
                    trailing: FontAwesomeIcons.pen,
                    trailingOnTap: () async {
                      await _buildShowDialog(
                        context: context,
                        key: 'name',
                        value: _student.name,
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.solidEnvelope,
                      color: Theme.of(context).accentColor,
                    ),
                    title: Text(
                      _student.email,
                      style: const TextStyle(
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.school,
                      color: Theme.of(context).accentColor,
                    ),
                    title: Text(
                      _student.college,
                      style: const TextStyle(
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                  _ProfileTile(
                    title: _student.usn,
                    icon: FontAwesomeIcons.solidIdBadge,
                    trailing: FontAwesomeIcons.pen,
                    trailingOnTap: () async {
                      await _buildShowDialog(
                        context: context,
                        key: 'usn',
                        value: _student.usn,
                      );
                    },
                  ),
                  _ProfileTile(
                    title: _student.branch,
                    icon: FontAwesomeIcons.bookReader,
                    trailing: FontAwesomeIcons.pen,
                    trailingOnTap: () async {
                      await _buildShowDialog(
                        context: context,
                        key: 'branch',
                        value: _student.branch,
                      );
                    },
                  ),
                  _ProfileTile(
                    title: _student.year,
                    icon: FontAwesomeIcons.graduationCap,
                    trailing: FontAwesomeIcons.pen,
                    trailingOnTap: () async {
                      await _buildShowDialog(
                        context: context,
                        key: 'year',
                        value: _student.year,
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventsPage(
                          isParticipated: true,
                        ),
                      ),
                    ),
                    child: const _ProfileTile(
                      title: 'Participated Events',
                      icon: FontAwesomeIcons.certificate,
                      trailing: FontAwesomeIcons.chevronRight,
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    height: MediaQuery.of(context).size.height * 0.06,
                    minWidth: MediaQuery.of(context).size.width * 0.6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () => customAlertDialog(
                      context: context,
                      title: 'Resetting Pasword!',
                      description:
                          'Are you sure you want to reset user password!?',
                      onOK: () async {
                        await context
                            .read<AuthService>()
                            .resetPassword(email: _student.email);

                        await context.read<AuthService>().signOut();

                        Navigator.pushReplacementNamed(
                            context, SignIn.routeName);
                      },
                    ),
                    color: Theme.of(context).accentColor,
                    child: const Text(
                      "Reset Password?",
                      textScaleFactor: 1.4,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _buildShowDialog({
    @required BuildContext context,
    @required String key,
    @required String value,
  }) async {
    _textController.text = value;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            color: Theme.of(context).backgroundColor,
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: _textController,
                  title: key,
                  validity: _validityName,
                  errorMessage: _errorMessage,
                  obscureText: false,
                  iconData: FontAwesomeIcons.solidEdit,
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  height: MediaQuery.of(context).size.height * 0.06,
                  minWidth: MediaQuery.of(context).size.width * 0.6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () async {
                    try {
                      setState(() {
                        _validityName =
                            _isValidName(_textController.text.trim());
                      });
                      if (_validityName) {
                        Navigator.pop(context);

                        _isLoading = true;

                        await Provider.of<StudentData>(context, listen: false)
                            .updateStudent(
                          key: key,
                          value: _textController.text.trim(),
                        );

                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Updated $key successfully')));
                      }
                    } catch (e) {
                      _scaffoldKey.currentState
                          .showSnackBar(SnackBar(content: Text('$e')));
                    } finally {
                      _isLoading = false;
                    }
                  },
                  color: Theme.of(context).accentColor,
                  child: const Text(
                    "Update",
                    textScaleFactor: 1.4,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isValidName(String name) {
    if (name.length < 3) {
      _errorMessage = 'Name too short';
      return false;
    } else {
      return true;
    }
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile(
      {Key key,
      @required this.title,
      @required this.icon,
      this.trailing,
      this.trailingOnTap})
      : super(key: key);

  final String title;
  final IconData icon;
  final IconData trailing;
  final Function trailingOnTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).accentColor,
      ),
      title: Text(
        title,
        style: const TextStyle(
          letterSpacing: 1.3,
        ),
      ),
      trailing: IconButton(
        onPressed: () => trailingOnTap(),
        icon: Icon(
          trailing,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
