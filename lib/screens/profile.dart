import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../models/student.dart';
import '../services/auth.dart';
import '../services/database.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_textfield.dart';
import 'participated_events.dart';
import 'sign_in.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Student student;
  final String uid = FirebaseAuth.instance.currentUser.uid;

  bool _isLoading = true;

  TextEditingController textController = TextEditingController();
  String errorMessage = "";
  bool validityName = true;

  @override
  void initState() {
    getStudent();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> getStudent() async {
    try {
      student = await DatabaseService.getStudent(uid);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            key: _scaffoldKey,
            backgroundColor: Theme.of(context).backgroundColor,
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
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
              padding: const EdgeInsets.only(
                  bottom: 20, left: 20, right: 20, top: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                      ProfileTile(
                        title: student.name,
                        icon: FontAwesomeIcons.solidUser,
                        trailing: FontAwesomeIcons.pen,
                        trailingOnTap: () async {
                          await buildShowDialog(
                            context: context,
                            key: 'name',
                            value: student.name,
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          FontAwesomeIcons.solidEnvelope,
                          color: Theme.of(context).accentColor,
                        ),
                        title: Text(
                          student.email,
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
                          student.college,
                          style: const TextStyle(
                            letterSpacing: 1.3,
                          ),
                        ),
                      ),
                      ProfileTile(
                        title: student.usn,
                        icon: FontAwesomeIcons.solidIdBadge,
                        trailing: FontAwesomeIcons.pen,
                        trailingOnTap: () async {
                          await buildShowDialog(
                            context: context,
                            key: 'usn',
                            value: student.usn,
                          );
                        },
                      ),
                      ProfileTile(
                        title: student.branch,
                        icon: FontAwesomeIcons.bookReader,
                        trailing: FontAwesomeIcons.pen,
                        trailingOnTap: () async {
                          await buildShowDialog(
                            context: context,
                            key: 'branch',
                            value: student.branch,
                          );
                        },
                      ),
                      ProfileTile(
                        title: student.year,
                        icon: FontAwesomeIcons.graduationCap,
                        trailing: FontAwesomeIcons.pen,
                        trailingOnTap: () async {
                          await buildShowDialog(
                            context: context,
                            key: 'year',
                            value: student.year,
                          );
                        },
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          ParticipatedEvents.routeName,
                        ),
                        child: const ProfileTile(
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
                        onPressed: () async {
                          await context
                              .read<AuthService>()
                              .resetPassword(email: student.email);
                          await context.read<AuthService>().signOut();
                          Navigator.pushReplacementNamed(
                              context, SignIn.routeName);
                        },
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
          );
  }

  Future<void> buildShowDialog({
    @required BuildContext context,
    @required String key,
    @required String value,
  }) async {
    textController.text = value;

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
                  controller: textController,
                  title: key,
                  validity: validityName,
                  errorMessage: errorMessage,
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
                        validityName = isValidName(textController.text.trim());
                      });
                      if (validityName) {
                        setState(() {
                          _isLoading = true;
                        });
                        Navigator.pop(context);

                        await DatabaseService.updateStudentField(
                          id: uid,
                          key: key,
                          value: textController.text.trim(),
                        );

                        await getStudent();

                        setState(() {
                          _isLoading = false;
                        });

                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Updated $key successfully')));
                      }
                    } catch (e) {
                      _scaffoldKey.currentState
                          .showSnackBar(SnackBar(content: Text('$e')));
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

  bool isValidName(String name) {
    if (name.length < 3) {
      errorMessage = 'Name too short';
      return false;
    } else {
      return true;
    }
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile(
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
