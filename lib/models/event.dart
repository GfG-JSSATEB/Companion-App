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

  Event({
    @required this.id,
    @required this.title,
    @required this.url,
    @required this.description,
    @required this.date,
    @required this.register,
    @required this.participants,
    @required this.participantsEmail,
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
    );
  }
}
