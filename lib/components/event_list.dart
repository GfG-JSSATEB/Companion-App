import 'package:flutter/material.dart';
import 'package:gfg_jssateb/models/event.dart';
import 'package:gfg_jssateb/widgets/custom_appbar.dart';
import 'package:gfg_jssateb/widgets/custom_drawer.dart';
import 'package:gfg_jssateb/widgets/error_message.dart';

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
