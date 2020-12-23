import 'package:flutter/material.dart';

import '../components/event_list.dart';
import '../models/event.dart';
import '../services/database.dart';

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
    return EventList(events: events);
  }
}
