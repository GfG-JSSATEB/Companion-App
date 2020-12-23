import 'package:flutter/material.dart';

import '../models/event.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/error_message.dart';
import 'event_card.dart';

class EventList extends StatelessWidget {
  const EventList({
    Key key,
    @required this.events,
  }) : super(key: key);

  final Future<List<Event>> events;

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
