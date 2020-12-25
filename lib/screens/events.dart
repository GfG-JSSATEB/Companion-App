import 'package:flutter/material.dart';
import 'package:gfg_jssateb/widgets/error_message.dart';

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
  bool error = false;
  String message = '';

  @override
  void initState() {
    try {
      events = DatabaseService.getAllEvents(isFinished: widget.isFinished);
    } catch (e) {
      setState(() {
        error = true;
        message = e.toString();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return error ? ErrorMessage(message: message) : EventList(events: events);
  }
}
