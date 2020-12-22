import 'package:flutter/material.dart';

import '../components/event_card.dart';
import '../models/event.dart';
import '../services/database.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/error_message.dart';

class EventsPage extends StatefulWidget {
  static const routeName = '/events';
  final bool isFinished;

  const EventsPage({Key key, @required this.isFinished}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  Future<List<Event>> events;

  @override
  void initState() {
    events = DatabaseService.getAllEvents(isFinished: widget.isFinished);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(
          title: 'Events',
        ),
      ),
      drawer: CustomDrawer(),
      body: SafeArea(
        child: FutureBuilder(
          future: events,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return ErrorMessage(
                message: snapshot.error,
              );
            } else if (snapshot.hasData) {
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
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
