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

  static Stream<List<Announcement>> get announcements {
    return _firestore
        .collection("announcements")
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(Announcement.announcemntListFromSnapshot);
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

  static Stream<List<Event>> getAllEvents({@required bool isFinished}) {
    return _firestore
        .collection("events")
        .where('isFinished', isEqualTo: isFinished)
        .snapshots()
        .map(Event.fromQuerySnapshot);
  }

  static Future<Event> getEvent({@required String id}) async {
    final DocumentSnapshot doc =
        await _firestore.collection('events').doc(id).get();
    return Event.fromDocumentSnapshot(doc);
  }

  static Stream<List<Event>> getParticipatedEvents({@required String uid}) {
    return _firestore
        .collection("events")
        .where('participants', arrayContains: uid)
        .snapshots()
        .map(Event.fromQuerySnapshot);
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
