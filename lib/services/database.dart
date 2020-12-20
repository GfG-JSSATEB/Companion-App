import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:gfg_jssateb/models/announcement.dart';

import '../models/student.dart';

class DatabaseService {
  DatabaseService._();

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
    final QuerySnapshot snapshot =
        await _firestore.collection("announcements").get();
    for (final QueryDocumentSnapshot docSnapshot in snapshot.docs) {
      announcements.add(Announcement.fromDocumentSnapshot(docSnapshot));
    }
    return announcements;
  }
}
