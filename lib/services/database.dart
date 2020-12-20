import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gfg_jssateb/models/event.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import '../models/announcement.dart';
import '../models/student.dart';

class DatabaseService {
  DatabaseService._();
  static Uuid uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addStudent({
    @required String email,
    @required String name,
    @required String usn,
    @required String college,
    @required String branch,
    @required String year,
    @required String id,
  }) async {
    _firestore.collection('students').doc(id).set({
      'id': id,
      'name': name,
      'email': email,
      'usn': usn,
      'college': college,
      'branch': branch,
      'year': year,
      'isAdmin': false,
      'participated': <String>[],
      'won': <String>[],
    });
  }

  static Future<Student> getStudent(String id) async {
    final DocumentSnapshot snapshot =
        await _firestore.collection('students').doc(id).get();
    return Student.fromDocumentSnapshot(snapshot);
  }

  static Future<List<Announcement>> getAnnouncements() async {
    final List<Announcement> announcements = [];
    final QuerySnapshot snapshot = await _firestore
        .collection("announcements")
        .orderBy('timestamp', descending: true)
        .get();
    for (final QueryDocumentSnapshot docSnapshot in snapshot.docs) {
      announcements.add(Announcement.fromDocumentSnapshot(docSnapshot));
    }
    return announcements;
  }

  static Future<void> addAnnouncement(
      {@required String title, @required String description}) async {
    final String id = uuid.v4();
    await _firestore.collection('announcements').doc(id).set({
      'id': id,
      'title': title,
      'description': description,
      'timestamp': Timestamp.now(),
    });
  }

  static Future<List<Event>> getEvents() async {
    final List<Event> events = [];
    final QuerySnapshot snapshot = await _firestore
        .collection("events")
        .where('isFinished', isEqualTo: false)
        .get();
    for (final QueryDocumentSnapshot docSnapshot in snapshot.docs) {
      events.add(Event.fromDocumentSnapshot(docSnapshot));
    }
    return events;
  }
}
