import 'package:flutter/material.dart';

import '../screens/about_app.dart';
import '../screens/about_us.dart';
import '../screens/forgot_password.dart';
import '../screens/home.dart';
import '../screens/participated_events.dart';
import '../screens/profile.dart';
import '../screens/settings.dart';
import '../screens/sign_in.dart';
import '../screens/sign_up.dart';
import '../screens/verify_screen.dart';

Map<String, WidgetBuilder> routes = {
  HomePage.routeName: (context) => HomePage(),
  SignIn.routeName: (context) => SignIn(),
  SignUp.routeName: (context) => SignUp(),
  VerifyScreen.routeName: (context) => VerifyScreen(),
  ForgotPassword.routeName: (context) => ForgotPassword(),
  AboutUs.routeName: (context) => AboutUs(),
  AboutApp.routeName: (context) => AboutApp(),
  Settings.routeName: (context) => Settings(),
  ProfilePage.routeName: (context) => ProfilePage(),
  ParticipatedEvents.routeName: (context) => ParticipatedEvents(),
};
