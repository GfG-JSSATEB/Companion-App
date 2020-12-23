import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/event_list.dart';
import '../models/event.dart';
import '../services/database.dart';

class ParticipatedEvents extends StatefulWidget {
  static const routeName = '/participatedEvent';

  @override
  _ParticipatedEventsState createState() => _ParticipatedEventsState();
}

class _ParticipatedEventsState extends State<ParticipatedEvents> {
  Future<List<Event>> events;
  final String uid = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    events = DatabaseService.getParticipatedEvents(uid: uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EventList(events: events);
  }
}
