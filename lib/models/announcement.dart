import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Announcement {
  final String id;
  final String title;
  final String description;
  final String date;
  final String relativeTime;

  Announcement({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.relativeTime,
    @required this.date,
  });

  factory Announcement.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = snapshot.data();
    final DateFormat dateFormat = DateFormat('EE, d MMM');

    final DateTime date = DateTime.parse(data['timestamp'].toDate().toString());

    return Announcement(
      id: snapshot.id,
      title: data['title'] as String,
      description: data['description'] as String,
      date: dateFormat.format(date),
      relativeTime: timeago.format(date),
    );
  }
}
