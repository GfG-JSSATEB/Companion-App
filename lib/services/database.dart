import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import '../models/announcement.dart';
import '../models/event.dart';
import '../models/student.dart';
import 'storage.dart';

class DatabaseService {
  DatabaseService._();
  static final Uuid _uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});

  static final CollectionReference _eventRef =
      FirebaseFirestore.instance.collection('events');

  static final CollectionReference _studentRef =
      FirebaseFirestore.instance.collection('students');

  static final CollectionReference _announcementRef =
      FirebaseFirestore.instance.collection('announcements');

  static Future<void> addStudent({
    @required String email,
    @required String name,
    @required String usn,
    @required String college,
    @required String branch,
    @required String year,
    @required String id,
  }) async {
    _studentRef.doc(id).set({
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
    final DocumentSnapshot snapshot = await _studentRef.doc(id).get();
    return Student.fromDocumentSnapshot(snapshot);
  }

  static Future<void> updateStudentField(
      {@required String id,
      @required String value,
      @required String key}) async {
    await _studentRef.doc(id).update({
      key: value,
    });
  }

  static Stream<List<Announcement>> get announcements {
    return _announcementRef
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(Announcement.announcemntListFromSnapshot);
  }

  static Future<void> addAnnouncement(
      {@required String title, @required String description}) async {
    final String id = _uuid.v4();
    await _announcementRef.doc(id).set({
      'id': id,
      'title': title,
      'description': description,
      'timestamp': Timestamp.now(),
    });
  }

  static Future<void> updateAnnouncement({
    @required String title,
    @required String description,
    @required String id,
  }) async {
    await _announcementRef.doc(id).update({
      'title': title,
      'description': description,
    });
  }

  static Future<void> deleteAnnouncement({@required String id}) async {
    await _announcementRef.doc(id).delete();
  }

  static Stream<List<Event>> getAllEvents({@required bool isFinished}) {
    return _eventRef
        .where('isFinished', isEqualTo: isFinished)
        .snapshots()
        .map(Event.fromQuerySnapshot);
  }

  static Stream<DocumentSnapshot> getEvent({@required String id}) {
    return _eventRef.doc(id).snapshots();
  }

  static Future<void> deleteEvent({@required String id}) async {
    return _eventRef.doc(id).delete();
  }

  static Stream<List<Event>> getParticipatedEvents({@required String uid}) {
    return _eventRef
        .where('participants', arrayContains: uid)
        .snapshots()
        .map(Event.fromQuerySnapshot);
  }

  static Future<void> registerToEvent(
      {@required String uid,
      @required String email,
      @required String eventId}) async {
    await _eventRef.doc(eventId).update({
      'participants': FieldValue.arrayUnion([uid]),
      'participantsEmail': FieldValue.arrayUnion([email]),
    });

    await _studentRef.doc(uid).update({
      'participated': FieldValue.arrayUnion([eventId])
    });
  }

  static Future<void> addEvent({
    @required String title,
    @required String description,
    @required File poster,
    @required DateTime date,
    @required DateTime register,
  }) async {
    final String id = _uuid.v4();

    final String url =
        await StorageService(id: title).uploadPoster(file: poster);

    await _eventRef.doc(id).set({
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'date': Timestamp.fromDate(date),
      'register': Timestamp.fromDate(register),
      'participants': <String>[],
      'participantsEmail': <String>[],
      'isFinished': false,
    });
  }

  static Future<void> updateEvent({
    @required String id,
    @required String title,
    @required String description,
    @required DateTime date,
    @required DateTime register,
  }) async {
    await _eventRef.doc(id).update({
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'register': Timestamp.fromDate(register),
    });
  }

  static Future<void> toggleEvent(
      {@required String id, @required bool isFinished}) async {
    await _eventRef.doc(id).update({
      'isFinished': isFinished,
    });
  }
}
