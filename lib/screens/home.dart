import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../components/announcement_card.dart';
import '../models/announcement.dart';
import '../models/student_data.dart';
import '../services/database.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/error_message.dart';
import 'admin/add_announcement.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Consumer<StudentData>(
          builder: (_, student, __) {
            return CustomAppBar(
              actions: student.isAdmin
                  ? [
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.plus),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddAnnouncement(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                    ]
                  : null,
              title: 'Home',
            );
          },
        ),
      ),
      drawer: CustomDrawer(),
      body: SafeArea(
        child: StreamBuilder(
          stream: DatabaseService.announcements,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: ErrorMessage(
                  message: snapshot.error,
                ),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data.length as int > 0) {
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
                  child: ErrorMessage(
                    message: 'No announcements available',
                  ),
                );
              }
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
