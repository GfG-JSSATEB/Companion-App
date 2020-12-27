import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../components/event_card.dart';
import '../models/event.dart';
import '../models/student_data.dart';
import '../services/database.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/error_message.dart';

class EventsPage extends StatelessWidget {
  static const routeName = '/events';
  final bool isFinished;
  final bool isParticipated;

  const EventsPage({
    Key key,
    this.isFinished,
    this.isParticipated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAdmin =
        Provider.of<StudentData>(context, listen: false).isAdmin;
    final String uid =
        Provider.of<StudentData>(context, listen: false).student.id;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppBar(
          actions: isAdmin
              ? [
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.plus),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 5),
                ]
              : null,
          title: 'Events',
        ),
      ),
      drawer: CustomDrawer(),
      body: SafeArea(
        child: StreamBuilder(
          stream: isParticipated
              ? DatabaseService.getParticipatedEvents(uid: uid)
              : DatabaseService.getAllEvents(isFinished: isFinished),
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
                    return EventCard(
                      event: snapshot.data[index] as Event,
                    );
                  },
                  itemCount: snapshot.data.length as int,
                );
              } else {
                return const Center(
                  child: ErrorMessage(
                    message: 'No events available',
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
