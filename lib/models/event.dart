import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Event {
  final String id;
  final String title;
  final String url;
  final String description;
  final DateTime date;
  final DateTime register;
  final List participants;
  final List participantsEmail;
  final bool isFinished;

  Event({
    @required this.id,
    @required this.title,
    @required this.url,
    @required this.description,
    @required this.date,
    @required this.register,
    @required this.participants,
    @required this.participantsEmail,
    @required this.isFinished,
  });

  factory Event.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = snapshot.data();

    return Event(
      id: data['id'] as String,
      url: data['url'] as String,
      description: data['description'] as String,
      date: DateTime.parse(data['date'].toDate().toString()),
      register: DateTime.parse(data['register'].toDate().toString()),
      title: data['title'] as String,
      participants: data['participants'] as List,
      participantsEmail: data['participantsEmail'] as List,
      isFinished: data['isFinished'] as bool,
    );
  }

  static List<Event> fromQuerySnapshot(QuerySnapshot snapshot) {
    List<Event> events = snapshot.docs.map((doc) {
      return Event(
        id: doc['id'] as String,
        url: doc['url'] as String,
        description: doc['description'] as String,
        date: DateTime.parse(doc['date'].toDate().toString()),
        register: DateTime.parse(doc['register'].toDate().toString()),
        title: doc['title'] as String,
        participants: doc['participants'] as List,
        participantsEmail: doc['participantsEmail'] as List,
        isFinished: doc['isFinished'] as bool,
      );
    }).toList();

    events.sort((a, b) => b.date.compareTo(a.date));

    return events;
  }
}
