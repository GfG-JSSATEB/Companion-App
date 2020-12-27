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

  static List<Announcement> announcemntListFromSnapshot(
    QuerySnapshot snapshot,
  ) {
    final DateFormat dateFormat = DateFormat('EE, d MMM');

    return snapshot.docs.map((doc) {
      final DateTime date =
          DateTime.parse(doc['timestamp'].toDate().toString());

      return Announcement(
        id: doc.id,
        title: doc['title'] as String,
        description: doc['description'] as String,
        date: dateFormat.format(date),
        relativeTime: timeago.format(date),
      );
    }).toList();
  }
}
