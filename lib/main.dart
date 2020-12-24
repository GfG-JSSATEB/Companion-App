import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/about_us.dart';
import 'screens/home.dart';
import 'screens/participated_events.dart';
import 'screens/profile.dart';
import 'screens/settings.dart';
import 'screens/sign_in.dart';
import 'screens/sign_up.dart';
import 'services/auth.dart';
import 'settings/dark_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => DarkNotifier(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
        ),
      ],
      child: MaterialApp(
        title: 'GfG JSSATEB',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Provider.of<DarkNotifier>(context).isDark
              ? const Color(0xFF161B22)
              : Colors.white,
          accentColor: const Color(0xFF2F8D46),
          backgroundColor: Provider.of<DarkNotifier>(context).isDark
              ? const Color(0xFF010409)
              : const Color(0xFFEEEEEE),
          fontFamily: "Mont-med",
          brightness: Provider.of<DarkNotifier>(context).isDark
              ? Brightness.dark
              : Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          HomePage.routeName: (context) => HomePage(),
          SignIn.routeName: (context) => SignIn(),
          SignUp.routeName: (context) => SignUp(),
          AboutUs.routeName: (context) => AboutUs(),
          Settings.routeName: (context) => Settings(),
          ProfilePage.routeName: (context) => ProfilePage(),
          ParticipatedEvents.routeName: (context) => ParticipatedEvents(),
        },
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _user = context.watch<User>();
    if (_user != null) {
      return HomePage();
    } else {
      return SignIn();
    }
  }
}
