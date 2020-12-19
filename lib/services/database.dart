import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
    });
  }
}
