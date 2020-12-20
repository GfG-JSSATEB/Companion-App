import 'package:flutter/material.dart';

import '../components/announcement_card.dart';
import '../models/announcement.dart';
import '../services/database.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/error_message.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Announcement>> announcements;

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
        child: CustomAppBar(
          title: 'Home',
        ),
      ),
      drawer: CustomDrawer(),
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
                    announcement: snapshot.data[index] as Announcement,
                  );
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
