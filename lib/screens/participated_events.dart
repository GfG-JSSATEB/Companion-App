import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/event_list.dart';
import '../models/event.dart';
import '../services/database.dart';
import '../widgets/error_message.dart';

class ParticipatedEvents extends StatefulWidget {
  static const routeName = '/participatedEvent';

  @override
  _ParticipatedEventsState createState() => _ParticipatedEventsState();
}

class _ParticipatedEventsState extends State<ParticipatedEvents> {
  Future<List<Event>> events;
  final String uid = FirebaseAuth.instance.currentUser.uid;

  bool error = false;
  String message = '';

  @override
  void initState() {
    try {
      events = DatabaseService.getParticipatedEvents(uid: uid);
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
