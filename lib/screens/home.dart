import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/announcement_card.dart';
import '../models/announcement.dart';
import '../screens/sign_in.dart';
import '../services/auth.dart';
import '../services/database.dart';
import '../widgets/app_bar.dart';
import '../widgets/error_message.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Announcement>> announcements;

  Future<void> signOut() async {
    await context.read<AuthService>().signOut();
    Navigator.pushReplacementNamed(context, SignIn.routeName);
  }

  @override
  void initState() {
    announcements = DatabaseService.getAnnouncements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBarDesign(
          title: 'Home',
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: announcements,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return ErrorMessage(
                message: snapshot.error,
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return AnnouncementCard(
                      announcement: snapshot.data[index] as Announcement);
                },
                itemCount: snapshot.data.length as int,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
