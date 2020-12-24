import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import '../models/announcement.dart';
import '../models/event.dart';
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

  static Future<void> updateStudentField(
      {@required String id,
      @required String value,
      @required String key}) async {
    await _firestore.collection('students').doc(id).update({
      key: value,
    });
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

  static Future<List<Event>> getAllEvents({@required bool isFinished}) async {
    final List<Event> events = [];
    final QuerySnapshot snapshot = await _firestore
        .collection("events")
        .where('isFinished', isEqualTo: isFinished)
        .get();
    for (final QueryDocumentSnapshot docSnapshot in snapshot.docs) {
      events.add(Event.fromDocumentSnapshot(docSnapshot));
    }

    events.sort((a, b) => b.date.compareTo(a.date));

    return events;
  }

  static Future<Event> getEvent({@required String id}) async {
    final DocumentSnapshot doc =
        await _firestore.collection('events').doc(id).get();
    return Event.fromDocumentSnapshot(doc);
  }

  static Future<List<Event>> getParticipatedEvents(
      {@required String uid}) async {
    final List<Event> events = [];
    final QuerySnapshot snapshot = await _firestore
        .collection("events")
        .where('participants', arrayContains: uid)
        .get();
    for (final QueryDocumentSnapshot docSnapshot in snapshot.docs) {
      events.add(Event.fromDocumentSnapshot(docSnapshot));
    }

    events.sort((a, b) => b.date.compareTo(a.date));

    return events;
  }

  static Future<void> registerToEvent(
      {@required String uid,
      @required String email,
      @required String eventId}) async {
    await _firestore.collection("events").doc(eventId).update({
      'participants': FieldValue.arrayUnion([uid]),
      'participantsEmail': FieldValue.arrayUnion([email]),
    });

    await _firestore.collection('students').doc(uid).update({
      'participated': FieldValue.arrayUnion([eventId])
    });
  }
}
