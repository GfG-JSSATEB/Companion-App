import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/student_data.dart';
import 'screens/home.dart';
import 'screens/sign_in.dart';
import 'services/auth.dart';
import 'services/image_picker.dart';
import 'settings/dark_notifier.dart';
import 'settings/routes.dart';
import 'settings/theme_data.dart';

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
        ChangeNotifierProvider<StudentData>(
          create: (_) => StudentData(),
        ),
        Provider<ImagePickerService>(
          create: (_) => ImagePickerService(),
        ),
      ],
      child: MaterialApp(
        title: 'GfG JSSATEB',
        debugShowCheckedModeBanner: false,
        theme: Styles.themeData(
          context: context,
          isDark: Provider.of<DarkNotifier>(context).isDark,
        ),
        routes: routes,
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
